Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351D1544C2C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiFIMeR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245443AbiFIMeJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:09 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44E621E28
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:34:08 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 5E31D1020;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 5C522D43A0; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Alexander Boyko <alexander.boyko@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 17/18] lustre: ptlrpc: send disconnected events
Date:   Thu,  9 Jun 2022 08:33:13 -0400
Message-Id: <1654777994-29806-18-git-send-email-jsimmons@infradead.org>
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

From: Alexander Boyko <alexander.boyko@hpe.com>

Failover of node does not produce disconnect event, only inactive.
Add sending disconnected events.

HPE-bug-id: LUS-10750
WC-bug-id: https://jira.whamcloud.com/browse/LU-15724
Lustre-commit: e55fc043679cdfadf ("LU-15724 osp: wakeup all precreate threads")
Signed-off-by: Alexander Boyko <alexander.boyko@hpe.com>
Reviewed-on: https://review.whamcloud.com/47005
Reviewed-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-by: Sergey Cheremencev <sergey.cheremencev@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/import.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/lustre/ptlrpc/import.c b/fs/lustre/ptlrpc/import.c
index 3dc987cf..c0aee34 100644
--- a/fs/lustre/ptlrpc/import.c
+++ b/fs/lustre/ptlrpc/import.c
@@ -1726,6 +1726,10 @@ int ptlrpc_disconnect_import(struct obd_import *imp, int noclose)
 	memset(&imp->imp_remote_handle, 0, sizeof(imp->imp_remote_handle));
 	spin_unlock(&imp->imp_lock);
 
+	obd_import_event(imp->imp_obd, imp, IMP_EVENT_DISCON);
+	if (!noclose)
+		obd_import_event(imp->imp_obd, imp, IMP_EVENT_INACTIVE);
+
 	if (rc == -ETIMEDOUT || rc == -ENOTCONN || rc == -ESHUTDOWN)
 		rc = 0;
 
-- 
1.8.3.1

