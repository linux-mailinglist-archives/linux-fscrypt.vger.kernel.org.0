Return-Path: <linux-fscrypt+bounces-1548-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFu0Lwln32lSSgAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1548-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 12:23:05 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D98840338E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 12:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 447793028B3B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 10:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0B833EAF9;
	Wed, 15 Apr 2026 10:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JHVfTE2d"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739AC3093A6
	for <linux-fscrypt@vger.kernel.org>; Wed, 15 Apr 2026 10:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776248500; cv=pass; b=CvrL/XzcLbJZ625hWHi0SpneOTamlGcFyAfyYTFAn3egFDORZKYnKFVD+qwOLDA+QllybOaZf6u5DKo2oKKvwJ4Nf44POCWtgev25MfNxDmxCBZPcvZNONjgYvDMe+rcAFqcsK9OPcGoRe54OlpVy/wsxmj1ObIZEoW2IwbQyfo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776248500; c=relaxed/simple;
	bh=Mp45n7gf0bWphbcLLRl8cG/twkgXRBKxmEorex//enk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCrXKzkVdQZLKbWCjBQg8ZqjbnIGeyRJWfNBIDTtj9MMbW23e0c9NZDQELz1HMj8F4tAEnPXRSs2jPQUNYNQ8suaDWl1W0OCaAAcu+Mstan2KJ7FGsaMHEjpoy1cifOrG3rV7iUBbwvAJF9w+qq3xyS2723e+WVXgTWAaGajRJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JHVfTE2d; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d7badbd7dso1560524f8f.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 15 Apr 2026 03:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776248498; cv=none;
        d=google.com; s=arc-20240605;
        b=L3lmzXlz9rCtvRfpYAjGHfE5kFrA9MOLed5NWmq3nPFBjYiFBbhpe7oSDqo+dP3hPW
         ZaOlYF/SM22mUdzuRYXembayBVUFOvWNYDwQifa4KhkY2fcGiG2ygAuNxw7v4t343eOu
         gktIO6xOgXPRLv9vpwVXhwojDxziyyNcOTChVFJMyUOVDiqiui2doQXwjVeG3G1CxT58
         JEXZA7+tz7zxvsnwgPtX0iEbA3AUQnKV7QqxTd0/KL11iYlvc0fb2LWBIPG1NB9/3M2W
         HslPrazzZdYItG+dVq2ddk0Ru52tVJnxqEjfsRL1WzYDwGTZMempdR574Uy1xGyKVEud
         wa1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        fh=QhIxwZP1QRLZESePBJWTR5xxdLtFCneBQAQMatcGNs4=;
        b=WB7unoyV+88aYweGGVTFXtj/ao3vcR25oLnCK6hq9GJ51fLyZfwuw/WR16vJg3RPdT
         NVk5OQOrYfMtZy0LsjEiWpqI0RvM8HXhi5nSJqFhQAJFfnWDygxxGhCNryezaNKy6rq0
         xhM8Npg1uXIK7oCTyLO6yzzq4VTg+IbuBXxdc8f8KkHBAKS6NEk5JhqRJHYdhq7G9BdQ
         Jn88kWgwVxlb6cdbWD8Hp3uITt1Y1IqTrxauw7t1WzQ2RQMixgQMoydPK7wv2slUfU7C
         nWUXqo19BBjT97ZJYDpiOTS+g56JaF/D68nl097MHinIdNwhgKGjRsAz/7fYoRNn2LJX
         vOzQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776248498; x=1776853298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        b=JHVfTE2dXAhTkYAwprQpbt42op74y45gg7jM8KiRePoLE7Ov2U72wArhD41imnii1H
         NzTNXCFcSWbmkgW9FLaw/MKB6cy1QNrBBSi6WDHUQVoFNtv4P62iYMYuk93htmsrcd+x
         JcQy9raiOlbyY/9vGP8iovVI9E70dlG/jAHlbs7+uu+qY8gbtFgiRnaKuxW+FxrPKDhb
         O5LJ3zy9rTw+UL4IqnCKTFvuNfYfrq3zWOS+COqYkyCPNVYsJZffbvm3Y2t16+PsasEE
         657rpRFRP1azuUN1EH+d/XWA7vX3c8ijyZU1Z34xk2yRCz0Z/cX4YyNeuqT07FPiN8M6
         LLzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776248498; x=1776853298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4jJcnoVEJ7leDnc7X0jMMrtOneFaKOo08VlNndQ70BY=;
        b=YJJ7PTBVHizXpRRK7/FaUzhKR3lFo6mfjO3Ys8DTGPLdwIFU1k5KasiH0OIJ6UsWgZ
         FydqvTiSyQCjekS0KJZ92CE6Tew3t61hGQbEY2mUzPkvpg0IAXtJ//cyBunpbEBK2Iax
         F8S+cu6z4xUVv6bM1E5qM9M/dVDu+aNDgPNDXF/Ko9LDA3NFCtIunTRYloPNxNnFnqSO
         Aa4VFFNTzI4soscBB+clFhIK0xLDGi0jYyJNJNcXCuSPvxJr5EWvpWCHc5NwYEPAEPwo
         TM4WgcX024s7e6K4a/X9dGMb3RDWNDjk1ouPyWFJMYaLRp+jnS23tKgrnVPFPri3/Qv4
         p6hg==
X-Forwarded-Encrypted: i=1; AFNElJ9c54T1a0q/oFVpvPLR8+MzvLXXMH3ZElgDx0bZ+Q6WvSidOkTkUzQxutZMVGlcItowHMfoHIzwou0ookCu@vger.kernel.org
X-Gm-Message-State: AOJu0YyE4j2tMQcHG5bJNnPRV2k4b0qES2mZlwphQcH6MUYpm6cce+ew
	gna1hLJJFW4jxNN7Z/9zzsqLuQRUltA9lCoayfPSmIUyTMY2WzFWLEwfMxuQAVtDbyhZnpaFkB5
	hZk7DHKHyaIwrWwD0J83Ni6182dIp9odLW1Af47YLVIBk42YHrEqMG1Mydg==
X-Gm-Gg: AeBDieveBYAnclO2ZSF7Whnmj1ZGTzcLt/3GRUGHnzqRjQ+0RcbjGYb1TfFxbbVTOqZ
	jzIUdzsJgrO3HAZRK3HKy7EtKaUvT8OdN2uR9bHRP0fNCo0qf2uqkXkE5kvVJGxWTfGjhbPRR5C
	pgxLJ/5cxWwCYDvTo+eOVoH7t3Wz881OCfToBBWI2MkN7nZivvQ3NwCCU2rl9MU1n9tKhSYPuWv
	9/7pNabYb5Sj7bfb5nEC6WGFBibNLsO2FrDGw8h51QHu8B23XWGoVZhAWTcTevr3mttbRGcVq/E
	/YLpItHp0INlSkFuNoNaNd/enIRsi6hTO6XxWL5XbwoG6QfFw68TQ6EI7PajvD63QxgqqZ2LCv2
	5oe9ql9P4XvKUT8M=
X-Received: by 2002:a05:6000:4203:b0:43d:9bb5:bd97 with SMTP id
 ffacd0b85a97d-43d9bb5bfa7mr10883975f8f.8.1776248497809; Wed, 15 Apr 2026
 03:21:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com>
 <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com> <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
In-Reply-To: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 15 Apr 2026 12:21:26 +0200
X-Gm-Features: AQROBzBSgMMSXj8EtJPvx4T66kG_rnjPScVsioJe9OwbOT5kODIuZAteSeQn6x4
Message-ID: <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1548-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D98840338E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> wro=
te:
> > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com=
> wrote:
> > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wr=
ote:
> > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > Hello,
> > > > > >
> > > > > > These are the remaining parts from former series [1] from Omar,=
 Sweet Tea
> > > > > > and Josef.  Some bits of it were split into the separate set [2=
] before.
> > > > > >
> > > > > > Notably, at this stage encryption is not supported with RAID5/6=
 setup
> > > > > > and send is also isabled for now.
> > > > >
> > > > > Where does this series apply to?  There's no base-commit or git t=
ree,
> > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > >
> > > > Hi Eric,
> > > >
> > > > My apologies, I did not explicitly mention the base. I'll do it nex=
t time.
> > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > Since then, some changes occurred that will require additional
> > > > touches. No wonder it does not apply anymore.
> > > >
> > >
> > > When you make your next revision, can you also provide a tag or branc=
h
> > > that I can use to grab the patches for testing? It would be easier fo=
r
> > > me than trying to yoink them down from the emails with how many of
> > > them there are...
> >
> > Sure
> >
>
> Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
> be nice to have an updated set with feedback addressed...

Hi Neal,

I wanted to post a new iteration last week but I hit some new issues
that I'm trying to address now.
The WIP is here if you want to have a peek:

https://github.com/dvacek/linux-btrfs/tree/fscrypt

Note, I'll be force-updating it later so don't take even the v7 tag
for granted at this point.

--nX

> --
> =E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=
=EF=BC=81/ Always, there's only one truth!

