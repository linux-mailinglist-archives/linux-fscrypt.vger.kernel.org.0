Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA4655055B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiFROBO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235115AbiFRNxT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:19 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D51AE7F
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:18 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 40FF213FD;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 3E232E4F1D; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Alexander Boyko <alexander.boyko@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 22/28] lustre: lmv: skip qos for qos_threshold_rr=100
Date:   Sat, 18 Jun 2022 09:52:04 -0400
Message-Id: <1655560330-30743-23-git-send-email-jsimmons@infradead.org>
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

From: Alexander Boyko <alexander.boyko@hpe.com>

Current implementation of qos allocation is called for
every statfs update. It takes lq_rw_sem for write and
recalculate penalties, even whith setting qos_threshold_rr=100.
Which means always use rr allocation. Let's skip unnecessary
locking and calculation for 100% round robin allocation.

HPE-bug-id: LUS-10388
WC-bug-id: https://jira.whamcloud.com/browse/LU-15393
Lustre-commit: 2f23140d5c1396fd0 ("LU-15393 lod: skip qos for qos_threshold_rr=100")
Signed-off-by: Alexander Boyko <alexander.boyko@hpe.com>
Reviewed-on: https://review.whamcloud.com/46388
Reviewed-by: Andrew Perepechko <andrew.perepechko@hpe.com>
Reviewed-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/lu_object.h     |  1 +
 fs/lustre/lmv/lproc_lmv.c         |  5 +++--
 fs/lustre/obdclass/lu_tgt_descs.c | 12 ++++++++----
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/lustre/include/lu_object.h b/fs/lustre/include/lu_object.h
index 3fb40c6..e4dd287c5 100644
--- a/fs/lustre/include/lu_object.h
+++ b/fs/lustre/include/lu_object.h
@@ -1503,6 +1503,7 @@ struct lu_tgt_desc_idx {
 };
 
 /* QoS data for LOD/LMV */
+#define QOS_THRESHOLD_MAX 256 /* should be power of two */
 struct lu_qos {
 	struct list_head	lq_svr_list;	 /* lu_svr_qos list */
 	struct rw_semaphore	lq_rw_sem;
diff --git a/fs/lustre/lmv/lproc_lmv.c b/fs/lustre/lmv/lproc_lmv.c
index b9efae9..6d4e8d9 100644
--- a/fs/lustre/lmv/lproc_lmv.c
+++ b/fs/lustre/lmv/lproc_lmv.c
@@ -158,7 +158,8 @@ static ssize_t qos_threshold_rr_show(struct kobject *kobj,
 					      obd_kset.kobj);
 
 	return scnprintf(buf, PAGE_SIZE, "%u%%\n",
-			(obd->u.lmv.lmv_qos.lq_threshold_rr * 100 + 255) >> 8);
+			(obd->u.lmv.lmv_qos.lq_threshold_rr * 100 +
+			(QOS_THRESHOLD_MAX - 1)) / QOS_THRESHOLD_MAX);
 }
 
 static ssize_t qos_threshold_rr_store(struct kobject *kobj,
@@ -190,7 +191,7 @@ static ssize_t qos_threshold_rr_store(struct kobject *kobj,
 	if (val > 100)
 		return -EINVAL;
 
-	lmv->lmv_qos.lq_threshold_rr = (val << 8) / 100;
+	lmv->lmv_qos.lq_threshold_rr = (val * QOS_THRESHOLD_MAX) / 100;
 	set_bit(LQ_DIRTY, &lmv->lmv_qos.lq_flags);
 
 	return count;
diff --git a/fs/lustre/obdclass/lu_tgt_descs.c b/fs/lustre/obdclass/lu_tgt_descs.c
index 935cff6..51d2e21 100644
--- a/fs/lustre/obdclass/lu_tgt_descs.c
+++ b/fs/lustre/obdclass/lu_tgt_descs.c
@@ -275,11 +275,13 @@ int lu_tgt_descs_init(struct lu_tgt_descs *ltd, bool is_mdt)
 		ltd->ltd_lmv_desc.ld_pattern = LMV_HASH_TYPE_DEFAULT;
 		ltd->ltd_qos.lq_prio_free = LMV_QOS_DEF_PRIO_FREE * 256 / 100;
 		ltd->ltd_qos.lq_threshold_rr =
-			LMV_QOS_DEF_THRESHOLD_RR_PCT * 256 / 100;
+			LMV_QOS_DEF_THRESHOLD_RR_PCT *
+			QOS_THRESHOLD_MAX / 100;
 	} else {
 		ltd->ltd_qos.lq_prio_free = LOV_QOS_DEF_PRIO_FREE * 256 / 100;
 		ltd->ltd_qos.lq_threshold_rr =
-			LOV_QOS_DEF_THRESHOLD_RR_PCT * 256 / 100;
+			LOV_QOS_DEF_THRESHOLD_RR_PCT *
+			QOS_THRESHOLD_MAX / 100;
 	}
 
 	return 0;
@@ -568,8 +570,10 @@ int ltd_qos_penalties_calc(struct lu_tgt_descs *ltd)
 	 * creation performance
 	 */
 	clear_bit(LQ_SAME_SPACE, &qos->lq_flags);
-	if ((ba_max * (256 - qos->lq_threshold_rr)) >> 8 < ba_min &&
-	    (ia_max * (256 - qos->lq_threshold_rr)) >> 8 < ia_min) {
+	if (((ba_max * (QOS_THRESHOLD_MAX - qos->lq_threshold_rr)) /
+	    QOS_THRESHOLD_MAX) < ba_min &&
+	    ((ia_max * (QOS_THRESHOLD_MAX - qos->lq_threshold_rr)) /
+	    QOS_THRESHOLD_MAX) < ia_min) {
 		set_bit(LQ_SAME_SPACE, &qos->lq_flags);
 		/* Reset weights for the next time we enter qos mode */
 		set_bit(LQ_RESET, &qos->lq_flags);
-- 
1.8.3.1

