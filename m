Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7598E3D92BB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jul 2021 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhG1QH6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 12:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237402AbhG1QFW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 12:05:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 805C160F93;
        Wed, 28 Jul 2021 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627488315;
        bh=mtlOEjAp0ZaGN8O1thI4Ls/GpTvqSvAbJ+P7xB2uW9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uGb09cwCNSkXfP+k0uos/ECMpj7PWsDGBwTi5+FvDBprC+zJ6BfucHxDsHBbwEQiJ
         7X7fwv1xOkt8e/MYIsO7NliM7xV6FbJj9upUwPMBeKNqVZPjXpah5kcwQG86/jY6s7
         olm0khDFNJwAXph5MR1EIh6jn5sI9nF28mKfDLP6g9C0BJcSh+sqTpngCmDT7Q2fNo
         Wm6BAOjSwA3YpETAXnVH3HCwmc+LvnxmTl4YAbqbs1HLViv/dRl0IXH8J3Wst6H6U1
         WqFZ9ZFDiB9K/5hoVa2Gpf4JQ8oy63HVN00dXpTp+McuvtwtDETTYLnnJ61YvCtwR5
         kG8EbXh9kjSRQ==
Date:   Wed, 28 Jul 2021 09:05:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@andred.net,
        Omar Sandoval <osandov@osandov.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
Message-ID: <YQGAOTdQRHFv9rlr@gmail.com>
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
 <YQA2fHPwH6EsH9BR@sol.localdomain>
 <367ea5bb-76cf-6020-cb99-91b5ca82d679@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <367ea5bb-76cf-6020-cb99-91b5ca82d679@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 28, 2021 at 10:50:42AM +0200, Ahmad Fatoum wrote:
> Hello Eric,
> 
> On 27.07.21 18:38, Eric Biggers wrote:
> > On Tue, Jul 27, 2021 at 04:43:49PM +0200, Ahmad Fatoum wrote:
> >> For both v1 and v2 key setup mechanisms, userspace supplies the raw key
> >> material to the kernel after which it is never again disclosed to
> >> userspace.
> >>
> >> Use of encrypted and trusted keys offers stronger guarantees:
> >> The key material is generated within the kernel and is never disclosed to
> >> userspace in clear text and, in the case of trusted keys, can be
> >> directly rooted to a trust source like a TPM chip.
> > 
> > Please include a proper justification for this feature
> 
> I've patches pending for extending trusted keys to wrap the key sealing
> functionality of the CAAM IP on NXP SoCs[1]. I want the kernel to
> generate key material in the factory, have the CAAM encrypt it using its
> undisclosed unique key and pass it to userspace as encrypted blob that is
> persisted to an unencrypted volume. The intention is to thwart offline
> decryption of an encrypted file system in an embedded system, where a
> passphrase can't be supplied by an end user.
> 
> Employing TPM and TEE trusted keys with this is already possible with
> dm-crypt, but I'd like this to be possible out-of-the-box with
> ubifs + fscrypt as well.

Why not do the key management in userspace, like tpm-tools
(https://github.com/tpm2-software/tpm2-tools)?  There are a lot of uses for this
type of hardware besides in-kernel crypto.  See
https://wiki.archlinux.org/title/Trusted_Platform_Module for all the things you
can do with the TPM on Linux, including LUKS encryption; this is all with
userspace key management.  Wouldn't the CAAM hardware be useful for similar
purposes and thus need a similar design as well, e.g. with functionality exposed
through some /dev node for userspace to use?  Or are you saying it will only
ever be useful for in-kernel crypto?

> > Note that there are several design flaws with the encrypted and trusted key
> > types:
> > 
> > - By default, trusted keys are generated using the TPM's RNG rather than the
> >   kernel's RNG, which places all trust in an unauditable black box.
> 
> Patch to fix that awaits feedback on linux-integrity[2].

It does *not* fix it, as your patch only provides an option to use the kernel's
RNG whereas the default is still the TPM's RNG.

Most people don't change defaults.

Essentially your same argument was used for Dual_EC_DRBG; people argued it was
okay to standardize because people had the option to choose their own constants
if they felt the default constants were backdoored.  That didn't really matter,
though, since in practice everyone just used the default constants.

> 
> > - trusted and encrypted keys aren't restricted to specific uses in the kernel
> >   (like the fscrypt-provisioning key type is) but rather are general-purpose.
> >   Hence, it may be possible to leak their contents to userspace by requesting
> >   their use for certain algorithms/features, e.g. to encrypt a dm-crypt target
> >   using a weak cipher that is vulnerable to key recovery attacks.
> 
> The footgun is already there by allowing users to specify their own
> 
> raw key. Users can already use $keyid for dm-crypt and then do
> 
>   $ keyctl pipe $keyid | fscryptctl add_key /mnt
> 
> The responsibility to not reuse key material already lies with the users,
> regardless if they handle the raw key material directly or indirectly via
> a trusted key description/ID.

Elsewhere you are claiming that "trusted" keys can never be disclosed to
userspace.  So you can't rely on userspace cooperating, right?

- Eric
