Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C029C65A904
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbjAAFN5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A1463E9
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6FC8C82642;
        Sun,  1 Jan 2023 00:06:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549607; bh=FGZbrt7PwqtDqmoTtWjKsiwBXR5iOGg5k7lqM36FoVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gr67VzxMKoTPRy5yEVrzLbqm0wfoa4PWZ6dMP1mgCXNzVMRZkq7EfCBuBGNM5Vd7K
         odyVtRxxkPuehGwdU0yPNk7equM1RE1oZuymz6y4s6DEZD9VPRxCuXjtgaFreS8V5Z
         hJwtZIaB+cM6Zgo39CjPraOTqFgF0i+SVsYtENFf6qOaXs2HTZUzad+WwdA1XnB2OE
         wtGGdpmRm/9FpDGSMMA0LwrfEzLXgRrhGf2rJPzqi5sNnDk263jh8lWdJhnn0Sgd33
         4qpXDrjPoyeFJ9NhnWeRIJScKcAI1anXgB1HJb9fRLlCaQCYbWrC+VuBxutv/XF9SV
         RE47okrmKAnjw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 09/17] fscrypt: make fscrypt_setup_encryption_info generic for extents
Date:   Sun,  1 Jan 2023 00:06:13 -0500
Message-Id: <2e4743214d5f40664ebb6227f71449015d16a218.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

fscrypt_setup_encryption_info() will be used for setting up both inode
and extent fscrypt_infos, so it can't just assume that it should set
inode->i_crypt_info to the new fscrypt_info. Instead, this changes it to
take a pointer to the location to store the new fscrypt_info, which
currently is always &inode->i_crypt_info.  Correspondingly,
fscrypt_setup_encryption_info() currently calls fscrypt_set_inode_info()
to set the inode's info; this renames it to fscrypt_set_info() and
plumbs through the pointer to the location to store the new
fscrypt_info.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index cb3ba4e4f816..04f01da900ca 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -513,22 +513,23 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
-static bool fscrypt_set_inode_info(struct inode *inode,
-				   struct fscrypt_info *ci,
-				   struct fscrypt_master_key *mk)
+static bool fscrypt_set_info(struct fscrypt_info **info_ptr,
+			     struct fscrypt_info *ci,
+			     struct fscrypt_master_key *mk)
 {
 	if (ci == NULL) {
-		inode->i_crypt_info = NULL;
+		*info_ptr = NULL;
 		return true;
 	}
 
 	/*
-	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
-	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
-	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
-	 * RELEASE barrier so that other tasks can ACQUIRE it.
+	 * For existing objects, multiple tasks may race to set ->i_crypt_info
+	 * or the equivalent. So use cmpxchg_release().  This pairs with the
+	 * smp_load_acquire() in fscrypt_get_info().  I.e., here we publish
+	 * ->i_crypt_info with a RELEASE barrier so that other tasks can
+	 *  ACQUIRE it.
 	 */
-	if (cmpxchg_release(&inode->i_crypt_info, NULL, ci) != NULL)
+	if (cmpxchg_release(info_ptr, NULL, ci) != NULL)
 		return false;
 
 	/*
@@ -549,7 +550,8 @@ static int
 fscrypt_setup_encryption_info(struct inode *inode,
 			      const union fscrypt_policy *policy,
 			      const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
-			      bool need_dirhash_key)
+			      bool need_dirhash_key,
+			      struct fscrypt_info **info_ptr)
 {
 	struct fscrypt_info *crypt_info;
 	struct fscrypt_mode *mode;
@@ -582,7 +584,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	set_succeeded = fscrypt_set_inode_info(inode, crypt_info, mk);
+	set_succeeded = fscrypt_set_info(info_ptr, crypt_info, mk);
 	res = 0;
 out:
 	if (mk) {
@@ -631,7 +633,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 		if (dir_info)
 			mk = dir_info->ci_master_key;
 
-		fscrypt_set_inode_info(inode, dir_info, mk);
+		fscrypt_set_info(&inode->i_crypt_info, dir_info, mk);
 		dput(parent_dentry);
 		dput(dentry);
 		return 0;
@@ -663,7 +665,8 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 	res = fscrypt_setup_encryption_info(inode, &policy,
 					    fscrypt_context_nonce(&ctx),
 					    IS_CASEFOLDED(inode) &&
-					    S_ISDIR(inode->i_mode));
+					    S_ISDIR(inode->i_mode),
+					    &inode->i_crypt_info);
 
 	if (res == -ENOPKG && allow_unsupported) /* Algorithm unavailable? */
 		res = 0;
@@ -722,15 +725,16 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 	if (fscrypt_uses_extent_encryption(inode)) {
 		struct fscrypt_info *dir_info = fscrypt_get_inode_info(dir);
 
-		fscrypt_set_inode_info(inode, dir_info,
-				       dir_info->ci_master_key);
+		fscrypt_set_info(&inode->i_crypt_info, dir_info,
+				 dir_info->ci_master_key);
 		return 0;
 	}
 
 	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
 	return fscrypt_setup_encryption_info(inode, policy, nonce,
 					     IS_CASEFOLDED(dir) &&
-					     S_ISDIR(inode->i_mode));
+					     S_ISDIR(inode->i_mode),
+					     &inode->i_crypt_info);
 }
 EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
 
@@ -745,7 +749,7 @@ void fscrypt_put_encryption_info(struct inode *inode)
 {
 	if (!fscrypt_uses_extent_encryption(inode))
 		put_crypt_info(fscrypt_get_inode_info(inode));
-	fscrypt_set_inode_info(inode, NULL, NULL);
+	fscrypt_set_info(&inode->i_crypt_info, NULL, NULL);
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
 
-- 
2.38.1

