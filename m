Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE53E430C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Aug 2021 11:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhHIJob (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Aug 2021 05:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234365AbhHIJoa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Aug 2021 05:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3151160F35;
        Mon,  9 Aug 2021 09:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628502250;
        bh=fpRT7uTTq1OKVtdrHaU+I/oKylPE+Adc/m7Bb1QlWfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Of83jRNJEoYUJ6zgx6BkQsugPLTztElCOYd3F3c7VidT6u3txvUOFKckWl0YGukK9
         EDMyhrlzsMtAh7woX1ydovxaX2jqLObXDE6tu6Ur9S5m03trDH01McBvQ9UKLsfKQp
         kcfEpT8977IheTxTCVgRUvfHQJCSQ7iRi6uPLoEcwxOKxksCApH3y0VRiBAEzsW0GK
         Uwf5YQ4lIaTuO6RcBVKV4aIYy7eIvB3+NzueSOAVZR35WPThXsc8cpWFmKPqfNNAid
         PNBnnT4OL0T16xnVEIe9Yt/yBDkPX/KmfmGjShYvkjaJ2gqbYOqtoShhPfH2So95fH
         aYG51tdGU5lJA==
Date:   Mon, 9 Aug 2021 12:44:08 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, kernel@pengutronix.de,
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
Subject: Re: [PATCH v2] fscrypt: support trusted keys
Message-ID: <20210809094408.4iqwsx77u64usfx6@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806150928.27857-1-a.fatoum@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 06, 2021 at 05:09:28PM +0200, Ahmad Fatoum wrote:
> Kernel trusted keys don't require userspace knowledge of the raw key
> material and instead export a sealed blob, which can be persisted to
> unencrypted storage. Userspace can then load this blob into the kernel,
> where it's unsealed and from there on usable for kernel crypto.
> 
> This is incompatible with fscrypt, where userspace is supposed to supply
> the raw key material. For TPMs, a work around is to do key unsealing in
> userspace, but this may not be feasible for other trusted key backends.
> 
> Make it possible to benefit from both fscrypt and trusted key sealing
> by extending fscrypt_add_key_arg::key_id to hold either the ID of a
> fscrypt-provisioning or a trusted key.
> 
> A non fscrypt-provisioning key_id was so far prohibited, so additionally
> allowing trusted keys won't break backwards compatibility.
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> Tested with:
> https://github.com/google/fscryptctl/pull/23
> 
> v1 here:
> https://lore.kernel.org/linux-fscrypt/20210727144349.11215-1-a.fatoum@pengutronix.de/T/#u
> 
> v1 -> v2:
>   - Drop encrypted key support and key_extract_material
>   - Use key_id instead of repurposing raw (Eric)
>   - Shift focus to trusted key sealing for non-TPM as a rationale
>     why this integration is worthwhile (Eric)
>   - Extend documentation with rationale on why one would
>     use trusted keys and warn about trusted key reuse
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
>  Documentation/filesystems/fscrypt.rst | 31 ++++++++++++++-----
>  fs/crypto/keyring.c                   | 43 +++++++++++++++++++--------
>  2 files changed, 54 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 44b67ebd6e40..c1811fa4285a 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -734,23 +734,40 @@ as follows:
>  
>  - ``key_id`` is 0 if the raw key is given directly in the ``raw``
>    field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
> -  type "fscrypt-provisioning" whose payload is
> +  type "fscrypt-provisioning" or "trusted":
> +  "fscrypt-provisioning" keys have a payload of
>    struct fscrypt_provisioning_key_payload whose ``raw`` field contains
>    the raw key and whose ``type`` field matches ``key_spec.type``.
>    Since ``raw`` is variable-length, the total size of this key's
>    payload must be ``sizeof(struct fscrypt_provisioning_key_payload)``
> -  plus the raw key size.  The process must have Search permission on
> -  this key.
> -
> -  Most users should leave this 0 and specify the raw key directly.
> -  The support for specifying a Linux keyring key is intended mainly to
> -  allow re-adding keys after a filesystem is unmounted and re-mounted,
> +  plus the raw key size.
> +  For "trusted" keys, the payload is directly taken as the raw key.
> +
> +  The process must have Search permission on this key.
> +
> +  Most users leave this 0 and specify the raw key directly.
> +  "trusted" keys are useful to leverage kernel support for sealing
> +  and unsealing key material. Sealed keys can be persisted to
> +  unencrypted storage and later be used to decrypt the file system
> +  without requiring userspace to have knowledge of the raw key
> +  material.
> +  "fscrypt-provisioning" key support is intended mainly to allow
> +  re-adding keys after a filesystem is unmounted and re-mounted,
>    without having to store the raw keys in userspace memory.
>  
>  - ``raw`` is a variable-length field which must contain the actual
>    key, ``raw_size`` bytes long.  Alternatively, if ``key_id`` is
>    nonzero, then this field is unused.
>  
> +.. note::
> +
> +   Users should take care not to reuse the fscrypt key material with
> +   different ciphers or in multiple contexts as this may make it
> +   easier to deduce the key.
> +   This also applies when the key material is supplied indirectly
> +   via a kernel trusted key. In this case, the trusted key should
> +   perferably be used only in a single context.
> +
>  For v2 policy keys, the kernel keeps track of which user (identified
>  by effective user ID) added the key, and only allows the key to be
>  removed by that user --- or by "root", if they use
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 0b3ffbb4faf4..721f5da51416 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -20,6 +20,7 @@
>  
>  #include <crypto/skcipher.h>
>  #include <linux/key-type.h>
> +#include <keys/trusted-type.h>
>  #include <linux/random.h>
>  #include <linux/seq_file.h>
>  
> @@ -577,28 +578,44 @@ static int get_keyring_key(u32 key_id, u32 type,
>  	key_ref_t ref;
>  	struct key *key;
>  	const struct fscrypt_provisioning_key_payload *payload;
> -	int err;
> +	int err = 0;
>  
>  	ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
>  	if (IS_ERR(ref))
>  		return PTR_ERR(ref);
>  	key = key_ref_to_ptr(ref);
>  
> -	if (key->type != &key_type_fscrypt_provisioning)
> -		goto bad_key;
> -	payload = key->payload.data[0];
> +	if (key->type == &key_type_fscrypt_provisioning) {

Why does fscrypt have own key type, and does not extend 'encrypted' with a
new format [*]?

> +		payload = key->payload.data[0];
>  
> -	/* Don't allow fscrypt v1 keys to be used as v2 keys and vice versa. */
> -	if (payload->type != type)
> -		goto bad_key;
> +		/* Don't allow fscrypt v1 keys to be used as v2 keys and vice versa. */
> +		if (payload->type != type) {
> +			err = -EKEYREJECTED;
> +			goto out_put;
> +		}
>  
> -	secret->size = key->datalen - sizeof(*payload);
> -	memcpy(secret->raw, payload->raw, secret->size);
> -	err = 0;
> -	goto out_put;
> +		secret->size = key->datalen - sizeof(*payload);
> +		memcpy(secret->raw, payload->raw, secret->size);
> +	} else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) && key->type == &key_type_trusted) {
> +		struct trusted_key_payload *tkp;
> +
> +		/* avoid reseal changing payload while we memcpy key */
> +		down_read(&key->sem);
> +		tkp = key->payload.data[0];
> +		if (!tkp || tkp->key_len < FSCRYPT_MIN_KEY_SIZE ||
> +		    tkp->key_len > FSCRYPT_MAX_KEY_SIZE) {
> +			up_read(&key->sem);
> +			err = -EINVAL;
> +			goto out_put;
> +		}
> +
> +		secret->size = tkp->key_len;
> +		memcpy(secret->raw, tkp->key, secret->size);
> +		up_read(&key->sem);
> +	} else {


I don't think this is right, or at least it does not follow the pattern
in [*]. I.e. you should rather use trusted key to seal your fscrypt key.


> +		err = -EKEYREJECTED;
> +	}
>  
> -bad_key:
> -	err = -EKEYREJECTED;
>  out_put:
>  	key_ref_put(ref);
>  	return err;
> -- 
> 2.30.2
> 
> 

[*] https://www.kernel.org/doc/html/v5.13/security/keys/trusted-encrypted.html

/Jarkko
