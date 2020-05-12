Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F711D031D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 01:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgELXgK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 19:36:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELXgJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 19:36:09 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B066C20753;
        Tue, 12 May 2020 23:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589326568;
        bh=EEakLHov+/y1Y/0O8Mqo/Itjd8dO5abxKpeHqQD/g6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVaPAYOdAT7VQ6IeMYWKeDPJih9Y81YQfL3bwHVeYmSiAAXwqn6aOm4FYDbqISAdQ
         U4XKzf1y8c6HI7uPFKgdiQUsONFGxqB1cFBtTWCkYN+QNaVsihpMqeulbTpO5/vxwo
         gINS5mhH3s4YN2cZJG5h4zZFlrY9NkAAIVdgfM7E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 2/4] fscrypt: add fscrypt_add_test_dummy_key()
Date:   Tue, 12 May 2020 16:32:49 -0700
Message-Id: <20200512233251.118314-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200512233251.118314-1-ebiggers@kernel.org>
References: <20200512233251.118314-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently, the test_dummy_encryption mount option (which is used for
encryption I/O testing with xfstests) uses v1 encryption policies, and
it relies on userspace inserting a test key into the session keyring.

We need test_dummy_encryption to support v2 encryption policies too.
Requiring userspace to add the test key doesn't work well with v2
policies, since v2 policies only support the filesystem keyring (not the
session keyring), and keys in the filesystem keyring are lost when the
filesystem is unmounted.  Hooking all test code that unmounts and
re-mounts the filesystem would be difficult.

Instead, let's make the filesystem automatically add the test key to its
keyring when test_dummy_encryption is enabled.

That puts the responsibility for choosing the test key on the kernel.
We could just hard-code a key.  But out of paranoia, let's first try
using a per-boot random key, to prevent this code from being misused.
A per-boot key will work as long as no one expects dummy-encrypted files
to remain accessible after a reboot.  (gce-xfstests doesn't.)

Therefore, this patch adds a function fscrypt_add_test_dummy_key() which
implements the above.  The next patch will use it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |   3 +
 fs/crypto/keyring.c         | 117 +++++++++++++++++++++++-------------
 2 files changed, 77 insertions(+), 43 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index dbced2937ec895..1bdb4a3a9b9fd6 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -440,6 +440,9 @@ extern struct key *
 fscrypt_find_master_key(struct super_block *sb,
 			const struct fscrypt_key_specifier *mk_spec);
 
+int fscrypt_add_test_dummy_key(struct super_block *sb,
+			       struct fscrypt_key_specifier *key_spec);
+
 extern int fscrypt_verify_key_added(struct super_block *sb,
 				    const u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE]);
 
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index ab41b25d4fa1ba..c983ddfde8ad8d 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -20,6 +20,7 @@
 
 #include <crypto/skcipher.h>
 #include <linux/key-type.h>
+#include <linux/random.h>
 #include <linux/seq_file.h>
 
 #include "fscrypt_private.h"
@@ -424,9 +425,9 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 	return 0;
 }
 
-static int add_master_key(struct super_block *sb,
-			  struct fscrypt_master_key_secret *secret,
-			  const struct fscrypt_key_specifier *mk_spec)
+static int do_add_master_key(struct super_block *sb,
+			     struct fscrypt_master_key_secret *secret,
+			     const struct fscrypt_key_specifier *mk_spec)
 {
 	static DEFINE_MUTEX(fscrypt_add_key_mutex);
 	struct key *key;
@@ -465,6 +466,35 @@ static int add_master_key(struct super_block *sb,
 	return err;
 }
 
+static int add_master_key(struct super_block *sb,
+			  struct fscrypt_master_key_secret *secret,
+			  struct fscrypt_key_specifier *key_spec)
+{
+	int err;
+
+	if (key_spec->type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER) {
+		err = fscrypt_init_hkdf(&secret->hkdf, secret->raw,
+					secret->size);
+		if (err)
+			return err;
+
+		/*
+		 * Now that the HKDF context is initialized, the raw key is no
+		 * longer needed.
+		 */
+		memzero_explicit(secret->raw, secret->size);
+
+		/* Calculate the key identifier */
+		err = fscrypt_hkdf_expand(&secret->hkdf,
+					  HKDF_CONTEXT_KEY_IDENTIFIER, NULL, 0,
+					  key_spec->u.identifier,
+					  FSCRYPT_KEY_IDENTIFIER_SIZE);
+		if (err)
+			return err;
+	}
+	return do_add_master_key(sb, secret, key_spec);
+}
+
 static int fscrypt_provisioning_key_preparse(struct key_preparsed_payload *prep)
 {
 	const struct fscrypt_provisioning_key_payload *payload = prep->data;
@@ -609,6 +639,15 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 	if (memchr_inv(arg.__reserved, 0, sizeof(arg.__reserved)))
 		return -EINVAL;
 
+	/*
+	 * Only root can add keys that are identified by an arbitrary descriptor
+	 * rather than by a cryptographic hash --- since otherwise a malicious
+	 * user could add the wrong key.
+	 */
+	if (arg.key_spec.type == FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR &&
+	    !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
 	memset(&secret, 0, sizeof(secret));
 	if (arg.key_id) {
 		if (arg.raw_size != 0)
@@ -626,54 +665,46 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 			goto out_wipe_secret;
 	}
 
-	switch (arg.key_spec.type) {
-	case FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR:
-		/*
-		 * Only root can add keys that are identified by an arbitrary
-		 * descriptor rather than by a cryptographic hash --- since
-		 * otherwise a malicious user could add the wrong key.
-		 */
-		err = -EACCES;
-		if (!capable(CAP_SYS_ADMIN))
-			goto out_wipe_secret;
-		break;
-	case FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER:
-		err = fscrypt_init_hkdf(&secret.hkdf, secret.raw, secret.size);
-		if (err)
-			goto out_wipe_secret;
-
-		/*
-		 * Now that the HKDF context is initialized, the raw key is no
-		 * longer needed.
-		 */
-		memzero_explicit(secret.raw, secret.size);
-
-		/* Calculate the key identifier and return it to userspace. */
-		err = fscrypt_hkdf_expand(&secret.hkdf,
-					  HKDF_CONTEXT_KEY_IDENTIFIER,
-					  NULL, 0, arg.key_spec.u.identifier,
-					  FSCRYPT_KEY_IDENTIFIER_SIZE);
-		if (err)
-			goto out_wipe_secret;
-		err = -EFAULT;
-		if (copy_to_user(uarg->key_spec.u.identifier,
-				 arg.key_spec.u.identifier,
-				 FSCRYPT_KEY_IDENTIFIER_SIZE))
-			goto out_wipe_secret;
-		break;
-	default:
-		WARN_ON(1);
-		err = -EINVAL;
+	err = add_master_key(sb, &secret, &arg.key_spec);
+	if (err)
 		goto out_wipe_secret;
-	}
 
-	err = add_master_key(sb, &secret, &arg.key_spec);
+	/* Return the key identifier to userspace, if applicable */
+	err = -EFAULT;
+	if (arg.key_spec.type == FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER &&
+	    copy_to_user(uarg->key_spec.u.identifier, arg.key_spec.u.identifier,
+			 FSCRYPT_KEY_IDENTIFIER_SIZE))
+		goto out_wipe_secret;
+	err = 0;
 out_wipe_secret:
 	wipe_master_key_secret(&secret);
 	return err;
 }
 EXPORT_SYMBOL_GPL(fscrypt_ioctl_add_key);
 
+/*
+ * Add the key for '-o test_dummy_encryption' to the filesystem keyring.
+ *
+ * Use a per-boot random key to prevent people from misusing this option.
+ */
+int fscrypt_add_test_dummy_key(struct super_block *sb,
+			       struct fscrypt_key_specifier *key_spec)
+{
+	static u8 test_key[FSCRYPT_MAX_KEY_SIZE];
+	struct fscrypt_master_key_secret secret;
+	int err;
+
+	get_random_once(test_key, FSCRYPT_MAX_KEY_SIZE);
+
+	memset(&secret, 0, sizeof(secret));
+	secret.size = FSCRYPT_MAX_KEY_SIZE;
+	memcpy(secret.raw, test_key, FSCRYPT_MAX_KEY_SIZE);
+
+	err = add_master_key(sb, &secret, key_spec);
+	wipe_master_key_secret(&secret);
+	return err;
+}
+
 /*
  * Verify that the current user has added a master key with the given identifier
  * (returns -ENOKEY if not).  This is needed to prevent a user from encrypting
-- 
2.26.2

