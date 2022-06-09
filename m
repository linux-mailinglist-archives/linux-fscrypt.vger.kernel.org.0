Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECB4544C21
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245510AbiFIMdu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245448AbiFIMds (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:48 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C993F220F6
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:41 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 4AC73EF9;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 46891D439B; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 10/18] lnet: socklnd: pass large processid to ksocknal_add_peer
Date:   Thu,  9 Jun 2022 08:33:06 -0400
Message-Id: <1654777994-29806-11-git-send-email-jsimmons@infradead.org>
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

Teach ksocknal_add_peer() to handle large-address processid, and now
ksocknal_launch_packet() can support IPv6 addresses as well as IPv4.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: 6deddc3d46704643d ("LU-10391 socklnd: pass large processid to ksocknal_add_peer")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/44621
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/klnds/socklnd/socklnd.c    | 22 +++++++++-------------
 net/lnet/klnds/socklnd/socklnd.h    |  2 +-
 net/lnet/klnds/socklnd/socklnd_cb.c | 28 ++++++++++++++++++----------
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/net/lnet/klnds/socklnd/socklnd.c b/net/lnet/klnds/socklnd/socklnd.c
index 4267832..2b6fa18 100644
--- a/net/lnet/klnds/socklnd/socklnd.c
+++ b/net/lnet/klnds/socklnd/socklnd.c
@@ -611,23 +611,19 @@ struct ksock_peer_ni *
 }
 
 int
-ksocknal_add_peer(struct lnet_ni *ni, struct lnet_process_id id4,
+ksocknal_add_peer(struct lnet_ni *ni, struct lnet_processid *id,
 		  struct sockaddr *addr)
 {
 	struct ksock_peer_ni *peer_ni;
 	struct ksock_peer_ni *peer2;
 	struct ksock_conn_cb *conn_cb;
-	struct lnet_processid id;
 
-	if (id4.nid == LNET_NID_ANY ||
-	    id4.pid == LNET_PID_ANY)
+	if (LNET_NID_IS_ANY(&id->nid) ||
+	    id->pid == LNET_PID_ANY)
 		return -EINVAL;
 
-	id.pid = id4.pid;
-	lnet_nid4_to_nid(id4.nid, &id.nid);
-
 	/* Have a brand new peer_ni ready... */
-	peer_ni = ksocknal_create_peer(ni, &id);
+	peer_ni = ksocknal_create_peer(ni, id);
 	if (IS_ERR(peer_ni))
 		return PTR_ERR(peer_ni);
 
@@ -642,14 +638,14 @@ struct ksock_peer_ni *
 	/* always called with a ref on ni, so shutdown can't have started */
 	LASSERT(atomic_read(&((struct ksock_net *)ni->ni_data)->ksnn_npeers) >= 0);
 
-	peer2 = ksocknal_find_peer_locked(ni, &id);
+	peer2 = ksocknal_find_peer_locked(ni, id);
 	if (peer2) {
 		ksocknal_peer_decref(peer_ni);
 		peer_ni = peer2;
 	} else {
 		/* peer_ni table takes my ref on peer_ni */
 		hash_add(ksocknal_data.ksnd_peers, &peer_ni->ksnp_list,
-			 nidhash(&id.nid));
+			 nidhash(&id->nid));
 	}
 
 	ksocknal_add_conn_cb_locked(peer_ni, conn_cb);
@@ -1830,11 +1826,11 @@ static int ksocknal_push(struct lnet_ni *ni, struct lnet_processid *id)
 	case IOC_LIBCFS_ADD_PEER: {
 		struct sockaddr_in sa = {.sin_family = AF_INET};
 
-		id4.nid = data->ioc_nid;
-		id4.pid = LNET_PID_LUSTRE;
+		id.pid = LNET_PID_LUSTRE;
+		lnet_nid4_to_nid(data->ioc_nid, &id.nid);
 		sa.sin_addr.s_addr = htonl(data->ioc_u32[0]);
 		sa.sin_port = htons(data->ioc_u32[1]);
-		return ksocknal_add_peer(ni, id4, (struct sockaddr *)&sa);
+		return ksocknal_add_peer(ni, &id, (struct sockaddr *)&sa);
 	}
 	case IOC_LIBCFS_DEL_PEER:
 		id4.nid = data->ioc_nid;
diff --git a/net/lnet/klnds/socklnd/socklnd.h b/net/lnet/klnds/socklnd/socklnd.h
index 13abe20..93368bd 100644
--- a/net/lnet/klnds/socklnd/socklnd.h
+++ b/net/lnet/klnds/socklnd/socklnd.h
@@ -627,7 +627,7 @@ int ksocknal_recv(struct lnet_ni *ni, void *private, struct lnet_msg *lntmsg,
 		  int delayed, struct iov_iter *to, unsigned int rlen);
 int ksocknal_accept(struct lnet_ni *ni, struct socket *sock);
 
-int ksocknal_add_peer(struct lnet_ni *ni, struct lnet_process_id id,
+int ksocknal_add_peer(struct lnet_ni *ni, struct lnet_processid *id,
 		      struct sockaddr *addr);
 struct ksock_peer_ni *ksocknal_find_peer_locked(struct lnet_ni *ni,
 						struct lnet_processid *id);
diff --git a/net/lnet/klnds/socklnd/socklnd_cb.c b/net/lnet/klnds/socklnd/socklnd_cb.c
index adec183..94600f3 100644
--- a/net/lnet/klnds/socklnd/socklnd_cb.c
+++ b/net/lnet/klnds/socklnd/socklnd_cb.c
@@ -808,7 +808,7 @@ struct ksock_conn_cb *
 {
 	struct ksock_peer_ni *peer_ni;
 	struct ksock_conn *conn;
-	struct sockaddr_in sa;
+	struct sockaddr_storage sa;
 	rwlock_t *g_lock;
 	int retry;
 	int rc;
@@ -859,16 +859,24 @@ struct ksock_conn_cb *
 		}
 
 		memset(&sa, 0, sizeof(sa));
-		sa.sin_family = AF_INET;
-		sa.sin_addr.s_addr = id->nid.nid_addr[0];
-		sa.sin_port = htons(lnet_acceptor_port());
-		{
-			struct lnet_process_id id4 = {
-				.pid = id->pid,
-				.nid = lnet_nid_to_nid4(&id->nid),
-			};
-			rc = ksocknal_add_peer(ni, id4, (struct sockaddr *)&sa);
+		switch (NID_ADDR_BYTES(&id->nid)) {
+			struct sockaddr_in *sin;
+			struct sockaddr_in6 *sin6;
+		case 4:
+			sin = (void *)&sa;
+			sin->sin_family = AF_INET;
+			sin->sin_addr.s_addr = id->nid.nid_addr[0];
+			sin->sin_port = htons(lnet_acceptor_port());
+			break;
+		case 16:
+			sin6 = (void *)&sa;
+			sin6->sin6_family = AF_INET6;
+			memcpy(&sin6->sin6_addr, id->nid.nid_addr,
+			       sizeof(sin6->sin6_addr));
+			sin6->sin6_port = htons(lnet_acceptor_port());
+			break;
 		}
+		rc = ksocknal_add_peer(ni, id, (struct sockaddr *)&sa);
 		if (rc) {
 			CERROR("Can't add peer_ni %s: %d\n",
 			       libcfs_idstr(id), rc);
-- 
1.8.3.1

