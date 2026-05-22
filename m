Return-Path: <linux-fscrypt+bounces-1608-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGK3KIJHEGrzVgYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1608-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 14:09:38 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E00C5B395E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 14:09:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1CA0630BB2EB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 May 2026 12:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F524370AD6;
	Fri, 22 May 2026 12:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ykt8rEYk"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C32D36D9E6
	for <linux-fscrypt@vger.kernel.org>; Fri, 22 May 2026 12:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451245; cv=pass; b=oYurUVKHkVvpiGg+7ogAPeAvnoBMiq9zMNu/5BJyfxK39r4YFn6ori7Hz4LxnZKA9sN/K2YPS08CJ2HYxx8z8X+166Uv9nMyBgrD61zjB2Ow8kMWy2DBmyHa2sJhQeOuDN1terM+gY8Aup1pflY0A1B8c81nrZO6LGyMizNf5So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451245; c=relaxed/simple;
	bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gl9WULGpCAxA/2IWavmElAwGHWVDW1USbWewM63qikwwdJdKmF0YeRsGc1eTg8KDjpru7WwbBDczl8oPHj17ZvnXUzql9P0nNMt6rIwno86vRQWflF/PtYzxTfnLF/ALLJNnw9EJO2qZ8qoicFmGeSN6BTnGWZY2UD22mEAuZKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ykt8rEYk; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48ff4f8ef0dso77156245e9.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 22 May 2026 05:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779451240; cv=none;
        d=google.com; s=arc-20240605;
        b=isvWuTcmjkoqOiQBjqB6c9bPVt4TIFN3xJ8rprCA4K55aTmRcigB91fWhIobv8TXOq
         tNGcxbkd9Zx2u2uI3/bZXSUOrQcb6zMJm6sZ4s2yQ5XmDLijor4iBSQ/bnjEx3k4DTZx
         ieDtA7iDbyf2V0ugw/qLmvFNnF1yU6iwbad6tn9UYYJX0uMbJv+ikLVEkLqvCtpbtreQ
         Ug9NFUL+M9RsbzFBMxkgZRfPsvXQTADUaQPXHbYe0zhasWaxPvBjo8w2C9lhr+QiI351
         VhNj5VMXi95GBdrUEGCKc6ZKfAqNcwPlucrP3xed4XlTqvLcImxMLg2y9kzeV1pRt2UR
         Qumw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        fh=I/5smj8CVNsaNIaWvirKUVajLmQ3vCYAnhKhvtCNuJ4=;
        b=JHsS126qEsXspLSajc6lPl4Ddr4APfqA2/iKw2GlGZeS1dEEMxiiV5BPOUMfn7kD9P
         2gw5tbB71a3g3fhb27STIG2DlJsB56OP6qAL1TS+C8jVuTI2U/WbJHGiYhr1A+k/NVyU
         JwGcnbLcbuBzQFjThj2PLOVd1W7xJkp7mHlqSyGUJR1zAmVAO4k2oLTtPLcL46BIVogv
         Dr/xVsDYWDZeiO0PScGID6U+BFd8b4zREr2X/vW80cGQE3NH1OGOTz89m5RYZbD+Hbnf
         z0dKjXqBiGX68cMSJRx5axuW0JG9efrCRfm0q8OVWShVlRPnUzb/8qmzNMaDbnogg0v/
         XjtQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779451240; x=1780056040; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        b=Ykt8rEYkjenflb7/tF/677oVnGU7WtpMdZ6ISzY8xTpgUY0DBn1gluzaFRb00NlMLR
         xLDc2uU/A2VibLCdHftPzNRSQZiWHxIYzJ4aQ1G5as7cVH2ESs677x4uEeP4ABQ+1Xin
         d4fW3zhIPaQpSB6A/Smoclf2pUhu5oqV5TNR3Oba7JEoc4yS8bPQwCyHBHWSPaGRXf26
         OeNrIecdYr6J1T+7NjCAAin82H3sBtzZsbxOWHbmxI5BlgCRp9i/ExfBOYR7FLCB7bxG
         QB8PG8BVHWtlTgt3buXhNjQpq50tGP/dd2RNRtELocYHswOIPfFLghpCCuF2TLaKJz9b
         bGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779451240; x=1780056040;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xlJ7dUMljsBSIjHOpjWzMVXJP09oDEZOhL9iMhou8is=;
        b=T6gSZqTv3NESOjJ22lrgWLS5jq1eOYOxhHjpii186WMdkmSbrZYl/DuuDZQ6/IJr3n
         2L6b4V1QGhaU0H3dphjnvP+LLgdCqGwMoZ1e7JxUMVcI+KpVsKFVjOwcsvbQrDIiuhXI
         Y8GAB/B82eBb/pys9096rE8PdKAY5B4G3MKX4YffFjp4qpgPPWgMPfucYYKPJm5JbhE/
         fz9OFxdIQVCOXBR8njShe5Jc2l0yAAM5UZ/+cBBn7NcSlQMoDdx+S1HlQAfxXyYM21zX
         66noELg0I8h/wZKlJ6cBkUFtvsz4G187bq8dfV1Nfs2EpF55HRdKmkQlmM7Z7pfJZY1N
         FB3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/caQpvE9rwQgyeu83eRQ3YP9qWY3D4zAXUxytVbOIAqLsirzuHUE6Ngi3Z2exL0D7sgraU4TWLcEy08GLA@vger.kernel.org
X-Gm-Message-State: AOJu0YxLM15eIgzfa/IVNjXDQ2nAlDQZUMGorZ3lpc9XLETl7X9KVa+u
	ZTY2fHsPijFYyGShSvw17XUVKgy5iFWe/7iZ4qi9aqcuKuDeZNqtU2890mJXoLc+WiNTwvjokxp
	+sZuwP9L9XZNFLnDRLAOuwygbTx1AKQ85xuNanTu8yw==
X-Gm-Gg: Acq92OHRJJ3LNMWIIY5QGCGM+yMXmsaluUOdmAFI28aMBwY66D3xa4/q6hsYn5c4CAe
	+Yqb4uoJBsqp582EFzyaIoOamBbtCgD8MpOzCDcRUZC8mC3oyt66tqNj6cLYPJ48E3uh0tdlFGG
	Az2/R1acW08zwomUqSFQTXTtC9Gt06BdJQ8ttwCN+i1Ft7fE5dDJdgWuDO9GsW1LIASdh4zmA+C
	8HWyUOBgHHQ/q5FpK6SjpNfqEnOStVur9FRUBfMxjYTEPvvD0+u36gqwveNd4HhAVTlGfIoDksl
	BoBuSH06Sc/WPpHEpf7C+8F+5lFxZRmylpCSXNR0DtsFMc5lYkTUUe3BTf3T6hjj2HJzAY1VirB
	cdJ43oTFfiIkDncE=
X-Received: by 2002:a05:600c:3547:b0:48a:7b55:12a6 with SMTP id
 5b1f17b1804b1-4904224b05emr46591285e9.0.1779451239711; Fri, 22 May 2026
 05:00:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <20260513085340.3673127-18-neelx@suse.com>
 <ahAfvPa_yl6AKZoW@infradead.org>
In-Reply-To: <ahAfvPa_yl6AKZoW@infradead.org>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 22 May 2026 14:00:28 +0200
X-Gm-Features: AVHnY4L-B6zCGkAkTyjhybBzvlntESV7mYOAACpjsS69rRBft3tIVAlMyDpZ2_s
Message-ID: <CAPjX3FeoGzNOBnmY5ie34irNaAOZiFqV_Ccf7dXFrZJeUXh8PA@mail.gmail.com>
Subject: Re: [PATCH v7 17/43] btrfs: add get_devices hook for fscrypt
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1608-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid,suse.com:dkim,infradead.org:email]
X-Rspamd-Queue-Id: 4E00C5B395E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 22 May 2026 at 11:19, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, May 13, 2026 at 10:52:51AM +0200, Daniel Vacek wrote:
> > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> >
> > Since extent encryption requires inline encryption, even though we
> > expect to use the inlinecrypt software fallback most of the time, we
> > need to enumerate all the devices in use by btrfs.
>
> How does this handled adding/removing devices at runtime?

When called, this callback returns the list of bdevs opened by the
given superblock. If devices are added or removed, this function
returns a different list.
In other words it always returns a valid list.

This is called from `fscrypt_get_devices()`, which is called from
`fscrypt_select_encryption_impl()` or
`fscrypt_prepare_inline_crypt_key()` or
`fscrypt_destroy_inline_crypt_key()`. All these functions walk the
returned list and discard it immediately afterwards.

Note that with btrfs at this point we're only using the inline crypto fallback.
Is there any particular reason you asked this question?

--nX

