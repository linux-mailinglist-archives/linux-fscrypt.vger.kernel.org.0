Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6562ECAF9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAGHbe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:55600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbhAGHbd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:31:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2391D2311A;
        Thu,  7 Jan 2021 07:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610004652;
        bh=+nXGNxH2Zt0Faa3QOoPaLUx5njlSeX/AHRJiAlLZcJ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pp9Q08Y7tYbL2bEI7YSXEaDWoLtI22t+r7/d8VgzxWzlhCxZxvwe6/PYeOjtcXb39
         tdSPUawxYbdv/jBy4U8DSdNnOkqlptS+8O4/2VAUn9GAcItZOU/BdWDaR3A+cPI6f8
         TxzhKVr9FruyeVgZrz2CNy+KFh36/FLNEsmRPH2tIM8Qjv9J/mM1nBQKgDq2GvQALm
         ex2s6aKA1L8zy5t+OHlb8Qk/Jm1lWxEdytyD9Z5TrEmz5XEAQjqT+FZngYnuZl2I07
         QgioHu+0S8xCmnnCE+Zgry5+Ez0ewlcth4voweLKAtywK9MhVaMz6CctY3YaNpPyEg
         o2Fo+FY2mt6+g==
Date:   Wed, 6 Jan 2021 23:30:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 3/5] crypto: add RFC5869 HKDF
Message-ID: <X/a4qt9Oiw4WgoRY@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <12679948.uLZWGnKmhe@positron.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12679948.uLZWGnKmhe@positron.chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 04, 2021 at 10:49:13PM +0100, Stephan Müller wrote:
> RFC5869 specifies an extract and expand two-step key derivation
> function. The HKDF implementation is provided as a service function that
> operates on a caller-provided HMAC cipher handle.

HMAC isn't a "cipher".

> The extract function is invoked via the crypto_hkdf_setkey call.

Any reason not to call this crypto_hkdf_extract(), to match the specification?

> RFC5869
> allows two optional parameters to be provided to the extract operation:
> the salt and additional information. Both are to be provided with the
> seed parameter where the salt is the first entry of the seed parameter
> and all subsequent entries are handled as additional information. If
> the caller intends to invoke the HKDF without salt, it has to provide a
> NULL/0 entry as first entry in seed.

Where does "additional information" for extract come from?  RFC 5869 has:

	HKDF-Extract(salt, IKM) -> PRK

	Inputs:
	      salt     optional salt value (a non-secret random value);
		       if not provided, it is set to a string of HashLen zeros.
	      IKM      input keying material

There's no "additional information".

> 
> The expand function is invoked via the crypto_hkdf_generate and can be
> invoked multiple times. This function allows the caller to provide a
> context for the key derivation operation. As specified in RFC5869, it is
> optional. In case such context is not provided, the caller must provide
> NULL / 0 for the info / info_nvec parameters.

Any reason not to call this crypto_hkdf_expand() to match the specification?

- Eric
