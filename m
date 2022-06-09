Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132F2544C1E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245465AbiFIMds (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbiFIMdi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:38 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075F4186FB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:36 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 46CD1EF6;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 3FF05D438A; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 08/18] lnet: convert LNetPut to take 16byte nid and pid.
Date:   Thu,  9 Jun 2022 08:33:04 -0400
Message-Id: <1654777994-29806-9-git-send-email-jsimmons@infradead.org>
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

LNetPut() now takes a 16byte nid for self and similar process_id for
target.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: 50f6bb62987c54ea9 ("LU-10391 lnet: convert LNetPut to take 16byte nid and pid.")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43619
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Amir Shehata <ashehata@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/niobuf.c | 15 ++++++++++-----
 include/linux/lnet/api.h  |  4 ++--
 net/lnet/lnet/lib-move.c  | 28 +++++++++++-----------------
 net/lnet/lnet/peer.c      | 10 +++++-----
 net/lnet/selftest/rpc.c   | 17 +++++++++++------
 5 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/lustre/ptlrpc/niobuf.c b/fs/lustre/ptlrpc/niobuf.c
index afe83ad..94a0329 100644
--- a/fs/lustre/ptlrpc/niobuf.c
+++ b/fs/lustre/ptlrpc/niobuf.c
@@ -46,15 +46,20 @@
  */
 static int ptl_send_buf(struct lnet_handle_md *mdh, void *base, int len,
 			enum lnet_ack_req ack, struct ptlrpc_cb_id *cbid,
-			lnet_nid_t self, struct lnet_process_id peer_id,
+			lnet_nid_t self4, struct lnet_process_id peer_id4,
 			int portal, u64 xid, unsigned int offset,
 			struct lnet_handle_md *bulk_cookie)
 {
 	int rc;
 	struct lnet_md md;
+	struct lnet_nid self;
+	struct lnet_processid peer_id;
+
+	lnet_nid4_to_nid(self4, &self);
+	lnet_pid4_to_pid(peer_id4, &peer_id);
 
 	LASSERT(portal != 0);
-	CDEBUG(D_INFO, "peer_id %s\n", libcfs_id2str(peer_id));
+	CDEBUG(D_INFO, "peer_id %s\n", libcfs_id2str(peer_id4));
 	md.start = base;
 	md.length = len;
 	md.threshold = (ack == LNET_ACK_REQ) ? 2 : 1;
@@ -85,8 +90,8 @@ static int ptl_send_buf(struct lnet_handle_md *mdh, void *base, int len,
 
 	percpu_ref_get(&ptlrpc_pending);
 
-	rc = LNetPut(self, *mdh, ack,
-		     peer_id, portal, xid, offset, 0);
+	rc = LNetPut(&self, *mdh, ack,
+		     &peer_id, portal, xid, offset, 0);
 	if (unlikely(rc != 0)) {
 		int rc2;
 		/* We're going to get an UNLINK event when I unlink below,
@@ -94,7 +99,7 @@ static int ptl_send_buf(struct lnet_handle_md *mdh, void *base, int len,
 		 * I fall through and return success here!
 		 */
 		CERROR("LNetPut(%s, %d, %lld) failed: %d\n",
-		       libcfs_id2str(peer_id), portal, xid, rc);
+		       libcfs_id2str(peer_id4), portal, xid, rc);
 		rc2 = LNetMDUnlink(*mdh);
 		LASSERTF(rc2 == 0, "rc2 = %d\n", rc2);
 	}
diff --git a/include/linux/lnet/api.h b/include/linux/lnet/api.h
index 3657c13..514cbe7 100644
--- a/include/linux/lnet/api.h
+++ b/include/linux/lnet/api.h
@@ -137,10 +137,10 @@ int LNetMDBind(const struct lnet_md *md_in,
  * and LNetGet().
  * @{
  */
-int LNetPut(lnet_nid_t self,
+int LNetPut(struct lnet_nid *self,
 	    struct lnet_handle_md md_in,
 	    enum lnet_ack_req ack_req_in,
-	    struct lnet_process_id target_in,
+	    struct lnet_processid *target_in,
 	    unsigned int portal_in,
 	    u64 match_bits_in,
 	    unsigned int offset_in,
diff --git a/net/lnet/lnet/lib-move.c b/net/lnet/lnet/lib-move.c
index bca33bf..55a001e 100644
--- a/net/lnet/lnet/lib-move.c
+++ b/net/lnet/lnet/lib-move.c
@@ -4707,36 +4707,30 @@ void lnet_monitor_thr_stop(void)
  * \see lnet_event::hdr_data and lnet_event_kind.
  */
 int
-LNetPut(lnet_nid_t self4, struct lnet_handle_md mdh, enum lnet_ack_req ack,
-	struct lnet_process_id target4, unsigned int portal,
+LNetPut(struct lnet_nid *self, struct lnet_handle_md mdh, enum lnet_ack_req ack,
+	struct lnet_processid *target, unsigned int portal,
 	u64 match_bits, unsigned int offset,
 	u64 hdr_data)
 {
 	struct lnet_rsp_tracker *rspt = NULL;
-	struct lnet_processid target;
 	struct lnet_msg *msg;
 	struct lnet_libmd *md;
-	struct lnet_nid self;
 	int cpt;
 	int rc;
 
 	LASSERT(the_lnet.ln_refcount > 0);
 
-	lnet_nid4_to_nid(self4, &self);
-	lnet_nid4_to_nid(target4.nid, &target.nid);
-	target.pid = target4.pid;
-
 	if (!list_empty(&the_lnet.ln_test_peers) &&	/* normally we don't */
-	    fail_peer(&target.nid, 1)) {		/* shall we now? */
+	    fail_peer(&target->nid, 1)) {		/* shall we now? */
 		CERROR("Dropping PUT to %s: simulated failure\n",
-		       libcfs_id2str(target4));
+		       libcfs_idstr(target));
 		return -EIO;
 	}
 
 	msg = kmem_cache_zalloc(lnet_msg_cachep, GFP_NOFS);
 	if (!msg) {
 		CERROR("Dropping PUT to %s: ENOMEM on struct lnet_msg\n",
-		       libcfs_id2str(target4));
+		       libcfs_idstr(target));
 		return -ENOMEM;
 	}
 	msg->msg_vmflush = !!(current->flags & PF_MEMALLOC);
@@ -4747,7 +4741,7 @@ void lnet_monitor_thr_stop(void)
 		rspt = lnet_rspt_alloc(cpt);
 		if (!rspt) {
 			CERROR("Dropping PUT to %s: ENOMEM on response tracker\n",
-			       libcfs_id2str(target4));
+			       libcfs_idstr(target));
 			return -ENOMEM;
 		}
 		INIT_LIST_HEAD(&rspt->rspt_on_list);
@@ -4758,7 +4752,7 @@ void lnet_monitor_thr_stop(void)
 	md = lnet_handle2md(&mdh);
 	if (!md || !md->md_threshold || md->md_me) {
 		CERROR("Dropping PUT (%llu:%d:%s): MD (%d) invalid\n",
-		       match_bits, portal, libcfs_id2str(target4),
+		       match_bits, portal, libcfs_idstr(target),
 		       !md ? -1 : md->md_threshold);
 		if (md && md->md_me)
 			CERROR("Source MD also attached to portal %d\n",
@@ -4772,11 +4766,11 @@ void lnet_monitor_thr_stop(void)
 		return -ENOENT;
 	}
 
-	CDEBUG(D_NET, "%s -> %s\n", __func__, libcfs_id2str(target4));
+	CDEBUG(D_NET, "%s -> %s\n", __func__, libcfs_idstr(target));
 
 	lnet_msg_attach_md(msg, md, 0, 0);
 
-	lnet_prep_send(msg, LNET_MSG_PUT, &target, 0, md->md_length);
+	lnet_prep_send(msg, LNET_MSG_PUT, target, 0, md->md_length);
 
 	msg->msg_hdr.msg.put.match_bits = cpu_to_le64(match_bits);
 	msg->msg_hdr.msg.put.ptl_index = cpu_to_le32(portal);
@@ -4810,10 +4804,10 @@ void lnet_monitor_thr_stop(void)
 				 CFS_FAIL_ONCE))
 		rc = -EIO;
 	else
-		rc = lnet_send(&self, msg, NULL);
+		rc = lnet_send(self, msg, NULL);
 	if (rc) {
 		CNETERR("Error sending PUT to %s: %d\n",
-			libcfs_id2str(target4), rc);
+			libcfs_idstr(target), rc);
 		msg->msg_no_resend = true;
 		lnet_finalize(msg, rc);
 	}
diff --git a/net/lnet/lnet/peer.c b/net/lnet/lnet/peer.c
index 2055f31..6c35901 100644
--- a/net/lnet/lnet/peer.c
+++ b/net/lnet/lnet/peer.c
@@ -3559,7 +3559,7 @@ static int lnet_peer_send_push(struct lnet_peer *lp)
 __must_hold(&lp->lp_lock)
 {
 	struct lnet_ping_buffer *pbuf;
-	struct lnet_process_id id;
+	struct lnet_processid id;
 	struct lnet_md md;
 	int cpt;
 	int rc;
@@ -3606,13 +3606,13 @@ static int lnet_peer_send_push(struct lnet_peer *lp)
 	lnet_peer_addref_locked(lp);
 	id.pid = LNET_PID_LUSTRE;
 	if (!LNET_NID_IS_ANY(&lp->lp_disc_dst_nid))
-		id.nid = lnet_nid_to_nid4(&lp->lp_disc_dst_nid);
+		id.nid = lp->lp_disc_dst_nid;
 	else
-		id.nid = lnet_nid_to_nid4(&lp->lp_primary_nid);
+		id.nid = lp->lp_primary_nid;
 	lnet_net_unlock(cpt);
 
-	rc = LNetPut(lnet_nid_to_nid4(&lp->lp_disc_src_nid), lp->lp_push_mdh,
-		     LNET_ACK_REQ, id, LNET_RESERVED_PORTAL,
+	rc = LNetPut(&lp->lp_disc_src_nid, lp->lp_push_mdh,
+		     LNET_ACK_REQ, &id, LNET_RESERVED_PORTAL,
 		     LNET_PROTO_PING_MATCHBITS, 0, 0);
 	/* reset the discovery nid. There is no need to restrict sending
 	 * from that source, if we call lnet_push_update_to_peers(). It'll
diff --git a/net/lnet/selftest/rpc.c b/net/lnet/selftest/rpc.c
index d1538be..b16711a 100644
--- a/net/lnet/selftest/rpc.c
+++ b/net/lnet/selftest/rpc.c
@@ -397,12 +397,17 @@ struct srpc_bulk *
 
 static int
 srpc_post_active_rdma(int portal, u64 matchbits, void *buf, int len,
-		      int options, struct lnet_process_id peer,
-		      lnet_nid_t self, struct lnet_handle_md *mdh,
+		      int options, struct lnet_process_id peer4,
+		      lnet_nid_t self4, struct lnet_handle_md *mdh,
 		      struct srpc_event *ev)
 {
 	int rc;
 	struct lnet_md md;
+	struct lnet_nid self;
+	struct lnet_processid peer;
+
+	lnet_nid4_to_nid(self4, &self);
+	lnet_pid4_to_pid(peer4, &peer);
 
 	md.user_ptr = ev;
 	md.start = buf;
@@ -424,18 +429,18 @@ struct srpc_bulk *
 	 * buffers...
 	 */
 	if (options & LNET_MD_OP_PUT) {
-		rc = LNetPut(self, *mdh, LNET_NOACK_REQ, peer,
+		rc = LNetPut(&self, *mdh, LNET_NOACK_REQ, &peer,
 			     portal, matchbits, 0, 0);
 	} else {
 		LASSERT(options & LNET_MD_OP_GET);
 
-		rc = LNetGet(self, *mdh, peer, portal, matchbits, 0, false);
+		rc = LNetGet(self4, *mdh, peer4, portal, matchbits, 0, false);
 	}
 
 	if (rc) {
 		CERROR("LNet%s(%s, %d, %lld) failed: %d\n",
 		       options & LNET_MD_OP_PUT ? "Put" : "Get",
-		       libcfs_id2str(peer), portal, matchbits, rc);
+		       libcfs_id2str(peer4), portal, matchbits, rc);
 
 		/*
 		 * The forthcoming unlink event will complete this operation
@@ -446,7 +451,7 @@ struct srpc_bulk *
 	} else {
 		CDEBUG(D_NET,
 		       "Posted active RDMA: peer %s, portal %u, matchbits %#llx\n",
-		       libcfs_id2str(peer), portal, matchbits);
+		       libcfs_id2str(peer4), portal, matchbits);
 	}
 	return 0;
 }
-- 
1.8.3.1

