Return-Path: <linux-fscrypt+bounces-1731-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1ibpDom1SmpxGgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1731-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:50:33 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DD4EA70B2FA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:50:32 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PYuUpoCt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1731-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1731-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 85C65304585C
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70F63A7F48;
	Sun,  5 Jul 2026 19:48:08 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9493A9612;
	Sun,  5 Jul 2026 19:48:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783280888; cv=none; b=eV8wgN2vlHAAfGCs004wTa/QYC99LLVfcv1iyzezFaOn7egKctDpJEqK7I488135WE7QOHWvD/7WP1Aw4+qE5AA43gEuc4XDyZevXtXpQRO9p1Emvq6b9LdWaHSZh9HmeVcDY5F6GIFujq00r5jYwW23fyirpz2QXh7Lns1Py0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783280888; c=relaxed/simple;
	bh=W/QJLI4Mq1P5Vmb73bJXC2tYTyq/1pN1dLht+cHPoiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEc+e3quAcIDwJ2MN8n01cX5/MCpDu9T+CWN3g9jY5uRpTJZ8XMsZuY/wz7e8pSpo8fe/8uZGMEUQ/ASg+FrlIgPizQEtdX/GLtyr26P3gJnU9jd8fKV6SBrZUORCCqBhUe+J0q9XqZYzuBnQfoScIbOB/sUrybYdZ4LxzSRkpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYuUpoCt; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFE51F00A3A;
	Sun,  5 Jul 2026 19:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280887;
	bh=8BmiWL6+8e1/XebN3PJhgaspqpqpmvTryYEn37+krNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYuUpoCt2+cI2EDhugaPnFm8k0RGc4qNhwmFYDfBtZB0qrMS/g6loiPcJWJVsE52M
	 pB56zUtYgdoZErCjlCUY9ghefKgcdxpFOeYQ85yOkZcs1mcZ0PZIkCLKnqDIH1VJlz
	 9rSZmGQMACuPNhKaZ7k+ZxKazfeAYhIOH2Oe+E1i8ADmhhFh3qOZxBjtoAo1wynR4r
	 IwGHLtsZQpX6+4FZI3cfTy6nba1Ul8/JuMnt6omnWFagU49vWyLuy42Sg+0EAm8XzR
	 /6pJmvqgyC3KmkDTHgnVYj7qFY2DB/6IluZAs1/EKfh4vevbuSd13j0ClhOysqrOu2
	 EEGJdp7wWlpag==
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
Subject: [PATCH v2 13/17] fscrypt: Remove fscrypt_dio_supported()
Date: Sun,  5 Jul 2026 12:45:50 -0700
Message-ID: <20260705194555.75030-14-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260705194555.75030-1-ebiggers@kernel.org>
References: <20260705194555.75030-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1731-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DD4EA70B2FA

On block-based filesystems, fscrypt file contents encryption is now
always implemented using blk-crypto.  This implementation supports
direct I/O.

Therefore, fscrypt_dio_supported() now always returns true, except in
the edge case where statx(STATX_DIOALIGN) is called on an encrypted
regular file that hasn't had its key set up.  But that was really a
workaround rather than the desired behavior, so we can disregard it.

Thus, fscrypt_dio_supported() is no longer needed.  Remove it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/inline_crypt.c | 43 ----------------------------------------
 fs/ext4/inode.c          |  5 +----
 fs/f2fs/file.c           |  2 --
 include/linux/fscrypt.h  |  7 -------
 4 files changed, 1 insertion(+), 56 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 685815fa71a6..14c8af322c2f 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -298,49 +298,6 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
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
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6faa7c751ca..dd321aaa8779 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6146,11 +6146,8 @@ u32 ext4_dio_alignment(struct inode *inode)
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
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 4b52c56d71f0..ace2e00fec75 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -950,8 +950,6 @@ static bool f2fs_force_buffered_io(struct inode *inode, int rw)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
-	if (!fscrypt_dio_supported(inode))
-		return true;
 	if (fsverity_active(inode))
 		return true;
 	if (f2fs_compressed_file(inode))
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 8d19b95150f1..43bafdd67dd7 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -870,8 +870,6 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   loff_t pos);
 
-bool fscrypt_dio_supported(struct inode *inode);
-
 u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks);
 
 #else /* CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
@@ -887,11 +885,6 @@ static inline bool fscrypt_mergeable_bio(struct bio *bio,
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
-- 
2.54.0


