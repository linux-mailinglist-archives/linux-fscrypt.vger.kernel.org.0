Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0FF52CCC06
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Dec 2020 03:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgLCCIr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 21:08:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726535AbgLCCIq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 21:08:46 -0500
From:   Eric Biggers <ebiggers@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
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
Subject: [PATCH v2 3/9] mmc: cqhci: initialize upper 64 bits of 128-bit task descriptors
Date:   Wed,  2 Dec 2020 18:05:10 -0800
Message-Id: <20201203020516.225701-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203020516.225701-1-ebiggers@kernel.org>
References: <20201203020516.225701-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Move the task descriptor initialization into cqhci_prep_task_desc(), and
make it initialize all 128 bits of the task descriptor if the host
controller is using 128-bit task descriptors.

This is needed to prepare for CQHCI inline encryption support, which
requires 128-bit task descriptors and uses the upper 64 bits.

Note: since some host controllers already enable 128-bit task
descriptors, it's unclear why the previous code worked when it wasn't
initializing the upper 64 bits.  One possibility is that the bits are
being ignored because the features that use them aren't enabled yet.
In any case, setting them to 0 won't hurt.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/host/cqhci-core.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/cqhci-core.c b/drivers/mmc/host/cqhci-core.c
index 697fe40756bf2..ad7c9acff1728 100644
--- a/drivers/mmc/host/cqhci-core.c
+++ b/drivers/mmc/host/cqhci-core.c
@@ -408,13 +408,15 @@ static void cqhci_disable(struct mmc_host *mmc)
 }
 
 static void cqhci_prep_task_desc(struct mmc_request *mrq,
-					u64 *data, bool intr)
+				 struct cqhci_host *cq_host, int tag)
 {
+	__le64 *task_desc = (__le64 __force *)get_desc(cq_host, tag);
 	u32 req_flags = mrq->data->flags;
+	u64 desc0;
 
-	*data = CQHCI_VALID(1) |
+	desc0 = CQHCI_VALID(1) |
 		CQHCI_END(1) |
-		CQHCI_INT(intr) |
+		CQHCI_INT(1) |
 		CQHCI_ACT(0x5) |
 		CQHCI_FORCED_PROG(!!(req_flags & MMC_DATA_FORCED_PRG)) |
 		CQHCI_DATA_TAG(!!(req_flags & MMC_DATA_DAT_TAG)) |
@@ -425,8 +427,19 @@ static void cqhci_prep_task_desc(struct mmc_request *mrq,
 		CQHCI_BLK_COUNT(mrq->data->blocks) |
 		CQHCI_BLK_ADDR((u64)mrq->data->blk_addr);
 
-	pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx\n",
-		 mmc_hostname(mrq->host), mrq->tag, (unsigned long long)*data);
+	task_desc[0] = cpu_to_le64(desc0);
+
+	if (cq_host->caps & CQHCI_TASK_DESC_SZ_128) {
+		u64 desc1 = 0;
+
+		task_desc[1] = cpu_to_le64(desc1);
+
+		pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx%016llx\n",
+			 mmc_hostname(mrq->host), mrq->tag, desc1, desc0);
+	} else {
+		pr_debug("%s: cqhci: tag %d task descriptor 0x%016llx\n",
+			 mmc_hostname(mrq->host), mrq->tag, desc0);
+	}
 }
 
 static int cqhci_dma_map(struct mmc_host *host, struct mmc_request *mrq)
@@ -567,8 +580,6 @@ static inline int cqhci_tag(struct mmc_request *mrq)
 static int cqhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 {
 	int err = 0;
-	u64 data = 0;
-	u64 *task_desc = NULL;
 	int tag = cqhci_tag(mrq);
 	struct cqhci_host *cq_host = mmc->cqe_private;
 	unsigned long flags;
@@ -598,9 +609,8 @@ static int cqhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 	}
 
 	if (mrq->data) {
-		task_desc = (__le64 __force *)get_desc(cq_host, tag);
-		cqhci_prep_task_desc(mrq, &data, 1);
-		*task_desc = cpu_to_le64(data);
+		cqhci_prep_task_desc(mrq, cq_host, tag);
+
 		err = cqhci_prep_tran_desc(mrq, cq_host, tag);
 		if (err) {
 			pr_err("%s: cqhci: failed to setup tx desc: %d\n",
-- 
2.29.2

