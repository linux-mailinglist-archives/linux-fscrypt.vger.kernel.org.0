Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260A0550553
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiFROAt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiFRNxM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:12 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B8664F4
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:10 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 365AC13FA;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 318CBE9152; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Patrick Farrell <pfarrell@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 19/28] lustre: osc: Add RPC to iotrace
Date:   Sat, 18 Jun 2022 09:52:01 -0400
Message-Id: <1655560330-30743-20-git-send-email-jsimmons@infradead.org>
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

From: Patrick Farrell <pfarrell@whamcloud.com>

Add RPCs to iotrace debugging.

To avoid creating too much debug output, this debug
ignores the possiblity that an RPC contains non-contiguous
extents.  Thus the eventual visualization will act as
though the RPC is a continuous whole.  I judge this to be
superior to the amount of log data and complexity of
capturing each extent separately.  If that level of detail
is needed, a higher debug level can be used.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15317
Lustre-commit: 5cb722c384077dd24 ("LU-15317 osc: Add RPC to iotrace")
Signed-off-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/45894
Reviewed-by: Sebastien Buisson <sbuisson@ddn.com>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/osc/osc_request.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/lustre/osc/osc_request.c b/fs/lustre/osc/osc_request.c
index 124d3c57..d84884f 100644
--- a/fs/lustre/osc/osc_request.c
+++ b/fs/lustre/osc/osc_request.c
@@ -2665,6 +2665,7 @@ int osc_build_rpc(const struct lu_env *env, struct client_obd *cli,
 
 	spin_lock(&cli->cl_loi_list_lock);
 	starting_offset >>= PAGE_SHIFT;
+	ending_offset >>= PAGE_SHIFT;
 	if (cmd == OBD_BRW_READ) {
 		cli->cl_r_in_flight++;
 		lprocfs_oh_tally_log2(&cli->cl_read_page_hist, page_count);
@@ -2681,8 +2682,19 @@ int osc_build_rpc(const struct lu_env *env, struct client_obd *cli,
 	spin_unlock(&cli->cl_loi_list_lock);
 
 	DEBUG_REQ(D_INODE, req, "%d pages, aa %p, now %ur/%dw in flight",
-		  page_count, aa, cli->cl_r_in_flight,
-		  cli->cl_w_in_flight);
+		  page_count, aa, cli->cl_r_in_flight, cli->cl_w_in_flight);
+	if (libcfs_debug & D_IOTRACE) {
+		struct lu_fid fid;
+
+		fid.f_seq = crattr->cra_oa->o_parent_seq;
+		fid.f_oid = crattr->cra_oa->o_parent_oid;
+		fid.f_ver = crattr->cra_oa->o_parent_ver;
+		CDEBUG(D_IOTRACE,
+		       DFID": %d %s pages, start %lld, end %lld, now %ur/%uw in flight\n",
+		       PFID(&fid), page_count,
+		       cmd == OBD_BRW_READ ? "read" : "write", starting_offset,
+		       ending_offset, cli->cl_r_in_flight, cli->cl_w_in_flight);
+	}
 	OBD_FAIL_TIMEOUT(OBD_FAIL_OSC_DELAY_IO, cfs_fail_val);
 
 	ptlrpcd_add_req(req);
-- 
1.8.3.1

