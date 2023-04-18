Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB36E6A7F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbjDRRFU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbjDRRFT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:19 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3831719
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:05:12 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 190BD827DA;
        Tue, 18 Apr 2023 13:05:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837512; bh=3pMurlPip88FFbIjIA0xNOL2ptF3NUMocQCIVqbTd14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5tZe9zD9ItQLHRa1zi9P0rtd40qNQVMmiqFP2EGCNY11eS0qKD26xHNbYJ8R2DIi
         6FeTTgY4C+x/fGgy9sA5rhyDpAUWgesZv+TsiUtSrG/nCTyYoAqIYNVrVNN9QKgFDr
         xeoMCWXA4FPVnsGb95C2ubgiIhA1VF7CaVb70LqxERr4riECrCGrMbh915vOAl75Wb
         eJ4Yb548Eyn9tdUABya27D2bE0xWdm5lCekGGaqUpwxFYII3/TaWelFvxPxN+0r2bd
         BdtIGU0tE3+fpHR6KETecd4wWFkeUAouXDrJYG29B6xD0uIsr7UTBQFfMBZUO1qMr6
         WGhljow3GPY/A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 02/11] fscrypt: split and rename setup_file_encryption_key()
Date:   Tue, 18 Apr 2023 13:04:39 -0400
Message-Id: <15b622949a181033ffe07cfac1532adc7666da0e.1681837335.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681837335.git.sweettea-kernel@dorminy.me>
References: <cover.1681837335.git.sweettea-kernel@dorminy.me>
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

At present, setup_file_encryption_key() does several things: it finds
and locks the master key, and then calls into the appropriate functions
to setup the prepared key for the fscrypt_info. The code is clearer to
follow if these functions are divided.

Thus, move calling the appropriate file key setup function into a new
fscrypt_setup_file_key() function. After the file key setup functions
are moved, the remaining function can take a const fscrypt_info, and is
renamed find_and_lock_master_key() to precisely describe its action.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 77 ++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index b89c32ad19fb..727d473b6b03 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -386,6 +386,43 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 	return 0;
 }
 
+/*
+ * Find or create the appropriate prepared key for an info.
+ */
+static int fscrypt_setup_file_key(struct fscrypt_info *ci,
+				  struct fscrypt_master_key *mk,
+				  bool need_dirhash_key)
+{
+	int err;
+
+	if (!mk) {
+		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
+			return -ENOKEY;
+
+		/*
+		 * As a legacy fallback for v1 policies, search for the key in
+		 * the current task's subscribed keyrings too.  Don't move this
+		 * to before the search of ->s_master_keys, since users
+		 * shouldn't be able to override filesystem-level keys.
+		 */
+		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
+	}
+
+	switch (ci->ci_policy.version) {
+	case FSCRYPT_POLICY_V1:
+		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
+		break;
+	case FSCRYPT_POLICY_V2:
+		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
 /*
  * Check whether the size of the given master key (@mk) is appropriate for the
  * encryption settings which a particular file will use (@ci).
@@ -426,7 +463,7 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
 }
 
 /*
- * Find the master key, then set up the inode's actual encryption key.
+ * Find and lock the master key.
  *
  * If the master key is found in the filesystem-level keyring, then it is
  * returned in *mk_ret with its semaphore read-locked.  This is needed to ensure
@@ -434,9 +471,8 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
  * multiple tasks may race to create an fscrypt_info for the same inode), and to
  * synchronize the master key being removed with a new inode starting to use it.
  */
-static int setup_file_encryption_key(struct fscrypt_info *ci,
-				     bool need_dirhash_key,
-				     struct fscrypt_master_key **mk_ret)
+static int find_and_lock_master_key(const struct fscrypt_info *ci,
+				    struct fscrypt_master_key **mk_ret)
 {
 	struct super_block *sb = ci->ci_inode->i_sb;
 	struct fscrypt_key_specifier mk_spec;
@@ -466,17 +502,19 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 			mk = fscrypt_find_master_key(sb, &mk_spec);
 		}
 	}
+
 	if (unlikely(!mk)) {
 		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
 			return -ENOKEY;
 
 		/*
-		 * As a legacy fallback for v1 policies, search for the key in
-		 * the current task's subscribed keyrings too.  Don't move this
-		 * to before the search of ->s_master_keys, since users
-		 * shouldn't be able to override filesystem-level keys.
+		 * This might be the case of a v1 policy using a process
+		 * subscribed keyring to get the key, so there may not be
+		 * a relevant master key.
 		 */
-		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
+
+		*mk_ret = NULL;
+		return 0;
 	}
 	down_read(&mk->mk_sem);
 
@@ -491,21 +529,6 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 		goto out_release_key;
 	}
 
-	switch (ci->ci_policy.version) {
-	case FSCRYPT_POLICY_V1:
-		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
-		break;
-	case FSCRYPT_POLICY_V2:
-		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		err = -EINVAL;
-		break;
-	}
-	if (err)
-		goto out_release_key;
-
 	*mk_ret = mk;
 	return 0;
 
@@ -580,7 +603,11 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
+	res = find_and_lock_master_key(crypt_info, &mk);
+	if (res)
+		goto out;
+
+	res = fscrypt_setup_file_key(crypt_info, mk, need_dirhash_key);
 	if (res)
 		goto out;
 
-- 
2.40.0

