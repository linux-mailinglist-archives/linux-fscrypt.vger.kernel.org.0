Return-Path: <linux-fscrypt+bounces-147-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B532B843010
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:39:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71EF8288433
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D3C78661;
	Tue, 30 Jan 2024 22:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Rh9EW82U"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0B512CD87;
	Tue, 30 Jan 2024 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654250; cv=none; b=ncXNAMheC9skD4JLf7ijxbhCVkaPmNmSk01UUH63fzP+rg+lTO86m1dfqaQMx2Z2bWdpotraF+VdmTqwxSWfryBWta576jjUgBqaM1HDlimsXmW/aSzZR9ZeTWZTdO3NiDsjil5jzTxseSTw2XKxAINsXz6qyESGRbTk2cRMMbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654250; c=relaxed/simple;
	bh=e+4lAQRk+1sqWv+mWddB1VL2xD4FFXo+2TSqecsvggQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=kE7SLa9w5Vjgg+4HTPI24AnBM9cPfUvqHuHID7eMMxVC3YwMnWKfQlBx2Q1BG2/m6Y70iT7aUDXapZNdlfvndJneq00eTw7LVNGOYj1qGPExoBLXtHLbGfTYZerP1tTPDV8sKCnFDnAraOQH3ambwEpfGHEkf60kvefFZnk7mtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Rh9EW82U; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 9987720B2015; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9987720B2015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=Bn8u6PAyziVes0s1hsHk4jpq4JCxu5y2joWk5Bg0G+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh9EW82UHPEc63gzo6A71jZ0RXefXsNEOrBrjIzHQOH6O3ROai3DR6IzwuFsQS52P
	 d4VHrYnGT+n1wBbLsv7kWO69RcAyb6EztZUaAOv5rjr2HGBB6y4cCyX8SHskPEzgSY
	 jtE6s7yVHZGWgBIbuhej61FM7JlaTjOKe10n4Bw0=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v12 12/20] dm verity: set DM_TARGET_SINGLETON feature flag
Date: Tue, 30 Jan 2024 14:37:00 -0800
Message-Id: <1706654228-17180-13-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

The device-mapper has a flag to mark targets as singleton, which is a
required flag for immutable targets. Without this flag, multiple
dm-verity targets can be added to a mapped device, which has no
practical use cases and will let dm_table_get_immutable_target return
NULL. This patch adds the missing flag, restricting only one
dm-verity target per mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present

v11:
  + Introduced

v12:
  + No changes
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 14e58ae70521..66a850c02be4 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1507,7 +1507,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.features	= DM_TARGET_IMMUTABLE,
+	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.version	= {1, 9, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
-- 
2.43.0


