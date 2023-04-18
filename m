Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069F06E6A76
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbjDRRFB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjDRRFA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:00 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F88B46A
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:04:58 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 358AC82601;
        Tue, 18 Apr 2023 13:04:58 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837498; bh=sewHxX6NTQoGhPnQldAneRt3lxUgP4NYJQ1E6+fyytE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MRq5WzFwB8uPAIJhYbjNYoVgWhP24+pcQeuGCHhpCu2/lYw7hZZYb/RTVkAUABS8k
         4y4oH8YUoYMdTiin6VQk30Lw1sTicOSBGjsLKvi+s/1i5x4KdplSk4oYyXqiKJZM5i
         LZ/eVUqE1qKxjcp5bg3zFd4u2BHqO1KN+tTbU0tjsg1KpDpjpA2CScrzuWzY0Rx7wd
         +4IBCCGos45rMjCE2aUGYsx6uupuS3Xj4Sb5hUDmAGk/iWG10C2sMVlQhni2FmeUa4
         /UfStzzQIqtb8jHudds2rbmrrUsHzinDskP2iGmGop1g4aNp2bLNXsWbLrg0CJheCc
         AtaOPda/ra1zg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 05/11] fscrypt: reduce special-casing of IV_INO_LBLK_32
Date:   Tue, 18 Apr 2023 13:04:30 -0400
Message-Id: <41ed422224d7240e9d4686011534170c2008e834.1681837291.git.sweettea-kernel@dorminy.me>
In-Reply-To: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
References: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
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

Right now, the IV_INO_LBLK_32 policy is handled by its own function
called in fscrypt_setup_v2_file_key(), different from all other policies
which just call find_mode_prepared_key() with various parameters. The
function additionally sets up the relevant inode hashing key in the
master key, and uses it to hash the inode number if possible. This is
not particularly relevant to setting up a prepared key, so this change
tries to make it clear that every non-default policy uses basically the
same setup mechanism for its prepared key. The other setup is moved to
be called from the top crypt_info setup function.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 62 +++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 302a1ccde439..0648ae22ecc4 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -302,44 +302,30 @@ void fscrypt_hash_inode_number(struct fscrypt_info *ci,
 					      &mk->mk_ino_hash_key);
 }
 
-static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
-					    struct fscrypt_master_key *mk)
+static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
 {
 	int err;
 
-	err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
-				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
-	if (err)
-		return err;
-
 	/* pairs with smp_store_release() below */
-	if (!smp_load_acquire(&mk->mk_ino_hash_key_initialized)) {
+	if (smp_load_acquire(&mk->mk_ino_hash_key_initialized))
+		return 0;
 
-		mutex_lock(&fscrypt_mode_key_setup_mutex);
+	mutex_lock(&fscrypt_mode_key_setup_mutex);
 
-		if (mk->mk_ino_hash_key_initialized)
-			goto unlock;
+	if (mk->mk_ino_hash_key_initialized)
+		goto unlock;
 
-		err = fscrypt_derive_siphash_key(mk,
-						 HKDF_CONTEXT_INODE_HASH_KEY,
-						 NULL, 0, &mk->mk_ino_hash_key);
-		if (err)
-			goto unlock;
-		/* pairs with smp_load_acquire() above */
-		smp_store_release(&mk->mk_ino_hash_key_initialized, true);
+	err = fscrypt_derive_siphash_key(mk,
+					 HKDF_CONTEXT_INODE_HASH_KEY,
+					 NULL, 0, &mk->mk_ino_hash_key);
+	if (err)
+		goto unlock;
+	/* pairs with smp_load_acquire() above */
+	smp_store_release(&mk->mk_ino_hash_key_initialized, true);
 unlock:
-		mutex_unlock(&fscrypt_mode_key_setup_mutex);
-		if (err)
-			return err;
-	}
+	mutex_unlock(&fscrypt_mode_key_setup_mutex);
 
-	/*
-	 * New inodes may not have an inode number assigned yet.
-	 * Hashing their inode number is delayed until later.
-	 */
-	if (ci->ci_inode->i_ino)
-		fscrypt_hash_inode_number(ci, mk);
-	return 0;
+	return err;
 }
 
 static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
@@ -371,7 +357,9 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 					     true);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
-		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
+		err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
+					     HKDF_CONTEXT_IV_INO_LBLK_32_KEY,
+					     true);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
 
@@ -629,6 +617,20 @@ fscrypt_setup_encryption_info(struct inode *inode,
 			goto out;
 	}
 
+	/*
+	 * The IV_INO_LBLK_32 policy needs a hashed inode number, but new
+	 * inodes may not have an inode number assigned yet.
+	 */
+	if (policy->version == FSCRYPT_POLICY_V2 &&
+	    (policy->v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+		res = fscrypt_setup_ino_hash_key(mk);
+		if (res)
+			goto out;
+
+		if (inode->i_ino)
+			fscrypt_hash_inode_number(crypt_info, mk);
+	}
+
 	/*
 	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
 	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
-- 
2.40.0

