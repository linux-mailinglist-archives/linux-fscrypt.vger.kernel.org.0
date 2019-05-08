Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B55016F6D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 05:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfEHDT6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 May 2019 23:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbfEHDT6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 May 2019 23:19:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D1A20850;
        Wed,  8 May 2019 03:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557285597;
        bh=FtRG6156KtZu1BolmdLDWFnW47KW80ODbaRpJ4mMguw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xb2KoPkGmqEvozbuzT/2B2KydTff65OLpueKhmesbdnO9Q3vqBN6IwZ1s8eXVVR/s
         kI+MDxrFWI3NTAK1b5T03iMVDjThToumXFfrcWMSQzPXIupPlLrgDc80aVa2CSQ1Cp
         Lalz9stoREKHFOq8BMhwYinRk8odJanADHCrzN74=
Date:   Tue, 7 May 2019 20:19:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] ubifs: Remove #ifdef around CONFIG_FS_ENCRYPTION
Message-ID: <20190508031954.GA26575@sol.localdomain>
References: <20190326075232.11717-1-s.hauer@pengutronix.de>
 <20190326075232.11717-2-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326075232.11717-2-s.hauer@pengutronix.de>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 26, 2019 at 08:52:31AM +0100, Sascha Hauer wrote:
> ifdefs reduce readablity and compile coverage. This removes the ifdefs
> around CONFIG_FS_ENCRYPTION by using IS_ENABLED and relying on static
> inline wrappers. A new static inline wrapper for setting sb->s_cop is
> introduced to allow filesystems to unconditionally compile in their
> s_cop operations.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  fs/ubifs/ioctl.c        | 11 +----------
>  fs/ubifs/sb.c           |  7 ++++---
>  fs/ubifs/super.c        |  4 +---
>  include/linux/fscrypt.h | 11 +++++++++++
>  4 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
> index 82e4e6a30b04..6b05b3ec500e 100644
> --- a/fs/ubifs/ioctl.c
> +++ b/fs/ubifs/ioctl.c
> @@ -193,7 +193,6 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		return err;
>  	}
>  	case FS_IOC_SET_ENCRYPTION_POLICY: {
> -#ifdef CONFIG_FS_ENCRYPTION
>  		struct ubifs_info *c = inode->i_sb->s_fs_info;
>  
>  		err = ubifs_enable_encryption(c);
> @@ -201,17 +200,9 @@ long ubifs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  			return err;
>  
>  		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> -#else
> -		return -EOPNOTSUPP;
> -#endif
>  	}
> -	case FS_IOC_GET_ENCRYPTION_POLICY: {
> -#ifdef CONFIG_FS_ENCRYPTION
> +	case FS_IOC_GET_ENCRYPTION_POLICY:
>  		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> -#else
> -		return -EOPNOTSUPP;
> -#endif
> -	}
>  
>  	default:
>  		return -ENOTTY;
> diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
> index 67fac1e8adfb..2afc8b1d4c3b 100644
> --- a/fs/ubifs/sb.c
> +++ b/fs/ubifs/sb.c
> @@ -748,14 +748,12 @@ int ubifs_read_superblock(struct ubifs_info *c)
>  		goto out;
>  	}
>  
> -#ifndef CONFIG_FS_ENCRYPTION
> -	if (c->encrypted) {
> +	if (!IS_ENABLED(CONFIG_UBIFS_FS_ENCRYPTION) && c->encrypted) {
>  		ubifs_err(c, "file system contains encrypted files but UBIFS"
>  			     " was built without crypto support.");
>  		err = -EINVAL;
>  		goto out;
>  	}

A bit late, but I noticed this in ubifs/linux-next.  This needs to use
CONFIG_FS_ENCRYPTION here, not CONFIG_UBIFS_FS_ENCRYPTION, as the latter no
longer exists.

> -#endif
>  
>  	/* Automatically increase file system size to the maximum size */
>  	c->old_leb_cnt = c->leb_cnt;
> @@ -943,6 +941,9 @@ int ubifs_enable_encryption(struct ubifs_info *c)
>  	int err;
>  	struct ubifs_sb_node *sup = c->sup_node;
>  
> +	if (!IS_ENABLED(CONFIG_UBIFS_FS_ENCRYPTION))
> +		return -EOPNOTSUPP;
> +

Same here.

- Eric
