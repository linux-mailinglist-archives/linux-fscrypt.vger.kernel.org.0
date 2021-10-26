Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1543AA1B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 04:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhJZCNm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Oct 2021 22:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233044AbhJZCNl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Oct 2021 22:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD8996105A
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Oct 2021 02:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635214277;
        bh=Y243GGaqc0H//eT0UW0+rqvA3KbVNjp8l3IFaKqXsTo=;
        h=From:To:Subject:Date:From;
        b=sZfNrVkwR5TPWCslBsvHf89SLP34HYIbYG8d5bSw4xc7lQ47Hstxw0L+x4poFs7nL
         QVkmRehHaz6WdyLX6pdF6TzSf/TVz7y5kquJ35/XX9OPjU1FmyS/YgOBwMQ07oSCFK
         I4Ls35D1UmkKTrd7yBm8YM/0kS3WQeDdLfJHqr7mSV721XaF9klsxqQlmWxUfh3b21
         IL8jO74ZX1cLV3qhhegyw/eWKVU61oIQKdj1cgHwunme+4J0dswAhkLwCwOdprvBjr
         RrzJkhDHy7SfvE0S89cprmOCZqpwJWYBblWS7KZTHcRuB9rS7/85FqOajLJmr9pTDm
         ER8J8BBa1Bz4g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: improve a few comments
Date:   Mon, 25 Oct 2021 19:10:42 -0700
Message-Id: <20211026021042.6581-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Improve a few comments.  These were extracted from the patch
"fscrypt: add support for hardware-wrapped keys"
(https://lore.kernel.org/r/20211021181608.54127-4-ebiggers@kernel.org).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 11 ++++++++++-
 fs/crypto/keysetup.c        |  5 +++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cb25ef0cdf1f3..5b0a9e6478b5d 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -20,6 +20,11 @@
 
 #define FSCRYPT_FILE_NONCE_SIZE	16
 
+/*
+ * Minimum size of an fscrypt master key.  Note: a longer key will be required
+ * if ciphers with a 256-bit security strength are used.  This is just the
+ * absolute minimum, which applies when only 128-bit encryption is used.
+ */
 #define FSCRYPT_MIN_KEY_SIZE	16
 
 #define FSCRYPT_CONTEXT_V1	1
@@ -413,7 +418,11 @@ struct fscrypt_master_key_secret {
 	 */
 	struct fscrypt_hkdf	hkdf;
 
-	/* Size of the raw key in bytes.  Set even if ->raw isn't set. */
+	/*
+	 * Size of the raw key in bytes.  This remains set even if ->raw was
+	 * zeroized due to no longer being needed.  I.e. we still remember the
+	 * size of the key even if we don't need to remember the key itself.
+	 */
 	u32			size;
 
 	/* For v1 policy keys: the raw key.  Wiped for v2 policy keys. */
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 89cd533a88bff..eede186b04ce3 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -122,8 +122,9 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
- * raw key, encryption mode, and flag indicating which encryption implementation
- * (fs-layer or blk-crypto) will be used.
+ * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
+ * implementation (fs-layer or blk-crypto) will be used (@ci->ci_inlinecrypt),
+ * and IV generation method (@ci->ci_policy.flags).
  */
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_info *ci)

base-commit: 7f595d6a6cdc336834552069a2e0a4f6d4756ddf
-- 
2.33.1

