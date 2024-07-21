Return-Path: <linux-fscrypt+bounces-357-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F92E9385CE
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Jul 2024 20:39:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02EE9280FFA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 21 Jul 2024 18:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7901667CD;
	Sun, 21 Jul 2024 18:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rb/F/fxK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C82629AF;
	Sun, 21 Jul 2024 18:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721587179; cv=none; b=tlxj5dOfk79AwclyACENqD7hWJZF32c3F5nFHclb9M7pRhLD685yPaGUWYjRP8I/U4UgEnxaNxs+Q6zX1ZQKRFP8vCV3HxJu7oE9cJd6mIWsGqLFeX6PewcxqbFii63VMpeftbUpzxh1peaQEwwxBFe+cT15RpFW4b+6NywK99w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721587179; c=relaxed/simple;
	bh=AgVYzcqSthU3IfcGkK+WHU67vqvwlxreaFp0UMGnL3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jdmQSRQRfK6Oytt62JMVy4sbFq5jQVIJFMl06P3Ix+dGm34osAgHk+QJW9BDurPJLOqQQb10ldogE3ABqEe9ekM8PjgpvSxy7I7GzXNjGvlP2eIi1xLifXTLq4hltS/W6igGZUK6pqb5UxgPGLcb+vB14aGJhtOTF5mo15ykcD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rb/F/fxK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F077C116B1;
	Sun, 21 Jul 2024 18:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721587178;
	bh=AgVYzcqSthU3IfcGkK+WHU67vqvwlxreaFp0UMGnL3s=;
	h=From:To:Cc:Subject:Date:From;
	b=Rb/F/fxKDNUd3AsChSWPanpUHCSUOBZZFxoyum40o/Z253XKPYa39MV+Z1ePD6c6V
	 RmwL7NQYZlIz7O7yuRHYn4tOlh1FpBa1jcYCmnpSN62Mc/pgap6R8YuCkwBi+GxMSQ
	 ijToz47fmtQbe+VTT6wnJOpXC5u5d0ex0zo4c5/X9suulAweqduzF1JgPk/DJZVGbf
	 ZklOJnORn4JjqmK9YvFYDg84MC9heH2GPgileLHainKsgqf5aWovav6ul9eEd+IGJc
	 e6/9rYQgt1IQ5YmHjHleH+0O9QKhqzkYmbRv6JvWacFr/s0JY9IlxfuzntbATFubVn
	 qOMxS8F9z756A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-scsi@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: [PATCH] scsi: ufs: exynos: Don't resume FMP when crypto support disabled
Date: Sun, 21 Jul 2024 11:38:40 -0700
Message-ID: <20240721183840.209284-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

If exynos_ufs_fmp_init() did not enable FMP support, then
exynos_ufs_fmp_resume() should not execute the FMP-related SMC calls.

Fixes: c96499fcb403 ("scsi: ufs: exynos: Add support for Flash Memory Protector (FMP)")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/ufs/host/ufs-exynos.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 16ad3528d80b..9ec318ef52bf 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1291,10 +1291,13 @@ static void exynos_ufs_fmp_init(struct ufs_hba *hba, struct exynos_ufs *ufs)
 
 static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
+	if (!(hba->caps & UFSHCD_CAP_CRYPTO))
+		return;
+
 	arm_smccc_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DESCTYPE_3,
 		      0, 0, 0, 0, &res);
 	if (res.a0)
 		dev_err(hba->dev,
 			"SMC_CMD_FMP_SECURITY failed on resume: %ld\n", res.a0);

base-commit: 2c9b3512402ed192d1f43f4531fb5da947e72bd0
-- 
2.45.2


