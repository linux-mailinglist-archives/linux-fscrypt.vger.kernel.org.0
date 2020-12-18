Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285DB2DE032
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 10:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732363AbgLRJDO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Dec 2020 04:03:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9630 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRJDM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Dec 2020 04:03:12 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cy2t637T1z15fk4;
        Fri, 18 Dec 2020 17:01:50 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 18 Dec
 2020 17:02:24 +0800
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
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <9a8d3ae2-a09f-f199-5cb1-48b1317b3d37@huawei.com>
Date:   Fri, 18 Dec 2020 17:02:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <X9t8y3rElyAPCLoD@google.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/12/17 23:44, Satya Tangirala wrote:
> On Sat, Oct 10, 2020 at 05:53:06PM +0800, Chao Yu wrote:
>> On 2020/10/5 15:36, Satya Tangirala wrote:
>>> This patch series adds support for metadata encryption to F2FS using
>>> blk-crypto.
>>
>> It looks this implementation is based on hardware crypto engine, could you
>> please add this info into f2fs.rst as well like inlinecrypt...
>>
> To be precise, the implementation requires either a hardware crypto
> engine *or* blk-crypto-fallback. I tried to clarify this a little better
> in the commit messages and in fscrypt.rst, but thinking about it again
> now, I think I should add a section about metadata encryption at the end
> of f2fs.rst. I'll do that when I send out v3 of this patch series (I
> just sent out v2).
>>>
>>> Patch 3 wires up F2FS with the functions introduced in Patch 2. F2FS
>>> will encrypt every block (that's not being encrypted by some other
>>> encryption key, e.g. a per-file key) with the metadata encryption key
>>> except the superblock (and the redundant copy of the superblock). The DUN
>>> of a block is the offset of the block from the start of the F2FS
>>> filesystem.
>>
>> Why not using nid as DUN, then GC could migrate encrypted node block directly via
>> meta inode's address space like we do for encrypted data block, rather than
>> decrypting node block to node page and then encrypting node page with DUN of new
>> blkaddr it migrates to.
>>
> The issue is, the bi_crypt_context in a bio holds a single DUN value,
> which is the DUN for the first data unit in the bio. blk-crypto assumes
> that the DUN of each subsequent data unit can be computed by simply
> incrementing the DUN. So physically contiguous data units can only be put
> into the same bio if they also have contiguous DUNs. I don't know much
> about nids, but if the nid is invariant w.r.t the physical block location,
> then there might be more fragmentation of bios in regular read/writes

Correct, considering performance of in batch node flush, it will be better to
use pba as IV value.

But, what's the plan about supporting software encryption for metadata? Current
f2fs write flow will handle all operations which may encounter failure before
allocating block address for node, if we do allocation first, and then use pba
as IV to encrypt node block, it will be a little complicated to revert allocation
if we fail to encrypt node block.

Thanks,

> (because physical contiguity may have no relation to DUN contiguity). So I
> think we should continue using the fsblk number as the DUN.
> .
> 
