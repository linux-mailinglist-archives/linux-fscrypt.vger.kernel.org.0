Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D04412D76
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Sep 2021 05:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhIUDcO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 23:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhIUDSN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 23:18:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 898AE60F4B;
        Tue, 21 Sep 2021 03:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632194205;
        bh=DDriJoNdbLJ77B18uyA437VOfoL8wfE5BYESXgC+4i8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hIJOqgegNG15iGaoH+XgMtwbYgyRvI8wKwtgpyqVIItezy9oPAVSNVClST1dR2V2y
         obLXfpGK+lFh/3voBYEI6yxEhv4fG1Jrvm/3KJjWgb1O3CPSRSr7xvHVjgTq7Lg4Th
         qb8Vb3JJzZ1W2Ss9ssyPIMO6KjYUDGIc2P7arNGe6WSdNZMtF5GkDBKrru6xao2CHY
         ZQrsweJRMyDE6CGI3UOEVuwm614YdEs2UpRwQfUUucrltvW0LMdz7O+Cx7G90TFBmq
         xSGwypFgJuUtd1vK4FlTXaZtQ6CVBrcifu6o4jKiclQuITLKE+eOVyF0VLBinPJWZL
         qpM/0HAjEYRdQ==
Date:   Mon, 20 Sep 2021 20:16:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [RFC PATCH v2 4/5] fscrypt: allow 256-bit master keys with
 AES-256-XTS
Message-ID: <YUlOnG4bfj7beDah@sol.localdomain>
References: <20210916174928.65529-1-ebiggers@kernel.org>
 <20210916174928.65529-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916174928.65529-5-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 16, 2021 at 10:49:27AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt currently requires a 512-bit master key when AES-256-XTS is
> used, since AES-256-XTS keys are 512-bit and fscrypt requires that the
> master key be at least as long any key that will be derived from it.
> 
> However, this is overly strict because AES-256-XTS doesn't actually have
> a 512-bit security strength, but rather 256-bit.  The fact that XTS
> takes twice the expected key size is a quirk of the XTS mode.  It is
> sufficient to use 256 bits of entropy for AES-256-XTS, provided that it
> is first properly expanded into a 512-bit key, which HKDF-SHA512 does.
> 
> Therefore, relax the check of the master key size to use the security
> strength of the derived key rather than the size of the derived key
> (except for v1 encryption policies, which don't use HKDF).
> 
> Besides making things more flexible for userspace, this is needed in
> order for the use of a KDF which only takes a 256-bit key to be
> introduced into the fscrypt key hierarchy.  This will happen with
> hardware-wrapped keys support, as all known hardware which supports that
> feature uses an SP800-108 KDF using AES-256-CMAC, so the wrapped keys
> are wrapped 256-bit AES keys.  Moreover, there is interest in fscrypt
> supporting the same type of AES-256-CMAC based KDF in software as an
> alternative to HKDF-SHA512.  There is no security problem with such
> features, so fix the key length check to work properly with them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fscrypt_private.h |  5 ++--
>  fs/crypto/hkdf.c            | 11 +++++--
>  fs/crypto/keysetup.c        | 57 +++++++++++++++++++++++++++++--------
>  3 files changed, 56 insertions(+), 17 deletions(-)

I've applied this patch to fscrypt.git#master for 5.16, as it's a useful cleanup
which isn't dependent on the hardware-wrapped keys feature.  I also fixed this
patch to update the documentation, which I had overlooked in this case.

- Eric
