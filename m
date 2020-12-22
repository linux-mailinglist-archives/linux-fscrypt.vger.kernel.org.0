Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A992E09D9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 12:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLVLsf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Dec 2020 06:48:35 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9235 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLVLsf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Dec 2020 06:48:35 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D0ZLn0qGZzktNS;
        Tue, 22 Dec 2020 19:46:57 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.212) with Microsoft SMTP Server (TLS) id 14.3.498.0; Tue, 22 Dec
 2020 19:47:46 +0800
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
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <c08aadef-47a7-f6fc-c2fa-11393ca938e8@huawei.com>
Date:   Tue, 22 Dec 2020 19:47:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X9yYVuuLt3/hL17J@google.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/12/18 19:53, Satya Tangirala wrote:
> On Fri, Dec 18, 2020 at 05:02:23PM +0800, Chao Yu wrote:
>> On 2020/12/17 23:44, Satya Tangirala wrote:
>>> On Sat, Oct 10, 2020 at 05:53:06PM +0800, Chao Yu wrote:
>>>> Why not using nid as DUN, then GC could migrate encrypted node block directly via
>>>> meta inode's address space like we do for encrypted data block, rather than
>>>> decrypting node block to node page and then encrypting node page with DUN of new
>>>> blkaddr it migrates to.
>>>>
>>> The issue is, the bi_crypt_context in a bio holds a single DUN value,
>>> which is the DUN for the first data unit in the bio. blk-crypto assumes
>>> that the DUN of each subsequent data unit can be computed by simply
>>> incrementing the DUN. So physically contiguous data units can only be put
>>> into the same bio if they also have contiguous DUNs. I don't know much
>>> about nids, but if the nid is invariant w.r.t the physical block location,
>>> then there might be more fragmentation of bios in regular read/writes
>>
>> Correct, considering performance of in batch node flush, it will be better to
>> use pba as IV value.
>>
>> But, what's the plan about supporting software encryption for metadata? Current
>> f2fs write flow will handle all operations which may encounter failure before
>> allocating block address for node, if we do allocation first, and then use pba
>> as IV to encrypt node block, it will be a little complicated to revert allocation
>> if we fail to encrypt node block.
>>
> Software encryption for metadata is supported through the blk-crypto

blk-crypto will encrypt all data in filesystem, if FBE is enabled, data may
be encrypted twice?

And why not supporting hardware encryption for metadata in blk-crypto? then
both f2fs and ext4 can use inline-encryption based blk-crypto?

Thanks,

> framework - so encryption will happen in the block layer, not the
> filesystem layer. So there's nothing extra/special we need to do if
> there's an encryption failure - an encryption failure is no different
> from a read/write failure in a lower layer from f2fs' perspective.
> .
> 
