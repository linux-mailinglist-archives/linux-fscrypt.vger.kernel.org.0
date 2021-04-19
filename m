Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03257364D7A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Apr 2021 00:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhDSWF5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Apr 2021 18:05:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhDSWF4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Apr 2021 18:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD7C1613B4;
        Mon, 19 Apr 2021 22:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618869926;
        bh=7qxXUL+60tZO/lod/ToaBQJmBTycv2Zd4iAqoJm/Ieg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCRAHbLOOD0Uqg3frJEbdBxsnOsucQlbyCtdknPJzv8auys3C34tIJ03gsnqkk2tu
         ZRmBJC5hgPR2vg8qyavmr8Ip5J8tfWDEvZHfLb8DD5GwSxXGZ6hvlSAr8mwQGatzKN
         O/TvmOk1vH2yrcxh4ouYGWyJYx5BmzPfHTHBE0TQj6toMXuZ/bnsW08amHPEQB4PNm
         yuo3iVSY3eVvrQ5dednFEeDWhs3r6klXjX98PrqmiRMv8XFpG/MaOq+pKSc/RR4AMH
         HRJewi7AnY/lwIRkCYcqGLFD+/CbBFI/1E5fmcmZCImRzEneX31zGPUPumFwVJv0aL
         EamfyDkYv/9yw==
Date:   Mon, 19 Apr 2021 15:05:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 2/2] fsverity: relax build time dependency on
 CRYPTO_SHA256
Message-ID: <YH3+pEyzcON8eEKJ@gmail.com>
References: <20210416160642.85387-1-ardb@kernel.org>
 <20210416160642.85387-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416160642.85387-3-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 16, 2021 at 06:06:42PM +0200, Ard Biesheuvel wrote:
> CONFIG_CRYPTO_SHA256 denotes the generic C implementation of the SHA-256
> shash algorithm, which is selected as the default crypto shash provider
> for fsverity. However, fsverity has no strict link time dependency, and
> the same shash could be exposed by an optimized implementation, and arm64
> has a number of those (scalar, NEON-based and one based on special crypto
> instructions). In such cases, it makes little sense to require that the
> generic C implementation is incorporated as well, given that it will never
> be called.
> 
> To address this, relax the 'select' clause to 'imply' so that the generic
> driver can be omitted from the build if desired.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  fs/verity/Kconfig | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
> index 88fb25119899..24d1b54de807 100644
> --- a/fs/verity/Kconfig
> +++ b/fs/verity/Kconfig
> @@ -3,9 +3,13 @@
>  config FS_VERITY
>  	bool "FS Verity (read-only file-based authenticity protection)"
>  	select CRYPTO
> -	# SHA-256 is selected as it's intended to be the default hash algorithm.
> +	# SHA-256 is implied as it's intended to be the default hash algorithm.
>  	# To avoid bloat, other wanted algorithms must be selected explicitly.
> -	select CRYPTO_SHA256
> +	# Note that CRYPTO_SHA256 denotes the generic C implementation, but
> +	# some architectures provided optimized implementations of the same
> +	# algorithm that may be used instead. In this case, CRYPTO_SHA256 may
> +	# be omitted even if SHA-256 is being used.
> +	imply CRYPTO_SHA256
>  	help
>  	  This option enables fs-verity.  fs-verity is the dm-verity
>  	  mechanism implemented at the file level.  On supported

Looks fine,

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric
