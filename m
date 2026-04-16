Return-Path: <linux-fscrypt+bounces-1549-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0Br9OgT04GkZnwAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1549-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Apr 2026 16:36:52 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BD6240FA39
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Apr 2026 16:36:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D9C7030B1489
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Apr 2026 14:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C751831E82A;
	Thu, 16 Apr 2026 14:35:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF573BD64D
	for <linux-fscrypt@vger.kernel.org>; Thu, 16 Apr 2026 14:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776350131; cv=none; b=ePsLPQlIZuOba/+1StJkX8YPx3SFB2UVrBfJK8ViaaPpvBKKUGGw6gz3sMl1B2ukCHIrM+YNriohFZAUh0PBE5W1NcNPfi26BSuwiEx1GxOb9QNdk08HwEkXjPWpJT8Bq73WXqLlfQi47G8iVISbs/iGRsZuZQsdhbom4N+tCQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776350131; c=relaxed/simple;
	bh=K5gvEiYv3jZzW25PsjZwADfdThiRHyl5G6a/VOIXzvs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YOsq6d9qyYfAfH/79WvhlXJzxmpJfH1iPlkJYSBFa47OysU63l6HMrJo+ck5ilV22XpraC9j8AOq3YPIjTbhcWdrt+GR7eYYUEmTGvoqe5NPllTL/WkmZQklsK/jlLMTISVpjuwAQU3GJOA44kXaIFpswoZfJ1uDGeQ9ImwZvCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-470145d7df5so4781978b6e.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Apr 2026 07:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776350129; x=1776954929;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AI1FEazLMBfRkY6zv90212rOaiThKdBsiK5ZQ2oBKoA=;
        b=tLarh0iXI2r9BWexDJonsnVJSMHn1PlHBqQUDF/5ce4mCB3Lr+Et0JMMgqYecN1pmq
         TR3Lf0aShROBMdczysZwngonxvicEhtYCcNMRaHGfHHD1v7mHS5gtrgiD1zSNV5d0BYV
         ENvQT44MxhedzYYKRDiELecezDyS/1/qelRdTQRfIYVUqpP0QfuUhFbtckUxr4uPdiys
         7u/C6hgmuUVlEmwjij1J3xa6dTIA+V3QQmPoZzWS6ZDJy6qkn4lm2BZjsqbVKzr26wLB
         PqAfIvYnCeXed8/TeE8TegEYrftHofEbGZOfIdWe3ErWearNWUVuU8r+gqOB6BSOGrnV
         TA7w==
X-Forwarded-Encrypted: i=1; AFNElJ/JVo42oIHNnkNH1PySYJOPf0q0qz9nOZFNjiHcMT/0WWi4E7obo0mI2zo74LEG2H5mOrJDZ6u9QHwOEY7L@vger.kernel.org
X-Gm-Message-State: AOJu0YzuEfgt00l+Qtz8am1hIQM8pM71IoUeBTxCt/+XHvd9trFl2Zk/
	SYAEKVcDk7gN8JT+MqjT3EnqS5Z4cjbeArX/T8Ooy65ybLctsFjSR5w+fj8pnQ==
X-Gm-Gg: AeBDiesLmX2NGas5Jbwc7vsq6xVMTY4QstabVh9gU0vLn+qbxymiAyP3fnIhEaRfZoj
	/hWBVClWXejK7bQRG4x1NiKSXj0ZJcezGWwIWumE0Utssq+65ABJOK0HcaNsJ284vqzczCDAHVK
	eTYqLJ0/ZHhM0t5qQeb+jc/MUe/VvC5D6TnPrVRMwtgYWUVmRvfFbQ8dsyTUAFrCCmnzVC51TN6
	zAWf5OpaYKfdorkbRZ7pdY9TJc6S1FCugcqamCY+GxgK12ZwOw72YUMys7WXkXZdmnJuBR/866o
	t8URkEiw5EJCGXtdI2Qy0ps1SpgcXEWlm2H8DGESILnaLtrE5WkX3SC3xhCrvW9zAg3iT901afH
	jj4q5NhzyMxv//9pMvFwX1NNzNcwHJX7jh9z9aDHvXqW6XPWIzQVq0wlTIyh45AOtuVnujTxf7i
	3vXy/wq/HB8cyuayk6pJIpWrXt/CBfV2n42/2J+wPRXaCmzdX53lXwVHTiaQCLoevP/pHuPLjHd
	sRnvYV7aXx3RYBeU8K7giWFXtUS2KI5ExX8g89xrD3UBxsZFwXW0aLc9ANb7hF/luVyI0HlRA==
X-Received: by 2002:a54:4e82:0:b0:46c:cdf4:1bed with SMTP id 5614622812f47-4789ca39714mr10755709b6e.3.1776350128807;
        Thu, 16 Apr 2026 07:35:28 -0700 (PDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42666bcb977sm4195644fac.6.2026.04.16.07.35.27
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 07:35:27 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d4c12ff3d5so7171218a34.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Apr 2026 07:35:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/0HEe1rhl4baIAqqnBHUyuRdiYSPaP+I8Wy4MP5WHoKC+3fPny9er1DQyM7rrI0jMOaKPreFuPrhT5ceBT@vger.kernel.org
X-Received: by 2002:a05:6830:3984:b0:7d7:ef0a:1ceb with SMTP id
 46e09a7af769-7dc27e2f0c5mr20103991a34.9.1776350126827; Thu, 16 Apr 2026
 07:35:26 -0700 (PDT)
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
 <CAEg-Je9XevtRv1VLPCQtog6+UrLL32ZWY_TzXVd8mU5Vnp+Nzg@mail.gmail.com> <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
In-Reply-To: <CAPjX3Fep5ZYLuSUY+zhewtcBqW84a+qYfLcc-20soDfMjvkecA@mail.gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Thu, 16 Apr 2026 10:34:49 -0400
X-Gmail-Original-Message-ID: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
X-Gm-Features: AQROBzAbu52l_aX8sNV_57C_OXX36_Cyf8egj2w81DfudRRt3HPopShq5pbvZPE
Message-ID: <CAEg-Je8ZFJ0MWobrgNpns1-ovh37FeyuvmaR3QSarF_sg87iVg@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1549-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,gompa.dev:email,suse.com:email]
X-Rspamd-Queue-Id: 9BD6240FA39
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 15, 2026 at 6:21=E2=80=AFAM Daniel Vacek <neelx@suse.com> wrote=
:
>
> On Wed, 15 Apr 2026 at 07:30, Neal Gompa <neal@gompa.dev> wrote:
> > On Sat, Feb 28, 2026 at 2:57=E2=80=AFAM Daniel Vacek <neelx@suse.com> w=
rote:
> > > On Fri, 27 Feb 2026 at 23:26, Neal Gompa <ngompa13@gmail.com> wrote:
> > > > On Fri, Feb 27, 2026 at 10:55=E2=80=AFAM Daniel Vacek <neelx@suse.c=
om> wrote:
> > > > > On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> =
wrote:
> > > > > > On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > These are the remaining parts from former series [1] from Oma=
r, Sweet Tea
> > > > > > > and Josef.  Some bits of it were split into the separate set =
[2] before.
> > > > > > >
> > > > > > > Notably, at this stage encryption is not supported with RAID5=
/6 setup
> > > > > > > and send is also isabled for now.
> > > > > >
> > > > > > Where does this series apply to?  There's no base-commit or git=
 tree,
> > > > > > and it doesn't apply to mainline or btrfs/for-next.
> > > > >
> > > > > Hi Eric,
> > > > >
> > > > > My apologies, I did not explicitly mention the base. I'll do it n=
ext time.
> > > > > This was based on for-next @20260127 (commit 80dbfe6512d9c).
> > > > > Since then, some changes occurred that will require additional
> > > > > touches. No wonder it does not apply anymore.
> > > > >
> > > >
> > > > When you make your next revision, can you also provide a tag or bra=
nch
> > > > that I can use to grab the patches for testing? It would be easier =
for
> > > > me than trying to yoink them down from the emails with how many of
> > > > them there are...
> > >
> > > Sure
> > >
> >
> > Ping to ask about the refreshed patch set. With 7.0 out the door, it'd
> > be nice to have an updated set with feedback addressed...
>
> Hi Neal,
>
> I wanted to post a new iteration last week but I hit some new issues
> that I'm trying to address now.
> The WIP is here if you want to have a peek:
>
> https://github.com/dvacek/linux-btrfs/tree/fscrypt
>
> Note, I'll be force-updating it later so don't take even the v7 tag
> for granted at this point.
>

Cool. I've got some travel and stuff going on, so I'll probably only
get to take another crack at this in a couple of weeks. Do you think
by then you'll have a finalized v7?


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!

