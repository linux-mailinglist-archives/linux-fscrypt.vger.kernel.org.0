Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEA0276F21
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Sep 2020 12:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgIXK53 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Sep 2020 06:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgIXK53 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Sep 2020 06:57:29 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2A732395B;
        Thu, 24 Sep 2020 10:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600945048;
        bh=ReNUjh2+4CXtsorEynITi+cDn6rHbuOX6gukuZuCGXI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a6rOZfN2v4qDIA7c079QPI66GmKpOEsCWxnxKgw2RbhqSDA1HsVDqgYgAm0I+C+t4
         QNnLU9xw1Pv7zs5P67nh9IA66wgWrf1jFeumaRWvMFjUhs1FoXqRyIJGQlEtvvI++4
         iL1I7aGO4aWakAy/iDW73AvJWyQbHpKWwTAjGvF8=
Message-ID: <ca5f64b6fdfd8ff2dde489d7cc8590e63da7c306.camel@kernel.org>
Subject: Re: [PATCH] fscrypt: export fscrypt_d_revalidate()
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, Daniel Rosenberg <drosen@google.com>
Date:   Thu, 24 Sep 2020 06:57:26 -0400
In-Reply-To: <20200924054721.187797-1-ebiggers@kernel.org>
References: <20200924054721.187797-1-ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2020-09-23 at 22:47 -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Dentries that represent no-key names must have a dentry_operations that
> includes fscrypt_d_revalidate().  Currently, this is handled by
> fscrypt_prepare_lookup() installing fscrypt_d_ops.
> 
> However, ceph support for encryption
> (https://lore.kernel.org/r/20200914191707.380444-1-jlayton@kernel.org)
> can't use fscrypt_d_ops, since ceph already has its own
> dentry_operations.
> 
> Similarly, ext4 and f2fs support for directories that are both encrypted
> and casefolded
> (https://lore.kernel.org/r/20200923010151.69506-1-drosen@google.com)
> can't use fscrypt_d_ops either, since casefolding requires some dentry
> operations too.
> 
> To satisfy both users, we need to move the responsibility of installing
> the dentry_operations to filesystems.
> 
> In preparation for this, export fscrypt_d_revalidate() and give it a
> !CONFIG_FS_ENCRYPTION stub.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Compared to the versions of this patch from Jeff and Daniel, I've
> improved the commit message and added a !CONFIG_FS_ENCRYPTION stub,
> which was missing.  I'm planning to apply this for 5.10 in preparation
> for both the ceph patchset and the encrypt+casefold patchset.
> 
> 
>  fs/crypto/fname.c       | 3 ++-
>  include/linux/fscrypt.h | 7 +++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index c65979452844..1fbe6c24d705 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -530,7 +530,7 @@ EXPORT_SYMBOL_GPL(fscrypt_fname_siphash);
>   * Validate dentries in encrypted directories to make sure we aren't potentially
>   * caching stale dentries after a key has been added.
>   */
> -static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
> +int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
>  {
>  	struct dentry *dir;
>  	int err;
> @@ -569,6 +569,7 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
>  
>  	return valid;
>  }
> +EXPORT_SYMBOL_GPL(fscrypt_d_revalidate);
>  
>  const struct dentry_operations fscrypt_d_ops = {
>  	.d_revalidate = fscrypt_d_revalidate,
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index f1757e73162d..a8f7a43f031b 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -197,6 +197,7 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
>  bool fscrypt_match_name(const struct fscrypt_name *fname,
>  			const u8 *de_name, u32 de_name_len);
>  u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
> +int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags);
>  
>  /* bio.c */
>  void fscrypt_decrypt_bio(struct bio *bio);
> @@ -454,6 +455,12 @@ static inline u64 fscrypt_fname_siphash(const struct inode *dir,
>  	return 0;
>  }
>  
> +static inline int fscrypt_d_revalidate(struct dentry *dentry,
> +				       unsigned int flags)
> +{
> +	return 1;
> +}
> +
>  /* bio.c */
>  static inline void fscrypt_decrypt_bio(struct bio *bio)
>  {

Reviewed-by: Jeff Layton <jlayton@kernel.org>

