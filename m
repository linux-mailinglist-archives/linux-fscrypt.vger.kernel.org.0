Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E0A52BCA1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 16:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbiERNYd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 09:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbiERNYb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 09:24:31 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4475169E0B;
        Wed, 18 May 2022 06:24:28 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L3D9H5JmhzCsmx;
        Wed, 18 May 2022 21:19:31 +0800 (CST)
Received: from huawei.com (10.67.174.96) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 21:24:26 +0800
From:   Zhang Jianhua <chris.zjh@huawei.com>
To:     <ebiggers@kernel.org>, <tytso@mit.edu>
CC:     <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] fs-verity: remove unused parameter desc_size in fsverity_create_info()
Date:   Wed, 18 May 2022 21:22:56 +0800
Message-ID: <20220518132256.2297655-1-chris.zjh@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.96]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The parameter desc_size in fsverity_create_info() is useless and it is
not referenced anywhere. The greatest meaning of desc_size here is to
indecate the size of struct fsverity_descriptor and futher calculate the
size of signature. However, the desc->sig_size can do it also and it is
indeed, so remove it.

Therefore, it is no need to acquire desc_size by fsverity_get_descriptor()
in ensure_verity_info(), so remove the parameter desc_ret in
fsverity_get_descriptor() too.

Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
---
 fs/verity/enable.c           |  2 +-
 fs/verity/fsverity_private.h |  6 ++----
 fs/verity/open.c             | 12 ++++--------
 fs/verity/read_metadata.c    |  5 ++---
 4 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 075dc0aa5416..df6b499bf6a1 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -280,7 +280,7 @@ static int enable_verity(struct file *filp,
 	 * from disk.  This is simpler, and it serves as an extra check that the
 	 * metadata we're writing is valid before actually enabling verity.
 	 */
-	vi = fsverity_create_info(inode, desc, desc_size);
+	vi = fsverity_create_info(inode, desc);
 	if (IS_ERR(vi)) {
 		err = PTR_ERR(vi);
 		goto rollback;
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index c6fb62e0ef1a..629785c95007 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -115,16 +115,14 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 				     const u8 *salt, size_t salt_size);
 
 struct fsverity_info *fsverity_create_info(const struct inode *inode,
-					   struct fsverity_descriptor *desc,
-					   size_t desc_size);
+					   struct fsverity_descriptor *desc);
 
 void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
 
 void fsverity_free_info(struct fsverity_info *vi);
 
 int fsverity_get_descriptor(struct inode *inode,
-			    struct fsverity_descriptor **desc_ret,
-			    size_t *desc_size_ret);
+			    struct fsverity_descriptor **desc_ret);
 
 int __init fsverity_init_info_cache(void);
 void __init fsverity_exit_info_cache(void);
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 92df87f5fa38..81ff94442f7b 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -147,8 +147,7 @@ static int compute_file_digest(struct fsverity_hash_alg *hash_alg,
  * fsverity_descriptor must have already undergone basic validation.
  */
 struct fsverity_info *fsverity_create_info(const struct inode *inode,
-					   struct fsverity_descriptor *desc,
-					   size_t desc_size)
+					   struct fsverity_descriptor *desc)
 {
 	struct fsverity_info *vi;
 	int err;
@@ -264,8 +263,7 @@ static bool validate_fsverity_descriptor(struct inode *inode,
  * the filesystem, and do basic validation of it.
  */
 int fsverity_get_descriptor(struct inode *inode,
-			    struct fsverity_descriptor **desc_ret,
-			    size_t *desc_size_ret)
+			    struct fsverity_descriptor **desc_ret)
 {
 	int res;
 	struct fsverity_descriptor *desc;
@@ -297,7 +295,6 @@ int fsverity_get_descriptor(struct inode *inode,
 	}
 
 	*desc_ret = desc;
-	*desc_size_ret = res;
 	return 0;
 }
 
@@ -306,17 +303,16 @@ static int ensure_verity_info(struct inode *inode)
 {
 	struct fsverity_info *vi = fsverity_get_info(inode);
 	struct fsverity_descriptor *desc;
-	size_t desc_size;
 	int err;
 
 	if (vi)
 		return 0;
 
-	err = fsverity_get_descriptor(inode, &desc, &desc_size);
+	err = fsverity_get_descriptor(inode, &desc);
 	if (err)
 		return err;
 
-	vi = fsverity_create_info(inode, desc, desc_size);
+	vi = fsverity_create_info(inode, desc);
 	if (IS_ERR(vi)) {
 		err = PTR_ERR(vi);
 		goto out_free_desc;
diff --git a/fs/verity/read_metadata.c b/fs/verity/read_metadata.c
index 7e2d0c7bdf0d..6ee849dc7bc1 100644
--- a/fs/verity/read_metadata.c
+++ b/fs/verity/read_metadata.c
@@ -101,7 +101,7 @@ static int fsverity_read_descriptor(struct inode *inode,
 	size_t desc_size;
 	int res;
 
-	res = fsverity_get_descriptor(inode, &desc, &desc_size);
+	res = fsverity_get_descriptor(inode, &desc);
 	if (res)
 		return res;
 
@@ -119,10 +119,9 @@ static int fsverity_read_signature(struct inode *inode,
 				   void __user *buf, u64 offset, int length)
 {
 	struct fsverity_descriptor *desc;
-	size_t desc_size;
 	int res;
 
-	res = fsverity_get_descriptor(inode, &desc, &desc_size);
+	res = fsverity_get_descriptor(inode, &desc);
 	if (res)
 		return res;
 
-- 
2.31.0

