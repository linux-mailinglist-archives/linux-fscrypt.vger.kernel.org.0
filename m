Return-Path: <linux-fscrypt+bounces-1547-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cATyL5Ui32ngPAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1547-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 07:31:01 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 60B0840079E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 07:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3E8933006815
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Apr 2026 05:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA16373BEE;
	Wed, 15 Apr 2026 05:30:56 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711D126059D
	for <linux-fscrypt@vger.kernel.org>; Wed, 15 Apr 2026 05:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231056; cv=none; b=FqDWXMhE44gSy7/fSDxl8F7gSHNHsEc2YWPrJ3pjVxbIj0qYpBrpRZuslU1FCPs0hWNDwS5qdJQl15IFSle4PrPMXoyqsGEMLtMC6gJECRx9gM8ua4u0M8j1fKruxx8iJkjhDSIwolXmIija79oqLksM8PDxs3tUI463v/dmCPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231056; c=relaxed/simple;
	bh=yTnQ5CAqd/UhKMcqDiDVIchriTG9e9wvpYUEVj06UmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GbZl5Cu8h8Eyd4V+oAsBCiKUXJplRQTexoAckC3N2FvAk04rZ0IEIz9gdjsAPnXmARusfheSKzrFauakId4IZ0A5V+gdFpcvwFjuhlXFwaPpzG1UQcqI6AdP5lMFJm+MSPPVdaySrWv5oT8vMGjQxqGbblw0KLVtiojUkrKIQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7dbccf6a23dso6126021a34.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 14 Apr 2026 22:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776231054; x=1776835854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y9GVkYuXTJNpmm1CRCAA50QlNbF7wx2z6REKbWX7K/s=;
        b=UlgjdfXauYu0sIvf2XsQlYtif4ZvY3PLR7PgG4Feqf1tp5xw7XYkFeCMkDxOPJ8WY1
         BMlbzgUMrV9Z7Qml0NpUP6SZVYOAJiY6ii/AT4XdOs/iVZLTI7uEJIR5cpnkKJL4NFP8
         SnM27dBqZWEDq4RgccZsE2Ltk4UDHQ1tNyfSHatCtiSysQHWH+2PW6b5kdT/xtYvs3Qc
         qBGv3faqH1nr1CRr4ZRmq/m4j3+APTTRZMKnzmUpefnLxqQUxh3tHYDmRSPgAaiGa/MF
         ex1aUNwkNLBxtHmtw2MIG/x3YyLiTEA9ZzbRUnd4ZOf6+qUzsPe6d1gQ4o+k4n6RiAdO
         3KOQ==
X-Forwarded-Encrypted: i=1; AFNElJ/kT7b3syojdiawxp8WR+HK3qbypP4ybtTb4YPbf4pm6yRjJd+c62P/tUEiXbreIk453vvHr61yp69eylUJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx45373TOIXrZYvzhDXMAJPv89K8p7DeWXJdvcThzrS3sV28l3
	yizLW7xIXAN1KnvgJ4acoTC1jNJSlNYVoeUWIzJtMMBxjLuXfXCaBa4BcWueKA94
X-Gm-Gg: AeBDievRqhnHTjK8zQZsMJZsp1uEhIMYzQ0zj8GdI2R2nBqQRkbVYQkspj7ouKa70bk
	S4KyK8l/LI1FePvZYvJ2/HU8kWzhKwDHZEKr547Tp9ieC++tGYu9GjPlTwJnxripStxN/LViuSm
	FWwjyTsXIt+Vp9zhWVNYdixXjKvSy5znsYU9eLV5iIQza30EnJNmCloElT3NVD31ye0Z4nf8gch
	eINBSLZExjtrVJ9npdVQDIkfWeP8x5LM/Rx73AvATlX1SSnNCS/36x12QnNeAgSvCaPx0RmVBZ3
	bPheWO2qT7mqUnExcYrAGbem19rycY31hgwIC1J3iPUL89SkwHaFyd8/i7rNCqoCmaAcuqlL4R8
	Kx8tBIxA+kH9SbAexgLp1pPW/zCXhJh8psQMaIh9RgzX3frtTEU+Rv8gByxS8eQ8UD2KiMhjiTo
	NX5FoieuH5JHzeWVJFW27ZoSLP2XAiSbjkbEhl2rY2I3+8JKvE/WHkbGcZsFM2sSevd0l6qVPv5
	Qp2QERupOsAZqzIn4ealxM0WkBHwNGhFzcO6WI8cjUhk7K6GUZAhb42x3E9SpFtSFYjHUMb0w==
X-Received: by 2002:a05:6830:4ac6:b0:7d7:ecda:cc3f with SMTP id 46e09a7af769-7dc27bea7e3mr13946342a34.0.1776231053661;
        Tue, 14 Apr 2026 22:30:53 -0700 (PDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc76a351bbsm708384a34.11.2026.04.14.22.30.52
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 22:30:53 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dbccf6a23dso6125996a34.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 14 Apr 2026 22:30:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+F+qwrbR1wSFsE95CbrYjJRqSjU2t0AVpJwhV7T0VAAQ25rrUFWu/pSbWAckT96MO7hm0gzNyWrAyHAbIm@vger.kernel.org
X-Received: by 2002:a05:6830:438a:b0:7d7:ef4a:5ba0 with SMTP id
 46e09a7af769-7dc27e5fb9cmr12397641a34.12.1776231052630; Tue, 14 Apr 2026
 22:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
 <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
 <CAEg-Je80=M9nS=Dmj3FiGfXTEP_fDYytAv0ouN_iu+GzRrHp+A@mail.gmail.com> <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
In-Reply-To: <CAPjX3Ff0=OOWcPHWam0WEGUY-xx860NHQt=igfZ9102-Zj1nOw@mail.gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Wed, 15 Apr 2026 01:30:15 -0400
X-Gmail-Original-Message-ID: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
X-Gm-Features: AQROBzC34OjCDF6LKBnu6dATulz6eZKfdg2cuV20SScBXwf_3JWh73-Zk-aV9jM
Message-ID: <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Daniel Vacek <neelx@suse.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1547-lists,linux-fscrypt=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[gompa.dev];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neal@gompa.dev,linux-fscrypt@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 60B0840079E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.com> =
wrote:
> > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wrot=
e:
> > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > Hello,
> > > > >
> > > > > These are the remaining parts from former series [1] from Omar, S=
weet Tea
> > > > > and Josef.  Some bits of it were split into the separate set [2] =
before.
> > > > >
> > > > > Notably, at this stage encryption is not supported with RAID5/6 s=
etup
> > > > > and send is also isabled for now.
> > > >
> > > > Where does this series apply to?  There's no base-commit or git tre=
e,
> > > > and it doesn't apply to mainline or btrfs/for-next.
> > >
> > > Hi Eric,
> > >
> > > My apologies, I did not explicitly mention the base. I'll do it next =
time.
> > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > Since then, some changes occurred that will require additional
> > > touches. No wonder it does not apply anymore.
> > >
> >
> > When you make your next revision, can you also provide a tag or branch
> > that I can use to grab the patches for testing? It would be easier for
> > me than trying to yoink them down from the emails with how many of
> > them there are...
>
> Sure
>

Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
be nice to have an updated set with feedback addressed...



--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

