Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C523E8280
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 20:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbhHJSJE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 14:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237130AbhHJSHB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 14:07:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C75F604D7;
        Tue, 10 Aug 2021 18:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628618799;
        bh=kEmljyW+BkGvemsIRyB4yzEDHSoBRNgJjHMOZEgNhDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tYlVsM4LEIve11JtBlC8hJSOXygxAr7SQKglPLL3rKUpPdQ7I7phVzvs6AKcgEpYa
         Y4F7f8EKKLwNFUqDXtCehzLm9XV8zTEYHyjFGfwb0BXhza8VW6PzxcbcyvdlwbbT5r
         S6/VtXqnF4ND27jVmC9+VHArKdHvMH5ZmWaeWepWopdNRfYM5sqHcdOBIjt/o/TBMS
         QX/+6nVyao88yWvVVT3YJNHX51euHA+w8ZdwwqoJQbSRwjfH9pqGYMeHM6Wtmweqo5
         gD6R9+6LSGn+uFKnpGkcfCAmBHxovcVVslzctkrbfeenRbxoOH6NtNRXjKTI3OEUJ0
         3PiztapJkj/4w==
Date:   Tue, 10 Aug 2021 21:06:36 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
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
Message-ID: <20210810180636.vqwaeftv7alsodgn@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
 <YRGVcaquAJiuc8bp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRGVcaquAJiuc8bp@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 09, 2021 at 01:52:01PM -0700, Eric Biggers wrote:
> On Mon, Aug 09, 2021 at 12:44:08PM +0300, Jarkko Sakkinen wrote:
> > > @@ -577,28 +578,44 @@ static int get_keyring_key(u32 key_id, u32 type,
> > >  	key_ref_t ref;
> > >  	struct key *key;
> > >  	const struct fscrypt_provisioning_key_payload *payload;
> > > -	int err;
> > > +	int err = 0;
> > >  
> > >  	ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
> > >  	if (IS_ERR(ref))
> > >  		return PTR_ERR(ref);
> > >  	key = key_ref_to_ptr(ref);
> > >  
> > > -	if (key->type != &key_type_fscrypt_provisioning)
> > > -		goto bad_key;
> > > -	payload = key->payload.data[0];
> > > +	if (key->type == &key_type_fscrypt_provisioning) {
> > 
> > Why does fscrypt have own key type, and does not extend 'encrypted' with a
> > new format [*]?
> 
> Are you referring to the "fscrypt-provisioning" key type?  That is an existing
> feature (which in most cases isn't used, but there is a use case that requires
> it), not something being added by this patch.  We just needed a key type where
> userspace can add a raw key to the kernel and not be able to read it back (so
> like the "logon" key type), but also have the kernel enforce that that key is
> only used for fscrypt with a particular KDF version, and not with other random
> kernel features.  The "encrypted" key type wouldn't have worked for this at all;
> it's a totally different thing.
> 
> > > +	} else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) && key->type == &key_type_trusted) {
> > > +		struct trusted_key_payload *tkp;
> > > +
> > > +		/* avoid reseal changing payload while we memcpy key */
> > > +		down_read(&key->sem);
> > > +		tkp = key->payload.data[0];
> > > +		if (!tkp || tkp->key_len < FSCRYPT_MIN_KEY_SIZE ||
> > > +		    tkp->key_len > FSCRYPT_MAX_KEY_SIZE) {
> > > +			up_read(&key->sem);
> > > +			err = -EINVAL;
> > > +			goto out_put;
> > > +		}
> > > +
> > > +		secret->size = tkp->key_len;
> > > +		memcpy(secret->raw, tkp->key, secret->size);
> > > +		up_read(&key->sem);
> > > +	} else {
> > 
> > 
> > I don't think this is right, or at least it does not follow the pattern
> > in [*]. I.e. you should rather use trusted key to seal your fscrypt key.
> 
> What's the benefit of the extra layer of indirection over just using a "trusted"
> key directly?  The use case for "encrypted" keys is not at all clear to me.

Because it is more robust to be able to use small amount of trusted keys,
which are not entirely software based.

And since it's also a pattern on existing kernel features utilizing trusted
keys, the pressure here to explain why break the pattern, should be on the
side of the one who breaks it.

/Jarkko
