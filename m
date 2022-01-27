Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E92049EA85
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240349AbiA0Sqf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:35 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4533 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235812AbiA0Sqc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:32 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8gJ4JHNz67y8F;
        Fri, 28 Jan 2022 02:46:04 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:29 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 07/11] fsverity: Introduce fsverity_get_signature()
Date:   Thu, 27 Jan 2022 19:46:11 +0100
Message-ID: <20220127184614.2837938-3-roberto.sassu@huawei.com>
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

Get the signature of an fsverity-protected file.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/verity/measure.c      | 38 ++++++++++++++++++++++++++++++++++++++
 include/linux/fsverity.h |  7 +++++++
 2 files changed, 45 insertions(+)

diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index 7afe4274ecb0..679e2ddae62c 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -142,3 +142,41 @@ ssize_t fsverity_get_formatted_digest(struct inode *inode,
 
 	return sizeof(*d) + hash_alg->digest_size;
 }
+
+/**
+ * fsverity_get_signature() - get a verity file's signature
+ * @inode: inode to get signature of
+ * @signature: (out) pointer to the signature
+ *
+ * Return the file signature of an fsverity-protected file.
+ *
+ * Return: written bytes on success, -errno on failure
+ */
+ssize_t fsverity_get_signature(struct inode *inode, u8 **signature)
+{
+	const struct fsverity_info *vi;
+	struct fsverity_descriptor *desc;
+	size_t desc_size;
+	int err, signature_size;
+
+	vi = fsverity_get_info(inode);
+	if (!vi)
+		return -ENODATA; /* not a verity file */
+
+	err = fsverity_get_descriptor(inode, &desc, &desc_size);
+	if (err)
+		return err;
+
+	signature_size = le32_to_cpu(desc->sig_size);
+
+	*signature = kmemdup(desc->signature, signature_size, GFP_KERNEL);
+
+	kfree(desc);
+
+	if (!*signature)
+		return -ENOMEM;
+
+	pr_debug("file signature %*phN\n", signature_size, *signature);
+
+	return signature_size;
+}
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 17ae313ed8f4..5ad7921f3589 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -147,6 +147,7 @@ int fsverity_get_digest(struct inode *inode,
 ssize_t fsverity_get_formatted_digest(struct inode *inode,
 			u8 formatted_digest[FS_VERITY_MAX_FMT_DIGEST_SIZE],
 			enum hash_algo *alg);
+ssize_t fsverity_get_signature(struct inode *inode, u8 **signature);
 
 /* open.c */
 
@@ -200,6 +201,12 @@ static inline ssize_t fsverity_get_formatted_digest(struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
+static inline ssize_t fsverity_get_signature(struct inode *inode,
+					     u8 **signature)
+{
+	return -EOPNOTSUPP;
+}
+
 /* open.c */
 
 static inline int fsverity_file_open(struct inode *inode, struct file *filp)
-- 
2.32.0

