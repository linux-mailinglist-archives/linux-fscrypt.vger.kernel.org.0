Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C128544C25
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235883AbiFIMeC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245500AbiFIMdu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:50 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2E922B28
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:45 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 4F0DCEFB;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 4C91ED43A3; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 12/18] lnet: socklnd: switch ksocknal_del_peer to lnet_processid
Date:   Thu,  9 Jun 2022 08:33:08 -0400
Message-Id: <1654777994-29806-13-git-send-email-jsimmons@infradead.org>
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

ksocknal_del_peer now takes a pointer to a lnet_processid,
with room for a large address.
A NULL means "ANY NID, AND PID".
The "ip" argument was completely unused, so has been removed.

This was the last use of 'struct lnet_process_id' in ksocklnd.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: 782e37e54f5c54886 ("LU-10391 socklnd: switch ksocknal_del_peer to lnet_processid")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/44623
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/klnds/socklnd/socklnd.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/net/lnet/klnds/socklnd/socklnd.c b/net/lnet/klnds/socklnd/socklnd.c
index 857aa05..01b434f 100644
--- a/net/lnet/klnds/socklnd/socklnd.c
+++ b/net/lnet/klnds/socklnd/socklnd.c
@@ -660,7 +660,7 @@ struct ksock_peer_ni *
 }
 
 static void
-ksocknal_del_peer_locked(struct ksock_peer_ni *peer_ni, u32 ip)
+ksocknal_del_peer_locked(struct ksock_peer_ni *peer_ni)
 {
 	struct ksock_conn *conn;
 	struct ksock_conn *cnxt;
@@ -683,7 +683,7 @@ struct ksock_peer_ni *
 }
 
 static int
-ksocknal_del_peer(struct lnet_ni *ni, struct lnet_process_id id4, u32 ip)
+ksocknal_del_peer(struct lnet_ni *ni, struct lnet_processid *id)
 {
 	LIST_HEAD(zombies);
 	struct hlist_node *pnxt;
@@ -692,15 +692,11 @@ struct ksock_peer_ni *
 	int hi;
 	int i;
 	int rc = -ENOENT;
-	struct lnet_processid id;
-
-	id.pid = id4.pid;
-	lnet_nid4_to_nid(id4.nid, &id.nid);
 
 	write_lock_bh(&ksocknal_data.ksnd_global_lock);
 
-	if (!LNET_NID_IS_ANY(&id.nid)) {
-		lo = hash_min(nidhash(&id.nid),
+	if (id && !LNET_NID_IS_ANY(&id->nid)) {
+		lo = hash_min(nidhash(&id->nid),
 			      HASH_BITS(ksocknal_data.ksnd_peers));
 		hi = lo;
 	} else {
@@ -715,15 +711,15 @@ struct ksock_peer_ni *
 			if (peer_ni->ksnp_ni != ni)
 				continue;
 
-			if (!((LNET_NID_IS_ANY(&id.nid) ||
-			       nid_same(&peer_ni->ksnp_id.nid, &id.nid)) &&
-			      (id.pid == LNET_PID_ANY ||
-			       peer_ni->ksnp_id.pid == id.pid)))
+			if (!((!id || LNET_NID_IS_ANY(&id->nid) ||
+			       nid_same(&peer_ni->ksnp_id.nid, &id->nid)) &&
+			      (!id || id->pid == LNET_PID_ANY ||
+			       peer_ni->ksnp_id.pid == id->pid)))
 				continue;
 
 			ksocknal_peer_addref(peer_ni);     /* a ref for me... */
 
-			ksocknal_del_peer_locked(peer_ni, ip);
+			ksocknal_del_peer_locked(peer_ni);
 
 			if (peer_ni->ksnp_closing &&
 			    !list_empty(&peer_ni->ksnp_tx_queue)) {
@@ -1764,7 +1760,6 @@ static int ksocknal_push(struct lnet_ni *ni, struct lnet_processid *id)
 int
 ksocknal_ctl(struct lnet_ni *ni, unsigned int cmd, void *arg)
 {
-	struct lnet_process_id id4 = {};
 	struct lnet_processid id = {};
 	struct libcfs_ioctl_data *data = arg;
 	int rc;
@@ -1832,10 +1827,9 @@ static int ksocknal_push(struct lnet_ni *ni, struct lnet_processid *id)
 		return ksocknal_add_peer(ni, &id, (struct sockaddr *)&sa);
 	}
 	case IOC_LIBCFS_DEL_PEER:
-		id4.nid = data->ioc_nid;
-		id4.pid = LNET_PID_ANY;
-		return ksocknal_del_peer(ni, id4,
-					 data->ioc_u32[0]); /* IP */
+		lnet_nid4_to_nid(data->ioc_nid, &id.nid);
+		id.pid = LNET_PID_ANY;
+		return ksocknal_del_peer(ni, &id);
 
 	case IOC_LIBCFS_GET_CONN: {
 		int txmem;
@@ -2347,10 +2341,6 @@ static int ksocknal_inetaddr_event(struct notifier_block *unused,
 ksocknal_shutdown(struct lnet_ni *ni)
 {
 	struct ksock_net *net = ni->ni_data;
-	struct lnet_process_id anyid = { 0 };
-
-	anyid.nid = LNET_NID_ANY;
-	anyid.pid = LNET_PID_ANY;
 
 	LASSERT(ksocknal_data.ksnd_init == SOCKNAL_INIT_ALL);
 	LASSERT(ksocknal_data.ksnd_nnets > 0);
@@ -2359,7 +2349,7 @@ static int ksocknal_inetaddr_event(struct notifier_block *unused,
 	atomic_add(SOCKNAL_SHUTDOWN_BIAS, &net->ksnn_npeers);
 
 	/* Delete all peers */
-	ksocknal_del_peer(ni, anyid, 0);
+	ksocknal_del_peer(ni, NULL);
 
 	/* Wait for all peer_ni state to clean up */
 	wait_var_event_warning(&net->ksnn_npeers,
-- 
1.8.3.1

