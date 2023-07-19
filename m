Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2532759BF9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jul 2023 19:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbjGSRIB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jul 2023 13:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjGSRH6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jul 2023 13:07:58 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061C2B7;
        Wed, 19 Jul 2023 10:07:58 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36JDiseY026989;
        Wed, 19 Jul 2023 17:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=qcppdkim1;
 bh=Jpuzc2CXthFAQJY0y7aFbzJS7cU7u80TEaNwPH6FLgI=;
 b=kgXIEZWqKHlsJEV5Dif/xyvgOavND/JP5DkQO0OF8omcK+tlNcw0pCSxd3wVJkSe+cf4
 DgOl4XQQkYRozPH6OnVs2M4M9YJ8vVjsaKuzd2yq4BfnUdymwJkw6ponDlAQlJoOn5iZ
 +oHme+UGNd0UTO/XmKWtZrGEhyZa/7N9KYpXrtTHcsepFNjuSrTuH4j065or/r1wywXN
 Of1VW/FUStpBcZSpcoZ0HOmFGzd9rvaTPK3vXh4p7Uacudh9UVbCcFhWce76B1+BEXeb
 m2LR8VtDwexhPPHZz+QfoznmYdfo6GjEVjgikz6aoLghVyu7Cep4/arsESQTMbWinFMI gA== 
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3rx1hx2amh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:54 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 36JH7sLY012853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Jul 2023 17:07:54 GMT
Received: from hu-gaurkash-lv.qualcomm.com (10.49.16.6) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.30; Wed, 19 Jul 2023 10:07:53 -0700
From:   Gaurav Kashyap <quic_gaurkash@quicinc.com>
To:     <linux-scsi@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ebiggers@google.com>
CC:     <linux-mmc@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-fscrypt@vger.kernel.org>, <omprsing@qti.qualcomm.com>,
        <quic_psodagud@quicinc.com>, <avmenon@quicinc.com>,
        <abel.vesa@linaro.org>, <quic_spuppala@quicinc.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 08/10] ufs: core: add support for generate, import and prepare keys
Date:   Wed, 19 Jul 2023 10:04:22 -0700
Message-ID: <20230719170423.220033-9-quic_gaurkash@quicinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: O6UHFnEMD1MuT1m9o20_R7WBw04ZUXVS
X-Proofpoint-ORIG-GUID: O6UHFnEMD1MuT1m9o20_R7WBw04ZUXVS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-19_11,2023-07-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 adultscore=0 clxscore=1015 mlxscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2306200000 definitions=main-2307190154
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch contains two changes in UFS for wrapped keys.
1. Implements the blk_crypto_profile ops for generate, import
   and prepare key apis.
2. Defines UFS vops for generate, import and prepare keys so
   that vendors can hook into them.

Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
---
 drivers/ufs/core/ufshcd-crypto.c | 45 ++++++++++++++++++++++++++++++++
 include/ufs/ufshcd.h             | 14 ++++++++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
index 2d8f43f2df1d..33a8653a7cd6 100644
--- a/drivers/ufs/core/ufshcd-crypto.c
+++ b/drivers/ufs/core/ufshcd-crypto.c
@@ -144,10 +144,55 @@ static int ufshcd_crypto_derive_sw_secret(struct blk_crypto_profile *profile,
 	return -EOPNOTSUPP;
 }
 
+static int ufshcd_crypto_generate_key(struct blk_crypto_profile *profile,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->generate_key)
+		return  hba->vops->generate_key(hba, longterm_wrapped_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_prepare_key(struct blk_crypto_profile *profile,
+		const u8 *longterm_wrapped_key,
+		size_t longterm_wrapped_key_size,
+		u8 ephemerally_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->prepare_key)
+		return  hba->vops->prepare_key(hba, longterm_wrapped_key,
+			longterm_wrapped_key_size, ephemerally_wrapped_key);
+
+	return -EOPNOTSUPP;
+}
+
+static int ufshcd_crypto_import_key(struct blk_crypto_profile *profile,
+		const u8 *imported_key,
+		size_t imported_key_size,
+		u8 longterm_wrapped_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct ufs_hba *hba =
+		container_of(profile, struct ufs_hba, crypto_profile);
+
+	if (hba->vops && hba->vops->import_key)
+		return  hba->vops->import_key(hba, imported_key,
+			imported_key_size, longterm_wrapped_key);
+
+	return -EOPNOTSUPP;
+}
+
 static const struct blk_crypto_ll_ops ufshcd_crypto_ops = {
 	.keyslot_program	= ufshcd_crypto_keyslot_program,
 	.keyslot_evict		= ufshcd_crypto_keyslot_evict,
 	.derive_sw_secret	= ufshcd_crypto_derive_sw_secret,
+	.generate_key		= ufshcd_crypto_generate_key,
+	.prepare_key		= ufshcd_crypto_prepare_key,
+	.import_key		= ufshcd_crypto_import_key,
 };
 
 static enum blk_crypto_mode_num
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index cef8e619fe5d..9c4824d46a2f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -300,6 +300,9 @@ struct ufs_pwr_mode_info {
  * @config_scaling_param: called to configure clock scaling parameters
  * @program_key: program or evict an inline encryption key
  * @derive_sw_secret: derive sw secret from a wrapped key
+ * @generate_key: generate a storage key and return longterm wrapped key
+ * @prepare_key: unwrap longterm key and return ephemeral wrapped key
+ * @import_key: import sw storage key and return longterm wrapped key
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear switch
  * @mcq_config_resource: called to configure MCQ platform resources
@@ -347,6 +350,17 @@ struct ufs_hba_variant_ops {
 	int	(*derive_sw_secret)(struct ufs_hba *hba, const u8 wrapped_key[],
 				    unsigned int wrapped_key_size,
 				    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+	int	(*generate_key)(struct ufs_hba *hba, u8 longterm_wrapped_key[
+				BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*prepare_key)(struct ufs_hba *hba,
+			       const u8 *longterm_wrapped_key,
+			       unsigned int longterm_wrapped_key_size,
+			       u8 ephemerally_wrapped_key[
+			       BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+	int	(*import_key)(struct ufs_hba *hba, const u8 *imported_key,
+			      unsigned int imported_key_size,
+			      u8 longterm_wrapped_key[
+			      BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
 	void	(*reinit_notify)(struct ufs_hba *);
-- 
2.25.1

