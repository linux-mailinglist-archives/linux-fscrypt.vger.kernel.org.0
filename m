Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF011784B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfLIVTY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbfLIVTX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:19:23 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636C220726;
        Mon,  9 Dec 2019 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926363;
        bh=n5h0R+RN0YxO0gGyUm0UiiMG/AYb4Qpjvhb4U0ujepk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dS2fzutw5aolUoFVWBH0IoRlRTiVR7NDLwi6UtKxR1VE1MX1U5nfKrolMMhyIxYmS
         w0GgYrZLLnO1m1ZgNdfIX7pvR7NGxp8v8zR46SsCqbYD//He+xuRFI8BBiPad/2ovS
         Ct5Pf8n4iamyYefFA5mngZwy9FcGqBzohTPk8JB0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 3/4] fscrypt: move fscrypt_valid_enc_modes() to policy.c
Date:   Mon,  9 Dec 2019 13:18:28 -0800
Message-Id: <20191209211829.239800-4-ebiggers@kernel.org>
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

fscrypt_valid_enc_modes() is only used by policy.c, so move it to there.

Also adjust the order of the checks to be more natural, matching the
numerical order of the constants and also keeping AES-256 (the
recommended default) first in the list.

No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 18 ------------------
 fs/crypto/policy.c          | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 41b061cdf06ee..71f496fe71732 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -206,24 +206,6 @@ typedef enum {
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
-static inline bool fscrypt_valid_enc_modes(u32 contents_mode,
-					   u32 filenames_mode)
-{
-	if (contents_mode == FSCRYPT_MODE_AES_128_CBC &&
-	    filenames_mode == FSCRYPT_MODE_AES_128_CTS)
-		return true;
-
-	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
-	    filenames_mode == FSCRYPT_MODE_AES_256_CTS)
-		return true;
-
-	if (contents_mode == FSCRYPT_MODE_ADIANTUM &&
-	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
-		return true;
-
-	return false;
-}
-
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
 extern int fscrypt_initialize(unsigned int cop_flags);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index e785b00f19b30..f1cff83c151ac 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -29,6 +29,23 @@ bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
 	return !memcmp(policy1, policy2, fscrypt_policy_size(policy1));
 }
 
+static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
+{
+	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_AES_256_CTS)
+		return true;
+
+	if (contents_mode == FSCRYPT_MODE_AES_128_CBC &&
+	    filenames_mode == FSCRYPT_MODE_AES_128_CTS)
+		return true;
+
+	if (contents_mode == FSCRYPT_MODE_ADIANTUM &&
+	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
+		return true;
+
+	return false;
+}
+
 static bool supported_direct_key_modes(const struct inode *inode,
 				       u32 contents_mode, u32 filenames_mode)
 {
-- 
2.24.0.393.g34dc348eaf-goog

