Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF76550557
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350581AbiFROAy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237024AbiFRNxd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:33 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8B8D108
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:29 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 5C0D81E8D;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 59C94FD3BF; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Alex Zhuravlev <bzzz@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 28/28] lustre: ptlrpc: don't report eviction for light weigth connections
Date:   Sat, 18 Jun 2022 09:52:10 -0400
Message-Id: <1655560330-30743-29-git-send-email-jsimmons@infradead.org>
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

From: Alex Zhuravlev <bzzz@whamcloud.com>

lightweight connections aren't persistent, so they found themselves
"evicted" after target's restart, which is not correct.
don't confuse people with false error.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15865
Lustre-commit: 3e5dc84be447e16a8 ("LU-15865 ptlrpc: don't report eviction for lwp")
Signed-off-by: Alex Zhuravlev <bzzz@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/47374
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Mike Pershin <mpershin@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/import.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/lustre/ptlrpc/import.c b/fs/lustre/ptlrpc/import.c
index d685b96..a5fdb8a8 100644
--- a/fs/lustre/ptlrpc/import.c
+++ b/fs/lustre/ptlrpc/import.c
@@ -1516,12 +1516,15 @@ int ptlrpc_import_recovery_state_machine(struct obd_import *imp)
 
 	if (imp->imp_state == LUSTRE_IMP_EVICTED) {
 		struct task_struct *task;
+		u64 connect_flags;
 
 		deuuidify(obd2cli_tgt(imp->imp_obd), NULL,
 			  &target_start, &target_len);
+		connect_flags = imp->imp_connect_data.ocd_connect_flags;
 		/* Don't care about MGC eviction */
 		if (strcmp(imp->imp_obd->obd_type->typ_name,
-			   LUSTRE_MGC_NAME) != 0) {
+			   LUSTRE_MGC_NAME) != 0 &&
+		    (connect_flags & OBD_CONNECT_LIGHTWEIGHT) == 0) {
 			LCONSOLE_ERROR_MSG(0x167,
 					   "%s: This client was evicted by %.*s; in progress operations using this service will fail.\n",
 					   imp->imp_obd->obd_name, target_len,
-- 
1.8.3.1

