Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FADA19366E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2020 04:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgCZDIh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Mar 2020 23:08:37 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:42395 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgCZDIX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Mar 2020 23:08:23 -0400
Received: by mail-ua1-f73.google.com with SMTP id x22so1795806ual.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Mar 2020 20:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zUCrBTMnJfCbwBJQT8vufO17mwz/7RWvRjbGfRNuVtw=;
        b=Wkw/JYbPxvrkDU1Nfdndoid8aYrOS1SFrxD108s5XxMaExsntG43yu0arlMGpwM5dm
         FvWge+a2FVSyz6zATZpGTQNFOGE2Q4Bhc58CuKL++sJGLuZtG+JZsWUx44zmwkkDs2tN
         erNLjfZE5nB1IIn8foZ/TxBYBdy5gHcgDaCW99jKza9w8kLvPi05FKxIGKcvSeYxtAZL
         XJ41WiQul72kWhb8okHANozwlXqfsrEFAFg7gF46LGK3K9mQZPhMNKf+1yDceqETatyF
         2kR3MI/T1ha1OgCAXaiIKpKioUADoo0KMTrK/zMpnm3ka2Qqo+NQjTE2WLbUNgI02hT9
         JJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zUCrBTMnJfCbwBJQT8vufO17mwz/7RWvRjbGfRNuVtw=;
        b=IDSWywV8G7nkV94MkG0Vg3kT3NMaBZK6LKHT/LtjWUfdwiz9PnGKG2XIOemgEDiMIX
         GHcmPFTkFTwgFf0I2DXX2n889jJ10vmFoLyRsa9Z7KsXvzrdrR8z3BWY6/Gk0Jdwbpxg
         TNDXtkfQ5znEahO6Q2AC4i4TgUm1TRc/2lOqYDgc7RGod86h2s8Ehrkfw0koMS9HgmOR
         7kHNl3FPtHA550uZjROwi4nhym2yIhlUK592BvrPRgw3yIl95OXIwGRF+3VpfYAiQEWi
         LScBzvALS7XlbBM3YA7zfW6NAqMhwFacxq10xRFw6x5GAy/PY/MzUhudcsVt8q3bL99s
         RldQ==
X-Gm-Message-State: ANhLgQ3Tv0wS0K8Wn3Mo6TH5sgSa90ElLR7Q0ibcBuvA+pSEejYoN8EF
        s8DNMKaR2gMTIvdvslo5L19xTcfx2Dk=
X-Google-Smtp-Source: ADFU+vtIk0aPbZFT4ATc515XY2iXqyJvKAUMzZoEKGVEgN9xBhqX93xhvj+u/w4Tl2xm6ZKvlGyz5p4b/SY=
X-Received: by 2002:a05:6102:3004:: with SMTP id s4mr5691679vsa.166.1585192101709;
 Wed, 25 Mar 2020 20:08:21 -0700 (PDT)
Date:   Wed, 25 Mar 2020 20:06:56 -0700
In-Reply-To: <20200326030702.223233-1-satyat@google.com>
Message-Id: <20200326030702.223233-6-satyat@google.com>
Mime-Version: 1.0
References: <20200326030702.223233-1-satyat@google.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
Subject: [PATCH v9 05/11] scsi: ufs: UFS driver v2.1 spec crypto additions
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add the crypto registers and structs defined in v2.1 of the JEDEC UFSHCI
specification in preparation to add support for inline encryption to
UFS.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 drivers/scsi/ufs/ufshcd.c |  2 ++
 drivers/scsi/ufs/ufshcd.h |  5 +++
 drivers/scsi/ufs/ufshci.h | 67 +++++++++++++++++++++++++++++++++++++--
 3 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2d705694636c2..a9c2ae9984ad7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4766,6 +4766,8 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case OCS_MISMATCH_RESP_UPIU_SIZE:
 	case OCS_PEER_COMM_FAILURE:
 	case OCS_FATAL_ERROR:
+	case OCS_INVALID_CRYPTO_CONFIG:
+	case OCS_GENERAL_CRYPTO_ERROR:
 	default:
 		result |= DID_ERROR << 16;
 		dev_err(hba->dev,
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2ae6c7c8528c7..978781c538c41 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -716,6 +716,11 @@ struct ufs_hba {
 	 * for userspace to control the power management.
 	 */
 #define UFSHCD_CAP_RPM_AUTOSUSPEND (1 << 6)
+	/*
+	 * This capability allows the host controller driver to use the
+	 * inline crypto engine, if it is present
+	 */
+#define UFSHCD_CAP_CRYPTO (1 << 7)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d37cc1cf..c0651fe6dbbc6 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -90,6 +90,7 @@ enum {
 	MASK_64_ADDRESSING_SUPPORT		= 0x01000000,
 	MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT	= 0x02000000,
 	MASK_UIC_DME_TEST_MODE_SUPPORT		= 0x04000000,
+	MASK_CRYPTO_SUPPORT			= 0x10000000,
 };
 
 #define UFS_MASK(mask, offset)		((mask) << (offset))
@@ -143,6 +144,7 @@ enum {
 #define DEVICE_FATAL_ERROR			0x800
 #define CONTROLLER_FATAL_ERROR			0x10000
 #define SYSTEM_BUS_FATAL_ERROR			0x20000
+#define CRYPTO_ENGINE_FATAL_ERROR		0x40000
 
 #define UFSHCD_UIC_HIBERN8_MASK	(UIC_HIBERNATE_ENTER |\
 				UIC_HIBERNATE_EXIT)
@@ -155,11 +157,13 @@ enum {
 #define UFSHCD_ERROR_MASK	(UIC_ERROR |\
 				DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR)
+				SYSTEM_BUS_FATAL_ERROR |\
+				CRYPTO_ENGINE_FATAL_ERROR)
 
 #define INT_FATAL_ERRORS	(DEVICE_FATAL_ERROR |\
 				CONTROLLER_FATAL_ERROR |\
-				SYSTEM_BUS_FATAL_ERROR)
+				SYSTEM_BUS_FATAL_ERROR |\
+				CRYPTO_ENGINE_FATAL_ERROR)
 
 /* HCS - Host Controller Status 30h */
 #define DEVICE_PRESENT				0x1
@@ -318,6 +322,61 @@ enum {
 	INTERRUPT_MASK_ALL_VER_21	= 0x71FFF,
 };
 
+/* CCAP - Crypto Capability 100h */
+union ufs_crypto_capabilities {
+	__le32 reg_val;
+	struct {
+		u8 num_crypto_cap;
+		u8 config_count;
+		u8 reserved;
+		u8 config_array_ptr;
+	};
+};
+
+enum ufs_crypto_key_size {
+	UFS_CRYPTO_KEY_SIZE_INVALID	= 0x0,
+	UFS_CRYPTO_KEY_SIZE_128		= 0x1,
+	UFS_CRYPTO_KEY_SIZE_192		= 0x2,
+	UFS_CRYPTO_KEY_SIZE_256		= 0x3,
+	UFS_CRYPTO_KEY_SIZE_512		= 0x4,
+};
+
+enum ufs_crypto_alg {
+	UFS_CRYPTO_ALG_AES_XTS			= 0x0,
+	UFS_CRYPTO_ALG_BITLOCKER_AES_CBC	= 0x1,
+	UFS_CRYPTO_ALG_AES_ECB			= 0x2,
+	UFS_CRYPTO_ALG_ESSIV_AES_CBC		= 0x3,
+};
+
+/* x-CRYPTOCAP - Crypto Capability X */
+union ufs_crypto_cap_entry {
+	__le32 reg_val;
+	struct {
+		u8 algorithm_id;
+		u8 sdus_mask; /* Supported data unit size mask */
+		u8 key_size;
+		u8 reserved;
+	};
+};
+
+#define UFS_CRYPTO_CONFIGURATION_ENABLE (1 << 7)
+#define UFS_CRYPTO_KEY_MAX_SIZE 64
+/* x-CRYPTOCFG - Crypto Configuration X */
+union ufs_crypto_cfg_entry {
+	__le32 reg_val[32];
+	struct {
+		u8 crypto_key[UFS_CRYPTO_KEY_MAX_SIZE];
+		u8 data_unit_size;
+		u8 crypto_cap_idx;
+		u8 reserved_1;
+		u8 config_enable;
+		u8 reserved_multi_host;
+		u8 reserved_2;
+		u8 vsb[2];
+		u8 reserved_3[56];
+	};
+};
+
 /*
  * Request Descriptor Definitions
  */
@@ -339,6 +398,7 @@ enum {
 	UTP_NATIVE_UFS_COMMAND		= 0x10000000,
 	UTP_DEVICE_MANAGEMENT_FUNCTION	= 0x20000000,
 	UTP_REQ_DESC_INT_CMD		= 0x01000000,
+	UTP_REQ_DESC_CRYPTO_ENABLE_CMD	= 0x00800000,
 };
 
 /* UTP Transfer Request Data Direction (DD) */
@@ -358,6 +418,9 @@ enum {
 	OCS_PEER_COMM_FAILURE		= 0x5,
 	OCS_ABORTED			= 0x6,
 	OCS_FATAL_ERROR			= 0x7,
+	OCS_DEVICE_FATAL_ERROR		= 0x8,
+	OCS_INVALID_CRYPTO_CONFIG	= 0x9,
+	OCS_GENERAL_CRYPTO_ERROR	= 0xA,
 	OCS_INVALID_COMMAND_STATUS	= 0x0F,
 	MASK_OCS			= 0x0F,
 };
-- 
2.25.1.696.g5e7596f4ac-goog

