Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D0D367B70
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Apr 2021 09:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhDVHtV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Apr 2021 03:49:21 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48832 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhDVHtV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Apr 2021 03:49:21 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lZU4q-0003AT-KW; Thu, 22 Apr 2021 17:48:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 Apr 2021 17:48:44 +1000
Date:   Thu, 22 Apr 2021 17:48:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ardb@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        ebiggers@kernel.org
Subject: Re: [PATCH v2 0/2] relax crypto Kconfig dependencies for
 fsverity/fscrypt
Message-ID: <20210422074844.GA14609@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421075511.45321-1-ardb@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> wrote:
> Relax 'select' dependencies to 'imply' for crypto algorithms that are
> fulfilled only at runtime, and which may be implemented by other drivers
> than the generic ones implemented in C. This permits, e.g., arm64 builds
> to omit the generic CRYPTO_SHA256 and CRYPTO_AES drivers, both of which
> are superseded by optimized scalar versions at the very least,
> 
> Changes since v1:
> - use Eric's suggested comment text in patch #1
> - add Eric's ack to partch #2
> 
> Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Eric Biggers <ebiggers@kernel.org>
> 
> Ard Biesheuvel (2):
>  fscrypt: relax Kconfig dependencies for crypto API algorithms
>  fsverity: relax build time dependency on CRYPTO_SHA256
> 
> fs/crypto/Kconfig | 30 ++++++++++++++------
> fs/verity/Kconfig |  8 ++++--
> 2 files changed, 28 insertions(+), 10 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
