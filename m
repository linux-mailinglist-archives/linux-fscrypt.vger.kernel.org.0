Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCDF76DC5B4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbjDJK0x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJK0w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:52 -0400
X-Greylist: delayed 607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Apr 2023 03:26:50 PDT
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A690A198
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 46FDF80599;
        Mon, 10 Apr 2023 06:16:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121806; bh=XX6bp4kajq0S7zO6XE9nIj+N7dA6CHFnrbOmyU/7MpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EDJQvEg9GoUTA5sIWLxZhDFJj/gq2AjFf4+gVE2OlwdHDoJoTJZ9s79304KTZfplC
         KljB8QHoW4/+qAZOsJRnbCFuGqUpTji8uB2JzP5SNanuPDitsnc881X0GdtDGeO6cY
         ZE75Naq2KLCgI25UCZn1W/ky0XmlOBlXSAIrR/Q4tIQzYL7Xi38Ba/ZVnCMnmhm1M0
         AUX+ziWis7sgLW4fT4JT79rq8EiYul9H4BzvTYTYXZk1MOpXcX3EsM1WOyT5EAW5pW
         z+8WRdhYUEyaB+NklnKg35V0JVOaYxDjEmp53bZE9EU3SitxycO51Ib8IXeKfAvzbe
         naYQylumMsLwg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 03/10] fscrypt: move dirhash key setup away from IO key setup
Date:   Mon, 10 Apr 2023 06:16:24 -0400
Message-Id: <ed3234344daa364c148bd1e8bc9c5130cb4e1d72.1681116739.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681116739.git.sweettea-kernel@dorminy.me>
References: <cover.1681116739.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 fs/crypto/keysetup.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 7a3147382033..82589c370b14 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -345,8 +345,7 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 }
 
 static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
-				     struct fscrypt_master_key *mk,
-				     bool need_dirhash_key)
+				     struct fscrypt_master_key *mk)
 {
 	int err;
 
@@ -391,13 +390,6 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 	if (err)
 		return err;
 
-	/* Derive a secret dirhash key for directories that need it. */
-	if (need_dirhash_key) {
-		err = fscrypt_derive_dirhash_key(ci, mk);
-		if (err)
-			return err;
-	}
-
 	return 0;
 }
 
@@ -405,8 +397,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
  * Find or create the appropriate prepared key for an info.
  */
 static int fscrypt_setup_file_key(struct fscrypt_info *ci,
-				  struct fscrypt_master_key *mk,
-				  bool need_dirhash_key)
+				  struct fscrypt_master_key *mk)
 {
 	int err;
 
@@ -428,7 +419,7 @@ static int fscrypt_setup_file_key(struct fscrypt_info *ci,
 		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
 		break;
 	case FSCRYPT_POLICY_V2:
-		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
+		err = fscrypt_setup_v2_file_key(ci, mk);
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -616,10 +607,26 @@ fscrypt_setup_encryption_info(struct inode *inode,
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

