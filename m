Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453AB544C12
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244796AbiFIMde (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245234AbiFIMd0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:26 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5D1186FB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:23 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 39621EF1;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 2D622D439B; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Patrick Farrell <pfarrell@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 02/18] lustre: llite: Check vmpage in releasepage
Date:   Thu,  9 Jun 2022 08:32:58 -0400
Message-Id: <1654777994-29806-3-git-send-email-jsimmons@infradead.org>
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

From: Patrick Farrell <pfarrell@whamcloud.com>

We cannot release a page if the vmpage reference count is
>1, otherwise we will detach a vmpage from Lustre when the
page is still referenced in the VM.

This creates a situation where page discard for lock
cancellation will not find the page, so we can get stale
data reads.

This re-introduces the LU-12587 issue where direct I/O on
a client falls back to buffered I/O if there are pages in
cache, since it cannot flush them.  This is annoying but
not a huge problem.

WC-bug-id: https://jira.whamcloud.com/browse/LU-14541
Lustre-commit: c524079f4f59a39b9 ("LU-14541 llite: Check vmpage in releasepage")
Signed-off-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/47262
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: John L. Hammond <jhammond@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/cl_object.h |  9 +++++++++
 fs/lustre/llite/rw26.c        | 19 +++++++++++++------
 fs/lustre/osc/osc_page.c      |  9 +++++++--
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/lustre/include/cl_object.h b/fs/lustre/include/cl_object.h
index ab7f0f2..b98109d 100644
--- a/fs/lustre/include/cl_object.h
+++ b/fs/lustre/include/cl_object.h
@@ -91,6 +91,7 @@
 #include <linux/uio.h>
 #include <lu_object.h>
 #include <linux/atomic.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/spinlock.h>
@@ -1071,6 +1072,14 @@ static inline bool __page_in_use(const struct cl_page *page, int refc)
  */
 #define cl_page_in_use_noref(pg) __page_in_use(pg, 0)
 
+/* references: cl_page, page cache, optional + refcount for caller reference
+ * (always 0 or 1 currently)
+ */
+static inline int vmpage_in_use(struct page *vmpage, int refcount)
+{
+	return (page_count(vmpage) - page_mapcount(vmpage) > 2 + refcount);
+}
+
 /** @} cl_page */
 
 /** \addtogroup cl_lock cl_lock
diff --git a/fs/lustre/llite/rw26.c b/fs/lustre/llite/rw26.c
index a5cdb01..8b379ca 100644
--- a/fs/lustre/llite/rw26.c
+++ b/fs/lustre/llite/rw26.c
@@ -102,7 +102,7 @@ static int ll_releasepage(struct page *vmpage, gfp_t gfp_mask)
 {
 	struct lu_env *env;
 	struct cl_object *obj;
-	struct cl_page *page;
+	struct cl_page *clpage;
 	struct address_space *mapping;
 	int result = 0;
 
@@ -118,16 +118,23 @@ static int ll_releasepage(struct page *vmpage, gfp_t gfp_mask)
 	if (!obj)
 		return 1;
 
-	page = cl_vmpage_page(vmpage, obj);
-	if (!page)
+	clpage = cl_vmpage_page(vmpage, obj);
+	if (!clpage)
 		return 1;
 
 	env = cl_env_percpu_get();
 	LASSERT(!IS_ERR(env));
 
-	if (!cl_page_in_use(page)) {
+	/* we must not delete the cl_page if the vmpage is in use, otherwise we
+	 * disconnect the vmpage from Lustre while it's still alive(!), which
+	 * means we won't find it to discard on lock cancellation.
+	 *
+	 * References here are: caller + cl_page + page cache.
+	 * Any other references are potentially transient and must be ignored.
+	 */
+	if (!cl_page_in_use(clpage) && !vmpage_in_use(vmpage, 1)) {
 		result = 1;
-		cl_page_delete(env, page);
+		cl_page_delete(env, clpage);
 	}
 
 	/* To use percpu env array, the call path can not be rescheduled;
@@ -144,7 +151,7 @@ static int ll_releasepage(struct page *vmpage, gfp_t gfp_mask)
 	 * that we won't get into object delete path.
 	 */
 	LASSERT(cl_object_refc(obj) > 1);
-	cl_page_put(env, page);
+	cl_page_put(env, clpage);
 
 	cl_env_percpu_put(env);
 	return result;
diff --git a/fs/lustre/osc/osc_page.c b/fs/lustre/osc/osc_page.c
index f46b4e7..b56bc1a 100644
--- a/fs/lustre/osc/osc_page.c
+++ b/fs/lustre/osc/osc_page.c
@@ -539,8 +539,13 @@ static inline bool lru_page_busy(struct client_obd *cli, struct cl_page *page)
 	if (cli->cl_cache->ccc_unstable_check) {
 		struct page *vmpage = cl_page_vmpage(page);
 
-		/* vmpage have two known users: cl_page and VM page cache */
-		if (page_count(vmpage) - page_mapcount(vmpage) > 2)
+		/* this check is racy because the vmpage is not locked, but
+		 * that's OK - the code which does the actual page release
+		 * checks this again before releasing
+		 *
+		 * vmpage have two known users: cl_page and VM page cache
+		 */
+		if (vmpage_in_use(vmpage, 0))
 			return true;
 	}
 	return false;
-- 
1.8.3.1

