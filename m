Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A4755A40
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjGQDxS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjGQDxD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:03 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C5AE48;
        Sun, 16 Jul 2023 20:52:57 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 198868341B;
        Sun, 16 Jul 2023 23:52:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565977; bh=fc8V80uwL1EJR9kXeU6P0xiETGVQBk6LO1V+FbSjDFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqoJi3avHJJIOLDnXx3XZZOzGOLu/XE+aBHqB8enZf3/Ved12MuMNfFuaxmGcyQyw
         tOFwLejXX+zaCrjZMkN+z2oO7jXkmKnXrKry8O8x+2yUpBt1GWDSsW81gCTi+gTMeH
         9wnZfyf7LuyzT647dkiGlM1TAaYPFTAdsLxgnq0LnZ7S6RvRi7s1LDDY198Nkttp8X
         9tTg5F7J1zOQF5wLLxCYYHtwj11HjCH05LFkHuKu121YKpMgtVsX8AjX+JSjMUbuM0
         4Q1kTFmHW6+O+s94R1xgJLHsXyxfUmqkOG1rae+Df4uY76qU55wru5JaKRBnyx/DlB
         vDx95B2FAvOng==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 03/17] fscrypt: expose fscrypt_nokey_name
Date:   Sun, 16 Jul 2023 23:52:34 -0400
Message-Id: <dfcbcba94da168404cac5407f7b3a62932f8e8fe.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

btrfs stores its data structures, including filenames in directories, in
its own buffer implementation, struct extent_buffer, composed of
several non-contiguous pages. We could copy filenames into a
temporary buffer and use fscrypt_match_name() against that buffer, such
extensive memcpying would be expensive. Instead, exposing
fscrypt_nokey_name as in this change allows btrfs to recapitulate
fscrypt_match_name() using methods on struct extent_buffer instead of
dealing with a raw byte array.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/fname.c       | 39 +--------------------------------------
 include/linux/fscrypt.h | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index edb78cd1b0e7..fb6bc46302c1 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -14,7 +14,6 @@
 #include <linux/namei.h>
 #include <linux/scatterlist.h>
 #include <crypto/hash.h>
-#include <crypto/sha2.h>
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
@@ -26,43 +25,7 @@
 #define FSCRYPT_FNAME_MIN_MSG_LEN 16
 
 /*
- * struct fscrypt_nokey_name - identifier for directory entry when key is absent
- *
- * When userspace lists an encrypted directory without access to the key, the
- * filesystem must present a unique "no-key name" for each filename that allows
- * it to find the directory entry again if requested.  Naively, that would just
- * mean using the ciphertext filenames.  However, since the ciphertext filenames
- * can contain illegal characters ('\0' and '/'), they must be encoded in some
- * way.  We use base64url.  But that can cause names to exceed NAME_MAX (255
- * bytes), so we also need to use a strong hash to abbreviate long names.
- *
- * The filesystem may also need another kind of hash, the "dirhash", to quickly
- * find the directory entry.  Since filesystems normally compute the dirhash
- * over the on-disk filename (i.e. the ciphertext), it's not computable from
- * no-key names that abbreviate the ciphertext using the strong hash to fit in
- * NAME_MAX.  It's also not computable if it's a keyed hash taken over the
- * plaintext (but it may still be available in the on-disk directory entry);
- * casefolded directories use this type of dirhash.  At least in these cases,
- * each no-key name must include the name's dirhash too.
- *
- * To meet all these requirements, we base64url-encode the following
- * variable-length structure.  It contains the dirhash, or 0's if the filesystem
- * didn't provide one; up to 149 bytes of the ciphertext name; and for
- * ciphertexts longer than 149 bytes, also the SHA-256 of the remaining bytes.
- *
- * This ensures that each no-key name contains everything needed to find the
- * directory entry again, contains only legal characters, doesn't exceed
- * NAME_MAX, is unambiguous unless there's a SHA-256 collision, and that we only
- * take the performance hit of SHA-256 on very long filenames (which are rare).
- */
-struct fscrypt_nokey_name {
-	u32 dirhash[2];
-	u8 bytes[149];
-	u8 sha256[SHA256_DIGEST_SIZE];
-}; /* 189 bytes => 252 bytes base64url-encoded, which is <= NAME_MAX (255) */
-
-/*
- * Decoded size of max-size no-key name, i.e. a name that was abbreviated using
+ * Decoded size of max-size nokey name, i.e. a name that was abbreviated using
  * the strong hash and thus includes the 'sha256' field.  This isn't simply
  * sizeof(struct fscrypt_nokey_name), as the padding at the end isn't included.
  */
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4ba624beea91..b2bde13fe0cc 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <crypto/sha2.h>
 #include <uapi/linux/fscrypt.h>
 
 /*
@@ -54,6 +55,42 @@ struct fscrypt_name {
 #define fname_name(p)		((p)->disk_name.name)
 #define fname_len(p)		((p)->disk_name.len)
 
+/*
+ * struct fscrypt_nokey_name - identifier for directory entry when key is absent
+ *
+ * When userspace lists an encrypted directory without access to the key, the
+ * filesystem must present a unique "no-key name" for each filename that allows
+ * it to find the directory entry again if requested.  Naively, that would just
+ * mean using the ciphertext filenames.  However, since the ciphertext filenames
+ * can contain illegal characters ('\0' and '/'), they must be encoded in some
+ * way.  We use base64url.  But that can cause names to exceed NAME_MAX (255
+ * bytes), so we also need to use a strong hash to abbreviate long names.
+ *
+ * The filesystem may also need another kind of hash, the "dirhash", to quickly
+ * find the directory entry.  Since filesystems normally compute the dirhash
+ * over the on-disk filename (i.e. the ciphertext), it's not computable from
+ * no-key names that abbreviate the ciphertext using the strong hash to fit in
+ * NAME_MAX.  It's also not computable if it's a keyed hash taken over the
+ * plaintext (but it may still be available in the on-disk directory entry);
+ * casefolded directories use this type of dirhash.  At least in these cases,
+ * each no-key name must include the name's dirhash too.
+ *
+ * To meet all these requirements, we base64url-encode the following
+ * variable-length structure.  It contains the dirhash, or 0's if the filesystem
+ * didn't provide one; up to 149 bytes of the ciphertext name; and for
+ * ciphertexts longer than 149 bytes, also the SHA-256 of the remaining bytes.
+ *
+ * This ensures that each no-key name contains everything needed to find the
+ * directory entry again, contains only legal characters, doesn't exceed
+ * NAME_MAX, is unambiguous unless there's a SHA-256 collision, and that we only
+ * take the performance hit of SHA-256 on very long filenames (which are rare).
+ */
+struct fscrypt_nokey_name {
+	u32 dirhash[2];
+	u8 bytes[149];
+	u8 sha256[SHA256_DIGEST_SIZE];
+}; /* 189 bytes => 252 bytes base64url-encoded, which is <= NAME_MAX (255) */
+
 /* Maximum value for the third parameter of fscrypt_operations.set_context(). */
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
 
-- 
2.40.1

