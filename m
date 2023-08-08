Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409CE774640
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbjHHSyd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjHHSyT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:19 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5123A8C;
        Tue,  8 Aug 2023 10:09:02 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 0F2B280029;
        Tue,  8 Aug 2023 13:09:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514542; bh=ukMXkhMtVtxX22ydxm2AoYUCCiVWA8QnfbaKw80mQOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WE0WH8NCn+UUWlAkf10jlQNpe6XbhQ6SIiC4aF+HNqcLSpqUYBWDEcHhGkXJz4ZtD
         LB5LO+UNKuQI2Gbqcn1Yu1lw1eUkZPkd655lY7nQBBCq/BdP8tf3VFiY/r9V6y+yig
         vDj35n+imPKbM/IPXvU7iqs8CczUrmUIAjOjAVFJBwMyKEnGyY01YX697nDunBCFnK
         PtdqZbEyxBr4IeXbMsZNXKCRGbzVK8/7jLEJdGe4aLA1WvYzOL47erq+MdPl8lCV8+
         64ND1OHgjsOlrUEXzewZxwPVyuLSZ0s7PgmxG2AnAel3Zb54s/NUHT2izPUOfQMdUK
         2lp9oC1IHq6QQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 15/16] fscrypt: allow asynchronous info freeing
Date:   Tue,  8 Aug 2023 13:08:32 -0400
Message-ID: <6c4a29fdfabf90f1a43dffff04debd54f941cf93.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index aba83509c735..2b95c3a9560f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -216,6 +216,12 @@ struct fscrypt_prepared_key {
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
 
@@ -526,8 +532,7 @@ fscrypt_prepare_inline_crypt_key(struct fscrypt_prepared_key *prep_key,
 }
 
 static inline void
-fscrypt_destroy_inline_crypt_key(struct super_block *sb,
-				 struct fscrypt_prepared_key *prep_key)
+fscrypt_destroy_inline_crypt_key(struct fscrypt_prepared_key *prep_key)
 {
 }
 
@@ -748,7 +753,8 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_info *ci);
 
 void fscrypt_destroy_prepared_key(struct super_block *sb,
-				  struct fscrypt_prepared_key *prep_key);
+				  struct fscrypt_prepared_key *prep_key,
+				  void *ptr_to_free);
 
 int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key);
 
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index feca4a8410bb..7826322b8528 100644
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
index fe246229c869..1acb676efe3e 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -190,13 +190,36 @@ int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
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
 
 /* Given a per-file encryption key, set up the file's crypto transform object */
@@ -608,8 +631,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 			fscrypt_put_direct_key(ci->ci_enc_key);
 		if (type == FSCRYPT_KEY_PER_INFO) {
 			fscrypt_destroy_prepared_key(ci->ci_sb,
+						     ci->ci_enc_key,
 						     ci->ci_enc_key);
-			kfree_sensitive(ci->ci_enc_key);
 		}
 	}
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 4f2be2377dfa..4f45e99290d9 100644
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

