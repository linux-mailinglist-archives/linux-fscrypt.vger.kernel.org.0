Return-Path: <linux-fscrypt+bounces-1290-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPn0Ajcaoml7zQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1290-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 23:27:03 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 948E91BEAE9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 23:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9C6F83049571
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 22:27:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3E3F478E49;
	Fri, 27 Feb 2026 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMaNTNyq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899923624A3
	for <linux-fscrypt@vger.kernel.org>; Fri, 27 Feb 2026 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772231220; cv=pass; b=AN/HMboEjCftPufZUo816KOuW+d65gkjg4HXGGYiO6Jwm9UVEQ0hxMbwvAQIBbkgCeDLFfIy65f+k9zj+lvcO0l1HhpLsq7B285dsMKBtP7Y9KRisy91VHqbpqxf9Rpa99dT6FPkqsEQRF9QvLE1rXoBAUs1PzaRaSn3vXVqWeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772231220; c=relaxed/simple;
	bh=HEc6W3B3KyQ3qcm07Kteieoys840RWPWeAPSz2C3iaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tLdejs//Gwkui5624dx94BY5xlzzu0U8tb00FlZugd3ueW5/oDNqZi9CyHEa/kdtU9zUZqhoxPXArlduhdyHPWQvwAPSWnMFOmAbng36Q/TUH1D+e7LBizjhdG9ujAJJTj6ZAV9sJ24iwHCmvuVXqEiZNyKQN0kpnCvxDNGFqrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMaNTNyq; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d4c65d772cso1866529a34.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 27 Feb 2026 14:26:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772231218; cv=none;
        d=google.com; s=arc-20240605;
        b=QcsZIuqiWAhZpFSsCYmeG61oaP0Zzgv7OeTBkNtQuVbm2R6wt4PHT6H+sD/NIsJknT
         jc8/9oeI3+JFjCAqpVCzsQZMZtNfeTZohgFL7qVbqYb7InTT4eRxp8OVt4RFsrm23GF0
         Oh45Ea51zz9mNvPq0uAFTnL8+xRUoEjIadoOMoxCivp4/e0GGNVKrdBuWDdWfNNFhVB4
         h3eQ0UWIPzL4Q2l1EChqUbQT+q9698W1/wYgjL4go2GuqS1JQHShSxNG7jpD4x7gR0nK
         3K0Pog8JRvVSBwfp0f1My7t7btSxi2dkr+QaDKa6FnWfSx9gJyloSneEgBUw9AIaaM0w
         nSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8eMIGQgXwUC3hnpuRTbobexlYQNAdEuk/XQ06Fgu5Gg=;
        fh=PUdomxGbkEqnhv2TeDNXk9syG7TlSC3tgSqeh4A9mFw=;
        b=BchgMHitqRietiobRGl7NE79XvW+CPpmPVIECjUxtehDdcgeDbWtAjXJ5poR2cPFOX
         jrfNx0RUGCjz8e6vA3vUEj+K9JqQrj/Givqb6dVcb/XrPZa7/M9yku09P8dmsRbYiKrB
         gXnuhLYc4+M+Eh64HnGOsVOqeVVwomBvQuSIiLXpuhv+OqlhBq/nOwrVap1YPnBJSkQq
         n41bMLWsVlVjAAPEiN+gYTtCtA9k4+c9EU53IAxqnTdgyPDMfSxXN5KcRiabGnKBNHLd
         sBH5jveouVwKvgpa/9N41wx+51lRtp20luFyfnbNqejDtOaQRqcjdvv5c5OR/3d4OeCH
         APUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772231218; x=1772836018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8eMIGQgXwUC3hnpuRTbobexlYQNAdEuk/XQ06Fgu5Gg=;
        b=FMaNTNyq5P2L2ZOkCx08XVH31ftCQCl//RJJ8Z5O7k1OA/ou0pGQpNJbIqWkpnZ8Oe
         vZVoskqyK4ickPDXrLzAxRqbxkgeJodI/gOFvmb0EH3Xf9lFTn9sVoJdZ5hpNa4QPRry
         tszjE4/VFQAYW8cT4I5YY3V/FhBFENjQ+jeccGBEkGPapY1EeL/6wTeK3KpszC7oMm4y
         la8vrr3WZrTNxBasHGYx16i7IK4UiUYtlHC70kghTEkn/fCeFOF7Gn9y6NRfIVDrhgtS
         1MRgAkx/zyHpkOlBbc3mW2GdNF1OQdLV8wWsCE2YkVWxuX5W1mfITHB99EDZZrN2imdk
         CZWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772231218; x=1772836018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8eMIGQgXwUC3hnpuRTbobexlYQNAdEuk/XQ06Fgu5Gg=;
        b=jTnWGywPmxQj3q2kbS7zeGcIgg48qoLxPrcQHHoP1Cz3vC79jE5AU2d4OjcbCBdzwV
         7DsqiKUqq+C0/Ts8RWrUAtQOBYRfejKQw+dSzO1PfIl7bNpHYMpsoMotShamp0qQxpN+
         ZEV3ZzUQ02L4eHy0xw8PdenJftpRIJ6O0eH7Zjw6Splfycj3rlMl/pO4cRdOAvChqVbG
         NttV3Toh+18p9nsJg4ZDC7so6rPSld2bM25mo63tkVao/pUDCXJ0YxpQnm0ep6V5WZ18
         SahNxb5k+qywN2+tFZeZpSRJmJzp/LWDRaOjK8u90DobThwheeZ0S0GyWYxvY7n/NK3s
         iZ+A==
X-Forwarded-Encrypted: i=1; AJvYcCWW6Np3K2V6GevgNdkovZBMoPi3ZtB32xVsJBzjcL9YU1mGj39BoFbYVw9NfpiCXEZFL0tE5Auqmw1S6A7A@vger.kernel.org
X-Gm-Message-State: AOJu0Yy38uc0COLJAsSeg+GiR7vcRGgfFy4lGY5rj2oruNxXZjxqYyd1
	PvpnPehOt07ZXyWytubFge3UruDpzK2flWB0Km96pVVaSjIu2N8uqKBisBLbm5zP23Gz9yXvRfH
	oSpH55z18oAMRNasEE3NEpseIJRUzXg0=
X-Gm-Gg: ATEYQzzXSkd07aW0lbyU3TzRcWQ8KSEetqqF12n1q7e2ZHUZ7nOnBeHoUfa9adSETIN
	TD0wpmC2Pi90mR6TDgQTF2Pfx5GyxgjP9DTAL8nGNiv0wsTXwbhtdp6bjQi7SpcDymqNrB7wP0U
	g2BUvzK+PoOJaSLbb3FNvDECalSitzdQxnRrnCwhUp7bi0rMQaM0flNZsznO5qsqAmo8ZXT0XAg
	uG9UyI9gmFgfYQxV4F8vQMf+ddN5Dur+yxUyA0nK2slLAbnNwYaYAsP6Ych9S06MA4jV0ZL72eZ
	gA7nP9Fwym9L53vQPUvpCTQRgRH5wSBNDqiJcyDIXZVkE0TiA19q75dHta/ySaESxcsVDgItZ+S
	m5s1rpJWgF5xAvokezNTnBVlaONJCBcSnqRPk4w==
X-Received: by 2002:a05:6830:200b:b0:7d5:96a9:388b with SMTP id
 46e09a7af769-7d596a93bc7mr1340172a34.17.1772231218567; Fri, 27 Feb 2026
 14:26:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
In-Reply-To: <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
From: Neal Gompa <ngompa13@gmail.com>
Date: Fri, 27 Feb 2026 17:26:22 -0500
X-Gm-Features: AaiRm52Usi2aZHq1dkEfq0px3QfzRlx9VQVNLzVN9g7lM_OjE4pL_WS1HE1bAk8
Message-ID: <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Daniel Vacek <neelx@suse.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1290-lists,linux-fscrypt=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ngompa13@gmail.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 948E91BEAE9
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrot=
e:
>
> On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > Hello,
> > >
> > > These are the remaining parts from former series [1] from Omar, Sweet=
 Tea
> > > and Josef.  Some bits of it were split into the separate set [2] befo=
re.
> > >
> > > Notably, at this stage encryption is not supported with RAID5/6 setup
> > > and send is also isabled for now.
> >
> > Where does this series apply to?  There's no base-commit or git tree,
> > and it doesn't apply to mainline or btrfs/for-next.
>
> Hi Eric,
>
> My apologies, I did not explicitly mention the base. I'll do it next time=
.
> This was based on for-next @20260127 (commit 80dbfe6512d9c).
> Since then, some changes occurred that will require additional
> touches. No wonder it does not apply anymore.
>

When you make your next revision, can you also provide a tag or branch
that I can use to grab the patches for testing? It would be easier for
me than trying to yoink them down from the emails with how many of
them there are...


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

