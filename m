Return-Path: <linux-fscrypt+bounces-685-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A39AF8724
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jul 2025 07:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D902546FE2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jul 2025 05:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71C1C1EF391;
	Fri,  4 Jul 2025 05:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEQoyJmg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A3E1E25ED;
	Fri,  4 Jul 2025 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751606125; cv=none; b=Zs+Nmy9bFr6MhaArw0JtVRXVJdV5q44Ht0n3ZkhR2Tb8UJJh0C0JgZWSOvLOBed3ZMQ9JKlz/V1N5V/3me4+fFADG5Jq/YaZaS0RrUclnuGvBpyVNEiYdXqdWxsDnrfcERMQlSAz1gB6H4x1ooQVeaaERG4vR99cGrbmHys4oSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751606125; c=relaxed/simple;
	bh=qdpZxGlVsjZhB+Tb2pPFqZR6qJzZ532AJ17NAKNRlMA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/mMyiVaPjMOJpil4hySLyGkXgEzsPQrfGlv4zz/Ili9AHd5lpUQ/0lDG6qkdS4zrjqkchPZBaeCJK5YffyrU8PuEm3W3mvK3g/0nkNHa3EWjI84RQ4j1kHAVb8RSyZJt12FNKx/YLn4zarlIyDzMszdj/NDlBD/0+7WjG5+OcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CEQoyJmg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CEEC4CEE3;
	Fri,  4 Jul 2025 05:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751606124;
	bh=qdpZxGlVsjZhB+Tb2pPFqZR6qJzZ532AJ17NAKNRlMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEQoyJmgtkkqKUwNx8RTQfhqU35Jrjz5w5axXUPgFSnoMBNdLu0FqSqAETG03FuvJ
	 InVP7iH6JOHjX8vvHG+vP/edytVEuYyNITNtfBWMe8Z9Ia0LucIay3Wh6vEKlxjTH/
	 ob+pnldPx1wMavx+tWEzIRXJg06roF9Q07bMKIdN5XQmq2klwROP6CmYhweb8Z7htY
	 CV+m+OYFMz1fYPYBJrG9sieGpv3W8pyex91kqyAYALsBjX60OdZMI7Cqi+1cQpRPcI
	 WZ12yMe6/543dEzmMt7l66RyIXlgA07mmDU1FrXMhniYQ/sff+owm1reyWqnFlnVfw
	 CeY4T6Y4KFrnQ==
Date: Thu, 3 Jul 2025 22:14:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, jaegeuk@kernel.org,
	linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2] fscrypt: improve filename encryption and decryption
 performance
Message-ID: <20250704051441.GA4199@sol>
References: <tencent_D06DEE8D71295798F385BCC52FACAE96A207@qq.com>
 <tencent_583C288FFF6BA70BAF0880FB7A5CCAB5EA05@qq.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_583C288FFF6BA70BAF0880FB7A5CCAB5EA05@qq.com>

On Fri, Jul 04, 2025 at 12:13:22PM +0800, Yuwen Chen wrote:
> With the CONFIG_UNICODE configuration enabled, the fname_decrypt
> and fscrypt_fname_encrypt functions may be called very frequently.
> Since filenames are generally short, the frequent invocation of
> memory allocation and release operations by these two functions
> will lead to very poor performance.
> 
> Use the following program to conduct a file-creation test in
> the private program directory(/data/media/0/Android/data/*)
> of Android.
> 
> int main(int argc, char **argv)
> {
>     size_t fcnt = 0;
>     char path[PATH_MAX];
>     char buf[4096] = {0};
>     int i, fd;
> 
>     if (argc < 2)
>         return - EINVAL;
> 
>     fcnt = atoi(argv[1]);
>     for (i = 0; i < fcnt; i++) {
>         snprintf(path, sizeof(path), "./%d", i);
>         fd = open(path, O_RDWR | O_CREAT, 0600);
>         if (fd < 0)
>             return - 1;
>         write(fd, buf, sizeof(buf));
>         close(fd);
>     }
>     return 0;
> }
> 
> The test platform is Snapdragon 8s Gen4, with a kernel version
> of v6.6 and a userdebug version.
> 
> Before this submission was merged, when creating 2000 files,
> the performance test results are as follows:
> $ time /data/file_creater 2000
> 0m14.83s real     0m00.00s user     0m14.30s system
> 0m15.61s real     0m00.00s user     0m15.04s system
> 0m14.72s real     0m00.01s user     0m14.18s system
> 
> After this submission was merged, the performance is as follows:
> $ time /data/file_creater 2000
> 0m07.64s real     0m00.00s user     0m07.37s system
> 0m07.66s real     0m00.00s user     0m07.40s system
> 0m08.67s real     0m00.01s user     0m08.35s system
> 
> Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
> ---
>  fs/crypto/fname.c         | 22 ++++++++++++++--------
>  include/crypto/skcipher.h |  9 +++++++++
>  2 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 010f9c0a4c2f1..168b2a88fa23b 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -92,14 +92,20 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
>  int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
>  			  u8 *out, unsigned int olen)
>  {
> -	struct skcipher_request *req = NULL;
>  	DECLARE_CRYPTO_WAIT(wait);
>  	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
>  	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
> +	SKCIPHER_REQUEST_ON_STACK(req, tfm, MAX_SKCIPHER_REQSIZE);
>  	union fscrypt_iv iv;
>  	struct scatterlist sg;
>  	int res;
>  
> +	/*
> +	 * When the size of the statically - allocated skcipher_request
> +	 * structure is insufficient, remind us to make modifications.
> +	 */
> +	BUG_ON(MAX_SKCIPHER_REQSIZE < crypto_skcipher_reqsize(tfm));
> +
>  	/*
>  	 * Copy the filename to the output buffer for encrypting in-place and
>  	 * pad it with the needed number of NUL bytes.
> @@ -124,7 +130,6 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
>  
>  	/* Do the encryption */
>  	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> -	skcipher_request_free(req);
>  	if (res < 0) {
>  		fscrypt_err(inode, "Filename encryption failed: %d", res);
>  		return res;

I'm guessing you have some debugging options enabled in your kconfig.  Usually
the allocations aren't quite *that* expensive.  That being said, it's always
been really annoying that they have to be there.

Unfortunately, as far as I know, you actually can't just allocate the
skcipher_request on the stack like that, since the legacy crypto API assumes
that the request memory is DMA-able.  On-stack requests also might not be
properly aligned (see
https://lore.kernel.org/all/CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com/
-- may be outdated, but I haven't heard otherwise).

The problem is really that the legacy crypto API (crypto_skcipher in this case)
was never really designed for efficient CPU-based crypto in the first place.
The correct solution is to add simple library APIs for the algorithms to
lib/crypto/, then update fscrypt to use that instead of crypto_skcipher.

I plan to do that, but I'm first focusing on other related things, such as doing
the same for fsverity.

- Eric

