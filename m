Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8EE21B001
	for <lists+linux-fscrypt@lfdr.de>; Fri, 10 Jul 2020 09:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgGJHVv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Jul 2020 03:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgGJHVt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Jul 2020 03:21:49 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AFC2207FB;
        Fri, 10 Jul 2020 07:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594365708;
        bh=2pN1FI3WYWMs7QJB0lFYOwEYs2Kt0rr9XebJxKSIrEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ag8PSip9NYlnbJG7+V8GP5w/uX0OxCXfv4vutGc8OMkBK2vFapJr6ybdR9PhOT78M
         FoQcRAvJEoTiYz1XlbjWKpkOxAZT6LOgFJ7A+GJ0f2kj4OT/k97bTQy5R4BRffZxeH
         N4pYTT32BxmPrNKqPL0weO2c9h4BBFRu07WNVJLM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v6 2/5] scsi: ufs-qcom: name the dev_ref_clk_ctrl registers
Date:   Fri, 10 Jul 2020 00:20:09 -0700
Message-Id: <20200710072013.177481-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710072013.177481-1-ebiggers@kernel.org>
References: <20200710072013.177481-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding another optional register range to the
ufs-qcom driver, name the existing optional register range
"dev_ref_clk_ctrl_mem".  This allows the driver to refer to the optional
register ranges by name rather than index.

No device-tree files actually have to be updated due to this change,
since none of them actually declares these registers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2e6ddb5cdfc2..bd0b4ed7b37a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1275,7 +1275,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		host->dev_ref_clk_en_mask = BIT(26);
 	} else {
 		/* "dev_ref_clk_ctrl_mem" is optional resource */
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "dev_ref_clk_ctrl_mem");
 		if (res) {
 			host->dev_ref_clk_ctrl_mmio =
 					devm_ioremap_resource(dev, res);
-- 
2.27.0

