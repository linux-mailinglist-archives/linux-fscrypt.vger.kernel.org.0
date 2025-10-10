Return-Path: <linux-fscrypt+bounces-869-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0A3BCDDDC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 17:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C81BA18861B6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Oct 2025 15:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0880D2FB99E;
	Fri, 10 Oct 2025 15:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bibn0VuR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762632EE616
	for <linux-fscrypt@vger.kernel.org>; Fri, 10 Oct 2025 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760111282; cv=none; b=SdtPfnu8Of8gav8WLm4FmSczyo/hI6ifXXc4/IDbcuTxrqLcQ4WXA3NZR1FQSJq411LOSmbdlEDojUQN0mbk52xuMREd1j3RcaCsYsQNYvwTjj5zVOBU0dAPFdacIS92nBIx6Pp3yFV+DRyIoHpA1D2aNlhzbO69sLeFoqsanGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760111282; c=relaxed/simple;
	bh=NdsUvpJDpi+f0utptiH48+P8qxTjCKD1BXdBqHb5OLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NrA2IZHg6GKu2aAAALtiX1aS7ydu2XnqlDl8Wz147yP17xXSBCPWB6B4jeDmA+uGcPtcQ0baq+xRSDraymLeO7X33dhPJ0eWndK5sABfEKJ0gwt7O3ZxeahaEKmGIzMvbEVkI5hrlQPG8Wn+GjxPK9l5BjP550VskqNqRftwrOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bibn0VuR; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b5f2c1a7e48so1485979a12.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 10 Oct 2025 08:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760111280; x=1760716080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IVrsyEiFlMWkB/upPN4SEiDIc8/lApQ9S0UUM9Wa5uQ=;
        b=Bibn0VuRo1gZ1Ith6+kwbMQxRF6QJO82MZ61cWDTgQ0zR5kc82761192OgOYQVDdf5
         FSjvU8NTpGPcguygjMc8zxB32iZFmGePFDCc6rfhTuQ2nkDI/0ehO+M9GalPGJZB/nde
         zauySeYNGccs8gPBMzVnvYXdfuN2+98Aqx2sT7LXKfD7ZPQfqzmlwfBYeWLFnBUgFm8p
         29VRElBHTnqn8xnsuYJPi6A8xnIup6C/2pF0NImKCx2TFlGdsAYrwUKEHCZ9RRhk546U
         Q+5G1e9A4WCIewy5KW04z2U4+/QdHYlDtH3+uT1rsdu0sAyVxe4rIfnnql+NNPKaOLLj
         fHVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760111280; x=1760716080;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVrsyEiFlMWkB/upPN4SEiDIc8/lApQ9S0UUM9Wa5uQ=;
        b=OdEBNrk73o3fxOqxGalIvfRlZueWze81zmKUBd87zXEsFLSMl2VqdUkudaYF3fMJ6A
         n6kLwudqY0AUtq2i2+w0WTt1zz4QkabzLJv96Wjbo0vXOU6tozFkLzmdxfLJo4r6xLGb
         QJ1jGUDS/K98ekuCS3Z3gRNCQw48hahYDLd/4evbPsq9WDuWmmwr8vJilyWqk4aRWmZP
         wu2f3erWAYFHYXOa6rbhLbMAbvhhh8RHKTt8sFspV1sAOrAmy0HMdn2fyR/Wyy6Lnl1f
         Xzo/foS3UrxVgw0vaKk291d7Rvrc8ZFdrMWQwAeAUmb6VintvJkk1DIsT65G+DEvqAbG
         bXMQ==
X-Gm-Message-State: AOJu0YzJ2miTaV+dqSuqzut3hXsjearoEPC1HaKkLFXhiTE5o+gPsV/4
	1VNa9/C4diQAi9Omji2zAHNFJdyhqf/1gymIUjvYMvz3uoBIAJc+ilvujbu6BdNMUbU=
X-Gm-Gg: ASbGncuVbqOXtNlJNEaFUoA+eiAZ6CJq4A0CVn5G8NIBPKHt4wfsNGz0e1JecNSe8Jp
	uK1AtROA8A/+lxFjIHzFILL2H3geBss90DBhy1ClAgJOXXI7iY3lX3DN1QD81d0Q6v6D01iZK46
	/BZDAyCHHgvjyP08AHHKJhDmdvYNUviOqlmbtWzhwy7D9q0stSYBVhaU7OY9Jr8fkTLfaY1HHT8
	0OCoZGo4yR7qau3WVMF+qg5nlToP3ml4V2glAJkd4sYBo1v4FA0Pk57/UFGY39ZVf3yb9wdeJeQ
	yWniKyKK/3Bt3bFj/PM23LO5fiRC7LN4bnSfK5EQMcoanOukHqfMezdA9Nco5XCbSVh0MU5iwO6
	Dr2BVIguzWx7lB2F74DHG3yVoqTVymxLRn4as
X-Google-Smtp-Source: AGHT+IECq+NaLToeqvLCJlAHobRhWtoU2tfGHlHLrRwiIikFaVG8MgZK2PzLWaGJXCNyUhyUAiHnRg==
X-Received: by 2002:a17:902:f608:b0:278:9051:8ea5 with SMTP id d9443c01a7336-290272b340fmr165277955ad.21.1760111280220;
        Fri, 10 Oct 2025 08:48:00 -0700 (PDT)
Received: from localhost ([122.171.19.27])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f06c82sm60691875ad.81.2025.10.10.08.47.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 08:47:59 -0700 (PDT)
From: Divya Bharathi <divya27392@gmail.com>
To: linux-fscrypt@vger.kernel.org
Cc: ebiggers@kernel.org,
	tytso@mit.edu,
	aegeuk@kernel.org,
	orbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Divya Bharathi <divya27392@gmail.com>
Subject: [PATCH] docs: fscrypt: document EFAULT return for FS_IOC_SET_ENCRYPTION_POLICY
Date: Fri, 10 Oct 2025 21:17:53 +0530
Message-ID: <20251010154753.19216-1-divya27392@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Divya Bharathi <divya27392@gmail.com>
---
 Documentation/filesystems/fscrypt.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4a3e844b7..26cb409e3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -729,6 +729,8 @@ FS_IOC_SET_ENCRYPTION_POLICY can fail with the following errors:
   version, mode(s), or flags; or reserved bits were set); or a v1
   encryption policy was specified but the directory has the casefold
   flag enabled (casefolding is incompatible with v1 policies).
+- ``EFAULT``: an invalid pointer was passed for the encryption policy
+  structure
 - ``ENOKEY``: a v2 encryption policy was specified, but the key with
   the specified ``master_key_identifier`` has not been added, nor does
   the process have the CAP_FOWNER capability in the initial user
-- 
2.51.0


