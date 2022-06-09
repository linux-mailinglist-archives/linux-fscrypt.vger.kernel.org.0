Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97D6544C1C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245364AbiFIMdh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245165AbiFIMde (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:34 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716EB186FB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:32 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 429FEEF5;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 38701D4403; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 06/18] lnet: alter lnet_drop_rule_match() to take lnet_nid
Date:   Thu,  9 Jun 2022 08:33:02 -0400
Message-Id: <1654777994-29806-7-git-send-email-jsimmons@infradead.org>
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

The local nid passed to lnet_drop_rule_match() is now a 16-byte nid.
Various support functions are also changed to embrace 'struct
lnet_nid'.

WC-bug-id: https://jira.whamcloud.com/browse/LU-10391
Lustre-commit: 57b7b3d36f5fa1527 ("LU-10391 lnet: alter lnet_drop_rule_match() to take lnet_nid")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43617
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Amir Shehata <ashehata@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/lnet/lib-lnet.h |  2 +-
 net/lnet/lnet/lib-move.c      |  3 +--
 net/lnet/lnet/lib-msg.c       |  3 +--
 net/lnet/lnet/net_fault.c     | 40 +++++++++++++++++++++++-----------------
 4 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/lnet/lib-lnet.h b/include/linux/lnet/lib-lnet.h
index b6a7a54..2e3c391 100644
--- a/include/linux/lnet/lib-lnet.h
+++ b/include/linux/lnet/lib-lnet.h
@@ -751,7 +751,7 @@ void lnet_drop_message(struct lnet_ni *ni, int cpt, void *private,
 int lnet_fault_init(void);
 void lnet_fault_fini(void);
 
-bool lnet_drop_rule_match(struct lnet_hdr *hdr, lnet_nid_t local_nid,
+bool lnet_drop_rule_match(struct lnet_hdr *hdr, struct lnet_nid *local_nid,
 			  enum lnet_msg_hstatus *hstatus);
 
 int lnet_delay_rule_add(struct lnet_fault_attr *attr);
diff --git a/net/lnet/lnet/lib-move.c b/net/lnet/lnet/lib-move.c
index 0496bf5..080bfe6 100644
--- a/net/lnet/lnet/lib-move.c
+++ b/net/lnet/lnet/lib-move.c
@@ -4379,9 +4379,8 @@ void lnet_monitor_thr_stop(void)
 		goto drop;
 	}
 
-	/* FIXME need to support large-addr nid */
 	if (!list_empty(&the_lnet.ln_drop_rules) &&
-	    lnet_drop_rule_match(hdr, lnet_nid_to_nid4(&ni->ni_nid), NULL)) {
+	    lnet_drop_rule_match(hdr, &ni->ni_nid, NULL)) {
 		CDEBUG(D_NET, "%s, src %s, dst %s: Dropping %s to simulate silent message loss\n",
 		       libcfs_nidstr(from_nid), libcfs_nidstr(&src_nid),
 		       libcfs_nidstr(&dest_nid), lnet_msgtyp2str(type));
diff --git a/net/lnet/lnet/lib-msg.c b/net/lnet/lnet/lib-msg.c
index f476975..95695b2 100644
--- a/net/lnet/lnet/lib-msg.c
+++ b/net/lnet/lnet/lib-msg.c
@@ -1115,8 +1115,7 @@
 		return false;
 
 	/* match only health rules */
-	if (!lnet_drop_rule_match(&msg->msg_hdr, LNET_NID_ANY,
-				  hstatus))
+	if (!lnet_drop_rule_match(&msg->msg_hdr, NULL, hstatus))
 		return false;
 
 	CDEBUG(D_NET,
diff --git a/net/lnet/lnet/net_fault.c b/net/lnet/lnet/net_fault.c
index 1f08b38..fe7a07c 100644
--- a/net/lnet/lnet/net_fault.c
+++ b/net/lnet/lnet/net_fault.c
@@ -65,12 +65,16 @@ struct lnet_drop_rule {
 };
 
 static bool
-lnet_fault_nid_match(lnet_nid_t nid, lnet_nid_t msg_nid)
+lnet_fault_nid_match(lnet_nid_t nid, struct lnet_nid *msg_nid)
 {
-	if (nid == msg_nid || nid == LNET_NID_ANY)
+	if (nid == LNET_NID_ANY)
+		return true;
+	if (!msg_nid)
+		return false;
+	if (lnet_nid_to_nid4(msg_nid) == nid)
 		return true;
 
-	if (LNET_NIDNET(nid) != LNET_NIDNET(msg_nid))
+	if (LNET_NIDNET(nid) != LNET_NID_NET(msg_nid))
 		return false;
 
 	/* 255.255.255.255@net is wildcard for all addresses in a network */
@@ -78,8 +82,10 @@ struct lnet_drop_rule {
 }
 
 static bool
-lnet_fault_attr_match(struct lnet_fault_attr *attr, lnet_nid_t src,
-		      lnet_nid_t local_nid, lnet_nid_t dst,
+lnet_fault_attr_match(struct lnet_fault_attr *attr,
+		      struct lnet_nid *src,
+		      struct lnet_nid *local_nid,
+		      struct lnet_nid *dst,
 		      unsigned int type, unsigned int portal)
 {
 	if (!lnet_fault_nid_match(attr->fa_src, src) ||
@@ -339,8 +345,10 @@ struct lnet_drop_rule {
  * decide whether should drop this message or not
  */
 static bool
-drop_rule_match(struct lnet_drop_rule *rule, lnet_nid_t src,
-		lnet_nid_t local_nid, lnet_nid_t dst,
+drop_rule_match(struct lnet_drop_rule *rule,
+		struct lnet_nid *src,
+		struct lnet_nid *local_nid,
+		struct lnet_nid *dst,
 		unsigned int type, unsigned int portal,
 		enum lnet_msg_hstatus *hstatus)
 {
@@ -424,11 +432,9 @@ struct lnet_drop_rule {
  */
 bool
 lnet_drop_rule_match(struct lnet_hdr *hdr,
-		     lnet_nid_t local_nid,
+		     struct lnet_nid *local_nid,
 		     enum lnet_msg_hstatus *hstatus)
 {
-	lnet_nid_t src = lnet_nid_to_nid4(&hdr->src_nid);
-	lnet_nid_t dst = lnet_nid_to_nid4(&hdr->dest_nid);
 	unsigned int typ = hdr->type;
 	struct lnet_drop_rule *rule;
 	unsigned int ptl = -1;
@@ -446,7 +452,8 @@ struct lnet_drop_rule {
 
 	cpt = lnet_net_lock_current();
 	list_for_each_entry(rule, &the_lnet.ln_drop_rules, dr_link) {
-		drop = drop_rule_match(rule, src, local_nid, dst, typ, ptl,
+		drop = drop_rule_match(rule, &hdr->src_nid, local_nid,
+				       &hdr->dest_nid, typ, ptl,
 				       hstatus);
 		if (drop)
 			break;
@@ -530,15 +537,15 @@ struct delay_daemon_data {
  * decide whether should delay this message or not
  */
 static bool
-delay_rule_match(struct lnet_delay_rule *rule, lnet_nid_t src,
-		 lnet_nid_t dst, unsigned int type, unsigned int portal,
+delay_rule_match(struct lnet_delay_rule *rule, struct lnet_nid *src,
+		 struct lnet_nid *dst, unsigned int type, unsigned int portal,
 		 struct lnet_msg *msg)
 {
 	struct lnet_fault_attr *attr = &rule->dl_attr;
 	bool delay;
 	time64_t now = ktime_get_seconds();
 
-	if (!lnet_fault_attr_match(attr, src, LNET_NID_ANY,
+	if (!lnet_fault_attr_match(attr, src, NULL,
 				   dst, type, portal))
 		return false;
 
@@ -605,8 +612,6 @@ struct delay_daemon_data {
 lnet_delay_rule_match_locked(struct lnet_hdr *hdr, struct lnet_msg *msg)
 {
 	struct lnet_delay_rule *rule;
-	lnet_nid_t src = lnet_nid_to_nid4(&hdr->src_nid);
-	lnet_nid_t dst = lnet_nid_to_nid4(&hdr->dest_nid);
 	unsigned int typ = hdr->type;
 	unsigned int ptl = -1;
 
@@ -622,7 +627,8 @@ struct delay_daemon_data {
 		ptl = le32_to_cpu(hdr->msg.get.ptl_index);
 
 	list_for_each_entry(rule, &the_lnet.ln_delay_rules, dl_link) {
-		if (delay_rule_match(rule, src, dst, typ, ptl, msg))
+		if (delay_rule_match(rule, &hdr->src_nid, &hdr->dest_nid,
+				     typ, ptl, msg))
 			return true;
 	}
 
-- 
1.8.3.1

