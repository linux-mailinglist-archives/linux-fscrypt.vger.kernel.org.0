Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBF2623D82
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Nov 2022 09:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiKJI3t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Nov 2022 03:29:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbiKJI3t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Nov 2022 03:29:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E04AE57
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Nov 2022 00:29:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3B561DB8
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Nov 2022 08:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4618BC433D6
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Nov 2022 08:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668068987;
        bh=9n2vDETUk7qKb2/4csfvpmj8pFP4JFYa7SL/X82Db6I=;
        h=From:To:Subject:Date:From;
        b=cJsgkNK7zIJsUYrxkTzz5bYpN/tELaG4x/R56rPZBOxszRJXDPDeK9tEIEzoKJkE2
         7o7ZIPMR9ZNqN0TDNu25g5ePuEFH+39uv7vWJudI9QKgd3mdHta9OnIwLei9tKlfHQ
         plv2KvPRAB9HEOj31kWHHTlNSaQOJM9++spQK9c86s1xRfWV21Q/3c8iNchcxwgCCR
         2hLGpt+hFckFTbaVsnVYeHNrOaLyVyW1I/T8wfuBeBfG2d2s0vKdmaEYSKAojRn0g9
         zKH4ZEw/0nCK0XM8YjKZVxJKSJw6cgQay3Kw5gVII4tWkjZNDKQZXZQZKXL8EZBoWj
         VhfxJDSOU22aQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: pass super_block to fscrypt_put_master_key_activeref()
Date:   Thu, 10 Nov 2022 00:29:42 -0800
Message-Id: <20221110082942.351615-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As this code confused Linus [1], pass the super_block as an argument to
fscrypt_put_master_key_activeref().  This removes the need to have the
back-pointer ->mk_sb, so remove that.

[1] https://lore.kernel.org/linux-fscrypt/CAHk-=wgud4Bc_um+htgfagYpZAnOoCb3NUoW67hc9LhOKsMtJg@mail.gmail.com

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 13 ++++---------
 fs/crypto/keyring.c         | 14 ++++++--------
 fs/crypto/keysetup.c        |  2 +-
 3 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index d5f68a0c5d154..316a778cec0ff 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -439,13 +439,7 @@ struct fscrypt_master_key_secret {
 struct fscrypt_master_key {
 
 	/*
-	 * Back-pointer to the super_block of the filesystem to which this
-	 * master key has been added.  Only valid if ->mk_active_refs > 0.
-	 */
-	struct super_block			*mk_sb;
-
-	/*
-	 * Link in ->mk_sb->s_master_keys->key_hashtable.
+	 * Link in ->s_master_keys->key_hashtable.
 	 * Only valid if ->mk_active_refs > 0.
 	 */
 	struct hlist_node			mk_node;
@@ -456,7 +450,7 @@ struct fscrypt_master_key {
 	/*
 	 * Active and structural reference counts.  An active ref guarantees
 	 * that the struct continues to exist, continues to be in the keyring
-	 * ->mk_sb->s_master_keys, and that any embedded subkeys (e.g.
+	 * ->s_master_keys, and that any embedded subkeys (e.g.
 	 * ->mk_direct_keys) that have been prepared continue to exist.
 	 * A structural ref only guarantees that the struct continues to exist.
 	 *
@@ -569,7 +563,8 @@ static inline int master_key_spec_len(const struct fscrypt_key_specifier *spec)
 
 void fscrypt_put_master_key(struct fscrypt_master_key *mk);
 
-void fscrypt_put_master_key_activeref(struct fscrypt_master_key *mk);
+void fscrypt_put_master_key_activeref(struct super_block *sb,
+				      struct fscrypt_master_key *mk);
 
 struct fscrypt_master_key *
 fscrypt_find_master_key(struct super_block *sb,
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 2a24b1f0ae688..78dd2ff306bd7 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -79,10 +79,9 @@ void fscrypt_put_master_key(struct fscrypt_master_key *mk)
 	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);
 }
 
-void fscrypt_put_master_key_activeref(struct fscrypt_master_key *mk)
+void fscrypt_put_master_key_activeref(struct super_block *sb,
+				      struct fscrypt_master_key *mk)
 {
-	struct super_block *sb = mk->mk_sb;
-	struct fscrypt_keyring *keyring = sb->s_master_keys;
 	size_t i;
 
 	if (!refcount_dec_and_test(&mk->mk_active_refs))
@@ -93,9 +92,9 @@ void fscrypt_put_master_key_activeref(struct fscrypt_master_key *mk)
 	 * destroying any subkeys embedded in it.
 	 */
 
-	spin_lock(&keyring->lock);
+	spin_lock(&sb->s_master_keys->lock);
 	hlist_del_rcu(&mk->mk_node);
-	spin_unlock(&keyring->lock);
+	spin_unlock(&sb->s_master_keys->lock);
 
 	/*
 	 * ->mk_active_refs == 0 implies that ->mk_secret is not present and
@@ -243,7 +242,7 @@ void fscrypt_destroy_keyring(struct super_block *sb)
 			WARN_ON(refcount_read(&mk->mk_struct_refs) != 1);
 			WARN_ON(!is_master_key_secret_present(&mk->mk_secret));
 			wipe_master_key_secret(&mk->mk_secret);
-			fscrypt_put_master_key_activeref(mk);
+			fscrypt_put_master_key_activeref(sb, mk);
 		}
 	}
 	kfree_sensitive(keyring);
@@ -424,7 +423,6 @@ static int add_new_master_key(struct super_block *sb,
 	if (!mk)
 		return -ENOMEM;
 
-	mk->mk_sb = sb;
 	init_rwsem(&mk->mk_sem);
 	refcount_set(&mk->mk_struct_refs, 1);
 	mk->mk_spec = *mk_spec;
@@ -1068,7 +1066,7 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	err = -ENOKEY;
 	if (is_master_key_secret_present(&mk->mk_secret)) {
 		wipe_master_key_secret(&mk->mk_secret);
-		fscrypt_put_master_key_activeref(mk);
+		fscrypt_put_master_key_activeref(sb, mk);
 		err = 0;
 	}
 	inodes_remain = refcount_read(&mk->mk_active_refs) > 0;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f7407071a9524..9e44dc078a81a 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -509,7 +509,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		spin_lock(&mk->mk_decrypted_inodes_lock);
 		list_del(&ci->ci_master_key_link);
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
-		fscrypt_put_master_key_activeref(mk);
+		fscrypt_put_master_key_activeref(ci->ci_inode->i_sb, mk);
 	}
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);

base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
-- 
2.38.1

