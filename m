Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8879E1799A1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Mar 2020 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbgCDUS1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Mar 2020 15:18:27 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29141 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728482AbgCDUS1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Mar 2020 15:18:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583353106; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Sender; bh=xwQrcELKm8+CGNRcrWhlucL89Q9eUPGyaf52hsWxIiw=; b=HnqDThwiYb8QgcVzifZDKf5u4DnFTlF8NO8LTNeM3oYGbJvKgXU7OQdxEKh2+AP0iQNaMyl6
 Hn6LUI+qqMC+hDXMpkjY11OG5hh8l8gEiApZFRu3nlmM4wxJFNVl4NkZC/C730B/Lv9CuCGT
 INZ1tQLN+3aKXu8UKhF5dXOPpJI=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI5MDEzZSIsICJsaW51eC1mc2NyeXB0QHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e600d11.7f7f3d65af80-smtp-out-n05;
 Wed, 04 Mar 2020 20:18:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76124C4479D; Wed,  4 Mar 2020 20:18:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from BMUTHUKU (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bmuthuku)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1073AC43383;
        Wed,  4 Mar 2020 20:18:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1073AC43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=bmuthuku@codeaurora.org
From:   <bmuthuku@codeaurora.org>
To:     "'Eric Biggers'" <ebiggers@kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Cc:     <linux-block@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Andy Gross'" <agross@kernel.org>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Barani Muthukumaran'" <bmuthuku@qti.qualcomm.com>,
        "'Bjorn Andersson'" <bjorn.andersson@linaro.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Elliot Berman'" <eberman@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "Neeraj Soni" <neersoni@qti.qualcomm.com>,
        "Gaurav Kashyap" <gaurkash@qti.qualcomm.com>,
        "Ravi Pathuru" <spathuru@qti.qualcomm.com>
References: <20200304064942.371978-1-ebiggers@kernel.org> <20200304064942.371978-4-ebiggers@kernel.org>
In-Reply-To: <20200304064942.371978-4-ebiggers@kernel.org>
Subject: RE: [RFC PATCH v2 3/4] scsi: ufs: add program_key() variant op
Date:   Wed, 4 Mar 2020 12:18:20 -0800
Message-ID: <000301d5f262$0d0dc260$27294720$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHV4AOcHaqcNbBin8YHf2Ps/jcLLAJYKj8rqCZBC2A=
Content-Language: en-us
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric, I strongly recommend not to support the old mechanism of calling into
TEE to set keys as this has been deprecated and will not work with newer
hardware. There are few issues with this patch, it adds all the code within
UFS and we would have to reimplement all the common ICE code for eMMC as
well. For clearing a key, the patch uses program_key to set zeroes to the
keyslot, without going into details (since newer hardware is not yet public)
this will not work.

We have a plan to upstream ICE support with the new hardware along with the
framework to support wrapped keys and add sdhci/cqhci-crypto support.

-----Original Message-----
From: linux-fscrypt-owner@vger.kernel.org
<linux-fscrypt-owner@vger.kernel.org> On Behalf Of Eric Biggers
Sent: Tuesday, March 3, 2020 10:50 PM
To: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org
Cc: linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; Alim Akhtar
<alim.akhtar@samsung.com>; Andy Gross <agross@kernel.org>; Avri Altman
<avri.altman@wdc.com>; Barani Muthukumaran <bmuthuku@qti.qualcomm.com>;
Bjorn Andersson <bjorn.andersson@linaro.org>; Can Guo <cang@codeaurora.org>;
Elliot Berman <eberman@codeaurora.org>; Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [RFC PATCH v2 3/4] scsi: ufs: add program_key() variant op

From: Eric Biggers <ebiggers@google.com>

On Snapdragon SoCs, the Linux kernel isn't permitted to directly access the
standard UFS crypto configuration registers.  Instead, programming and
evicting keys must be done through vendor-specific SMC calls.

To support this hardware, add a ->program_key() method to 'struct
ufs_hba_variant_ops'.  This allows overriding the UFS standard key
programming / eviction procedure.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd-crypto.c | 34 +++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.h        |  3 +++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-crypto.c
b/drivers/scsi/ufs/ufshcd-crypto.c
index cd7ca50a1dd9..7c50d1d4f58c 100644
--- a/drivers/scsi/ufs/ufshcd-crypto.c
+++ b/drivers/scsi/ufs/ufshcd-crypto.c
@@ -131,14 +131,20 @@ static int ufshcd_crypto_cfg_entry_write_key(union
ufs_crypto_cfg_entry *cfg,
 	return -EINVAL;
 }
 
-static void ufshcd_program_key(struct ufs_hba *hba,
-			       const union ufs_crypto_cfg_entry *cfg,
-			       int slot)
+static int ufshcd_program_key(struct ufs_hba *hba,
+			      const union ufs_crypto_cfg_entry *cfg, int
slot)
 {
 	int i;
 	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
+	int err = 0;
 
 	ufshcd_hold(hba, false);
+
+	if (hba->vops && hba->vops->program_key) {
+		err = hba->vops->program_key(hba, cfg, slot);
+		goto out;
+	}
+
 	/* Ensure that CFGE is cleared before programming the key */
 	ufshcd_writel(hba, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]));
 	for (i = 0; i < 16; i++) {
@@ -151,23 +157,28 @@ static void ufshcd_program_key(struct ufs_hba *hba,
 	/* Dword 16 must be written last */
 	ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
 		      slot_offset + 16 * sizeof(cfg->reg_val[0]));
+out:
 	ufshcd_release(hba);
+	return err;
 }
 
-static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
+static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
 {
 	union ufs_crypto_cfg_entry cfg = { 0 };
 
-	ufshcd_program_key(hba, &cfg, slot);
+	return ufshcd_program_key(hba, &cfg, slot);
 }
 
 /* Clear all keyslots at driver init time */  static void
ufshcd_clear_all_keyslots(struct ufs_hba *hba)  {
 	int slot;
+	int err;
 
-	for (slot = 0; slot < ufshcd_num_keyslots(hba); slot++)
-		ufshcd_clear_keyslot(hba, slot);
+	for (slot = 0; slot < ufshcd_num_keyslots(hba); slot++) {
+		err = ufshcd_clear_keyslot(hba, slot);
+		WARN_ON_ONCE(err);
+	}
 }
 
 static int ufshcd_crypto_keyslot_program(struct keyslot_manager *ksm, @@
-203,10 +214,11 @@ static int ufshcd_crypto_keyslot_program(struct
keyslot_manager *ksm,
 	if (err)
 		return err;
 
-	ufshcd_program_key(hba, &cfg, slot);
+	err = ufshcd_program_key(hba, &cfg, slot);
 
 	memzero_explicit(&cfg, sizeof(cfg));
-	return 0;
+
+	return err;
 }
 
 static int ufshcd_crypto_keyslot_evict(struct keyslot_manager *ksm, @@
-223,9 +235,7 @@ static int ufshcd_crypto_keyslot_evict(struct
keyslot_manager *ksm,
 	 * Clear the crypto cfg on the device. Clearing CFGE
 	 * might not be sufficient, so just clear the entire cfg.
 	 */
-	ufshcd_clear_keyslot(hba, slot);
-
-	return 0;
+	return ufshcd_clear_keyslot(hba, slot);
 }
 
 void ufshcd_crypto_enable(struct ufs_hba *hba) diff --git
a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
c8f948aa5e3d..c2656575e24b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -306,6 +306,7 @@ struct ufs_pwr_mode_info {
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
+ * @program_key: program or evict an inline encryption key
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -335,6 +336,8 @@ struct ufs_hba_variant_ops {
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
 	void	(*device_reset)(struct ufs_hba *hba);
+	int	(*program_key)(struct ufs_hba *hba,
+			       const union ufs_crypto_cfg_entry *cfg, int
slot);
 };
 
 /* clock gating state  */
--
2.25.1

