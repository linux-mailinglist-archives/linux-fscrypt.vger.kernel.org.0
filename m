Return-Path: <linux-fscrypt+bounces-137-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DD1E83EB70
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jan 2024 07:38:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49AC31C22934
	for <lists+linux-fscrypt@lfdr.de>; Sat, 27 Jan 2024 06:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3833613AF8;
	Sat, 27 Jan 2024 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lk6T48pI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFF7801;
	Sat, 27 Jan 2024 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706337477; cv=none; b=lIdrfZiA6pq/hBfh4R7aeG75pnvCtOVANffrdBgukmi8ZTUxp14CQEzlC3pQsitUZmMxDIuGNKJd/kcIxeF7hm0v3IoeuCp7nRLXeZmUmfFVd0Cj3bbK+8O53IISf7qMBi08sfh2Ai46l3E0737th7uH+9v8YgolRhR6zAAq5JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706337477; c=relaxed/simple;
	bh=eiun4me+83JhgNCDe4y9ORXCfAlPGIdgEeQXmo7Bor8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rn0qnARSeKpBH9PmyhQNLTxtloXSae7DhpUECHPgV8ahHathVpEEMX0swARXYyWcejfnCMvMt8by5QTCykBTWHUnylNydxbeV8g4AkuSm8keiWBVEGJ1zk30GftiBs3AYrUzDVZwp4JBh1oFrmJsJSNCTQhHoQlXxh3LidhdvRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lk6T48pI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1289AC433F1;
	Sat, 27 Jan 2024 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706337476;
	bh=eiun4me+83JhgNCDe4y9ORXCfAlPGIdgEeQXmo7Bor8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lk6T48pIofWov6dE1nAMdxwOCZRx/5CPJ2kUK7+BYj3Bf166s7nQOu/NX+lNl1am5
	 knxc/Uc15XNMmNX+3WwpDOeqybdbEasK0tw0toixzLq8LS9CgrIUKBEvf3hQbvmOYg
	 yakTAw5+8whCrlkaI0Wq7LLyBnSXaos3qGiT7d2E6NSv16g4SZavpxc4anc0ALNS+u
	 5z9s4G4HlzSOqDOKOhhOYlC0oiUU0NXf/EYYyr7om7E5BxNZqeKOw9IGRCf6r91OMu
	 YIiFrZ0NDMCGpIEAlTXGEzDJVf9UVBpGqAQhpVJGEdClcqB/Q9hQ9xWH/PZ4SsB4hG
	 3PVqtbe7kxpnQ==
Date: Fri, 26 Jan 2024 22:37:54 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: xiubli@redhat.com
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
	linux-kernel@vger.kernel.org, idryomov@gmail.com,
	ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com
Subject: Re: [PATCH] fscrypt: to make sure the inode->i_blkbits is correctly
 set
Message-ID: <20240127063754.GA11935@sol.localdomain>
References: <20240125044826.1294268-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240125044826.1294268-1-xiubli@redhat.com>

On Thu, Jan 25, 2024 at 12:48:25PM +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The inode->i_blkbits should be already set before calling
> fscrypt_get_encryption_info() and it will be used this to setup the
> ci_data_unit_bits.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/crypto/keysetup.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index d71f7c799e79..909187e52bae 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -702,6 +702,9 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
>  /**
>   * fscrypt_prepare_new_inode() - prepare to create a new inode in a directory
>   * @dir: a possibly-encrypted directory
>   * @inode: the new inode.  ->i_mode must be set already.
>   *         ->i_ino doesn't need to be set yet.

Maybe just change the above to "->i_mode and ->i_blkbits", instead of adding a
separate paragraph?

>   * @encrypt_ret: (output) set to %true if the new inode will be encrypted
>   *
>   * If the directory is encrypted, set up its ->i_crypt_info in preparation for
>   * encrypting the name of the new file.  Also, if the new inode will be
>   * encrypted, set up its ->i_crypt_info and set *encrypt_ret=true.
>   *
>   * This isn't %GFP_NOFS-safe, and therefore it should be called before starting
>   * any filesystem transaction to create the inode.  For this reason, ->i_ino
>   * isn't required to be set yet, as the filesystem may not have set it yet.
>   *
>   * This doesn't persist the new inode's encryption context.  That still needs to
>   * be done later by calling fscrypt_set_context().
>   *
> + * Please note that the inode->i_blkbits should be already set before calling
> + * this and later it will be used to setup the ci_data_unit_bits.
> + *
>   * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
>   *	   -errno code
>   */
> @@ -717,6 +720,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
>  	if (IS_ERR(policy))
>  		return PTR_ERR(policy);
>  
> +	if (WARN_ON_ONCE(inode->i_blkbits == 0))
> +		return -EINVAL;
> +

Thanks,

- Eric

