Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B80544C2B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245497AbiFIMeP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245537AbiFIMeL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:11 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD5A22520
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:34:10 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 61DAC1021;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 5F4E9D43A3; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Chris Horn <chris.horn@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 18/18] lnet: Avoid redundant peer NI lookups
Date:   Thu,  9 Jun 2022 08:33:14 -0400
Message-Id: <1654777994-29806-19-git-send-email-jsimmons@infradead.org>
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

From: Chris Horn <chris.horn@hpe.com>

Each caller of lnet_peer_ni_traffic_add() performs a subsequent call
to lnet_peer_ni_find_locked(). We can avoid the extra lookup by having
lnet_peer_ni_traffic_add() return a peer NI pointer (or ERR_PTR as
appropriate).

lnet_peer_ni_traffic_add() now takes a ref on the peer NI to mimic
the behavior of lnet_peer_ni_find_locked().

lnet_nid2peerni_ex() only has a single caller that always passes
LNET_LOCK_EX for the cpt argument, so this function argument is
removed.

Some duplicate code dealing with ln_state handling is removed from
lnet_peerni_by_nid_locked()

WC-bug-id: https://jira.whamcloud.com/browse/LU-12756
Lustre-commit: b00ac5f7038434a33 ("LU-12756 lnet: Avoid redundant peer NI lookups")
Signed-off-by: Chris Horn <chris.horn@hpe.com>
Reviewed-on: https://review.whamcloud.com/36623
Reviewed-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/lnet/lib-lnet.h |  2 +-
 net/lnet/lnet/peer.c          | 74 ++++++++++++++++++-------------------------
 net/lnet/lnet/router.c        |  6 ++--
 3 files changed, 35 insertions(+), 47 deletions(-)

diff --git a/include/linux/lnet/lib-lnet.h b/include/linux/lnet/lib-lnet.h
index 2e3c391..ca2a565 100644
--- a/include/linux/lnet/lib-lnet.h
+++ b/include/linux/lnet/lib-lnet.h
@@ -901,7 +901,7 @@ struct lnet_peer_ni *lnet_nid2peerni_locked(lnet_nid_t nid, lnet_nid_t pref,
 struct lnet_peer_ni *lnet_peerni_by_nid_locked(struct lnet_nid *nid,
 					       struct lnet_nid *pref,
 					       int cpt);
-struct lnet_peer_ni *lnet_nid2peerni_ex(struct lnet_nid *nid, int cpt);
+struct lnet_peer_ni *lnet_nid2peerni_ex(struct lnet_nid *nid);
 struct lnet_peer_ni *lnet_peer_get_ni_locked(struct lnet_peer *lp,
 					     lnet_nid_t nid);
 struct lnet_peer_ni *lnet_peer_ni_get_locked(struct lnet_peer *lp,
diff --git a/net/lnet/lnet/peer.c b/net/lnet/lnet/peer.c
index 6c35901..57d137c 100644
--- a/net/lnet/lnet/peer.c
+++ b/net/lnet/lnet/peer.c
@@ -1836,19 +1836,22 @@ struct lnet_peer_net *
 
 /*
  * lpni creation initiated due to traffic either sending or receiving.
+ * Callers must hold ln_api_mutex
+ * Ref taken on lnet_peer_ni returned by this function
  */
-static int
+static struct lnet_peer_ni *
 lnet_peer_ni_traffic_add(struct lnet_nid *nid, struct lnet_nid *pref)
+__must_hold(&the_lnet.ln_api_mutex)
 {
-	struct lnet_peer *lp;
-	struct lnet_peer_net *lpn;
+	struct lnet_peer *lp = NULL;
+	struct lnet_peer_net *lpn = NULL;
 	struct lnet_peer_ni *lpni;
 	unsigned int flags = 0;
 	int rc = 0;
 
 	if (LNET_NID_IS_ANY(nid)) {
 		rc = -EINVAL;
-		goto out;
+		goto out_err;
 	}
 
 	/* lnet_net_lock is not needed here because ln_api_lock is held */
@@ -1860,7 +1863,6 @@ struct lnet_peer_net *
 		 * traffic, we just assume everything is ok and
 		 * return.
 		 */
-		lnet_peer_ni_decref_locked(lpni);
 		goto out;
 	}
 
@@ -1868,24 +1870,29 @@ struct lnet_peer_net *
 	rc = -ENOMEM;
 	lp = lnet_peer_alloc(nid);
 	if (!lp)
-		goto out;
+		goto out_err;
 	lpn = lnet_peer_net_alloc(LNET_NID_NET(nid));
 	if (!lpn)
-		goto out_free_lp;
+		goto out_err;
 	lpni = lnet_peer_ni_alloc(nid);
 	if (!lpni)
-		goto out_free_lpn;
+		goto out_err;
 	lnet_peer_ni_set_non_mr_pref_nid(lpni, pref);
 
-	return lnet_peer_attach_peer_ni(lp, lpn, lpni, flags);
+	/* lnet_peer_attach_peer_ni() always returns 0 */
+	rc = lnet_peer_attach_peer_ni(lp, lpn, lpni, flags);
 
-out_free_lpn:
-	kfree(lpn);
-out_free_lp:
-	kfree(lp);
+	lnet_peer_ni_addref_locked(lpni);
+
+out_err:
+	if (rc) {
+		kfree(lpn);
+		kfree(lp);
+		lpni = ERR_PTR(rc);
+	}
 out:
 	CDEBUG(D_NET, "peer %s: %d\n", libcfs_nidstr(nid), rc);
-	return rc;
+	return lpni;
 }
 
 /*
@@ -2054,10 +2061,10 @@ struct lnet_peer_net *
 }
 
 struct lnet_peer_ni *
-lnet_nid2peerni_ex(struct lnet_nid *nid, int cpt)
+lnet_nid2peerni_ex(struct lnet_nid *nid)
+__must_hold(&the_lnet.ln_api_mutex)
 {
 	struct lnet_peer_ni *lpni = NULL;
-	int rc;
 
 	if (the_lnet.ln_state != LNET_STATE_RUNNING)
 		return ERR_PTR(-ESHUTDOWN);
@@ -2070,19 +2077,11 @@ struct lnet_peer_ni *
 	if (lpni)
 		return lpni;
 
-	lnet_net_unlock(cpt);
-
-	rc = lnet_peer_ni_traffic_add(nid, NULL);
-	if (rc) {
-		lpni = ERR_PTR(rc);
-		goto out_net_relock;
-	}
+	lnet_net_unlock(LNET_LOCK_EX);
 
-	lpni = lnet_peer_ni_find_locked(nid);
-	LASSERT(lpni);
+	lpni = lnet_peer_ni_traffic_add(nid, NULL);
 
-out_net_relock:
-	lnet_net_lock(cpt);
+	lnet_net_lock(LNET_LOCK_EX);
 
 	return lpni;
 }
@@ -2096,7 +2095,6 @@ struct lnet_peer_ni *
 			  struct lnet_nid *pref, int cpt)
 {
 	struct lnet_peer_ni *lpni = NULL;
-	int rc;
 
 	if (the_lnet.ln_state != LNET_STATE_RUNNING)
 		return ERR_PTR(-ESHUTDOWN);
@@ -2124,30 +2122,18 @@ struct lnet_peer_ni *
 	lnet_net_unlock(cpt);
 	mutex_lock(&the_lnet.ln_api_mutex);
 	/*
-	 * Shutdown is only set under the ln_api_lock, so a single
+	 * the_lnet.ln_state is only modified under the ln_api_lock, so a single
 	 * check here is sufficent.
 	 */
-	if (the_lnet.ln_state != LNET_STATE_RUNNING) {
-		lpni = ERR_PTR(-ESHUTDOWN);
-		goto out_mutex_unlock;
-	}
-
-	rc = lnet_peer_ni_traffic_add(nid, pref);
-	if (rc) {
-		lpni = ERR_PTR(rc);
-		goto out_mutex_unlock;
-	}
-
-	lpni = lnet_peer_ni_find_locked(nid);
-	LASSERT(lpni);
+	if (the_lnet.ln_state == LNET_STATE_RUNNING)
+		lpni = lnet_peer_ni_traffic_add(nid, pref);
 
-out_mutex_unlock:
 	mutex_unlock(&the_lnet.ln_api_mutex);
 	lnet_net_lock(cpt);
 
 	/* Lock has been dropped, check again for shutdown. */
 	if (the_lnet.ln_state != LNET_STATE_RUNNING) {
-		if (!IS_ERR(lpni))
+		if (!IS_ERR_OR_NULL(lpni))
 			lnet_peer_ni_decref_locked(lpni);
 		lpni = ERR_PTR(-ESHUTDOWN);
 	}
diff --git a/net/lnet/lnet/router.c b/net/lnet/lnet/router.c
index 60ae15d..b4f7aaa 100644
--- a/net/lnet/lnet/router.c
+++ b/net/lnet/lnet/router.c
@@ -702,7 +702,7 @@ static void lnet_shuffle_seed(void)
 	/* lnet_nid2peerni_ex() grabs a ref on the lpni. We will need to
 	 * lose that once we're done
 	 */
-	lpni = lnet_nid2peerni_ex(gateway, LNET_LOCK_EX);
+	lpni = lnet_nid2peerni_ex(gateway);
 	if (IS_ERR(lpni)) {
 		lnet_net_unlock(LNET_LOCK_EX);
 
@@ -716,7 +716,9 @@ static void lnet_shuffle_seed(void)
 		return rc;
 	}
 
-	LASSERT(lpni->lpni_peer_net && lpni->lpni_peer_net->lpn_peer);
+	LASSERT(lpni);
+	LASSERT(lpni->lpni_peer_net);
+	LASSERT(lpni->lpni_peer_net->lpn_peer);
 	gw = lpni->lpni_peer_net->lpn_peer;
 
 	route->lr_gateway = gw;
-- 
1.8.3.1

