Return-Path: <linux-fscrypt+bounces-1761-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Ih1/Hu9PVGrdkQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1761-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:39:43 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F45F746A9F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:39:43 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aPGIZQ3b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1761-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1761-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2370E3002B03
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1B8369D45;
	Mon, 13 Jul 2026 02:39:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB0D37187C;
	Mon, 13 Jul 2026 02:39:38 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910380; cv=none; b=VnAuavc0djZ8qsq8n73GEBGCM+9dOiw5C27C5vn0f+u7Fh+L2Cv/OKD43/N9QlTzEdcRG9wmLZ5pq8wNBTjvWYNcm4p1VrHEc3YT8+Y/LTMKxLEKHBwxnl/6cpLp2SKaMB9BH/yHMkHv9xC6TO6s6wzZsgX4oHrx2KJP1gwNoyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910380; c=relaxed/simple;
	bh=BICFOTeGJxuw4S3sozP1B1tFp+JwzUlAKsvrXpF6C7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAGDla6RSclQgXVKTb8ae3YIVOqswlE+uAbqwbn7vaWZyym9g9V23mqnSOueZu6sC+3KO8i++teBRkV7vxN14X5BO7Advr8P2awrliyCyb1o67wva3VgY3v2AAdB4vk5Q9B23Q1BHwROqmN8MZ1yIg6KBPZ9EZKyzEOXevlPiWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPGIZQ3b; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6671F00A3D;
	Mon, 13 Jul 2026 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910377;
	bh=heJf2lUsfHWx2MluoNOLNNCT5X8VE5KT5lfDTj6MDb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPGIZQ3b9j+h6Z0MyThuY/ZUQCSxgActPOPVfiyM8xdeZu8TstqIdUTmaMnprF4mr
	 OqcBPDoE41PPE0bZe11h5ABtIn1j/8fdPmz4grktn1zusegI/Kwj/ni4vBbnhyfNn6
	 pmPGtTaoSpL85dQ/O4DiG+MX6fHofacLEIL6KiVc2Zewi3nucU1OxKcyGEi2Ca7Gl7
	 BJc6UfJ/+lhqGGPjbB5pq0Dx1ncUJgzhJRRzLhh2G98uk6bhenV+UpuShpgd5XJIeN
	 LfkeI2T9jUISjTYa5vUj5CHw2T4opMTVJjL5RdGS5OTPPH/kVlYm38JMo/A7ubm3+X
	 eZBcUNyGC4ygA==
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
Subject: [PATCH v3 04/17] fscrypt: Fully disallow IV_INO_LBLK_32 with s_blocksize != PAGE_SIZE
Date: Sun, 12 Jul 2026 22:36:55 -0400
Message-ID: <20260713023708.9245-5-ebiggers@kernel.org>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	SUBJECT_HAS_EXCLAIM(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-1761-lists,linux-fscrypt=lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4F45F746A9F

FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 with s_blocksize != PAGE_SIZE works
only with the fs-layer implementation of file contents encryption, not
blk-crypto.  This is a problem for standardizing on blk-crypto.

Fortunately, no one should be using this combination anyway.  It doesn't
make sense because the entire point of IV_INO_LBLK_32 is to support
inline encryption hardware that is limited to 32-bit DUNs.

Thus, fully disallow IV_INO_LBLK_32 with s_blocksize != PAGE_SIZE.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/filesystems/fscrypt.rst |  3 +++
 fs/crypto/inline_crypt.c              | 13 -------------
 fs/crypto/policy.c                    | 17 +++++++++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index c0dd35f1af12..92b8f311e211 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -336,6 +336,9 @@ per I/O request and may have only a small number of keyslots.  This
 format results in some level of IV reuse, so it should only be used
 when necessary due to hardware limitations.
 
+IV_INO_LBLK_32 is supported only when the filesystem block size is
+equal to the page size.
+
 Key identifiers
 ---------------
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index aaf71f6068b0..83dea8bc2c8c 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -112,19 +112,6 @@ int fscrypt_select_encryption_impl(struct fscrypt_inode_info *ci,
 	if (!(sb->s_flags & SB_INLINECRYPT))
 		return 0;
 
-	/*
-	 * When a page contains multiple logically contiguous filesystem blocks,
-	 * some filesystem code only calls fscrypt_mergeable_bio() for the first
-	 * block in the page. This is fine for most of fscrypt's IV generation
-	 * strategies, where contiguous blocks imply contiguous IVs. But it
-	 * doesn't work with IV_INO_LBLK_32. For now, simply exclude
-	 * IV_INO_LBLK_32 with blocksize != PAGE_SIZE from inline encryption.
-	 */
-	if ((fscrypt_policy_flags(&ci->ci_policy) &
-	     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
-	    sb->s_blocksize != PAGE_SIZE)
-		return 0;
-
 	/*
 	 * On all the filesystem's block devices, blk-crypto must support the
 	 * crypto configuration that the file would use.
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index f40fb5924e75..a7322dba7557 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -177,6 +177,23 @@ static bool supported_iv_ino_lblk_policy(const struct fscrypt_policy_v2 *policy,
 			     type, sb->s_id);
 		return false;
 	}
+
+	/*
+	 * IV_INO_LBLK_32 isn't compatible with inline encryption when
+	 * s_blocksize != PAGE_SIZE.  In that case the DUN can wrap around in
+	 * the middle of a page, but sometimes fscrypt_mergeable_bio() is called
+	 * only for the first block per page.  Since IV_INO_LBLK_32 exists only
+	 * to support inline encryption hardware that is limited to 32-bit DUNs,
+	 * just disallow IV_INO_LBLK_32 with s_blocksize != PAGE_SIZE entirely.
+	 */
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
+	    sb->s_blocksize != PAGE_SIZE) {
+		fscrypt_warn(inode,
+			     "Can't use %s policy on filesystem '%s' with block size != PAGE_SIZE",
+			     type, sb->s_id);
+		return false;
+	}
+
 	return true;
 }
 
-- 
2.55.0


