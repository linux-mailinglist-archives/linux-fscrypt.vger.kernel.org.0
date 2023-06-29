Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13D1B741D12
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjF2Af1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjF2AfT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:19 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E63297C;
        Wed, 28 Jun 2023 17:35:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CB774807B7;
        Wed, 28 Jun 2023 20:29:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998556; bh=YqRRDWI4Q3S+nsoV4rR7qxoo++Y30XsC6x8HLIhWvkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZ1Vd1SKJ1X2CtCTuhtuxgVbtLoLVJFmEa0f4scBw8OgUodlXjidgqX8IB50sYlSf
         Km5VGglTbkOi71y0UJftEt2pWHbD24x55Yqt7Ac9l1XPshS5OE2VmzViAWpsic6OWe
         XJyhmSUMtmmkFBKsP3rafPrDguFsMUOj+gppQH6FA3096VzHhdjhe93SCAQ8lU9pkm
         kn3H6plI2bq8deaBSa+klDcq/T+Ir05NwDYt4h4AjjLbXjREsap7S2y4ZnJMXUmWKZ
         blDa/5y8SJ34Pex3SyuCUMdKmDlbxzqlUJgwyZcNp9TuHMIEjnpDn/Xu8jaUN5M8vb
         FJdTHp9XqBCcQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 4/8] fscrypt: move dirhash key setup away from IO key setup
Date:   Wed, 28 Jun 2023 20:28:54 -0400
Message-Id: <143406026caa2f73865dbc448533fb96735f896d.1687988119.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988119.git.sweettea-kernel@dorminy.me>
References: <cover.1687988119.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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
2.40.1

