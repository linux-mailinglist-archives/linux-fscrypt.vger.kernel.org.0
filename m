Return-Path: <linux-fscrypt+bounces-1634-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id fEfRIE1lKWq7WAMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1634-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jun 2026 15:23:25 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC1DB669AC5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jun 2026 15:23:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=EWsQI+1P;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1634-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1634-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 158D43170C5F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Jun 2026 13:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B13407CE1;
	Wed, 10 Jun 2026 13:19:35 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93994408639
	for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jun 2026 13:19:31 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781097574; cv=pass; b=Pl2NJxeCgXzJNctiQ+IkvTHo3acZfUSOXTh9iFQnxT8FsZxnqBjG3g8eRlZC3LPqfZ2JGJmFhX8zxOnYzu5TnwPApcHupgMsoO2N9eQDM5MmzT4qjdWGb+n3w8roVpvLdABUfrFhqxeggy0SGlfBZUGP+oIHOSsWRnziwQ3n2eU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781097574; c=relaxed/simple;
	bh=lGRQFI3Hp/wayJqw+xf0lgQEfSFmDvi6/ZWTJl9pGSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BVw1AyU5VFLE9uGb9jBQU+Y82TlRgKr2FgW1fmGEJJisw4sB/Tanc2ImZNkCRrEfJDmjMMSkdxHLeyRz0O56O7PoHUO1in6GkJoCH8Z6UspTkL/IZYI8pXhUawvCY7zJqzSTSB9XN42glpMp4WRS+BKe8a7ci6QXLJ0vABnw40U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EWsQI+1P; arc=pass smtp.client-ip=209.85.221.43
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4600ddc4017so4679560f8f.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Jun 2026 06:19:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781097570; cv=none;
        d=google.com; s=arc-20240605;
        b=FbqTc9bbtr2QqYTm1ff62jnSDU/2/HOWKj3k49a8zsgbSUzXZKrgmiV+6jGD3Ywzly
         8Xobd8OUPtilQxvhD4CXyfN50SAUza9b4MOnH19CPCqs4WWleCbxM3I7W5wA8VM7ZtCV
         g0a/IEIbShP902456ZORUJGgfyM0JzyMn1+1ATa7kB4hd4n2fjmczwW/hh3zMIvjKp79
         9u7LJHhwAA6tBXJy82KGtTrmVYgxb5M9vS5H6EXCDYYUCkg2BDtiApUT56vGeV9Gxt84
         lHYDp0gAJ9zQ3mraLs06DJGUcaSCk0quDZjB62f7GyhQlRR4bJ4BO7WOsuz/d3bmL114
         kgug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        fh=8nMEic+vZ89ddqpZP0PXbHHjxHAKASG9Ozz5SLYrkbk=;
        b=ltgWBTcTpczazGW2ezNCZw0mqy6aKLzuiGoz3e0KJlZa0d9pQyBb0Jfp3SNo0unyKW
         DwjzzeShVy5BQmo4DmcY6qXHX/CCKG4lDjPaQFTDseCp6q8jJ/Tn9+zgyY+bz2SYw2t1
         cqgcsmqPzbc/ViV0NGwBakeiEbVphIzenHZXWgK+QEY4IveP2zKkinPvEAVjRGOG9ows
         dRj09IjJT4glF85/9GyO7zQ8/YnIRtVQ+6G2X9m98EbO4OaO13hcw2UHzFE3emVb/9aA
         NaYTleZgYWHNBLrP398ZVgA7kO5PjS1vs+S+I4TsrOpgamB+5z9MimjoXA2U2/lR/BvJ
         0JqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781097570; x=1781702370; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        b=EWsQI+1PHRt5cJmsyJ3ajj9Tth53M2IR+9GHVPtZW6HR6bWyc4weZjTdyEOmMIW7ef
         IqM3ByglwjqeWAfLJ9MUU91AauLIXZZ2q3t2EhYg47KYAfonhd4cjXBKDslAJughRWdW
         BQkfHCAxvNYKeRDj/fzsv/rifdgfKIxv38JyS8cXlY92rzg+iUklQAjCBefVTgIMlE6H
         chRUlexFVEeKdMwisLFkrif8PF4rz3IhkKKIrKaxzNfwVhEY5KOrm+rq4XS3imqM6jU3
         +o0aqlpPDapAzO7B3JjrgEW3zZ199s0lLtvrtOni71ediE1rjMOI2kgpIwk6+OPJV06H
         ey+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781097570; x=1781702370;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZiiuXZsTISkwh6lAvtwah1aW4/G3cB8JXIp3JxzVYw8=;
        b=T47BaNaqPhNc+dNU3vyGOUi+YnNZ3vMf0bnwvQV5dKjzrn18G5u3/NleBGyWxhM6fO
         5EFVGNrA9etKR62Gbhw3uTUBEpI68W7Uz/1uwo8Z8zWprEnvwgl5RL1pujyxtNVClBVJ
         2ZMOlo8UbEfduhKHpeCUM7NLeS3r5mgiO8OFyp8Bxx0ZMy+uJx69FCAPuNPY1h+u2rt8
         2L7Urdh2NjTX+dCFclszWTUfLS1BjRJaT2lZ1V3rAVJBh+xtFfAAJ2J5CExGZjHbk5W+
         eZZ8YbJqwnNRAm71kQEU9pxAdMMhVKkPN+UYFkmIyI9J3zkBRpBIgpnagveAodYcK6vC
         UVJA==
X-Forwarded-Encrypted: i=1; AFNElJ83FKFTK+g64BhnG8luKvVLkI4dCJqJMbbt3rKUz5lR3juU2IKI3lXAb8B6n4esCex5NmJJQS7scIEtCp6Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yw92VcnJJik4RlTfo8h1/OF1Z5kq/CK4mnUil1+oqTZgsX1LPTH
	EBDNY5foK81ZXAHCm5N+x7wg2vg17Ufd/tGqh9H7IqFvTlH9mY2rsml+KfX6EkEF2Zp3IxJt6N9
	La40i3ne3cLm5eQDB4+Ogs4xyUn3Ofu8qE+9eg2ojag==
X-Gm-Gg: Acq92OGvsCtsVgFNat26EUzfdE5SsEeiPQjVugl5/H9suahuOWADRbuFG+9oU1hPkaX
	iVMisDcdSuroZ15FTql+QlRfROUwt5KNqiYY1CNlE1x35P4Onon6g+G/Gj5HQnLfNIKG8dCYGLi
	7DSosEFPfuO8elaQ69INtxBzTujjv/1BgBZzz02b9Fli0ULK+GYgMIcQbFj6EdOxzlEsGRdWlcA
	rdmhe+g0h0zG+gb7MBtkoUzvvRmHLX8/+Ef/fUJlzhRspHMSzehZhT+Uc9nexj9LMylQaDhNNnI
	628+Jr5QgQqDjicXGeszDlu37JiO6gYrbIF6nVXhjWnAs/P4nlb0u1F/BktL5puozL7IFz+n899
	mJy1TOB3UvPUCNhE=
X-Received: by 2002:a5d:4285:0:b0:43f:e721:76b8 with SMTP id
 ffacd0b85a97d-46030624015mr27894543f8f.37.1781097569748; Wed, 10 Jun 2026
 06:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513085340.3673127-1-neelx@suse.com> <CAPjX3FdHJpZUVk2dfA+Ov5K6vOSsOJMUaxCU4G8y1qg6baMXYw@mail.gmail.com>
 <20260531002812.GA2302@sol>
In-Reply-To: <20260531002812.GA2302@sol>
From: Daniel Vacek <neelx@suse.com>
Date: Wed, 10 Jun 2026 15:19:18 +0200
X-Gm-Features: AVVi8Cc3kwl9fZ56YD-UdBCxPsiFupB3WEKTLBFSqqAW2W86Bzv6x7-7G0urFU0
Message-ID: <CAPjX3FcWv4Pv_dc+ArUYdpr+KZh=57q8XFaqrF0=CX+59bDaPA@mail.gmail.com>
Subject: Re: [PATCH v7 00/43] btrfs: add fscrypt support
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1634-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:dsterba@suse.com,m:linux-block@vger.kernel.org,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:clm@fb.com,m:josef@toxicpanda.com,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,sashiko.dev:url]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: CC1DB669AC5

On Sun, 31 May 2026 at 02:29, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Fri, May 22, 2026 at 09:00:46AM +0200, Daniel Vacek wrote:
> > Hi Eric,
> >
> > This is just a gentle ping.
> > I was wondering if you had a chance to look at this version?
> > I believe all your previous feedback has been addressed and this
> > version is solid.
> > Please, let me know your thoughts.
> >
> > Regards,
> > Daniel
>
> It's been really hard to find time to review this huge patchset.  I've
> started going through it and will try to leave comments next week.

Hi Eric,

First, thank you for looking into this.

> In the mean time it would be really helpful if you went through the
> Sashiko reviews
> (https://sashiko.dev/#/patchset/20260513085340.3673127-1-neelx%40suse.com)
> and address the ones that make sense to.  It found 93 issues including
> 16 critical ones, which is kind of a lot.  Some of them are the same
> things I'm noticing already.  Same for the issue that Christoph noticed
> where new devices can be added; Sashiko had already found that too.
>
> If I'm going to have to use my limited human review time to point out
> issues that were already found, that's not a great use of time.

I already went through some of the Sashiko reviews (they were slowly
coming up one by one) before leaving for my vacation. And I found them
mostly confusing or misleading. I'm gonna have a look into the rest I
haven't seen yet to see if there are any useful points. And I'll
compare it to your notes to see if it was Sashiko being confused or if
it was me.

> I also don't see any information about how this was tested (and will
> continue to be tested in the future).

I'm using the `encrypt` group of xfstests as the acceptance criteria
and the full test run to ensure no regressions.

General support for btrfs had to be added. And since we only support
the v2 fscrypt policy, some tests had to be split into two tests - one
testing v1 and the other testing v2 policy.
There are also additional new btrfs specific tests (reflinks,
snapshots). xfstests also need fscrypt support in btrfs-progs with
related changes to export nonces and other metadata like device
offsets of encrypted blocks for validation.

I'll send the fscrypt updated btrfs-progs and xfstests next. I just
need to clean them up a bit first. I'm sorry about the delay, but I
only managed to post the kernel part before my vacation. I was hoping
it would give you all more time to review.

Thanks,
Daniel

> - Eric

