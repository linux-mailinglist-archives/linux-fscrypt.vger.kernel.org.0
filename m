Return-Path: <linux-fscrypt+bounces-505-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 290B39A4627
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 20:45:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8E02285881
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 18:45:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4668205AD1;
	Fri, 18 Oct 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tb8QNDbB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835FF205AA3;
	Fri, 18 Oct 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277106; cv=none; b=IhxKmKAgea+SJzh7rQ5iGFcBwPa6+W54uzZBimWL7VpAq5rJ1zP+qwmZ98Wo11Xm+MnRuO42jsAqC3E7lPbcEMRDvgZy6h41E52qXkERAmO7AJ/yT4Tag2WAMlt7tWbi1cZLJR/GkK7cj5N1OXMg+wUkDZ2IpQmbFke91sBWf6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277106; c=relaxed/simple;
	bh=CJqMmKGmlMC1ZgTSvCsZDhV/pMMcxUr0PbmDF9R/3J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtXgYBdH2gz0eSbBuS+FGeAvLWadoZ5k7cFdZiFFUge1YrCpAtgVsvjpxNWon0kkLUuPNxhJteqKWweg9asNLRRzUurw3gT2OeVsqNFvekS+OrzTEZQIcMpN6NoTSnTsrvJjKWvZf1D8/kAIIjqrRzqXi5SBJ8FCpaFJ9k3VGEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tb8QNDbB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0401DC4CED2;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277106;
	bh=CJqMmKGmlMC1ZgTSvCsZDhV/pMMcxUr0PbmDF9R/3J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tb8QNDbBm1c5jVfWGHeTX79arz2h6WihIiGeGNIT1wKOvl2SnsoxQny2qbD9K1FS5
	 97IPTYhanx0dVA/KlRGXyEAFlT3qZc5C3vmIG1rDfkSH2LyQaUiCnmtuIj6YD37F5h
	 g4WCzHrK0wC5FDmW5iezMTH7eAeEg/CHLKAH4Qp9fiamrAYfzwxlebwnZvFSKbxHAk
	 yiQDNBYnN+xJV0CVw+2R+YJrgal7feu2DQYXE0AETmCZ4+krXjiiwSrmpxVeK46w6g
	 MrU3gjK5ZqSFodlQJ5Ej0BiLUESxaSHZ8BqiviYFBDcr65dFbbHe+Yxb9T66VX434g
	 9ZMlF7J4BWWWg==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Adrian Vovk <adrianvovk@gmail.com>
Subject: [RFC PATCH 4/4] ext4,f2fs: support metadata encryption via dm-default-key
Date: Fri, 18 Oct 2024 11:43:39 -0700
Message-ID: <20241018184339.66601-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241018184339.66601-1-ebiggers@kernel.org>
References: <20241018184339.66601-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Set the bi_skip_dm_default_key flag on bios that are targeting the
contents of an encrypted file and therefore should not be en/decrypted
by dm-default-key.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/inline_crypt.c | 14 +++++++++++++-
 fs/f2fs/data.c           |  6 +++++-
 include/linux/fscrypt.h  | 14 ++++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 40de69860dcf9..b75c69c09500b 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -261,17 +261,22 @@ static void fscrypt_generate_dun(const struct fscrypt_inode_info *ci,
  *
  * Normally the bio should be newly allocated (i.e. no pages added yet), as
  * otherwise fscrypt_mergeable_bio() won't work as intended.
  *
  * The encryption context will be freed automatically when the bio is freed.
+ *
+ * This function also handles setting bi_skip_dm_default_key when needed.
  */
 void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 			       u64 first_lblk, gfp_t gfp_mask)
 {
 	const struct fscrypt_inode_info *ci;
 	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 
+	if (fscrypt_inode_should_skip_dm_default_key(inode))
+		bio_set_skip_dm_default_key(bio);
+
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
 	ci = inode->i_crypt_info;
 
 	fscrypt_generate_dun(ci, first_lblk, dun);
@@ -342,20 +347,26 @@ EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx_bh);
  *
  * This function isn't required in cases where crypto-mergeability is ensured in
  * another way, such as I/O targeting only a single file (and thus a single key)
  * combined with fscrypt_limit_io_blocks() to ensure DUN contiguity.
  *
+ * This function also returns false if the next part of the I/O would need to
+ * have a different value for the bi_skip_dm_default_key flag.
+ *
  * Return: true iff the I/O is mergeable
  */
 bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 			   u64 next_lblk)
 {
 	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 
 	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
 		return false;
+	if (bio_should_skip_dm_default_key(bio) !=
+	    fscrypt_inode_should_skip_dm_default_key(inode))
+		return false;
 	if (!bc)
 		return true;
 
 	/*
 	 * Comparing the key pointers is good enough, as all I/O for each key
@@ -385,11 +396,12 @@ bool fscrypt_mergeable_bio_bh(struct bio *bio,
 {
 	const struct inode *inode;
 	u64 next_lblk;
 
 	if (!bh_get_inode_and_lblk_num(next_bh, &inode, &next_lblk))
-		return !bio->bi_crypt_context;
+		return !bio->bi_crypt_context &&
+		       !bio_should_skip_dm_default_key(bio);
 
 	return fscrypt_mergeable_bio(bio, inode, next_lblk);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio_bh);
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 94f7b084f6016..a413508210994 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -484,10 +484,12 @@ static void f2fs_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 	 * The f2fs garbage collector sets ->encrypted_page when it wants to
 	 * read/write raw data without encryption.
 	 */
 	if (!fio || !fio->encrypted_page)
 		fscrypt_set_bio_crypt_ctx(bio, inode, first_idx, gfp_mask);
+	else if (fscrypt_inode_should_skip_dm_default_key(inode))
+		bio_set_skip_dm_default_key(bio);
 }
 
 static bool f2fs_crypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 				     pgoff_t next_idx,
 				     const struct f2fs_io_info *fio)
@@ -495,11 +497,13 @@ static bool f2fs_crypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	/*
 	 * The f2fs garbage collector sets ->encrypted_page when it wants to
 	 * read/write raw data without encryption.
 	 */
 	if (fio && fio->encrypted_page)
-		return !bio_has_crypt_ctx(bio);
+		return !bio_has_crypt_ctx(bio) &&
+			(bio_should_skip_dm_default_key(bio) ==
+			 fscrypt_inode_should_skip_dm_default_key(inode));
 
 	return fscrypt_mergeable_bio(bio, inode, next_idx);
 }
 
 void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, struct bio *bio,
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 772f822dc6b82..eac1917db79a9 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -890,10 +890,24 @@ static inline u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk,
 {
 	return nr_blocks;
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENABLED(CONFIG_DM_DEFAULT_KEY)
+static inline bool
+fscrypt_inode_should_skip_dm_default_key(const struct inode *inode)
+{
+	return IS_ENCRYPTED(inode) && S_ISREG(inode->i_mode);
+}
+#else
+static inline bool
+fscrypt_inode_should_skip_dm_default_key(const struct inode *inode)
+{
+	return false;
+}
+#endif
+
 /**
  * fscrypt_inode_uses_inline_crypto() - test whether an inode uses inline
  *					encryption
  * @inode: an inode. If encrypted, its key must be set up.
  *
-- 
2.47.0


