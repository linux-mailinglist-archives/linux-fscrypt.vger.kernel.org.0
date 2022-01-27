Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2863249EA87
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbiA0Sqg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:36 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4532 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiA0Sqc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:32 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8gJ02h1z68568;
        Fri, 28 Jan 2022 02:46:04 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:28 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 06/11] fsverity: Introduce fsverity_get_formatted_digest()
Date:   Thu, 27 Jan 2022 19:46:10 +0100
Message-ID: <20220127184614.2837938-2-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127184614.2837938-1-roberto.sassu@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Introduce fsverity_get_formatted_digest() so that a caller (e.g. IMA) can
get all the information necessary to validate the fsverity signature.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/verity/measure.c      | 46 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h | 12 +++++++++++
 2 files changed, 58 insertions(+)

diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 2152f115071a..7afe4274ecb0 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -8,6 +8,7 @@
 #include "fsverity_private.h"
 
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 
 /**
  * fsverity_ioctl_measure() - get a verity file's digest
@@ -96,3 +97,48 @@ int fsverity_get_digest(struct inode *inode,
 
 	return 0;
 }
+
+/**
+ * fsverity_get_formatted_digest() - get a verity file's formatted digest
+ * @inode: inode to get the formatted digest from
+ * @formatted_digest: (out) pointer to the formatted digest
+ * @alg: (out) pointer to the hash algorithm enumeration
+ *
+ * Return the fsverity_formatted_digest structure for a given inode.
+ *
+ * Return: written bytes on success, -errno on failure
+ */
+ssize_t fsverity_get_formatted_digest(struct inode *inode,
+			u8 formatted_digest[FS_VERITY_MAX_FMT_DIGEST_SIZE],
+			enum hash_algo *alg)
+{
+	struct fsverity_formatted_digest *d =
+			(struct fsverity_formatted_digest *)formatted_digest;
+	const struct fsverity_info *vi;
+	const struct fsverity_hash_alg *hash_alg;
+	int i;
+
+	vi = fsverity_get_info(inode);
+	if (!vi)
+		return -ENODATA; /* not a verity file */
+
+	hash_alg = vi->tree_params.hash_alg;
+
+	/* convert hash algorithm to hash_algo_name */
+	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
+	if (i < 0)
+		return -EINVAL;
+	*alg = i;
+
+	memset(formatted_digest, 0, FS_VERITY_MAX_FMT_DIGEST_SIZE);
+
+	memcpy(d->magic, "FSVerity", 8);
+	d->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
+	d->digest_size = cpu_to_le16(hash_alg->digest_size);
+	memcpy(d->digest, vi->file_digest, hash_alg->digest_size);
+
+	pr_debug("file formatted digest FSVerity:%s:%d:%*phN\n", hash_alg->name,
+		 hash_alg->digest_size, hash_alg->digest_size, vi->file_digest);
+
+	return sizeof(*d) + hash_alg->digest_size;
+}
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 9a1b70cc7318..17ae313ed8f4 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -21,6 +21,8 @@
  * Currently assumed to be <= size of fsverity_descriptor::root_hash.
  */
 #define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+#define FS_VERITY_MAX_FMT_DIGEST_SIZE	(FS_VERITY_MAX_DIGEST_SIZE + \
+				sizeof(struct fsverity_formatted_digest))
 
 /* Verity operations for filesystems */
 struct fsverity_operations {
@@ -142,6 +144,9 @@ int fsverity_ioctl_measure(struct file *filp, void __user *arg);
 int fsverity_get_digest(struct inode *inode,
 			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
 			enum hash_algo *alg);
+ssize_t fsverity_get_formatted_digest(struct inode *inode,
+			u8 formatted_digest[FS_VERITY_MAX_FMT_DIGEST_SIZE],
+			enum hash_algo *alg);
 
 /* open.c */
 
@@ -188,6 +193,13 @@ static inline int fsverity_get_digest(struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
+static inline ssize_t fsverity_get_formatted_digest(struct inode *inode,
+			u8 formatted_digest[FS_VERITY_MAX_FMT_DIGEST_SIZE],
+			enum hash_algo *alg)
+{
+	return -EOPNOTSUPP;
+}
+
 /* open.c */
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
-- 
2.32.0

