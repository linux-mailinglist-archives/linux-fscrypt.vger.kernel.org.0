Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779CC550538
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiFRNw6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiFRNwx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:53 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B026CB2A
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:50 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 16B2F13DB;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 151FC1002C9; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Patrick Farrell <pfarrell@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 12/28] lustre: llite: Correct cl_env comments
Date:   Sat, 18 Jun 2022 09:51:54 -0400
Message-Id: <1655560330-30743-13-git-send-email-jsimmons@infradead.org>
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

From: Patrick Farrell <pfarrell@whamcloud.com>

The comments related to cl_env caching behavior are
dangerously out of date and misleading, describing an
old caching mechanism which was linked to threads.

This has not been present for some time, and we cannot use
cl_env_get to get the environment for a thread as it
describes.

Correct the various comments and remove a now extraneous
include.

Fixes: a763e916d8 ("staging/lustre: Get rid of cl_env hash table")
WC-bug-id: https://jira.whamcloud.com/browse/LU-14832
Lustre-commit: c6d1f8aacafe67510 ("LU-14832 llite: Correct cl_env comments")
Signed-off-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/44191
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Wang Shilong <wangshilong1991@gmail.com>
Reviewed-by: Sebastien Buisson <sbuisson@ddn.com>
Reviewed-by: John L. Hammond <jhammond@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/obdclass/cl_object.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/lustre/obdclass/cl_object.c b/fs/lustre/obdclass/cl_object.c
index c5deb5c..6f87160 100644
--- a/fs/lustre/obdclass/cl_object.c
+++ b/fs/lustre/obdclass/cl_object.c
@@ -532,21 +532,6 @@ int cl_site_stats_print(const struct cl_site *site, struct seq_file *m)
  *
  */
 
-/**
- * The most efficient way is to store cl_env pointer in task specific
- * structures. On Linux, it isn't easy to use task_struct->journal_info
- * because Lustre code may call into other fs during memory reclaim, which
- * has certain assumptions about journal_info. There are not currently any
- * fields in task_struct that can be used for this purpose.
- * \note As long as we use task_struct to store cl_env, we assume that once
- * called into Lustre, we'll never call into the other part of the kernel
- * which will use those fields in task_struct without explicitly exiting
- * Lustre.
- *
- * Since there's no space in task_struct is available, hash will be used.
- * bz20044, bz22683.
- */
-
 static unsigned int cl_envs_cached_max = 32; /* XXX: prototype: arbitrary limit
 					      * for now.
 					      */
@@ -628,6 +613,9 @@ static void cl_env_fini(struct cl_env *cle)
 	kmem_cache_free(cl_env_kmem, cle);
 }
 
+/* Get a cl_env, either from the per-CPU cache for the current CPU, or by
+ * allocating a new one.
+ */
 static struct lu_env *cl_env_obtain(void *debug)
 {
 	struct cl_env *cle;
@@ -672,10 +660,14 @@ static inline struct cl_env *cl_env_container(struct lu_env *env)
 }
 
 /**
- * Returns lu_env: if there already is an environment associated with the
- * current thread, it is returned, otherwise, new environment is allocated.
+ * Returns an lu_env.
+ *
+ * No link to thread, this returns an env from the cache or
+ * allocates a new one.
  *
- * Allocations are amortized through the global cache of environments.
+ * If you need to get the specific environment you created for this thread,
+ * you must either pass the pointer directly or store it in the file/inode
+ * private data and retrieve it from there using ll_cl_add/ll_cl_find.
  *
  * @refcheck pointer to a counter used to detect environment leaks. In
  * the usual case cl_env_get() and cl_env_put() are called in the same lexical
@@ -765,8 +757,8 @@ unsigned int cl_env_cache_purge(unsigned int nr)
  * Release an environment.
  *
  * Decrement @env reference counter. When counter drops to 0, nothing in
- * this thread is using environment and it is returned to the allocation
- * cache, or freed straight away, if cache is large enough.
+ * this thread is using environment and it is returned to the per-CPU cache or
+ * freed immediately if the cache is full.
  */
 void cl_env_put(struct lu_env *env, u16 *refcheck)
 {
-- 
1.8.3.1

