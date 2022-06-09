Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3EC544C29
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245344AbiFIMeL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiFIMeI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:08 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C748D2252D
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:34:01 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 5A5AFEFF;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 58E6DD439B; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Etienne AUJAMES <eaujames@ddn.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 16/18] lustre: mdc: Use early cancels for hsm requests
Date:   Thu,  9 Jun 2022 08:33:12 -0400
Message-Id: <1654777994-29806-17-git-send-email-jsimmons@infradead.org>
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

From: Etienne AUJAMES <eaujames@ddn.com>

HSM RELEASE and RESTORE requests take EX layout lock on the MDT side.
So the client can use early cancel for its local lock on the resource
to limit the contention (mdt side).

This patch does not pack ldlm request inside the hsm request because
the field (RMF_DLM_REQ) does not exist in the request. Adding this
field inside the request would break compatibility with _old_ servers.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15132
Lustre-commit: 60d2a4b0efa4a944b ("LU-15132 mdc: Use early cancels for hsm requests")
Signed-off-by: Etienne AUJAMES <eaujames@ddn.com>
Reviewed-on: https://review.whamcloud.com/47181
Reviewed-by: Nikitas Angelinas <nikitas.angelinas@hpe.com>
Reviewed-by: Sergey Cheremencev <sergey.cheremencev@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/mdc/mdc_request.c | 37 +++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/fs/lustre/mdc/mdc_request.c b/fs/lustre/mdc/mdc_request.c
index f553d44..bb51878 100644
--- a/fs/lustre/mdc/mdc_request.c
+++ b/fs/lustre/mdc/mdc_request.c
@@ -2000,6 +2000,32 @@ static int mdc_ioc_hsm_state_set(struct obd_export *exp,
 	return rc;
 }
 
+/* For RESTORE and RELEASE the mdt will take EX lock on the file layout.
+ * So we can use early cancel on client side locks for that resource.
+ */
+static inline int mdc_hsm_request_lock_to_cancel(struct obd_export *exp,
+						 struct hsm_user_request *hur,
+						 struct list_head *cancels)
+{
+	struct hsm_user_item *hui = &hur->hur_user_item[0];
+	struct hsm_request *req_hr = &hur->hur_request;
+	int count = 0;
+	int i;
+
+	if (req_hr->hr_action != HUA_RESTORE &&
+	    req_hr->hr_action != HUA_RELEASE)
+		return 0;
+
+	for (i = 0; i < req_hr->hr_itemcount; i++, hui++) {
+		if (!fid_is_sane(&hui->hui_fid))
+			continue;
+		count += mdc_resource_get_unused(exp, &hui->hui_fid, cancels,
+						 LCK_EX, MDS_INODELOCK_LAYOUT);
+	}
+
+	return count;
+}
+
 static int mdc_ioc_hsm_request(struct obd_export *exp,
 			       struct hsm_user_request *hur)
 {
@@ -2008,13 +2034,13 @@ static int mdc_ioc_hsm_request(struct obd_export *exp,
 	struct hsm_request *req_hr;
 	struct hsm_user_item *req_hui;
 	char *req_opaque;
+	LIST_HEAD(cancels);
+	int count;
 	int rc;
 
 	req = ptlrpc_request_alloc(imp, &RQF_MDS_HSM_REQUEST);
-	if (!req) {
-		rc = -ENOMEM;
-		goto out;
-	}
+	if (!req)
+		return -ENOMEM;
 
 	req_capsule_set_size(&req->rq_pill, &RMF_MDS_HSM_USER_ITEM, RCL_CLIENT,
 			     hur->hur_request.hr_itemcount
@@ -2028,6 +2054,9 @@ static int mdc_ioc_hsm_request(struct obd_export *exp,
 		return rc;
 	}
 
+	/* Cancel existing locks */
+	count = mdc_hsm_request_lock_to_cancel(exp, hur, &cancels);
+	ldlm_cli_cancel_list(&cancels, count, NULL, 0);
 	mdc_pack_body(&req->rq_pill, NULL, 0, 0, -1, 0);
 
 	/* Copy hsm_request struct */
-- 
1.8.3.1

