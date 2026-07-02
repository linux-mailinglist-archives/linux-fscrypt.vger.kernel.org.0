Return-Path: <linux-fscrypt+bounces-1713-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Tn5VJPkQRmqkIwsAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1713-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:19:21 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A4876F417D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 02 Jul 2026 09:19:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=PzIdkSNW;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1713-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1713-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 972203008D5A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Jul 2026 07:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FAE23911BD;
	Thu,  2 Jul 2026 07:19:04 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EB538F95B
	for <linux-fscrypt@vger.kernel.org>; Thu,  2 Jul 2026 07:18:58 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782976743; cv=pass; b=jVXczfw171TCuVcj6PzK1gbcLv4GcrEhHt/HonIa/ZAY+DcYkiF1Cwk+S719lRstWy0sU+o/bAmjdx5agKD/N0vnBbTKXeOJYFcf2kNlSi7r3fSTqzqJ5/imwJuBMvl7MHU+2ECyTe1A1jlI/sbr/Bxv2deuD+iurepbaQVibw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782976743; c=relaxed/simple;
	bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MzJl6wtcr+Y7ALfZT7kewZAAPVbMyNEF6c8a1r/kIhxyW4QwmYaL+NyaxrhzXtNs0IHiDPAUwfv6oVWB6YbdSrTOPpSbvsF4J8vEXa4YLRZR6ajrUDSVdUyx2X4YAoiCGNuJRa7IZYsGRBobDjnu4sbr7t2telgyZpoqffWlRcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PzIdkSNW; arc=pass smtp.client-ip=209.85.128.52
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-493c55d5c7aso4268375e9.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Jul 2026 00:18:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782976737; cv=none;
        d=google.com; s=arc-20260327;
        b=jxVFeoOFkON/H7suBwYRh0ot9ShXloS9E0QodsO9bJXJIwVgliYYs2MrDLBPR1DeZ1
         z9WzmYoiGqk9AdI/36pCvVe+Xck8UCT1PRu/j5weleztO3jgDnSZGXCWu4T/ruR3zuZE
         12mpnDBvTcEZU5YiK0MnzoKvmQMFelPIJHwPCTIkysiJFVXwMokzO5fV9Sj6a7gcq3mP
         J0KrgTq/uL7APFdv/pYf0XGPjXTE5BNqDzvD3Jp3EW1GeAaVidjcv1hYOWptakXQsnQR
         u+uog51WY8LOeM7HmXJKF1WFDABZ1y/6Q9vwvc7LTx0k9gyIiwL0SZyQI7RChL8nkSed
         vznA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        fh=VhGpBG5zG/3awosYfq1S3Yvf9y2s8pJeEnBPWuuHQ9s=;
        b=JRWtKu8XzWdoZHzDHrmQ4tlixEWGuLuccxcNys3cIijYiUstCE3gAErLL2m94/+RYK
         6zSY2J2im+T4GPDzxFbqJncDSGIJR7O0bB2N/32ag1ccRHZw4oubhliwTmyhj1efvBm7
         0P0GejLRV7bedPz0v4WNqu4kY9p7ryxGKjU9Ejq6g+IoSBL369FOQSAca31KJ6PrbYQj
         mmobM6qeXTd6iPAw8fUR6zSyd2et7/pmgtaRothpP1RTv8CpRYoBO6Ao10qcm+My/YvY
         oM2CQjJeQnbBlcLXBn/5518owMuY+1T8kVaw+2D/WcyPYef02cygyV72XgpclEktSWQV
         ZmEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782976737; x=1783581537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        b=PzIdkSNWXvl6WWsnM5EdePveBC3TSCk5cZa/soGX4ViEWRBNN0sV/+oYcjS2B9iod/
         5GdUzboiDQLkywUb83lw4VbDMSyQzOJC1el/8WdLnbtN0Lc2LJvbJf/Eyzv2cG/BrzNB
         Zi+4DF6JtY5ilEuh7dfMZrT1XBIzgTdJa0IwQc8DdcSVHVdjBg1CT5E4vDroam+Y25L2
         McejGmWTxARBiKkqgUhTD2c+GDmnfdVeY0sVG5HFb12suV3ebpR5dNW9Q+4nyu8DD4D2
         lTRsG0trOdPPBygt4lvjmH/9K81TcW3+xwH/sXNH6koBQKQgShcZ221jFsyD6z0y1POa
         r7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782976737; x=1783581537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f61h4aIXGzp8C33glYZ3LIjMlftj5SY0AMhGdTrfedg=;
        b=nqOmZbinUS+mOfOZE6BEt8hD49N9QvDhOUHmbfIFCj7f2WVvAnKQ/FpoQK/xM/YJLE
         QWs+Sp+KNE3Qlc2FqA3iiuLxKCwo1B53/kxelCm8+wVTN1rOGUSrgAyn1uT4o425TH1d
         t9rdrAkjsr4LugpysCD7PvdYUMXeNBhzlR+mDIExEOhjG7FGFFccjmLz3edkF58vMqz/
         YoQESgabw+Y9RDo90NYRYzbY8JT+qrNST6+Fxq/CWm98aYaIZdbmm/x4ZQZweQthjs6C
         erqMaLXzL4k3lilOz7LP2mLElc+8PbeqwZf1ZaA+/z0bIINJ05MeeLiwFSPG0M/yc18V
         /npw==
X-Forwarded-Encrypted: i=1; AFNElJ9sBl1wR9L8f/62G4fabn29T4jEazVvb0yIYHnQmKQn0Fo5+CiOytif1Y7Tm8Nfd9yd7v/w6MSJRDfDSfZ0@vger.kernel.org
X-Gm-Message-State: AOJu0YxhWMCIFMeaTO1iTfq9dR9BUANy06G/zrgVfPJbc1BvP5ACaNkV
	hdDTKWK+HCp3bcYwWhbIpVD6NkhKyf5QLTAIEcjPVTHG1mnVwB9WNq3g+BgE+rPUF4sIsZFQSE6
	7ifAwz1hhAivdwnz1CPY+iAhzW5Z0Zz0a85DGL8K2oA==
X-Gm-Gg: AfdE7cnE5UaknZDEJJG6epR2PUPChAwWCQ5w1d7YAg/WlyI0GWxwVY0gF/kiltqFbAv
	HXvg4Ln79ryVueWI3lLrECQ5fsFCfsEDWpbtMxJ6LY1tfX89xafxrt8zSRzO+DYibzmTwhK2OvR
	0U6Vq5vfQkSHlJ7nWk9UD/Z8gK+Bd7X8nOzkD00pLHp/KsfQZOLkuOVEhDHsUlRpjWdrAkMm+y4
	CzA/T7sXf6pQsx1dh3F9LimywJA8Wtd7nvxzcGFCmMtNG72zn5blwJDmRsKwIWlFdYH86qqSQvK
	8TOoN4P1vxEiJ/MjVfUCHAEsMKSOI6hKZtgxtj3pONPZ6tTas+o4KJhL4trGupImaB7sNQ==
X-Received: by 2002:a05:600c:1986:b0:493:c3c9:218c with SMTP id
 5b1f17b1804b1-493c3c92192mr52905165e9.30.1782976736990; Thu, 02 Jul 2026
 00:18:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624165144.556908-1-neelx@suse.com> <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com> <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com> <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
 <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com> <CAPjX3Ff_iG5B=uJp9uJZPVGGbAhp9fErVkHxdOLr5EZNGPMZXg@mail.gmail.com>
 <628d90f5-f2d5-4b67-929f-ad7835e7fd89@gmx.com> <CAPjX3FdzjXTR7q8RjOUdu_8h6V5wkBjsUKM+=_9VV=rcg+3FdA@mail.gmail.com>
 <1cb04346-a607-4253-add8-614de783a0f2@gmx.com>
In-Reply-To: <1cb04346-a607-4253-add8-614de783a0f2@gmx.com>
From: Daniel Vacek <neelx@suse.com>
Date: Thu, 2 Jul 2026 09:18:45 +0200
X-Gm-Features: AVVi8CfLydV7MLy8qhraAKclKY-C8O9mruPT1LVYg123RLLwxpEiEiyk426zbl4
Message-ID: <CAPjX3Fdc7+iy+-zqHgnJQwgwDk4mNSbuWmLG44jWWJkk=3MWvg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file extents
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:quwenruo.btrfs@gmx.com,m:wqu@suse.com,m:dsterba@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmx.com];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1713-lists,linux-fscrypt=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,gmx.com:email,suse.com:dkim,suse.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2A4876F417D

On Thu, 2 Jul 2026 at 09:11, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> =E5=9C=A8 2026/7/2 16:35, Daniel Vacek =E5=86=99=E9=81=93:
> [...]
> >>
> >> A simple tree dump can always show which range is hole and which is
> >> preallocated.
> >
> > Yeah, that's true. I'm curious how other FSes handle this. Let me see.
> > Or do you know from the top of your head?
>
> Sorry, not familiar with other fscrypt implementation at all.
> You may want to try to experiment on ext4 to see how it's implemented.
>
> I guess they do nothing special and just expose hole/prealloc info.
>
> As the other path would be always filling hole with zero filled regular
> extents (before encryption), and disable preallocation completely.
> That looks over-killed and may take a lot of extra space.

Well, rather filling the prealloc with the same zero-filled extent I guess.

--nX

