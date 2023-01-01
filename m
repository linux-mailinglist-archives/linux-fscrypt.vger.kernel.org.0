Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02D365A900
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjAAFNz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745663E3
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 286A082634;
        Sun,  1 Jan 2023 00:06:37 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549597; bh=Cjs7qIoema7Ub8xzcx1e2WzqdwoTIiR4o58nP15fEEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHShNtu7TCZXL4t0PajRcdozfNL56jqTolrDeHM06KiaNyvGOa1eI7pzQOe3Vumv1
         ocTSygXmLbPAK9E6Fsqq1wtaT5tG+mMdb6GHjeMyKytooz4Xvo/9HONkqGTVzIp3bw
         Yud/Y+3whiyYAG55iHtK9CuhZ5l6P7Fm6KnqR7BoYFZLR4zaqpyIPK0S2cBR4uuIu1
         rPlmwPbWo0xJ3QpCKC30I5imz1U5xWFb9AEz/MQTgiaWvN7JqBQ/Vwc7jpbkVFplOx
         L6tSTz9D/WsUgHGC3AOssGbAHN/r8/BUlONw3WCGw0d5TmjvuotG78B1Lp2akMg9hi
         vE3oOFMcLrgng==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 04/17] fscrypt: factor out fscrypt_set_inode_info()
Date:   Sun,  1 Jan 2023 00:06:08 -0500
Message-Id: <fba20d354834b5b9f20c284b577381e5147692a0.1672547582.git.sweettea-kernel@dorminy.me>
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

As this function needs to be called in several different places to
short-circuit creating a new fscrypt_info for extent-based encryption,
it makes sense to pull it into its own function for easy calling.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 60 +++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 87f28d666602..4d7ff8244c55 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -515,6 +515,38 @@ static void put_crypt_info(struct fscrypt_info *ci)
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
+static bool fscrypt_set_inode_info(struct inode *inode,
+				   struct fscrypt_info *ci,
+				   struct fscrypt_master_key *mk)
+{
+	if (ci == NULL) {
+		inode->i_crypt_info = NULL;
+		return true;
+	}
+
+	/*
+	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
+	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
+	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
+	 * RELEASE barrier so that other tasks can ACQUIRE it.
+	 */
+	if (cmpxchg_release(&inode->i_crypt_info, NULL, ci) != NULL)
+		return false;
+
+	/*
+	 * We won the race and set ->i_crypt_info to our crypt_info.
+	 * Now link it into the master key's inode list.
+	 */
+	if (mk) {
+		ci->ci_master_key = mk;
+		refcount_inc(&mk->mk_active_refs);
+		spin_lock(&mk->mk_decrypted_inodes_lock);
+		list_add(&ci->ci_master_key_link, &mk->mk_decrypted_inodes);
+		spin_unlock(&mk->mk_decrypted_inodes_lock);
+	}
+	return true;
+}
+
 static int
 fscrypt_setup_encryption_info(struct inode *inode,
 			      const union fscrypt_policy *policy,
@@ -525,6 +557,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	struct fscrypt_mode *mode;
 	struct fscrypt_master_key *mk = NULL;
 	int res;
+	bool set_succeeded;
 
 	res = fscrypt_initialize(inode->i_sb->s_cop->flags);
 	if (res)
@@ -550,34 +583,15 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
-	/*
-	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
-	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
-	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
-	 * RELEASE barrier so that other tasks can ACQUIRE it.
-	 */
-	if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
-		/*
-		 * We won the race and set ->i_crypt_info to our crypt_info.
-		 * Now link it into the master key's inode list.
-		 */
-		if (mk) {
-			crypt_info->ci_master_key = mk;
-			refcount_inc(&mk->mk_active_refs);
-			spin_lock(&mk->mk_decrypted_inodes_lock);
-			list_add(&crypt_info->ci_master_key_link,
-				 &mk->mk_decrypted_inodes);
-			spin_unlock(&mk->mk_decrypted_inodes_lock);
-		}
-		crypt_info = NULL;
-	}
+	set_succeeded = fscrypt_set_inode_info(inode, crypt_info, mk);
 	res = 0;
 out:
 	if (mk) {
 		up_read(&mk->mk_sem);
 		fscrypt_put_master_key(mk);
 	}
-	put_crypt_info(crypt_info);
+	if (!set_succeeded)
+		put_crypt_info(crypt_info);
 	return res;
 }
 
@@ -707,7 +721,7 @@ EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
 void fscrypt_put_encryption_info(struct inode *inode)
 {
 	put_crypt_info(fscrypt_get_inode_info(inode));
-	inode->i_crypt_info = NULL;
+	fscrypt_set_inode_info(inode, NULL, NULL);
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
 
-- 
2.38.1

