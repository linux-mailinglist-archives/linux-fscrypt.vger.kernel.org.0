Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBD514811
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 13:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358339AbiD2L3z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358317AbiD2L3w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 07:29:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2432D49274;
        Fri, 29 Apr 2022 04:26:34 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TB0APK025727;
        Fri, 29 Apr 2022 11:26:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=g/wDleQPkOGH8z+6U+L+qcZitdKW3mEVvH+oSjG4BxU=;
 b=b32/mNOp+u6eSku193hweWP1KZ/yUNyi/yI2jSE01TIQbDh0JHCNMsr6e5+OXlaOrGwN
 +piE4eyCXgqexWvH00UyJiA0Vfo5E6bDu3UX2JVzhAyHUSnp1zbRN1XjPgKcO7zDfkTG
 I0qkNmryar6sBZmrJ3x236PICsHZt7nHtROyJxqnvh04hbNY82UXCv077kxEKFDeTYZL
 8zWMRa1l3P68Hid3BE3AS6ypxE+OztY//Wb96STG7hAqPClyHBLqeZfaeXM43WIQzOGr
 Vt0+QL1HahVc4j7cKFAnv6/lyl6fNTezDpDarjFGR9FS4dD6nr6nQ9bb/BxDoqvVckXA Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqt9e9jnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:27 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23TBH8wk011994;
        Fri, 29 Apr 2022 11:26:27 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqt9e9jmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:26 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TBEUp6018431;
        Fri, 29 Apr 2022 11:26:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3fm8qhq5tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 11:26:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TBDDJa52232600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 11:13:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7791C11C04A;
        Fri, 29 Apr 2022 11:26:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74E7D11C04C;
        Fri, 29 Apr 2022 11:26:20 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.70.88])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 11:26:20 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v8 3/7] fs-verity: define a function to return the integrity protected file digest
Date:   Fri, 29 Apr 2022 07:25:57 -0400
Message-Id: <20220429112601.1421947-4-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220429112601.1421947-1-zohar@linux.ibm.com>
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vdeJJktZi4p_M8p2HRNqfK6IEoMuGcpe
X-Proofpoint-ORIG-GUID: dLvXswUvccE1FMeN1rlf0Yidmaw39Ss7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_06,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Define a function named fsverity_get_digest() to return the verity file
digest and the associated hash algorithm (enum hash_algo).

This assumes that before calling fsverity_get_digest() the file must have
been opened, which is even true for the IMA measure/appraise on file
open policy rule use case (func=FILE_CHECK).  do_open() calls vfs_open()
immediately prior to ima_file_check().

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
index a7afc800bd8d..7af030fa3c36 100644
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

