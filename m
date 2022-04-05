Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7979C4F21BF
	for <lists+linux-fscrypt@lfdr.de>; Tue,  5 Apr 2022 06:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiDECUl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 4 Apr 2022 22:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiDECUl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 4 Apr 2022 22:20:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A904D1AC41F;
        Mon,  4 Apr 2022 18:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C05D61794;
        Tue,  5 Apr 2022 01:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5985C2BBE4;
        Tue,  5 Apr 2022 01:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649121043;
        bh=/wQGv+a5YNqAzNePjyG4n29JhJYDL+Zyw5nRut7cPrc=;
        h=From:To:Cc:Subject:Date:From;
        b=q8VfEa/oASHdKAkWs2vcgyr8IFyfZpgeO+2YxRec8fu1S5I/16C+2g1X8fOEDJ/dB
         64eOp+fLrNCiX4pmDDz89Fvaz28wO5peHW1tvH8Q+ANFh8+b3JSAnWgTGSQNUnuMfY
         GvDS3RbRdDy3f0v35lJ6CsuXQxnlXMq+uHCcECfkLY8apdfr3xbR7Nrm4TC6erTq1u
         x8aKSIeDPdXmMZqU0KAZEKjtNJN/2enPWNfDMlHiU3yzn+DlIZORiMljEtv48rXNZN
         +xS+ZQcGnl+E3Z37rSp9+BvQxGB7G7gIziWS54dIpEFGfYRYNpyU3TlXt9kBNrnKtT
         rjU1AZVFsuHyQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org
Subject: [PATCH] fscrypt: split up FS_CRYPTO_BLOCK_SIZE
Date:   Mon,  4 Apr 2022 18:09:14 -0700
Message-Id: <20220405010914.18519-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

FS_CRYPTO_BLOCK_SIZE is neither the filesystem block size nor the
granularity of encryption.  Rather, it defines two logically separate
constraints that both arise from the block size of the AES cipher:

- The alignment required for the lengths of file contents blocks
- The minimum input/output length for the filenames encryption modes

Since there are way too many things called the "block size", and the
connection with the AES block size is not easily understood, split
FS_CRYPTO_BLOCK_SIZE into two constants FSCRYPT_CONTENTS_ALIGNMENT and
FSCRYPT_FNAME_MIN_MSG_LEN that more clearly describe what they are.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c      | 10 +++++-----
 fs/crypto/fname.c       | 11 +++++++++--
 fs/ubifs/ubifs.h        |  2 +-
 include/linux/fscrypt.h | 12 +++++++++++-
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 526a4c1bed994..e78be66bbf015 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -113,7 +113,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 
 	if (WARN_ON_ONCE(len <= 0))
 		return -EINVAL;
-	if (WARN_ON_ONCE(len % FS_CRYPTO_BLOCK_SIZE != 0))
+	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
 		return -EINVAL;
 
 	fscrypt_generate_iv(&iv, lblk_num, ci);
@@ -213,8 +213,8 @@ EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
  * fscrypt_encrypt_block_inplace() - Encrypt a filesystem block in-place
  * @inode:     The inode to which this block belongs
  * @page:      The page containing the block to encrypt
- * @len:       Size of block to encrypt.  Doesn't need to be a multiple of the
- *		fs block size, but must be a multiple of FS_CRYPTO_BLOCK_SIZE.
+ * @len:       Size of block to encrypt.  This must be a multiple of
+ *		FSCRYPT_CONTENTS_ALIGNMENT.
  * @offs:      Byte offset within @page at which the block to encrypt begins
  * @lblk_num:  Filesystem logical block number of the block, i.e. the 0-based
  *		number of the block within the file
@@ -283,8 +283,8 @@ EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
  * fscrypt_decrypt_block_inplace() - Decrypt a filesystem block in-place
  * @inode:     The inode to which this block belongs
  * @page:      The page containing the block to decrypt
- * @len:       Size of block to decrypt.  Doesn't need to be a multiple of the
- *		fs block size, but must be a multiple of FS_CRYPTO_BLOCK_SIZE.
+ * @len:       Size of block to decrypt.  This must be a multiple of
+ *		FSCRYPT_CONTENTS_ALIGNMENT.
  * @offs:      Byte offset within @page at which the block to decrypt begins
  * @lblk_num:  Filesystem logical block number of the block, i.e. the 0-based
  *		number of the block within the file
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index a9be4bc74a94a..14e0ef5e9a20a 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -18,6 +18,13 @@
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
+/*
+ * The minimum message length (input and output length), in bytes, for all
+ * filenames encryption modes.  Filenames shorter than this will be zero-padded
+ * before being encrypted.
+ */
+#define FSCRYPT_FNAME_MIN_MSG_LEN 16
+
 /*
  * struct fscrypt_nokey_name - identifier for directory entry when key is absent
  *
@@ -267,7 +274,7 @@ bool fscrypt_fname_encrypted_size(const union fscrypt_policy *policy,
 
 	if (orig_len > max_len)
 		return false;
-	encrypted_len = max(orig_len, (u32)FS_CRYPTO_BLOCK_SIZE);
+	encrypted_len = max_t(u32, orig_len, FSCRYPT_FNAME_MIN_MSG_LEN);
 	encrypted_len = round_up(encrypted_len, padding);
 	*encrypted_len_ret = min(encrypted_len, max_len);
 	return true;
@@ -350,7 +357,7 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 		return 0;
 	}
 
-	if (iname->len < FS_CRYPTO_BLOCK_SIZE)
+	if (iname->len < FSCRYPT_FNAME_MIN_MSG_LEN)
 		return -EUCLEAN;
 
 	if (fscrypt_has_encryption_key(inode))
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 008fa46ef61e7..7d6d2f152e039 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -132,7 +132,7 @@
 #define WORST_COMPR_FACTOR 2
 
 #ifdef CONFIG_FS_ENCRYPTION
-#define UBIFS_CIPHER_BLOCK_SIZE FS_CRYPTO_BLOCK_SIZE
+#define UBIFS_CIPHER_BLOCK_SIZE FSCRYPT_CONTENTS_ALIGNMENT
 #else
 #define UBIFS_CIPHER_BLOCK_SIZE 0
 #endif
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 50d92d805bd8c..efc7f96e5e26b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -18,7 +18,17 @@
 #include <linux/slab.h>
 #include <uapi/linux/fscrypt.h>
 
-#define FS_CRYPTO_BLOCK_SIZE		16
+/*
+ * The lengths of all file contents blocks must be divisible by this value.
+ * This is needed to ensure that all contents encryption modes will work, as
+ * some of the supported modes don't support arbitrarily byte-aligned messages.
+ *
+ * Since the needed alignment is 16 bytes, most filesystems will meet this
+ * requirement naturally, as typical block sizes are powers of 2.  However, if a
+ * filesystem can generate arbitrarily byte-aligned block lengths (e.g., via
+ * compression), then it will need to pad to this alignment before encryption.
+ */
+#define FSCRYPT_CONTENTS_ALIGNMENT 16
 
 union fscrypt_policy;
 struct fscrypt_info;
-- 
2.35.1

