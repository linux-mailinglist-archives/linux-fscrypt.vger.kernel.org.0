Return-Path: <linux-fscrypt+bounces-1550-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4C68NJjR4WnQyQAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1550-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Apr 2026 08:22:16 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 36B184175C3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Apr 2026 08:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA3C431853C8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Apr 2026 06:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5970936D513;
	Fri, 17 Apr 2026 06:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Pj+e+9rO"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A9235E940
	for <linux-fscrypt@vger.kernel.org>; Fri, 17 Apr 2026 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776406681; cv=pass; b=Hl0ZlKmZG9uevlhHtgXUFGXIRVcy16U/BVDIplGV+/iqrAvEkwUylKtkO1vdY4Ci04lcvbA/6RtDZgdJ/coknyZNCNzcsLZfH3U3t2g2powpiFCFJV4BBD8z3OjG7M2V6HUemc3UYrh/e44FxoSysnSsqrZTGxL+MCv7t5Yh4RE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776406681; c=relaxed/simple;
	bh=CftPVaHbY/sLZyg7fdjKAg/Q4VVFXC/L3LipqZPWB7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vBO4qaI28SxMy9k0kgqIHWDNPYOJWH5l2sWt2hDu021+2PEbVq6W3l/L3Pdst4/tsezq6CPe2VXuamucoQEkYhf8yrReLHSe+MYtjIz1feQH988Ape3hoILWtQGOrCtoxPpcdDonqX+VEs9+TdidCjRRwmGenDXQUGPA2h77qQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Pj+e+9rO; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488c2690057so2486355e9.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Apr 2026 23:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776406678; cv=none;
        d=google.com; s=arc-20240605;
        b=VJXFUwa57b+8ljY56CrcdIuKyqWKSGLL5Fy02LGjIoxaCxB6py+iTaR7JM2B8PFuik
         kvdfYUZbkglMKkcuJMSZxsOzFWHi3G3cWMPjeTOCC9N6RH+zRiX9IWvOfGUbloxD3WzM
         1ZtMNUQLG160cPo6qtxXIB1Va3Arc6+wsFXCfsOpwQfssauP1PdVy58F+P5Wm7TTRX3z
         +358fiuTf7CSr+82nXkCrOB6srVT7XG2/eTjbpqoeoeK1rERab8EnMbQBCehdbZcl51o
         3rBT9d+UI6gjr39CdSG4UIt7rqfJoaer9MolRm2kvmuFRu6Cd4oWGekAjodZaQ/wfPaf
         Bc7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        fh=aobJhiWiD6Fzm2xiH4+y0FK6stllhWJ45S2JsXHraHM=;
        b=RcHTeckk3w4PNd3YtepOoxSA35Qq1UGfIuTH8GAe/2+RakVGu4uVm4HikR4kgW+pOu
         Eb8hGBdM0C0gvnBaLoJSCQJ8mgwqM6QJ3d954abjj7ihZX2CKLsfdNBFVBoFNfadz9vV
         HxsYIscXdJESnBI+wkCdNvjIu/uFbsrcRYUhijyNsFJHnUFrVQP4o3nFRMIoVbgKonxz
         /EocIdoBLjBsTWqgNCA8yKbLEgfIPpVrjtwGftWe7KQldEwa0JwJHoYKH2xKZ1GykKg9
         FSEho8AzgwwPh+pLsm0epPuct2TqxEuXIG0iLbOzsnkylBXMTgTwzQNBfc+dg0WJBoB6
         FbQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776406678; x=1777011478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        b=Pj+e+9rOGAOsIvl6Lpgw/XMNd0V1JM9H9ggsyuz7i4FaFZnWHAsk/ET9R7IPTwyR1z
         BGgNc4AdSYXSks55nxUJl5xujTnOtC+cZLNlxVQcRg5VV3IU991UcoLd7eO68mD+9qEj
         LZlx1Tz/uWwzc6y+X2+GfwFQkgLdm94YkMxU+a9MiZg8sYY393ODlmgZMATXriSi0D3x
         cl4S3l0rzjuuBSWLFmeBmzHQ5VGXFWWePJZvlbru/0cncC8XDf2Wot0QeKwpq3FNrwGu
         1M+JTuhEpNwzgPkHBjwP9WOfPDRuBY4EXP4YVXKQqjbmATnNaH3b118STCVW63aipeXH
         wUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776406678; x=1777011478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKMEI62h4xeSA4wc4eiWLcZ98YwqwCz1YZcyfyucBNw=;
        b=YbUu7x3lGUJbJFLTcp3awdC6Hq7kVRjCxKnu+CsIx1whpttWtROjNh21B2GTT2PHr4
         DGqYuJCutVNQsls2FQwyovTSyNraSnYs63QtmAuaxHoKnlxrnEyZhjWFUlnrSO2TF7El
         gCEZkBRxCLQqyepHdN13AlaQMPhyT7l9nstXto1U3W7a4/LdNjUqyozMTPNkX5005uUh
         /ulN6oR29cIBNlVvd2dL20W6om3/ljJyuubt3HTo/JjEt5oM2nmyfmhay/LPpnIkdnpX
         Y3RuX3DCpcEe6NnMKojT1/qgCRowLfDbJUlkc5IUdwFqvphY60TaIpZIVoanIvBL0CeZ
         qBkA==
X-Forwarded-Encrypted: i=1; AFNElJ/HZhxsdojaX8Fww7acm0tKuF0EF0JktfhmFuzNHFT4r8xKhNmI2y0PnV/2XGeIZwrV2PeRISheArxCf0w+@vger.kernel.org
X-Gm-Message-State: AOJu0YxkOBCzOMtvB74+0OEoPpxUviWr/MU9XbySHwsDKYz8RZxkK+8d
	JAEg94iDknC9jnb17teSMq8o5RGVO6CEfjK1HLsJCB0LsrkQEB1Jyb04l998SKU5xiP7WCXc7w9
	kfmsZHEOT+ajZjuZvXqaLrq2dr4cXrg2gxObupNheTQ==
X-Gm-Gg: AeBDiespneALeh6on50nmuYHdttXWjmErja/7qQ9Z6u9YdhlAtxgZkfuXFIOMLwkiUb
	+Jy2bNU7vzDoCwV3n4GtFkFZ+94h4UeRkBtsdp888wOsA1YjdU4g47ytIWAeNoB6R4TiH/HCZUN
	LA0q/FYgNCxoHXsj6XRht/2YfjZqaHYUuq4w2TnTXqfQJr+xpFaz2ArfbzGDJ3wad/XR4rk4BrB
	2gwvSYbjjU01VXs95JyuMS8Qz/N7Th0IFr6TLPGrtCdWXCG0Gl5NfXBXgjZcFGA0bucxBUn/rDj
	zrpJPKQ+aQWY6TDLQ0jTRs1dljFR2Bqmb8j4zS/kXlHYrnPycaOF+JTdIB+BqEq60vt9yK0xDje
	EZMoxCupOwWdkD+g=
X-Received: by 2002:a05:600c:8207:b0:485:3193:6ddb with SMTP id
 5b1f17b1804b1-488fb73cf74mr20471855e9.3.1776406678000; Thu, 16 Apr 2026
 23:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
 <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
 <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
 <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com> <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
In-Reply-To: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 17 Apr 2026 08:17:47 +0200
X-Gm-Features: AQROBzCA29DldQaGFY1g3w9X-DRSmkbfRlRBH1HuXznzsTGLXoDZj0AOkLhu9Ak
Message-ID: <CAPjX3Ffen=QZvJLdmudBg8LsTnuTOsq1QvXF7eWJtK0Sfr8xnQ@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Neal Gompa <neal@gompa.dev>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1550-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,mail.gmail.com:mid,gompa.dev:email]
X-Rspamd-Queue-Id: 36B184175C3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 16 Apr 2026 at 16:35, Neal Gompa <neal@gompa.dev> wrote:
> On Wed, Apr 15, 2026 at 6:21=E2=80=AFAM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> > > On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com>=
 wrote:
> > > > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote=
:
> > > > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse=
.com> wrote:
> > > > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org=
> wrote:
> > > > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > These are the remaining parts from former series [1] from O=
mar, Sweet Tea
> > > > > > > > and Josef.  Some bits of it were split into the separate se=
t [2] before.
> > > > > > > >
> > > > > > > > Notably, at this stage encryption is not supported with RAI=
D5/6 setup
> > > > > > > > and send is also isabled for now.
> > > > > > >
> > > > > > > Where does this series apply to?  There's no base-commit or g=
it tree,
> > > > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > > > >
> > > > > > Hi Eric,
> > > > > >
> > > > > > My apologies, I did not explicitly mention the base. I'll do it=
 next time.
> > > > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > > > Since then, some changes occurred that will require additional
> > > > > > touches. No wonder it does not apply anymore.
> > > > > >
> > > > >
> > > > > When you make your next revision, can you also provide a tag or b=
ranch
> > > > > that I can use to grab the patches for testing? It would be easie=
r for
> > > > > me than trying to yoink them down from the emails with how many o=
f
> > > > > them there are...
> > > >
> > > > Sure
> > > >
> > >
> > > Ping to ask about the refreshed patch set. With 7.0 out the door, it'=
d
> > > be nice to have an updated set with feedback addressed...
> >
> > Hi Neal,
> >
> > I wanted to post a new iteration last week but I hit some new issues
> > that I'm trying to address now.
> > The WIP is here if you want to have a peek:
> >
> > https://github.com/dvacek/linux-btrfs/tree/fscrypt
> >
> > Note, I'll be force-updating it later so don't take even the v7 tag
> > for granted at this point.
> >
>
> Cool. I've got some travel and stuff going on, so I'll probably only
> get to take another crack at this in a couple of weeks. Do you think
> by then you'll have a finalized v7?

Yeah, it's on track. I expect to have it ready in 1-2 weeks (famous last wo=
rds).

--nX

> --
> =E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=
=EF=BC=81/ Always, there's only one truth!

