Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54424790574
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235725AbjIBF4R (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjIBF4Q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:16 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15EE10F4;
        Fri,  1 Sep 2023 22:56:13 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3D1E6807EE;
        Sat,  2 Sep 2023 01:56:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634173; bh=f/KDTmj8qltktWsMIyHJJg5ruFMNDD45n9oJKTrCgso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dS9LvgxPoY4UoJ//ZM/9dXk1DSqD1+1Sl9REVKkz69k82yR2d9zECadZsRdvW4Zts
         T6oytW2ogIfQCiTkhRKtA9EcwuUlkBDc08X2ZQD/v0t/s3DJ+Ur13iTFsBVD+Kfmbd
         bdBLoJ8bn0ezMnE3h/TCJFWMgeNJimH7AXIAQTEd3nBRFcHfOqiGffMRwql29Fu5TB
         kaxCdsPF7t/4WSqDWH3odgGmFtu4cxe3MOmV7xMHtUK3/VaKbWStjf9IxKb9YemyB5
         Guvp83jXtrLan9zxbpxAXlQYIwrKnQNi8sfLw3v4auAAOfiJvhT3V72vzygHyGqc1+
         jBPr/heMMA39A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 12/13] fscrypt: allow asynchronous info freeing
Date:   Sat,  2 Sep 2023 01:54:30 -0400
Message-ID: <a7eb6e15940fa7afd800a10d80adff7e29fff926.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs sometimes frees extents while holding a mutex. This makes it hard
to free the prepared keys associated therewith, as the free process may
need to take a semaphore. Just offloading freeing to rcu doesn't work,
as rcu may call the callback in softirq context, which also doesn't
allow taking a semaphore. Thus, for extent infos, offload their freeing
to the general system workqueue.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 12 +++++++++---
 fs/crypto/keyring.c         |  6 +++---
 fs/crypto/keysetup.c        | 31 +++++++++++++++++++++++++++----
 fs/crypto/keysetup_v1.c     |  3 +--
 4 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 30459e219fc3..67f33ad704a3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -217,6 +217,12 @@ struct fscrypt_prepared_key {
 	 */
 	size_t device_count;
 #endif
+	/*
+	 * For destroying asynchronously.
+	 */
+	struct work_struct work;
+	/* A pointer to free after destroy. */
+	void *ptr_to_free;
 	enum fscrypt_prepared_key_type type;
 };
 
@@ -528,8 +534,7 @@ fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 }
 
 static inline void
-fscrypt_destroy_inline_crypt_key(struct super_block *sb,
-				 struct fscrypt_prepared_key *prep_key)
+fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 {
 }
 
@@ -751,7 +756,8 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const struct fscrypt_common_info *ci);
 
 void fscrypt_destroy_prepared_key(struct super_block *sb,
-				  struct fscrypt_prepared_key *prep_key);
+				  struct fscrypt_prepared_key *prep_key,
+				  void *ptr_to_free);
 
 int fscrypt_set_per_info_enc_key(struct fscrypt_common_info *ci, const u8 *raw_key);
 
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 9235a5a9bcba..d4ec4ff27266 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -107,11 +107,11 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_direct_keys[i]);
+				sb, &mk->mk_direct_keys[i], NULL);
 		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_iv_ino_lblk_64_keys[i]);
+				sb, &mk->mk_iv_ino_lblk_64_keys[i], NULL);
 		fscrypt_destroy_prepared_key(
-				sb, &mk->mk_iv_ino_lblk_32_keys[i]);
+				sb, &mk->mk_iv_ino_lblk_32_keys[i], NULL);
 	}
 	memzero_explicit(&mk->mk_ino_hash_key,
 			 sizeof(mk->mk_ino_hash_key));
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 4ea9b68363d5..293a7d765ca7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -179,13 +179,36 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 	return 0;
 }
 
-/* Destroy a crypto transform object and/or blk-crypto key. */
-void fscrypt_destroy_prepared_key(struct super_block *sb,
-				  struct fscrypt_prepared_key *prep_key)
+static void __destroy_key(struct fscrypt_prepared_key *prep_key)
 {
+	void *ptr_to_free = prep_key->ptr_to_free;
+
 	crypto_free_skcipher(prep_key->tfm);
 	fscrypt_destroy_inline_crypt_key(prep_key);
 	memzero_explicit(prep_key, sizeof(*prep_key));
+	if (ptr_to_free)
+		kfree_sensitive(ptr_to_free);
+}
+
+static void __destroy_key_work(struct work_struct *work)
+{
+	struct fscrypt_prepared_key *prep_key =
+		container_of(work, struct fscrypt_prepared_key, work);
+
+	__destroy_key(prep_key);
+}
+
+/* Destroy a crypto transform object and/or blk-crypto key. */
+void fscrypt_destroy_prepared_key(struct super_block *sb,
+				  struct fscrypt_prepared_key *prep_key,
+				  void *ptr_to_free)
+{
+	prep_key->ptr_to_free = ptr_to_free;
+	if (fscrypt_fs_uses_extent_encryption(sb)) {
+		INIT_WORK(&prep_key->work, __destroy_key_work);
+		queue_work(system_unbound_wq, &prep_key->work);
+	} else
+		__destroy_key(prep_key);
 }
 
 /* Given a per-info encryption key, set up the info's crypto transform object */
@@ -594,8 +617,8 @@ static void free_prepared_key(struct fscrypt_common_info *cci)
 			fscrypt_put_direct_key(cci->ci_enc_key);
 		if (type == FSCRYPT_KEY_PER_INFO) {
 			fscrypt_destroy_prepared_key(cci->ci_inode->i_sb,
+						     cci->ci_enc_key,
 						     cci->ci_enc_key);
-			kfree_sensitive(cci->ci_enc_key);
 		}
 	}
 }
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index b57ed49ac201..8ccd8d4154d0 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -155,8 +155,7 @@ struct fscrypt_direct_key {
 static void free_direct_key(struct fscrypt_direct_key *dk)
 {
 	if (dk) {
-		fscrypt_destroy_prepared_key(dk->dk_sb, &dk->dk_key);
-		kfree_sensitive(dk);
+		fscrypt_destroy_prepared_key(dk->dk_sb, &dk->dk_key, dk);
 	}
 }
 
-- 
2.41.0

