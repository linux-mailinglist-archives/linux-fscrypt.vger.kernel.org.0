Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839EC409B98
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242962AbhIMSBE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239852AbhIMSBE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:01:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D08760F3A;
        Mon, 13 Sep 2021 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631555988;
        bh=pxSLrfQALbitgdYScNCysW/1moAPeQGUi9Q+vRF+62Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m0kD1UaKObb+YJUUgmKPb0L4hACQlTfoMXJPUNGqu7D6wseUreydvWKnkYUI9n+V+
         WQpWw5caFHnYZo7my6UkcVfQGjYUfjNuVITcrrBShC1w68+F8bdWKdAG219nZD913N
         9vl9/41TkMFCyJxb4MCfUt9PPT0Y1nEHQx62mDRRaGb3oqeIWEtujMCYRLB/HXp0Gd
         RPXuNGB//sDyPdRMvACLJkJi0SR2AXovEhscUSNWJ0iD9QbV9FEwki7vg+OFicogZ9
         CLCHCFUEufN6zJuZRDSCP7+PCAZXCMNKXFA9KzpfoHl7QQkmIKqk8ZlB/6NBAt1esh
         douanigTJch+g==
Date:   Mon, 13 Sep 2021 10:59:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v5] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Message-ID: <YT+RktgS+WUXvq2t@sol.localdomain>
References: <20210909212731.1151190-1-olo@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909212731.1151190-1-olo@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 09, 2021 at 02:27:31PM -0700, Aleksander Adamowski wrote:
> PKCS#11 API allows us to use opaque keys confined in hardware security
> modules (HSMs) and similar hardware tokens without direct access to the
> key material, providing logical separation of the keys from the
> cryptographic operations performed using them.
> 
> This commit allows using the popular libp11 pkcs11 module for the
> OpenSSL library with `fsverity` so that direct access to a private key
> file isn't necessary to sign files.
> 
> The user needs to supply the path to the engine shared library
> (typically the libp11 shared object file) and the PKCS#11 module library
> (a shared object file specific to the given hardware token).  The user
> may also supply a token-specific key identifier.
> 
> Test evidence with a hardware PKCS#11 token:
> 
>   $ echo test > dummy
>   $ ./fsverity sign dummy dummy.sig \
>     --pkcs11-engine=/usr/lib64/engines-1.1/libpkcs11.so \
>     --pkcs11-module=/usr/local/lib64/pkcs11_module.so \
>     --cert=test-pkcs11-cert.pem && echo OK;
>   Signed file 'dummy'
>   (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
>   OK
> 
> Test evidence for regression check (checking that regular file-based key
> signing still works):
> 
>   $ ./fsverity sign dummy dummy.sig --key=key.pem --cert=cert.pem && \
>     echo  OK;
>   Signed file 'dummy'
>   (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
>   OK
> 
> Signed-off-by: Aleksander Adamowski <olo@fb.com>
> [EB: Avoided overloading the --key option and keyfile field, clarified
>  the documentation, removed logic from cmd_sign.c that libfsverity
>  already handles, and many other improvements.]
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Applied, thanks.

- Eric
