Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7492544C28
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245372AbiFIMeF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245554AbiFIMeC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:02 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30088237C6
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:52 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 56F15EFE;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 55D8CD438A; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 15/18] lnet: selftest: improve lnet_selftest speed
Date:   Thu,  9 Jun 2022 08:33:11 -0400
Message-Id: <1654777994-29806-16-git-send-email-jsimmons@infradead.org>
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

From: Alexey Lyashkov <alexey.lyashkov@hpe.com>

lets replace a global spinlock with atomic variables,
to avoid cpu power limit in testing.

HPE-bug-id: LUS-10812
WC-bug-id: https://jira.whamcloud.com/browse/LU-15718
Lustre-commit: dd5aa640781d8c6dc ("LU-15718 lnet: improve lnet_selftest speed")
Signed-off-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-on: https://review.whamcloud.com/47002
Reviewed-by: Cyril Bordage <cbordage@whamcloud.com>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/selftest/rpc.c      | 105 ++++++++++++++++++++++++-------------------
 net/lnet/selftest/selftest.h |   1 -
 2 files changed, 58 insertions(+), 48 deletions(-)

diff --git a/net/lnet/selftest/rpc.c b/net/lnet/selftest/rpc.c
index 17277b8..c376019 100644
--- a/net/lnet/selftest/rpc.c
+++ b/net/lnet/selftest/rpc.c
@@ -50,15 +50,41 @@ enum srpc_state {
 	SRPC_STATE_STOPPING,
 };
 
+enum rpc_counter_32 {
+	SRPC_ERROR,
+	SRPC_RPC_SENT,
+	SRPC_RPC_RCVD,
+	SRPC_RPC_DROP,
+	SRPC_RPC_EXPIRED,
+	SRPC_COUNTER32_MAX,
+};
+
+enum rpc_counter_64 {
+	SRPC_BULK_GET,
+	SRPC_BULK_PUT,
+	SRPC_COUNTER64_MAX,
+};
+
 static struct smoketest_rpc {
-	spinlock_t	 rpc_glock;	/* global lock */
-	struct srpc_service	*rpc_services[SRPC_SERVICE_MAX_ID + 1];
-	lnet_handler_t		 rpc_lnet_handler; /* _the_ LNet event queue */
-	enum srpc_state	 rpc_state;
-	struct srpc_counters	 rpc_counters;
-	u64		 rpc_matchbits;	/* matchbits counter */
+	spinlock_t		rpc_glock;	/* global lock */
+	struct srpc_service    *rpc_services[SRPC_SERVICE_MAX_ID + 1];
+	lnet_handler_t		rpc_lnet_handler; /* _the_ LNet event queue */
+	enum srpc_state		rpc_state;
+	struct srpc_counters	rpc_counters;
+	atomic_t		rpc_counters32[SRPC_COUNTER32_MAX];
+	atomic64_t		rpc_counters64[SRPC_COUNTER64_MAX];
+	atomic64_t		rpc_matchbits;	/* matchbits counter */
 } srpc_data;
 
+#define RPC_STAT32(a) \
+	srpc_data.rpc_counters32[(a)]
+
+#define GET_RPC_STAT32(a) \
+	atomic_read(&srpc_data.rpc_counters32[(a)])
+
+#define GET_RPC_STAT64(a) \
+	atomic64_read(&srpc_data.rpc_counters64[(a)])
+
 static inline int
 srpc_serv_portal(int svc_id)
 {
@@ -69,18 +95,17 @@ enum srpc_state {
 /* forward ref's */
 void srpc_handle_rpc(struct swi_workitem *wi);
 
-void srpc_get_counters(struct srpc_counters *cnt)
-{
-	spin_lock(&srpc_data.rpc_glock);
-	*cnt = srpc_data.rpc_counters;
-	spin_unlock(&srpc_data.rpc_glock);
-}
 
-void srpc_set_counters(const struct srpc_counters *cnt)
+void srpc_get_counters(struct srpc_counters *cnt)
 {
-	spin_lock(&srpc_data.rpc_glock);
-	srpc_data.rpc_counters = *cnt;
-	spin_unlock(&srpc_data.rpc_glock);
+	cnt->errors = GET_RPC_STAT32(SRPC_ERROR);
+	cnt->rpcs_sent = GET_RPC_STAT32(SRPC_RPC_SENT);
+	cnt->rpcs_rcvd = GET_RPC_STAT32(SRPC_RPC_RCVD);
+	cnt->rpcs_dropped = GET_RPC_STAT32(SRPC_RPC_DROP);
+	cnt->rpcs_expired = GET_RPC_STAT32(SRPC_RPC_EXPIRED);
+
+	cnt->bulk_get = GET_RPC_STAT64(SRPC_BULK_GET);
+	cnt->bulk_put = GET_RPC_STAT64(SRPC_BULK_PUT);
 }
 
 static int
@@ -162,12 +187,7 @@ struct srpc_bulk *
 static inline u64
 srpc_next_id(void)
 {
-	u64 id;
-
-	spin_lock(&srpc_data.rpc_glock);
-	id = srpc_data.rpc_matchbits++;
-	spin_unlock(&srpc_data.rpc_glock);
-	return id;
+	return atomic64_inc_return(&srpc_data.rpc_matchbits);
 }
 
 static void
@@ -922,11 +942,8 @@ struct srpc_bulk *
 		     rpc, sv->sv_name, libcfs_id2str(rpc->srpc_peer),
 		     swi_state2str(rpc->srpc_wi.swi_state), status);
 
-	if (status) {
-		spin_lock(&srpc_data.rpc_glock);
-		srpc_data.rpc_counters.rpcs_dropped++;
-		spin_unlock(&srpc_data.rpc_glock);
-	}
+	if (status)
+		atomic_inc(&RPC_STAT32(SRPC_RPC_DROP));
 
 	if (rpc->srpc_done)
 		(*rpc->srpc_done) (rpc);
@@ -1096,9 +1113,7 @@ struct srpc_bulk *
 
 	spin_unlock(&rpc->crpc_lock);
 
-	spin_lock(&srpc_data.rpc_glock);
-	srpc_data.rpc_counters.rpcs_expired++;
-	spin_unlock(&srpc_data.rpc_glock);
+	atomic_inc(&RPC_STAT32(SRPC_RPC_EXPIRED));
 }
 
 static void
@@ -1431,11 +1446,10 @@ struct srpc_client_rpc *
 	if (ev->status) {
 		u32 errors;
 
-		spin_lock(&srpc_data.rpc_glock);
 		if (ev->status != -ECANCELED) /* cancellation is not error */
-			srpc_data.rpc_counters.errors++;
-		errors = srpc_data.rpc_counters.errors;
-		spin_unlock(&srpc_data.rpc_glock);
+			errors = atomic_inc_return(&RPC_STAT32(SRPC_ERROR));
+		else
+			errors = atomic_read(&RPC_STAT32(SRPC_ERROR));
 
 		CNETERR("LNet event status %d type %d, RPC errors %u\n",
 			ev->status, ev->type, errors);
@@ -1449,11 +1463,9 @@ struct srpc_client_rpc *
 		       rpcev->ev_status, rpcev->ev_type, rpcev->ev_lnet);
 		LBUG();
 	case SRPC_REQUEST_SENT:
-		if (!ev->status && ev->type != LNET_EVENT_UNLINK) {
-			spin_lock(&srpc_data.rpc_glock);
-			srpc_data.rpc_counters.rpcs_sent++;
-			spin_unlock(&srpc_data.rpc_glock);
-		}
+		if (!ev->status && ev->type != LNET_EVENT_UNLINK)
+			atomic_inc(&RPC_STAT32(SRPC_RPC_SENT));
+
 		/* fall through */
 	case SRPC_REPLY_RCVD:
 	case SRPC_BULK_REQ_RCVD:
@@ -1566,9 +1578,7 @@ struct srpc_client_rpc *
 
 		spin_unlock(&scd->scd_lock);
 
-		spin_lock(&srpc_data.rpc_glock);
-		srpc_data.rpc_counters.rpcs_rcvd++;
-		spin_unlock(&srpc_data.rpc_glock);
+		atomic_inc(&RPC_STAT32(SRPC_RPC_RCVD));
 		break;
 
 	case SRPC_BULK_GET_RPLD:
@@ -1581,14 +1591,14 @@ struct srpc_client_rpc *
 		/* fall through */
 	case SRPC_BULK_PUT_SENT:
 		if (!ev->status && ev->type != LNET_EVENT_UNLINK) {
-			spin_lock(&srpc_data.rpc_glock);
+			atomic64_t *data;
 
 			if (rpcev->ev_type == SRPC_BULK_GET_RPLD)
-				srpc_data.rpc_counters.bulk_get += ev->mlength;
+				data = &srpc_data.rpc_counters64[SRPC_BULK_GET];
 			else
-				srpc_data.rpc_counters.bulk_put += ev->mlength;
+				data = &srpc_data.rpc_counters64[SRPC_BULK_PUT];
 
-			spin_unlock(&srpc_data.rpc_glock);
+			atomic64_add(ev->mlength, data);
 		}
 		/* fall through */
 	case SRPC_REPLY_SENT:
@@ -1619,7 +1629,8 @@ struct srpc_client_rpc *
 
 	/* 1 second pause to avoid timestamp reuse */
 	schedule_timeout_uninterruptible(HZ);
-	srpc_data.rpc_matchbits = ((u64)ktime_get_real_seconds()) << 48;
+	atomic64_set(&srpc_data.rpc_matchbits,
+		     ((u64)ktime_get_real_seconds() << 48));
 
 	srpc_data.rpc_state = SRPC_STATE_NONE;
 
diff --git a/net/lnet/selftest/selftest.h b/net/lnet/selftest/selftest.h
index 26202c1..223a432 100644
--- a/net/lnet/selftest/selftest.h
+++ b/net/lnet/selftest/selftest.h
@@ -452,7 +452,6 @@ struct srpc_bulk *srpc_alloc_bulk(int cpt, unsigned int off,
 int srpc_service_add_buffers(struct srpc_service *sv, int nbuffer);
 void srpc_service_remove_buffers(struct srpc_service *sv, int nbuffer);
 void srpc_get_counters(struct srpc_counters *cnt);
-void srpc_set_counters(const struct srpc_counters *cnt);
 
 extern struct workqueue_struct *lst_serial_wq;
 extern struct workqueue_struct **lst_test_wq;
-- 
1.8.3.1

