Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1862544C19
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiFIMdh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245441AbiFIMdc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:32 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008F5192AB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:30 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 3ECD6EF4;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 36142D43AC; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 05/18] lnet: change LNetPrimaryNID to use struct lnet_nid
Date:   Thu,  9 Jun 2022 08:33:01 -0400
Message-Id: <1654777994-29806-6-git-send-email-jsimmons@infradead.org>
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

From: Mr NeilBrown <neilb@suse.de>

Rather than taking and returning a 4-byte-addr nid, LNetPrimaryNID now
takes a pointer to a struct lnet_nid, and updates it in-place.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: ac881498fa19e6b04 ("LU-10391 lnet: change LNetPrimaryNID to use struct lnet_nid")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43616
Reviewed-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Cyril Bordage <cbordage@whamcloud.com>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/connection.c |  2 +-
 include/linux/lnet/api.h      |  2 +-
 net/lnet/lnet/peer.c          | 21 +++++++++++----------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/lustre/ptlrpc/connection.c b/fs/lustre/ptlrpc/connection.c
index d1f53c6..58161fe 100644
--- a/fs/lustre/ptlrpc/connection.c
+++ b/fs/lustre/ptlrpc/connection.c
@@ -82,8 +82,8 @@ struct ptlrpc_connection *
 	struct ptlrpc_connection *conn, *conn2;
 	struct lnet_processid peer;
 
-	peer4.nid = LNetPrimaryNID(peer4.nid);
 	lnet_pid4_to_pid(peer4, &peer);
+	LNetPrimaryNID(&peer.nid);
 	conn = rhashtable_lookup_fast(&conn_hash, &peer, conn_hash_params);
 	if (conn) {
 		ptlrpc_connection_addref(conn);
diff --git a/include/linux/lnet/api.h b/include/linux/lnet/api.h
index 6d8e915..447b41d 100644
--- a/include/linux/lnet/api.h
+++ b/include/linux/lnet/api.h
@@ -77,7 +77,7 @@
  */
 int LNetGetId(unsigned int index, struct lnet_processid *id);
 int LNetDist(lnet_nid_t nid, lnet_nid_t *srcnid, u32 *order);
-lnet_nid_t LNetPrimaryNID(lnet_nid_t nid);
+void LNetPrimaryNID(struct lnet_nid *nid);
 
 /** @} lnet_addr */
 
diff --git a/net/lnet/lnet/peer.c b/net/lnet/lnet/peer.c
index 714326a..2055f31 100644
--- a/net/lnet/lnet/peer.c
+++ b/net/lnet/lnet/peer.c
@@ -1430,18 +1430,20 @@ struct lnet_peer_ni *
 }
 EXPORT_SYMBOL(LNetAddPeer);
 
-/* FIXME support large-addr nid */
-lnet_nid_t
-LNetPrimaryNID(lnet_nid_t nid)
+void LNetPrimaryNID(struct lnet_nid *nid)
 {
 	struct lnet_peer *lp;
 	struct lnet_peer_ni *lpni;
-	lnet_nid_t primary_nid = nid;
+	struct lnet_nid orig;
 	int rc = 0;
 	int cpt;
 
+	if (!nid || nid_is_lo0(nid))
+		return;
+	orig = *nid;
+
 	cpt = lnet_net_lock_current();
-	lpni = lnet_nid2peerni_locked(nid, LNET_NID_ANY, cpt);
+	lpni = lnet_peerni_by_nid_locked(nid, NULL, cpt);
 	if (IS_ERR(lpni)) {
 		rc = PTR_ERR(lpni);
 		goto out_unlock;
@@ -1468,7 +1470,7 @@ struct lnet_peer_ni *
 		 * and lookup the lpni again
 		 */
 		lnet_peer_ni_decref_locked(lpni);
-		lpni = lnet_find_peer_ni_locked(nid);
+		lpni = lnet_peer_ni_find_locked(nid);
 		if (!lpni) {
 			rc = -ENOENT;
 			goto out_unlock;
@@ -1483,15 +1485,14 @@ struct lnet_peer_ni *
 		if (lnet_is_discovery_disabled(lp))
 			break;
 	}
-	primary_nid = lnet_nid_to_nid4(&lp->lp_primary_nid);
+	*nid = lp->lp_primary_nid;
 out_decref:
 	lnet_peer_ni_decref_locked(lpni);
 out_unlock:
 	lnet_net_unlock(cpt);
 
-	CDEBUG(D_NET, "NID %s primary NID %s rc %d\n", libcfs_nid2str(nid),
-	       libcfs_nid2str(primary_nid), rc);
-	return primary_nid;
+	CDEBUG(D_NET, "NID %s primary NID %s rc %d\n", libcfs_nidstr(&orig),
+	       libcfs_nidstr(nid), rc);
 }
 EXPORT_SYMBOL(LNetPrimaryNID);
 
-- 
1.8.3.1

