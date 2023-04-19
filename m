Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD98E6E712A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjDSCm0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSCm0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:26 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CABA619B
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:25 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7883180529;
        Tue, 18 Apr 2023 22:42:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872144; bh=Ijz/vYd6LqXOA8ADiLuNtP0ypKMGVc9dVkDScUro6QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WQX00hxa0yxj2dOCAjDBPet5jAD2ekXbFoc5KXLgsOPvK44gYuF2AvYS7UihINai8
         EtLFR5/c861QUpf+7VboSgeRniP0SaFKP0M/tZVKEIGSrQJCFa366JzqfJqvk8TOR8
         7OnFVt7tlVxC7qlQ10iu1jKxrqKn0r89F9L0uhCF/ZNuSWYCkNtnmLbZfwG+3MyhnX
         yWQIL+DT3J89OXcMemDb29G2kU9fPHMx2VG4DE0I7UMBElVMUGBBp4RIPxCiD+ldKI
         hIJ7ULDdqBu/kqgdYNHCLjBCJnpk+85vOHQC+mvaZ8xlEMB3IFJFhQzGnXf4j+qYrk
         iZLQZ63LzVktA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 1/7] fscrypt: add new pooled prepared keys.
Date:   Tue, 18 Apr 2023 22:42:10 -0400
Message-Id: <833c7892da7981e46e13d1be9aa4629926448bd1.1681871298.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681871298.git.sweettea-kernel@dorminy.me>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For extent-based encryption, we need to avoid allocating prepared keys
at IO time, since crypto_skcipher allocation takes a lock and can do IO
itself. As such, we will need to use pooled prepared keys. This change
begins adding pooled prepared keys, but doesn't use them yet.

For testing, fscrypt_using_pooled_prepared_keys() can be changed to use
pooled keys for leaf inodes, so that pooled prepared keys are used for
contents encryption for v2 default-key policies.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  9 ++++++
 fs/crypto/keysetup.c        | 62 ++++++++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index eb302e342fb9..4942a8ae2061 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -30,6 +30,11 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+#define FSCRYPT_POLICY_FLAGS_KEY_MASK		\
+	(FSCRYPT_POLICY_FLAG_DIRECT_KEY		\
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	\
+	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)
+
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
 #define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
@@ -185,11 +190,15 @@ struct fscrypt_symlink_data {
  *			    part of a fscrypt_master_key, shared between all
  *			    users of this master key having this mode and
  *			    policy.
+ * @FSCRYPT_KEY_POOLED: this prepared key is embedded in a
+ *			fscrypt_pooled_prepared_key. It should be returned to
+ *			its pool when no longer in use.
  */
 enum fscrypt_prepared_key_type {
 	FSCRYPT_KEY_PER_INFO = 1,
 	FSCRYPT_KEY_DIRECT_V1,
 	FSCRYPT_KEY_MASTER_KEY,
+	FSCRYPT_KEY_POOLED,
 } __packed;
 
 /**
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 9cd60e09b0c5..171114fd5590 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -89,6 +89,10 @@ struct fscrypt_mode fscrypt_modes[] = {
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
 
+struct fscrypt_pooled_prepared_key {
+	struct fscrypt_prepared_key prep_key;
+};
+
 static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
@@ -117,6 +121,21 @@ static int lock_master_key(struct fscrypt_master_key *mk)
 	return 0;
 }
 
+static inline bool
+fscrypt_using_pooled_prepared_key(const struct fscrypt_info *ci)
+{
+	if (ci->ci_policy.version != FSCRYPT_POLICY_V2)
+		return false;
+	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAGS_KEY_MASK)
+		return false;
+	if (fscrypt_using_inline_encryption(ci))
+		return false;
+
+	if (!S_ISREG(ci->ci_inode->i_mode))
+		return false;
+	return false;
+}
+
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
  * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
@@ -140,7 +159,6 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 	return err;
 }
 
-
 /* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
@@ -213,14 +231,31 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
 {
 	int err;
 
-	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
-	if (!ci->ci_enc_key)
-		return -ENOMEM;
+	if (fscrypt_using_pooled_prepared_key(ci)) {
+		struct fscrypt_pooled_prepared_key *pooled_key;
 
-	ci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
-	err = fscrypt_allocate_key_member(ci->ci_enc_key, ci);
-	if (err)
-		return err;
+		pooled_key = kzalloc(sizeof(*pooled_key), GFP_KERNEL);
+		if (!pooled_key)
+			return -ENOMEM;
+
+		err = fscrypt_allocate_key_member(&pooled_key->prep_key, ci);
+		if (err) {
+			kfree(pooled_key);
+			return err;
+		}
+
+		pooled_key->prep_key.type = FSCRYPT_KEY_POOLED;
+		ci->ci_enc_key = &pooled_key->prep_key;
+	} else {
+		ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
+		if (!ci->ci_enc_key)
+			return -ENOMEM;
+
+		ci->ci_enc_key->type = FSCRYPT_KEY_PER_INFO;
+		err = fscrypt_allocate_key_member(ci->ci_enc_key, ci);
+		if (err)
+			return err;
+	}
 
 	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
 }
@@ -616,6 +651,17 @@ static void put_crypt_info(struct fscrypt_info *ci)
 						     ci->ci_enc_key);
 			kfree_sensitive(ci->ci_enc_key);
 		}
+		if (type == FSCRYPT_KEY_POOLED) {
+			struct fscrypt_pooled_prepared_key *pooled_key;
+
+			pooled_key = container_of(ci->ci_enc_key,
+						  struct fscrypt_pooled_prepared_key,
+						  prep_key);
+
+			fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
+						     ci->ci_enc_key);
+			kfree_sensitive(pooled_key);
+		}
 	}
 
 	mk = ci->ci_master_key;
-- 
2.40.0

