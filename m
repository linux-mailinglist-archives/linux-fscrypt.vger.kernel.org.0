Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29E2466BC9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 22:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377128AbhLBV7H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 16:59:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39228 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243133AbhLBV7G (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 16:59:06 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2Jr1AH029117;
        Thu, 2 Dec 2021 21:55:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+DeRp858qnInW1elOnLNsw4/TGKd2BJwXQzP9ThUne8=;
 b=Z4AQH6Bmg4Udr9aXP6K4DvTHCdz8HxO1aTaweEXZHyPPQ/7KK3sr3qmy41/LFmq2i1F4
 C4zf3X5nYp401+PnmJtwm6DsZKI/rrDW4JFNneaVQDDaqrDq7VT9SK34gCFHdl2Rw54r
 6VUCVLdgYz002IQ5Go4QVy6NznhSR6/Z2+/SnCzVGdKYT0FoX+WAAgCMX62mFKKJ9KfP
 xhXZdNXUxp0tqXV0Yc15tq851o+XFYrGoBd42Jd3FTD+DErYKQT0iU/6upWk7nL8me2l
 NJbYX1i3eS2UfgD36Zwt+Oqb5w5ViKP4YURjCWDdzF7WxIDU4cnbmWPNrjowEQ5rEnMy tQ== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cq4pajjkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:41 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2LoEsV008840;
        Thu, 2 Dec 2021 21:55:39 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxkrb6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 21:55:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2Lm6sW20775222
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 21:48:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 055F852052;
        Thu,  2 Dec 2021 21:55:37 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.72.23])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4F03F52050;
        Thu,  2 Dec 2021 21:55:36 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/5] fs-verity: define a function to return the integrity protected file digest
Date:   Thu,  2 Dec 2021 16:55:03 -0500
Message-Id: <20211202215507.298415-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211202215507.298415-1-zohar@linux.ibm.com>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3uCrgem_OIuA4nxWYeCB44FaaiVWJ_i4
X-Proofpoint-ORIG-GUID: 3uCrgem_OIuA4nxWYeCB44FaaiVWJ_i4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_14,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112020133
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Define a function named fsverity_collect_digest() to return the verity
file digest and the associated hash algorithm (enum hash_algo).

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
Changelog v1:
- Renamed new function to fsverity_collect_digest(), based on discussion
  with Eric Biggers and Lakshmi.
- Addressed Eric's suggestions: updated kernel doc variable and function
description, removed unnecessary include file.


 fs/verity/Kconfig            |  1 +
 fs/verity/fsverity_private.h |  7 ------
 fs/verity/measure.c          | 49 ++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h     | 18 +++++++++++++
 4 files changed, 68 insertions(+), 7 deletions(-)

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
index f0d7b30c62db..64fbfbd408d4 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -57,3 +57,52 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
+
+/**
+ * fsverity_collect_digest() - get a verity file's digest
+ * @inode: inode to get digest of
+ * @digest: (out) pointer to the digest
+ * @alg: (out) pointer to the hash algorithm enumeration
+ *
+ * Return the file hash algorithm and digest of an fsverity protected file.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_collect_digest(struct inode *inode,
+			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+			    enum hash_algo *alg)
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
+	*alg = HASH_ALGO__LAST;
+
+	/* convert hash algorithm to hash_algo_name */
+	for (i = 0; i < HASH_ALGO__LAST; i++) {
+		pr_debug("name %s hash_algo_name[%d] %s\n",
+			  hash_alg->name, i, hash_algo_name[i]);
+
+		if (!strcmp(hash_alg->name, hash_algo_name[i])) {
+			*alg = i;
+			break;
+		}
+	}
+
+	/* Shouldn't happen */
+	if (*alg == HASH_ALGO__LAST)
+		return -EINVAL;
+
+	memcpy(digest, vi->file_digest, hash_alg->digest_size);
+
+	pr_debug("file digest:%s %*phN\n", hash_algo_name[*alg],
+		  hash_digest_size[*alg], digest);
+
+	return 0;
+}
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b568b3c7d095..2755e8bd80e5 100644
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
+int fsverity_collect_digest(struct inode *inode,
+			    u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+			    enum hash_algo *alg);
 
 /* open.c */
 
@@ -170,6 +181,13 @@ static inline int fsverity_ioctl_measure(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fsverity_collect_digest(struct inode *inode,
+					  u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+					  enum hash_algo *alg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* open.c */
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
-- 
2.27.0

