Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B8E8E0A9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 00:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbfHNW20 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 18:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbfHNW20 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 18:28:26 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667EF2064A;
        Wed, 14 Aug 2019 22:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565821705;
        bh=Fp8KCIMcKiB0kj7H4Ozz1VWH7BDbgk3wHcO/XUFfrcY=;
        h=Date:From:To:Cc:Subject:From;
        b=MmdznKI1SQKspJ/KQjNbSCbZkqOzcT/EJYmuXbZjN0RCXQvLaQ9dgQhQs0QfVZcN4
         ogkfPSnvclQPmpuv75lKzZ46xpoW8RZY3NTnEDJhEVCnm58WVko59v55CeI58u5wOt
         gaFj3f9FIBptAHYcnvU8SDBGNe18KnR+l1c6ARqU=
Date:   Wed, 14 Aug 2019 15:28:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-fscrypt@vger.kernel.org, linux-next@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Merge resolution for fscrypt and keyrings trees
Message-ID: <20190814222822.GA101319@gmail.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-fscrypt@vger.kernel.org, linux-next@vger.kernel.org,
        keyrings@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Stephen, the fscrypt patches I've just pushed out conflict with the keys ACLs
patch in keys-next.  To resolve the conflict for tomorrow's linux-next:

1. Discard change to deleted file keyinfo.c
2. In keyinfo_v1.c, add NULL argument to request_key() [this was change (1)]
3. In keyring.c, translate key permissions to ACLs

'git diff fscrypt/master -- fs/crypto/' on the merge commit should show:

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index c34fa7c61b43b0..8a7519b120153b 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -127,6 +127,38 @@ static struct key_type key_type_fscrypt_user = {
 	.describe		= fscrypt_user_key_describe,
 };
 
+static struct key_acl fscrypt_keyring_acl = {
+	.usage = REFCOUNT_INIT(1),
+	.nr_ace	= 2,
+	.aces = {
+		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL |
+				  KEY_ACE_JOIN),
+		KEY_OWNER_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL | KEY_ACE_JOIN |
+			      KEY_ACE_READ | KEY_ACE_VIEW),
+	}
+};
+
+static struct key_acl fscrypt_key_acl = {
+	.usage = REFCOUNT_INIT(1),
+	.nr_ace	= 2,
+	.aces = {
+		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL |
+				  KEY_ACE_JOIN),
+		KEY_OWNER_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL | KEY_ACE_JOIN |
+			      KEY_ACE_VIEW),
+	}
+};
+
+static struct key_acl fscrypt_user_key_acl = {
+	.usage = REFCOUNT_INIT(1),
+	.nr_ace	= 2,
+	.aces = {
+		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_INVAL |
+				  KEY_ACE_JOIN),
+		KEY_OWNER_ACE(KEY_ACE_VIEW),
+	}
+};
+
 /* Search ->s_master_keys or ->mk_users */
 static struct key *search_fscrypt_keyring(struct key *keyring,
 					  struct key_type *type,
@@ -203,8 +235,7 @@ static int allocate_filesystem_keyring(struct super_block *sb)
 
 	format_fs_keyring_description(description, sb);
 	keyring = keyring_alloc(description, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
-				current_cred(), KEY_POS_SEARCH |
-				  KEY_USR_SEARCH | KEY_USR_READ | KEY_USR_VIEW,
+				current_cred(), &fscrypt_keyring_acl,
 				KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
 	if (IS_ERR(keyring))
 		return PTR_ERR(keyring);
@@ -247,8 +278,7 @@ static int allocate_master_key_users_keyring(struct fscrypt_master_key *mk)
 	format_mk_users_keyring_description(description,
 					    mk->mk_spec.u.identifier);
 	keyring = keyring_alloc(description, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID,
-				current_cred(), KEY_POS_SEARCH |
-				  KEY_USR_SEARCH | KEY_USR_READ | KEY_USR_VIEW,
+				current_cred(), &fscrypt_keyring_acl,
 				KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);
 	if (IS_ERR(keyring))
 		return PTR_ERR(keyring);
@@ -285,7 +315,7 @@ static int add_master_key_user(struct fscrypt_master_key *mk)
 	format_mk_user_description(description, mk->mk_spec.u.identifier);
 	mk_user = key_alloc(&key_type_fscrypt_user, description,
 			    current_fsuid(), current_gid(), current_cred(),
-			    KEY_POS_SEARCH | KEY_USR_VIEW, 0, NULL);
+			    &fscrypt_user_key_acl, 0, NULL);
 	if (IS_ERR(mk_user))
 		return PTR_ERR(mk_user);
 
@@ -357,8 +387,7 @@ static int add_new_master_key(struct fscrypt_master_key_secret *secret,
 	format_mk_description(description, mk_spec);
 	key = key_alloc(&key_type_fscrypt, description,
 			GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, current_cred(),
-			KEY_POS_SEARCH | KEY_USR_SEARCH | KEY_USR_VIEW,
-			KEY_ALLOC_NOT_IN_QUOTA, NULL);
+			&fscrypt_key_acl, KEY_ALLOC_NOT_IN_QUOTA, NULL);
 	if (IS_ERR(key)) {
 		err = PTR_ERR(key);
 		goto out_free_mk;
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index ad1a36c370c3fb..0727251be865b7 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -104,7 +104,7 @@ find_and_lock_process_key(const char *prefix,
 	if (!description)
 		return ERR_PTR(-ENOMEM);
 
-	key = request_key(&key_type_logon, description, NULL);
+	key = request_key(&key_type_logon, description, NULL, NULL);
 	kfree(description);
 	if (IS_ERR(key))
 		return key;
