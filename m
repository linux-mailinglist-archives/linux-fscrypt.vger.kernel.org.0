Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B47550556
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236954AbiFROAw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236309AbiFRNx3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:29 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E61610572
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:25 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 5434C1E89;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 51BB9E4F1D; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        "John L. Hammond" <jhammond@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 26/28] lustre: lov: remove lov_page
Date:   Sat, 18 Jun 2022 09:52:08 -0400
Message-Id: <1655560330-30743-27-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
References: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: "John L. Hammond" <jhammond@whamcloud.com>

Remove the lov page layer since it does nothing but costs 24 bytes per
page plus pointer chases.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10994
Lustre-commit: 56f520b1a4c9ae64c ("LU-10994 lov: remove lov_page")
Signed-off-by: John L. Hammond <jhammond@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/47221
Reviewed-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-by: Bobi Jam <bobijam@hotmail.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/cl_object.h   | 13 ++++++------
 fs/lustre/lov/lov_cl_internal.h | 32 ++++++++++++----------------
 fs/lustre/lov/lov_object.c      |  5 ++---
 fs/lustre/lov/lov_page.c        | 46 ++++++-----------------------------------
 4 files changed, 27 insertions(+), 69 deletions(-)

diff --git a/fs/lustre/include/cl_object.h b/fs/lustre/include/cl_object.h
index 06f03b4..5be89d6 100644
--- a/fs/lustre/include/cl_object.h
+++ b/fs/lustre/include/cl_object.h
@@ -720,7 +720,7 @@ enum cl_page_type {
 
 #define	CP_STATE_BITS	4
 #define	CP_TYPE_BITS	2
-#define	CP_MAX_LAYER	3
+#define	CP_MAX_LAYER	2
 
 /**
  * Fields are protected by the lock on struct page, except for atomics and
@@ -751,22 +751,21 @@ struct cl_page {
 	/** Linkage of pages within group. Pages must be owned */
 	struct list_head		 cp_batch;
 	/** array of slices offset. Immutable after creation. */
-	unsigned char			 cp_layer_offset[CP_MAX_LAYER]; /* 24 bits */
+	unsigned char			 cp_layer_offset[CP_MAX_LAYER];
 	/** current slice index */
-	unsigned char			 cp_layer_count:2; /* 26 bits */
+	unsigned char			 cp_layer_count:2;
 	/**
 	 * Page state. This field is const to avoid accidental update, it is
 	 * modified only internally within cl_page.c. Protected by a VM lock.
 	 */
-	enum cl_page_state		 cp_state:CP_STATE_BITS; /* 30 bits */
+	enum cl_page_state		 cp_state:CP_STATE_BITS;
 	/**
 	 * Page type. Only CPT_TRANSIENT is used so far. Immutable after
 	 * creation.
 	 */
-	enum cl_page_type		 cp_type:CP_TYPE_BITS; /* 32 bits */
+	enum cl_page_type		 cp_type:CP_TYPE_BITS;
 	/* which slab kmem index this memory allocated from */
-	short int			 cp_kmem_index; /* 48 bits */
-	unsigned int			 cp_unused1:16; /* 64 bits */
+	short int			 cp_kmem_index;
 
 	/**
 	 * Owning IO in cl_page_state::CPS_OWNED state. Sub-page can be owned
diff --git a/fs/lustre/lov/lov_cl_internal.h b/fs/lustre/lov/lov_cl_internal.h
index 6b96543..95dbb43 100644
--- a/fs/lustre/lov/lov_cl_internal.h
+++ b/fs/lustre/lov/lov_cl_internal.h
@@ -48,14 +48,13 @@
 /** \defgroup lov lov
  * Logical object volume layer. This layer implements data striping (raid0).
  *
- * At the lov layer top-entity (object, page, lock, io) is connected to one or
+ * At the lov layer top-entity (object, lock, io) is connected to one or
  * more sub-entities: top-object, representing a file is connected to a set of
  * sub-objects, each representing a stripe, file-level top-lock is connected
- * to a set of per-stripe sub-locks, top-page is connected to a (single)
- * sub-page, and a top-level IO is connected to a set of (potentially
- * concurrent) sub-IO's.
+ * to a set of per-stripe sub-locks, and a top-level IO is connected to a set of
+ * (potentially concurrent) sub-IO's.
  *
- * Sub-object, sub-page, and sub-io have well-defined top-object and top-page
+ * Sub-object and sub-io have well-defined top-object and top-io
  * respectively, while a single sub-lock can be part of multiple top-locks.
  *
  * Reference counting models are different for different types of entities:
@@ -63,9 +62,6 @@
  *     - top-object keeps a reference to its sub-objects, and destroys them
  *       when it is destroyed.
  *
- *     - top-page keeps a reference to its sub-page, and destroys it when it
- *       is destroyed.
- *
  *     - IO's are not reference counted.
  *
  * To implement a connection between top and sub entities, lov layer is split
@@ -441,10 +437,6 @@ struct lov_lock {
 	struct lov_lock_sub     lls_sub[0];
 };
 
-struct lov_page {
-	struct cl_page_slice	lps_cl;
-};
-
 /*
  * Bottom half.
  */
@@ -626,6 +618,15 @@ int lov_io_init_released(const struct lu_env *env, struct cl_object *obj,
 struct lov_io_sub *lov_sub_get(const struct lu_env *env, struct lov_io *lio,
 			       int stripe);
 
+enum {
+	CP_LOV_INDEX_EMPTY = -1U,
+};
+
+static inline bool lov_page_is_empty(const struct cl_page *cp)
+{
+	return cp->cp_lov_index == CP_LOV_INDEX_EMPTY;
+}
+
 int lov_page_init_empty(const struct lu_env *env, struct cl_object *obj,
 			struct cl_page *page, pgoff_t index);
 int lov_page_init_composite(const struct lu_env *env, struct cl_object *obj,
@@ -640,7 +641,6 @@ struct lu_object *lovsub_object_alloc(const struct lu_env *env,
 				      const struct lu_object_header *hdr,
 				      struct lu_device *dev);
 
-bool lov_page_is_empty(const struct cl_page *page);
 int lov_lsm_entry(const struct lov_stripe_md *lsm, u64 offset);
 int lov_io_layout_at(struct lov_io *lio, u64 offset);
 
@@ -776,12 +776,6 @@ static inline struct lov_lock *cl2lov_lock(const struct cl_lock_slice *slice)
 	return container_of(slice, struct lov_lock, lls_cl);
 }
 
-static inline struct lov_page *cl2lov_page(const struct cl_page_slice *slice)
-{
-	LINVRNT(lov_is_object(&slice->cpl_obj->co_lu));
-	return container_of(slice, struct lov_page, lps_cl);
-}
-
 static inline struct lov_io *cl2lov_io(const struct lu_env *env,
 				       const struct cl_io_slice *ios)
 {
diff --git a/fs/lustre/lov/lov_object.c b/fs/lustre/lov/lov_object.c
index d9eaf15..3934a98 100644
--- a/fs/lustre/lov/lov_object.c
+++ b/fs/lustre/lov/lov_object.c
@@ -113,8 +113,7 @@ static int lov_page_slice_fixup(struct lov_object *lov,
 	struct cl_object *o;
 
 	if (!stripe)
-		return hdr->coh_page_bufsize - lov->lo_cl.co_slice_off -
-		       cfs_size_round(sizeof(struct lov_page));
+		return hdr->coh_page_bufsize - lov->lo_cl.co_slice_off;
 
 	cl_object_for_each(o, stripe)
 		o->co_slice_off += hdr->coh_page_bufsize;
@@ -1329,7 +1328,7 @@ static int lov_object_init(const struct lu_env *env, struct lu_object *obj,
 	init_rwsem(&lov->lo_type_guard);
 	atomic_set(&lov->lo_active_ios, 0);
 	init_waitqueue_head(&lov->lo_waitq);
-	cl_object_page_init(lu2cl(obj), sizeof(struct lov_page));
+	cl_object_page_init(lu2cl(obj), 0);
 
 	lov->lo_type = LLT_EMPTY;
 	if (cconf->u.coc_layout.lb_buf) {
diff --git a/fs/lustre/lov/lov_page.c b/fs/lustre/lov/lov_page.c
index 16bd7cd..bd6ba79 100644
--- a/fs/lustre/lov/lov_page.c
+++ b/fs/lustre/lov/lov_page.c
@@ -39,6 +39,8 @@
 
 #include <linux/highmem.h>
 #include "lov_cl_internal.h"
+#include <linux/bug.h>
+#include <linux/compiler.h>
 
 /** \addtogroup lov
  *  @{
@@ -49,20 +51,6 @@
  * Lov page operations.
  *
  */
-static int lov_comp_page_print(const struct lu_env *env,
-			       const struct cl_page_slice *slice,
-			       void *cookie, lu_printer_t printer)
-{
-	struct lov_page *lp = cl2lov_page(slice);
-
-	return (*printer)(env, cookie,
-			  LUSTRE_LOV_NAME"-page@%p\n", lp);
-}
-
-static const struct cl_page_operations lov_comp_page_ops = {
-	.cpo_print	= lov_comp_page_print
-};
-
 int lov_page_init_composite(const struct lu_env *env, struct cl_object *obj,
 			    struct cl_page *page, pgoff_t index)
 {
@@ -72,7 +60,6 @@ int lov_page_init_composite(const struct lu_env *env, struct cl_object *obj,
 	struct cl_object *subobj;
 	struct cl_object *o;
 	struct lov_io_sub *sub;
-	struct lov_page *lpg = cl_object_page_slice(obj, page);
 	bool stripe_cached = false;
 	u64 offset;
 	u64 suboff;
@@ -118,7 +105,7 @@ int lov_page_init_composite(const struct lu_env *env, struct cl_object *obj,
 	       offset, entry, stripe, suboff);
 
 	page->cp_lov_index = lov_comp_index(entry, stripe);
-	cl_page_slice_add(page, &lpg->lps_cl, obj, &lov_comp_page_ops);
+	LASSERT(page->cp_lov_index != CP_LOV_INDEX_EMPTY);
 
 	if (!stripe_cached) {
 		sub = lov_sub_get(env, lio, page->cp_lov_index);
@@ -146,28 +133,14 @@ int lov_page_init_composite(const struct lu_env *env, struct cl_object *obj,
 	return rc;
 }
 
-static int lov_empty_page_print(const struct lu_env *env,
-				const struct cl_page_slice *slice,
-				void *cookie, lu_printer_t printer)
-{
-	struct lov_page *lp = cl2lov_page(slice);
-
-	return (*printer)(env, cookie, LUSTRE_LOV_NAME "-page@%p, empty.\n",
-			  lp);
-}
-
-static const struct cl_page_operations lov_empty_page_ops = {
-	.cpo_print	= lov_empty_page_print
-};
-
 int lov_page_init_empty(const struct lu_env *env, struct cl_object *obj,
 			struct cl_page *page, pgoff_t index)
 {
-	struct lov_page *lpg = cl_object_page_slice(obj, page);
 	void *addr;
 
-	page->cp_lov_index = ~0;
-	cl_page_slice_add(page, &lpg->lps_cl, obj, &lov_empty_page_ops);
+	BUILD_BUG_ON(!__same_type(page->cp_lov_index, CP_LOV_INDEX_EMPTY));
+	page->cp_lov_index = CP_LOV_INDEX_EMPTY;
+
 	addr = kmap(page->cp_vmpage);
 	memset(addr, 0, cl_page_size(obj));
 	kunmap(page->cp_vmpage);
@@ -182,11 +155,4 @@ int lov_page_init_foreign(const struct lu_env *env, struct cl_object *obj,
 	return -ENODATA;
 }
 
-bool lov_page_is_empty(const struct cl_page *page)
-{
-	const struct cl_page_slice *slice = cl_page_at(page, &lov_device_type);
-
-	LASSERT(slice);
-	return slice->cpl_ops == &lov_empty_page_ops;
-}
 /** @} lov */
-- 
1.8.3.1

