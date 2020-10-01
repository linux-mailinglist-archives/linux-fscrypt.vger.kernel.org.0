Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001C527F6A3
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Oct 2020 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731944AbgJAAZc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730031AbgJAAZc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CBC5206B6;
        Thu,  1 Oct 2020 00:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511931;
        bh=VBMU9zqlg9ziA+/O/cMqrobWj/zYBNWxbE24XEi8/AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AugeuiLRw3N7KlPmLepNKhjwvFgVeDxBUEXbg+LSFZlH2CVtQlJR6d/Cld+l0Afp8
         xLj2lKNGXvlnjdU+tTxNOLTGUkfME3T5UG8Wqr7PXzqscjVo1qAjqnVWoVqX4lzk06
         eLD6IjeXdUfyS+G85rHJW4Xsc+RRbthsY9xI+djs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daeho43@gmail.com>
Subject: [PATCH 2/5] fscrypt-crypt-util: fix IV incrementing for --iv-ino-lblk-32
Date:   Wed, 30 Sep 2020 17:25:04 -0700
Message-Id: <20201001002508.328866-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001002508.328866-1-ebiggers@kernel.org>
References: <20201001002508.328866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt-crypt-util treats the "block number" part of the IV as 64-bit
when incrementing it.  That's wrong for --iv-ino-lblk-32 and
--iv-ino-lblk-64, as in those cases the block number should be 32-bit.

Fix this by using the correct length for the block number.

For --iv-ino-lblk-64 this doesn't actually matter, since in that case
the block number starts at 0 and never exceeds UINT32_MAX.

But for --iv-ino-lblk-32, the hashed inode number gets added to the
original block number to produce the IV block number, which can later
wrap around from UINT32_MAX to 0.  As a result, this change fixes
generic/602, though since the wraparound case isn't specifically tested
currently, the chance of failure was extremely small.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 54 ++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index d9189346..5c065116 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -1692,16 +1692,32 @@ static const struct fscrypt_cipher *find_fscrypt_cipher(const char *name)
 	return NULL;
 }
 
-struct fscrypt_iv {
-	union {
-		__le64 block_num;
-		u8 bytes[32];
+union fscrypt_iv {
+	/* usual IV format */
+	struct {
+		/* logical block number within the file */
+		__le64 block_number;
+
+		/* per-file nonce; only set in DIRECT_KEY mode */
+		u8 nonce[FILE_NONCE_SIZE];
+	};
+	/* IV format for IV_INO_LBLK_* modes */
+	struct {
+		/*
+		 * IV_INO_LBLK_64: logical block number within the file
+		 * IV_INO_LBLK_32: hashed inode number + logical block number
+		 *		   within the file, mod 2^32
+		 */
+		__le32 block_number32;
+
+		/* IV_INO_LBLK_64: inode number */
+		__le32 inode_number;
 	};
 };
 
 static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
-		       struct fscrypt_iv *iv, bool decrypting,
-		       size_t block_size, size_t padding)
+		       union fscrypt_iv *iv, bool decrypting,
+		       size_t block_size, size_t padding, bool is_bnum_32bit)
 {
 	u8 *buf = xmalloc(block_size);
 	size_t res;
@@ -1718,13 +1734,18 @@ static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
 		memset(&buf[res], 0, crypt_len - res);
 
 		if (decrypting)
-			cipher->decrypt(key, iv->bytes, buf, buf, crypt_len);
+			cipher->decrypt(key, (u8 *)iv, buf, buf, crypt_len);
 		else
-			cipher->encrypt(key, iv->bytes, buf, buf, crypt_len);
+			cipher->encrypt(key, (u8 *)iv, buf, buf, crypt_len);
 
 		full_write(STDOUT_FILENO, buf, crypt_len);
 
-		iv->block_num = cpu_to_le64(le64_to_cpu(iv->block_num) + 1);
+		if (is_bnum_32bit)
+			iv->block_number32 = cpu_to_le32(
+					le32_to_cpu(iv->block_number32) + 1);
+		else
+			iv->block_number = cpu_to_le64(
+					le64_to_cpu(iv->block_number) + 1);
 	}
 	free(buf);
 }
@@ -1806,7 +1827,7 @@ static u32 hash_inode_number(const struct key_and_iv_params *params)
  */
 static void get_key_and_iv(const struct key_and_iv_params *params,
 			   u8 *real_key, size_t real_key_size,
-			   struct fscrypt_iv *iv)
+			   union fscrypt_iv *iv)
 {
 	bool file_nonce_in_iv = false;
 	struct aes_key aes_key;
@@ -1860,14 +1881,14 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
-			put_unaligned_le32(params->inode_number, &iv->bytes[4]);
+			iv->inode_number = cpu_to_le32(params->inode_number);
 		} else if (params->iv_ino_lblk_32) {
 			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
-			put_unaligned_le32(hash_inode_number(params),
-					   iv->bytes);
+			iv->block_number32 =
+				cpu_to_le32(hash_inode_number(params));
 		} else if (params->mode_num != 0) {
 			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
 			info[infolen++] = params->mode_num;
@@ -1888,7 +1909,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 	}
 
 	if (file_nonce_in_iv && params->file_nonce_specified)
-		memcpy(&iv->bytes[8], params->file_nonce, FILE_NONCE_SIZE);
+		memcpy(iv->nonce, params->file_nonce, FILE_NONCE_SIZE);
 }
 
 enum {
@@ -1928,7 +1949,7 @@ int main(int argc, char *argv[])
 	size_t padding = 0;
 	const struct fscrypt_cipher *cipher;
 	u8 real_key[MAX_KEY_SIZE];
-	struct fscrypt_iv iv;
+	union fscrypt_iv iv;
 	char *tmp;
 	int c;
 
@@ -2025,6 +2046,7 @@ int main(int argc, char *argv[])
 
 	get_key_and_iv(&params, real_key, cipher->keysize, &iv);
 
-	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding);
+	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding,
+		   params.iv_ino_lblk_64 || params.iv_ino_lblk_32);
 	return 0;
 }
-- 
2.28.0

