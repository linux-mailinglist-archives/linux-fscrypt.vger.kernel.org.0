Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8341F550551
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbiFROAv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbiFRNxV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:21 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AECC3AD
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:20 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 484FF13FE;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 43A4AE9152; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Chris Horn <chris.horn@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 23/28] lnet: Ping buffer ref leak in lnet_peer_data_present
Date:   Sat, 18 Jun 2022 09:52:05 -0400
Message-Id: <1655560330-30743-24-git-send-email-jsimmons@infradead.org>
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

From: Chris Horn <chris.horn@hpe.com>

lnet_peer_merge_data() and lnet_peer_set_primary_data() are
responsible for dropping the reference on the ping buffer that is
taken by lnet_peer_push_event() and lnet_discovery_event_reply().
However, there are some error paths in lnet_peer_data_present()
where we do not call either lnet_peer_merge_data() or
lnet_peer_set_primary_data(). In these cases, we need to drop
the reference on the ping buffer otherwise it will leak.

HPE-bug-id: LUS-10715
WC-bug-id: https://jira.whamcloud.com/browse/LU-15509
Lustre-commit: 4de9793654ec1b2f0 ("LU-15509 lnet: Ping buffer ref leak in lnet_peer_data_present")
Signed-off-by: Chris Horn <chris.horn@hpe.com>
Reviewed-on: https://review.whamcloud.com/46431
Reviewed-by: Andriy Skulysh <andriy.skulysh@hpe.com>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-by: Cyril Bordage <cbordage@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/lnet/peer.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/lnet/lnet/peer.c b/net/lnet/lnet/peer.c
index 57d137c..3909c5d 100644
--- a/net/lnet/lnet/peer.c
+++ b/net/lnet/lnet/peer.c
@@ -3317,8 +3317,10 @@ static int lnet_peer_data_present(struct lnet_peer *lp)
 	 * down, and our reference count may be all that is keeping it
 	 * alive. Don't do any work on it.
 	 */
-	if (list_empty(&lp->lp_peer_list))
+	if (list_empty(&lp->lp_peer_list)) {
+		lnet_ping_buffer_decref(pbuf);
 		goto out;
+	}
 
 	flags = LNET_PEER_DISCOVERED;
 	if (pbuf->pb_info.pi_features & LNET_PING_FEAT_MULTI_RAIL)
@@ -3345,7 +3347,9 @@ static int lnet_peer_data_present(struct lnet_peer *lp)
 	nid = pbuf->pb_info.pi_ni[1].ns_nid;
 	if (nid_is_lo0(&lp->lp_primary_nid)) {
 		rc = lnet_peer_set_primary_nid(lp, nid, flags);
-		if (!rc)
+		if (rc)
+			lnet_ping_buffer_decref(pbuf);
+		else
 			rc = lnet_peer_merge_data(lp, pbuf);
 	/* if the primary nid of the peer is present in the ping info returned
 	 * from the peer, but it's not the local primary peer we have
@@ -3367,6 +3371,7 @@ static int lnet_peer_data_present(struct lnet_peer *lp)
 				CERROR("Primary NID error %s versus %s: %d\n",
 				       libcfs_nidstr(&lp->lp_primary_nid),
 				       libcfs_nid2str(nid), rc);
+				lnet_ping_buffer_decref(pbuf);
 			} else {
 				rc = lnet_peer_merge_data(lp, pbuf);
 			}
-- 
1.8.3.1

