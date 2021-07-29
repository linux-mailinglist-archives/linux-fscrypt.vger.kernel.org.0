Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1EE3D9D54
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jul 2021 07:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhG2F5N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jul 2021 01:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2F5M (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jul 2021 01:57:12 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9119AC061765
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Jul 2021 22:57:09 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f18so8695050lfu.10
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Jul 2021 22:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XcbhZ5Sjzz8dxY7pTRg9gGEgfRrO83ag5vG41bFy7qA=;
        b=YQEazPr+8F1apEi6PsoFkWJBawAyqulBeVpaRkq8+OZmhbwY1w8AVgsg+ekg2keP8U
         AQcbJfUtG6kHUx4bXydpdMV+rM1Fqd1RbfQGFJHSmUF+3eTPZgSJjGCjWMfi3z8FdKHx
         9eQlqYzm1NR3PI3NeTNFqlYI+ILW5SPY64rTFV2wN12Xu4blbSJRHDWC+QXnXYIVacUP
         /wg78Zv0mNs3pKalYMNWqLZJSW4c4MvY0wzm5PHUFEMKJeMZFAqGDbbqEpGrlveUhjP1
         zV+2fMf0vt26mgSFhuuBJgNMNWgrDM67K5+KGvh+xqp0ABvRQsEksxGogLILccUxaclh
         uAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XcbhZ5Sjzz8dxY7pTRg9gGEgfRrO83ag5vG41bFy7qA=;
        b=TfUnE0c4FzxrhnfXgFQBIpC/piZbybOZuRGSmXJ//3cj/2VwqeTtloCQb4CDadzpqs
         CyF+nZxRz4ISBNNPNa+KSNIBufcjRLzmMjqQpI+8RQeDSvv5L7ah7cMs9K+OCrT3NcVc
         aKixpmPL9uf4JRTsy6IMHGNhEvr1Y9Fw/zRaglKQEvy2q9Hs/AHeFUYzBuoPlkHAIdg1
         w6eiaMam/BGj62T47r4Le/dk7M1R76HTVIAnf8GVbtYzHjbjHsmYaGQ5nusF9EUo67Pm
         IeKs9+mvYxfr6m0RUgP4tTM/S+Ias7QvVvowj80DzgNHuY+BqzYx2fapddHgOVN3TGin
         LkwA==
X-Gm-Message-State: AOAM5314jk2iJZDuBZpOtGkbHBM5CBN+wkHmPNwtJSvCvTwDs8hQwIhF
        sHaG0OPmIgN7s0F1YZGGtMcXr8lMRURZHG0EB+pYTw==
X-Google-Smtp-Source: ABdhPJzXQMiTbRwHulQZgSyAMiQCjKimBxkJLN8fa+Src+cJukNSOCcSHAMcEv0gZ4fTWkxqcwZgE78x/0et/HUAcqo=
X-Received: by 2002:a19:c757:: with SMTP id x84mr2581412lff.302.1627538227888;
 Wed, 28 Jul 2021 22:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
 <YQA2fHPwH6EsH9BR@sol.localdomain> <367ea5bb-76cf-6020-cb99-91b5ca82d679@pengutronix.de>
 <YQGAOTdQRHFv9rlr@gmail.com>
In-Reply-To: <YQGAOTdQRHFv9rlr@gmail.com>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 29 Jul 2021 11:26:56 +0530
Message-ID: <CAFA6WYO-h+ngCAT_PS=bZTQkBBtOpBRUmZNP4zhvRuLDJYQXkA@mail.gmail.com>
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        "open list:SECURITY SUBSYSTEM" 
        <linux-security-module@vger.kernel.org>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        git@andred.net, Omar Sandoval <osandov@osandov.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On Wed, 28 Jul 2021 at 21:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jul 28, 2021 at 10:50:42AM +0200, Ahmad Fatoum wrote:
> > Hello Eric,
> >
> > On 27.07.21 18:38, Eric Biggers wrote:
> > > On Tue, Jul 27, 2021 at 04:43:49PM +0200, Ahmad Fatoum wrote:
> > >> For both v1 and v2 key setup mechanisms, userspace supplies the raw key
> > >> material to the kernel after which it is never again disclosed to
> > >> userspace.
> > >>
> > >> Use of encrypted and trusted keys offers stronger guarantees:
> > >> The key material is generated within the kernel and is never disclosed to
> > >> userspace in clear text and, in the case of trusted keys, can be
> > >> directly rooted to a trust source like a TPM chip.
> > >
> > > Please include a proper justification for this feature
> >
> > I've patches pending for extending trusted keys to wrap the key sealing
> > functionality of the CAAM IP on NXP SoCs[1]. I want the kernel to
> > generate key material in the factory, have the CAAM encrypt it using its
> > undisclosed unique key and pass it to userspace as encrypted blob that is
> > persisted to an unencrypted volume. The intention is to thwart offline
> > decryption of an encrypted file system in an embedded system, where a
> > passphrase can't be supplied by an end user.
> >
> > Employing TPM and TEE trusted keys with this is already possible with
> > dm-crypt, but I'd like this to be possible out-of-the-box with
> > ubifs + fscrypt as well.
>
> Why not do the key management in userspace, like tpm-tools
> (https://github.com/tpm2-software/tpm2-tools)?  There are a lot of uses for this
> type of hardware besides in-kernel crypto.  See
> https://wiki.archlinux.org/title/Trusted_Platform_Module for all the things you
> can do with the TPM on Linux, including LUKS encryption; this is all with
> userspace key management.  Wouldn't the CAAM hardware be useful for similar
> purposes and thus need a similar design as well, e.g. with functionality exposed
> through some /dev node for userspace to use?  Or are you saying it will only
> ever be useful for in-kernel crypto?

AFAIK from my prior experience while working with CAAM engine during
my time at NXP, it is generally a crypto engine with additional
security properties like one discussed here to protect keys (blob
encap and decap) etc. But it doesn't offer user authentication similar
to what a TPM (ownership) can offer. Although, one should be able to
expose CAAM via /dev node but I am not sure if that would be really
useful without user authentication. I think similar should be the case
for other crypto engines with additional security properties.

With restriction of CAAM's security properties to kernel crypto we
could at least ensure a kernel boundary that should offer enough
resistance from malicious user space attacks.

>
> > > Note that there are several design flaws with the encrypted and trusted key
> > > types:
> > >
> > > - By default, trusted keys are generated using the TPM's RNG rather than the
> > >   kernel's RNG, which places all trust in an unauditable black box.
> >

With regards to trusted keys generated using the TEE's RNG, the
underlying implementation being OP-TEE [1] which is an open source TEE
implementation built on top of Arm TrustZone providing the hardware
based isolation among the TEE and Linux. So regarding auditability, it
should be comparatively easier to audit the TEE components designed
with a goal of minimal footprint when compared with Linux kernel.

[1] https://github.com/OP-TEE/optee_os

> > Patch to fix that awaits feedback on linux-integrity[2].
>
> It does *not* fix it, as your patch only provides an option to use the kernel's
> RNG whereas the default is still the TPM's RNG.
>

Yes in case of TPM, default is still TPM's RNG but with Ahmad's patch
#2, the trust source backend like CAAM should be able to use kernel's
RNG by default.

-Sumit

> Most people don't change defaults.
>
> Essentially your same argument was used for Dual_EC_DRBG; people argued it was
> okay to standardize because people had the option to choose their own constants
> if they felt the default constants were backdoored.  That didn't really matter,
> though, since in practice everyone just used the default constants.
>
> >
> > > - trusted and encrypted keys aren't restricted to specific uses in the kernel
> > >   (like the fscrypt-provisioning key type is) but rather are general-purpose.
> > >   Hence, it may be possible to leak their contents to userspace by requesting
> > >   their use for certain algorithms/features, e.g. to encrypt a dm-crypt target
> > >   using a weak cipher that is vulnerable to key recovery attacks.
> >
> > The footgun is already there by allowing users to specify their own
> >
> > raw key. Users can already use $keyid for dm-crypt and then do
> >
> >   $ keyctl pipe $keyid | fscryptctl add_key /mnt
> >
> > The responsibility to not reuse key material already lies with the users,
> > regardless if they handle the raw key material directly or indirectly via
> > a trusted key description/ID.
>
> Elsewhere you are claiming that "trusted" keys can never be disclosed to
> userspace.  So you can't rely on userspace cooperating, right?
>
> - Eric
