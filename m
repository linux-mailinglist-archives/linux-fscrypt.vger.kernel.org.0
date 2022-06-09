Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B63F544C1D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245165AbiFIMdi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245355AbiFIMdg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:36 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB105186FB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:34 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 473E9EF7;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 3CCFBD4381; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 07/18] lnet: Change LNetDist to work with struct lnet_nid
Date:   Thu,  9 Jun 2022 08:33:03 -0400
Message-Id: <1654777994-29806-8-git-send-email-jsimmons@infradead.org>
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

LNetDist now takes and returns 'struct lnet_nid'
lustre_uuid_to_peer() is also updated.

The 'dst' and 'src' parameters to LNetDist are now both pointers, and
that can point to the same 'struct lnet_nid'.  Code needs to be
careful not to set *src until after the last use of *dst.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: c87f70acd86c59425 ("LU-10391 lnet: Change LNetDist to work with struct lnet_nid")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43618
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Amir Shehata <ashehata@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/obd_class.h    |  3 ++-
 fs/lustre/obdclass/lustre_peer.c |  4 ++--
 fs/lustre/ptlrpc/events.c        | 12 ++++++------
 include/linux/lnet/api.h         |  2 +-
 net/lnet/lnet/api-ni.c           |  4 +++-
 net/lnet/lnet/lib-move.c         | 35 ++++++++++++++++-------------------
 6 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/lustre/include/obd_class.h b/fs/lustre/include/obd_class.h
index 3f444b0..f603140 100644
--- a/fs/lustre/include/obd_class.h
+++ b/fs/lustre/include/obd_class.h
@@ -1688,7 +1688,8 @@ struct lwp_register_item {
 int lustre_check_exclusion(struct super_block *sb, char *svname);
 
 /* lustre_peer.c    */
-int lustre_uuid_to_peer(const char *uuid, lnet_nid_t *peer_nid, int index);
+int lustre_uuid_to_peer(const char *uuid, struct lnet_nid *peer_nid,
+			int index);
 int class_add_uuid(const char *uuid, u64 nid);
 int class_del_uuid(const char *uuid);
 int class_add_nids_to_uuid(struct obd_uuid *uuid, lnet_nid_t *nids,
diff --git a/fs/lustre/obdclass/lustre_peer.c b/fs/lustre/obdclass/lustre_peer.c
index f7e6a0f..5eae2eb 100644
--- a/fs/lustre/obdclass/lustre_peer.c
+++ b/fs/lustre/obdclass/lustre_peer.c
@@ -51,7 +51,7 @@ struct uuid_nid_data {
 static LIST_HEAD(g_uuid_list);
 static DEFINE_SPINLOCK(g_uuid_lock);
 
-int lustre_uuid_to_peer(const char *uuid, lnet_nid_t *peer_nid, int index)
+int lustre_uuid_to_peer(const char *uuid, struct lnet_nid *peer_nid, int index)
 {
 	struct uuid_nid_data *data;
 	struct obd_uuid tmp;
@@ -65,7 +65,7 @@ int lustre_uuid_to_peer(const char *uuid, lnet_nid_t *peer_nid, int index)
 				break;
 
 			rc = 0;
-			*peer_nid = data->un_nids[index];
+			lnet_nid4_to_nid(data->un_nids[index], peer_nid);
 			break;
 		}
 	}
diff --git a/fs/lustre/ptlrpc/events.c b/fs/lustre/ptlrpc/events.c
index 385a6f2..140ea85 100644
--- a/fs/lustre/ptlrpc/events.c
+++ b/fs/lustre/ptlrpc/events.c
@@ -476,18 +476,18 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
 	int rc = -ENOENT;
 	int dist;
 	u32 order;
-	lnet_nid_t dst_nid;
-	lnet_nid_t src_nid;
+	struct lnet_nid dst_nid;
+	struct lnet_nid src_nid;
 
 	peer->pid = LNET_PID_LUSTRE;
 
 	/* Choose the matching UUID that's closest */
 	while (lustre_uuid_to_peer(uuid->uuid, &dst_nid, count++) == 0) {
 		if (peer->nid != LNET_NID_ANY && LNET_NIDADDR(peer->nid) == 0 &&
-		    LNET_NIDNET(dst_nid) != LNET_NIDNET(peer->nid))
+		    LNET_NID_NET(&dst_nid) != LNET_NIDNET(peer->nid))
 			continue;
 
-		dist = LNetDist(dst_nid, &src_nid, &order);
+		dist = LNetDist(&dst_nid, &src_nid, &order);
 		if (dist < 0)
 			continue;
 
@@ -503,8 +503,8 @@ int ptlrpc_uuid_to_peer(struct obd_uuid *uuid,
 			best_dist = dist;
 			best_order = order;
 
-			peer->nid = dst_nid;
-			*self = src_nid;
+			peer->nid = lnet_nid_to_nid4(&dst_nid);
+			*self = lnet_nid_to_nid4(&src_nid);
 			rc = 0;
 		}
 	}
diff --git a/include/linux/lnet/api.h b/include/linux/lnet/api.h
index 447b41d..3657c13 100644
--- a/include/linux/lnet/api.h
+++ b/include/linux/lnet/api.h
@@ -76,7 +76,7 @@
  * @{
  */
 int LNetGetId(unsigned int index, struct lnet_processid *id);
-int LNetDist(lnet_nid_t nid, lnet_nid_t *srcnid, u32 *order);
+int LNetDist(struct lnet_nid *nid, struct lnet_nid *srcnid, u32 *order);
 void LNetPrimaryNID(struct lnet_nid *nid);
 
 /** @} lnet_addr */
diff --git a/net/lnet/lnet/api-ni.c b/net/lnet/lnet/api-ni.c
index 44d5014..c977b47 100644
--- a/net/lnet/lnet/api-ni.c
+++ b/net/lnet/lnet/api-ni.c
@@ -4261,10 +4261,12 @@ u32 lnet_get_dlc_seq_locked(void)
 	}
 
 	case IOC_LIBCFS_LNET_DIST:
-		rc = LNetDist(data->ioc_nid, &data->ioc_nid, &data->ioc_u32[1]);
+		lnet_nid4_to_nid(data->ioc_nid, &nid);
+		rc = LNetDist(&nid, &nid, &data->ioc_u32[1]);
 		if (rc < 0 && rc != -EHOSTUNREACH)
 			return rc;
 
+		data->ioc_nid = lnet_nid_to_nid4(&nid);
 		data->ioc_u32[0] = rc;
 		return 0;
 
diff --git a/net/lnet/lnet/lib-move.c b/net/lnet/lnet/lib-move.c
index 080bfe6..bca33bf 100644
--- a/net/lnet/lnet/lib-move.c
+++ b/net/lnet/lnet/lib-move.c
@@ -5072,55 +5072,51 @@ struct lnet_msg *
  *		-EHOSTUNREACH If @dstnid is not reachable.
  */
 int
-LNetDist(lnet_nid_t dstnid, lnet_nid_t *srcnidp, u32 *orderp)
+LNetDist(struct lnet_nid *dstnid, struct lnet_nid *srcnid, u32 *orderp)
 {
 	struct lnet_ni *ni = NULL;
 	struct lnet_remotenet *rnet;
-	u32 dstnet = LNET_NIDNET(dstnid);
+	u32 dstnet = LNET_NID_NET(dstnid);
 	int hops;
 	int cpt;
 	u32 order = 2;
 	struct list_head *rn_list;
-	bool matched_dstnet = false;
+	struct lnet_ni *matched_dstnet = NULL;
 
-	/*
-	 * if !local_nid_dist_zero, I don't return a distance of 0 ever
+	/* if !local_nid_dist_zero, I don't return a distance of 0 ever
 	 * (when lustre sees a distance of 0, it substitutes 0@lo), so I
 	 * keep order 0 free for 0@lo and order 1 free for a local NID
 	 * match
+	 * WARNING: dstnid and srcnid might point to same place.
+	 * Don't set *srcnid until late.
 	 */
 	LASSERT(the_lnet.ln_refcount > 0);
 
 	cpt = lnet_net_lock_current();
 
 	while ((ni = lnet_get_next_ni_locked(NULL, ni))) {
-		/* FIXME support large-addr nid */
-		if (lnet_nid_to_nid4(&ni->ni_nid) == dstnid) {
-			if (srcnidp)
-				*srcnidp = dstnid;
+		if (nid_same(&ni->ni_nid, dstnid)) {
 			if (orderp) {
-				if (dstnid == LNET_NID_LO_0)
+				if (nid_is_lo0(dstnid))
 					*orderp = 0;
 				else
 					*orderp = 1;
 			}
+			if (srcnid)
+				*srcnid = *dstnid;
 			lnet_net_unlock(cpt);
 
 			return local_nid_dist_zero ? 0 : 1;
 		}
 
 		if (!matched_dstnet && LNET_NID_NET(&ni->ni_nid) == dstnet) {
-			matched_dstnet = true;
+			matched_dstnet = ni;
 			/* We matched the destination net, but we may have
 			 * additional local NIs to inspect.
 			 *
-			 * We record the nid and order as appropriate, but
+			 * We record the order as appropriate, but
 			 * they may be overwritten if we match local NI above.
 			 */
-			if (srcnidp)
-				/* FIXME support large-addr nids */
-				*srcnidp = lnet_nid_to_nid4(&ni->ni_nid);
-
 			if (orderp) {
 				/* Check if ni was originally created in
 				 * current net namespace.
@@ -5140,6 +5136,8 @@ struct lnet_msg *
 	}
 
 	if (matched_dstnet) {
+		if (srcnid)
+			*srcnid = matched_dstnet->ni_nid;
 		lnet_net_unlock(cpt);
 		return 1;
 	}
@@ -5168,14 +5166,13 @@ struct lnet_msg *
 
 			LASSERT(shortest);
 			hops = shortest_hops;
-			if (srcnidp) {
+			if (srcnid) {
 				struct lnet_net *net;
 
 				net = lnet_get_net_locked(shortest->lr_lnet);
 				LASSERT(net);
 				ni = lnet_get_next_ni_locked(net, NULL);
-				/* FIXME support large-addr nids */
-				*srcnidp = lnet_nid_to_nid4(&ni->ni_nid);
+				*srcnid = ni->ni_nid;
 			}
 			if (orderp)
 				*orderp = order;
-- 
1.8.3.1

