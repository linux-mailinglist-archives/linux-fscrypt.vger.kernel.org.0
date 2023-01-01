Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F02465A902
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAAFN4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42CE63CA
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D9B5982640;
        Sun,  1 Jan 2023 00:06:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549606; bh=ZPrF757A3eeai3f9ewaah8yVadD7gA3m855rzNAOjbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVog0Xuu8dmtl5r4A4gDKn8lb4pBMjKMnjzwCpemhBKu0h2J5URobR4TpgyU0iva0
         wLsbnXHJPRjSpEL2cuzukKr0CqvwijBfYcnLYGUofDev96M2S+ZMOipTvSqQqO02rt
         nQ2Og8JrcBlKW1fS8OtbHGhqD6JXooLPu6HOPkAZySH+gRcrUwSWSckOxYDPIDXW15
         U0S/pq6eK8uuB541f6+PTttsvkyB7wbAmwJPKyT2sWxaYPo19DK9UmoM1pZirTKtUG
         VAEkYBlxER8hlKsvA6pnjwPShDmk1MVy8wWFBdapGImMK9gUCxU9f1I4lZ62x1imo4
         5BdbP5BKaFNmw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 08/17] fscrypt: rename mk->mk_decrypted_inodes*
Date:   Sun,  1 Jan 2023 00:06:12 -0500
Message-Id: <5040a466038d72547f2ecaae489a4eccc0453fc5.1672547582.git.sweettea-kernel@dorminy.me>
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

With the advent of extent-owned infos, we will need to track both inodes
and extents in each master key, in order to appropriately notify
filesystems that an extent needs to forget its fscrypt_info. Thus, it no
longer makes sense for the list of these objects to be called 'decrypted
inodes'. This change renames mk_decrypted_inodes{,_lock} to
mk_active_infos{,_lock} since the list tracks active fscrypt_info
objects of any provenance.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 12 ++++++------
 fs/crypto/keyring.c         | 30 +++++++++++++++---------------
 fs/crypto/keysetup.c        | 12 ++++++------
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 71e16d188fe8..0c7b785f1d8c 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -537,7 +537,7 @@ struct fscrypt_master_key {
 	 * A structural ref only guarantees that the struct continues to exist.
 	 *
 	 * There is one active ref associated with ->mk_secret being present,
-	 * and one active ref for each inode in ->mk_decrypted_inodes.
+	 * and one active ref for each inode in ->mk_active_infos.
 	 *
 	 * There is one structural ref associated with the active refcount being
 	 * nonzero.  Finding a key in the keyring also takes a structural ref,
@@ -551,7 +551,7 @@ struct fscrypt_master_key {
 	/*
 	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
 	 * executed, this is wiped and no new inodes can be unlocked with this
-	 * key; however, there may still be inodes in ->mk_decrypted_inodes
+	 * key; however, there may still be inodes in ->mk_active_infos
 	 * which could not be evicted.  As long as some inodes still remain,
 	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
 	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
@@ -587,11 +587,11 @@ struct fscrypt_master_key {
 	struct key		*mk_users;
 
 	/*
-	 * List of inodes that were unlocked using this key.  This allows the
-	 * inodes to be evicted efficiently if the key is removed.
+	 * List of infos that were unlocked using this key.  This allows the
+	 * owning objects to be evicted efficiently if the key is removed.
 	 */
-	struct list_head	mk_decrypted_inodes;
-	spinlock_t		mk_decrypted_inodes_lock;
+	struct list_head	mk_active_infos;
+	spinlock_t		mk_active_infos_lock;
 
 	/*
 	 * Per-mode encryption keys for the various types of encryption policies
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index f825d800867c..846f480da081 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -99,10 +99,10 @@ void fscrypt_put_master_key_activeref(struct fscrypt_master_key *mk)
 
 	/*
 	 * ->mk_active_refs == 0 implies that ->mk_secret is not present and
-	 * that ->mk_decrypted_inodes is empty.
+	 * that ->mk_active_infos is empty.
 	 */
 	WARN_ON(is_master_key_secret_present(&mk->mk_secret));
-	WARN_ON(!list_empty(&mk->mk_decrypted_inodes));
+	WARN_ON(!list_empty(&mk->mk_active_infos));
 
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(
@@ -429,8 +429,8 @@ static int add_new_master_key(struct super_block *sb,
 	refcount_set(&mk->mk_struct_refs, 1);
 	mk->mk_spec = *mk_spec;
 
-	INIT_LIST_HEAD(&mk->mk_decrypted_inodes);
-	spin_lock_init(&mk->mk_decrypted_inodes_lock);
+	INIT_LIST_HEAD(&mk->mk_active_infos);
+	spin_lock_init(&mk->mk_active_infos_lock);
 
 	if (mk_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
 		err = allocate_master_key_users_keyring(mk);
@@ -882,9 +882,9 @@ static void evict_dentries_for_decrypted_objects(struct fscrypt_master_key *mk)
 	struct inode *inode;
 	struct inode *toput_inode = NULL;
 
-	spin_lock(&mk->mk_decrypted_inodes_lock);
+	spin_lock(&mk->mk_active_infos_lock);
 
-	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
+	list_for_each_entry(ci, &mk->mk_active_infos, ci_master_key_link) {
 		inode = ci->ci_inode;
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
@@ -893,16 +893,16 @@ static void evict_dentries_for_decrypted_objects(struct fscrypt_master_key *mk)
 		}
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_unlock(&mk->mk_active_infos_lock);
 
 		shrink_dcache_inode(inode);
 		iput(toput_inode);
 		toput_inode = inode;
 
-		spin_lock(&mk->mk_decrypted_inodes_lock);
+		spin_lock(&mk->mk_active_infos_lock);
 	}
 
-	spin_unlock(&mk->mk_decrypted_inodes_lock);
+	spin_unlock(&mk->mk_active_infos_lock);
 	iput(toput_inode);
 }
 
@@ -914,25 +914,25 @@ static int check_for_busy_inodes(struct super_block *sb,
 	unsigned long ino;
 	char ino_str[50] = "";
 
-	spin_lock(&mk->mk_decrypted_inodes_lock);
+	spin_lock(&mk->mk_active_infos_lock);
 
-	list_for_each(pos, &mk->mk_decrypted_inodes)
+	list_for_each(pos, &mk->mk_active_infos)
 		busy_count++;
 
 	if (busy_count == 0) {
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_unlock(&mk->mk_active_infos_lock);
 		return 0;
 	}
 
 	{
 		/* select an example file to show for debugging purposes */
 		struct inode *inode =
-			list_first_entry(&mk->mk_decrypted_inodes,
+			list_first_entry(&mk->mk_active_infos,
 					 struct fscrypt_info,
 					 ci_master_key_link)->ci_inode;
 		ino = inode->i_ino;
 	}
-	spin_unlock(&mk->mk_decrypted_inodes_lock);
+	spin_unlock(&mk->mk_active_infos_lock);
 
 	/* If the inode is currently being created, ino may still be 0. */
 	if (ino)
@@ -954,7 +954,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 
 	/*
 	 * An inode can't be evicted while it is dirty or has dirty pages.
-	 * Thus, we first have to clean the inodes in ->mk_decrypted_inodes.
+	 * Thus, we first have to clean the inodes in ->mk_active_infos.
 	 *
 	 * Just do it the easy way: call sync_filesystem().  It's overkill, but
 	 * it works, and it's more important to minimize the amount of caches we
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 22e3ce5d61dc..cb3ba4e4f816 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -414,7 +414,7 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
  *
  * If the master key is found in the filesystem-level keyring, then it is
  * returned in *mk_ret with its semaphore read-locked.  This is needed to ensure
- * that only one task links the fscrypt_info into ->mk_decrypted_inodes (as
+ * that only one task links the fscrypt_info into ->mk_active_infos (as
  * multiple tasks may race to create an fscrypt_info for the same inode), and to
  * synchronize the master key being removed with a new inode starting to use it.
  */
@@ -504,9 +504,9 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		 * inode from a master key struct that already had its secret
 		 * removed, then complete the full removal of the struct.
 		 */
-		spin_lock(&mk->mk_decrypted_inodes_lock);
+		spin_lock(&mk->mk_active_infos_lock);
 		list_del(&ci->ci_master_key_link);
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_unlock(&mk->mk_active_infos_lock);
 		fscrypt_put_master_key_activeref(mk);
 	}
 	memzero_explicit(ci, sizeof(*ci));
@@ -538,9 +538,9 @@ static bool fscrypt_set_inode_info(struct inode *inode,
 	if (mk) {
 		ci->ci_master_key = mk;
 		refcount_inc(&mk->mk_active_refs);
-		spin_lock(&mk->mk_decrypted_inodes_lock);
-		list_add(&ci->ci_master_key_link, &mk->mk_decrypted_inodes);
-		spin_unlock(&mk->mk_decrypted_inodes_lock);
+		spin_lock(&mk->mk_active_infos_lock);
+		list_add(&ci->ci_master_key_link, &mk->mk_active_infos);
+		spin_unlock(&mk->mk_active_infos_lock);
 	}
 	return true;
 }
-- 
2.38.1

