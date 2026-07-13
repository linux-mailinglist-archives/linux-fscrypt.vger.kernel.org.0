Return-Path: <linux-fscrypt+bounces-1766-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id isb7BfdQVGpSkgMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1766-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:44:07 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A10F5746BF6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:44:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y5W71pCc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1766-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1766-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 669593041A2C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DE535B63B;
	Mon, 13 Jul 2026 02:39:49 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD253546C1;
	Mon, 13 Jul 2026 02:39:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910388; cv=none; b=ub+Aban/4Eht5mTUFqNIIAd3alL8wlfZegs0DvtmqUQ8QLUUVWkQgX+8nsbOTjYgs9lVdCAfemO7jd5jhRY0JH8UqosxYjwtuEIWt3spV93O0kXy0P2hesFEOWcNTi+8ufQJm1gF9oskMbb4/wbux16afcRgWGHxWA/cjgDlL4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910388; c=relaxed/simple;
	bh=893Gv/6olIck7ZNN1dhPkzk6zBkha5BkIyWYbHITmU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC4MI9is+KpTMLL1oOqO8Alo5RbchltEX1fDO+fJIMKcinyt+WQNNuvHAbZwd+BdZQtJiAHbgKOu+MQd5UW1pesLoQvMpa9EKGUMmmtabJynfNnd9mPwKeWdpf+AaRoznjfpsEugM70P1sYGhvNXQQitYWHMGBszRNL6pelDbMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y5W71pCc; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4A81F00A3E;
	Mon, 13 Jul 2026 02:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910386;
	bh=J5lMqtVI9y4q28CYeXopPGl3o5JEbpZ2Hmblb9x1Xmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5W71pCc2oPPvWxaduUd81NIPKGVuhBATznBLJccaYVG4ngMLTA+0C/44XcPrr4hr
	 KlVQLBeqhFmMvV92ely+j/FeA3HcOz0HBKyNVCSJQZcNJF+o1wkSx2m3Ig+0X/2qvT
	 li5WOEkC6AVrtkCRnskVO4drvbPsUY1YJ/gIiNAfevNLL4mYxPIiFoya9EWCkZ43kZ
	 6oUEAWerOcpu2zzWDLuaKmMXrByVPRugfk6uqf4dLtoeCGaEErn1CITInfPj9kqS5W
	 kgrpGonS0ZfIsY3d4ttPWuhy1/ypQmX9lWRLGlG0IWkPJe9uy4Z58vkT7XIwDLN7zE
	 rmdc4znCnniSw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 09/17] ext4: Further de-generalize the bio postprocessing code
Date: Sun, 12 Jul 2026 22:37:00 -0400
Message-ID: <20260713023708.9245-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713023708.9245-1-ebiggers@kernel.org>
References: <20260713023708.9245-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1766-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A10F5746BF6

Since the bio postprocessing code in fs/ext4/readpage.c is now used only
for fsverity, rename things accordingly.

Also:

- Don't create the caches at all when !CONFIG_FS_VERITY.
- Remove the unused inode argument from ext4_set_verity_work().

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/ext4/ext4.h     |  4 +--
 fs/ext4/readpage.c | 65 ++++++++++++++++++++++------------------------
 fs/ext4/super.c    |  6 ++---
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 920a8ec1b948..489ed6dcee52 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3829,8 +3829,8 @@ static inline void ext4_set_de_type(struct super_block *sb,
 /* readpages.c */
 int ext4_read_folio(struct file *file, struct folio *folio);
 void ext4_readahead(struct readahead_control *rac);
-extern int __init ext4_init_post_read_processing(void);
-extern void ext4_exit_post_read_processing(void);
+int __init ext4_init_verity_caches(void);
+void ext4_exit_verity_caches(void);
 
 /* symlink.c */
 extern const struct inode_operations ext4_encrypted_symlink_inode_operations;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 8af183798a33..c7b6cdb2e124 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -47,12 +47,12 @@
 #include "ext4.h"
 #include <trace/events/ext4.h>
 
-#define NUM_PREALLOC_POST_READ_CTXS	128
+#define NUM_VERITY_WORKS 128
 
-static struct kmem_cache *bio_post_read_ctx_cache;
-static mempool_t *bio_post_read_ctx_pool;
+static struct kmem_cache *ext4_verity_work_cache;
+static mempool_t *ext4_verity_work_pool;
 
-struct bio_post_read_ctx {
+struct ext4_verity_work {
 	struct bio *bio;
 	struct fsverity_info *vi;
 	struct work_struct work;
@@ -65,22 +65,22 @@ static void __read_end_io(struct bio *bio)
 	bio_for_each_folio_all(fi, bio)
 		folio_end_read(fi.folio, bio->bi_status == 0);
 	if (bio->bi_private)
-		mempool_free(bio->bi_private, bio_post_read_ctx_pool);
+		mempool_free(bio->bi_private, ext4_verity_work_pool);
 	bio_put(bio);
 }
 
 static void verity_work(struct work_struct *work)
 {
-	struct bio_post_read_ctx *ctx =
-		container_of(work, struct bio_post_read_ctx, work);
+	struct ext4_verity_work *ctx =
+		container_of(work, struct ext4_verity_work, work);
 	struct bio *bio = ctx->bio;
 	struct fsverity_info *vi = ctx->vi;
 
 	/*
-	 * Free the bio_post_read_ctx right away, since it's no longer needed.
+	 * Free the ext4_verity_work right away, since it's no longer needed.
 	 * This relieves the pressure on the mempool as much as possible.
 	 */
-	mempool_free(ctx, bio_post_read_ctx_pool);
+	mempool_free(ctx, ext4_verity_work_pool);
 	bio->bi_private = NULL;
 
 	fsverity_verify_bio(vi, bio);
@@ -88,12 +88,6 @@ static void verity_work(struct work_struct *work)
 	__read_end_io(bio);
 }
 
-static bool bio_post_read_required(struct bio *bio)
-{
-	return IS_ENABLED(CONFIG_FS_VERITY) && bio->bi_private &&
-	       !bio->bi_status;
-}
-
 /*
  * I/O completion handler for multipage BIOs.
  *
@@ -108,8 +102,9 @@ static bool bio_post_read_required(struct bio *bio)
  */
 static void mpage_end_io(struct bio *bio)
 {
-	if (bio_post_read_required(bio)) {
-		struct bio_post_read_ctx *ctx = bio->bi_private;
+	if (IS_ENABLED(CONFIG_FS_VERITY) && bio->bi_private &&
+	    !bio->bi_status) {
+		struct ext4_verity_work *ctx = bio->bi_private;
 
 		INIT_WORK(&ctx->work, verity_work);
 		fsverity_enqueue_verify_work(&ctx->work);
@@ -118,14 +113,12 @@ static void mpage_end_io(struct bio *bio)
 	__read_end_io(bio);
 }
 
-static void ext4_set_bio_post_read_ctx(struct bio *bio,
-				       const struct inode *inode,
-				       struct fsverity_info *vi)
+static void ext4_set_verity_work(struct bio *bio, struct fsverity_info *vi)
 {
 	if (vi) {
 		/* Due to the mempool, this never fails. */
-		struct bio_post_read_ctx *ctx =
-			mempool_alloc(bio_post_read_ctx_pool, GFP_NOFS);
+		struct ext4_verity_work *ctx =
+			mempool_alloc(ext4_verity_work_pool, GFP_NOFS);
 
 		ctx->bio = bio;
 		ctx->vi = vi;
@@ -289,7 +282,7 @@ static int ext4_mpage_readpages(struct inode *inode, struct fsverity_info *vi,
 			bio = bio_alloc(bdev, bio_max_segs(nr_pages),
 					REQ_OP_READ, GFP_KERNEL);
 			fscrypt_set_bio_crypt_ctx(bio, inode, pos, GFP_KERNEL);
-			ext4_set_bio_post_read_ctx(bio, inode, vi);
+			ext4_set_verity_work(bio, vi);
 			bio->bi_iter.bi_sector = first_block << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			if (rac)
@@ -363,27 +356,31 @@ void ext4_readahead(struct readahead_control *rac)
 	ext4_mpage_readpages(inode, vi, rac, NULL);
 }
 
-int __init ext4_init_post_read_processing(void)
+int __init ext4_init_verity_caches(void)
 {
-	bio_post_read_ctx_cache = KMEM_CACHE(bio_post_read_ctx, SLAB_RECLAIM_ACCOUNT);
+	if (!IS_ENABLED(CONFIG_FS_VERITY))
+		return 0;
+	ext4_verity_work_cache =
+		KMEM_CACHE(ext4_verity_work, SLAB_RECLAIM_ACCOUNT);
 
-	if (!bio_post_read_ctx_cache)
+	if (!ext4_verity_work_cache)
 		goto fail;
-	bio_post_read_ctx_pool =
-		mempool_create_slab_pool(NUM_PREALLOC_POST_READ_CTXS,
-					 bio_post_read_ctx_cache);
-	if (!bio_post_read_ctx_pool)
+	ext4_verity_work_pool = mempool_create_slab_pool(
+		NUM_VERITY_WORKS, ext4_verity_work_cache);
+	if (!ext4_verity_work_pool)
 		goto fail_free_cache;
 	return 0;
 
 fail_free_cache:
-	kmem_cache_destroy(bio_post_read_ctx_cache);
+	kmem_cache_destroy(ext4_verity_work_cache);
 fail:
 	return -ENOMEM;
 }
 
-void ext4_exit_post_read_processing(void)
+void ext4_exit_verity_caches(void)
 {
-	mempool_destroy(bio_post_read_ctx_pool);
-	kmem_cache_destroy(bio_post_read_ctx_cache);
+	if (!IS_ENABLED(CONFIG_FS_VERITY))
+		return;
+	mempool_destroy(ext4_verity_work_pool);
+	kmem_cache_destroy(ext4_verity_work_cache);
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 245f67d10ded..cb9ca0dc4664 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -7531,7 +7531,7 @@ static int __init ext4_init_fs(void)
 	if (err)
 		goto out7;
 
-	err = ext4_init_post_read_processing();
+	err = ext4_init_verity_caches();
 	if (err)
 		goto out6;
 
@@ -7580,7 +7580,7 @@ static int __init ext4_init_fs(void)
 out4:
 	ext4_exit_pageio();
 out5:
-	ext4_exit_post_read_processing();
+	ext4_exit_verity_caches();
 out6:
 	ext4_exit_pending();
 out7:
@@ -7601,7 +7601,7 @@ static void __exit ext4_exit_fs(void)
 	ext4_exit_sysfs();
 	ext4_exit_system_zone();
 	ext4_exit_pageio();
-	ext4_exit_post_read_processing();
+	ext4_exit_verity_caches();
 	ext4_exit_es();
 	ext4_exit_pending();
 }
-- 
2.55.0


