Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7D32ED700
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Jan 2021 19:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729158AbhAGSy0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Jan 2021 13:54:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727215AbhAGSy0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Jan 2021 13:54:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 027AA23428;
        Thu,  7 Jan 2021 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610045626;
        bh=4NuZzLXjOFpgEN2Yzoo6R/ZAluYF2iO7Vq7NOU6blWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AUOnbVERVw0fnIdBRyEeLh8o05/CE+wzls6yEWLvcTdqThOngaSEo37qcbAJaMcTa
         su+PgsAQV5/fazGrQyMDqzt1U1KnSkHfqEIQxeYbyp4gnH/uQ6Y6SVM9iyD51N4Zc6
         DlsGN9u2CyHubPSP9MkVivLLCLyv9p81jbZjFhal17I/4OBr1Bf0KOqwrg+8/EGwb3
         mY8ES8PayNfYnVgiVnS6SykEesxv1coOSofvpmNoc1rlkVdgXnmorGc8w9lsqqyFcL
         Y9MrpmXl8bW3SuM+l9AJXWAsyTcJoLI81R9/ATu2WZF4IISLFp11FC276aqiBwzNF8
         ZX6q9ad1c4gCQ==
Date:   Thu, 7 Jan 2021 10:53:42 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, mathew.j.martineau@linux.intel.com,
        dhowells@redhat.com, linux-crypto@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [PATCH 3/5] crypto: add RFC5869 HKDF
Message-ID: <X/dYtjA6OJAKc3Pc@gmail.com>
References: <4616980.31r3eYUQgx@positron.chronox.de>
 <12679948.uLZWGnKmhe@positron.chronox.de>
 <X/a4qt9Oiw4WgoRY@sol.localdomain>
 <a5c50afa7e11329ea301e64bc03951b38f4e1eda.camel@chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a5c50afa7e11329ea301e64bc03951b38f4e1eda.camel@chronox.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jan 07, 2021 at 08:53:15AM +0100, Stephan Mueller wrote:
> > 
> > > RFC5869
> > > allows two optional parameters to be provided to the extract operation:
> > > the salt and additional information. Both are to be provided with the
> > > seed parameter where the salt is the first entry of the seed parameter
> > > and all subsequent entries are handled as additional information. If
> > > the caller intends to invoke the HKDF without salt, it has to provide a
> > > NULL/0 entry as first entry in seed.
> > 
> > Where does "additional information" for extract come from?  RFC 5869 has:
> > 
> >         HKDF-Extract(salt, IKM) -> PRK
> > 
> >         Inputs:
> >               salt     optional salt value (a non-secret random value);
> >                        if not provided, it is set to a string of HashLen
> > zeros.
> >               IKM      input keying material
> > 
> > There's no "additional information".
> 
> I used the terminology from SP800-108. I will update the description
> accordingly. 

For HKDF, it would be better to stick to the terminology used in RFC 5869
(https://tools.ietf.org/html/rfc5869), as generally that's what people are most
familiar with for HKDF.  It also matches the HKDF paper
(https://eprint.iacr.org/2010/264.pdf) more closely.

- Eric
