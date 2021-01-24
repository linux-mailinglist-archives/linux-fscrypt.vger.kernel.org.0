Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F13301CCA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbhAXOjT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:39:19 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.102]:9571 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbhAXOjS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611498974;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=djudYJy4uCamF9BzVNn1GVJzDuSOcjWUTDquOv2MIAg=;
        b=sJK3VgK9gIIlDsEQaGs1M22T+lu7W4ec6DIucOL17q0b8MWOFcRtYDfv7mnzL/50sP
        oABJ2bCanz/1Ws4DZMqkzZqn0YqSw/0QIhkfVwEZQXGHeUvEOyxnzJZlu2HZYrKlXkDy
        YXw5rQHjD2plhMoPwxy4sLvMLdz+6B8qQiclc/Z74r/zHDOYpf3R9ahRe5/lLtvRT0DT
        0Iq4iIY3i78J7hOwJhCVME5gU6fr+zqPqsyk/RHSVNrQ3uL9QynaUv/AJl1Sdxgv8aBj
        0wUPu3uWlQ//U+EktRI5vseziNPEOhQdjgkOV89bp51727aDAUoO7WYjy8TxSXRwHdsU
        OZwg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OEaDesY
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:36:13 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org, simo@redhat.com
Subject: Re: [PATCH v2 0/7] Add KDF implementations to crypto API
Date:   Sun, 24 Jan 2021 15:36:13 +0100
Message-ID: <3522419.MHq7AAxBmi@positron.chronox.de>
In-Reply-To: <CAMj1kXG5EyTT9ha2C7e1UELknshofUWFGVhKvzXHbptvvvuY=Q@mail.gmail.com>
References: <1772794.tdWV9SEqCh@positron.chronox.de> <CAMj1kXE=46vk15Ovs8qS96JZRi2xDHHe=QqC=WKbZ-+gx4DL4Q@mail.gmail.com> <CAMj1kXG5EyTT9ha2C7e1UELknshofUWFGVhKvzXHbptvvvuY=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Am Sonntag, 24. Januar 2021, 15:32:59 CET schrieb Ard Biesheuvel:

Hi Ard,

> On Sun, 24 Jan 2021 at 15:23, Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Sun, 24 Jan 2021 at 15:10, Stephan M=FCller <smueller@chronox.de> wr=
ote:
> > > Hi,
> > >=20
> > > The key derviation functions are considered to be a cryptographic
> > > operation. As cryptographic operations are provided via the kernel
> > > crypto API, this patch set consolidates the KDF implementations into =
the
> > > crypto API.
> > >=20
> > > The KDF implementations are provided as service functions. Yet, the
> > > interface to the two provided KDFs are identical with the goal to all=
ow
> > > them to be transformed into a crypto API template eventually.
> >=20
> > Why? There are typically two reasons to use the crypto API abstractions:
> > - the algorithm is not known at compile time, so we need the runtime
> > dispatch that the crypto API implements,
> > - the algorithm may be implemented by a h/w accelerator which is
> > discovered at runtime via the driver stack
> >=20
> > In other cases, a library API is much more suitable, even in the case
> > where we may provide arch-specific accelerated implementations of such
> > an algorithm.
>=20
> Hmm, apologies if I got the wrong end of the stick here - this prose
> and the naming of some of the crypto_hkdf_xxx routines and function
> pointers in the test code made me think that this is more than it
> actually is.
>=20
> What we are talking about are basically library wrappers around shash
> instances to perform HKDF, right?

Sorry, our emails just crossed each other.

Yes, you are absolutely correct. The KDF implementations are wrappers aroun=
d=20
the SHASH API. Conceptually the provided API is what templates actually sho=
uld=20
do.

As mentioned in the other email, however, adding a template was and is not=
=20
considered appropriate at the time. Yet, I would like to keep the path open=
 to=20
transform the KDF implementations into a template.

Ciao
Stephan


