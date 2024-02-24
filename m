Return-Path: <linux-fscrypt+bounces-183-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA47F8622D4
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Feb 2024 07:01:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC9C1C2155E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Feb 2024 06:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0BB13FFF;
	Sat, 24 Feb 2024 06:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d496LrwI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4AB1FAA
	for <linux-fscrypt@vger.kernel.org>; Sat, 24 Feb 2024 06:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708754513; cv=none; b=XPZptCyqyzCl4dJrqfO6tVrupXwZb7nnb35Zw/HI9cj1PbZBIRICcgjHWnoLrs+7+xUAGOZ7uXOVAvej+QRPyw3Z8MddxVGV9W8x0Ib+7KG1bA4P8Dy4CxDD8eg3SmYFDT7VO9h360UcIGEiQ+R7lBXeFIpEKyG4xFkVrnDRSVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708754513; c=relaxed/simple;
	bh=F2+whYXAh7qvhGyZbgUIT9BuWE8TH/Bwu4CpObDrxBA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kbKPneYsgxbywwx4lEMw1B0UW2GeXDr65ZjXElP6F1i94LzwHKVJD8wPI7sBeu7E8kL4Fw7pNhLpQ5rjCZswGeOt18c+jcgfzAhJPwsxyvfEt3GqVdvv/8UZu3B1fP4LU316h9eFMrvdQ5/05re5FEWhrXyVfinYThWzNsbxJqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d496LrwI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4108AC433F1
	for <linux-fscrypt@vger.kernel.org>; Sat, 24 Feb 2024 06:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708754513;
	bh=F2+whYXAh7qvhGyZbgUIT9BuWE8TH/Bwu4CpObDrxBA=;
	h=From:To:Subject:Date:From;
	b=d496LrwIvHuIgpkkKtHOoA20Mgli5VmJmIvWA/y5/t/1DHFHk4NndIIUwyzQgiA5o
	 gXfcc89YBkUJLhA0mOoM3KqYKJZgtev1aMEQzEwOv6BW/aMF4U7Tki+C5cFRW0tZfR
	 m3dP5n2uOflHJuVSkTKh6takvlsvFxpYEGUMtypj1kgeq5bqjvb0IX51w/IlwNcxUZ
	 G45o8kHuW8pkOEseZMhG2x5dYXTIIAk2Wfu486lXogg30oivX91AOHOeBD/IEo1eqp
	 DmQETaaGxt0uujKsK+P2CwkUkghBDgOUH17D4KGAhknel1s0D3dOHReQxK0TSGSv/g
	 +kokPXBDdxrZQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: shrink the size of struct fscrypt_inode_info slightly
Date: Fri, 23 Feb 2024 22:01:03 -0800
Message-ID: <20240224060103.91037-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Shrink the size of struct fscrypt_inode_info by 8 bytes by packing the
small fields into the 64 bits after ci_enc_key.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 1892356cf924a..8371e4e1f596a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -215,40 +215,46 @@ struct fscrypt_prepared_key {
  * When an encrypted file's key is made available, an instance of this struct is
  * allocated and stored in ->i_crypt_info.  Once created, it remains until the
  * inode is evicted.
  */
 struct fscrypt_inode_info {
 
 	/* The key in a form prepared for actual encryption/decryption */
 	struct fscrypt_prepared_key ci_enc_key;
 
 	/* True if ci_enc_key should be freed when this struct is freed */
-	bool ci_owns_key;
+	u8 ci_owns_key : 1;
 
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 	/*
 	 * True if this inode will use inline encryption (blk-crypto) instead of
 	 * the traditional filesystem-layer encryption.
 	 */
-	bool ci_inlinecrypt;
+	u8 ci_inlinecrypt : 1;
 #endif
 
+	/* True if ci_dirhash_key is initialized */
+	u8 ci_dirhash_key_initialized : 1;
+
 	/*
 	 * log2 of the data unit size (granularity of contents encryption) of
 	 * this file.  This is computable from ci_policy and ci_inode but is
 	 * cached here for efficiency.  Only used for regular files.
 	 */
 	u8 ci_data_unit_bits;
 
 	/* Cached value: log2 of number of data units per FS block */
 	u8 ci_data_units_per_block_bits;
 
+	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
+	u32 ci_hashed_ino;
+
 	/*
 	 * Encryption mode used for this inode.  It corresponds to either the
 	 * contents or filenames encryption mode, depending on the inode type.
 	 */
 	struct fscrypt_mode *ci_mode;
 
 	/* Back-pointer to the inode */
 	struct inode *ci_inode;
 
 	/*
@@ -269,30 +275,26 @@ struct fscrypt_inode_info {
 	 * and ci_enc_key will equal ci_direct_key->dk_key.
 	 */
 	struct fscrypt_direct_key *ci_direct_key;
 
 	/*
 	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
 	 * key.  This is only set for directories that use a keyed dirhash over
 	 * the plaintext filenames -- currently just casefolded directories.
 	 */
 	siphash_key_t ci_dirhash_key;
-	bool ci_dirhash_key_initialized;
 
 	/* The encryption policy used by this inode */
 	union fscrypt_policy ci_policy;
 
 	/* This inode's nonce, copied from the fscrypt_context */
 	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
-
-	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
-	u32 ci_hashed_ino;
 };
 
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_inode_info_cachep;
 int fscrypt_initialize(struct super_block *sb);

base-commit: 2f944c66ae73eed4250607ccd3acdf2531afc194
-- 
2.43.2


