Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B0C301CC4
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbhAXOhJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:37:09 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:20005 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAXOhI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:37:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1611498843;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:From:
        Subject:Sender;
        bh=xyuBJ9z5Y2O0KqbpsKjLYim6gTS3ckKJAVrCOhui480=;
        b=dlG97Q+Ac+JbXGCfVHCVnKWpfN1MAIBwgdOXnwx6A32/i3VbvhLQTNPzfZoVHHoSct
        M1dHFP+g8XnzDI3g6eet00ndoPU863UcxJC7J4omeQ5syrlI8Dp4eSZHJKWEFcpl7t+6
        gB6sZhJWwvISTFIznk7ayAB5D+YqEd6CPZEbjTA02+xI6sV2yeK3wxaAFcZrLxzrRIwe
        F/ueoKUe0nrMF9kqgUZE6p1bUFiTRJo4ePN9HD+zr5Ik8BU/OiNpLzieb5LVB1JwtRRR
        b2Kirt1GkFufXlelUPWlLkqQWH+p6XCdGLxBMlPlD5THaa1XRUS3phn/gECQny9U2utQ
        ZgBQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZI/ScIzb9"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.12.1 DYNA|AUTH)
        with ESMTPSA id Z04c46x0OEY2eqT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 24 Jan 2021 15:34:02 +0100 (CET)
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
Date:   Sun, 24 Jan 2021 15:34:02 +0100
Message-ID: <4083606.ejJDZkT8p0@positron.chronox.de>
In-Reply-To: <CAMj1kXE=46vk15Ovs8qS96JZRi2xDHHe=QqC=WKbZ-+gx4DL4Q@mail.gmail.com>
References: <1772794.tdWV9SEqCh@positron.chronox.de> <CAMj1kXE=46vk15Ovs8qS96JZRi2xDHHe=QqC=WKbZ-+gx4DL4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Am Sonntag, 24. Januar 2021, 15:23:29 CET schrieb Ard Biesheuvel:

Hi Ard,

> On Sun, 24 Jan 2021 at 15:10, Stephan M=FCller <smueller@chronox.de> wrot=
e:
> > Hi,
> >=20
> > The key derviation functions are considered to be a cryptographic
> > operation. As cryptographic operations are provided via the kernel
> > crypto API, this patch set consolidates the KDF implementations into the
> > crypto API.
> >=20
> > The KDF implementations are provided as service functions. Yet, the
> > interface to the two provided KDFs are identical with the goal to allow
> > them to be transformed into a crypto API template eventually.
>=20
> Why? There are typically two reasons to use the crypto API abstractions:
> - the algorithm is not known at compile time, so we need the runtime
> dispatch that the crypto API implements,
> - the algorithm may be implemented by a h/w accelerator which is
> discovered at runtime via the driver stack
>=20
> In other cases, a library API is much more suitable, even in the case
> where we may provide arch-specific accelerated implementations of such
> an algorithm.

In case your "why" refers to why I stated that the KDF implementations are=
=20
similar to eventually consolidate them into a template eventually:

A KDF is conceptually a logic on top of a (hash) algorithm like a block=20
chaining mode on top of a block cipher or a deterministic RNG on top of an=
=20
underlying cipher.

So, conceptually with the kernel crypto API, we would have a KDF template t=
hat=20
can be used like hkdf(sha256) or hkdf(sha256-avx2).

The behavior of a KDF is identical to a deterministic RNG. Thus, a long tim=
e=20
ago, I had a patch developed that adds a very small addition to the existin=
g=20
RNG API to allow the KDFs to be used. See [1]. Yet, that was not desired at=
=20
the time due to different reasons.

Yet, the crypto API as it stands today knows of templates and basic=20
algorithms. Having a separate library API providing a crypto algorithm is n=
ew=20
to the crypto API. You see that with the test manager which works well with=
=20
the templates / algorithms but does not provide any helpers for some "libra=
ry=20
APIs".



In case your "why" refers to whether I am not using a template to begin wit=
h:

Some time back I provided the patch using a template (see [1] for example).=
 At=20
that time, Herbert wanted to have a service API instead.

[1] http://www.chronox.de/kdf.html

Ciao
Stephan


