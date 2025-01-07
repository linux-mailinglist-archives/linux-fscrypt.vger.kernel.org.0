Return-Path: <linux-fscrypt+bounces-580-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71526A04160
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jan 2025 15:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68CB1165B98
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jan 2025 14:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C83FB1E8839;
	Tue,  7 Jan 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P91bxWrV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB59D1F193D
	for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jan 2025 14:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736258404; cv=none; b=D7Fod2dABYynCtlRw6P4G4gBjC2STWdXN44anCIxKmAEBGUGvOG2NgBdjMyAL0rdnjLjMx8uX4MzH7Bfsl/NknV5gRPTk4bMaiqauX4gWsyQUV1k5jE9J64S8a6KG7E7WtoPlrysbn3EG7zwybaFDulBJPWZFoz+7N1t3VBSqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736258404; c=relaxed/simple;
	bh=wAxME8YMOU4GM4a1MPnvRrFZt+NPAe8W10OAkDSFdh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqMygNj2KV0+HjhP7yapmGWe9tzqjfEQ92tGh+bqmFjb2ByWkAFW2iiie63AK1u78w+Ds151yHJ7NoLl2ExpnwHQeb/I6QDkQfhP6SvYXKBj0WS3cGrfCUvplfhxDO056/l3+MZozCCOnuFJAAqOI3k+2UUVWFccF9GNYuE+UWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P91bxWrV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736258401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pwPtk1bUMw6H3qg/0OJzmZMXntXsHFnd2zi27fFb7Io=;
	b=P91bxWrVdKz+l0TA/j8sxwAfLLChQ6KvrEroWAIiPV5IAVngmmGP6sxrlsS05L/xNXOnJR
	Nl4i3xp3Y11YGQoBaKDd+sjJtVWnQULOZE4KmJ29dvveBNzFjpk5Ab4p/RLif0e2v7AP39
	PMLkEwRAJAEq3Buhhg5vlSg+KzsYmLA=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-9JRdpJuePsGaitiVEmDo_g-1; Tue, 07 Jan 2025 09:00:00 -0500
X-MC-Unique: 9JRdpJuePsGaitiVEmDo_g-1
X-Mimecast-MFC-AGG-ID: 9JRdpJuePsGaitiVEmDo_g
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2164861e1feso223080935ad.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jan 2025 06:00:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736258399; x=1736863199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pwPtk1bUMw6H3qg/0OJzmZMXntXsHFnd2zi27fFb7Io=;
        b=m+rfiRxT9Z1ZXDrHWzf1e7MG8dRtOrFpirTdNRS7FlXUhEBrn2ZZwxvxYjKZqM84D+
         DesdJdMIN/WF1VlGu48rwsH1g6J2pql/hYu33ZP2Qnx1cIWACYGc1wRVpQpQKlLcUCcT
         9VqHz5z4R6yoaNhRnebWJBwGQ7gLY9oMoD5pvL9kPehrw06l7lC+XMDiPcVACkMkPuVq
         PLgpqn42zPJU4m+6h2i5l1iPKuByavdla5q8w5RkXgTmP0mW22Su8QjtzAUbBEtMfP7S
         h0JI8DX/bGh3kW7EWLaGSt0/9EP8YUEzgsaCxUABqE48YSiKUXeJo2NZpnAmHEp4Q2Ef
         QZ2g==
X-Forwarded-Encrypted: i=1; AJvYcCVFNK5E0wBU3TlolI75u9L28OmTgJDPtzCpulElFvdkNUsZYumK8Fgfqyb7olNl6WbeW/QeeoiB/8uhuLqj@vger.kernel.org
X-Gm-Message-State: AOJu0YxrGycZwG5j846HQHDo+02MMVTPAlHSOzahxY3iokFflCnGuBQK
	d8IcFCPJk95MaK1rF7/tSQTks0v4+FTKKVFvqjMeZfPGAvFOCG7DxhREMmD+FnWzlN1InrKqNoM
	GOB6Wq4sPnzCkBZHmpvg28xZKmedJZ9IdHrsyk1ZEfwCiAx2gTwiKnjRyP7zI56o=
X-Gm-Gg: ASbGncssjUnFzkrNaVln/HQzeceUKzl/SPa8FpvX5yutaGdIr2oRbNV53xB0BvuzZXd
	9AbPBAOemI/9UcySnvDPbOstm2m4jlmDyYllBYqtCUkPtr/5vLJ9Nye693Us7kCajPI8JP/AUQa
	YVaPI6GE7+nurBNfMvTeUsLy4pf+1IGcwedgAQAV0/Xh9Iv7WVN6n8jzHtYYG9CdMUJjZgwkvAp
	FnQzSXQ0Fcq2zfcIxyj10i+9UybwKscC1l8PgRgxyEnNwrXiI788fHM5j15Zi5J2bwJTLYatHHb
	svw3JDNBtiG6jNa3JWigUQ==
X-Received: by 2002:a05:6a20:d80f:b0:1e2:5c9:6791 with SMTP id adf61e73a8af0-1e5e04609bfmr105375544637.15.1736258399549;
        Tue, 07 Jan 2025 05:59:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQGAIMBMYfyEH0WhdgKPHwTDoX2FnQN7dUQaqrnDfzapkVsLHcdkSROMlvR/09DvsKerh9Dg==
X-Received: by 2002:a05:6a20:d80f:b0:1e2:5c9:6791 with SMTP id adf61e73a8af0-1e5e04609bfmr105375500637.15.1736258399206;
        Tue, 07 Jan 2025 05:59:59 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad81617csm33311902b3a.39.2025.01.07.05.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 05:59:58 -0800 (PST)
Date: Tue, 7 Jan 2025 21:59:55 +0800
From: Zorro Lang <zlang@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH v2 0/3] xfstests: test the fscrypt hardware-wrapped key
 support
Message-ID: <20250107135955.7ysucjcdh6m3zlh6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241213052840.314921-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213052840.314921-1-ebiggers@kernel.org>

On Thu, Dec 12, 2024 at 09:28:36PM -0800, Eric Biggers wrote:
> This is a refreshed version of my hardware-wrapped inline encryption key
> tests from several years ago
> (https://lore.kernel.org/fstests/20220228074722.77008-1-ebiggers@kernel.org/).

As this patchset is applied to upstream, I think it's good to me to have
this test. I gave it a basic test, didn't find issues. If still no more
review points from fscrypt list, I'll merge it.

Reveiwed-by: Zorro Lang <zlang@redhat.com>

> It applies to the latest master branch of xfstests (8467552f09e1).
> It is not ready for merging yet; I am sending this out so that people
> have access to the latest patches for testing.
> 
> This corresponds to the kernel patchset
> "[PATCH v10 00/15] Support for hardware-wrapped inline encryption keys"
> (https://lore.kernel.org/linux-fscrypt/20241213041958.202565-1-ebiggers@kernel.org/).
> In theory the new tests should run and pass on the SM8650 HDK with that
> kernel patchset applied.  On all other systems they should be skipped.
> 
> Eric Biggers (3):
>   fscrypt-crypt-util: add hardware KDF support
>   common/encrypt: support hardware-wrapped key testing
>   generic: verify ciphertext with hardware-wrapped keys
> 
>  common/config            |   1 +
>  common/encrypt           |  80 ++++++++++++-
>  src/fscrypt-crypt-util.c | 251 +++++++++++++++++++++++++++++++++++++--
>  tests/generic/900        |  24 ++++
>  tests/generic/900.out    |   6 +
>  tests/generic/901        |  24 ++++
>  tests/generic/901.out    |   6 +
>  7 files changed, 377 insertions(+), 15 deletions(-)
>  create mode 100755 tests/generic/900
>  create mode 100644 tests/generic/900.out
>  create mode 100755 tests/generic/901
>  create mode 100644 tests/generic/901.out
> 
> 
> base-commit: 8467552f09e1672a02712653b532a84bd46ea10e
> -- 
> 2.47.1
> 
> 


