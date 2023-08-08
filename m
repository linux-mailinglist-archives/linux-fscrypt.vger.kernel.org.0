Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E295774630
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbjHHSyO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbjHHSxu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:53:50 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED68963483;
        Tue,  8 Aug 2023 10:08:23 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 04F9883543;
        Tue,  8 Aug 2023 13:08:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514502; bh=wiexMjPw2AV0+ev+V2Ao2InY43w8oDJglvamG5Tr2Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INhyXvRdqBv1yVK2/AFyEGA3i3saH9PGG9OCGZlsaXQ3JXIunrc2APmXrMDvi4xkq
         lMh7rPV4iCAN08wmhAcpdgRa61jIr5EA+6sWga7omcbzQMNTLhaLY2RIK3wFwamAE+
         BYdRpGLhNnPDy7cr2gY11sc2jIMwxTWS0z2Pt5dvskHRw72f6FvDgfHLjRfy33hpFs
         vgCZmW1Vfd5J4ZFUc4bcIveoO6f90ZjpnsrsvZJc8lHFHzuAmfd10fa+XgBbNWzvgx
         tmJhmHRIiOQ60GhMJxYsW7a1gIZB2DbbNMK2V4lB4wMq2GIiy85HFxCRkuDhga0cXV
         COXsFs6OZfTJw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 4/8] fscrypt: move dirhash key setup away from IO key setup
Date:   Tue,  8 Aug 2023 13:08:04 -0400
Message-ID: <729a2735c32cd9ddd9fb61c716643a39d10ae189.1691505830.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505830.git.sweettea-kernel@dorminy.me>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
index 06deac6f4487..430e2455ea2d 100644
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
2.41.0

