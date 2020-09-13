Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FFD267EBD
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgIMIil (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725967AbgIMIiD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:03 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0090E221E7;
        Sun, 13 Sep 2020 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986280;
        bh=MK+A5d7zq9Y3Zsp3oOCC55fP5PFX6LAy1zZJkGWXiO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNXvgR5be/gzPpLGuUrvSdScKa/sWQTRwvtGRXdyLDV9JksHQuCd363gzeItv1NTO
         fe8DHiB/3NngDwFC1HJAMcMhn7T+d0fNkZRqLoTsAqiPgTyy1iW2iC1bdIXYivfggq
         BghRF3rUV5A5hGY+UX1g51VGbPjjlUjgDIdH+ssE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 08/11] fscrypt: stop pretending that key setup is nofs-safe
Date:   Sun, 13 Sep 2020 01:36:17 -0700
Message-Id: <20200913083620.170627-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200913083620.170627-1-ebiggers@kernel.org>
References: <20200913083620.170627-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_get_encryption_info() has never actually been safe to call in a
context that needs GFP_NOFS, since it calls crypto_alloc_skcipher().

crypto_alloc_skcipher() isn't GFP_NOFS-safe, even if called under
memalloc_nofs_save().  This is because it may load kernel modules, and
also because it internally takes crypto_alg_sem.  Other tasks can do
GFP_KERNEL allocations while holding crypto_alg_sem for write.

The use of fscrypt_init_mutex isn't GFP_NOFS-safe either.

So, stop pretending that fscrypt_get_encryption_info() is nofs-safe.
I.e., when it allocates memory, just use GFP_KERNEL instead of GFP_NOFS.

Note, another reason to do this is that GFP_NOFS is deprecated in favor
of using memalloc_nofs_save() in the proper places.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/inline_crypt.c | 7 ++-----
 fs/crypto/keysetup.c     | 2 +-
 fs/crypto/keysetup_v1.c  | 8 ++++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index faa25541ccb68..89bffa82ed74a 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -106,7 +106,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	crypto_cfg.data_unit_size = sb->s_blocksize;
 	crypto_cfg.dun_bytes = fscrypt_get_dun_bytes(ci);
 	num_devs = fscrypt_get_num_devices(sb);
-	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_NOFS);
+	devs = kmalloc_array(num_devs, sizeof(*devs), GFP_KERNEL);
 	if (!devs)
 		return -ENOMEM;
 	fscrypt_get_devices(sb, num_devs, devs);
@@ -135,9 +135,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 	struct fscrypt_blk_crypto_key *blk_key;
 	int err;
 	int i;
-	unsigned int flags;
 
-	blk_key = kzalloc(struct_size(blk_key, devs, num_devs), GFP_NOFS);
+	blk_key = kzalloc(struct_size(blk_key, devs, num_devs), GFP_KERNEL);
 	if (!blk_key)
 		return -ENOMEM;
 
@@ -166,10 +165,8 @@ int fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 		}
 		queue_refs++;
 
-		flags = memalloc_nofs_save();
 		err = blk_crypto_start_using_key(&blk_key->base,
 						 blk_key->devs[i]);
-		memalloc_nofs_restore(flags);
 		if (err) {
 			fscrypt_err(inode,
 				    "error %d starting to use blk-crypto", err);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 5371eee8f4b30..7f5fbc2654d57 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -485,7 +485,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		return res;
 
-	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_NOFS);
+	crypt_info = kmem_cache_zalloc(fscrypt_info_cachep, GFP_KERNEL);
 	if (!crypt_info)
 		return -ENOMEM;
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index a3cb52572b05c..2762c53504323 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -60,7 +60,7 @@ static int derive_key_aes(const u8 *master_key,
 		goto out;
 	}
 	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
-	req = skcipher_request_alloc(tfm, GFP_NOFS);
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		res = -ENOMEM;
 		goto out;
@@ -99,7 +99,7 @@ find_and_lock_process_key(const char *prefix,
 	const struct user_key_payload *ukp;
 	const struct fscrypt_key *payload;
 
-	description = kasprintf(GFP_NOFS, "%s%*phN", prefix,
+	description = kasprintf(GFP_KERNEL, "%s%*phN", prefix,
 				FSCRYPT_KEY_DESCRIPTOR_SIZE, descriptor);
 	if (!description)
 		return ERR_PTR(-ENOMEM);
@@ -228,7 +228,7 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 		return dk;
 
 	/* Nope, allocate one. */
-	dk = kzalloc(sizeof(*dk), GFP_NOFS);
+	dk = kzalloc(sizeof(*dk), GFP_KERNEL);
 	if (!dk)
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&dk->dk_refcount, 1);
@@ -272,7 +272,7 @@ static int setup_v1_file_key_derived(struct fscrypt_info *ci,
 	 * This cannot be a stack buffer because it will be passed to the
 	 * scatterlist crypto API during derive_key_aes().
 	 */
-	derived_key = kmalloc(ci->ci_mode->keysize, GFP_NOFS);
+	derived_key = kmalloc(ci->ci_mode->keysize, GFP_KERNEL);
 	if (!derived_key)
 		return -ENOMEM;
 
-- 
2.28.0

