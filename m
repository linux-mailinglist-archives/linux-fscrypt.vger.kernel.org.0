Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78C42ECB52
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 08:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbhAGH4I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 02:56:08 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:23466 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbhAGH4I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 02:56:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1610005995;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=KeYZOhheY0c+6YwZ/Ytl1iRm8ID+YfLlMyMcKez+UfA=;
        b=l5xUZ+JK8oIyy+KMdfjWHfEazaQAwGhpjZq3zAhn7o0OvAd6dQh2hmItMN59R6zeQV
        ZOgmg/HuP6BzanUkI58/EE66+Z6S6XthfpqielTkQhm8q6n6J2lzyiMnf2SZCDkI11JA
        z/bOAasrBznNcE1mUtTSd3ohdr9F2U2cY7YxqYcAgSXjPxT5/5HXRzgn7YfzmDenJKw4
        4o2kgzSshSNbH1yVUrdi5U/czXB+Mloy+zHOUCs/OAMwnNsmR/H0j41TSHz7buYjj2Bh
        Wmfp5HtY+VywBWlNYvaiKYJYMzYlvnlf4p88bx63BueVKVypR40NAmRgxWsWzcYYa4HA
        osww==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShPkMRYMkE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x077rFCYk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 7 Jan 2021 08:53:15 +0100 (CET)
Message-ID: <a5c50afa7e11329ea301e64bc03951b38f4e1eda.camel@chronox.de>
Subject: Re: [PATCH 3/5] crypto: add RFC5869 HKDF
From:   Stephan Mueller <smueller@chronox.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Date:   Thu, 07 Jan 2021 08:53:15 +0100
In-Reply-To: <X/a4qt9Oiw4WgoRY@sol.localdomain>
References: <4616980.31r3eYUQgx@positron.chronox.de>
         <12679948.uLZWGnKmhe@positron.chronox.de>
         <X/a4qt9Oiw4WgoRY@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Am Mittwoch, dem 06.01.2021 um 23:30 -0800 schrieb Eric Biggers:
> On Mon, Jan 04, 2021 at 10:49:13PM +0100, Stephan Müller wrote:
> > RFC5869 specifies an extract and expand two-step key derivation
> > function. The HKDF implementation is provided as a service function that
> > operates on a caller-provided HMAC cipher handle.
> 
> HMAC isn't a "cipher".
> 
> > The extract function is invoked via the crypto_hkdf_setkey call.
> 
> Any reason not to call this crypto_hkdf_extract(), to match the
> specification?

I named it to match the other KDF implementation. But you are right, I will
name it accordingly.

> 
> > RFC5869
> > allows two optional parameters to be provided to the extract operation:
> > the salt and additional information. Both are to be provided with the
> > seed parameter where the salt is the first entry of the seed parameter
> > and all subsequent entries are handled as additional information. If
> > the caller intends to invoke the HKDF without salt, it has to provide a
> > NULL/0 entry as first entry in seed.
> 
> Where does "additional information" for extract come from?  RFC 5869 has:
> 
>         HKDF-Extract(salt, IKM) -> PRK
> 
>         Inputs:
>               salt     optional salt value (a non-secret random value);
>                        if not provided, it is set to a string of HashLen
> zeros.
>               IKM      input keying material
> 
> There's no "additional information".

I used the terminology from SP800-108. I will update the description
accordingly. 
> 
> > 
> > The expand function is invoked via the crypto_hkdf_generate and can be
> > invoked multiple times. This function allows the caller to provide a
> > context for the key derivation operation. As specified in RFC5869, it is
> > optional. In case such context is not provided, the caller must provide
> > NULL / 0 for the info / info_nvec parameters.
> 
> Any reason not to call this crypto_hkdf_expand() to match the specification?

I will update the function name.

Thanks
Stephan
> 
> - Eric


