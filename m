Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1028550537
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiFRNw7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiFRNwz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:55 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80992DAB
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:53 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 1783913E6;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 105F1FD3BF; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Andrew Elwell <Andrew.Elwell@gmail.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 11/28] lustre: ptlrpc: Rearrange version mismatch message
Date:   Sat, 18 Jun 2022 09:51:53 -0400
Message-Id: <1655560330-30743-12-git-send-email-jsimmons@infradead.org>
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

From: Andrew Elwell <Andrew.Elwell@gmail.com>

Minor change to reposition the client version string on
console warning message.

WC-bug-id: https://jira.whamcloud.com/browse/LU-14771
Lustre-commit: 8a35a977b4322db56 ("LU-14771 ptlrpc: Rearrange version mismatch message")
Signed-off-by: Andrew Elwell <Andrew.Elwell@gmail.com>
Reviewed-on: https://review.whamcloud.com/44029
Reviewed-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/import.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/lustre/ptlrpc/import.c b/fs/lustre/ptlrpc/import.c
index c0aee34..d685b96 100644
--- a/fs/lustre/ptlrpc/import.c
+++ b/fs/lustre/ptlrpc/import.c
@@ -853,14 +853,15 @@ static int ptlrpc_connect_set_flags(struct obd_import *imp,
 		const char *older = "older than client. Consider upgrading server";
 		const char *newer = "newer than client. Consider upgrading client";
 
-		LCONSOLE_WARN("Server %s version (%d.%d.%d.%d) is much %s (%s)\n",
+		LCONSOLE_WARN("Client version (%s). Server %s version (%d.%d.%d.%d) is much %s\n",
+			      LUSTRE_VERSION_STRING,
 			      obd2cli_tgt(imp->imp_obd),
 			      OBD_OCD_VERSION_MAJOR(ocd->ocd_version),
 			      OBD_OCD_VERSION_MINOR(ocd->ocd_version),
 			      OBD_OCD_VERSION_PATCH(ocd->ocd_version),
 			      OBD_OCD_VERSION_FIX(ocd->ocd_version),
 			      ocd->ocd_version > LUSTRE_VERSION_CODE ?
-			      newer : older, LUSTRE_VERSION_STRING);
+			      newer : older);
 		warned = true;
 	}
 
-- 
1.8.3.1

