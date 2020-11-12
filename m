Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3733A2B0E4B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Nov 2020 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgKLTlT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Nov 2020 14:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgKLTlS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Nov 2020 14:41:18 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BD652225D;
        Thu, 12 Nov 2020 19:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605210076;
        bh=IUjOSIQZD6Z+EjSb6Dg28SrVH/30Bkh20OYYepkiFow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/caqjtYVqaKdJN0n9uJSAwIO+PFlS90Srb5m3dzj63pbGN2dl6abrRrR0AQvhmG9
         5HLpJlrhBu75/K68s/yIlNigqb+xJAlne+tHoAK36DMBuTV42KCepVufssI+qpseu8
         hWdDtPYTRlPmRInsV0NID/i7eMcJV30GdVT1HiyU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-mmc@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ritesh Harjani <riteshh@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: [PATCH 4/8] mmc: cqhci: add cqhci_host_ops::program_key
Date:   Thu, 12 Nov 2020 11:40:07 -0800
Message-Id: <20201112194011.103774-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201112194011.103774-1-ebiggers@kernel.org>
References: <20201112194011.103774-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-crypto.c | 22 +++++++++++++---------
 drivers/mmc/host/cqhci.h        |  4 ++++
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/cqhci-crypto.c b/drivers/mmc/host/cqhci-crypto.c
index b14a5a15f5b52..5e3488c19f70e 100644
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
 
 static const struct blk_ksm_ll_ops cqhci_ksm_ops = {
diff --git a/drivers/mmc/host/cqhci.h b/drivers/mmc/host/cqhci.h
index 5c18734624fea..ece997dd8bcc7 100644
--- a/drivers/mmc/host/cqhci.h
+++ b/drivers/mmc/host/cqhci.h
@@ -287,6 +287,10 @@ struct cqhci_host_ops {
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
2.29.2

