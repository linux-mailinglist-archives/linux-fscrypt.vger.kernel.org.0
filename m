Return-Path: <linux-fscrypt+bounces-1769-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id F3vwJgdQVGoGkgMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1769-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:40:07 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C220746B08
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:40:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndaxoUNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1769-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1769-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3B53230066B2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D58A3603D5;
	Mon, 13 Jul 2026 02:39:52 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB7E3546C1;
	Mon, 13 Jul 2026 02:39:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910392; cv=none; b=Wfk0vfgFdiv7e/GyYQNsZguyL3aEDAxisSXyow+7HphT2NvQz1/S7SkBHgT04EHRR+vT7v5S4ggg9i8P5O5sU1KHbn2OkG7JYGziEC/fSq9gYOqTrHPJ1HmtDZOCQ3hA41tIoe3GUbp1shuyXYzBHyTEw3YMXwctuaDva8zftTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910392; c=relaxed/simple;
	bh=RHxIgbhBrruKkjLQj7tF6Os862sU/dl1dRXbzjsdxk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOc+508ojbEHGqtCdbdukt6WjP72/UcO6cQZH8v3SUZ/tqDe0LT/rewXACYGJfC1Smzwek7NJYMQmQs/gw3+bZwx4XYCZvfsTFZ3P2/pj8DyUqP3uTEvB6HvrT5K21PKAEXQDoQDGSCwCW4UdVuG0UUbB3Vp8XKB8djHlcvr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndaxoUNS; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F80F1F00A3F;
	Mon, 13 Jul 2026 02:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910390;
	bh=bvixfnNTZ6JKiWa0QbNPZbAZZhqRDEEPo5VoHOqsM7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndaxoUNS3+xgvoK9Pswmoy34DaNx2gPHFtz9XNSC7wvMdwS7EOmhKXETLVHy1lHpp
	 NcZwZghkpTMmiVCQ/1Q+pzCHkQKAQvbRA1AkgyD9BWPl3h8rE9nELFCa6gYP+UlKXr
	 q59Qz/UZEQGyMV1t0NGX+a7ChTA+kiEJWicY1sgxzzKrb1zBy6VqEGaCqpVDHBlVYC
	 wLQ3obKg3JjMAGiXA8/HNamfUrcq86IuZsT/jVJAW4eUtrjhad15ac9mO0tqbyzUOH
	 uCd+R+8mz0yrR2f3T6LtA/WUmuuVuiDsDH0C9rOuNc30w/3Gh3HfjrRfJlbE/NC0ga
	 IWIHPnwWkOntQ==
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
Subject: [PATCH v3 12/17] fscrypt: Replace calls to fscrypt_inode_uses_inline_crypto()
Date: Sun, 12 Jul 2026 22:37:03 -0400
Message-ID: <20260713023708.9245-13-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1769-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2C220746B08

Now that fscrypt's file contents en/decryption is always implemented
using blk-crypto when the filesystem is block-based, the calls to
fscrypt_inode_uses_inline_crypto() in fs/crypto/inline_crypt.c (which
contains functions that are called only from block-based filesystems)
are equivalent to checking whether the file is an encrypted regular
file, i.e. fscrypt_needs_contents_encryption().  Use that instead.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/inline_crypt.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 3a92bd57e3eb..685815fa71a6 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -228,8 +228,8 @@ static void fscrypt_generate_dun(const struct fscrypt_inode_info *ci,
  * @gfp_mask: memory allocation flags - these must be a waiting mask so that
  *					bio_crypt_set_ctx can't fail.
  *
- * If the contents of the file should be encrypted (or decrypted) with inline
- * encryption, then assign the appropriate encryption context to the bio.
+ * If the contents of the file should be encrypted (or decrypted), then assign
+ * the appropriate encryption context to the bio.
  *
  * Normally the bio should be newly allocated (i.e. no pages added yet), as
  * otherwise fscrypt_mergeable_bio() won't work as intended.
@@ -242,7 +242,7 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	const struct fscrypt_inode_info *ci;
 	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 
-	if (!fscrypt_inode_uses_inline_crypto(inode))
+	if (!fscrypt_needs_contents_encryption(inode))
 		return;
 	ci = fscrypt_get_inode_info_raw(inode);
 
@@ -257,12 +257,12 @@ EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
  * @inode: the inode for the next part of the I/O
  * @pos: the next file position (in bytes) in the I/O
  *
- * When building a bio which may contain data which should undergo inline
- * encryption (or decryption) via fscrypt, filesystems should call this function
- * to ensure that the resulting bio contains only contiguous data unit numbers.
- * This will return false if the next part of the I/O cannot be merged with the
- * bio because either the encryption key would be different or the encryption
- * data unit numbers would be discontiguous.
+ * When building a bio which may contain data which should undergo encryption
+ * (or decryption) via fscrypt, filesystems should call this function to ensure
+ * that the resulting bio contains only contiguous data unit numbers.  This will
+ * return false if the next part of the I/O cannot be merged with the bio
+ * because either the encryption key would be different or the encryption data
+ * unit numbers would be discontiguous.
  *
  * fscrypt_set_bio_crypt_ctx() must have already been called on the bio.
  *
@@ -279,7 +279,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	const struct fscrypt_inode_info *ci;
 	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 
-	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
+	if (!!bc != fscrypt_needs_contents_encryption(inode))
 		return false;
 	if (!bc)
 		return true;
@@ -337,7 +337,7 @@ bool fscrypt_dio_supported(struct inode *inode)
 		 */
 		return false;
 	}
-	return fscrypt_inode_uses_inline_crypto(inode);
+	return true;
 }
 EXPORT_SYMBOL_GPL(fscrypt_dio_supported);
 
@@ -366,7 +366,7 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	const struct fscrypt_inode_info *ci;
 	u32 dun;
 
-	if (!fscrypt_inode_uses_inline_crypto(inode))
+	if (!fscrypt_needs_contents_encryption(inode))
 		return nr_blocks;
 
 	if (nr_blocks <= 1)
-- 
2.55.0


