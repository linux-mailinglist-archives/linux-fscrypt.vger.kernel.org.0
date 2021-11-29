Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B02461C67
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Nov 2021 18:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346849AbhK2RGx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 12:06:53 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29618 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232862AbhK2REw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 12:04:52 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGqTQb029443;
        Mon, 29 Nov 2021 17:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=VV7NbaGSBU5mx87Gn3b0nCfbWWPterfXx56KmUlJans=;
 b=IKbpPkdQ0bv0a16qPlz5cPzff3G6Mj+AgwiDgVtDKC5R1WKi9qX3QyVSW8AttmbxMaDn
 ICNxuxQ20fHXmp3HJgcXWMpgyeUbA79ZZi8/idHrUc5hqDplfMyfHgtS5wPGnMhKiAnb
 LcmEJ09yGzHVkxRwmyYAMCqBMqRQF+iwEGRRwqrU4noKyjTyE9D6Ip9szIDJ9TsmYU1H
 qL7Kxvp3klHmu5Lfu7i3/Kr9E7/JPGWSp7MAJC4vV4Y351U6br9A1rA1DA3k+lnczztW
 8ilYFMHio94Bwoiud03Q7VgnZ32bbLx6HJdxVpax4+aNCPjunmv9B5X+em2GHVFSMPRR qA== 
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cn2s2r5t0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:33 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ATGwdHW011359;
        Mon, 29 Nov 2021 17:01:24 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3ckca9p3et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 17:01:23 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ATGrvEd52888002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 16:53:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF5A04C062;
        Mon, 29 Nov 2021 17:01:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00FBE4C05E;
        Mon, 29 Nov 2021 17:01:19 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com.com (unknown [9.65.68.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 17:01:18 +0000 (GMT)
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/4] fs-verity: define a function to return the integrity protected file digest
Date:   Mon, 29 Nov 2021 12:00:54 -0500
Message-Id: <20211129170057.243127-2-zohar@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211129170057.243127-1-zohar@linux.ibm.com>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5hcNeUWbFf9Anjm00HrPU44rlvpBCaBN
X-Proofpoint-GUID: 5hcNeUWbFf9Anjm00HrPU44rlvpBCaBN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290081
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Define a function named fsverity_measure() to return the verity file digest
and the associated hash algorithm (enum hash_algo).

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
---
 fs/verity/fsverity_private.h |  6 -----
 fs/verity/measure.c          | 49 ++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h     | 17 +++++++++++++
 3 files changed, 66 insertions(+), 6 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a7920434bae5..54c5f0993541 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -26,12 +26,6 @@ struct ahash_request;
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
index f0d7b30c62db..98d8f6f2a2be 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -57,3 +57,52 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
+
+/**
+ * fsverity_measure() - get a verity file's digest
+ * @inode: inode to get digest of
+ * @digest: pointer to the digest
+ * @alg: pointer to the hash algorithm enumeration
+ *
+ * Return the file hash algorithm, digest size, and digest of an fsverity
+ * protected file.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fsverity_measure(struct inode *inode, u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+		     enum hash_algo *alg)
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
index b568b3c7d095..11006b60713b 100644
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
 
@@ -131,6 +139,8 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *arg);
 /* measure.c */
 
 int fsverity_ioctl_measure(struct file *filp, void __user *arg);
+int fsverity_measure(struct inode *inode, u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+		     enum hash_algo *alg);
 
 /* open.c */
 
@@ -170,6 +180,13 @@ static inline int fsverity_ioctl_measure(struct file *filp, void __user *arg)
 	return -EOPNOTSUPP;
 }
 
+static inline int fsverity_measure(struct inode *inode,
+				   u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
+				   enum hash_algo *alg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* open.c */
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
-- 
2.27.0

