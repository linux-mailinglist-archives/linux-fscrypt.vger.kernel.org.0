Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C4989E3A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 14:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfHLMZj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 08:25:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4661 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728389AbfHLMZi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 08:25:38 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 270DCE2238499EAB75AB;
        Mon, 12 Aug 2019 20:25:37 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.211) with Microsoft SMTP Server (TLS) id 14.3.439.0; Mon, 12 Aug
 2019 20:25:32 +0800
Subject: Re: [PATCH 3/6] f2fs: skip truncate when verity in progress in
 ->write_begin()
To:     Eric Biggers <ebiggers@kernel.org>, <linux-fscrypt@vger.kernel.org>
CC:     <linux-ext4@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
References: <20190811213557.1970-1-ebiggers@kernel.org>
 <20190811213557.1970-4-ebiggers@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <e5d57ee4-f022-12ca-7f09-e4b8ef86c6b6@huawei.com>
Date:   Mon, 12 Aug 2019 20:25:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190811213557.1970-4-ebiggers@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 2019/8/12 5:35, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When an error (e.g. ENOSPC) occurs during f2fs_write_begin() when called
> from f2fs_write_merkle_tree_block(), skip truncating the file.  i_size
> is not meaningful in this case, and the truncation is handled by
> f2fs_end_enable_verity() instead.
> 
> Fixes: 60d7bf0f790f ("f2fs: add fs-verity support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/f2fs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 3f525f8a3a5fa..00b03fb87bd9b 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2476,7 +2476,7 @@ static void f2fs_write_failed(struct address_space *mapping, loff_t to)
>  	struct inode *inode = mapping->host;
>  	loff_t i_size = i_size_read(inode);
>  
> -	if (to > i_size) {

Maybe adding one single line comment to mention that it's redundant/unnecessary
truncation here is better, if I didn't misunderstand this.

Thanks,

> +	if (to > i_size && !f2fs_verity_in_progress(inode)) {
>  		down_write(&F2FS_I(inode)->i_gc_rwsem[WRITE]);
>  		down_write(&F2FS_I(inode)->i_mmap_sem);
>  
> 
