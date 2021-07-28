Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E43D9853
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jul 2021 00:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhG1WWs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 18:22:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhG1WWr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 18:22:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071B261019;
        Wed, 28 Jul 2021 22:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627510965;
        bh=j+LzmXUtSJPFBAH+9hQlIoYTHJxJKbuBPn8YylxDQqc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QckIa4S93w+Qg3Iw3yokMJlLjd08JmqqXmv5D5sCDBsQhJTBxYmk24O9QYuwzYtDg
         4I/YSOYf6Z+O2AxGq3WND6/ndPh10gZqUhHDbAV3EepVJNLDCSdal5X9uHzYaB4Ff1
         pPwMhg7YghjWvvCMdStVRTUfw5tLoXSPlOD/G79bcfbY9AWT9XgT8DVZzBy7i83Hx9
         w2QGeeO4iTwyeeuRpjIsk1Hh0b5p17GtYH404zu9AAcPHKEikjh4uoQYctRI6tgSDk
         0B4pU/QPpJaSnrQ3pRMJhotyMhfZc7HWExTNE0m9QcJm4KoOHKw/NbK47BY6V67gTY
         UVadGHRyG5GIQ==
Date:   Thu, 29 Jul 2021 01:22:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
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
Message-ID: <20210728222243.4wqs64pqngzzii3b@kernel.org>
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

Would be nice to have these documented.

/Jarkko
