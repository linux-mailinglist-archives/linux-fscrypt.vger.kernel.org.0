Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 696F23E4E65
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Aug 2021 23:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbhHIVYs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Aug 2021 17:24:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:49690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236441AbhHIVYq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Aug 2021 17:24:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 203B860EB9;
        Mon,  9 Aug 2021 21:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628544264;
        bh=D2aOWPkZRvo4FPeQiqOYNBi8S+9DKShgichgczsHHWo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iZLhpA+/gitAAaAEJQa+SuwtTRtdWqNg6KiI+uJ7wTvD3Slz3f1q3M9eNHEFeRye0
         skvrWsmpZpvzteGIgxz4pTEpOgAipWgy9d7eUlNX8TSLP79IWGFGwweo0PtzzXd7OB
         AEZsAAVVZ292uDGutkHjSqtKaODj/EDag/I63+6go3rh+dCs85LjWzbrvCixe8fofF
         dgyiqfDqJVa2wzIudk1PTzSFI5sW3HaAMH3j/iQ+w7cgz2z0y4fJVAo4aRdc/zM6FO
         /bYKoXwAhjmPGJpABv1eqcLcp3CKE5y689yJhJ/+5zZVIW9+Yy4Zn2AvdCx12kotWk
         fG+pgXQ5/og3w==
Date:   Mon, 9 Aug 2021 14:24:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
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
Subject: Re: [PATCH v2] fscrypt: support trusted keys
Message-ID: <YRGdBiJQ3xqZAT4w@gmail.com>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806150928.27857-1-a.fatoum@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Ahmad,

This generally looks okay, but I have some comments below.

On Fri, Aug 06, 2021 at 05:09:28PM +0200, Ahmad Fatoum wrote:
> Kernel trusted keys don't require userspace knowledge of the raw key
> material and instead export a sealed blob, which can be persisted to
> unencrypted storage. Userspace can then load this blob into the kernel,
> where it's unsealed and from there on usable for kernel crypto.

Please be explicit about where and how the keys get generated in this case.

> This is incompatible with fscrypt, where userspace is supposed to supply
> the raw key material. For TPMs, a work around is to do key unsealing in
> userspace, but this may not be feasible for other trusted key backends.

As far as I can see, "Key unsealing in userspace" actually is the preferred way
to implement TPM-bound encryption.  So it doesn't seem fair to call it a "work
around".

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

Again, please be explicit about key generation.  Note that key generation is
already discussed in a different section, "Master Keys".  There should be a
mention of trusted keys there.  The above note about not reusing keys probably
belongs there too.  (The section you're editing here is
"FS_IOC_ADD_ENCRYPTION_KEY", which is primarily intended to just document the
ioctl, so it's not necessarily the best place for this type of information.)

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

This function is getting long; it probably should be broken this up into several
functions.  E.g.:

static int get_keyring_key(u32 key_id, u32 type,
                           struct fscrypt_master_key_secret *secret)
{
        key_ref_t ref;
        struct key *key;
        int err;

        ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
        if (IS_ERR(ref))
                return PTR_ERR(ref);
        key = key_ref_to_ptr(ref);

        if (key->type == &key_type_fscrypt_provisioning) {
                err = fscrypt_get_provisioning_key(key, type, secret);
        } else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) &&
                   key->type == &key_type_trusted) {
                err = fscrypt_get_trusted_key(key, secret);
        } else {
                err = -EKEYREJECTED;
        }
        key_ref_put(ref);
        return err;
}

> +		/* Don't allow fscrypt v1 keys to be used as v2 keys and vice versa. */

Please avoid overly-long lines.

> +		tkp = key->payload.data[0];
> +		if (!tkp || tkp->key_len < FSCRYPT_MIN_KEY_SIZE ||
> +		    tkp->key_len > FSCRYPT_MAX_KEY_SIZE) {
> +			up_read(&key->sem);
> +			err = -EINVAL;
> +			goto out_put;
> +		}

What does the !tkp case mean?  For "user" and "logon" keys it means "key
revoked", but the "trusted" key type doesn't implement revoke.  Is this included
just to be safe?  That might be reasonable, but perhaps the error code in that
case (but not the invalid length cases) should be -EKEYREVOKED instead?

- Eric
