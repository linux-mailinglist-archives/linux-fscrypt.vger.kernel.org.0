Return-Path: <linux-fscrypt+bounces-831-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABAC1B54354
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Sep 2025 08:53:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DF1C167B59
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Sep 2025 06:53:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D952E287259;
	Fri, 12 Sep 2025 06:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="nSe9+r/Z"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D4288C20
	for <linux-fscrypt@vger.kernel.org>; Fri, 12 Sep 2025 06:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757659979; cv=none; b=Bo4u0HjLHDuOMyxnrH9wK+LBU8KjwYu6lcb0VmI/vqYjMZJxVf3DWyy0Bi1t5Skmv3r7gaJEsIP7lNZ93y6alvJFAeO0XI0lrsIN1lVTIIQHa/CSr9ga7a1ZEMSFzMjBYdJdTRg+8s2j8aziHNL83f6UfmC1McWrEFZKCrMR4hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757659979; c=relaxed/simple;
	bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fPxZeE+stDL+Ff8JFpS68GtSrtGH6UniSghtVoyzSOVZ86HaxQw9DxJnb4QgLSDgoct18gjGWmMb5CK7C+4NUBSZ4FP+j+MS7wJlPavrP/kJ8YmgTo5gGDTDptwLaVqicJKMtNMVs04ROi6MviydAlCXgj64LTTLMP4yYZdjciM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=nSe9+r/Z; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-772481b2329so1833761b3a.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 23:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757659978; x=1758264778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
        b=nSe9+r/ZU5y7WEJgrf9f3rUh1nS6uir2QVa1uhENhODP3KSZhst0fiV8hwOMzKe3uV
         BaXXTCHv7KBAQcEhfcXOYvF0AFuOzMOPY8u0hpVN7GDLeAxRyEOckWk5sD2PXkPIv0xg
         hx7VMz6C0YF6URuzBm0+PlinXwn3/cUi6RHIR+vNHqPW+du2i0dFk1qf7jnnYYcjzi7I
         crwNb53jn0Dt3y/rVPffjs+Nzh81BOZOZLT4iwUQzdKLzd+ZDi2ipqBHsBkb26TEJInc
         Zy6iq8s8ufk66lTTGc7ZOnUdpIWOdVM0shpZPuB4XpCoQZxg3akIVNVIYw5GDpfXUqqa
         RQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757659978; x=1758264778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMQ9UJhJn6NJ6YO0XjNRfud58VDObW+dwpThmQIOhd8=;
        b=xOzr68V/s+t4hziBKu/oKTes1zHu0V2//ACFNzFuHAj6ImgW5qm+nZyUsXqDOX5sLp
         I3myOWeB7mzV8xehpmlBUcjiEPtQ8WbqxU0bYaYH96Oh92Gzs3IgrJRDlU7LPIrbtuL6
         hz/z7YefynfpM5EGELizHG9xrROqZiMnBBxev88jONrRjlBzvonI1OqsA2BUEDvYZsAC
         I0aASXtVXQgSVp9QaBSSPqUWPIbadfI2OX2YVQEpGbZjX9t3HleX30Mrp567MnLm5RmP
         sn1217SBb+2FdjUxwmc2XJ1TSLpOs1/YoXv0gWaySACzyNjYT2sM29bCxxKmiZ68pUjD
         74pA==
X-Forwarded-Encrypted: i=1; AJvYcCUNh1h9iUAFlzxRxjR5gWEJu0smqVn/HkQCCOyHymFfzrnuTH7GTCTczfmNbEDrm+6MjJJrS9t/eb9G71ZI@vger.kernel.org
X-Gm-Message-State: AOJu0YzL45Chdjh5l1GqGfmfAezPMOu9qMUVs70JJqmM3RfazOelF9vf
	jujsvqWphFkWvIgwKl3UsJHhz0PYGe2lkmy54HFM/ZlFSPlcTkpwUPGeMQO0HRJYXjw=
X-Gm-Gg: ASbGncuvdEEkskTzW1hT3VOOxH7FaiR06KUQjFTc0nHaqrlWZUF1lA0sQl8I6DvN16C
	i0S0fLotVAuvGTYMObvchau2UuVbmrfBYaa9OL2iQXLY5H173vp7cXlbwwoR++JMFYCnU4pf5F1
	41fUPNM82DvGDK3aRDPKjDhh4MP7UyhEfraWJe+d2LKIuQIQop23eSDpl1kSu+B0SNoVrA3bVDZ
	nEOkfeHQt6eR1PYSndJfu5lvyfdQC2yMBo86kyEP221ujHPdFu590Ngs7GVm3Ys+Fod1oQKARlU
	C6Uz1OW5E8lG+LWNf24V1eSnz2kmWnS8coZEmGoEKosf1y9r86qpmxaQzJlQ5c83Th8ORUM8xG+
	xXF2aJVzFQFPGJnAEDyPFM8DsDpw0zE/gnDx6i1DaDYidfyA=
X-Google-Smtp-Source: AGHT+IFQKeePLPos3Wc/vCSrtfD9DK3M1OpdAn6C2aQwDSA3Qht9Qgg36mVj/vePp62ddGIi74wlig==
X-Received: by 2002:a05:6a00:2ea2:b0:76e:2eff:7ae9 with SMTP id d2e1a72fcca58-77612092482mr1980655b3a.12.1757659977712;
        Thu, 11 Sep 2025 23:52:57 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c49fe4sm4410985b3a.101.2025.09.11.23.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 23:52:56 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v2 2/5] lib/base64: rework encoder/decoder with customizable support and update nvme-auth
Date: Fri, 12 Sep 2025 14:52:52 +0800
Message-Id: <20250912065252.857420-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aMO/woLrAN7bn9Fd@wu-Pro-E500-G6-WS720T>
References: <aMO/woLrAN7bn9Fd@wu-Pro-E500-G6-WS720T>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorry, please ignore my previous email. My email client was not configured correctly.

Best regards,
Guan-chun

