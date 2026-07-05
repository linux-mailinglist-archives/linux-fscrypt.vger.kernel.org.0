Return-Path: <linux-fscrypt+bounces-1724-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CdR/HCm1SmpGGgEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1724-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:48:57 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D96EB70B282
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 21:48:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QULkJKEz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1724-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1724-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0BF5A30300F3
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 19:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27613A75B6;
	Sun,  5 Jul 2026 19:47:50 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B79527E1D7;
	Sun,  5 Jul 2026 19:47:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783280870; cv=none; b=lrfGl+L+s0qjQB52QfBuFz8a8V396AWRyo2EPKvOd58G6C8Y30w8IZl9Cj8Mrna1ofJmlnivUhLMcztZsboim0cG2BcP0cmFTTo+MlkrQn2dCpCv50FHJ+jw2dBjoPpI7c7Xmfd+I4GYLB1ms/ItIISqdVDv88emYOKR0nyRRuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783280870; c=relaxed/simple;
	bh=QFmwzgLu1tA6UpGvD0pHZ1cvPyB/iK841ggAv9I4LVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbxkLDWYWH1HHmJTlPdfyn0Oqp3XuO1fUvNirR1eFhBcqexOaF5QH+NT1EUn0Xx4DRP1HvBT4yFBz4GYNEHT2j0QaflFzszG7TRT+KFfboSSQQNtGsAFWAPoQzxbmhIIEa30OKz0gZx7ikuHSJ6jokeWGMRSqElDCw2E5SzmYag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QULkJKEz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF081F00A3E;
	Sun,  5 Jul 2026 19:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783280869;
	bh=wWudyb7yAyg/xFRgTR3OCCHUQ/2sHz9VK5cdUhXrtV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QULkJKEz3nDFL2EYQs7OdBbEGe7wlQ6nGJQUvS6bd2NE3OEwJzKSfWW2jXn6+xu1w
	 5Zo2w6fEwjYichv92zRs+ZkfFqH+AcbvRJ1oXQ2bErGiGoIzETicUp+bhDqGO9z4/7
	 NDN8jLIUtaz4k7IjQxk+o9BV/y1DYPWo8kXFcC7dOgnMDd/By2Js7YY+YcniJSTW4h
	 ndXBP1f4eqWE418Oetdu2J1i7US49nQHZWKHrSAToNSBJT8zlLtL2slbY6AnbfqKDI
	 2nNi5jZTbJu50q/HxarW0p8jochBAQx5B4gIzy1xNF+CqcFewB+c99UsuSsF7QtFAL
	 hoWjy7eZ1fAxg==
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
Subject: [PATCH v2 06/17] Documentation: fscrypt: Update docs for inlinecrypt
Date: Sun,  5 Jul 2026 12:45:43 -0700
Message-ID: <20260705194555.75030-7-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1724-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D96EB70B282

Update the documentation for the inlinecrypt mount option to reflect
that it's now just about the choice of whether to use inline encryption
hardware, not whether the blk-crypto framework is used.

Also remove an outdated statement about the data unit size, and make the
ext4 and f2fs docs reference the fscrypt docs rather than the block
layer docs directly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/admin-guide/ext4.rst    |  8 +++---
 Documentation/filesystems/f2fs.rst    | 10 +++-----
 Documentation/filesystems/fscrypt.rst | 36 +++++++++------------------
 3 files changed, 19 insertions(+), 35 deletions(-)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index ac0c709ea9e7..742a48e6fc0c 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -385,11 +385,9 @@ When mounting an ext4 filesystem, the following option are accepted:
         incompatible with data=journal.
 
   inlinecrypt
-        When possible, encrypt/decrypt the contents of encrypted files using the
-        blk-crypto framework rather than filesystem-layer encryption. This
-        allows the use of inline encryption hardware. The on-disk format is
-        unaffected. For more details, see
-        Documentation/block/inline-encryption.rst.
+        When possible, encrypt/decrypt the contents of encrypted files using
+        inline encryption hardware rather than the CPU. For more details, see
+        Documentation/filesystems/fscrypt.rst.
 
 Data Mode
 =========
diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
index 8c4a14ae444f..b45d7a687625 100644
--- a/Documentation/filesystems/f2fs.rst
+++ b/Documentation/filesystems/f2fs.rst
@@ -351,12 +351,10 @@ compress_mode=%s	 Control file compression mode. This supports "fs" and "user"
 compress_cache		 Support to use address space of a filesystem managed inode to
 			 cache compressed block, in order to improve cache hit ratio of
 			 random read.
-inlinecrypt		 When possible, encrypt/decrypt the contents of encrypted
-			 files using the blk-crypto framework rather than
-			 filesystem-layer encryption. This allows the use of
-			 inline encryption hardware. The on-disk format is
-			 unaffected. For more details, see
-			 Documentation/block/inline-encryption.rst.
+inlinecrypt		 When possible, encrypt/decrypt the contents of
+			 encrypted files using inline encryption hardware rather
+			 than the CPU. For more details, see
+			 Documentation/filesystems/fscrypt.rst.
 atgc			 Enable age-threshold garbage collection, it provides high
 			 effectiveness and efficiency on background GC.
 discard_unit=%s		 Control discard unit, the argument can be "block", "segment"
diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 92b8f311e211..370a5ef73ef2 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1318,32 +1318,20 @@ Inline encryption support
 
 Many newer systems (especially mobile SoCs) have *inline encryption
 hardware* that can encrypt/decrypt data while it is on its way to/from
-the storage device.  Linux supports inline encryption through a set of
-extensions to the block layer called *blk-crypto*.  blk-crypto allows
-filesystems to attach encryption contexts to bios (I/O requests) to
-specify how the data will be encrypted or decrypted in-line.  For more
-information about blk-crypto, see
-:ref:`Documentation/block/inline-encryption.rst <inline_encryption>`.
+the storage device.
 
 On supported filesystems (currently ext4 and f2fs), fscrypt can use
-blk-crypto instead of the kernel crypto API to encrypt/decrypt file
-contents.  To enable this, set CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y in
-the kernel configuration, and specify the "inlinecrypt" mount option
-when mounting the filesystem.
-
-Note that the "inlinecrypt" mount option just specifies to use inline
-encryption when possible; it doesn't force its use.  fscrypt will
-still fall back to using the kernel crypto API on files where the
-inline encryption hardware doesn't have the needed crypto capabilities
-(e.g. support for the needed encryption algorithm and data unit size)
-and where blk-crypto-fallback is unusable.  (For blk-crypto-fallback
-to be usable, it must be enabled in the kernel configuration with
-CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y, and the file must be
-protected by a raw key rather than a hardware-wrapped key.)
-
-Currently fscrypt always uses the filesystem block size (which is
-usually 4096 bytes) as the data unit size.  Therefore, it can only use
-inline encryption hardware that supports that data unit size.
+inline encryption hardware instead of the CPU to encrypt/decrypt file
+contents.  To enable this, specify the "inlinecrypt" mount option when
+mounting the filesystem.
+
+This causes the filesystem to use inline encryption hardware whenever
+possible, falling back to the CPU only if such hardware is absent or
+doesn't provide the needed crypto capabilities.
+
+For more information about the kernel's support for inline encryption
+hardware, see :ref:`Documentation/block/inline-encryption.rst
+<inline_encryption>`.
 
 Inline encryption doesn't affect the ciphertext or other aspects of
 the on-disk format, so users may freely switch back and forth between
-- 
2.54.0


