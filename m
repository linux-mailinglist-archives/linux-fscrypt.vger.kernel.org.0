Return-Path: <linux-fscrypt+bounces-1661-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id miWqEqpmO2qNXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1661-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:10:02 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 966C66BB6BD
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:10:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SWkacxRR;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1661-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1661-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 483C23134C2F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3AA9382F1C;
	Wed, 24 Jun 2026 05:06:07 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB5381AEF;
	Wed, 24 Jun 2026 05:06:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277567; cv=none; b=c1srrjDw+UBd1glYzY7/Zrf1CDjuK/UMY4wDlT/K4KiwAhj6lyhxSx6WreipbQ/evz/uu00fRAO5MDHeLtlPnOTkQ4EOP9TwsQ2rIh8on+tuICG4sb97/hMaXLWCVO4kfDNPCTsj73hm6mL6swE2JxSazTqU6JXtHiNujlKTDsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277567; c=relaxed/simple;
	bh=cJRwScJeeXOGgTWzzHYCCWG5mg8NJV4unF0inbcDKWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwZnKkxBvERxg7QkvBoX1LxkG4wiyaDeogD/TSS4jIjRSZKxK4s7ii03Dm03RuDUxR+8oL/6lF/vtpmVAu6vJgFzXS1ya6neozrMG6zNQJNf9e7kYnyVv8BJWXmJ0E9OF8kLKnGfbC/RWUPDyUMbtk6e/aPueOhPsdKs3UEoauw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWkacxRR; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BE91F00A3F;
	Wed, 24 Jun 2026 05:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277566;
	bh=IFP11NYXgmlrWphHBvNAvyfYE4d+s/tUyAJE1tBe8dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SWkacxRRt70//Lub46ZvIgySBsaG5i3QX+Nvn8zFdMH5/7HA+5ATdIR8+tZsNjmdl
	 tG1WfD4BAKYSNromdGvDtJy5LFuzmZUe+JgS3GiwDe/7JcjWNRwqGgx1mDjbYSwfsG
	 99lHVmP80aDbesZ16urpnuhBHHg/sxbT/Y1lcNyVHLSsM2jm4vHwiZ7sXOu5uT6Sj2
	 9iEPX3BuJSJ8zazA7diay48tpAzcLP9TmWNd8yqdTM1CzXkH6J9Ev+h4YMEsQ7pKjj
	 DAjwp/abDis88JHyUvHTSkQX/JG5PNoY8EnATdgYjRF2VJF/QJ4LKYz9tkvaMOp9wN
	 p7TzAjsAl0UvQ==
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
Subject: [PATCH 12/16] fscrypt: Remove fscrypt_dio_supported()
Date: Tue, 23 Jun 2026 22:03:30 -0700
Message-ID: <20260624050334.124606-13-ebiggers@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-1661-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 966C66BB6BD

On block-based filesystems, fscrypt file contents encryption is now
always implemented using blk-crypto.  This implementation supports
direct I/O.

Therefore, fscrypt_dio_supported() now always returns true, except in
the edge case where statx(STATX_DIOALIGN) is called on an encrypted
regular file that hasn't had its key set up.  But that was really a
workaround rather than the desired behavior, so we can disregard it.

Thus, fscrypt_dio_supported() is no longer needed.  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/inline_crypt.c | 43 ----------------------------------------
 fs/ext4/inode.c          |  5 +----
 fs/f2fs/file.c           |  2 --
 include/linux/fscrypt.h  |  7 -------
 4 files changed, 1 insertion(+), 56 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 111ea45732f0..3c3a46c5af42 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -295,53 +295,10 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	fscrypt_generate_dun(ci, pos, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
 
-/**
- * fscrypt_dio_supported() - check whether DIO (direct I/O) is supported on an
- *			     inode, as far as encryption is concerned
- * @inode: the inode in question
- *
- * Return: %true if there are no encryption constraints that prevent DIO from
- *	   being supported; %false if DIO is unsupported.  (Note that in the
- *	   %true case, the filesystem might have other, non-encryption-related
- *	   constraints that prevent DIO from actually being supported.  Also, on
- *	   encrypted files the filesystem is still responsible for only allowing
- *	   DIO when requests are filesystem-block-aligned.)
- */
-bool fscrypt_dio_supported(struct inode *inode)
-{
-	int err;
-
-	/* If the file is unencrypted, no veto from us. */
-	if (!fscrypt_needs_contents_encryption(inode))
-		return true;
-
-	/*
-	 * We only support DIO with inline crypto, not fs-layer crypto.
-	 *
-	 * To determine whether the inode is using inline crypto, we have to set
-	 * up the key if it wasn't already done.  This is because in the current
-	 * design of fscrypt, the decision of whether to use inline crypto or
-	 * not isn't made until the inode's encryption key is being set up.  In
-	 * the DIO read/write case, the key will always be set up already, since
-	 * the file will be open.  But in the case of statx(), the key might not
-	 * be set up yet, as the file might not have been opened yet.
-	 */
-	err = fscrypt_require_key(inode);
-	if (err) {
-		/*
-		 * Key unavailable or couldn't be set up.  This edge case isn't
-		 * worth worrying about; just report that DIO is unsupported.
-		 */
-		return false;
-	}
-	return true;
-}
-EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
-
 /**
  * fscrypt_limit_io_blocks() - limit I/O blocks to avoid discontiguous DUNs
  * @inode: the file on which I/O is being done
  * @lblk: the block at which the I/O is being started from
  * @nr_blocks: the number of blocks we want to submit starting at @lblk
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6faa7c751ca..dd321aaa8779 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6144,15 +6144,12 @@ u32 ext4_dio_alignment(struct inode *inode)
 		return 0;
 	if (ext4_should_journal_data(inode))
 		return 0;
 	if (ext4_has_inline_data(inode))
 		return 0;
-	if (IS_ENCRYPTED(inode)) {
-		if (!fscrypt_dio_supported(inode))
-			return 0;
+	if (IS_ENCRYPTED(inode))
 		return i_blocksize(inode);
-	}
 	return 1; /* use the iomap defaults */
 }
 
 int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
 		 struct kstat *stat, u32 request_mask, unsigned int query_flags)
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index fb12c5c9affd..a726bc2ab66c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -948,12 +948,10 @@ int f2fs_truncate(struct inode *inode)
 
 static bool f2fs_force_buffered_io(struct inode *inode, int rw)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
-	if (!fscrypt_dio_supported(inode))
-		return true;
 	if (fsverity_active(inode))
 		return true;
 	if (f2fs_compressed_file(inode))
 		return true;
 	/*
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 8d19b95150f1..43bafdd67dd7 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -868,12 +868,10 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 			       loff_t pos, gfp_t gfp_mask);
 
 bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   loff_t pos);
 
-bool fscrypt_dio_supported(struct inode *inode);
-
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
 static inline void fscrypt_set_bio_crypt_ctx(struct bio *bio,
@@ -885,15 +883,10 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
 					 loff_t pos)
 {
 	return true;
 }
 
-static inline bool fscrypt_dio_supported(struct inode *inode)
-{
-	return !fscrypt_needs_contents_encryption(inode);
-}
-
 static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
 					  u64 nr_blocks)
 {
 	return nr_blocks;
 }
-- 
2.54.0


