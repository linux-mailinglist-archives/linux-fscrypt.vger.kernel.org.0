Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF68550535
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiFRNwr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233897AbiFRNwf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:35 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED1C1D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:31 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 0A8A113D6;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 0352ADC803; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Bobi Jam <bobijam@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 08/28] lustre: ec: add necessary structure member for EC file
Date:   Sat, 18 Jun 2022 09:51:50 -0400
Message-Id: <1655560330-30743-9-git-send-email-jsimmons@infradead.org>
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

From: Bobi Jam <bobijam@whamcloud.com>

Added basic structure members for erasure-coding layout.

WC-bug-id: https://jira.whamcloud.com/browse/LU-12186
Lustre-commit: 4c4790088995fa690 ("LU-12186 ec: add necessary structure member for EC file")
Signed-off-by: Bobi Jam <bobijam@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/38319
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Bobi Jam <bobijam@hotmail.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/ptlrpc/pack_generic.c         |  4 ++++
 fs/lustre/ptlrpc/wiretest.c             | 24 ++++++++++++++++++++----
 include/uapi/linux/lustre/lustre_user.h | 20 +++++++++++++++++---
 3 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/fs/lustre/ptlrpc/pack_generic.c b/fs/lustre/ptlrpc/pack_generic.c
index f075188e..9acea24 100644
--- a/fs/lustre/ptlrpc/pack_generic.c
+++ b/fs/lustre/ptlrpc/pack_generic.c
@@ -2129,8 +2129,10 @@ void lustre_swab_lov_comp_md_v1(struct lov_comp_md_v1 *lum)
 	__swab16s(&lum->lcm_flags);
 	__swab16s(&lum->lcm_entry_count);
 	__swab16s(&lum->lcm_mirror_count);
+	/* no need to swab lcm_ec_count */
 	BUILD_BUG_ON(offsetof(typeof(*lum), lcm_padding1) == 0);
 	BUILD_BUG_ON(offsetof(typeof(*lum), lcm_padding2) == 0);
+	BUILD_BUG_ON(offsetof(typeof(*lum), lcm_padding3) == 0);
 
 	for (i = 0; i < ent_count; i++) {
 		struct lov_user_md_v1 *v1;
@@ -2153,6 +2155,8 @@ void lustre_swab_lov_comp_md_v1(struct lov_comp_md_v1 *lum)
 		__swab32s(&ent->lcme_offset);
 		__swab32s(&ent->lcme_size);
 		__swab32s(&ent->lcme_layout_gen);
+		/* no need to swab lcme_dstripe_count */
+		/* no need to swab lcme_cstripe_count */
 		BUILD_BUG_ON(offsetof(typeof(*ent), lcme_padding_1) == 0);
 
 		v1 = (struct lov_user_md_v1 *)((char *)lum + off);
diff --git a/fs/lustre/ptlrpc/wiretest.c b/fs/lustre/ptlrpc/wiretest.c
index 687a54d..81e0485 100644
--- a/fs/lustre/ptlrpc/wiretest.c
+++ b/fs/lustre/ptlrpc/wiretest.c
@@ -1654,9 +1654,17 @@ void lustre_assert_wire_constants(void)
 		 (long long)(int)offsetof(struct lov_comp_md_entry_v1, lcme_timestamp));
 	LASSERTF((int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_timestamp) == 8, "found %lld\n",
 		 (long long)(int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_timestamp));
-	LASSERTF((int)offsetof(struct lov_comp_md_entry_v1, lcme_padding_1) == 44, "found %lld\n",
+	LASSERTF((int)offsetof(struct lov_comp_md_entry_v1, lcme_dstripe_count) == 44, "found %lld\n",
+		 (long long)(int)offsetof(struct lov_comp_md_entry_v1, lcme_dstripe_count));
+	LASSERTF((int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_dstripe_count) == 1, "found %lld\n",
+		 (long long)(int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_dstripe_count));
+	LASSERTF((int)offsetof(struct lov_comp_md_entry_v1, lcme_cstripe_count) == 45, "found %lld\n",
+		 (long long)(int)offsetof(struct lov_comp_md_entry_v1, lcme_cstripe_count));
+	LASSERTF((int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_cstripe_count) == 1, "found %lld\n",
+		 (long long)(int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_cstripe_count));
+	LASSERTF((int)offsetof(struct lov_comp_md_entry_v1, lcme_padding_1) == 46, "found %lld\n",
 		 (long long)(int)offsetof(struct lov_comp_md_entry_v1, lcme_padding_1));
-	LASSERTF((int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_padding_1) == 4, "found %lld\n",
+	LASSERTF((int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_padding_1) == 2, "found %lld\n",
 		 (long long)(int)sizeof(((struct lov_comp_md_entry_v1 *)0)->lcme_padding_1));
 	BUILD_BUG_ON(LCME_FL_STALE != 0x00000001);
 	BUILD_BUG_ON(LCME_FL_PREF_RD != 0x00000002);
@@ -1695,9 +1703,17 @@ void lustre_assert_wire_constants(void)
 		 (long long)(int)offsetof(struct lov_comp_md_v1, lcm_mirror_count));
 	LASSERTF((int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_mirror_count) == 2, "found %lld\n",
 		 (long long)(int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_mirror_count));
-	LASSERTF((int)offsetof(struct lov_comp_md_v1, lcm_padding1) == 18, "found %lld\n",
+	LASSERTF((int)offsetof(struct lov_comp_md_v1, lcm_ec_count) == 18, "found %lld\n",
+		 (long long)(int)offsetof(struct lov_comp_md_v1, lcm_ec_count));
+	LASSERTF((int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_ec_count) == 1, "found %lld\n",
+		 (long long)(int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_ec_count));
+	LASSERTF((int)offsetof(struct lov_comp_md_v1, lcm_padding3) == 19, "found %lld\n",
+		 (long long)(int)offsetof(struct lov_comp_md_v1, lcm_padding3));
+	LASSERTF((int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_padding3) == 1, "found %lld\n",
+		 (long long)(int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_padding3));
+	LASSERTF((int)offsetof(struct lov_comp_md_v1, lcm_padding1) == 20, "found %lld\n",
 		 (long long)(int)offsetof(struct lov_comp_md_v1, lcm_padding1));
-	LASSERTF((int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_padding1) == 6, "found %lld\n",
+	LASSERTF((int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_padding1) == 4, "found %lld\n",
 		 (long long)(int)sizeof(((struct lov_comp_md_v1 *)0)->lcm_padding1));
 	LASSERTF((int)offsetof(struct lov_comp_md_v1, lcm_padding2) == 24, "found %lld\n",
 		 (long long)(int)offsetof(struct lov_comp_md_v1, lcm_padding2));
diff --git a/include/uapi/linux/lustre/lustre_user.h b/include/uapi/linux/lustre/lustre_user.h
index fa01c28..ee789f2 100644
--- a/include/uapi/linux/lustre/lustre_user.h
+++ b/include/uapi/linux/lustre/lustre_user.h
@@ -564,6 +564,7 @@ enum lov_comp_md_entry_flags {
 	LCME_FL_INIT		= 0x00000010,	/* instantiated */
 	LCME_FL_NOSYNC		= 0x00000020,	/* FLR: no sync for the mirror */
 	LCME_FL_EXTENSION	= 0x00000040,	/* extension comp, never init */
+	LCME_FL_PARITY		= 0x00000080,	/* EC: a parity code component */
 	LCME_FL_NEG		= 0x80000000,	/* used to indicate a negative
 						 * flag, won't be stored on disk
 						 */
@@ -596,14 +597,24 @@ enum lcme_id {
 struct lov_comp_md_entry_v1 {
 	__u32			lcme_id;	/* unique id of component */
 	__u32			lcme_flags;	/* LCME_FL_XXX */
-	struct lu_extent	lcme_extent;	/* file extent for component */
+	/* file extent for component. If it's an EC code component, its flags
+	 * contains LCME_FL_PARITY, and its extent covers the same extent of
+	 * its corresponding data component.
+	 */
+	struct lu_extent	lcme_extent;
 	__u32			lcme_offset;	/* offset of component blob,
 						 * start from lov_comp_md_v1
 						 */
 	__u32			lcme_size;	/* size of component blob */
 	__u32			lcme_layout_gen;
 	__u64			lcme_timestamp;	/* snapshot time if applicable*/
-	__u32			lcme_padding_1;
+	__u8			lcme_dstripe_count;	/* data stripe count,
+							 * k value in EC
+							 */
+	__u8			lcme_cstripe_count;	/* code stripe count,
+							 * p value in EC
+							 */
+	__u16			lcme_padding_1;
 } __attribute__((packed));
 
 #define SEQ_ID_MAX		0x0000FFFF
@@ -645,7 +656,10 @@ struct lov_comp_md_v1 {
 	 * so that non-flr files will have value 0 meaning 1 mirror.
 	 */
 	__u16	lcm_mirror_count;
-	__u16	lcm_padding1[3];
+	/* code components count, non-EC file contains 0 ec_count */
+	__u8	lcm_ec_count;
+	__u8	lcm_padding3[1];
+	__u16	lcm_padding1[2];
 	__u64	lcm_padding2;
 	struct lov_comp_md_entry_v1 lcm_entries[0];
 } __attribute__((packed));
-- 
1.8.3.1

