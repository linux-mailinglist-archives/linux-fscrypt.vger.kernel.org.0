Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3A53035E4
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jan 2021 06:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbhAZFzw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jan 2021 00:55:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:44846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732328AbhAZDPM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jan 2021 22:15:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA5EF22B3B;
        Tue, 26 Jan 2021 00:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611620115;
        bh=WUKP87w2XAHM6dlfW//r1KXDrQH7mn8Uptp48oDpgmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJwq9MgRk9X5D0U8P2oV7muJ59EAbweBoiO7bRVgnFmrco/uHhmeS9BiMs7qJWqMb
         rESA7mYQWU042pu7fra+aFdGl1wTxJRY72QvE7FTwM2ccJ4kqlWZy1L9ASCqmIU7Su
         eOmh+5CrgDchn9vv79/pR25PQYwwNEW+t2P/HUI1tZO/KgcvTE6kBj0s3NYeStQvXs
         jI2J5I0OWFtABp+RgWy3v1UVOefbafHTvM8qjEm+oR/PAicNt55VKxo19n2EXPr9Kp
         9EevkgExS6kn4zP/NDcCj4MkV27iSpOW63JkrWeBOl7rXxDzjJl+6aZ+h9pJH94CwH
         4Kh4HJSTHcjAA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH RESEND v6 5/9] mmc: cqhci: add cqhci_host_ops::program_key
Date:   Mon, 25 Jan 2021 16:14:52 -0800
Message-Id: <20210126001456.382989-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210126001456.382989-1-ebiggers@kernel.org>
References: <20210126001456.382989-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

On Snapdragon SoCs, the Linux kernel isn't permitted to directly access
the standard CQHCI crypto configuration registers.  Instead, programming
and evicting keys must be done through vendor-specific SMC calls.

To support this hardware, add a ->program_key() method to
'struct cqhci_host_ops'.  This allows overriding the standard CQHCI
crypto key programming / eviction procedure.

This is inspired by the corresponding UFS crypto support, which uses
these same SMC calls.  See commit 1bc726e26ef3 ("scsi: ufs: Add
program_key() variant op").

Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Satya Tangirala <satyat@google.com>
Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-crypto.c | 22 +++++++++++++---------
 drivers/mmc/host/cqhci.h        |  4 ++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index 0e2a9dcac6308..6419cfbb4ab78 100644
--- a/drivers/mmc/host/cqhci-crypto.c
+++ b/drivers/mmc/host/cqhci-crypto.c
@@ -30,13 +30,16 @@ cqhci_host_from_ksm(struct blk_keyslot_manager *ksm)
 	return mmc->cqe_private;
 }
 
-static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
-				     const union cqhci_crypto_cfg_entry *cfg,
-				     int slot)
+static int cqhci_crypto_program_key(struct cqhci_host *cq_host,
+				    const union cqhci_crypto_cfg_entry *cfg,
+				    int slot)
 {
 	u32 slot_offset = cq_host->crypto_cfg_register + slot * sizeof(*cfg);
 	int i;
 
+	if (cq_host->ops->program_key)
+		return cq_host->ops->program_key(cq_host, cfg, slot);
+
 	/* Clear CFGE */
 	cqhci_writel(cq_host, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 
@@ -51,6 +54,7 @@ static void cqhci_crypto_program_key(struct cqhci_host *cq_host,
 	/* Write dword 16, which includes the new value of CFGE */
 	cqhci_writel(cq_host, le32_to_cpu(cfg->reg_val[16]),
 		     slot_offset + 16 * sizeof(cfg->reg_val[0]));
+	return 0;
 }
 
 static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
@@ -67,6 +71,7 @@ static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 	int i;
 	int cap_idx = -1;
 	union cqhci_crypto_cfg_entry cfg = {};
+	int err;
 
 	BUILD_BUG_ON(CQHCI_CRYPTO_KEY_SIZE_INVALID != 0);
 	for (i = 0; i < cq_host->crypto_capabilities.num_crypto_cap; i++) {
@@ -93,13 +98,13 @@ static int cqhci_crypto_keyslot_program(struct blk_keyslot_manager *ksm,
 		memcpy(cfg.crypto_key, key->raw, key->size);
 	}
 
-	cqhci_crypto_program_key(cq_host, &cfg, slot);
+	err = cqhci_crypto_program_key(cq_host, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return 0;
+	return err;
 }
 
-static void cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
+static int cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
 {
 	/*
 	 * Clear the crypto cfg on the device. Clearing CFGE
@@ -107,7 +112,7 @@ static void cqhci_crypto_clear_keyslot(struct cqhci_host *cq_host, int slot)
 	 */
 	union cqhci_crypto_cfg_entry cfg = {};
 
-	cqhci_crypto_program_key(cq_host, &cfg, slot);
+	return cqhci_crypto_program_key(cq_host, &cfg, slot);
 }
 
 static int cqhci_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
@@ -116,8 +121,7 @@ static int cqhci_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
 {
 	struct cqhci_host *cq_host = cqhci_host_from_ksm(ksm);
 
-	cqhci_crypto_clear_keyslot(cq_host, slot);
-	return 0;
+	return cqhci_crypto_clear_keyslot(cq_host, slot);
 }
 
 /*
diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
index 8e9e8f5db5bcc..ba9387ed90eb6 100644
--- a/drivers/mmc/host/cqhci.h
+++ b/drivers/mmc/host/cqhci.h
@@ -286,6 +286,10 @@ struct cqhci_host_ops {
 				 u64 *data);
 	void (*pre_enable)(struct mmc_host *mmc);
 	void (*post_disable)(struct mmc_host *mmc);
+#ifdef CONFIG_MMC_CRYPTO
+	int (*program_key)(struct cqhci_host *cq_host,
+			   const union cqhci_crypto_cfg_entry *cfg, int slot);
+#endif
 };
 
 static inline void cqhci_writel(struct cqhci_host *host, u32 val, int reg)
-- 
2.30.0

