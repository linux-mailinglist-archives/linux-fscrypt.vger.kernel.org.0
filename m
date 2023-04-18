Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18A06E6A75
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjDRRE7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjDRRE6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:04:58 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A67786BC
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:04:57 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BB7DD825C6;
        Tue, 18 Apr 2023 13:04:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837497; bh=uRx7bHD8Ij+dgTOQA+c1S9zdeSABug3aN1jCY2/W2GQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U55s7wV+Z1xMmMxKgU98vCjRQ5Vn/1JY39LcBUwHIkeBkdro3tKiQVPqjAfGk8gbg
         x7MsyD+Dm/jlsS1b9fDJCHoEeQeOMaN967mkNcVbW/JT/ooHFinkJSOinOoTqUDPhF
         y5iwzHMk2vWXC7EmykUWrcUm3VkuM/vC5iUX8m2g8bMRWMEKYv4vLPx6kVTtiE06C+
         lrmm0GyyuAEcSz5YMwBKigQJj4+Ex8nC7/z4/h5B5hPmxpv5EB4nIj2AtGg586EGGV
         5yJ8GjyWOooRYgMK6lSMW8K0dSyYrCrZBawYFAXzFgHrQEhQd8bkXwQGzKFtNWdWF0
         50gcK5iWoDUDg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 04/11] fscrypt: move dirhash key setup away from IO key setup
Date:   Tue, 18 Apr 2023 13:04:29 -0400
Message-Id: <0d3ae92ef973edcd70f18aa408de61e44dd7e28f.1681837291.git.sweettea-kernel@dorminy.me>
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

The function named fscrypt_setup_v2_file_key() has as its main focus the
setting up of the fscrypt_info's ci_enc_key member, the prepared key
with which filenames or file contents are encrypted or decrypted.
However, it currently also sets up the dirhash key, used by some
directories, based on a parameter. There are no dependencies on
setting up the dirhash key beyond having the master key locked, and it's
clearer having fscrypt_setup_file_key() be only about setting up the
prepared key for IO.

Thus, move dirhash key setup to fscrypt_setup_encryption_info(), which
calls out to each function setting up parts of the fscrypt_info, and
stop passing the need_dirhash_key parameter around.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 69bd27b7e9d8..302a1ccde439 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -343,8 +343,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 }
 
 static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
-				     struct fscrypt_master_key *mk,
-				     bool need_dirhash_key)
+				     struct fscrypt_master_key *mk)
 {
 	int err;
 
@@ -386,25 +385,15 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		err = fscrypt_set_per_file_enc_key(ci, derived_key);
 		memzero_explicit(derived_key, ci->ci_mode->keysize);
 	}
-	if (err)
-		return err;
 
-	/* Derive a secret dirhash key for directories that need it. */
-	if (need_dirhash_key) {
-		err = fscrypt_derive_dirhash_key(ci, mk);
-		if (err)
-			return err;
-	}
-
-	return 0;
+	return err;
 }
 
 /*
  * Find or create the appropriate prepared key for an info.
  */
 static int fscrypt_setup_file_key(struct fscrypt_info *ci,
-				  struct fscrypt_master_key *mk,
-				  bool need_dirhash_key)
+				  struct fscrypt_master_key *mk)
 {
 	int err;
 
@@ -426,7 +415,7 @@ static int fscrypt_setup_file_key(struct fscrypt_info *ci,
 		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
 		break;
 	case FSCRYPT_POLICY_V2:
-		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
+		err = fscrypt_setup_v2_file_key(ci, mk);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -620,10 +609,26 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	res = fscrypt_setup_file_key(crypt_info, mk, need_dirhash_key);
+	res = fscrypt_setup_file_key(crypt_info, mk);
 	if (res)
 		goto out;
 
+	/*
+	 * Derive a secret dirhash key for directories that need it. It
+	 * should be impossible to set flags such that a v1 policy sets
+	 * need_dirhash_key, but check it anyway.
+	 */
+	if (need_dirhash_key) {
+		if (WARN_ON_ONCE(policy->version == FSCRYPT_POLICY_V1)) {
+			res = -EINVAL;
+			goto out;
+		}
+
+		res = fscrypt_derive_dirhash_key(crypt_info, mk);
+		if (res)
+			goto out;
+	}
+
 	/*
 	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
 	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
-- 
2.40.0

