Return-Path: <linux-fscrypt+bounces-1292-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GB0IHRugomko4gQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1292-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Feb 2026 08:58:19 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 970681C1528
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Feb 2026 08:58:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0799B300A253
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Feb 2026 07:57:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A488D39B4AD;
	Sat, 28 Feb 2026 07:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Vbt4Wigh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE24396D2C
	for <linux-fscrypt@vger.kernel.org>; Sat, 28 Feb 2026 07:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772265441; cv=pass; b=CiU62RPJzkG128v+n4gEGl+RjX4DcxoR0H6yH6VLSsLbptOEgqrPK5wwFh+EZYVeuvVmqlC39kT1CYIY41UcGr/mIuR1zJiymjhioAR8Ckh2f9mmtEQ9Rc0CU+RM8+lP1mL7TIQwrfKonAGF1RygDGKKPUcesB0jhv5r5rf0NfA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772265441; c=relaxed/simple;
	bh=6PdqOpfgB3YMOOlux3bduC+ojGyQw/085BF80Hxj8Hc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CRSz91r20v0WRHq0d1kE7XR1MZ3O1IAJrP+ZvGYHcmcfngJ5kE7jdE8LRxvauBuLsgxIBRTXWNmgFitQqYzmOc6h3sser9k7sgVt/fSradGhZUZnhvBZXw1959MRemU57lk6lObF9mcLup8VOWcglgwMHbpUfFQCpEIt4a1/xiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Vbt4Wigh; arc=pass smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4398f8403edso2192735f8f.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 27 Feb 2026 23:57:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772265438; cv=none;
        d=google.com; s=arc-20240605;
        b=HaVk5j+wwdiPghs7DICgVvACdh4UHcRCW7/WRhQTSSh6K+ldJU2NDcq+88i9MWjm+V
         eVHYI8Mq74UEW2xFZtZr9gP2hjBfgsPUAV1BedgSY7IHIuBM7SslOSEbr/6h/SttW0e8
         TEM6RbJ7wVvsi2TTSfmHJOydW4oHO04j8EIggQsz+UhFeFBvx8NouHoqQnisiRkUZpxE
         BFu76/TXFgIIBo002dx5DgtSC82MOXZOJOmk8XkVtfOBcdzfYnOsqVLw6cUYZ/ETqQws
         kjxb6eWHxMPMWSQGyMEYiaGnWHyKiQMolKRCbyXENWh7v5QWNZysvFlDZwzT9PQ6hFVy
         zHjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ClMAoK6WITuHcNfY7J0tERhWJlZRJZGKOpSkq0A50FQ=;
        fh=nee0FpqxoDynj34XRFjrP9ho7SbKh8UGFl9qO9nw2oE=;
        b=HkInzbGocN4Fld/ST1rMCXpxgpnMzvfXnYazW/tBa/Pzhe53CheynGr8PRCxTC/QOf
         rqpeX3hdhToVP/pG8EVk4fnarrTmjVChJ+nEyxiIAW0xy+seEzu3hXblp2T2dU289y2j
         3ZPQ4v1Vv0RFscm5KjRgtgDY5QIjUIbXiMPjRXFb0PAkESehThvnHC+m3F5rQu5npipP
         Hdc7QAyTA441rUvMl+m8OrNT5WsXDVvfBg3Fc+Z3J3NewsPVkmyYVyDzCld3jOxPn6ap
         7WfbZXr87Cyu5NHQFTbeSVdkqwocYmGzrlWdab6YTAExRrCJezVOXPEAfWM0VkRRGFns
         3mcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772265438; x=1772870238; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClMAoK6WITuHcNfY7J0tERhWJlZRJZGKOpSkq0A50FQ=;
        b=Vbt4WighTUGP+oXtWsfyZsltXqfo6+swatGLEdwqw8HOMXUzJQ7k2UoUQjxP//tcfj
         s9N+MX9Ipxw83tnOHvudb4TyAyI8FCDUPR2tK+Ewh0j+jm+4zYd6e/XJROtE2cv/yD9b
         K/opeqNAkvON7Vq8CZn1ZWZXdVSzAINrdtTL1StdkB+x9FID+sQAv7ETgvTqqWLM+JwU
         Z5L4Zc9WFQD7ya26sb1shoa/LuLzx9QleW6EQXT34Dcdbli4nZbhzeLdOWwjlblpCmCU
         jxqp+lVO2+NSumQWufcdTISg8r8yyFNBRbagOw0pXNQ+TDMb5gd+Ee/lOdniQpJZyfR3
         4Ejg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772265438; x=1772870238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClMAoK6WITuHcNfY7J0tERhWJlZRJZGKOpSkq0A50FQ=;
        b=VlebMF+/D6aogZwL0UizpsRET/oRf3Y/yyvPUzhX9qD3xTXUvojafvwNQSNlUGEMTP
         gjOirr7I1VQceGIkTJ/VtcuDsc/i1YuI15o1LBVjyBhu9Vsy/9NL5k763ws7iZDbUyWs
         Laa1xQmc26c0a2dCPeh3GQTioEp6GaMaJ7/HsECoEsL56WmuX9LPpFQSTlCBsPDF/oeH
         WiCBD9a/iKIsXNFLSo6/7ibD6CAJ49TrAlbtceuurPbuDDHDzvMafZ+yw4wle2tYk4fd
         s+v2xI5m6WGTtxhI3BfrkE7Uc206NBVoyu4ZXvg4B6oP7lmnH73ewiMxaaIseP2w0sQ8
         JhEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkpaA5xuD/ihPmumXYnu7bIG4eoQxmqJq2VudDubxQwJafkw7c31wp2U0pUFOwNVb3CsnPfKzXr2OIWTMx@vger.kernel.org
X-Gm-Message-State: AOJu0YxV+2vaoL54gUjZ9dSra2j0RZQZZIBZdVGfhJIua2a7Hd9IVcyp
	N4nyxEJUeEHFULodXpxoPO8ryXD7kZS6VWt9+xNFdmqMTydiUomSqN3U2OWsMGu86YPdnv5HZeg
	hrU5vAZxppLUIRJhPvyzW4oF8JOznK1zerB1S3LUbaA==
X-Gm-Gg: ATEYQzxWNM0bqFQj1t1TX+pM93h8ymNty/+FadynvhmmKwjt4P1kALETvc2tYOL6iVP
	8FeIfS+40A9KSUXMZvUy+eI+SyCS5kskLgRm5gUoLs9f68EiaMrf7oLyqzMhveoAwNM/UpYMzAg
	Qi9s3FrTRn+x9FbKtN2cIxh4iG27BgnenWnnm1zdsyb0X8YHYDq4qhpcxQ5wpV5DgTfAwRtioMc
	Rt1R2BCcdF+WStHsmokUr43r+U2Qkzd8sPjW0WEWBr5xgicpJaDBAJWnx+Fdif8lAwN1KEOGvKl
	iMtyc9xv0ZomUnIg6I2CqpCjEUGnlKu7KaQJ4cbhG78fMiEhATPQCzEyxrnCbbWazKaLwN0nLKp
	C1jD8
X-Received: by 2002:a5d:5d0d:0:b0:437:771b:26b with SMTP id
 ffacd0b85a97d-4399ddfc43cmr9839007f8f.26.1772265438557; Fri, 27 Feb 2026
 23:57:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com> <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
In-Reply-To: <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Sat, 28 Feb 2026 08:57:06 +0100
X-Gm-Features: AaiRm50fp_4Fyhos6nvwQgL-IlBc5T53PNbqLb3xsg-h7pbpyOz2GPW0NAm_PCQ
Message-ID: <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Neal Gompa <ngompa13@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1292-lists,linux-fscrypt=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 970681C1528
X-Rspamd-Action: no action

On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com> wr=
ote:
> > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wrote:
> > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > Hello,
> > > >
> > > > These are the remaining parts from former series [1] from Omar, Swe=
et Tea
> > > > and Josef.  Some bits of it were split into the separate set [2] be=
fore.
> > > >
> > > > Notably, at this stage encryption is not supported with RAID5/6 set=
up
> > > > and send is also isabled for now.
> > >
> > > Where does this series apply to?  There's no base-commit or git tree,
> > > and it doesn't apply to mainline or btrfs/for-next.
> >
> > Hi Eric,
> >
> > My apologies, I did not explicitly mention the base. I'll do it next ti=
me.
> > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > Since then, some changes occurred that will require additional
> > touches. No wonder it does not apply anymore.
> >
>
> When you make your next revision, can you also provide a tag or branch
> that I can use to grab the patches for testing? It would be easier for
> me than trying to yoink them down from the emails with how many of
> them there are...

Sure

--nX

> --
> =E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=
=EF=BC=81/ Always, there's only one truth!

