Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C089D3DAAE1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jul 2021 20:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhG2S2R (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jul 2021 14:28:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhG2S2R (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jul 2021 14:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1132660EBD;
        Thu, 29 Jul 2021 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627583293;
        bh=CBrRBRO/tDGawMDo7/5lR6U7y1rcL3K2D2QD62EAY6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SSnwQJ29s1xjFeEYWBu1pRC14ZtIm/hTtIUu0k3HawS4MB3N4ncTvbVEzae3ViuU7
         jMa5AUdbBxSVR+sU86OHV8imvEEQ0yRcLvsmV4wgr9p97tx+SeN1m745TVZBloK3NU
         +PLPoJvqKc+M0iUzkNEBBMzdETD8o3otG55JX/H678jYHFCZICO3RZvay7zsQNEqPU
         3cPc9DshIMs//k25ZFoTZ6Az0Yyk/ivATKSGF6hGzGUO8ZndNr3l0ZNfodBZozS8lt
         +bp3xPA5qOIzn21SiBqnQd6NFa3O1VRuEuw5UPvi8FxVaMdAJRFpvLAjIeTYx7kcAj
         GpNEVPswy/0ig==
Date:   Thu, 29 Jul 2021 11:28:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Sumit Garg <sumit.garg@linaro.org>,
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
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
Message-ID: <YQLzOwnPF1434kUk@gmail.com>
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
 <YQA2fHPwH6EsH9BR@sol.localdomain>
 <367ea5bb-76cf-6020-cb99-91b5ca82d679@pengutronix.de>
 <YQGAOTdQRHFv9rlr@gmail.com>
 <CAFA6WYO-h+ngCAT_PS=bZTQkBBtOpBRUmZNP4zhvRuLDJYQXkA@mail.gmail.com>
 <1530428a-ad2c-a169-86a7-24bfafb9b9bd@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530428a-ad2c-a169-86a7-24bfafb9b9bd@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 29, 2021 at 11:07:00AM +0200, Ahmad Fatoum wrote:
> >> Most people don't change defaults.
> >>
> >> Essentially your same argument was used for Dual_EC_DRBG; people argued it was
> >> okay to standardize because people had the option to choose their own constants
> >> if they felt the default constants were backdoored.  That didn't really matter,
> >> though, since in practice everyone just used the default constants.
> 
> I'd appreciate your feedback on my CAAM series if you think the defaults
> can be improved. Trusted keys are no longer restricted to TPMs,
> so users of other backends shouldn't be dismissed, because one backend
> can be used with fscrypt by alternative means.

I already gave feedback:
https://lkml.kernel.org/keyrings/YGOcZtkw3ZM5kvl6@gmail.com
https://lkml.kernel.org/keyrings/YGUHBelwhvJDhKoo@gmail.com
https://lkml.kernel.org/keyrings/YGViOc3DG+Pjuur6@sol.localdomain

> >>>> - trusted and encrypted keys aren't restricted to specific uses in the kernel
> >>>>   (like the fscrypt-provisioning key type is) but rather are general-purpose.
> >>>>   Hence, it may be possible to leak their contents to userspace by requesting
> >>>>   their use for certain algorithms/features, e.g. to encrypt a dm-crypt target
> >>>>   using a weak cipher that is vulnerable to key recovery attacks.
> >>>
> >>> The footgun is already there by allowing users to specify their own
> >>>
> >>> raw key. Users can already use $keyid for dm-crypt and then do
> >>>
> >>>   $ keyctl pipe $keyid | fscryptctl add_key /mnt
> >>>
> >>> The responsibility to not reuse key material already lies with the users,
> >>> regardless if they handle the raw key material directly or indirectly via
> >>> a trusted key description/ID.
> >>
> >> Elsewhere you are claiming that "trusted" keys can never be disclosed to
> >> userspace.  So you can't rely on userspace cooperating, right?
> 
> The users I meant are humans, e.g. system integrators. They need to think about
> 
> burning fuses, signing bootloaders, verifying kernel and root file systems,
> 
> encrypting file systems and safekeeping their crypto keys. Ample opportunity for
> 
> stuff to go wrong. They would benefit from having relevant kernel functionality
> 
> integrate with each other instead of having to carry downstream patches, which
> we and many others[1] did for years. We now finally have a chance to drop this
> technical debt thanks to Sumit's trusted key rework and improve user security
> along the way.
> 
> So, Eric, how should we proceed?
> 

It is probably inevitable that this be added, but you need to document it
properly and not make misleading claims like "The key material is generated
within the kernel" (for the TPM "trust" source the default is to use the TPM's
RNG, *not* the kernel RNG), and "is never disclosed to userspace in clear text"
(that's only guaranteed to be true for non-malicious userspace).  Also please
properly document that this is mainly intended for accessing key wrapping
hardware such as CAAM that can't be accessed from userspace in another way like
TPMs can.

- Eric
