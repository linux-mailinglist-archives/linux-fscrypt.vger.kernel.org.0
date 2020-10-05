Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737382830F4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 09:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgJEHgV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 03:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbgJEHgS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 03:36:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99693C0613A8
        for <linux-fscrypt@vger.kernel.org>; Mon,  5 Oct 2020 00:36:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f199so8921908yba.12
        for <linux-fscrypt@vger.kernel.org>; Mon, 05 Oct 2020 00:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6it/52lmg4W3wLyYi3d7Plv4UDu4Yutc2uS93yL0Ts0=;
        b=IhFgftIzZAnmJlKhGAq4n5Lm1PzuUm13YbZgx99S+eVswOrPQ4lVhCGiB1Nrtzhy99
         JFXQw8gJ9TKa45+e0vk/alX272T+Jx9D/px6F4eZscMd95Ry/I1mVU62KHFe/dvJKX45
         Q+sgCc1h4ROQKS/A4nUdQaQXKiWuKT17OrUq0KUpr3R2rv4z4Hbc0Abs07xh2pOOaSu7
         PZG0pfGQyD5sD89p6WN51RCXXn7YF8MhHjeyGe6qB2A4zQI41JRUw5UpIWT3NHHMuEhb
         wwpSWF7WsBVYYKHMCd1UH20niAprgz6Spxr3nUM/Q4rocEt9mwITrZGxA1EZ8NbrFted
         s5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6it/52lmg4W3wLyYi3d7Plv4UDu4Yutc2uS93yL0Ts0=;
        b=U0L+Oy5YbwVy9QRxstJtgwqgre/JRiA/OHUbnrkDMYHt82YhJ4aQarGUIVp4gUe8sm
         isqGruPiwZpzkisPEbzQFVYFBCh8JV0Kv4anDUbECoctKs4/bo3FoFE6mxNkjXth+jYK
         m7jklC9yNxdO6jrv+NwO2pCKDDNKC5MtkeNUodVL2ZKKoZORPKnh69eo9YbqHv8M6aWY
         +Q84Djm6Mzj65/0xTEVihyeSZiIndFmSi8XpYuOTuWsQ4vnGxwvtFhuRL00INec2CETy
         iSVfiYEybi0+Qd9e3uDlO8SVY7bFq6sgq0/tkuBU9UOnmY9+67Ipd8MlHMznJpLF0oE2
         wSaw==
X-Gm-Message-State: AOAM532TnYqFh3Ajr1xjzE/huKUlPbb7ZC1AnOFth0xH1uU2yKS/1As3
        yvBnjeoCMyiXXl5Sn4dbCYLRSZBqSsE=
X-Google-Smtp-Source: ABdhPJzAsZ1vv0A688VdcDETTl2/ICPFDeu2DtSgo3iuR4LMbMtyGfdsDa3+pOa8x9USbzNA3lSdPduDRCg=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:a083:: with SMTP id y3mr17551841ybh.296.1601883377704;
 Mon, 05 Oct 2020 00:36:17 -0700 (PDT)
Date:   Mon,  5 Oct 2020 07:36:05 +0000
In-Reply-To: <20201005073606.1949772-1-satyat@google.com>
Message-Id: <20201005073606.1949772-3-satyat@google.com>
Mime-Version: 1.0
References: <20201005073606.1949772-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 2/3] fscrypt: Add metadata encryption support
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Introduces functions that help with metadata encryption.

In particular, we introduce:

fscrypt_setup_metadata_encryption() - filesystems should call this function
to set up metadata encryption on a super block with the encryption
algorithm (the desired FSCRYPT_MODE_*) and the key descriptor of the
encryption key. The key descriptor is looked up in the logon keyring of the
current session using "fscrypt:" as the descriptor prefix.

fscrypt_metadata_crypt_bio() - filesystems should call this function on a
bio that it wants metadata crypted. This function will set a bio-crypt-ctx
on the bio if the metadata key was set up with
fscrypt_setup_metadata_encryption(). The DUN for the first block in the bio
is the offset of that block from the start of the filesystem.

fscrypt_free_metadata_encryption() - this function should be called when
the super block is being freed. It ensures that the metadata encryption key
is evicted, if necessary, from devices.

Note that the filesystem (rather than fscrypt) controls precisely which
blocks are encrypted with the metadata encryption key and which blocks are
encrypted with other keys/not encrypted at all. Fscrypt only provides some
convenience functions that ultimately help encrypt a bio with the metadata
encryption key when desired.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/crypto/Kconfig           |   6 +
 fs/crypto/Makefile          |   1 +
 fs/crypto/fscrypt_private.h |  19 ++++
 fs/crypto/inline_crypt.c    |  18 ---
 fs/crypto/metadata_crypt.c  | 220 ++++++++++++++++++++++++++++++++++++
 include/linux/fs.h          |   3 +
 include/linux/fscrypt.h     |  47 ++++++++
 7 files changed, 296 insertions(+), 18 deletions(-)
 create mode 100644 fs/crypto/metadata_crypt.c

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index a5f5c30368a2..3010e91f6659 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -30,3 +30,9 @@ config FS_ENCRYPTION_INLINE_CRYPT
 	depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
 	help
 	  Enable fscrypt to use inline encryption hardware if available.
+
+config FS_ENCRYPTION_METADATA
+	bool "Enable metadata encryption with fscrypt"
+	depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
+	help
+	  Enable fscrypt to encrypt metadata.
\ No newline at end of file
diff --git a/fs/crypto/Makefile b/fs/crypto/Makefile
index 652c7180ec6d..8403c7956983 100644
--- a/fs/crypto/Makefile
+++ b/fs/crypto/Makefile
@@ -12,3 +12,4 @@ fscrypto-y := crypto.o \
 
 fscrypto-$(CONFIG_BLOCK) += bio.o
 fscrypto-$(CONFIG_FS_ENCRYPTION_INLINE_CRYPT) += inline_crypt.o
+fscrypto-$(CONFIG_FS_ENCRYPTION_METADATA) += metadata_crypt.o
\ No newline at end of file
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8117a61b6f55..dca254590a70 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -327,6 +327,25 @@ int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 void fscrypt_destroy_hkdf(struct fscrypt_hkdf *hkdf);
 
 /* inline_crypt.c */
+
+static inline int fscrypt_get_num_devices(struct super_block *sb)
+{
+	if (sb->s_cop->get_num_devices)
+		return sb->s_cop->get_num_devices(sb);
+	return 1;
+}
+
+static inline struct request_queue *fscrypt_get_device(struct super_block *sb,
+						unsigned int device_index)
+{
+	if (sb->s_cop->get_device)
+		return sb->s_cop->get_device(sb, device_index);
+	else if (WARN_ON_ONCE(device_index != 0))
+		return NULL;
+	else
+		return bdev_get_queue(sb->s_bdev);
+}
+
 #ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
 int fscrypt_select_encryption_impl(struct fscrypt_info *ci);
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 5bbce79df638..f8f7363ebcd0 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -26,24 +26,6 @@ struct fscrypt_blk_crypto_key {
 	struct request_queue *devs[];
 };
 
-static int fscrypt_get_num_devices(struct super_block *sb)
-{
-	if (sb->s_cop->get_num_devices)
-		return sb->s_cop->get_num_devices(sb);
-	return 1;
-}
-
-static struct request_queue *fscrypt_get_device(struct super_block *sb,
-						unsigned int device_index)
-{
-	if (sb->s_cop->get_device)
-		return sb->s_cop->get_device(sb, device_index);
-	else if (WARN_ON_ONCE(device_index != 0))
-		return NULL;
-	else
-		return bdev_get_queue(sb->s_bdev);
-}
-
 static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
 {
 	struct super_block *sb = ci->ci_inode->i_sb;
diff --git a/fs/crypto/metadata_crypt.c b/fs/crypto/metadata_crypt.c
new file mode 100644
index 000000000000..5e16df130509
--- /dev/null
+++ b/fs/crypto/metadata_crypt.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Metadata encryption support for fscrypt
+ *
+ * Copyright 2020 Google LLC
+ */
+
+#include <keys/user-type.h>
+#include <linux/blk-crypto.h>
+#include <linux/blkdev.h>
+#include <linux/buffer_head.h>
+#include <linux/sched/mm.h>
+
+#include "fscrypt_private.h"
+
+/* TODO: mostly copied from keysetup_v1.c - maybe refactor this function */
+static int fscrypt_metadata_get_key_from_id(const char *prefix,
+					    char *descriptor_hex,
+					    unsigned int min_keysize,
+					    char *raw_key)
+{
+	char *description;
+	struct key *key;
+	const struct user_key_payload *ukp;
+	const struct fscrypt_key *payload;
+	int err = -ENOKEY;
+
+	if (strlen(descriptor_hex) != FSCRYPT_KEY_DESCRIPTOR_SIZE * 2)
+		return -EINVAL;
+
+	description = kasprintf(GFP_NOFS, "%s%s", prefix, descriptor_hex);
+	if (!description)
+		return -ENOMEM;
+
+	key = request_key(&key_type_logon, description, NULL);
+	kfree(description);
+	if (IS_ERR(key))
+		return PTR_ERR(key);
+
+	down_read(&key->sem);
+	ukp = user_key_payload_locked(key);
+
+	if (!ukp) /* was the key revoked before we acquired its semaphore? */
+		goto out;
+
+	payload = (const struct fscrypt_key *)ukp->data;
+
+	if (ukp->datalen != sizeof(struct fscrypt_key) ||
+	    payload->size < 1 || payload->size > FSCRYPT_MAX_KEY_SIZE) {
+		fscrypt_warn(NULL,
+			     "key with description '%s' has invalid payload",
+			     key->description);
+		goto out;
+	}
+
+	if (payload->size < min_keysize) {
+		fscrypt_warn(NULL,
+			     "key with description '%s' is too short (got %u bytes, need %u+ bytes)",
+			     key->description, payload->size, min_keysize);
+		goto out;
+	}
+
+	memcpy(raw_key, payload->raw, min_keysize);
+	err = 0;
+
+out:
+	up_read(&key->sem);
+	key_put(key);
+
+	return err;
+}
+
+/**
+ * fscrypt_setup_metadata_encryption() - prepare a super_block for metadata
+ *					 encryption
+ * @sb: The super_block to set up metadata encryption for
+ * @key_desc_hex: The key descriptor (in hex) to look for in the logon keyring.
+ * @fscrypt_mode_num: The FSCRYPT_MODE_* to use as the encryption algorithm.
+ *
+ * Return: 0 on success, negative number on error.
+ */
+int fscrypt_setup_metadata_encryption(struct super_block *sb,
+				      char *key_desc_hex,
+				      int fscrypt_mode_num)
+{
+	int err = 0;
+	enum blk_crypto_mode_num crypto_mode;
+	unsigned int lblk_bits = 64;
+	unsigned int dun_bytes;
+	unsigned int dummy;
+	char raw_key[FSCRYPT_MAX_KEY_SIZE];
+
+	if (fscrypt_mode_num > __FSCRYPT_MODE_MAX || fscrypt_mode_num < 0 ||
+	    !fscrypt_modes[fscrypt_mode_num].cipher_str) {
+		fscrypt_warn(NULL, "Invalid fscrypt mode %d specified for metadata encryption.",
+			     fscrypt_mode_num);
+		return -EOPNOTSUPP;
+	}
+
+	if (sb->s_cop->get_ino_and_lblk_bits)
+		sb->s_cop->get_ino_and_lblk_bits(sb, &dummy, &lblk_bits);
+	dun_bytes = DIV_ROUND_UP(lblk_bits, 8);
+
+	if (fscrypt_modes[fscrypt_mode_num].ivsize < dun_bytes) {
+		fscrypt_warn(NULL, "The fscrypt mode only supports %d DUN bytes, but FS requires support for %d DUN bytes.",
+			     fscrypt_modes[fscrypt_mode_num].ivsize, dun_bytes);
+		return -EOPNOTSUPP;
+	}
+
+	crypto_mode = fscrypt_modes[fscrypt_mode_num].blk_crypto_mode;
+
+	err = fscrypt_metadata_get_key_from_id(
+					FSCRYPT_KEY_DESC_PREFIX,
+					key_desc_hex,
+					fscrypt_modes[fscrypt_mode_num].keysize,
+					raw_key);
+	if (err)
+		goto out;
+
+	sb->s_metadata_key = kzalloc(sizeof(*sb->s_metadata_key), GFP_NOFS);
+	if (!sb->s_metadata_key) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = blk_crypto_init_key(sb->s_metadata_key, raw_key, crypto_mode,
+				  dun_bytes, sb->s_blocksize);
+	if (err)
+		goto out_free_key;
+
+	err = blk_crypto_start_using_key(sb->s_metadata_key,
+					 bdev_get_queue(sb->s_bdev));
+	if (err)
+		goto out_free_key;
+
+	goto out;
+out_free_key:
+	fscrypt_free_metadata_encryption(sb);
+out:
+	memzero_explicit(raw_key, sizeof(raw_key));
+	return err;
+}
+
+/**
+ * fscrypt_metadata_crypt_prepare_all_devices() - prepare all devices used by
+ *					the filesystem for metadata encryption.
+ * @sb: The super_block whose devices to prepare
+ *
+ * This function should be called when the filesystem has determined all its
+ * devices. This might happen only after some initial setup, which is why
+ * this is a separate function from fscrypt_setup_metadata_encryption().
+ *
+ * Return: 0 on success, negative on error.
+ */
+int fscrypt_metadata_crypt_prepare_all_devices(struct super_block *sb)
+{
+	int num_devices;
+	int i;
+	struct request_queue *q;
+
+	if (!sb->s_metadata_key)
+		return 0;
+
+	num_devices = fscrypt_get_num_devices(sb);
+	for (i = 0; i < num_devices; i++) {
+		q = fscrypt_get_device(sb, i);
+		if (!q || blk_crypto_start_using_key(sb->s_metadata_key, q))
+			return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+/**
+ * fscrypt_free_metadata_encryption() - free metadata encryption fields in
+ *					super_block.
+ * @sb: The super_block to free metatdata encryption fields from
+ */
+void fscrypt_free_metadata_encryption(struct super_block *sb)
+{
+	int num_devices;
+	int i;
+	struct request_queue *q;
+
+	if (!sb->s_metadata_key)
+		return;
+
+	num_devices = fscrypt_get_num_devices(sb);
+
+	for (i = 0; i < num_devices; i++) {
+		q = fscrypt_get_device(sb, i);
+		if (WARN_ON(!q))
+			continue;
+		blk_crypto_evict_key(q, sb->s_metadata_key);
+	}
+
+	memzero_explicit(sb->s_metadata_key, sizeof(*sb->s_metadata_key));
+	kzfree(sb->s_metadata_key);
+	sb->s_metadata_key = NULL;
+}
+
+/**
+ * fscrypt_metadata_crypt_bio() - Add metadata encryption context to bio.
+ *
+ * @bio: The bio to add the encryption context to
+ * @lblk: The logical block number within the filesystem at which this bio
+ *	  starts reading/writing data.
+ * @sb: The superblock of the filesystem
+ * @gfp_mask: gfp_mask for bio_crypt_context allocation
+ */
+void fscrypt_metadata_crypt_bio(struct bio *bio, u64 lblk,
+				struct super_block *sb, gfp_t gfp_mask)
+{
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = { 0 };
+
+	if (!sb->s_metadata_key)
+		return;
+
+	dun[0] = lblk;
+	bio_crypt_set_ctx(bio, sb->s_metadata_key, dun, gfp_mask);
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7519ae003a08..aba3b0e2d56f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1438,6 +1438,9 @@ struct super_block {
 	const struct fscrypt_operations	*s_cop;
 	struct key		*s_master_keys; /* master crypto keys in use */
 #endif
+#ifdef CONFIG_FS_ENCRYPTION_METADATA
+	struct blk_crypto_key	*s_metadata_key;
+#endif
 #ifdef CONFIG_FS_VERITY
 	const struct fsverity_operations *s_vop;
 #endif
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index d835fd19a20a..f7cdc8627984 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -594,6 +594,53 @@ static inline bool fscrypt_mergeable_bio_bh(struct bio *bio,
 }
 #endif /* !CONFIG_FS_ENCRYPTION_INLINE_CRYPT */
 
+/* metadata_crypt.c */
+#ifdef CONFIG_FS_ENCRYPTION_METADATA
+
+int fscrypt_setup_metadata_encryption(struct super_block *sb,
+				      char *key_desc_hex,
+				      int fscrypt_mode_num);
+
+int fscrypt_metadata_crypt_prepare_all_devices(struct super_block *sb);
+
+void fscrypt_free_metadata_encryption(struct super_block *sb);
+
+void fscrypt_metadata_crypt_bio(struct bio *bio, u64 lblk,
+				struct super_block *sb, gfp_t gfp_mask);
+
+static inline bool fscrypt_metadata_crypted(struct super_block *sb)
+{
+	return sb->s_metadata_key;
+}
+
+#else /* CONFIG_FS_ENCRYPTION_METADATA */
+
+static inline int fscrypt_setup_metadata_encryption(struct super_block *sb,
+						    char *key_desc_hex,
+						    int fscrypt_mode_num)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int
+fscrypt_metadata_crypt_prepare_all_devices(struct super_block *sb)
+{
+	return 0;
+}
+
+static inline void fscrypt_free_metadata_encryption(struct super_block *sb) { }
+
+static inline void fscrypt_metadata_crypt_bio(struct bio *bio, u64 lblk,
+					      struct super_block *sb,
+					      gfp_t gfp_mask) { }
+
+static inline bool fscrypt_metadata_crypted(struct super_block *sb)
+{
+	return false;
+}
+
+#endif /* CONFIG_FS_ENCRYPTION_METADATA */
+
 /**
  * fscrypt_inode_uses_inline_crypto() - test whether an inode uses inline
  *					encryption
-- 
2.28.0.806.g8561365e88-goog

