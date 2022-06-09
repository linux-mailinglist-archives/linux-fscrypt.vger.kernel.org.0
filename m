Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB0A544C0F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbiFIMdd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245425AbiFIMda (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:30 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12501192AB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:27 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 3D405EF3;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 31CF9D43A3; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Etienne AUJAMES <etienne.aujames@cea.fr>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 04/18] lustre: llog: read canceled records in llog_backup
Date:   Thu,  9 Jun 2022 08:33:00 -0400
Message-Id: <1654777994-29806-5-git-send-email-jsimmons@infradead.org>
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

From: Etienne AUJAMES <etienne.aujames@cea.fr>

llog_backup() do not reproduce index "holes" in the generated copy.
This could result to a llog copy indexes different from the source.
Then it might confuse the configuration update mechanism that rely on
indexes between the MGS source and the target copy.

This index gaps can be caused by "lctl --device MGS llog_cancel".

This patch add "raw" read mode to llog_process* to read canceled
records.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15000
Lustre-commit: d8e2723b4e9409954 ("LU-15000 llog: read canceled records in llog_backup")
Signed-off-by: Etienne AUJAMES <etienne.aujames@cea.fr>
Reviewed-on: https://review.whamcloud.com/46552
Reviewed-by: Dominique Martinet <qhufhnrynczannqp.f@noclue.notk.org>
Reviewed-by: DELBARY Gael <gael.delbary@cea.fr>
Reviewed-by: Stephane Thiell <sthiell@stanford.edu>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/lustre_log.h  | 11 +++++++++++
 fs/lustre/obdclass/llog.c       | 22 +++++++++++++++++-----
 fs/lustre/obdclass/llog_cat.c   |  5 ++++-
 fs/lustre/obdclass/obd_config.c |  1 +
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/lustre/include/lustre_log.h b/fs/lustre/include/lustre_log.h
index 1fc7729..2e43d56 100644
--- a/fs/lustre/include/lustre_log.h
+++ b/fs/lustre/include/lustre_log.h
@@ -94,6 +94,13 @@ int llog_open(const struct lu_env *env, struct llog_ctxt *ctxt,
 /* llog_process flags */
 #define LLOG_FLAG_NODEAMON 0x0001
 
+/* llog read mode, LLOG_READ_MODE_RAW will process llog canceled records */
+enum llog_read_mode {
+	LLOG_READ_MODE_NORMAL	= 0x0000,
+	LLOG_READ_MODE_RAW	= 0x0001,
+};
+
+
 /* llog_cat.c - catalog api */
 struct llog_process_data {
 	/**
@@ -122,6 +129,10 @@ struct llog_process_cat_data {
 	 * Temporary stored last_idx while scanning log.
 	 */
 	int			lpcd_last_idx;
+	/**
+	 * llog read mode
+	 */
+	enum llog_read_mode	lpcd_read_mode;
 };
 
 struct thandle;
diff --git a/fs/lustre/obdclass/llog.c b/fs/lustre/obdclass/llog.c
index acede87..0cc64ce 100644
--- a/fs/lustre/obdclass/llog.c
+++ b/fs/lustre/obdclass/llog.c
@@ -256,6 +256,15 @@ int llog_verify_record(const struct llog_handle *llh, struct llog_rec_hdr *rec)
 	return 0;
 }
 
+static inline bool llog_is_index_skipable(int idx, struct llog_log_hdr *llh,
+					  struct llog_process_cat_data *cd)
+{
+	if (cd && (cd->lpcd_read_mode & LLOG_READ_MODE_RAW))
+		return false;
+
+	return !test_bit_le(idx, LLOG_HDR_BITMAP(llh));
+}
+
 static int llog_process_thread(void *arg)
 {
 	struct llog_process_info *lpi = arg;
@@ -291,6 +300,8 @@ static int llog_process_thread(void *arg)
 	}
 	if (cd && cd->lpcd_last_idx)
 		last_index = cd->lpcd_last_idx;
+	else if (cd && (cd->lpcd_read_mode & LLOG_READ_MODE_RAW))
+		last_index = loghandle->lgh_last_idx;
 	else
 		last_index = LLOG_HDR_BITMAP_SIZE(llh) - 1;
 
@@ -303,7 +314,7 @@ static int llog_process_thread(void *arg)
 
 		/* skip records not set in bitmap */
 		while (index <= last_index &&
-		       !test_bit_le(index, LLOG_HDR_BITMAP(llh)))
+		       llog_is_index_skipable(index, llh, cd))
 			++index;
 
 		if (index > last_index)
@@ -451,8 +462,8 @@ static int llog_process_thread(void *arg)
 			loghandle->lgh_cur_offset = (char *)rec - (char *)buf +
 						    chunk_offset;
 
-			/* if set, process the callback on this record */
-			if (test_bit_le(index, LLOG_HDR_BITMAP(llh))) {
+			/* if needed, process the callback on this record */
+			if (!llog_is_index_skipable(index, llh, cd)) {
 				rc = lpi->lpi_cb(lpi->lpi_env, loghandle, rec,
 						 lpi->lpi_cbdata);
 				last_called_index = index;
@@ -522,11 +533,12 @@ int llog_process_or_fork(const struct lu_env *env,
 	lpi->lpi_catdata = catdata;
 
 	CDEBUG(D_OTHER,
-	       "Processing " DFID " flags 0x%03x startcat %d startidx %d first_idx %d last_idx %d\n",
+	       "Processing " DFID " flags 0x%03x startcat %d startidx %d first_idx %d last_idx %d read_mode %d\n",
 	       PFID(&loghandle->lgh_id.lgl_oi.oi_fid), flags,
 	       (flags & LLOG_F_IS_CAT) && d ? d->lpd_startcat : -1,
 	       (flags & LLOG_F_IS_CAT) && d ? d->lpd_startidx : -1,
-	       cd ? cd->lpcd_first_idx : -1, cd ? cd->lpcd_last_idx : -1);
+	       cd ? cd->lpcd_first_idx : -1, cd ? cd->lpcd_last_idx : -1,
+	       cd ? cd->lpcd_read_mode : -1);
 
 	if (fork) {
 		struct task_struct *task;
diff --git a/fs/lustre/obdclass/llog_cat.c b/fs/lustre/obdclass/llog_cat.c
index 7f55895..753422b 100644
--- a/fs/lustre/obdclass/llog_cat.c
+++ b/fs/lustre/obdclass/llog_cat.c
@@ -197,6 +197,7 @@ static int llog_cat_process_cb(const struct lu_env *env,
 	else if (d->lpd_startidx > 0) {
 		struct llog_process_cat_data cd;
 
+		cd.lpcd_read_mode = LLOG_READ_MODE_NORMAL;
 		cd.lpcd_first_idx = d->lpd_startidx;
 		cd.lpcd_last_idx = 0;
 		rc = llog_process_or_fork(env, llh, d->lpd_cb, d->lpd_data,
@@ -231,7 +232,9 @@ static int llog_cat_process_or_fork(const struct lu_env *env,
 	d.lpd_startidx = startidx;
 
 	if (llh->llh_cat_idx > cat_llh->lgh_last_idx) {
-		struct llog_process_cat_data cd;
+		struct llog_process_cat_data cd = {
+			.lpcd_read_mode = LLOG_READ_MODE_NORMAL
+		};
 
 		CWARN("%s: catlog " DFID " crosses index zero\n",
 		      loghandle2name(cat_llh),
diff --git a/fs/lustre/obdclass/obd_config.c b/fs/lustre/obdclass/obd_config.c
index cb70ed5..4db7399 100644
--- a/fs/lustre/obdclass/obd_config.c
+++ b/fs/lustre/obdclass/obd_config.c
@@ -1401,6 +1401,7 @@ int class_config_parse_llog(const struct lu_env *env, struct llog_ctxt *ctxt,
 {
 	struct llog_process_cat_data cd = {
 		.lpcd_first_idx = 0,
+		.lpcd_read_mode = LLOG_READ_MODE_NORMAL,
 	};
 	struct llog_handle *llh;
 	llog_cb_t callback;
-- 
1.8.3.1

