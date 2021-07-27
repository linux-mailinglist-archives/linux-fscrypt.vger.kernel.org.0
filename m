Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1683D7B2A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Jul 2021 18:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhG0QiW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 27 Jul 2021 12:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhG0QiW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 27 Jul 2021 12:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B5160551;
        Tue, 27 Jul 2021 16:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627403902;
        bh=kTfNWkw/+75t2SVupGO2gGNYqskpuTnQ2ecCChCQJXU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tXFG82sYCd1JVI4/3dsitudiqHAqS03OKzRf4OBFy3GO7R+TpL8Pg2TClRDW2dLRj
         sfAakK5vupxZk380szPZlh7nGOCYm1Cq74BBAip6ZBSK7ji6tmFUSSsRut7DGwptC6
         avLECug1VDiL3HqG/ZIElog7ZDje2cRMK6iHX8P6ugfsOUHJkpxkoYqxuWGGozqLcq
         QVBHUbx2p3bAATaxh43Dk+TSAD+Vf/f3cZ5oA5jlnIHZNcwU+29XkNMwNfOL2BDj9h
         IVc99ZTBumNnD5HL79B1HvIjTwIPGASwX74zfB4eaujMc0eoa6G2En3Ys8J87nz2ro
         0LVbkXUwp7EDA==
Date:   Tue, 27 Jul 2021 09:38:20 -0700
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
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
Message-ID: <YQA2fHPwH6EsH9BR@sol.localdomain>
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727144349.11215-1-a.fatoum@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 27, 2021 at 04:43:49PM +0200, Ahmad Fatoum wrote:
> For both v1 and v2 key setup mechanisms, userspace supplies the raw key
> material to the kernel after which it is never again disclosed to
> userspace.
> 
> Use of encrypted and trusted keys offers stronger guarantees:
> The key material is generated within the kernel and is never disclosed to
> userspace in clear text and, in the case of trusted keys, can be
> directly rooted to a trust source like a TPM chip.

Please include a proper justification for this feature and update the relevant
sections of Documentation/filesystems/fscrypt.rst to explain why someone would
want to use this feature and what it accomplishes.

As-is, this feature doesn't seem to have a very strong justification.  Please
also see previous threads where this feature was discussed/requested:
https://lkml.kernel.org/linux-fscrypt/20180110124418.24385-1-git@andred.net/T/#u,
https://lkml.kernel.org/linux-fscrypt/20180118131359.8365-1-git@andred.net/T/#u,
https://lkml.kernel.org/linux-fscrypt/20200116193228.GA266386@vader/T/#u

Note that there are several design flaws with the encrypted and trusted key
types:

- By default, trusted keys are generated using the TPM's RNG rather than the
  kernel's RNG, which places all trust in an unauditable black box.

- trusted and encrypted keys aren't restricted to specific uses in the kernel
  (like the fscrypt-provisioning key type is) but rather are general-purpose.
  Hence, it may be possible to leak their contents to userspace by requesting
  their use for certain algorithms/features, e.g. to encrypt a dm-crypt target
  using a weak cipher that is vulnerable to key recovery attacks.

- "encrypted" keys that use a master key of type "user" are supported, despite
  these being easily obtainable in the clear by userspace providing their own
  master key.  This violates one of the main design goals of "encrypted" keys.

Also, using the "trusted" key type isn't necessary to achieve TPM-bound
encryption, as TPM binding can be handled in userspace instead.

So I really would like to see a proper justification for this feature, and have
it be properly documented.

One comment on the UAPI below.

> 
> Add support for trusted and encrypted keys by repurposing
> fscrypt_add_key_arg::raw to hold the key description when the new
> FSCRYPT_KEY_ARG_TYPE_DESC flag is supplied. The location of the flag
> was previously reserved and enforced by ioctl code to be zero, so this
> change won't break backwards compatibility.
> 
> Corresponding userspace patches are available for fscryptctl:
> https://github.com/google/fscryptctl/pull/23
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> key_extract_material used by this patch is added in
> <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
> which still awaits feedback.
> 
> Sending this RFC out anyway to get some feedback from the fscrypt
> developers whether this is the correct way to go about it.
> 
> To: "Theodore Y. Ts'o" <tytso@mit.edu>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Eric Biggers <ebiggers@kernel.org>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: James Bottomley <jejb@linux.ibm.com>
> Cc: Mimi Zohar <zohar@linux.ibm.com>
> Cc: Sumit Garg <sumit.garg@linaro.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-fscrypt@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: keyrings@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/filesystems/fscrypt.rst | 24 ++++++++---
>  fs/crypto/keyring.c                   | 59 ++++++++++++++++++++++++---
>  include/uapi/linux/fscrypt.h          | 16 +++++++-
>  3 files changed, 87 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 44b67ebd6e40..83738af2afa3 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -681,11 +681,15 @@ It can be executed on any file or directory on the target filesystem,
>  but using the filesystem's root directory is recommended.  It takes in
>  a pointer to struct fscrypt_add_key_arg, defined as follows::
>  
> +    #define FSCRYPT_KEY_ADD_RAW_ASIS		0
> +    #define FSCRYPT_KEY_ADD_RAW_DESC		1
> +
>      struct fscrypt_add_key_arg {
>              struct fscrypt_key_specifier key_spec;
>              __u32 raw_size;
>              __u32 key_id;
> -            __u32 __reserved[8];
> +            __u32 raw_flags;     /* one of FSCRYPT_KEY_ADD_RAW_* */
> +            __u32 __reserved[7];
>              __u8 raw[];
>      };
>  
> @@ -732,8 +736,11 @@ as follows:
>    Alternatively, if ``key_id`` is nonzero, this field must be 0, since
>    in that case the size is implied by the specified Linux keyring key.
>  
> -- ``key_id`` is 0 if the raw key is given directly in the ``raw``
> -  field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
> +- If ``key_id`` is 0, the raw key is given directly in the ``raw``
> +  field if ``raw_flags == FSCRYPT_KEY_ADD_RAW_ASIS``. With
> +  ``raw_flags == FSCRYPT_KEY_ADD_RAW_DESC``, ``raw`` is instead
> +  interpreted as the description of an encrypted or trusted key.
> +  Otherwise ``key_id`` is the ID of a Linux keyring key of
>    type "fscrypt-provisioning" whose payload is
>    struct fscrypt_provisioning_key_payload whose ``raw`` field contains
>    the raw key and whose ``type`` field matches ``key_spec.type``.
> @@ -748,8 +755,15 @@ as follows:
>    without having to store the raw keys in userspace memory.

Why not just allow the key_id field to specify a "trusted" or "encrypted" key?
Why is it necessary for FS_IOC_ADD_ENCRYPTION_KEY to support two different ways
of looking up keyring keys -- by ID and by description?  Looking up by ID works
fine for "fscrypt-provisioning" keys; why are "trusted" and "encrypted" keys
different in this regard?

- Eric
