Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C955804AA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 Jul 2022 21:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiGYTtJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jul 2022 15:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiGYTtI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jul 2022 15:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79564205D8;
        Mon, 25 Jul 2022 12:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BF5F6104F;
        Mon, 25 Jul 2022 19:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30511C341C6;
        Mon, 25 Jul 2022 19:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658778546;
        bh=id+EBJFdduylyxAYQwz7tH1Mr9qeU6vgbiFk3borljM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POov4GUS960gl9ukMVWPN35q3+0dIk9k4liye8IG9fFN3RANvHFCk6W7ByQjiWDnH
         0rkkhp3uZDWro74UyM1K1ms7uyt/mAPyKzTWTYGcHyUhq2KR1YIvxymCvgJlM9Xr9i
         15vK22yqOlvubP5bMTTQlXuG42mMIau8c6SqwcPtzs29kdUyAQhQfVBc0LTo+wonOw
         Ky5iecqdoERaUttF7xixJfj0rbg2AXHqlBbViPrVOGGLwkn/J3k3yLp1xLUMzn3gNC
         gt48nGF2dLNKKHnJ8cU3vvMAb0ymSAvrPDCSH5/O1RHfR9vjLu+MBuDI4+XWH8SUR+
         NAjyxiofMSRfg==
Date:   Mon, 25 Jul 2022 12:49:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Subject: Re: [PATCH RFC 2/4] fscrypt: add flag allowing partially-encrypted
 directories
Message-ID: <Yt7zsMGrxwKiM+GH@sol.localdomain>
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <0508dac7fd6ec817007c5e21a565d1bb9d4f4921.1658623235.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0508dac7fd6ec817007c5e21a565d1bb9d4f4921.1658623235.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 23, 2022 at 08:52:26PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Creating several new subvolumes out of snapshots of another subvolume,
> each for a different VM's storage, is a important usecase for btrfs.  We
> would like to give each VM a unique encryption key to use for new writes
> to its subvolume, so that secure deletion of the VM's data is as simple
> as securely deleting the key; to avoid needing multiple keys in each VM,
> we envision the initial subvolume being unencrypted. However, this means
> that the snapshot's directories would have a mix of encrypted and
> unencrypted files.
> 
> To allow this, add another FS_CFLG to allow filesystems to opt into
> partially encrypted directories.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fname.c       | 17 ++++++++++++++++-
>  include/linux/fscrypt.h |  2 ++
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 5d5c26d827fd..c5dd19c1d19e 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -389,6 +389,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>  	fname->usr_fname = iname;
>  
>  	if (!IS_ENCRYPTED(dir) || fscrypt_is_dot_dotdot(iname)) {
> +unencrypted:
>  		fname->disk_name.name = (unsigned char *)iname->name;
>  		fname->disk_name.len = iname->len;
>  		return 0;
> @@ -424,8 +425,16 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>  	 * user-supplied name
>  	 */
>  
> -	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED)
> +	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED) {
> +		/*
> +		 * This isn't a valid nokey name, but it could be an unencrypted
> +		 * name if the filesystem allows partially encrypted
> +		 * directories.
> +		 */
> +		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL)
> +			goto unencrypted;
>  		return -ENOENT;
> +	}
>  
>  	fname->crypto_buf.name = kmalloc(FSCRYPT_NOKEY_NAME_MAX, GFP_KERNEL);
>  	if (fname->crypto_buf.name == NULL)
> @@ -436,6 +445,12 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>  	if (ret < (int)offsetof(struct fscrypt_nokey_name, bytes[1]) ||
>  	    (ret > offsetof(struct fscrypt_nokey_name, sha256) &&
>  	     ret != FSCRYPT_NOKEY_NAME_MAX)) {
> +		/* Again, this could be an unencrypted name. */
> +		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL) {
> +			kfree(fname->crypto_buf.name);
> +			fname->crypto_buf.name = NULL;
> +			goto unencrypted;
> +		}
>  		ret = -ENOENT;
>  		goto errout;
>  	}
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 6020b738c3b2..fb48961c46f6 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -102,6 +102,8 @@ struct fscrypt_nokey_name {
>   * pages for writes and therefore won't need the fscrypt bounce page pool.
>   */
>  #define FS_CFLG_OWN_PAGES (1U << 1)
> +/* The filesystem allows partially encrypted directories/files. */
> +#define FS_CFLG_ALLOW_PARTIAL (1U << 2)

I'm very confused about what the semantics of this are.  So a directory will be
able to contain both encrypted and unencrypted filenames?  If so, how will it be
possible to distinguish between them?  Or is it just both encrypted and
unencrypted files (which is actually already possible, in the case where
encrypted files are moved into an unencrypted directory)?  What sort of metadata
is stored with the parent directory?

Please note that any new semantics and APIs will need to be documented in
Documentation/filesystems/fscrypt.rst.

- Eric
