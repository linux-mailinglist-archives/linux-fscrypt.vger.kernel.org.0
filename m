Return-Path: <linux-fscrypt+bounces-841-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6AEB8E2F6
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Sep 2025 20:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC10E3BB81B
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Sep 2025 18:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DAB24BBE4;
	Sun, 21 Sep 2025 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ujmvQVVt"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFAA469D;
	Sun, 21 Sep 2025 18:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758478443; cv=none; b=RYhOsb+Zhk7qX/KrUReGOrTCszlpvQMqgv3NtAeKBXP/1LKKBPiLeUWldIHP9sQRvf6WhtJM8+G6Fuf/m2A6tJkr5r6JPJEeti+Un8zjWl5ObNXiCUSxMsX0t9Ji0L+MVKOoLRPzQwpeggUVTooIN3WhGMJF0tdZjCwMnLA1SwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758478443; c=relaxed/simple;
	bh=yMFELehJgZQJctgfQnuhpygZUPyILt389k0cTOfyln0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kmrMfhpOcmDCnFepc34mdAFqe3gUB1B/VqcfnIhvFoHs1gvMHZHgjZTKTtpouv/afjDqkkODY003Rm9TDk1SWZzFPkHG2CEfOZo7VDwmWiI2kKaCVuZFzMYH7l9XH82ze+fgBL583gqShMuZJvQTPNWkezA6sSAximm92ma97AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ujmvQVVt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78C2C4CEE7;
	Sun, 21 Sep 2025 18:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758478442;
	bh=yMFELehJgZQJctgfQnuhpygZUPyILt389k0cTOfyln0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ujmvQVVt4YMkllTjhNXKIN20zJGjHmZ/Xm+C/XNIT0v9tzgKQT9yf/GB6NmOmhlyI
	 EfGV5NpmOMasoeloDzb3NN97Q/RHzK1MpmmVm6xZqZzuHE+43B4aDgBVG4U7uObhhE
	 fqQEzZ0gBdN6RmqHmuiG461ngK8cNZn0jO8eTL9ZjZzNbHjhq0c5qFzXb489a9BbPu
	 EDFhuj1Pi+H9MnAtxWKZ7DxSpDL+pHyAun+8Q99IchH7Trpv3ZMXs4JnAUxyvp7seo
	 PofL1BhKhkKSMFUjCPKrSfQhHXGFxRYnA5wTS0BZZDqVYoFRaG7oUjC7/I8k9zRybh
	 rx5B3RhiZfnbg==
Date: Sun, 21 Sep 2025 11:12:47 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH] fscrypt: use HMAC-SHA512 library for HKDF
Message-ID: <20250921181247.GA22468@sol>
References: <20250906035913.1141532-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250906035913.1141532-1-ebiggers@kernel.org>

On Fri, Sep 05, 2025 at 08:59:13PM -0700, Eric Biggers wrote:
> For the HKDF-SHA512 key derivation needed by fscrypt, just use the
> HMAC-SHA512 library functions directly.  These functions were introduced
> in v6.17, and they provide simple and efficient direct support for
> HMAC-SHA512.  This ends up being quite a bit simpler and more efficient
> than using crypto/hkdf.c, as it avoids the generic crypto layer:
> 
> - The HMAC library can't fail, so callers don't need to handle errors
> - No inefficient indirect calls
> - No inefficient and error-prone dynamic allocations
> - No inefficient and error-prone loading of algorithm by name
> - Less stack usage
> 
> Benchmarks on x86_64 show that deriving a per-file key gets about 30%
> faster, and FS_IOC_ADD_ENCRYPTION_KEY gets nearly twice as fast.
> 
> The only small downside is the HKDF-Expand logic gets duplicated again.
> Then again, even considering that, the new fscrypt_hkdf_expand() is only
> 7 lines longer than the version that called hkdf_expand().  Later we
> could add HKDF support to lib/crypto/, but for now let's just do this.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting fscrypt/for-next

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric

