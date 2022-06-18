Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0989D550530
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiFRNwh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiFRNwT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:19 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FA31D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:18 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id EB62F13C3;
        Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id DD002E4F1D; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 01/28] lustre: osc: handle removal of NR_UNSTABLE_NFS
Date:   Sat, 18 Jun 2022 09:51:43 -0400
Message-Id: <1655560330-30743-2-git-send-email-jsimmons@infradead.org>
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

From: Mr NeilBrown <neilb@suse.de>

In Linux 5.8 the NR_UNSTABLE_NFS page counters are go.  All pages that
have been writen but are not yet safe are now counted in NR_WRITEBACK.

So change osc_page to count in NR_WRITEBACK.

WC-bug-id: https://jira.whamcloud.com/browse/LU-13783
Lustre-commit: 3e5faa441266cd8d ("LU-13783 osc: handle removal of NR_UNSTABLE_NFS")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/39260
Reviewed-by: Shaun Tancheff <shaun.tancheff@hpe.com>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/osc/osc_page.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lustre/osc/osc_page.c b/fs/lustre/osc/osc_page.c
index b56bc1a..fd87698 100644
--- a/fs/lustre/osc/osc_page.c
+++ b/fs/lustre/osc/osc_page.c
@@ -934,7 +934,7 @@ static inline void unstable_page_accounting(struct ptlrpc_bulk_desc *desc,
 		}
 
 		if (count > 0) {
-			mod_node_page_state(pgdat, NR_UNSTABLE_NFS,
+			mod_node_page_state(pgdat, NR_WRITEBACK,
 					    factor * count);
 			count = 0;
 		}
@@ -942,7 +942,7 @@ static inline void unstable_page_accounting(struct ptlrpc_bulk_desc *desc,
 		++count;
 	}
 	if (count > 0)
-		mod_node_page_state(last, NR_UNSTABLE_NFS, factor * count);
+		mod_node_page_state(last, NR_WRITEBACK, factor * count);
 }
 
 static inline void add_unstable_page_accounting(struct ptlrpc_bulk_desc *desc,
-- 
1.8.3.1

