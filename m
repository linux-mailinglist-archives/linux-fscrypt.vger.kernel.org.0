Return-Path: <linux-fscrypt+bounces-807-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 492B7B3D3E7
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 16:25:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB6541880565
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 14:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37089259C93;
	Sun, 31 Aug 2025 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="n3Vlqj1l"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E3C2153EA
	for <linux-fscrypt@vger.kernel.org>; Sun, 31 Aug 2025 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756650338; cv=none; b=T11McLZltvxnfvIEj6ogZo2dakOxO9+aXM6/i8GwjfctNRMuuZJUtiDq+p64vC/oO8fIRTip4TpDRTMf5GJjkzWxaUApKRV8w43NmD9YR2NN7I8KiWuPQjlDN67ug+y2chKhXuACJrHGVP5im+bTlXT0/G+r+RPm1ZllSzcg8VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756650338; c=relaxed/simple;
	bh=tia0mrGZ7h1NCfPvef4VGNKt1YRomP862h78mFARS1M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OTyfrXM/3ejVYR4G8DsWu43SbAJSdWb1YnzC2qLwhdFBolM6Z1H/3q3TONc2PB77W8ruGfbU8nm9vUUeQZ8uE0Ns0nB8l+MkN8/IOcOKsUv9fD1J5/FjuM/FlCf3eSOZYdRIOpAw/rXUFRV/4HIxBv2Gz7nKNeMLqgf7LO1tQc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=n3Vlqj1l; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-771ff6f117aso2922712b3a.2
        for <linux-fscrypt@vger.kernel.org>; Sun, 31 Aug 2025 07:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1756650335; x=1757255135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tia0mrGZ7h1NCfPvef4VGNKt1YRomP862h78mFARS1M=;
        b=n3Vlqj1lBNW1z86PHYxUgo0EUmRALAbbQvB013upW56oRHvEExo8MK0m8zlgrE5TVh
         BCmszlWKxfCSFnJWuIZQyeIUBQLYRqqYUE9JSgF9oJW/S/4Qluc0vMxLihHyD+dS0+b/
         ynLdXOpC0F7euJoUBpsxv+MO28rk/LKkYrPWtoijomNhkz1idOXR8Jrn4hQ6D8bBCSbC
         WZr+c7G6oy3TGmlYwyEZTCmzVgKFajjPjvpWkSH22Cniu+xPelwoMsHiA41VI+0BURY+
         ocg659AUe8OZgBWuCV6fqFchjEf9BhbXGOHMEkoFxrEjPd+alwT2AAKws0IES5ENXb86
         TG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756650335; x=1757255135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tia0mrGZ7h1NCfPvef4VGNKt1YRomP862h78mFARS1M=;
        b=qq4PA5PgWdTbpPBJ7etzkqJsYCSi3SqVgDWmjLZNBIeeT90Y7W+d9ogu0vcDkpOn5U
         BFZ/ARZ5fzdCsPXBKQoRczxeJDdEB+1oKKmMcX2oTKRdLO4IKqjr8JUIQivGYPkfn434
         XD9MVTxPNqhZp0QboAQr1ZPI3QDIl6sY4YmObaF4XEUt9WjOhsAc/P4ROmLyOdB0WS2y
         QSdI/tjLF5R2V6/aikvPu/BPr6AmEULYPKFZTqrv3egNsHdvfXMgbS0iwJ2xWwB38Vm7
         fLB5WPJKI2eQUHagVb6MStLYwwBnuJTHydENua+tQkxTYd2lQfZSKEcTkIOC8p0S5JBT
         X11A==
X-Forwarded-Encrypted: i=1; AJvYcCVcmL9e6dHYR5UT3MIQ2ZFzAwLejRNK+olamqB+44UwaE1JgsKxzN4XmDmV3nl7xUP/uJoaiXp3qsrznCOc@vger.kernel.org
X-Gm-Message-State: AOJu0YzaEU5Xan7tBnjekHRNU++w1KO+jkzDW/3jRw3NrYxzwbKq6jvO
	cRUipK/bUMQ7uMMDzrMehkg7ULaaEI9HrOVx653TEnsHOVvdwEz7mM4Es6QjLlMqI2w=
X-Gm-Gg: ASbGnctyxxGzhhYQM4nhgXMP1jfRILREC6LjrpGKnyqf+4M5rlzmxBFMiWFZsNOXI9h
	sXCoQdVkfcgckC4uCstoOxGcwsyE21U1bHqq8LutwaiXuR90zBNr9RqELZuZgQlnNUj60z7ZW5p
	89IVQkxCXhy/ePvs60WbSLh1D3cjFMwv/TGqMp3uD9y8uBjZxk+yjK9Uk7wAD4skWUKNklZD53C
	lYC7lt1em4qvv13w2eM72QgtC2g3+3Qaay+4l0e+cph9KSOGouRM7noqpo9qV+mAi412YNB7CTg
	gIcA737wx6l+bARUwxM1cmVrYcCYYRToZF8leMNW8u2o3VIgHDGExEc2e+LOz0xAMjp1UsMfnaX
	7OsMvJ1F+idE+VfvoLqt9R7wGW5l7uwPdwVzUfjSE3f0yGrQ=
X-Google-Smtp-Source: AGHT+IEzLsF872AQW2WCrkafZsoPe6MW3OMi+DhNMIiv+MgumYXMxcJnQU1vk9tsPiaqMVbYQ3vByw==
X-Received: by 2002:a05:6a00:1945:b0:736:5e28:cfba with SMTP id d2e1a72fcca58-7723e33888bmr6988197b3a.18.1756650335482;
        Sun, 31 Aug 2025 07:25:35 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:c382:54ef:4bb4:90ef])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a090c77sm7784647b3a.0.2025.08.31.07.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 07:25:35 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: linux@weissschuh.net
Cc: 409411716@gms.tku.edu.tw,
	ebiggers@kernel.org,
	jaegeuk@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu
Subject: Re: [PATCH] fscrypt: optimize fscrypt_base64url_encode() with block processing
Date: Sun, 31 Aug 2025 22:25:31 +0800
Message-Id: <20250831142531.16756-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de>
References: <38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Thomas,

>On 2025-08-30 21:28:32+0800, Guan-Chun Wu wrote:
>> Previously, fscrypt_base64url_encode() processed input one byte at a
>> time, using a bitstream, accumulating bits and emitting characters when
>> 6 bits were available. This was correct but added extra computation.
>
>Can't the custom base64 implementations in fs/ not pass a custom table
>and padding to the generic algorithm in lib/? Then we only need to maintain
>this code once.
>
>
>Thomas

Thanks, that makes sense.

For v2, I’m considering extending the lib/base64 API to support a custom
encoding table and optional padding. That way, the fs/ code can just use
the generic implementation directly, and we only need to maintain the
logic in one place.

