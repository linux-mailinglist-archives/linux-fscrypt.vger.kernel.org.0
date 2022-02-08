Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF63F4ACE38
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Feb 2022 02:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343596AbiBHBsM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Feb 2022 20:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344906AbiBHBm1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Feb 2022 20:42:27 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB2AC043181;
        Mon,  7 Feb 2022 17:42:25 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 217LMWV6013010;
        Tue, 8 Feb 2022 01:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=krtvOcvXF32XPtlhSDQUP5MaKSEcLiroOIXzFu4OWs8=;
 b=YioOwb/jEzudIQpP2lrI2CfU4RzsM2ki5ykifE+j7mq3bR9EBS3qsU7166TJrl7fjqD1
 bIBJ0Y1els8DMbGhgTh+IECf8UsAN/lvr4EMT1kBLeRX/uEdCdTP60Zqzn2AQh6XBlEF
 T0X4v9Zd58NriFwCovSrEmZd5Wm8PXwucNQvKwuG0YdHT/+aBl+TrshEmSwiW2atCjS/
 CRfuxkF3UWpt90YtdEPvQYTAwybosgSbhpvXN898fQCsLFkTtZWUTkysOu0bhKmTqx0F
 UYNl/PgxcNmfauEbH046bx5VtMAvNGOE9OLJTc4qDYx7pnYxYhGg1XNKND4euvzIxRkr PQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e22u3ap7b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2181gH8I023563;
        Tue, 8 Feb 2022 01:42:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3e1ggjsksn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:42:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2181gIw642926424
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 01:42:18 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CA3AA4057;
        Tue,  8 Feb 2022 01:42:18 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B179A4055;
        Tue,  8 Feb 2022 01:42:17 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.90.153])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Feb 2022 01:42:17 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/8] ima: define a new template field 'd-type' and a new template 'ima-ngv2'
Date:   Mon,  7 Feb 2022 20:41:36 -0500
Message-Id: <20220208014140.483447-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208014140.483447-1-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xZOSJXNdO9DX-DZOxIls-4B0yNkko4y6
X-Proofpoint-ORIG-GUID: xZOSJXNdO9DX-DZOxIls-4B0yNkko4y6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-07_07,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 malwarescore=0 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080006
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In preparation to differentiate between regular IMA file hashes and
fs-verity's file digests, define a new template field named 'd-type'.
Define a new template named 'ima-ngv2', which includes the new 'd-type'
field.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_template.c     |  3 +++
 security/integrity/ima/ima_template_lib.c | 13 +++++++++++++
 security/integrity/ima/ima_template_lib.h |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index db1ad6d7a57f..b321342e5bee 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -19,6 +19,7 @@ enum header_fields { HDR_PCR, HDR_DIGEST, HDR_TEMPLATE_NAME,
 static struct ima_template_desc builtin_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
+	{.name = "ima-ngv2", .fmt = "d-ng|n-ng|d-type"},
 	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
 	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
 	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
@@ -40,6 +41,8 @@ static const struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_digest_ng},
 	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
 	 .field_show = ima_show_template_string},
+	{.field_id = "d-type", .field_init = ima_eventdigest_type_init,
+	 .field_show = ima_show_template_string},
 	{.field_id = "sig", .field_init = ima_eventsig_init,
 	 .field_show = ima_show_template_sig},
 	{.field_id = "buf", .field_init = ima_eventbuf_init,
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 5a5d462ab36d..48c2fcbefacf 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -386,6 +386,19 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 					   hash_algo, field_data);
 }
 
+/*
+ * This function writes the digest type of an event.
+ */
+int ima_eventdigest_type_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data)
+{
+	static const char * const digest_type[] = {"ima"};
+
+	return ima_write_template_field_data(digest_type[0],
+					     strlen(digest_type[0]),
+					     DATA_FMT_STRING, field_data);
+}
+
 /*
  * This function writes the digest of the file which is expected to match the
  * digest contained in the file's appended signature.
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
index c71f1de95753..539a5e354925 100644
--- a/security/integrity/ima/ima_template_lib.h
+++ b/security/integrity/ima/ima_template_lib.h
@@ -38,6 +38,8 @@ int ima_eventname_init(struct ima_event_data *event_data,
 		       struct ima_field_data *field_data);
 int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 			    struct ima_field_data *field_data);
+int ima_eventdigest_type_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data);
 int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
 				struct ima_field_data *field_data);
 int ima_eventname_ng_init(struct ima_event_data *event_data,
-- 
2.27.0

