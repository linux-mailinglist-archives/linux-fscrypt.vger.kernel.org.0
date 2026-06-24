Return-Path: <linux-fscrypt+bounces-1659-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tJcCK3JmO2pxXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1659-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:09:06 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 058376BB67E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:09:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=neOJRwaH;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1659-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1659-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80019310C7DD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B24E3822AF;
	Wed, 24 Jun 2026 05:06:06 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BB23815D9;
	Wed, 24 Jun 2026 05:06:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277566; cv=none; b=uA1geAHYBt3+NTYJNzTTmaq9rEgTGd1ikqe1ijN2TgcxmwFMauz6YH9YnHaIWPyPzTyY0Bn8vUMiDJZ4VNyBZ0aH7yqCNcpsFNWC2IVVVz32hBr6B7p6O6LmaQk1lKu8fuG4GJ4CTBgce/GQh1tIKdhXJApWqVSMHImNOHGuQMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277566; c=relaxed/simple;
	bh=0AQMR9LnYPMmGlQIPJXyQsmFiCCJeWmH0pJG4cVBIqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijVLBIRHMWWNdiqd0UOOe4p/0SNPJXzFxVY1kM3Jqu9j9xJf3VM+p7nJuOWxSGh88ZUfjYdlZa8sR1CLj2tgI+W58Q1PXPjF9wd0rD5oF/EVLqjmlbsujS6fa/eAOvtlsY93fM+xBdy/ihIcm/wFGaNxOvtqA6sYTmKeKoUlDg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neOJRwaH; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798EF1F00AC4;
	Wed, 24 Jun 2026 05:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277564;
	bh=ebBXpaAjXk49KLNuYNTlNcNswdiZ5gqBVZ+LrAJfT1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neOJRwaHGAGxAApHKWDtOWnCgMo880nQkDcqwUso4QRaoZNvbLBd8W327XRPDAjvs
	 qrPylWNKjSWi7RVCblirUeEF3+BHyAODk9O6vZsf/Ng/1IrGJbnHemVVhhpg4b6Z0e
	 5Ljjqea8DP6SaO3OAJk6PDw+IzfcAtbCtGLHh1Nz3VL9GKjdPxvRabIMZsKjx8L7sa
	 01mShRsSGaGptFrNBmSatfuF2BNUfABcGpxGGWfjChYJEc9w5qREN5sNVthgrovOkH
	 IweiUWOEBPSY4n1USngleRdgPjfigobJjGM4MhHGy0eKo1MsOc+V7xrduAc7RsS+ZG
	 oBXJZw9vx7emA==
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
Subject: [PATCH 10/16] fs/buffer: Remove fs-layer decryption code
Date: Tue, 23 Jun 2026 22:03:28 -0700
Message-ID: <20260624050334.124606-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624050334.124606-1-ebiggers@kernel.org>
References: <20260624050334.124606-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1659-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 058376BB67E

Now that fscrypt's file contents en/decryption is always implemented
using blk-crypto when the filesystem is block-based, the fs-layer
decryption code in fs/buffer.c is unused code.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/buffer.c | 45 ++++++++-------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 9af5f061a1f8..21dd9596a941 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -334,82 +334,53 @@ static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 
 still_busy:
 	spin_unlock_irqrestore(&first->b_uptodate_lock, flags);
 }
 
-struct postprocess_bh_ctx {
+struct verify_bh_ctx {
 	struct work_struct work;
 	struct buffer_head *bh;
 	struct fsverity_info *vi;
 };
 
 static void verify_bh(struct work_struct *work)
 {
-	struct postprocess_bh_ctx *ctx =
-		container_of(work, struct postprocess_bh_ctx, work);
+	struct verify_bh_ctx *ctx =
+		container_of(work, struct verify_bh_ctx, work);
 	struct buffer_head *bh = ctx->bh;
 	bool valid;
 
 	valid = fsverity_verify_blocks(ctx->vi, bh->b_folio, bh->b_size,
 				       bh_offset(bh));
 	end_buffer_async_read(bh, valid);
 	kfree(ctx);
 }
 
-static void decrypt_bh(struct work_struct *work)
-{
-	struct postprocess_bh_ctx *ctx =
-		container_of(work, struct postprocess_bh_ctx, work);
-	struct buffer_head *bh = ctx->bh;
-	int err;
-
-	err = fscrypt_decrypt_pagecache_blocks(bh->b_folio, bh->b_size,
-					       bh_offset(bh));
-	if (err == 0 && ctx->vi) {
-		/*
-		 * We use different work queues for decryption and for verity
-		 * because verity may require reading metadata pages that need
-		 * decryption, and we shouldn't recurse to the same workqueue.
-		 */
-		INIT_WORK(&ctx->work, verify_bh);
-		fsverity_enqueue_verify_work(&ctx->work);
-		return;
-	}
-	end_buffer_async_read(bh, err == 0);
-	kfree(ctx);
-}
-
 /*
  * I/O completion handler for block_read_full_folio() - folios
  * which come unlocked at the end of I/O.
  */
 static void bh_end_async_read(struct bio *bio)
 {
 	struct buffer_head *bh;
 	bool uptodate = bio_endio_bh(bio, &bh);
 	struct inode *inode = bh->b_folio->mapping->host;
-	bool decrypt = fscrypt_inode_uses_fs_layer_crypto(inode);
 	struct fsverity_info *vi = NULL;
 
 	/* needed by ext4 */
 	if (bh->b_folio->index < DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
 		vi = fsverity_get_info(inode);
 
-	/* Decrypt (with fscrypt) and/or verify (with fsverity) if needed. */
-	if (uptodate && (decrypt || vi)) {
-		struct postprocess_bh_ctx *ctx = kmalloc_obj(*ctx, GFP_ATOMIC);
+	/* Verify (with fsverity) if needed. */
+	if (vi && uptodate) {
+		struct verify_bh_ctx *ctx = kmalloc_obj(*ctx, GFP_ATOMIC);
 
 		if (ctx) {
 			ctx->bh = bh;
 			ctx->vi = vi;
-			if (decrypt) {
-				INIT_WORK(&ctx->work, decrypt_bh);
-				fscrypt_enqueue_decrypt_work(&ctx->work);
-			} else {
-				INIT_WORK(&ctx->work, verify_bh);
-				fsverity_enqueue_verify_work(&ctx->work);
-			}
+			INIT_WORK(&ctx->work, verify_bh);
+			fsverity_enqueue_verify_work(&ctx->work);
 			return;
 		}
 		uptodate = false;
 	}
 	end_buffer_async_read(bh, uptodate);
-- 
2.54.0


