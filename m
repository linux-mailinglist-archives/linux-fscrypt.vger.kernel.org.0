Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0540612FB09
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 18:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbgACRBQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 12:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbgACRBQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 12:01:16 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74DB2206DB;
        Fri,  3 Jan 2020 17:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578070875;
        bh=HMuouXSipp7GyOORuZndvSxu7oJc36nPRlBYJnzTvfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0c6Riaif5UCXPFg0KmFe/6EcY83zl1CgNxWZ8G9Th6X6ej3StmUMFqe7YT76jAdF+
         CIgJI5O8guUL/J87QCnIeoZODInfIQmP1XJ2yd2xCr2ie5qx3g3ZeH35l31c6fQXxQ
         SbrnR6jcQ3akMOEV8pNdkAJPuJpI84QatL6I2wrw=
Date:   Fri, 3 Jan 2020 09:01:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] fscrypt: don't check for ENOKEY from
 fscrypt_get_encryption_info()
Message-ID: <20200103170113.GJ19521@gmail.com>
References: <20191209212348.243331-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209212348.243331-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 09, 2019 at 01:23:48PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt_get_encryption_info() returns 0 if the encryption key is
> unavailable; it never returns ENOKEY.  So remove checks for ENOKEY.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/ext4/dir.c  | 2 +-
>  fs/f2fs/dir.c  | 2 +-
>  fs/ubifs/dir.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 9fdd2b269d617..4c9d3ff394a5d 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -116,7 +116,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  
>  	if (IS_ENCRYPTED(inode)) {
>  		err = fscrypt_get_encryption_info(inode);
> -		if (err && err != -ENOKEY)
> +		if (err)
>  			return err;
>  	}
>  
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index c967cacf979ef..d9ad842945df5 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -987,7 +987,7 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
>  
>  	if (IS_ENCRYPTED(inode)) {
>  		err = fscrypt_get_encryption_info(inode);
> -		if (err && err != -ENOKEY)
> +		if (err)
>  			goto out;
>  
>  		err = fscrypt_fname_alloc_buffer(inode, F2FS_NAME_LEN, &fstr);
> diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> index 0b98e3c8b461d..acc4f942d25b6 100644
> --- a/fs/ubifs/dir.c
> +++ b/fs/ubifs/dir.c
> @@ -512,7 +512,7 @@ static int ubifs_readdir(struct file *file, struct dir_context *ctx)
>  
>  	if (encrypted) {
>  		err = fscrypt_get_encryption_info(dir);
> -		if (err && err != -ENOKEY)
> +		if (err)
>  			return err;
>  
>  		err = fscrypt_fname_alloc_buffer(dir, UBIFS_MAX_NLEN, &fstr);
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 

Applied to fscrypt.git#master for 5.6.

- Eric
