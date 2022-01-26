Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5C849BFE7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jan 2022 01:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbiAZAHU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 Jan 2022 19:07:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31268 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235129AbiAZAHT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 Jan 2022 19:07:19 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PNkXHg028222;
        Wed, 26 Jan 2022 00:07:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WCHF4t6YNEtIg5YwP0EHoL2BlDhnfIuZYpWv/GKW1TQ=;
 b=IFvhSyBAVuzcQPVmbFQadodFZYJrOQ1fqz7x59oTKGwiA5rmYbovbgu4fl70gSjbEPji
 iIZf4sYGm4zgxFVjEeHBrh/8CLKUxDoDQpU5oxFj7GYdeF0z9NugqtKZQsqXc4yaxZkh
 mE54u+/XGpGZXq+GZlbBTnvDUUZQBNgkBXf8Nbj8y5X78hJn3l8e0DFp4UHDaba0Cdye
 sD9cOrejLNx800ZJ/nldH83rGuHD+EpuRLBfgQU6SiGmy0Aln2g01tl6FAi3Y7RLKYXw
 vitRBsrs86ebbHPN8FCp6qKYIJ1a72aqy0BOyLleG02Uw3PthOFcTUM1nIY4tzsGj3L8 HA== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtu65r9n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:17 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q02hoU019310;
        Wed, 26 Jan 2022 00:07:15 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96jjb2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 00:07:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q07Co447513936
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 00:07:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1347E4C044;
        Wed, 26 Jan 2022 00:07:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E797F4C040;
        Wed, 26 Jan 2022 00:07:10 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.78.94])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 00:07:10 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/8] ima: define a new template field 'd-type' and a new template 'ima-ngv2'
Date:   Tue, 25 Jan 2022 19:06:54 -0500
Message-Id: <20220126000658.138345-5-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: E5u3g1zKEbP7sf1Z4qNRRfUuveQIqI7-
X-Proofpoint-ORIG-GUID: E5u3g1zKEbP7sf1Z4qNRRfUuveQIqI7-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 impostorscore=0 suspectscore=0 priorityscore=1501
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250145
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In preparation to differentiate between regular file hashes and
fs-verity's file digests, define a new template field named 'd-type'.
Define and include the new 'd-type' field in the new template named
'ima-ngv2'.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 security/integrity/ima/ima_template.c     |  3 +++
 security/integrity/ima/ima_template_lib.c | 13 +++++++++++++
 security/integrity/ima/ima_template_lib.h |  2 ++
 3 files changed, 18 insertions(+)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 694560396be0..9d8253c6c52c 100644
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
@@ -39,6 +40,8 @@ static const struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_digest_ng},
 	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
 	 .field_show = ima_show_template_string},
+	{.field_id = "d-type", .field_init = ima_eventdigest_type_init,
+	 .field_show = ima_show_template_string},
 	{.field_id = "sig", .field_init = ima_eventsig_init,
 	 .field_show = ima_show_template_sig},
 	{.field_id = "buf", .field_init = ima_eventbuf_init,
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index d3aa511027cd..aa5d4a490657 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -387,6 +387,19 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 					   hash_algo, field_data);
 }
 
+/*
+ * This function writes the digest type of an event.
+ */
+int ima_eventdigest_type_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data)
+{
+	static const char * const digest_type[] = {"hash"};
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

