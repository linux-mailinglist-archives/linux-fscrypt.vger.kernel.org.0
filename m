Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CF5301CBD
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jan 2021 15:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbhAXOdx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 24 Jan 2021 09:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:56342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbhAXOdw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 24 Jan 2021 09:33:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA73A22D6E;
        Sun, 24 Jan 2021 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611498791;
        bh=Q3cUe7yDX2mO/ETbuJLITh1ajJhq2oBZAS851gRpukY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Y6BXIj/vR7t0TjBzKxt0KfdhusYgv24y0OXRjUx/TnVmJTlbVNDXkDYOXlwGmvI53
         3fPkYeg6IhttMHelNk0cysJ0mafHPCLQqJtivtWOY3JLcYTlecJL8msvnhjBDMZUMf
         tbTo8mN97kcEi/N2z2aiR0LBcn7SQiDnR7CLu6OFyTomC7PIn43/EZyzC25vL+bzTd
         CA1lkwQtKFRNN5cT8vvCF2Ue2v4v8YdIUdiSg7/xuP+mY60iP3+inqCOsx7JiMPB1v
         PNmH+qiyfS3GNA5S5VjibG0F//4mTW3/uT7WyTrYr+1L7oGN+1D6ZRokBlQZ99axek
         LdGFmqnNzxgjw==
Received: by mail-oi1-f176.google.com with SMTP id g69so11113314oib.12;
        Sun, 24 Jan 2021 06:33:10 -0800 (PST)
X-Gm-Message-State: AOAM531QtXczGrphQJ4lPQ938p1XChy4iTJf8ZmHILcf8KUon+LGGYz/
        B9/hxJZ5K2hMrTbdc4W2TjBpZETXlSnANgaOybk=
X-Google-Smtp-Source: ABdhPJxf6wa+w3HL2ymkhEq31S6mF8P+3sGJegXlCV1/K2tJPMbFBc46KgOW4xLvkSWjyGzP4p9A3/TDEY+/xqY36LI=
X-Received: by 2002:aca:210f:: with SMTP id 15mr812785oiz.174.1611498790252;
 Sun, 24 Jan 2021 06:33:10 -0800 (PST)
MIME-Version: 1.0
References: <1772794.tdWV9SEqCh@positron.chronox.de> <CAMj1kXE=46vk15Ovs8qS96JZRi2xDHHe=QqC=WKbZ-+gx4DL4Q@mail.gmail.com>
In-Reply-To: <CAMj1kXE=46vk15Ovs8qS96JZRi2xDHHe=QqC=WKbZ-+gx4DL4Q@mail.gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 24 Jan 2021 15:32:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG5EyTT9ha2C7e1UELknshofUWFGVhKvzXHbptvvvuY=Q@mail.gmail.com>
Message-ID: <CAMj1kXG5EyTT9ha2C7e1UELknshofUWFGVhKvzXHbptvvvuY=Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Add KDF implementations to crypto API
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        David Howells <dhowells@redhat.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        keyrings@vger.kernel.org, simo@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, 24 Jan 2021 at 15:23, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Sun, 24 Jan 2021 at 15:10, Stephan M=C3=BCller <smueller@chronox.de> w=
rote:
> >
> > Hi,
> >
> > The key derviation functions are considered to be a cryptographic
> > operation. As cryptographic operations are provided via the kernel
> > crypto API, this patch set consolidates the KDF implementations into th=
e
> > crypto API.
> >
> > The KDF implementations are provided as service functions. Yet, the
> > interface to the two provided KDFs are identical with the goal to allow
> > them to be transformed into a crypto API template eventually.
> >
>
> Why? There are typically two reasons to use the crypto API abstractions:
> - the algorithm is not known at compile time, so we need the runtime
> dispatch that the crypto API implements,
> - the algorithm may be implemented by a h/w accelerator which is
> discovered at runtime via the driver stack
>
> In other cases, a library API is much more suitable, even in the case
> where we may provide arch-specific accelerated implementations of such
> an algorithm.
>

Hmm, apologies if I got the wrong end of the stick here - this prose
and the naming of some of the crypto_hkdf_xxx routines and function
pointers in the test code made me think that this is more than it
actually is.

What we are talking about are basically library wrappers around shash
instances to perform HKDF, right?

>
>
> > The KDFs execute a power-on self test with test vectors from commonly
> > known sources.
> >
> > Tbe SP800-108 KDF implementation is used to replace the implementation
> > in the keys subsystem. The implementation was verified using the
> > keyutils command line test code provided in
> > tests/keyctl/dh_compute/valid. All tests show that the expected values
> > are calculated with the new code.
> >
> > The HKDF addition is used to replace the implementation in the filesyst=
em
> > crypto extension. This code was tested by using an EXT4 encrypted file
> > system that was created and contains files written to by the current
> > implementation. Using the new implementation a successful read of the
> > existing files was possible and new files / directories were created
> > and read successfully. These newly added file system objects could be
> > successfully read using the current code. Yet if there is a test suite
> > to validate whether the invokcation of the HKDF calculates the same
> > result as the existing implementation, I would be happy to validate
> > the implementation accordingly.
> >
> > Changes v2:
> >
> > * change HKDF function names
> > * change HKDF/SP800-108 KDF extract / seed function prototype
> > * ensure clearing of memory of destination buffer in KDF implementation
> >   if KDF operation fails
> > * security DH: split the removal of dead code into separate patch
> >
> > Stephan Mueller (7):
> >   crypto: Add key derivation self-test support code
> >   crypto: add SP800-108 counter key derivation function
> >   crypto: add RFC5869 HKDF
> >   security: DH - remove dead code for zero padding
> >   security: DH - use KDF implementation from crypto API
> >   fs: use HKDF implementation from kernel crypto API
> >   fs: HKDF - remove duplicate memory clearing
> >
> >  crypto/Kconfig                         |  14 ++
> >  crypto/Makefile                        |   6 +
> >  crypto/hkdf.c                          | 199 +++++++++++++++++++++++++
> >  crypto/kdf_sp800108.c                  | 149 ++++++++++++++++++
> >  fs/crypto/Kconfig                      |   2 +-
> >  fs/crypto/hkdf.c                       | 103 +++----------
> >  include/crypto/hkdf.h                  |  48 ++++++
> >  include/crypto/internal/kdf_selftest.h |  71 +++++++++
> >  include/crypto/kdf_sp800108.h          |  61 ++++++++
> >  security/keys/Kconfig                  |   2 +-
> >  security/keys/dh.c                     | 118 ++-------------
> >  11 files changed, 586 insertions(+), 187 deletions(-)
> >  create mode 100644 crypto/hkdf.c
> >  create mode 100644 crypto/kdf_sp800108.c
> >  create mode 100644 include/crypto/hkdf.h
> >  create mode 100644 include/crypto/internal/kdf_selftest.h
> >  create mode 100644 include/crypto/kdf_sp800108.h
> >
> > --
> > 2.26.2
> >
> >
> >
> >
