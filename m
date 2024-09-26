Return-Path: <linux-fscrypt+bounces-459-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC659875DB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Sep 2024 16:45:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE38C1C22AD4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Sep 2024 14:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7CF63EA98;
	Thu, 26 Sep 2024 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="VeyTd9R8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86BF43AA9
	for <linux-fscrypt@vger.kernel.org>; Thu, 26 Sep 2024 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727361917; cv=none; b=koZ4k8Tbaa88pmQVBCGNJ/l++VC/nJ6W2Y+KcKGVxht+d7ivcDFEqseiMBKn2ljBshopEtHEru91XRnWTLAc9+WmHRqq5mmu4Gsj45FCsGIyreZJzdLnLR3Zjsh3R8Umj72hh6EaqlRK0f1vutyKOncr0u84LSAA+yvAjoJEmKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727361917; c=relaxed/simple;
	bh=dsumOzFDfuh/PYFlQ5fBlwa0itLqF681cpqOcUvtv+0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hnWIMIqK6Y39+ZODhU1QeVKd6+1vB9iN3/RRap0yek2eSU/kgCQm5LooPACN9HBmMX3DCANJ4SDClshtPgQbT/SXJ+rz6WtKNNOEA529MSWP7R6QH8uqwKLJdNpE3hnigEM9avgiWLwyEhFjd4VDAKjYWywOadxTcFJPmjEzggM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=VeyTd9R8; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2f74e613a10so17719671fa.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 26 Sep 2024 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1727361914; x=1727966714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=VeyTd9R8+cruMSRIYlvO1L1twVFDeN8tss4OomfqAArVdxqGg5rlNP6/dJTdyfu6V3
         hBKl0fkg0OuRoNnW63/VeLvk9B7em36Cbcnf2Gqp0/4BJBn67uvQv+ry8hFi5yDSjsIc
         a8GEHDLtx83lBr4KcH8WHijTHKP8MtiCRHURjyDSGurE/OL6/lpPk1QxqVf8EiHx0yZz
         TNVzZ3pDHrxw7mhaAX45p5GVd9rTkNk/1N3FlqBl5y1AreZfVYwwT+srqanbuS6g/v0f
         fU5CB0OLI9I9lxOKOEvBd+ntYRVtMlLO8Iq/FKzmdsk+ivGluF7Kent+Kwap0IKHHHBN
         HYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727361914; x=1727966714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUk5GqFsvnt8aibuoucXH3mgAlXQnT7Fu6sM4Odfi8U=;
        b=mwRKdmHxo0MerjzUOIQJyuJQMh+b+Byu6SqEYxn3VNMjLzS4JLhuSer6kpdZsPWfoh
         FcaFOpPevQZaJ5ncQ63R8N/IXvaE6txWA3BVKjyOwMxl04apm/rdYEgJsPjc4HLBk7RN
         n5qKclS9hczsZNtlaZcEmP487PsUhA64J32gZfIZITS538sIfpw1oTz2arKHXSsEjD5Z
         L0jK+VHc55C82lN/GH0cS4FWfiye6V4aKQIpADAz6PLyKwZhs2rOJ7rxgw0sHjFybkef
         snwuec+ic4NQoMR/wm9up01+U8PWlT09Ug0QgEOppyYLQ1iYA3h1a0hab+PYAoBMt51E
         t5RA==
X-Forwarded-Encrypted: i=1; AJvYcCWDDN+rxGGWYxyUl/g7+jKXlyBrlp5+d1ugKgZPJko+/hHbWvSdC9eMJvge62QJM8k/9EUtHbV3v7BnkzVv@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4nuaiMGQ++9j/+F0IK5xBhBKpeLYNBpJk7FIyMww5POxQzcbs
	UuI4jovEDfQ5A00e1XWCdaLOTQ/DrKJ9V62rVMUda1QklHlIaLAzFuWhFEn2iF4i6apVDPfFa00
	jP96JddK0NegjRMCgZgXIiufcGTg0zJZK9HSk+Q==
X-Google-Smtp-Source: AGHT+IFBiLue3QFOk1WR26MRKOBV5299+r2MgZ52axZ/Ki/sFLcqtDTCw32+oxmnpnFn89KL/PCW6zIy0IG54nMMM54=
X-Received: by 2002:a2e:4a0a:0:b0:2f7:6869:3b55 with SMTP id
 38308e7fff4ca-2f9cd40052emr9790031fa.21.1727361913927; Thu, 26 Sep 2024
 07:45:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240906-wrapped-keys-v6-0-d59e61bc0cb4@linaro.org>
 <20240906-wrapped-keys-v6-6-d59e61bc0cb4@linaro.org> <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
In-Reply-To: <fc780dc2-5a69-48d8-8caa-ca2ee97d10ef@kernel.org>
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 26 Sep 2024 16:45:01 +0200
Message-ID: <CAMRc=Md3itY5N1gErL-VDAz0qW6DrHPKpXzT6kNwc2HVfvchpA@mail.gmail.com>
Subject: Re: [PATCH v6 06/17] firmware: qcom: scm: add a call for deriving the
 software secret
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Asutosh Das <quic_asutoshd@quicinc.com>, 
	Ritesh Harjani <ritesh.list@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Bjorn Andersson <andersson@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
	Neil Armstrong <neil.armstrong@linaro.org>, linux-block@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 9, 2024 at 1:23=E2=80=AFPM Konrad Dybcio <konradybcio@kernel.or=
g> wrote:
> > +
> > +     memzero_explicit(secret_buf, sw_secret_size);
> > +
> > +out_free_wrapped:
>
> Is there a reason to zero out the buffer that's being zero-allocated?
>

It's my understanding that it is a good practice in crypto routines to
immediately and explicitly zero out the memory used for storing
secrets.

Bart

