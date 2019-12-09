Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38C6B11784E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfLIVTZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfLIVTY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DD1820721;
        Mon,  9 Dec 2019 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926363;
        bh=2t2zHjdLcabx9JAerCcLMD7S2wxXmjeDy//wqclhC1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VOSUaxp1JUk66FkvHJT2Xw430pQXz80vcm3XdzSaRJ9aT9VgEWllxDwnBMlTIIwJ2
         c12HcY+WDmN79GRCX81fcys5yDgp83PodAdijIgoLxPdDrWhZ0KRbYJYvvhhqFF/++
         YmHnAg9IBq2ZO2OpItQzYaebX6qWuYD97es06T0E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 2/4] fscrypt: check for appropriate use of DIRECT_KEY flag earlier
Date:   Mon,  9 Dec 2019 13:18:27 -0800
Message-Id: <20191209211829.239800-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209211829.239800-1-ebiggers@kernel.org>
References: <20191209211829.239800-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

FSCRYPT_POLICY_FLAG_DIRECT_KEY is currently only allowed with Adiantum
encryption.  But FS_IOC_SET_ENCRYPTION_POLICY allowed it in combination
with other encryption modes, and an error wasn't reported until later
when the encrypted directory was actually used.

Fix it to report the error earlier by validating the correct use of the
DIRECT_KEY flag in fscrypt_supported_policy(), similar to how we
validate the IV_INO_LBLK_64 flag.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  6 +-----
 fs/crypto/keysetup.c        | 14 ++++----------
 fs/crypto/keysetup_v1.c     | 15 ---------------
 fs/crypto/policy.c          | 30 ++++++++++++++++++++++++++++++
 4 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 37c418d23962b..41b061cdf06ee 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -448,11 +448,7 @@ struct fscrypt_mode {
 	int logged_impl_name;
 };
 
-static inline bool
-fscrypt_mode_supports_direct_key(const struct fscrypt_mode *mode)
-{
-	return mode->ivsize >= offsetofend(union fscrypt_iv, nonce);
-}
+extern struct fscrypt_mode fscrypt_modes[];
 
 extern struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 39fdea79e912f..96074054bdbc8 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -13,7 +13,7 @@
 
 #include "fscrypt_private.h"
 
-static struct fscrypt_mode available_modes[] = {
+struct fscrypt_mode fscrypt_modes[] = {
 	[FSCRYPT_MODE_AES_256_XTS] = {
 		.friendly_name = "AES-256-XTS",
 		.cipher_str = "xts(aes)",
@@ -51,10 +51,10 @@ select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode))
-		return &available_modes[fscrypt_policy_contents_mode(policy)];
+		return &fscrypt_modes[fscrypt_policy_contents_mode(policy)];
 
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
-		return &available_modes[fscrypt_policy_fnames_mode(policy)];
+		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
 
 	WARN_ONCE(1, "fscrypt: filesystem tried to load encryption info for inode %lu, which is not encryptable (file type %d)\n",
 		  inode->i_ino, (inode->i_mode & S_IFMT));
@@ -129,7 +129,7 @@ static int setup_per_mode_key(struct fscrypt_info *ci,
 	const struct inode *inode = ci->ci_inode;
 	const struct super_block *sb = inode->i_sb;
 	struct fscrypt_mode *mode = ci->ci_mode;
-	u8 mode_num = mode - available_modes;
+	const u8 mode_num = mode - fscrypt_modes;
 	struct crypto_skcipher *tfm, *prev_tfm;
 	u8 mode_key[FSCRYPT_MAX_KEY_SIZE];
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
@@ -189,12 +189,6 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 		 * This ensures that the master key is consistently used only
 		 * for HKDF, avoiding key reuse issues.
 		 */
-		if (!fscrypt_mode_supports_direct_key(ci->ci_mode)) {
-			fscrypt_warn(ci->ci_inode,
-				     "Direct key flag not allowed with %s",
-				     ci->ci_mode->friendly_name);
-			return -EINVAL;
-		}
 		return setup_per_mode_key(ci, mk, mk->mk_direct_tfms,
 					  HKDF_CONTEXT_DIRECT_KEY, false);
 	} else if (ci->ci_policy.v2.flags &
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 5298ef22aa859..3578c1c607c51 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -253,23 +253,8 @@ fscrypt_get_direct_key(const struct fscrypt_info *ci, const u8 *raw_key)
 static int setup_v1_file_key_direct(struct fscrypt_info *ci,
 				    const u8 *raw_master_key)
 {
-	const struct fscrypt_mode *mode = ci->ci_mode;
 	struct fscrypt_direct_key *dk;
 
-	if (!fscrypt_mode_supports_direct_key(mode)) {
-		fscrypt_warn(ci->ci_inode,
-			     "Direct key mode not allowed with %s",
-			     mode->friendly_name);
-		return -EINVAL;
-	}
-
-	if (ci->ci_policy.v1.contents_encryption_mode !=
-	    ci->ci_policy.v1.filenames_encryption_mode) {
-		fscrypt_warn(ci->ci_inode,
-			     "Direct key mode not allowed with different contents and filenames modes");
-		return -EINVAL;
-	}
-
 	dk = fscrypt_get_direct_key(ci, raw_master_key);
 	if (IS_ERR(dk))
 		return PTR_ERR(dk);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index fdb13ce69cd28..e785b00f19b30 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -29,6 +29,26 @@ bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
 	return !memcmp(policy1, policy2, fscrypt_policy_size(policy1));
 }
 
+static bool supported_direct_key_modes(const struct inode *inode,
+				       u32 contents_mode, u32 filenames_mode)
+{
+	const struct fscrypt_mode *mode;
+
+	if (contents_mode != filenames_mode) {
+		fscrypt_warn(inode,
+			     "Direct key flag not allowed with different contents and filenames modes");
+		return false;
+	}
+	mode = &fscrypt_modes[contents_mode];
+
+	if (mode->ivsize < offsetofend(union fscrypt_iv, nonce)) {
+		fscrypt_warn(inode, "Direct key flag not allowed with %s",
+			     mode->friendly_name);
+		return false;
+	}
+	return true;
+}
+
 static bool supported_iv_ino_lblk_64_policy(
 					const struct fscrypt_policy_v2 *policy,
 					const struct inode *inode)
@@ -82,6 +102,11 @@ static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
 		return false;
 	}
 
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) &&
+	    !supported_direct_key_modes(inode, policy->contents_encryption_mode,
+					policy->filenames_encryption_mode))
+		return false;
+
 	return true;
 }
 
@@ -103,6 +128,11 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		return false;
 	}
 
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) &&
+	    !supported_direct_key_modes(inode, policy->contents_encryption_mode,
+					policy->filenames_encryption_mode))
+		return false;
+
 	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) &&
 	    !supported_iv_ino_lblk_64_policy(policy, inode))
 		return false;
-- 
2.24.0.393.g34dc348eaf-goog

