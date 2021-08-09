Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF503E4E1E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Aug 2021 22:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhHIUwY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Aug 2021 16:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231439AbhHIUwY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Aug 2021 16:52:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5C3E61019;
        Mon,  9 Aug 2021 20:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628542323;
        bh=Hmwxlf5nQ7ImK2R2BhO30AV/6FpqvIYKru/OacCO/yI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+SB5V7BnHWZA1+CxKpnSYavXT98W4ODpDVlD+XnnVvKsjZbLwcMZaIjQPimc+wty
         HeRSgLLvr0bL+nvQEhQYmFMNzgUdXpBUkYxsSofCOST9b7gtqMsLb2dS7ZywqI+PfJ
         jqWJKwkDczv9HXamv4LdC1Y841+ehrsggFvhehTUWt4TynfJ6pvOvuxqH61NN+//ne
         Gq4IRclpNdCln9SoQCCKdwGoZXM4gtSbwAkO/wl/MTpKkfwNxMV3A0FtsKSuL69t0K
         r1O31SpBeVUg8PgVABpL4gGF6vvwr/qnYH33nxARtCg1w9zNGYpYLU7C5fHtDAKQcy
         5fS2dwdG18wgw==
Date:   Mon, 9 Aug 2021 13:52:01 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
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
Message-ID: <YRGVcaquAJiuc8bp@gmail.com>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809094408.4iqwsx77u64usfx6@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 09, 2021 at 12:44:08PM +0300, Jarkko Sakkinen wrote:
> > @@ -577,28 +578,44 @@ static int get_keyring_key(u32 key_id, u32 type,
> >  	key_ref_t ref;
> >  	struct key *key;
> >  	const struct fscrypt_provisioning_key_payload *payload;
> > -	int err;
> > +	int err = 0;
> >  
> >  	ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
> >  	if (IS_ERR(ref))
> >  		return PTR_ERR(ref);
> >  	key = key_ref_to_ptr(ref);
> >  
> > -	if (key->type != &key_type_fscrypt_provisioning)
> > -		goto bad_key;
> > -	payload = key->payload.data[0];
> > +	if (key->type == &key_type_fscrypt_provisioning) {
> 
> Why does fscrypt have own key type, and does not extend 'encrypted' with a
> new format [*]?

Are you referring to the "fscrypt-provisioning" key type?  That is an existing
feature (which in most cases isn't used, but there is a use case that requires
it), not something being added by this patch.  We just needed a key type where
userspace can add a raw key to the kernel and not be able to read it back (so
like the "logon" key type), but also have the kernel enforce that that key is
only used for fscrypt with a particular KDF version, and not with other random
kernel features.  The "encrypted" key type wouldn't have worked for this at all;
it's a totally different thing.

> > +	} else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) && key->type == &key_type_trusted) {
> > +		struct trusted_key_payload *tkp;
> > +
> > +		/* avoid reseal changing payload while we memcpy key */
> > +		down_read(&key->sem);
> > +		tkp = key->payload.data[0];
> > +		if (!tkp || tkp->key_len < FSCRYPT_MIN_KEY_SIZE ||
> > +		    tkp->key_len > FSCRYPT_MAX_KEY_SIZE) {
> > +			up_read(&key->sem);
> > +			err = -EINVAL;
> > +			goto out_put;
> > +		}
> > +
> > +		secret->size = tkp->key_len;
> > +		memcpy(secret->raw, tkp->key, secret->size);
> > +		up_read(&key->sem);
> > +	} else {
> 
> 
> I don't think this is right, or at least it does not follow the pattern
> in [*]. I.e. you should rather use trusted key to seal your fscrypt key.

What's the benefit of the extra layer of indirection over just using a "trusted"
key directly?  The use case for "encrypted" keys is not at all clear to me.

- Eric
