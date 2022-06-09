Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0696544C24
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245532AbiFIMeB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245480AbiFIMds (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:48 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9AC22520
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:44 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 4B4B6EFA;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 498CCD43A0; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 11/18] lnet: socklnd: large processid for ksocknal_get_peer_info
Date:   Thu,  9 Jun 2022 08:33:07 -0400
Message-Id: <1654777994-29806-12-git-send-email-jsimmons@infradead.org>
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

Have ksocknal_launch_packet() report a 'struct lnet_processid'
with a large address.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: e4a49294530a5d5f7 ("LU-10391 socklnd: large processid for ksocknal_get_peer_info")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/44622
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/klnds/socklnd/socklnd.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/lnet/klnds/socklnd/socklnd.c b/net/lnet/klnds/socklnd/socklnd.c
index 2b6fa18..857aa05 100644
--- a/net/lnet/klnds/socklnd/socklnd.c
+++ b/net/lnet/klnds/socklnd/socklnd.c
@@ -292,7 +292,7 @@ struct ksock_peer_ni *
 
 static int
 ksocknal_get_peer_info(struct lnet_ni *ni, int index,
-		       struct lnet_process_id *id, u32 *myip, u32 *peer_ip,
+		       struct lnet_processid *id, u32 *myip, u32 *peer_ip,
 		       int *port, int *conn_count, int *share_count)
 {
 	struct ksock_peer_ni *peer_ni;
@@ -312,8 +312,7 @@ struct ksock_peer_ni *
 			if (index-- > 0)
 				continue;
 
-			id->pid = peer_ni->ksnp_id.pid;
-			id->nid = lnet_nid_to_nid4(&peer_ni->ksnp_id.nid);
+			*id = peer_ni->ksnp_id;
 			*myip = 0;
 			*peer_ip = 0;
 			*port = 0;
@@ -327,8 +326,7 @@ struct ksock_peer_ni *
 			if (index-- > 0)
 				continue;
 
-			id->pid = peer_ni->ksnp_id.pid;
-			id->nid = lnet_nid_to_nid4(&peer_ni->ksnp_id.nid);
+			*id = peer_ni->ksnp_id;
 			*myip = peer_ni->ksnp_passive_ips[j];
 			*peer_ip = 0;
 			*port = 0;
@@ -344,8 +342,7 @@ struct ksock_peer_ni *
 
 			conn_cb = peer_ni->ksnp_conn_cb;
 
-			id->pid = peer_ni->ksnp_id.pid;
-			id->nid = lnet_nid_to_nid4(&peer_ni->ksnp_id.nid);
+			*id = peer_ni->ksnp_id;
 			if (conn_cb->ksnr_addr.ss_family == AF_INET) {
 				struct sockaddr_in *sa;
 
@@ -1808,18 +1805,20 @@ static int ksocknal_push(struct lnet_ni *ni, struct lnet_processid *id)
 		int share_count = 0;
 
 		rc = ksocknal_get_peer_info(ni, data->ioc_count,
-					    &id4, &myip, &ip, &port,
+					    &id, &myip, &ip, &port,
 					    &conn_count,  &share_count);
 		if (rc)
 			return rc;
 
-		data->ioc_nid = id4.nid;
+		if (!nid_is_nid4(&id.nid))
+			return -EINVAL;
+		data->ioc_nid = lnet_nid_to_nid4(&id.nid);
 		data->ioc_count = share_count;
 		data->ioc_u32[0] = ip;
 		data->ioc_u32[1] = port;
 		data->ioc_u32[2] = myip;
 		data->ioc_u32[3] = conn_count;
-		data->ioc_u32[4] = id4.pid;
+		data->ioc_u32[4] = id.pid;
 		return 0;
 	}
 
-- 
1.8.3.1

