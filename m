Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8E312FAFF
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 17:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgACQ7H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 11:59:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgACQ7H (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 11:59:07 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D900A206DB;
        Fri,  3 Jan 2020 16:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578070747;
        bh=p72TZiAw/07LPkWfOYtzCa9bg2/ZkXAP1lj3Ql8HWCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAiCI/0HUAM2UwsWoQBgKTgxK40H4qoBIM733qN53Eqka1K9WI2tyqOEGXGoMrNmA
         eTL6rRcTRo/DjytRRFsds40kh/fRQvFxCHEfT+X6HWXGplKTEIfJkdrrPz4NTa7P3s
         KjET9/U6YAjG2SLcFN/KpVEDjiU7cb5FS2Isdux4=
Date:   Fri, 3 Jan 2020 08:59:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH v2] fscrypt: constify inode parameter to filename
 encryption functions
Message-ID: <20200103165905.GF19521@gmail.com>
References: <20191215213947.9521-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215213947.9521-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Dec 15, 2019 at 01:39:47PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Constify the struct inode parameter to fscrypt_fname_disk_to_usr() and
> the other filename encryption functions so that users don't have to pass
> in a non-const inode when they are dealing with a const one, as in [1].
> 
> [1] https://lkml.kernel.org/linux-ext4/20191203051049.44573-6-drosen@google.com/
> 
> Cc: Daniel Rosenberg <drosen@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: also update the !CONFIG_FS_ENCRYPTION version of
>     fscrypt_fname_disk_to_usr().
> 
>  fs/crypto/fname.c           | 20 ++++++++++----------
>  fs/crypto/fscrypt_private.h |  2 +-
>  include/linux/fscrypt.h     |  8 +++++---
>  3 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 3da3707c10e3..c87b71aa2353 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -34,12 +34,12 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
>   *
>   * Return: 0 on success, -errno on failure
>   */
> -int fname_encrypt(struct inode *inode, const struct qstr *iname,
> +int fname_encrypt(const struct inode *inode, const struct qstr *iname,
>  		  u8 *out, unsigned int olen)
>  {
>  	struct skcipher_request *req = NULL;
>  	DECLARE_CRYPTO_WAIT(wait);
> -	struct fscrypt_info *ci = inode->i_crypt_info;
> +	const struct fscrypt_info *ci = inode->i_crypt_info;
>  	struct crypto_skcipher *tfm = ci->ci_ctfm;
>  	union fscrypt_iv iv;
>  	struct scatterlist sg;
> @@ -85,14 +85,14 @@ int fname_encrypt(struct inode *inode, const struct qstr *iname,
>   *
>   * Return: 0 on success, -errno on failure
>   */
> -static int fname_decrypt(struct inode *inode,
> -				const struct fscrypt_str *iname,
> -				struct fscrypt_str *oname)
> +static int fname_decrypt(const struct inode *inode,
> +			 const struct fscrypt_str *iname,
> +			 struct fscrypt_str *oname)
>  {
>  	struct skcipher_request *req = NULL;
>  	DECLARE_CRYPTO_WAIT(wait);
>  	struct scatterlist src_sg, dst_sg;
> -	struct fscrypt_info *ci = inode->i_crypt_info;
> +	const struct fscrypt_info *ci = inode->i_crypt_info;
>  	struct crypto_skcipher *tfm = ci->ci_ctfm;
>  	union fscrypt_iv iv;
>  	int res;
> @@ -247,10 +247,10 @@ EXPORT_SYMBOL(fscrypt_fname_free_buffer);
>   *
>   * Return: 0 on success, -errno on failure
>   */
> -int fscrypt_fname_disk_to_usr(struct inode *inode,
> -			u32 hash, u32 minor_hash,
> -			const struct fscrypt_str *iname,
> -			struct fscrypt_str *oname)
> +int fscrypt_fname_disk_to_usr(const struct inode *inode,
> +			      u32 hash, u32 minor_hash,
> +			      const struct fscrypt_str *iname,
> +			      struct fscrypt_str *oname)
>  {
>  	const struct qstr qname = FSTR_TO_QSTR(iname);
>  	struct fscrypt_digested_name digested_name;
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 23cef4d3793a..5792ecbd4d24 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -260,7 +260,7 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
>  			 const struct fscrypt_info *ci);
>  
>  /* fname.c */
> -extern int fname_encrypt(struct inode *inode, const struct qstr *iname,
> +extern int fname_encrypt(const struct inode *inode, const struct qstr *iname,
>  			 u8 *out, unsigned int olen);
>  extern bool fscrypt_fname_encrypted_size(const struct inode *inode,
>  					 u32 orig_len, u32 max_len,
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index 1a7bffe78ed5..6eaa729544a3 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -153,8 +153,10 @@ static inline void fscrypt_free_filename(struct fscrypt_name *fname)
>  extern int fscrypt_fname_alloc_buffer(const struct inode *, u32,
>  				struct fscrypt_str *);
>  extern void fscrypt_fname_free_buffer(struct fscrypt_str *);
> -extern int fscrypt_fname_disk_to_usr(struct inode *, u32, u32,
> -			const struct fscrypt_str *, struct fscrypt_str *);
> +extern int fscrypt_fname_disk_to_usr(const struct inode *inode,
> +				     u32 hash, u32 minor_hash,
> +				     const struct fscrypt_str *iname,
> +				     struct fscrypt_str *oname);
>  
>  #define FSCRYPT_FNAME_MAX_UNDIGESTED_SIZE	32
>  
> @@ -438,7 +440,7 @@ static inline void fscrypt_fname_free_buffer(struct fscrypt_str *crypto_str)
>  	return;
>  }
>  
> -static inline int fscrypt_fname_disk_to_usr(struct inode *inode,
> +static inline int fscrypt_fname_disk_to_usr(const struct inode *inode,
>  					    u32 hash, u32 minor_hash,
>  					    const struct fscrypt_str *iname,
>  					    struct fscrypt_str *oname)
> -- 
> 2.24.1
> 

Applied to fscrypt.git#master for 5.6.

- Eric
