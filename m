Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89CC0544C27
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245475AbiFIMeE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiFIMeA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:00 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6AE622BC2
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:47 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 51DBAEFC;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 4FA1BD43AC; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Lai Siyao <lai.siyao@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 13/18] lustre: llite: access lli_lsm_md with lock in all places
Date:   Thu,  9 Jun 2022 08:33:09 -0400
Message-Id: <1654777994-29806-14-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654777994-29806-1-git-send-email-jsimmons@infradead.org>
References: <1654777994-29806-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Lai Siyao <lai.siyao@whamcloud.com>

lli_lsm_md should be accessed with lock in all places. Among all the
changes, ll_rease_page() is inside lock already, except statahead
code.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15284
Lustre-commit: 1dfae156d1dbc11cf ("LU-15284 llite: access lli_lsm_md with lock in all places")
Signed-off-by: Lai Siyao <lai.siyao@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/46355
Reviewed-by: Mike Pershin <mpershin@whamcloud.com>
Reviewed-by: John L. Hammond <jhammond@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/llite/dir.c            |  6 +++---
 fs/lustre/llite/file.c           |  8 +++++---
 fs/lustre/llite/llite_internal.h | 17 +++++++++++++++--
 fs/lustre/llite/llite_lib.c      | 20 +++++++++++---------
 fs/lustre/llite/namei.c          |  7 +++++--
 fs/lustre/llite/statahead.c      |  2 ++
 fs/lustre/lmv/lmv_obd.c          |  3 ++-
 7 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/fs/lustre/llite/dir.c b/fs/lustre/llite/dir.c
index cfd8184..29d7e44 100644
--- a/fs/lustre/llite/dir.c
+++ b/fs/lustre/llite/dir.c
@@ -162,11 +162,11 @@ void ll_release_page(struct inode *inode, struct page *page, bool remove)
 {
 	kunmap(page);
 
-	/*
-	 * Always remove the page for striped dir, because the page is
+	/* Always remove the page for striped dir, because the page is
 	 * built from temporarily in LMV layer
 	 */
-	if (inode && ll_dir_striped(inode)) {
+	if (inode && S_ISDIR(inode->i_mode) &&
+	    lmv_dir_striped(ll_i2info(inode)->lli_lsm_md)) {
 		__free_page(page);
 		return;
 	}
diff --git a/fs/lustre/llite/file.c b/fs/lustre/llite/file.c
index 1ac3e4f..30f522b 100644
--- a/fs/lustre/llite/file.c
+++ b/fs/lustre/llite/file.c
@@ -5066,12 +5066,14 @@ static int ll_merge_md_attr(struct inode *inode)
 	struct cl_attr attr = { 0 };
 	int rc;
 
-	LASSERT(lli->lli_lsm_md);
-
-	if (!lmv_dir_striped(lli->lli_lsm_md))
+	if (!lli->lli_lsm_md)
 		return 0;
 
 	down_read(&lli->lli_lsm_sem);
+	if (!lmv_dir_striped(lli->lli_lsm_md)) {
+		up_read(&lli->lli_lsm_sem);
+		return 0;
+	}
 	rc = md_merge_attr(ll_i2mdexp(inode), lli->lli_lsm_md, &attr,
 			   ll_md_blocking_ast);
 	up_read(&lli->lli_lsm_sem);
diff --git a/fs/lustre/llite/llite_internal.h b/fs/lustre/llite/llite_internal.h
index f51ab19..bc50169 100644
--- a/fs/lustre/llite/llite_internal.h
+++ b/fs/lustre/llite/llite_internal.h
@@ -1373,9 +1373,22 @@ static inline struct lu_fid *ll_inode2fid(struct inode *inode)
 
 static inline bool ll_dir_striped(struct inode *inode)
 {
+	struct ll_inode_info *lli;
+	bool rc;
+
 	LASSERT(inode);
-	return S_ISDIR(inode->i_mode) &&
-	       lmv_dir_striped(ll_i2info(inode)->lli_lsm_md);
+	if (!S_ISDIR(inode->i_mode))
+		return false;
+
+	lli = ll_i2info(inode);
+	if (!lli->lli_lsm_md)
+		return false;
+
+	down_read(&lli->lli_lsm_sem);
+	rc = lmv_dir_striped(lli->lli_lsm_md);
+	up_read(&lli->lli_lsm_sem);
+
+	return rc;
 }
 
 static inline loff_t ll_file_maxbytes(struct inode *inode)
diff --git a/fs/lustre/llite/llite_lib.c b/fs/lustre/llite/llite_lib.c
index ad77ef0..99ab9ac 100644
--- a/fs/lustre/llite/llite_lib.c
+++ b/fs/lustre/llite/llite_lib.c
@@ -1626,23 +1626,25 @@ static int ll_update_lsm_md(struct inode *inode, struct lustre_md *md)
 	}
 
 	rc = ll_init_lsm_md(inode, md);
-	up_write(&lli->lli_lsm_sem);
-
-	if (rc)
+	if (rc) {
+		up_write(&lli->lli_lsm_sem);
 		return rc;
+	}
+
+	/* md_merge_attr() may take long, since lsm is already set, switch to
+	 * read lock.
+	 */
+	downgrade_write(&lli->lli_lsm_sem);
 
 	/* set md->lmv to NULL, so the following free lustre_md will not free
 	 * this lsm.
 	 */
 	md->lmv = NULL;
 
-	/* md_merge_attr() may take long, since lsm is already set, switch to
-	 * read lock.
-	 */
-	down_read(&lli->lli_lsm_sem);
-
-	if (!lmv_dir_striped(lli->lli_lsm_md))
+	if (!lmv_dir_striped(lli->lli_lsm_md)) {
+		rc = 0;
 		goto unlock;
+	}
 
 	attr = kzalloc(sizeof(*attr), GFP_NOFS);
 	if (!attr) {
diff --git a/fs/lustre/llite/namei.c b/fs/lustre/llite/namei.c
index c05e3bf..f7e900d 100644
--- a/fs/lustre/llite/namei.c
+++ b/fs/lustre/llite/namei.c
@@ -765,14 +765,17 @@ static int ll_lookup_it_finish(struct ptlrpc_request *request,
 			.it_op = IT_GETATTR,
 			.it_lock_handle = 0
 		};
-		struct lu_fid fid = ll_i2info(parent)->lli_fid;
+		struct ll_inode_info *lli = ll_i2info(parent);
+		struct lu_fid fid = lli->lli_fid;
 
 		/* If it is striped directory, get the real stripe parent */
 		if (unlikely(ll_dir_striped(parent))) {
+			down_read(&lli->lli_lsm_sem);
 			rc = md_get_fid_from_lsm(ll_i2mdexp(parent),
-						 ll_i2info(parent)->lli_lsm_md,
+						 lli->lli_lsm_md,
 						 (*de)->d_name.name,
 						 (*de)->d_name.len, &fid);
+			up_read(&lli->lli_lsm_sem);
 			if (rc)
 				return rc;
 		}
diff --git a/fs/lustre/llite/statahead.c b/fs/lustre/llite/statahead.c
index c781e49..3043a51 100644
--- a/fs/lustre/llite/statahead.c
+++ b/fs/lustre/llite/statahead.c
@@ -1164,8 +1164,10 @@ static int ll_statahead_thread(void *arg)
 		}
 
 		pos = le64_to_cpu(dp->ldp_hash_end);
+		down_read(&lli->lli_lsm_sem);
 		ll_release_page(dir, page,
 				le32_to_cpu(dp->ldp_flags) & LDF_COLLIDE);
+		up_read(&lli->lli_lsm_sem);
 
 		if (sa_low_hit(sai)) {
 			rc = -EFAULT;
diff --git a/fs/lustre/lmv/lmv_obd.c b/fs/lustre/lmv/lmv_obd.c
index 5b43cfd..d83ba41ff 100644
--- a/fs/lustre/lmv/lmv_obd.c
+++ b/fs/lustre/lmv/lmv_obd.c
@@ -3654,7 +3654,8 @@ static int lmv_revalidate_lock(struct obd_export *exp, struct lookup_intent *it,
 {
 	const struct lmv_oinfo *oinfo;
 
-	LASSERT(lmv_dir_striped(lsm));
+	if (!lmv_dir_striped(lsm))
+		return -ESTALE;
 
 	oinfo = lsm_name_to_stripe_info(lsm, name, namelen, false);
 	if (IS_ERR(oinfo))
-- 
1.8.3.1

