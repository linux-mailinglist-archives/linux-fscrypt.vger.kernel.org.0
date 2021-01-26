Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE15D3035DE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jan 2021 06:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbhAZFzo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jan 2021 00:55:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732169AbhAZCGR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jan 2021 21:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7326022AAA;
        Tue, 26 Jan 2021 00:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611620112;
        bh=R8sFfCHubgkOU0cGm4n8neybL2+MAy4yCvazMFWKA44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R20i+Ru87U4OBpNu7yIG2s8yKqd9X++mhBDy6OkNHv3qEKe/UmaZ+e2j29B+xfkhs
         8LKx5+c/IIbu/uElLWTHX6pgw+OSLcPTD5CFqTgP+3l3SEZga1KqIRWYsnRw1WZzQX
         31104r/Z5WU9HEX4TINfhEiJv+I7ShAJUbAZ0BQdr8i/haYlMv1wuohWJgPJjndyjh
         xyp3EK+f6tDiysX4e9iPeojLZGai+z5IeFjZCQan4jGF+aRa+wNHf8zns2Zu8TuYyM
         B2TN48eb8hxvYwmb1Rhx+f1GQ5mKx6OJK874UT2v1HCKFNZx0ozd23kRqMkf1n4pqt
         R5Y3Tgp6hXm0w==
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
Subject: [PATCH RESEND v6 1/9] mmc: add basic support for inline encryption
Date:   Mon, 25 Jan 2021 16:14:48 -0800
Message-Id: <20210126001456.382989-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210126001456.382989-1-ebiggers@kernel.org>
References: <20210126001456.382989-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding CQHCI crypto engine (inline encryption)
support, add the code required to make mmc_core and mmc_block aware of
inline encryption.  Specifically:

- Add a capability flag MMC_CAP2_CRYPTO to struct mmc_host.  Drivers
  will set this if the host and driver support inline encryption.

- Embed a blk_keyslot_manager in struct mmc_host.  Drivers will
  initialize this (as a device-managed resource) if the host and driver
  support inline encryption.  mmc_block registers this keyslot manager
  with the request_queue of any MMC card attached to the host.

- Make mmc_block copy the crypto keyslot and crypto data unit number
  from struct request to struct mmc_request, so that drivers will have
  access to them.

- If the MMC host is reset, reprogram all the keyslots to ensure that
  the software state stays in sync with the hardware state.

Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Satya Tangirala <satyat@google.com>
Reviewed-and-tested-by: Peng Zhou <peng.zhou@mediatek.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/mmc/core/Kconfig  |  8 +++++++
 drivers/mmc/core/Makefile |  1 +
 drivers/mmc/core/block.c  |  3 +++
 drivers/mmc/core/core.c   |  3 +++
 drivers/mmc/core/crypto.c | 48 +++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/crypto.h | 40 ++++++++++++++++++++++++++++++++
 drivers/mmc/core/host.c   |  1 +
 drivers/mmc/core/queue.c  |  3 +++
 include/linux/mmc/core.h  |  6 +++++
 include/linux/mmc/host.h  | 11 +++++++++
 10 files changed, 124 insertions(+)
 create mode 100644 drivers/mmc/core/crypto.c
 create mode 100644 drivers/mmc/core/crypto.h

diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
index c12fe13e4b147..ae8b69aee6190 100644
--- a/drivers/mmc/core/Kconfig
+++ b/drivers/mmc/core/Kconfig
@@ -81,3 +81,11 @@ config MMC_TEST
 	  This driver is only of interest to those developing or
 	  testing a host driver. Most people should say N here.
 
+config MMC_CRYPTO
+	bool "MMC Crypto Engine Support"
+	depends on BLK_INLINE_ENCRYPTION
+	help
+	  Enable Crypto Engine Support in MMC.
+	  Enabling this makes it possible for the kernel to use the crypto
+	  capabilities of the MMC device (if present) to perform crypto
+	  operations on data being transferred to/from the device.
diff --git a/drivers/mmc/core/Makefile b/drivers/mmc/core/Makefile
index 95ffe008ebdf8..6a907736cd7a5 100644
--- a/drivers/mmc/core/Makefile
+++ b/drivers/mmc/core/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_MMC_BLOCK)		+= mmc_block.o
 mmc_block-objs			:= block.o queue.o
 obj-$(CONFIG_MMC_TEST)		+= mmc_test.o
 obj-$(CONFIG_SDIO_UART)		+= sdio_uart.o
+mmc_core-$(CONFIG_MMC_CRYPTO)	+= crypto.o
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 42e27a2982180..b877f62df3660 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -51,6 +51,7 @@
 #include "block.h"
 #include "core.h"
 #include "card.h"
+#include "crypto.h"
 #include "host.h"
 #include "bus.h"
 #include "mmc_ops.h"
@@ -1247,6 +1248,8 @@ static void mmc_blk_data_prep(struct mmc_queue *mq, struct mmc_queue_req *mqrq,
 
 	memset(brq, 0, sizeof(struct mmc_blk_request));
 
+	mmc_crypto_prepare_req(mqrq);
+
 	brq->mrq.data = &brq->data;
 	brq->mrq.tag = req->tag;
 
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 49d9117550afe..1136b859ddd86 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -37,6 +37,7 @@
 
 #include "core.h"
 #include "card.h"
+#include "crypto.h"
 #include "bus.h"
 #include "host.h"
 #include "sdio_bus.h"
@@ -992,6 +993,8 @@ void mmc_set_initial_state(struct mmc_host *host)
 		host->ops->hs400_enhanced_strobe(host, &host->ios);
 
 	mmc_set_ios(host);
+
+	mmc_crypto_set_initial_state(host);
 }
 
 /**
diff --git a/drivers/mmc/core/crypto.c b/drivers/mmc/core/crypto.c
new file mode 100644
index 0000000000000..419a368f84029
--- /dev/null
+++ b/drivers/mmc/core/crypto.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * MMC crypto engine (inline encryption) support
+ *
+ * Copyright 2020 Google LLC
+ */
+
+#include <linux/blk-crypto.h>
+#include <linux/mmc/host.h>
+
+#include "core.h"
+#include "crypto.h"
+#include "queue.h"
+
+void mmc_crypto_set_initial_state(struct mmc_host *host)
+{
+	/* Reset might clear all keys, so reprogram all the keys. */
+	if (host->caps2 & MMC_CAP2_CRYPTO)
+		blk_ksm_reprogram_all_keys(&host->ksm);
+}
+
+void mmc_crypto_setup_queue(struct request_queue *q, struct mmc_host *host)
+{
+	if (host->caps2 & MMC_CAP2_CRYPTO)
+		blk_ksm_register(&host->ksm, q);
+}
+EXPORT_SYMBOL_GPL(mmc_crypto_setup_queue);
+
+void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq)
+{
+	struct request *req = mmc_queue_req_to_req(mqrq);
+	struct mmc_request *mrq = &mqrq->brq.mrq;
+
+	if (!req->crypt_keyslot)
+		return;
+
+	mrq->crypto_enabled = true;
+	mrq->crypto_key_slot = blk_ksm_get_slot_idx(req->crypt_keyslot);
+
+	/*
+	 * For now we assume that all MMC drivers set max_dun_bytes_supported=4,
+	 * which is the limit for CQHCI crypto.  So all DUNs should be 32-bit.
+	 */
+	WARN_ON_ONCE(req->crypt_ctx->bc_dun[0] > U32_MAX);
+
+	mrq->data_unit_num = req->crypt_ctx->bc_dun[0];
+}
+EXPORT_SYMBOL_GPL(mmc_crypto_prepare_req);
diff --git a/drivers/mmc/core/crypto.h b/drivers/mmc/core/crypto.h
new file mode 100644
index 0000000000000..fbe9a520bf90d
--- /dev/null
+++ b/drivers/mmc/core/crypto.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * MMC crypto engine (inline encryption) support
+ *
+ * Copyright 2020 Google LLC
+ */
+
+#ifndef _MMC_CORE_CRYPTO_H
+#define _MMC_CORE_CRYPTO_H
+
+struct mmc_host;
+struct mmc_queue_req;
+struct request_queue;
+
+#ifdef CONFIG_MMC_CRYPTO
+
+void mmc_crypto_set_initial_state(struct mmc_host *host);
+
+void mmc_crypto_setup_queue(struct request_queue *q, struct mmc_host *host);
+
+void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq);
+
+#else /* CONFIG_MMC_CRYPTO */
+
+static inline void mmc_crypto_set_initial_state(struct mmc_host *host)
+{
+}
+
+static inline void mmc_crypto_setup_queue(struct request_queue *q,
+					  struct mmc_host *host)
+{
+}
+
+static inline void mmc_crypto_prepare_req(struct mmc_queue_req *mqrq)
+{
+}
+
+#endif /* !CONFIG_MMC_CRYPTO */
+
+#endif /* _MMC_CORE_CRYPTO_H */
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 74e853bb69482..9b89a91b6b476 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -25,6 +25,7 @@
 #include <linux/mmc/slot-gpio.h>
 
 #include "core.h"
+#include "crypto.h"
 #include "host.h"
 #include "slot-gpio.h"
 #include "pwrseq.h"
diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 002426e3cf76c..33e7e65b6ddea 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -19,6 +19,7 @@
 #include "block.h"
 #include "core.h"
 #include "card.h"
+#include "crypto.h"
 #include "host.h"
 
 #define MMC_DMA_MAP_MERGE_SEGMENTS	512
@@ -407,6 +408,8 @@ static void mmc_setup_queue(struct mmc_queue *mq, struct mmc_card *card)
 	mutex_init(&mq->complete_lock);
 
 	init_waitqueue_head(&mq->wait);
+
+	mmc_crypto_setup_queue(mq->queue, host);
 }
 
 static inline bool mmc_merge_capable(struct mmc_host *host)
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 29aa507116261..ab19245e99451 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -162,6 +162,12 @@ struct mmc_request {
 	bool			cap_cmd_during_tfr;
 
 	int			tag;
+
+#ifdef CONFIG_MMC_CRYPTO
+	bool			crypto_enabled;
+	int			crypto_key_slot;
+	u32			data_unit_num;
+#endif
 };
 
 struct mmc_card;
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 8cf686d98a68f..927ba75666176 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -15,6 +15,7 @@
 #include <linux/mmc/card.h>
 #include <linux/mmc/pm.h>
 #include <linux/dma-direction.h>
+#include <linux/keyslot-manager.h>
 
 struct mmc_ios {
 	unsigned int	clock;			/* clock rate */
@@ -395,6 +396,11 @@ struct mmc_host {
 #define MMC_CAP2_CQE_DCMD	(1 << 24)	/* CQE can issue a direct command */
 #define MMC_CAP2_AVOID_3_3V	(1 << 25)	/* Host must negotiate down from 3.3V */
 #define MMC_CAP2_MERGE_CAPABLE	(1 << 26)	/* Host can merge a segment over the segment size */
+#ifdef CONFIG_MMC_CRYPTO
+#define MMC_CAP2_CRYPTO		(1 << 27)	/* Host supports inline encryption */
+#else
+#define MMC_CAP2_CRYPTO		0
+#endif
 
 	int			fixed_drv_type;	/* fixed driver type for non-removable media */
 
@@ -489,6 +495,11 @@ struct mmc_host {
 	bool			cqe_enabled;
 	bool			cqe_on;
 
+	/* Inline encryption support */
+#ifdef CONFIG_MMC_CRYPTO
+	struct blk_keyslot_manager ksm;
+#endif
+
 	/* Host Software Queue support */
 	bool			hsq_enabled;
 
-- 
2.30.0

