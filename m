Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2B6544C22
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245448AbiFIMdu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245424AbiFIMdk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:40 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4106321E38
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:38 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 49E9AEF8;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 43316D4404; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 09/18] lnet: change LNetGet to take 16byte nid and pid.
Date:   Thu,  9 Jun 2022 08:33:05 -0400
Message-Id: <1654777994-29806-10-git-send-email-jsimmons@infradead.org>
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

"self" is now passed to LNetGet as a pointer to a 16-byte-addr nid, or
NULL for "ANY".  "target" is passed as a 16-bytes-addr process_id.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: d727ec56b26cbd1b8 ("LU-10391 lnet: change LNetGet to take 16byte nid and pid.")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43620
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/lnet/api.h |  4 ++--
 net/lnet/lnet/api-ni.c   | 25 +++++++++++++------------
 net/lnet/lnet/lib-move.c | 34 ++++++++++++++--------------------
 net/lnet/selftest/rpc.c  |  2 +-
 4 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/include/linux/lnet/api.h b/include/linux/lnet/api.h
index 514cbe7..7ea61cb 100644
--- a/include/linux/lnet/api.h
+++ b/include/linux/lnet/api.h
@@ -146,9 +146,9 @@ int LNetPut(struct lnet_nid *self,
 	    unsigned int offset_in,
 	    u64	hdr_data_in);
 
-int LNetGet(lnet_nid_t self,
+int LNetGet(struct lnet_nid *self,
 	    struct lnet_handle_md md_in,
-	    struct lnet_process_id target_in,
+	    struct lnet_processid *target_in,
 	    unsigned int portal_in,
 	    u64	match_bits_in,
 	    unsigned int offset_in,
diff --git a/net/lnet/lnet/api-ni.c b/net/lnet/lnet/api-ni.c
index c977b47..8643ac8d 100644
--- a/net/lnet/lnet/api-ni.c
+++ b/net/lnet/lnet/api-ni.c
@@ -205,7 +205,7 @@ static void lnet_set_lnd_timeout(void)
  */
 static atomic_t lnet_dlc_seq_no = ATOMIC_INIT(0);
 
-static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
+static int lnet_ping(struct lnet_process_id id4, struct lnet_nid *src_nid,
 		     signed long timeout, struct lnet_process_id __user *ids,
 		     int n_ids);
 
@@ -4562,7 +4562,7 @@ struct ping_data {
 		complete(&pd->completion);
 }
 
-static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
+static int lnet_ping(struct lnet_process_id id4, struct lnet_nid *src_nid,
 		     signed long timeout, struct lnet_process_id __user *ids,
 		     int n_ids)
 {
@@ -4570,13 +4570,14 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 	struct ping_data pd = { 0 };
 	struct lnet_ping_buffer *pbuf;
 	struct lnet_process_id tmpid;
+	struct lnet_processid id;
 	int i;
 	int nob;
 	int rc;
 	int rc2;
 
 	/* n_ids limit is arbitrary */
-	if (n_ids <= 0 || id.nid == LNET_NID_ANY)
+	if (n_ids <= 0 || id4.nid == LNET_NID_ANY)
 		return -EINVAL;
 
 	/* if the user buffer has more space than the lnet_interfaces_max
@@ -4585,8 +4586,8 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 	if (n_ids > lnet_interfaces_max)
 		n_ids = lnet_interfaces_max;
 
-	if (id.pid == LNET_PID_ANY)
-		id.pid = LNET_PID_LUSTRE;
+	if (id4.pid == LNET_PID_ANY)
+		id4.pid = LNET_PID_LUSTRE;
 
 	pbuf = lnet_ping_buffer_alloc(n_ids, GFP_NOFS);
 	if (!pbuf)
@@ -4609,8 +4610,8 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 		goto fail_ping_buffer_decref;
 	}
 
-	rc = LNetGet(lnet_nid_to_nid4(src_nid), pd.mdh, id,
-		     LNET_RESERVED_PORTAL,
+	lnet_pid4_to_pid(id4, &id);
+	rc = LNetGet(src_nid, pd.mdh, &id, LNET_RESERVED_PORTAL,
 		     LNET_PROTO_PING_MATCHBITS, 0, false);
 	if (rc) {
 		/* Don't CERROR; this could be deliberate! */
@@ -4637,7 +4638,7 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 
 	if (nob < 8) {
 		CERROR("%s: ping info too short %d\n",
-		       libcfs_id2str(id), nob);
+		       libcfs_id2str(id4), nob);
 		goto fail_ping_buffer_decref;
 	}
 
@@ -4645,19 +4646,19 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 		lnet_swap_pinginfo(pbuf);
 	} else if (pbuf->pb_info.pi_magic != LNET_PROTO_PING_MAGIC) {
 		CERROR("%s: Unexpected magic %08x\n",
-		       libcfs_id2str(id), pbuf->pb_info.pi_magic);
+		       libcfs_id2str(id4), pbuf->pb_info.pi_magic);
 		goto fail_ping_buffer_decref;
 	}
 
 	if (!(pbuf->pb_info.pi_features & LNET_PING_FEAT_NI_STATUS)) {
 		CERROR("%s: ping w/o NI status: 0x%x\n",
-		       libcfs_id2str(id), pbuf->pb_info.pi_features);
+		       libcfs_id2str(id4), pbuf->pb_info.pi_features);
 		goto fail_ping_buffer_decref;
 	}
 
 	if (nob < LNET_PING_INFO_SIZE(0)) {
 		CERROR("%s: Short reply %d(%d min)\n",
-		       libcfs_id2str(id),
+		       libcfs_id2str(id4),
 		       nob, (int)LNET_PING_INFO_SIZE(0));
 		goto fail_ping_buffer_decref;
 	}
@@ -4667,7 +4668,7 @@ static int lnet_ping(struct lnet_process_id id, struct lnet_nid *src_nid,
 
 	if (nob < LNET_PING_INFO_SIZE(n_ids)) {
 		CERROR("%s: Short reply %d(%d expected)\n",
-		       libcfs_id2str(id),
+		       libcfs_id2str(id4),
 		       nob, (int)LNET_PING_INFO_SIZE(n_ids));
 		goto fail_ping_buffer_decref;
 	}
diff --git a/net/lnet/lnet/lib-move.c b/net/lnet/lnet/lib-move.c
index 55a001e..9ee1075 100644
--- a/net/lnet/lnet/lib-move.c
+++ b/net/lnet/lnet/lib-move.c
@@ -3630,7 +3630,7 @@ struct lnet_mt_event_info {
 	       void *user_data, lnet_handler_t handler, bool recovery)
 {
 	struct lnet_md md = { NULL };
-	struct lnet_process_id id;
+	struct lnet_processid id;
 	struct lnet_ping_buffer *pbuf;
 	int rc;
 
@@ -3662,9 +3662,9 @@ struct lnet_mt_event_info {
 		goto fail_error;
 	}
 	id.pid = LNET_PID_LUSTRE;
-	id.nid = lnet_nid_to_nid4(dest_nid);
+	id.nid = *dest_nid;
 
-	rc = LNetGet(LNET_NID_ANY, *mdh, id,
+	rc = LNetGet(NULL, *mdh, &id,
 		     LNET_RESERVED_PORTAL,
 		     LNET_PROTO_PING_MATCHBITS, 0, recovery);
 	if (rc)
@@ -4948,35 +4948,29 @@ struct lnet_msg *
  *		-ENOENT Invalid MD object.
  */
 int
-LNetGet(lnet_nid_t self4, struct lnet_handle_md mdh,
-	struct lnet_process_id target4, unsigned int portal,
+LNetGet(struct lnet_nid *self, struct lnet_handle_md mdh,
+	struct lnet_processid *target, unsigned int portal,
 	u64 match_bits, unsigned int offset, bool recovery)
 {
 	struct lnet_rsp_tracker *rspt;
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
 		CERROR("Dropping GET to %s: simulated failure\n",
-		       libcfs_id2str(target4));
+		       libcfs_idstr(target));
 		return -EIO;
 	}
 
 	msg = kmem_cache_zalloc(lnet_msg_cachep, GFP_NOFS);
 	if (!msg) {
 		CERROR("Dropping GET to %s: ENOMEM on struct lnet_msg\n",
-		       libcfs_id2str(target4));
+		       libcfs_idstr(target));
 		return -ENOMEM;
 	}
 
@@ -4985,7 +4979,7 @@ struct lnet_msg *
 	rspt = lnet_rspt_alloc(cpt);
 	if (!rspt) {
 		CERROR("Dropping GET to %s: ENOMEM on response tracker\n",
-		       libcfs_id2str(target4));
+		       libcfs_idstr(target));
 		return -ENOMEM;
 	}
 	INIT_LIST_HEAD(&rspt->rspt_on_list);
@@ -4997,7 +4991,7 @@ struct lnet_msg *
 	md = lnet_handle2md(&mdh);
 	if (!md || !md->md_threshold || md->md_me) {
 		CERROR("Dropping GET (%llu:%d:%s): MD (%d) invalid\n",
-		       match_bits, portal, libcfs_id2str(target4),
+		       match_bits, portal, libcfs_idstr(target),
 		       !md ? -1 : md->md_threshold);
 		if (md && md->md_me)
 			CERROR("REPLY MD also attached to portal %d\n",
@@ -5010,11 +5004,11 @@ struct lnet_msg *
 		return -ENOENT;
 	}
 
-	CDEBUG(D_NET, "%s -> %s\n", __func__, libcfs_id2str(target4));
+	CDEBUG(D_NET, "%s -> %s\n", __func__, libcfs_idstr(target));
 
 	lnet_msg_attach_md(msg, md, 0, 0);
 
-	lnet_prep_send(msg, LNET_MSG_GET, &target, 0, 0);
+	lnet_prep_send(msg, LNET_MSG_GET, target, 0, 0);
 
 	msg->msg_hdr.msg.get.match_bits = cpu_to_le64(match_bits);
 	msg->msg_hdr.msg.get.ptl_index = cpu_to_le32(portal);
@@ -5036,10 +5030,10 @@ struct lnet_msg *
 	else
 		lnet_rspt_free(rspt, cpt);
 
-	rc = lnet_send(&self, msg, NULL);
+	rc = lnet_send(self, msg, NULL);
 	if (rc < 0) {
 		CNETERR("Error sending GET to %s: %d\n",
-			libcfs_id2str(target4), rc);
+			libcfs_idstr(target), rc);
 		msg->msg_no_resend = true;
 		lnet_finalize(msg, rc);
 	}
diff --git a/net/lnet/selftest/rpc.c b/net/lnet/selftest/rpc.c
index b16711a..17277b8 100644
--- a/net/lnet/selftest/rpc.c
+++ b/net/lnet/selftest/rpc.c
@@ -434,7 +434,7 @@ struct srpc_bulk *
 	} else {
 		LASSERT(options & LNET_MD_OP_GET);
 
-		rc = LNetGet(self4, *mdh, peer4, portal, matchbits, 0, false);
+		rc = LNetGet(&self, *mdh, &peer, portal, matchbits, 0, false);
 	}
 
 	if (rc) {
-- 
1.8.3.1

