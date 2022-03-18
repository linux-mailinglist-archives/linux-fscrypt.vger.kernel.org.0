Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407864DE0F3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Mar 2022 19:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiCRSXk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Mar 2022 14:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238994AbiCRSXi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Mar 2022 14:23:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7F730CD94;
        Fri, 18 Mar 2022 11:22:09 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IHN3C7015386;
        Fri, 18 Mar 2022 18:22:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=conySYsg0ynx3rzah3UbXnChqXYMg2tQSfroH/ckxxg=;
 b=sO3Ls+5KgJetmOk9zC3Zw3PVuxOioXlX4nicOm2WjTjOqBeLri50mL2YeMqrwKDNoyx4
 lYMOpCqn9QCtquQPkqgK7sfVXMU4rE2yDmuU4v/QKWQLIbY9/fj4jxoC9RZS2OVGsqr1
 R7FM4eBMLjdzOfFH84qRIfVbMX16+vlhdUXfCsX+uLw3N7Y9xrWig2OGGsOCA84zpr2c
 Si7J3seDNBKaa68CohivbMK2N8aTd0ZEsrJuqFwkVw+qCA/fllnJ9mWSQX/hTfGCKEjG
 i1rOyj8CjKc343xe6QQIp6m0KqD7Xi2EZ3w3xodEMUkUsBFHsHRY7qz9dKNo/2sTYyaq Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ev10dkhm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22IIJqKG011473;
        Fri, 18 Mar 2022 18:22:05 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ev10dkhkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:05 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22II4pwa014349;
        Fri, 18 Mar 2022 18:22:03 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3erjshv1qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 18:22:03 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IIM0jK17563908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 18:22:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 154FFAE061;
        Fri, 18 Mar 2022 18:22:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D7A1AE05A;
        Fri, 18 Mar 2022 18:21:59 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.75.142])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 18:21:58 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v6 1/5] fs-verity: define a function to return the integrity protected file digest
Date:   Fri, 18 Mar 2022 14:21:47 -0400
Message-Id: <20220318182151.100847-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318182151.100847-1-zohar@linux.ibm.com>
References: <20220318182151.100847-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tI62bJJ4CaS6Y2cZVHoQQhGqwWuV9ALU
X-Proofpoint-GUID: O41N78MGqdIsDvlpl58IXK1SGN5NLf6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_13,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Define a function named fsverity_get_digest() to return the verity file
digest and the associated hash algorithm (enum hash_algo).

This assumes that before calling fsverity_get_digest() the file must have
been opened, which is true for the IMA measure/appraise on file open policy
rule use case (func=FILE_CHECK).  do_open() calls vfs_open() immediately
prior to ima_file_check().

Acked-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 fs/verity/Kconfig            |  1 +
 fs/verity/fsverity_private.h |  7 ------
 fs/verity/measure.c          | 43 ++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h     | 18 +++++++++++++++
 4 files changed, 62 insertions(+), 7 deletions(-)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index 24d1b54de807..54598cd80145 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -3,6 +3,7 @@
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
 	select CRYPTO
+	select CRYPTO_HASH_INFO
 	# SHA-256 is implied as it's intended to be the default hash algorithm.
 	# To avoid bloat, other wanted algorithms must be selected explicitly.
 	# Note that CRYPTO_SHA256 denotes the generic C implementation, but
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a7920434bae5..c6fb62e0ef1a 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -14,7 +14,6 @@
 
 #define pr_fmt(fmt) "fs-verity: " fmt
 
-#include <crypto/sha2.h>
 #include <linux/fsverity.h>
 #include <linux/mempool.h>
 
@@ -26,12 +25,6 @@ struct ahash_request;
  */
 #define FS_VERITY_MAX_LEVELS		8
 
-/*
- * Largest digest size among all hash algorithms supported by fs-verity.
- * Currently assumed to be <= size of fsverity_descriptor::root_hash.
- */
-#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
-
 /* A hash algorithm supported by fs-verity */
 struct fsverity_hash_alg {
 	struct crypto_ahash *tfm; /* hash tfm, allocated on demand */
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index f0d7b30c62db..e99c00350c28 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -57,3 +57,46 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
+
+/**
+ * fsverity_get_digest() - get a verity file's digest
+ * @inode: inode to get digest of
+ * @digest: (out) pointer to the digest
+ * @alg: (out) pointer to the hash algorithm enumeration
+ *
+ * Return the file hash algorithm and digest of an fsverity protected file.
+ * Assumption: before calling fsverity_get_digest(), the file must have been
+ * opened.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_get_digest(struct inode *inode,
+			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+			enum hash_algo *alg)
+{
+	const struct fsverity_info *vi;
+	const struct fsverity_hash_alg *hash_alg;
+	int i;
+
+	vi = fsverity_get_info(inode);
+	if (!vi)
+		return -ENODATA; /* not a verity file */
+
+	hash_alg = vi->tree_params.hash_alg;
+	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
+
+	/* convert the verity hash algorithm name to a hash_algo_name enum */
+	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
+	if (i < 0)
+		return -EINVAL;
+	*alg = i;
+
+	if (WARN_ON_ONCE(hash_alg->digest_size != hash_digest_size[*alg]))
+		return -EINVAL;
+	memcpy(digest, vi->file_digest, hash_alg->digest_size);
+
+	pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
+		 hash_digest_size[*alg], digest);
+
+	return 0;
+}
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b568b3c7d095..9a1b70cc7318 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -12,8 +12,16 @@
 #define _LINUX_FSVERITY_H
 
 #include <linux/fs.h>
+#include <crypto/hash_info.h>
+#include <crypto/sha2.h>
 #include <uapi/linux/fsverity.h>
 
+/*
+ * Largest digest size among all hash algorithms supported by fs-verity.
+ * Currently assumed to be <= size of fsverity_descriptor::root_hash.
+ */
+#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+
 /* Verity operations for filesystems */
 struct fsverity_operations {
 
@@ -131,6 +139,9 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
 /* measure.c */
 
 int fsverity_ioctl_measure(struct file *filp, void __user *arg);
+int fsverity_get_digest(struct inode *inode,
+			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+			enum hash_algo *alg);
 
 /* open.c */
 
@@ -170,6 +181,13 @@ static inline int fsverity_ioctl_measure(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fsverity_get_digest(struct inode *inode,
+				      u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+				      enum hash_algo *alg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* open.c */
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
-- 
2.27.0

