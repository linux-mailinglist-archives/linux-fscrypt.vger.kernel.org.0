Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985BA51CAAF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 22:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381320AbiEEUih (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 16:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiEEUig (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 16:38:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887C25FF24;
        Thu,  5 May 2022 13:34:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245Ik6vd024491;
        Thu, 5 May 2022 20:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=dzh3k8pr9lO4VqF9yDEwUJQhgbGmce0E34c/qiSouFQ=;
 b=S24GyW6NghkoWkZ3pvaEKjB3PRFzAMq/rU490ooVCCM4+CybUoQ2j4IahBP3sOCdHbGm
 yJpm1QJJPzB9MgOxzst3vyHvo/pBflmDYyCtX+9HZ2v2NsnJKnPc+dXdXM2ymlu7Gmy5
 EwWPGON3hzE3stKArsqV6/abuf7htudF2Z2qoyJOm6QJm2zBdJaMt3y6umUY9QjhAlr5
 oFl5OzXTcJEILA9JvByt5HckyBFrzw0m84nD7T6EhJ89w2fDs7j9FWgbwYr4fjKcZOt6
 cKhVRVKF+qx1+fqvHGqBNRJ8WMuxNK8RvOTw2XXGQ5oAETMaNcPailWhVeAgWUSnr1Bj tQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvhnswh91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 20:34:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245KSkwt028198;
        Thu, 5 May 2022 20:34:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fvnaqg0t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 20:34:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245KYcFQ35127608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 20:34:38 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 685D55204E;
        Thu,  5 May 2022 20:34:44 +0000 (GMT)
Received: from sig-9-65-68-56.ibm.com (unknown [9.65.68.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 99BE85204F;
        Thu,  5 May 2022 20:34:43 +0000 (GMT)
Message-ID: <2f6105f1ae49f915b4df23d5f189e05407e76452.camel@linux.ibm.com>
Subject: [PATCH v9 4/7] ima: define a new template field named 'd-ngv2' and
 templates  (repost)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 05 May 2022 16:34:43 -0400
In-Reply-To: <20220505123141.1599622-5-zohar@linux.ibm.com>
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
         <20220505123141.1599622-5-zohar@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Asj7W4uqHlRgGYnYdUHsCb7YcNxOvCUp
X-Proofpoint-ORIG-GUID: Asj7W4uqHlRgGYnYdUHsCb7YcNxOvCUp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_08,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 suspectscore=0 mlxscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205050133
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
 Documentation/security/IMA-templates.rst      |  4 +
 security/integrity/ima/ima_template.c         |  4 +
 security/integrity/ima/ima_template_lib.c     | 76 ++++++++++++++++---
 security/integrity/ima/ima_template_lib.h     |  4 +
 5 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3f1cc5e317ed..5e866be89f5d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1903,7 +1903,8 @@
 
 	ima_template=	[IMA]
 			Select one of defined IMA measurements template formats.
-			Formats: { "ima" | "ima-ng" | "ima-sig" }
+			Formats: { "ima" | "ima-ng" | "ima-ngv2" | "ima-sig" |
+				   "ima-sigv2" }
 			Default: "ima-ng"
 
 	ima_template_fmt=
diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
index cab97f49971d..eafc4e34f890 100644
--- a/Documentation/security/IMA-templates.rst
+++ b/Documentation/security/IMA-templates.rst
@@ -67,6 +67,8 @@ descriptors by adding their identifier to the format string
  - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
  - 'd-ng': the digest of the event, calculated with an arbitrary hash
    algorithm (field format: <hash algo>:digest);
+ - 'd-ngv2': same as d-ng, but prefixed with the "ima" digest type
+   (field format: <digest type>:<hash algo>:digest);
  - 'd-modsig': the digest of the event without the appended modsig;
  - 'n-ng': the name of the event, without size limitations;
  - 'sig': the file signature, or the EVM portable signature if the file
@@ -87,7 +89,9 @@ Below, there is the list of defined template descriptors:
 
  - "ima": its format is ``d|n``;
  - "ima-ng" (default): its format is ``d-ng|n-ng``;
+ - "ima-ngv2": its format is ``d-ngv2|n-ng``;
  - "ima-sig": its format is ``d-ng|n-ng|sig``;
+ - "ima-sigv2": its format is ``d-ngv2|n-ng|sig``;
  - "ima-buf": its format is ``d-ng|n-ng|buf``;
  - "ima-modsig": its format is ``d-ng|n-ng|sig|d-modsig|modsig``;
  - "evm-sig": its format is ``d-ng|n-ng|evmsig|xattrnames|xattrlengths|xattrvalues|iuid|igid|imode``;
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
index 4b6706f864d4..409023e620d6 100644
--- a/security/integrity/ima/ima_template_lib.c
+++ b/security/integrity/ima/ima_template_lib.c
@@ -24,11 +24,22 @@ static bool ima_template_hash_algo_allowed(u8 algo)
 enum data_formats {
 	DATA_FMT_DIGEST = 0,
 	DATA_FMT_DIGEST_WITH_ALGO,
+	DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
 	DATA_FMT_STRING,
 	DATA_FMT_HEX,
 	DATA_FMT_UINT
 };
 
+enum digest_type {
+	DIGEST_TYPE_IMA,
+	DIGEST_TYPE__LAST
+};
+
+#define DIGEST_TYPE_NAME_LEN_MAX 4	/* including NUL */
+static const char * const digest_type_name[DIGEST_TYPE__LAST] = {
+	[DIGEST_TYPE_IMA] = "ima"
+};
+
 static int ima_write_template_field_data(const void *data, const u32 datalen,
 					 enum data_formats datafmt,
 					 struct ima_field_data *field_data)
@@ -72,8 +83,9 @@ static void ima_show_template_data_ascii(struct seq_file *m,
 	u32 buflen = field_data->len;
 
 	switch (datafmt) {
+	case DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
 	case DATA_FMT_DIGEST_WITH_ALGO:
-		buf_ptr = strnchr(field_data->data, buflen, ':');
+		buf_ptr = strrchr(field_data->data, ':');
 		if (buf_ptr != field_data->data)
 			seq_printf(m, "%s", field_data->data);
 
@@ -178,6 +190,14 @@ void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
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
@@ -265,28 +285,35 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
 }
 
 static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
-				       u8 hash_algo,
+				       u8 digest_type, u8 hash_algo,
 				       struct ima_field_data *field_data)
 {
 	/*
 	 * digest formats:
 	 *  - DATA_FMT_DIGEST: digest
 	 *  - DATA_FMT_DIGEST_WITH_ALGO: <hash algo> + ':' + '\0' + digest,
+	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
+	 *	<digest type> + ':' + <hash algo> + ':' + '\0' + digest,
 	 *
 	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
 	 *      with a hash size limitation of 20 bytes,
+	 *    where <digest type> is "ima",
 	 *    where <hash algo> is the hash_algo_name[] string.
 	 */
-	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
+	u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
+		IMA_MAX_DIGEST_SIZE] = { 0 };
 	enum data_formats fmt = DATA_FMT_DIGEST;
 	u32 offset = 0;
 
-	if (hash_algo < HASH_ALGO__LAST) {
+	if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
+		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
+		offset += 1 + sprintf(buffer, "%s:%s:",
+				      digest_type_name[digest_type],
+				      hash_algo_name[hash_algo]);
+	} else if (hash_algo < HASH_ALGO__LAST) {
 		fmt = DATA_FMT_DIGEST_WITH_ALGO;
-		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
-				   hash_algo_name[hash_algo]);
-		buffer[offset] = ':';
-		offset += 2;
+		offset += 1 + sprintf(buffer, "%s:",
+				      hash_algo_name[hash_algo]);
 	}
 
 	if (digest)
@@ -361,7 +388,8 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
 	cur_digestsize = hash.hdr.length;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   HASH_ALGO__LAST, field_data);
+					   DIGEST_TYPE__LAST, HASH_ALGO__LAST,
+					   field_data);
 }
 
 /*
@@ -382,7 +410,32 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
 	hash_algo = event_data->iint->ima_hash->algo;
 out:
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   hash_algo, field_data);
+					   DIGEST_TYPE__LAST, hash_algo,
+					   field_data);
+}
+
+/*
+ * This function writes the digest of an event (without size limit),
+ * prefixed with both the digest type and hash algorithm.
+ */
+int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
+			      struct ima_field_data *field_data)
+{
+	u8 *cur_digest = NULL, hash_algo = ima_hash_algo;
+	u32 cur_digestsize = 0;
+	u8 digest_type = DIGEST_TYPE_IMA;
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
+					   digest_type, hash_algo,
+					   field_data);
 }
 
 /*
@@ -417,7 +470,8 @@ int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
 	}
 
 	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
-					   hash_algo, field_data);
+					   DIGEST_TYPE__LAST, hash_algo,
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


