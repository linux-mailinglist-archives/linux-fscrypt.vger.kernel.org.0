Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD311784C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfLIVTY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfLIVTY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC0CE2071E;
        Mon,  9 Dec 2019 21:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926363;
        bh=UfqzD+esPBfPHwDjjLqkJ5E3YqVZyAA71Nq92++d4bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2nvwJ4ZsYA0a2z1vNDWrcRMpdfYwXEp9l8KyzUt1aYyS/0PGK7M6nP4rQz98wUBG
         jd9IxO/r462z75LQa1vzkts5qq19ld1y3kilWIqQ8B/lQ5d5hl5rvAccvOWK3yOBwK
         v5FBTQiF27FWny7IoVa8xzQUs9IXZS7iuuXAiPQs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 1/4] fscrypt: split up fscrypt_supported_policy() by policy version
Date:   Mon,  9 Dec 2019 13:18:26 -0800
Message-Id: <20191209211829.239800-2-ebiggers@kernel.org>
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

Make fscrypt_supported_policy() call new functions
fscrypt_supported_v1_policy() and fscrypt_supported_v2_policy(), to
reduce the indentation level and make the code easier to read.

Also adjust the function comment to mention that whether the encryption
policy is supported can also depend on the inode.

No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 116 +++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 57 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 96f528071bed3..fdb13ce69cd28 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -63,13 +63,65 @@ static bool supported_iv_ino_lblk_64_policy(
 	return true;
 }
 
+static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
+					const struct inode *inode)
+{
+	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+				     policy->filenames_encryption_mode)) {
+		fscrypt_warn(inode,
+			     "Unsupported encryption modes (contents %d, filenames %d)",
+			     policy->contents_encryption_mode,
+			     policy->filenames_encryption_mode);
+		return false;
+	}
+
+	if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
+			      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
+		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
+			     policy->flags);
+		return false;
+	}
+
+	return true;
+}
+
+static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
+					const struct inode *inode)
+{
+	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+				     policy->filenames_encryption_mode)) {
+		fscrypt_warn(inode,
+			     "Unsupported encryption modes (contents %d, filenames %d)",
+			     policy->contents_encryption_mode,
+			     policy->filenames_encryption_mode);
+		return false;
+	}
+
+	if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
+		fscrypt_warn(inode, "Unsupported encryption flags (0x%02x)",
+			     policy->flags);
+		return false;
+	}
+
+	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) &&
+	    !supported_iv_ino_lblk_64_policy(policy, inode))
+		return false;
+
+	if (memchr_inv(policy->__reserved, 0, sizeof(policy->__reserved))) {
+		fscrypt_warn(inode, "Reserved bits set in encryption policy");
+		return false;
+	}
+
+	return true;
+}
+
 /**
  * fscrypt_supported_policy - check whether an encryption policy is supported
  *
  * Given an encryption policy, check whether all its encryption modes and other
- * settings are supported by this kernel.  (But we don't currently don't check
- * for crypto API support here, so attempting to use an algorithm not configured
- * into the crypto API will still fail later.)
+ * settings are supported by this kernel on the given inode.  (But we don't
+ * currently don't check for crypto API support here, so attempting to use an
+ * algorithm not configured into the crypto API will still fail later.)
  *
  * Return: %true if supported, else %false
  */
@@ -77,60 +129,10 @@ bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
 			      const struct inode *inode)
 {
 	switch (policy_u->version) {
-	case FSCRYPT_POLICY_V1: {
-		const struct fscrypt_policy_v1 *policy = &policy_u->v1;
-
-		if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
-					     policy->filenames_encryption_mode)) {
-			fscrypt_warn(inode,
-				     "Unsupported encryption modes (contents %d, filenames %d)",
-				     policy->contents_encryption_mode,
-				     policy->filenames_encryption_mode);
-			return false;
-		}
-
-		if (policy->flags & ~(FSCRYPT_POLICY_FLAGS_PAD_MASK |
-				      FSCRYPT_POLICY_FLAG_DIRECT_KEY)) {
-			fscrypt_warn(inode,
-				     "Unsupported encryption flags (0x%02x)",
-				     policy->flags);
-			return false;
-		}
-
-		return true;
-	}
-	case FSCRYPT_POLICY_V2: {
-		const struct fscrypt_policy_v2 *policy = &policy_u->v2;
-
-		if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
-					     policy->filenames_encryption_mode)) {
-			fscrypt_warn(inode,
-				     "Unsupported encryption modes (contents %d, filenames %d)",
-				     policy->contents_encryption_mode,
-				     policy->filenames_encryption_mode);
-			return false;
-		}
-
-		if (policy->flags & ~FSCRYPT_POLICY_FLAGS_VALID) {
-			fscrypt_warn(inode,
-				     "Unsupported encryption flags (0x%02x)",
-				     policy->flags);
-			return false;
-		}
-
-		if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) &&
-		    !supported_iv_ino_lblk_64_policy(policy, inode))
-			return false;
-
-		if (memchr_inv(policy->__reserved, 0,
-			       sizeof(policy->__reserved))) {
-			fscrypt_warn(inode,
-				     "Reserved bits set in encryption policy");
-			return false;
-		}
-
-		return true;
-	}
+	case FSCRYPT_POLICY_V1:
+		return fscrypt_supported_v1_policy(&policy_u->v1, inode);
+	case FSCRYPT_POLICY_V2:
+		return fscrypt_supported_v2_policy(&policy_u->v2, inode);
 	}
 	return false;
 }
-- 
2.24.0.393.g34dc348eaf-goog

