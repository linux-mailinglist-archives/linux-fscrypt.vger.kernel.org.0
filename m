Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83164DE0F1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Mar 2022 19:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbiCRSXj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Mar 2022 14:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240095AbiCRSXi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Mar 2022 14:23:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4110830CD9E;
        Fri, 18 Mar 2022 11:22:10 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IHN2qI018701;
        Fri, 18 Mar 2022 18:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4513YrQ18D++1xkGYcJ1Tehh8fycwtVqFRHfdqwUOmc=;
 b=UzcH0gXgccv28rDld0KOXP/TVcrbCigKBIClhvQgYgMZREvpzK/CGxHH8GfmC8DUFJP8
 OCWmOIpSHE+HtFN1UXb9CDU2UXuJItyU1nLtL9QsK0EVTZZ1iTS80RcCUA74IeAc6YSV
 XMup1hEPzL+T2E3/QRH+sf7nfGKAWmST7NJxGNIhKQqwI4RSROs0gWFvawcGCYjmll4z
 IRl1yImA1XCJt3azsQfneNMoonAuc+uZ79hlF7cwiP/XUTeqVv4uLxkJr93yq+hMg9Jy
 iljjwX3WZROpGfbNQT/mJ9fC9RAC4yX9XRBfNPeI75ncnSsFYaMfnx9vJwPhf/PNowu7 Xw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ev1vqsv9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22II38q0004127;
        Fri, 18 Mar 2022 18:22:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3erk58v081-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IIM4g940632742
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 18:22:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 80B4DAE05F;
        Fri, 18 Mar 2022 18:22:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E3DAE05A;
        Fri, 18 Mar 2022 18:22:00 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.75.142])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 18:22:00 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/5] ima: define a new template field named 'd-ngv2' and templates
Date:   Fri, 18 Mar 2022 14:21:48 -0400
Message-Id: <20220318182151.100847-3-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318182151.100847-1-zohar@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qv94sp8fW0j7rb3XGzHy8P98WnZKrORS
X-Proofpoint-ORIG-GUID: Qv94sp8fW0j7rb3XGzHy8P98WnZKrORS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_13,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203180095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In preparation to differentiate between unsigned regular IMA file
hashes and fs-verity's file digests in the IMA measurement list,
define a new template field named 'd-ngv2'.

Also define two new templates named 'ima-ngv2' and 'ima-sigv2', which
include the new 'd-ngv2' field.

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 .../admin-guide/kernel-parameters.txt         |  3 +-
 security/integrity/ima/ima_template.c         |  4 ++
 security/integrity/ima/ima_template_lib.c     | 71 ++++++++++++++++---
 security/integrity/ima/ima_template_lib.h     |  4 ++
 4 files changed, 72 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f5a27f067db9..47386ac10471 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1876,7 +1876,8 @@
 
 	ima_template=	[IMA]
 			Select one of defined IMA measurements template formats.
-			Formats: { "ima" | "ima-ng" | "ima-sig" }
+			Formats: { "ima" | "ima-ng" | "ima-ngv2" | "ima-sig" |
+				   "ima-sigv2" }
 			Default: "ima-ng"
 
 	ima_template_fmt=
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index db1ad6d7a57f..c25079faa208 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -20,6 +20,8 @@ static struct ima_template_desc builtin_templates[] = {
 	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
 	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
 	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
+	{.name = "ima-ngv2", .fmt = "d-ngv2|n-ng"},
+	{.name = "ima-sigv2", .fmt = "d-ngv2|n-ng|sig"},
 	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
 	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
 	{.name = "evm-sig",
@@ -38,6 +40,8 @@ static const struct ima_template_field supported_fields[] = {
 	 .field_show = ima_show_template_string},
 	{.field_id = "d-ng", .field_init = ima_eventdigest_ng_init,
 	 .field_show = ima_show_template_digest_ng},
+	{.field_id = "d-ngv2", .field_init = ima_eventdigest_ngv2_init,
+	 .field_show = ima_show_template_digest_ngv2},
 	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
 	 .field_show = ima_show_template_string},
 	{.field_id = "sig", .field_init = ima_eventsig_init,
diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
index 7155d17a3b75..bd95864a5f6f 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -24,11 +24,16 @@ static bool ima_template_hash_algo_allowed(u8 algo)
 enum data_formats {
 	DATA_FMT_DIGEST = 0,
 	DATA_FMT_DIGEST_WITH_ALGO,
+	DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
 	DATA_FMT_STRING,
 	DATA_FMT_HEX,
 	DATA_FMT_UINT
 };
 
+#define DIGEST_TYPE_MAXLEN 16	/* including NULL */
+static const char * const digest_type_name[] = {"ima"};
+static int digest_type_size = ARRAY_SIZE(digest_type_name);
+
 static int ima_write_template_field_data(const void *data, const u32 datalen,
 					 enum data_formats datafmt,
 					 struct ima_field_data *field_data)
@@ -72,8 +77,9 @@ static void ima_show_template_data_ascii(struct seq_file *m,
 	u32 buflen = field_data->len;
 
 	switch (datafmt) {
+	case DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
 	case DATA_FMT_DIGEST_WITH_ALGO:
-		buf_ptr = strnchr(field_data->data, buflen, ':');
+		buf_ptr = strrchr(field_data->data, ':');
 		if (buf_ptr != field_data->data)
 			seq_printf(m, "%s", field_data->data);
 
@@ -178,6 +184,14 @@ void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
 				     field_data);
 }
 
+void ima_show_template_digest_ngv2(struct seq_file *m, enum ima_show_type show,
+				   struct ima_field_data *field_data)
+{
+	ima_show_template_field_data(m, show,
+				     DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
+				     field_data);
+}
+
 void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data)
 {
@@ -265,26 +279,39 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
 }
 
 static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
-				       u8 hash_algo,
+				       u8 digest_type, u8 hash_algo,
 				       struct ima_field_data *field_data)
 {
 	/*
 	 * digest formats:
 	 *  - DATA_FMT_DIGEST: digest
 	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
+	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
+	 *	[<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
+	 *    where <hash type> is either "ima" or "verity",
 	 *    where <hash algo> is provided if the hash algorithm is not
 	 *    SHA1 or MD5
 	 */
-	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
+	u8 buffer[DIGEST_TYPE_MAXLEN + CRYPTO_MAX_ALG_NAME + 2 +
+		IMA_MAX_DIGEST_SIZE] = { 0 };
 	enum data_formats fmt = DATA_FMT_DIGEST;
 	u32 offset = 0;
 
-	if (hash_algo < HASH_ALGO__LAST) {
-		fmt = DATA_FMT_DIGEST_WITH_ALGO;
-		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
+	if (digest_type < digest_type_size && hash_algo < HASH_ALGO__LAST) {
+		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
+		offset += snprintf(buffer, DIGEST_TYPE_MAXLEN +
+				   CRYPTO_MAX_ALG_NAME + 1, "%*s:%s",
+				   (int)strlen(digest_type_name[digest_type]),
+				   digest_type_name[digest_type],
 				   hash_algo_name[hash_algo]);
 		buffer[offset] = ':';
 		offset += 2;
+	} else if (hash_algo < HASH_ALGO__LAST) {
+		fmt = DATA_FMT_DIGEST_WITH_ALGO;
+		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1,
+				   "%s", hash_algo_name[hash_algo]);
+		buffer[offset] = ':';
+		offset += 2;
 	}
 
 	if (digest)
@@ -359,7 +386,8 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 	cur_digestsize = hash.hdr.length;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   HASH_ALGO__LAST, field_data);
+					   digest_type_size, HASH_ALGO__LAST,
+					   field_data);
 }
 
 /*
@@ -380,7 +408,31 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 	hash_algo = event_data->iint->ima_hash->algo;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   hash_algo, field_data);
+					   digest_type_size, hash_algo,
+					   field_data);
+}
+
+/*
+ * This function writes the digest of an event (without size limit),
+ * prefixed with both the hash type and algorithm.
+ */
+int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data)
+{
+	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
+	u32 cur_digestsize = 0;
+	u8 digest_type = 0;
+
+	if (event_data->violation)	/* recording a violation. */
+		goto out;
+
+	cur_digest = event_data->iint->ima_hash->digest;
+	cur_digestsize = event_data->iint->ima_hash->length;
+
+	hash_algo = event_data->iint->ima_hash->algo;
+out:
+	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
+					   digest_type, hash_algo, field_data);
 }
 
 /*
@@ -415,7 +467,8 @@ int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
 	}
 
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   hash_algo, field_data);
+					   digest_type_size, hash_algo,
+					   field_data);
 }
 
 static int ima_eventname_init_common(struct ima_event_data *event_data,
diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
index c71f1de95753..9f7c335f304f 100644
--- a/security/integrity/ima/ima_template_lib.h
+++ b/security/integrity/ima/ima_template_lib.h
@@ -21,6 +21,8 @@ void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data);
 void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
 				 struct ima_field_data *field_data);
+void ima_show_template_digest_ngv2(struct seq_file *m, enum ima_show_type show,
+				   struct ima_field_data *field_data);
 void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
 			      struct ima_field_data *field_data);
 void ima_show_template_sig(struct seq_file *m, enum ima_show_type show,
@@ -38,6 +40,8 @@ int ima_eventname_init(struct ima_event_data *event_data,
 		       struct ima_field_data *field_data);
 int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 			    struct ima_field_data *field_data);
+int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data);
 int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
 				struct ima_field_data *field_data);
 int ima_eventname_ng_init(struct ima_event_data *event_data,
-- 
2.27.0

