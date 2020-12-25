Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D55E2E2AA1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Dec 2020 10:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgLYJch (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Dec 2020 04:32:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9994 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728794AbgLYJcg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Dec 2020 04:32:36 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D2MBg63P0zhxyy;
        Fri, 25 Dec 2020 17:31:07 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 25 Dec
 2020 17:31:50 +0800
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
To:     Satya Tangirala <satyat@google.com>
CC:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
References: <20201005073606.1949772-1-satyat@google.com>
 <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
 <X9t8y3rElyAPCLoD@google.com>
 <9a8d3ae2-a09f-f199-5cb1-48b1317b3d37@huawei.com>
 <X9yYVuuLt3/hL17J@google.com>
 <c08aadef-47a7-f6fc-c2fa-11393ca938e8@huawei.com>
 <X+Rp579fp5sMDvSP@google.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <8a0246cf-0548-7c36-b4af-08219fad365d@huawei.com>
Date:   Fri, 25 Dec 2020 17:31:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X+Rp579fp5sMDvSP@google.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/12/24 18:13, Satya Tangirala wrote:
> On Tue, Dec 22, 2020 at 07:47:45PM +0800, Chao Yu wrote:
>> On 2020/12/18 19:53, Satya Tangirala wrote:
>>> On Fri, Dec 18, 2020 at 05:02:23PM +0800, Chao Yu wrote:
>>>> But, what's the plan about supporting software encryption for metadata? Current
>>>> f2fs write flow will handle all operations which may encounter failure before
>>>> allocating block address for node, if we do allocation first, and then use pba
>>>> as IV to encrypt node block, it will be a little complicated to revert allocation
>>>> if we fail to encrypt node block.
>>>>
>>> Software encryption for metadata is supported through the blk-crypto
>>
>> blk-crypto will encrypt all data in filesystem, if FBE is enabled, data may
>> be encrypted twice?
> blk-crypto will only encrypt bios as directed to do so by the encryption
> context set on the bio. That encryption context is constructed by the
> submitter of the bio - in our case, the submitter is the filesystem.
> So the filesystem decides which bio gets encrypted with
> which key/algorithm/etc (and in the current implementation, each bio
> only supports a single bi_crypt_context, so *only one* layer of
> encryption is possible with blk-crypto anyway). So no, data won't be
> encrypted twice, because F2FS/fscrypt ensure that it does not (and the
> filesystem knows exactly which blocks need metadata encryption, and
> which blocks need FBE).

Oh, sorry, I misunderstand blk-crypto as dm-crypt...

So once hardware encryption is absent, blk-crypto will use blk-crypto-fallback
to encrypt bio data with software crypto, I see.

>>
>> And why not supporting hardware encryption for metadata in blk-crypto? then
>> both f2fs and ext4 can use inline-encryption based blk-crypto?
>>
> I may be misunderstanding what you're asking, but I think you're asking
> why not make blk-crypto do metadata encryption (without explicit
> involvement from filesystems)? Or more generally, why not do metadata
> encryption below the filesystem layer?

Yes.

> 
> As mentioned above, the filesystem is what knows which blocks need to be
> metadata encrypted and which blocks need to be FBE encrypted (or even
> just read without any encryption at all) - the block layer doesn't have
> this information, and so can't effectively decide which blocks to use
> the metadata encryption key on. Fwiw, Android does take a somewhat
> similar approach to what you're suggesting here (I explain more in
> detail in the cover letter for v2 of this patch series at
> https://lore.kernel.org/linux-fscrypt/20201217150435.1505269-1-satyat@google.com/

Ah, thanks for all your detailed explanation, now, I can see the
context.

> ). In Android, we have a new DM target (called dm-default-key) that adds
> an encryption context to any bio that doesn't already have an encryption
> context - so the assumption in general is that if the filesystem wants to
> use an FBE key, it would have already set the encryption context on the
> bio, so if a bio reaches dm-default-key without an encryption context,
> it must mean that it needs metadata encryption. However, that assumption
> doesn't always hold because F2FS sometimes needs to read the ciphertext
> of FBE files without having the file's FBE key available - in those
> situations, F2FS will send a bio without any encryption context, but
> will also tell dm-default-key to *not* add the metadata encryption
> context. That's a layering violation, which is why I'm not using that
> approach here.
> 
> Does that answer your question? Or am I misunderstanding what you're
> asking?

Yup, thank you!

Thanks,

>> Thanks,
>>
>>> framework - so encryption will happen in the block layer, not the
>>> filesystem layer. So there's nothing extra/special we need to do if
>>> there's an encryption failure - an encryption failure is no different
>>> from a read/write failure in a lower layer from f2fs' perspective.
>>> .
>>>
> .
> 
