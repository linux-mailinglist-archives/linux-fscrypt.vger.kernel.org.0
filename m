Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D973D78BD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Jul 2021 16:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbhG0Oof (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 27 Jul 2021 10:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhG0Ooe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 27 Jul 2021 10:44:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E864C061757
        for <linux-fscrypt@vger.kernel.org>; Tue, 27 Jul 2021 07:44:34 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1m8OJh-0005wY-AQ; Tue, 27 Jul 2021 16:44:21 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1m8OJe-0002zM-UG; Tue, 27 Jul 2021 16:44:18 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
Date:   Tue, 27 Jul 2021 16:43:49 +0200
Message-Id: <20210727144349.11215-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-fscrypt@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For both v1 and v2 key setup mechanisms, userspace supplies the raw key
material to the kernel after which it is never again disclosed to
userspace.

Use of encrypted and trusted keys offers stronger guarantees:
The key material is generated within the kernel and is never disclosed to
userspace in clear text and, in the case of trusted keys, can be
directly rooted to a trust source like a TPM chip.

Add support for trusted and encrypted keys by repurposing
fscrypt_add_key_arg::raw to hold the key description when the new
FSCRYPT_KEY_ARG_TYPE_DESC flag is supplied. The location of the flag
was previously reserved and enforced by ioctl code to be zero, so this
change won't break backwards compatibility.

Corresponding userspace patches are available for fscryptctl:
https://github.com/google/fscryptctl/pull/23

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
key_extract_material used by this patch is added in
<cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
which still awaits feedback.

Sending this RFC out anyway to get some feedback from the fscrypt
developers whether this is the correct way to go about it.

To: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Sumit Garg <sumit.garg@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-integrity@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Cc: keyrings@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/filesystems/fscrypt.rst | 24 ++++++++---
 fs/crypto/keyring.c                   | 59 ++++++++++++++++++++++++---
 include/uapi/linux/fscrypt.h          | 16 +++++++-
 3 files changed, 87 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 44b67ebd6e40..83738af2afa3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -681,11 +681,15 @@ It can be executed on any file or directory on the target filesystem,
 but using the filesystem's root directory is recommended.  It takes in
 a pointer to struct fscrypt_add_key_arg, defined as follows::
 
+    #define FSCRYPT_KEY_ADD_RAW_ASIS		0
+    #define FSCRYPT_KEY_ADD_RAW_DESC		1
+
     struct fscrypt_add_key_arg {
             struct fscrypt_key_specifier key_spec;
             __u32 raw_size;
             __u32 key_id;
-            __u32 __reserved[8];
+            __u32 raw_flags;     /* one of FSCRYPT_KEY_ADD_RAW_* */
+            __u32 __reserved[7];
             __u8 raw[];
     };
 
@@ -732,8 +736,11 @@ as follows:
   Alternatively, if ``key_id`` is nonzero, this field must be 0, since
   in that case the size is implied by the specified Linux keyring key.
 
-- ``key_id`` is 0 if the raw key is given directly in the ``raw``
-  field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
+- If ``key_id`` is 0, the raw key is given directly in the ``raw``
+  field if ``raw_flags == FSCRYPT_KEY_ADD_RAW_ASIS``. With
+  ``raw_flags == FSCRYPT_KEY_ADD_RAW_DESC``, ``raw`` is instead
+  interpreted as the description of an encrypted or trusted key.
+  Otherwise ``key_id`` is the ID of a Linux keyring key of
   type "fscrypt-provisioning" whose payload is
   struct fscrypt_provisioning_key_payload whose ``raw`` field contains
   the raw key and whose ``type`` field matches ``key_spec.type``.
@@ -748,8 +755,15 @@ as follows:
   without having to store the raw keys in userspace memory.
 
 - ``raw`` is a variable-length field which must contain the actual
-  key, ``raw_size`` bytes long.  Alternatively, if ``key_id`` is
-  nonzero, then this field is unused.
+  key when ``raw_flags == FSCRYPT_KEY_ADD_RAW_ASIS``,
+  ``raw_size`` bytes long.  Alternatively, if
+  ``raw_flags == FSCRYPT_KEY_ADD_RAW_DESC``, ``raw`` is interpreted
+  as the key description of an encrypted or trusted key, in that order.
+  The material of this key will be used as if it were a raw key
+  supplied by userspace.
+
+  In both cases, the buffer is ``raw_size`` bytes long. If ````key_id``
+  is nonzero, then this field is unused.
 
 For v2 policy keys, the kernel keeps track of which user (identified
 by effective user ID) added the key, and only allows the key to be
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 0b3ffbb4faf4..484f7c883b17 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -20,6 +20,9 @@
 
 #include <crypto/skcipher.h>
 #include <linux/key-type.h>
+#include <linux/key-type.h>
+#include <keys/encrypted-type.h>
+#include <keys/trusted-type.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
 
@@ -662,13 +665,57 @@ int fscrypt_ioctl_add_key(struct file *filp, void __user *_uarg)
 		if (err)
 			goto out_wipe_secret;
 	} else {
-		if (arg.raw_size < FSCRYPT_MIN_KEY_SIZE ||
-		    arg.raw_size > FSCRYPT_MAX_KEY_SIZE)
+		struct key *keyring_key = ERR_PTR(-EINVAL);
+		const void *key_material;
+		const char *desc;
+
+		switch (arg.raw_flags) {
+		case FSCRYPT_KEY_ADD_RAW_ASIS:
+			if (arg.raw_size < FSCRYPT_MIN_KEY_SIZE ||
+			    arg.raw_size > FSCRYPT_MAX_KEY_SIZE)
+				return -EINVAL;
+			secret.size = arg.raw_size;
+			err = -EFAULT;
+			if (copy_from_user(secret.raw, uarg->raw, secret.size))
+				goto out_wipe_secret;
+			break;
+		case FSCRYPT_KEY_ADD_RAW_DESC:
+			if (arg.raw_size > 4096)
+				return -EINVAL;
+			desc = memdup_user_nul(uarg->raw, arg.raw_size);
+			if (IS_ERR(desc))
+				return PTR_ERR(desc);
+
+			if (IS_REACHABLE(CONFIG_ENCRYPTED_KEYS))
+				keyring_key = request_key(&key_type_encrypted, desc, NULL);
+			if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) && IS_ERR(keyring_key))
+				keyring_key = request_key(&key_type_trusted, desc, NULL);
+
+			kfree(desc);
+
+			if (IS_ERR(keyring_key))
+				return PTR_ERR(keyring_key);
+
+			down_read(&keyring_key->sem);
+
+			key_material = key_extract_material(keyring_key, &secret.size);
+			if (!IS_ERR(key_material) && (secret.size < FSCRYPT_MIN_KEY_SIZE ||
+			    secret.size > FSCRYPT_MAX_KEY_SIZE))
+				key_material = ERR_PTR(-EINVAL);
+			if (IS_ERR(key_material)) {
+				up_read(&keyring_key->sem);
+				key_put(keyring_key);
+				return PTR_ERR(key_material);
+			}
+
+			memcpy(secret.raw, key_material, secret.size);
+
+			up_read(&keyring_key->sem);
+			key_put(keyring_key);
+			break;
+		default:
 			return -EINVAL;
-		secret.size = arg.raw_size;
-		err = -EFAULT;
-		if (copy_from_user(secret.raw, uarg->raw, secret.size))
-			goto out_wipe_secret;
+		}
 	}
 
 	err = add_master_key(sb, &secret, &arg.key_spec);
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9f4428be3e36..bd498a188cf5 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -119,12 +119,26 @@ struct fscrypt_provisioning_key_payload {
 	__u8 raw[];
 };
 
+/*
+ * fscrypt_add_key_arg::raw contains the raw key material directly
+ * if key_id == 0
+ */
+#define FSCRYPT_KEY_ADD_RAW_ASIS		0
+
+/*
+ * fscrypt_add_key_arg::raw is a key descriptor for an already
+ * existing kernel encrypted or trusted key if key_id == 0.
+ * The kernel key's material will be used as input for fscrypt.
+ */
+#define FSCRYPT_KEY_ADD_RAW_DESC		1
+
 /* Struct passed to FS_IOC_ADD_ENCRYPTION_KEY */
 struct fscrypt_add_key_arg {
 	struct fscrypt_key_specifier key_spec;
 	__u32 raw_size;
 	__u32 key_id;
-	__u32 __reserved[8];
+	__u32 raw_flags;	/* one of FSCRYPT_KEY_ADD_RAW_* */
+	__u32 __reserved[7];
 	__u8 raw[];
 };
 
-- 
2.30.2

