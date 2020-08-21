Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E56B24DF7A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgHUS2b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbgHUS2T (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:19 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3CA823100;
        Fri, 21 Aug 2020 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034499;
        bh=2iMgd9gzoGbTXYOv5cvo7OTc/B3IdOkCCK31kYZpqAs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=fxTJctI3Fa5vwZlSuUzSj0EoOPzHKPMoKFDRf9DI08dOMNrMmlanw0Gkg445rKOiF
         x0bBYn7LwiKAuwH7Gcb3V9yynOB+NIC3m57DR0gaMgxnuLHxdyW/GNyE4jG7Aoo9lb
         /9KrdPqUrecRHsbxB0jafzVT7sfVX1Q5qohZl4G4=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 08/14] ceph: add routine to create context prior to RPC
Date:   Fri, 21 Aug 2020 14:28:07 -0400
Message-Id: <20200821182813.52570-9-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Allow the client to create a new encryption context prior to creating a
new inode, and ensure that we set it in the ceph_acl_sec_ctx (alongside
acls, selinux contexts, etc.).

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h |  8 +++++++
 fs/ceph/dir.c    | 15 +++++++++++++
 fs/ceph/file.c   |  4 ++++
 fs/ceph/super.h  |  4 ++++
 5 files changed, 86 insertions(+)

diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
index 22a09d422b72..0e57497c2e55 100644
--- a/fs/ceph/crypto.c
+++ b/fs/ceph/crypto.c
@@ -67,3 +67,58 @@ int ceph_fscrypt_set_ops(struct super_block *sb)
 	}
 	return 0;
 }
+
+int ceph_fscrypt_new_context(struct inode *parent, struct ceph_acl_sec_ctx *as)
+{
+	int ret, ctxsize;
+	size_t name_len;
+	char *name;
+	struct ceph_pagelist *pagelist = as->pagelist;
+
+	/* Do nothing if subtree isn't encrypted */
+	if (!IS_ENCRYPTED(parent))
+		return 0;
+
+	ctxsize = fscrypt_new_context_from_parent(parent, as->fscrypt);
+	if (ctxsize <= 0)
+		return ctxsize;
+
+	/* marshal it in page array */
+	if (!pagelist) {
+		pagelist = ceph_pagelist_alloc(GFP_KERNEL);
+		if (!pagelist)
+			return -ENOMEM;
+		ret = ceph_pagelist_reserve(pagelist, PAGE_SIZE);
+		if (ret)
+			goto out;
+		ceph_pagelist_encode_32(pagelist, 1);
+	}
+
+	name = CEPH_XATTR_NAME_ENCRYPTION_CONTEXT;
+	name_len = strlen(name);
+	ret = ceph_pagelist_reserve(pagelist, 4 * 2 + name_len + ctxsize);
+	if (ret)
+		goto out;
+
+	if (as->pagelist) {
+		BUG_ON(pagelist->length <= sizeof(__le32));
+		if (list_is_singular(&pagelist->head)) {
+			le32_add_cpu((__le32*)pagelist->mapped_tail, 1);
+		} else {
+			struct page *page = list_first_entry(&pagelist->head,
+							     struct page, lru);
+			void *addr = kmap_atomic(page);
+			le32_add_cpu((__le32*)addr, 1);
+			kunmap_atomic(addr);
+		}
+	}
+
+	ceph_pagelist_encode_32(pagelist, name_len);
+	ceph_pagelist_append(pagelist, name, name_len);
+	ceph_pagelist_encode_32(pagelist, ctxsize);
+	ceph_pagelist_append(pagelist, as->fscrypt, ctxsize);
+out:
+	if (pagelist && !as->pagelist)
+		ceph_pagelist_release(pagelist);
+	return ret;
+}
diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index 309925b345fc..e7d00831ef36 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -8,9 +8,12 @@
 
 #ifdef CONFIG_FS_ENCRYPTION
 
+#define CEPH_XATTR_NAME_ENCRYPTION_CONTEXT	"encryption.ctx"
+
 #define DUMMY_ENCRYPTION_ENABLED(fsc) ((fsc)->dummy_enc_ctx.ctx != NULL)
 
 int ceph_fscrypt_set_ops(struct super_block *sb);
+int ceph_fscrypt_new_context(struct inode *parent, struct ceph_acl_sec_ctx *as);
 
 #else /* CONFIG_FS_ENCRYPTION */
 
@@ -21,6 +24,11 @@ static inline int ceph_fscrypt_set_ops(struct super_block *sb)
 	return 0;
 }
 
+static int ceph_fscrypt_new_context(struct inode *parent, struct ceph_acl_sec_ctx *as)
+{
+	return 0;
+}
+
 #endif /* CONFIG_FS_ENCRYPTION */
 
 #endif
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 34f669220a8b..2e7f2bfa2c12 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -9,6 +9,7 @@
 
 #include "super.h"
 #include "mds_client.h"
+#include "crypto.h"
 
 /*
  * Directory operations: readdir, lookup, create, link, unlink,
@@ -848,6 +849,12 @@ static int ceph_mknod(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		goto out;
 
+	if (S_ISREG(mode)) {
+		err = ceph_fscrypt_new_context(dir, &as_ctx);
+		if (err < 0)
+			goto out;
+	}
+
 	dout("mknod in dir %p dentry %p mode 0%ho rdev %d\n",
 	     dir, dentry, mode, rdev);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_MKNOD, USE_AUTH_MDS);
@@ -907,6 +914,10 @@ static int ceph_symlink(struct inode *dir, struct dentry *dentry,
 	if (err < 0)
 		goto out;
 
+	err = ceph_fscrypt_new_context(dir, &as_ctx);
+	if (err < 0)
+		goto out;
+
 	dout("symlink in dir %p dentry %p to '%s'\n", dir, dentry, dest);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SYMLINK, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
@@ -975,6 +986,10 @@ static int ceph_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (err < 0)
 		goto out;
 
+	err = ceph_fscrypt_new_context(dir, &as_ctx);
+	if (err < 0)
+		goto out;
+
 	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index cf3f66d75162..94558e04f34a 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -19,6 +19,7 @@
 #include "cache.h"
 #include "io.h"
 #include "metric.h"
+#include "crypto.h"
 
 static __le32 ceph_flags_sys2wire(u32 flags)
 {
@@ -686,6 +687,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+		err = ceph_fscrypt_new_context(dir, &as_ctx);
+		if (err < 0)
+			goto out_ctx;
 	} else if (!d_in_lookup(dentry)) {
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 6327b5739286..a481cacf775a 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -17,6 +17,7 @@
 #include <linux/posix_acl.h>
 #include <linux/refcount.h>
 #include <linux/security.h>
+#include <linux/fscrypt.h>
 
 #include <linux/ceph/libceph.h>
 
@@ -991,6 +992,9 @@ struct ceph_acl_sec_ctx {
 #ifdef CONFIG_CEPH_FS_SECURITY_LABEL
 	void *sec_ctx;
 	u32 sec_ctxlen;
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+	u8	fscrypt[FSCRYPT_SET_CONTEXT_MAX_SIZE];
 #endif
 	struct ceph_pagelist *pagelist;
 };
-- 
2.26.2

