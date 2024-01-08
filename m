Return-Path: <linux-fscrypt+bounces-109-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E43826749
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jan 2024 03:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 222921F217AB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jan 2024 02:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D21DB79D8;
	Mon,  8 Jan 2024 02:44:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B826D79CD
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jan 2024 02:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4T7dfm4kvSz1wr1q;
	Mon,  8 Jan 2024 10:43:44 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (unknown [7.193.23.68])
	by mail.maildlp.com (Postfix) with ESMTPS id 6FF561A0172;
	Mon,  8 Jan 2024 10:44:19 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 8 Jan
 2024 10:44:18 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <richard@nod.at>, <ebiggers@google.com>, <terrelln@fb.com>
CC: <linux-fscrypt@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: [PATCH v3 1/2] ubifs: dbg_check_idx_size: Fix kmemleak if loading znode failed
Date: Mon, 8 Jan 2024 10:41:04 +0800
Message-ID: <20240108024105.194516-2-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240108024105.194516-1-chengzhihao1@huawei.com>
References: <20240108024105.194516-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)

If function dbg_check_idx_size() failed by loading znode in mounting
process, there are two problems:
  1. Allocated znodes won't be freed, which causes kmemleak in kernel:
     ubifs_mount
      dbg_check_idx_size
       dbg_walk_index
        c->zroot.znode = ubifs_load_znode
	child = ubifs_load_znode // failed
	// Loaded znodes won't be freed in error handling path.
  2. Global variable ubifs_clean_zn_cnt is not decreased, because
     ubifs_tnc_close() is not invoked in error handling path, which
     triggers a warning in ubifs_exit():
      WARNING: CPU: 1 PID: 1576 at fs/ubifs/super.c:2486 ubifs_exit
      Modules linked in: zstd ubifs(-) ubi nandsim
      CPU: 1 PID: 1576 Comm: rmmod Not tainted 6.7.0-rc6
      Call Trace:
	ubifs_exit+0xca/0xc70 [ubifs]
	__do_sys_delete_module+0x29a/0x4a0
	do_syscall_64+0x6f/0x140

Fix it by adding error handling path in dbg_check_idx_size() to release
tnc tree.

Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Suggested-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/debug.c    |  9 +++++++--
 fs/ubifs/tnc.c      |  9 +--------
 fs/ubifs/tnc_misc.c | 22 ++++++++++++++++++++++
 fs/ubifs/ubifs.h    |  1 +
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index d013c5b3f1ed..ac77ac1fd73e 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -1742,17 +1742,22 @@ int dbg_check_idx_size(struct ubifs_info *c, long long idx_size)
 	err = dbg_walk_index(c, NULL, add_size, &calc);
 	if (err) {
 		ubifs_err(c, "error %d while walking the index", err);
-		return err;
+		goto out_err;
 	}
 
 	if (calc != idx_size) {
 		ubifs_err(c, "index size check failed: calculated size is %lld, should be %lld",
 			  calc, idx_size);
 		dump_stack();
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_err;
 	}
 
 	return 0;
+
+out_err:
+	ubifs_destroy_tnc_tree(c);
+	return err;
 }
 
 /**
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 7b7d75ed3ec7..0fabecd9d379 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -3091,14 +3091,7 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
 void ubifs_tnc_close(struct ubifs_info *c)
 {
 	tnc_destroy_cnext(c);
-	if (c->zroot.znode) {
-		long n, freed;
-
-		n = atomic_long_read(&c->clean_zn_cnt);
-		freed = ubifs_destroy_tnc_subtree(c, c->zroot.znode);
-		ubifs_assert(c, freed == n);
-		atomic_long_sub(n, &ubifs_clean_zn_cnt);
-	}
+	ubifs_destroy_tnc_tree(c);
 	kfree(c->gap_lebs);
 	kfree(c->ilebs);
 	destroy_old_idx(c);
diff --git a/fs/ubifs/tnc_misc.c b/fs/ubifs/tnc_misc.c
index 4d686e34e64d..d3f8a6aa1f49 100644
--- a/fs/ubifs/tnc_misc.c
+++ b/fs/ubifs/tnc_misc.c
@@ -250,6 +250,28 @@ long ubifs_destroy_tnc_subtree(const struct ubifs_info *c,
 	}
 }
 
+/**
+ * ubifs_destroy_tnc_tree - destroy all znodes connected to the TNC tree.
+ * @c: UBIFS file-system description object
+ *
+ * This function destroys the whole TNC tree and updates clean global znode
+ * count.
+ */
+void ubifs_destroy_tnc_tree(struct ubifs_info *c)
+{
+	long n, freed;
+
+	if (!c->zroot.znode)
+		return;
+
+	n = atomic_long_read(&c->clean_zn_cnt);
+	freed = ubifs_destroy_tnc_subtree(c, c->zroot.znode);
+	ubifs_assert(c, freed == n);
+	atomic_long_sub(n, &ubifs_clean_zn_cnt);
+
+	c->zroot.znode = NULL;
+}
+
 /**
  * read_znode - read an indexing node from flash and fill znode.
  * @c: UBIFS file-system description object
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 3916dc4f30ca..6eba287ae66c 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1903,6 +1903,7 @@ struct ubifs_znode *ubifs_tnc_postorder_next(const struct ubifs_info *c,
 					     struct ubifs_znode *znode);
 long ubifs_destroy_tnc_subtree(const struct ubifs_info *c,
 			       struct ubifs_znode *zr);
+void ubifs_destroy_tnc_tree(struct ubifs_info *c);
 struct ubifs_znode *ubifs_load_znode(struct ubifs_info *c,
 				     struct ubifs_zbranch *zbr,
 				     struct ubifs_znode *parent, int iip);
-- 
2.39.2


