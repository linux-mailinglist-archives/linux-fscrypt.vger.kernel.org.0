Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5113674F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jan 2020 07:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731465AbgAJGSa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jan 2020 01:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgAJGS1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jan 2020 01:18:27 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B2802073A;
        Fri, 10 Jan 2020 06:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578637106;
        bh=Ee2p9izgcxGtpWv84PgFIJfcISSTM0ZUb+bggD+7SqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jb3rvM4QzmHKz8wEik8cbtCyaw0honO94cDYMxfjLOj93/mwClJt7nBAC8Bf7iZ4
         P+HbfAP2Nah1u6A2PpbHYry0LdUX5b3VaBr036+FDpKfD+PF/oFm1VtIyl/IAMBv8q
         QLcDULli5LMtgf9veFv3Lv3kC/PwCrgCdQfjMyzY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        John Stultz <john.stultz@linaro.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Can Guo <cang@codeaurora.org>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [RFC PATCH 3/5] scsi: ufs: add quirk to disable inline crypto support
Date:   Thu,  9 Jan 2020 22:16:32 -0800
Message-Id: <20200110061634.46742-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110061634.46742-1-ebiggers@kernel.org>
References: <20200110061634.46742-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a quirk flag which allows UFS drivers to tell the UFS core that
their crypto support is not working properly, so should not be used
despite the host controller declaring the standard crypto support bit.

There are various situations in which this can be needed:

- When the crypto support requires vendor-specific logic that hasn't
  been implemented yet.  For example, the standard keyslot programming
  procedure doesn't work with ufs-hisi and ufs-qcom.

- When necessary vendor-specific crypto registers haven't been declared
  in the device tree for the SoC yet.

- When the crypto hardware declares an unsupported vendor-specific
  version number, has vendor-specific fuses blown which make it unusable
  in the normal way, or a vendor-specific self-test fails.

- The crypto produces the wrong results.

Originally-from: John Stultz <john.stultz@linaro.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h        | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-crypto.c
index 749c325686a7d..2c34beb47f8e0 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -278,7 +278,8 @@ int ufshcd_hba_init_crypto(struct ufs_hba *hba)
 	hba->caps &= ~UFSHCD_CAP_CRYPTO;
 
 	/* Return 0 if crypto support isn't present */
-	if (!(hba->capabilities & MASK_CRYPTO_SUPPORT))
+	if (!(hba->capabilities & MASK_CRYPTO_SUPPORT) ||
+	    (hba->quirks & UFSHCD_QUIRK_BROKEN_CRYPTO))
 		goto out;
 
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 5f5440059dd8a..b6f0d08a98a8b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -650,6 +650,13 @@ struct ufs_hba {
 	 * enabled via HCE register.
 	 */
 	#define UFSHCI_QUIRK_BROKEN_HCE				0x400
+
+	/*
+	 * This quirk needs to be enabled if the host controller advertises
+	 * inline encryption support but it doesn't work correctly.
+	 */
+	#define UFSHCD_QUIRK_BROKEN_CRYPTO			0x800
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
2.24.1

