Return-Path: <linux-fscrypt+bounces-1555-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGj8JiXA6WkXjQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1555-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 08:45:57 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 36FE944DB39
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 08:45:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A38033008D6C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Apr 2026 06:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E87F23BFE2F;
	Thu, 23 Apr 2026 06:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SzKTEfuc"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361C039D6FC
	for <linux-fscrypt@vger.kernel.org>; Thu, 23 Apr 2026 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776926752; cv=pass; b=ZRKrKd2mPxcyC5WSTDrUQfZ6FNWb69uz7VbVjz3+RPfS8nRW0qHg2Y4Iz8N1YwEuGe2V9W0nWw6yI+J395WcUhEXx3dGGykkMsefb9tO0Z2XPerqWUooo3BHxAbILSeI6GvfJImp2TFKulGlTbuft34YV886k7OAvLxLAQcaDgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776926752; c=relaxed/simple;
	bh=VoW/jBNfb743v0Rg9HRnbEDd8rmyiFM2HQb/i/qQDkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jMr5GJa4W9+4qisf+9jdfp0Y/clxAattgzsbwGIc9wUDG+f0LsaLDf/7i2yl++utwUNpb4hnaJ8NjM5+D5aGj8YNcAxTd8Ssby6SlDwezf5j+SOon/gpIFTG/XjWR+dMcLtpJIxJL/2r52XBZxA1tHL6zTiUCR+2NDtv2nLtOtA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SzKTEfuc; arc=pass smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso64148875e9.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Apr 2026 23:45:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776926749; cv=none;
        d=google.com; s=arc-20240605;
        b=RmZIFv+ZjK9quf1wAQaXRzH7etGfnyx+05p6nw7N+5CMImMWO2oLcKsjyPmKK5cJvs
         rnceymteniYftwx7YfQ68BzYaXjY8Snr59fCU6OR8xHN9iDxOgoTMTjdrsddlmKyCO1d
         MRBCMlfidRxCipz9EBWzi4twqhbuuwuE11Bo67hh/6rOIm8ztHkJyF1MQoSLKIyG8lTG
         qhQIWrDKR8fW3IO+jHBjS6F+7pvXh+9hBm1ph8fVhFr7Lx7a9ujgasu/9IoIrtz9DT1N
         9NnFV32r94N8hSYo++woCecA2YdqesFpdoWqQoLBbeLUKP+WT5BhiXYs2acS44Zmx7FZ
         u4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        fh=Os8eZkgcJnuVtNpbxuXSRTvrSMkJfdRX8WlM+hjGAAU=;
        b=kWclT6Dr3ZswKCFTaGhv4l+l0cuH8WEz5ZMkYlq1jXWtzmJ03rRVjFyFqzEVPaLB12
         RYc16K7Sm5+u3nK4I04yG+QPE/oIw6Fsq7tr2VXWx5iyzQogW6KasCPHj4Zrlv3RS/hm
         WJtcAXsOGb2n4TJixgFlW9yQ6ajBx0CV0DIcDKea9EAlOnMq0BDq41AfvtR6ZCYdvhu5
         zvBnpCJkjXVhQWlA3iO7TjsxsL1kCxp4u0J9GcZxAX6EMQmHpY2HIXQ3duScy13vP3T+
         cXc8QhmdFi5u0HkDSHGld7c6exdMTf/+Z+Jv6lTfrR5Ig5Sabr4C4vWJMD6PKGak4RcQ
         sVkw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776926749; x=1777531549; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        b=SzKTEfuc5t7Yfm0cnYEKYxlnYEfVvHxu5qKAkZ3DPCnVsknAYgW4TurCBPDZzvXu/N
         XQvs5+VPDq1orOE5HecPECrpLY2//2RsDtvckuql3sjOyT3Ma5B/tkxf81dVrOap733M
         Jdr2Ec4qQH+wpEAn7/ZXnRfXAugH87Yi40LV94YgI/cWIu7GKZodhrodWh8ZmG/VaInS
         1ArSpjSaIJ0u1Z6hr4OlTOKLmqUCb7GQ1LHjXYp4F0hux8fvM9rBYaWzA/HkLmyTyYM1
         gKxpTtI5YBmL9qXkOyXbrGDBV/JUwHNscB/hKFgf37tnjy87zYLRWKehlIE+5HfA9FiX
         D1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776926749; x=1777531549;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFx+EzwA27+TMrhv+NVPiNfgiU3/L9VD2VlgqAAxpWA=;
        b=kkWBpMGBygUABxYTQ10jmSB18SkFpdy+fAAr5Deyzmm1aLT3wh2UqdtdskVFngbpUn
         wTbs/D7zSdb1Bni5XPBl7nd0+/L+XML2vTvAKk48P0Yp/4t8jOqRPFbWpZydF+sPs27t
         bXEcgnqMN70PPbK2NdOodsDoO+yDU0QNjVbPSO5BLpiK6tU2+x11Lvt1DaaEO/0dtyp1
         7pg0Gu7Pgs4OQqxa9BmoBtFhVPBuhoUQ7Dy3m1oXHwCOyiuP25VLO49gVLXk2es/JlC0
         sFNMK4Ni3T9Iuw8MqcqbNik/ZqtLxyzOWczeiCDFdaH5RlNPjtnQFiJ+y3netAvoOPtK
         u9yw==
X-Forwarded-Encrypted: i=1; AFNElJ8FF9jueRYWViErtjgKy+OM63oUpjtxMjXTy/dk+wivpDsEg+NRooGItf4CrgUwTpNO7OEugJ+IPRwGmecO@vger.kernel.org
X-Gm-Message-State: AOJu0Yy62cavdDYrBWYP+ygE69VUZWWdxz2o9Ow0cd6gQaCqSL0+lu/o
	Yi6ayCfzKmfhZrpYKCtUcW6tv0PRww6ECAb2VE+KAHe7tW6WN0iQEtRSD6UfZXMccaJ2cKMizVZ
	UxTBI2Y4jWnGvJIlOs+mKhekXTfT6vZ4ab5G7l2vK4Q==
X-Gm-Gg: AeBDietwZ3ktPi7X1ATxJpTU1hfMECrLCoUzQXMLQp51aCAJ6xBzPtju07XR63FUTLe
	pMKsbc429lYZbNkQ67NpIlJDv8lirbdgepGChMhKw/bs+ot7evFYztx4zdvTDzq43+h9jBNLuiR
	M7GvxyhwrArJEp/EATMEikOC9VUug5ztWIboiGZjgrWXEPf8x+yuRA2mGrmAmKFCxEGL89F1Gsr
	ZG0hg3VybCxLQIW7bCw97bDIcRa4xQF6C1Dobe0UzHollOuxF1BtMynHSAydtmBYoKUs/OzdQl7
	DCrFudumtn4Mv/YQSBOKpGw78hyEvhhFenjYkP17yJHWVRfJRroY9kX9XzvGE0mhAVaxGlf2Pun
	Flum6o/boVNBX2WoOfbJ1EKk1YQ==
X-Received: by 2002:a05:600c:2256:b0:489:1927:5c0 with SMTP id
 5b1f17b1804b1-48919270787mr172142805e9.0.1776926749488; Wed, 22 Apr 2026
 23:45:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260206182336.1397715-2-neelx@suse.com>
 <20260221221153.GA2123@quark> <CAPjX3FficsLf2QXFU70sR6PN7h8rj5opz_wntLm+Acd3YLvu+A@mail.gmail.com>
 <20260422225310.GB2226@sol>
In-Reply-To: <20260422225310.GB2226@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 23 Apr 2026 08:45:38 +0200
X-Gm-Features: AQROBzBwq5ZRAPxV2aicYDXhz8eGzSNuCy0WrJTFESLNDvoGYhORBKakn6zpBls
Message-ID: <CAPjX3Fdg=4gMYZQcfmG00ucrtheUW-UKqR0yGwfJ=cA3BzrRWg@mail.gmail.com>
Subject: Re: [PATCH v6 01/43] fscrypt: add per-extent encryption support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1555-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 36FE944DB39
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 23 Apr 2026 at 00:54, Eric Biggers <ebiggers@kernel.org> wrote:
> On Wed, Apr 22, 2026 at 10:17:40AM +0200, Daniel Vacek wrote:
> > > > +/**
> > > > + * fscrypt_mergeable_extent_bio() - test whether data can be added to a bio
> > > > + * @bio: the bio being built up
> > > > + * @ei: the fscrypt_extent_info for this extent
> > > > + * @next_lblk: the next file logical block number in the I/O
> > > > + *
> > > > + * When building a bio which may contain data which should undergo inline
> > > > + * encryption (or decryption) via fscrypt, filesystems should call this function
> > > > + * to ensure that the resulting bio contains only contiguous data unit numbers.
> > > > + * This will return false if the next part of the I/O cannot be merged with the
> > > > + * bio because either the encryption key would be different or the encryption
> > > > + * data unit numbers would be discontiguous.
> > > > + *
> > > > + * fscrypt_set_bio_crypt_ctx_from_extent() must have already been called on the
> > > > + * bio.
> > > > + *
> > > > + * This function isn't required in cases where crypto-mergeability is ensured in
> > > > + * another way, such as I/O targeting only a single file (and thus a single key)
> > > > + * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
> > > > + *
> > > > + * Return: true iff the I/O is mergeable
> > > > + */
> > > > +bool fscrypt_mergeable_extent_bio(struct bio *bio,
> > > > +                               const struct fscrypt_extent_info *ei,
> > > > +                               u64 next_lblk)
> > > > +{
> > > > +     const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
> > > > +     u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { next_lblk };
> > > > +
> > > > +     if (!ei)
> > > > +             return true;
> > > > +     if (!bc)
> > > > +             return true;
> > > > +
> > > > +     /*
> > > > +      * Comparing the key pointers is good enough, as all I/O for each key
> > > > +      * uses the same pointer.  I.e., there's currently no need to support
> > > > +      * merging requests where the keys are the same but the pointers differ.
> > > > +      */
> > > > +     if (bc->bc_key != ei->prep_key.blk_key)
> > > > +             return false;
> > > > +
> > > > +     return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(fscrypt_mergeable_extent_bio);
> > >
> > > Similar to fscrypt_set_bio_crypt_ctx_from_extent().  The copy-pasted
> > > comment needs to be updated to remove no-longer-relevant information
> > > specific to per-file encryption and correctly reflect per-extent
> > > encryption.  The DUN needs to be calculated correctly for sub-block data
> > > units or else the combination of the two needs to be unsupported.
> >
> > The DUN is fixed as per above. Regarding the comment, it looks quite
> > valid to me. What exactly would you like to change?
>
> It's now been a while since I was looking at this, but looking at it
> again now, at least the following parts are incorrect:
>
>     "the next file logical block number in the I/O"
>
>     "I/O targeting only a single file (and thus a single key)"
>
> It's actually the block number in the *extent*.  And it's a single key
> only when the I/O targets a single *extent*.

Yeah, I fixed the block number comment with the change to the `pos`
offset. That one is clear.
I'll amend the rest.

Thank you very much, Eric.

--nX

> - Eric

