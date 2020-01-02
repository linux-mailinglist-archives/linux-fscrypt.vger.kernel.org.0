Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AED12E3AD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jan 2020 09:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgABING (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Jan 2020 03:13:06 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:51616 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727714AbgABING (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Jan 2020 03:13:06 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 902062E29299B644E8A3;
        Thu,  2 Jan 2020 16:13:04 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.201) with Microsoft SMTP Server (TLS) id 14.3.439.0; Thu, 2 Jan 2020
 16:13:02 +0800
Subject: Re: [PATCH] f2fs: fix deadlock allocating bio_post_read_ctx from
 mempool
To:     Eric Biggers <ebiggers@kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
CC:     <linux-fscrypt@vger.kernel.org>
References: <20191231181416.47875-1-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <883839de-94e7-9c93-388b-9787e3fa76ba@huawei.com>
Date:   Thu, 2 Jan 2020 16:13:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20191231181416.47875-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/1/1 2:14, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Without any form of coordination, any case where multiple allocations
> from the same mempool are needed at a time to make forward progress can
> deadlock under memory pressure.
> 
> This is the case for struct bio_post_read_ctx, as one can be allocated
> to decrypt a Merkle tree page during fsverity_verify_bio(), which itself
> is running from a post-read callback for a data bio which has its own
> struct bio_post_read_ctx.
> 
> Fix this by freeing first bio_post_read_ctx before calling
> fsverity_verify_bio().  This works because verity (if enabled) is always
> the last post-read step.
> 
> This deadlock can be reproduced by trying to read from an encrypted
> verity file after reducing NUM_PREALLOC_POST_READ_CTXS to 1 and patching
> mempool_alloc() to pretend that pool->alloc() always fails.
> 
> Note that since NUM_PREALLOC_POST_READ_CTXS is actually 128, to actually
> hit this bug in practice would require reading from lots of encrypted
> verity files at the same time.  But it's theoretically possible, as N
> available objects doesn't guarantee forward progress when > N/2 threads
> each need 2 objects at a time.
> 
> Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Chao Yu <yuchao0@huawei.com>

Thanks,
