Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16F01297A1D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Oct 2020 02:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757148AbgJXAwb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 23 Oct 2020 20:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757142AbgJXAwa (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 23 Oct 2020 20:52:30 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D67A2137B;
        Sat, 24 Oct 2020 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603500749;
        bh=NZB0h7Jpq6DmOfGEmEupTswD29UD7PJtM1kWqbdQOrQ=;
        h=From:To:Cc:Subject:Date:From;
        b=LGMq/RZ/UYSfgBSKwH8FZ1OKec5/ct1jLIJjNYJDMSkCVDLKTu4mdbkLzqPDl+tpg
         heaIS1PFy9pHCkzyhipDWR0gbOH+oL3FBLOAoGxLaPcMphqnFBGNd9jfBBrGUI8Nhm
         CvTSp29EcgzSakAXd2/Fu6APFZWJLGoMrxEu58Ro=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-api@vger.kernel.org
Subject: [PATCH] fscrypt: remove kernel-internal constants from UAPI header
Date:   Fri, 23 Oct 2020 17:51:31 -0700
Message-Id: <20201024005132.495952-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.0.rc1.297.gfa9743e501-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

There isn't really any valid reason to use __FSCRYPT_MODE_MAX or
FSCRYPT_POLICY_FLAGS_VALID in a userspace program.  These constants are
only meant to be used by the kernel internally, and they are defined in
the UAPI header next to the mode numbers and flags only so that kernel
developers don't forget to update them when adding new modes or flags.

In https://lkml.kernel.org/r/20201005074133.1958633-2-satyat@google.com
there was an example of someone wanting to use __FSCRYPT_MODE_MAX in a
user program, and it was wrong because the program would have broken if
__FSCRYPT_MODE_MAX were ever increased.  So having this definition
available is harmful.  FSCRYPT_POLICY_FLAGS_VALID has the same problem.

So, remove these definitions from the UAPI header.  Replace
FSCRYPT_POLICY_FLAGS_VALID with just listing the valid flags explicitly
in the one kernel function that needs it.  Move __FSCRYPT_MODE_MAX to
fscrypt_private.h, remove the double underscores (which were only
present to discourage use by userspace), and add a BUILD_BUG_ON() and
comments to (hopefully) ensure it is kept in sync.

Keep the old name FS_POLICY_FLAGS_VALID, since it's been around for
longer and there's a greater chance that removing it would break source
compatibility with some program.  Indeed, mtd-utils is using it in
an #ifdef, and removing it would introduce compiler warnings (about
FS_POLICY_FLAGS_PAD_* being redefined) into the mtd-utils build.
However, reduce its value to 0x07 so that it only includes the flags
with old names (the ones present before Linux 5.4), and try to make it
clear that it's now "frozen" and no new flags should be added to it.

Fixes: 2336d0deb2d4 ("fscrypt: use FSCRYPT_ prefix for uapi constants")
Cc: <stable@vger.kernel.org> # v5.4+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h  | 9 ++++++---
 fs/crypto/keyring.c          | 2 +-
 fs/crypto/keysetup.c         | 4 +++-
 fs/crypto/policy.c           | 5 ++++-
 include/uapi/linux/fscrypt.h | 5 ++---
 5 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 4f5806a3b73d..322ecae9a758 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -25,6 +25,9 @@
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
+/* Keep this in sync with include/uapi/linux/fscrypt.h */
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_ADIANTUM
+
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
 	u8 contents_encryption_mode;
@@ -491,9 +494,9 @@ struct fscrypt_master_key {
 	 * Per-mode encryption keys for the various types of encryption policies
 	 * that use them.  Allocated and derived on-demand.
 	 */
-	struct fscrypt_prepared_key mk_direct_keys[__FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[__FSCRYPT_MODE_MAX + 1];
-	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[__FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_direct_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_iv_ino_lblk_64_keys[FSCRYPT_MODE_MAX + 1];
+	struct fscrypt_prepared_key mk_iv_ino_lblk_32_keys[FSCRYPT_MODE_MAX + 1];
 
 	/* Hash key for inode numbers.  Initialized only when needed. */
 	siphash_key_t		mk_ino_hash_key;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 53cc552a7b8f..d7ec52cb3d9a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -44,7 +44,7 @@ static void free_master_key(struct fscrypt_master_key *mk)
 
 	wipe_master_key_secret(&mk->mk_secret);
 
-	for (i = 0; i <= __FSCRYPT_MODE_MAX; i++) {
+	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
 		fscrypt_destroy_prepared_key(&mk->mk_direct_keys[i]);
 		fscrypt_destroy_prepared_key(&mk->mk_iv_ino_lblk_64_keys[i]);
 		fscrypt_destroy_prepared_key(&mk->mk_iv_ino_lblk_32_keys[i]);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d3c3e5d9b41f..43408d2f0acf 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -56,6 +56,8 @@ static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
 {
+	BUILD_BUG_ON(ARRAY_SIZE(fscrypt_modes) != FSCRYPT_MODE_MAX + 1);
+
 	if (S_ISREG(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_contents_mode(policy)];
 
@@ -168,7 +170,7 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
 	unsigned int hkdf_infolen = 0;
 	int err;
 
-	if (WARN_ON(mode_num > __FSCRYPT_MODE_MAX))
+	if (WARN_ON(mode_num > FSCRYPT_MODE_MAX))
 		return -EINVAL;
 
 	prep_key = &keys[mode_num];
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 4441d9944b9e..faa0f21daa68 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -175,7 +175,10 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		return false;
 	}
 
-	if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+			      FSCRYPT_POLICY_FLAG_DIRECT_KEY |
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
+			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
 		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
 			     policy->flags);
 		return false;
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index e5de60336938..9f4428be3e36 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -20,7 +20,6 @@
 #define FSCRYPT_POLICY_FLAG_DIRECT_KEY		0x04
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64	0x08
 #define FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32	0x10
-#define FSCRYPT_POLICY_FLAGS_VALID		0x1F
 
 /* Encryption algorithms */
 #define FSCRYPT_MODE_AES_256_XTS		1
@@ -28,7 +27,7 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-#define __FSCRYPT_MODE_MAX			9
+/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
@@ -177,7 +176,7 @@ struct fscrypt_get_key_status_arg {
 #define FS_POLICY_FLAGS_PAD_32		FSCRYPT_POLICY_FLAGS_PAD_32
 #define FS_POLICY_FLAGS_PAD_MASK	FSCRYPT_POLICY_FLAGS_PAD_MASK
 #define FS_POLICY_FLAG_DIRECT_KEY	FSCRYPT_POLICY_FLAG_DIRECT_KEY
-#define FS_POLICY_FLAGS_VALID		FSCRYPT_POLICY_FLAGS_VALID
+#define FS_POLICY_FLAGS_VALID		0x07	/* contains old flags only */
 #define FS_ENCRYPTION_MODE_INVALID	0	/* never used */
 #define FS_ENCRYPTION_MODE_AES_256_XTS	FSCRYPT_MODE_AES_256_XTS
 #define FS_ENCRYPTION_MODE_AES_256_GCM	2	/* never used */
-- 
2.29.0.rc1.297.gfa9743e501-goog

