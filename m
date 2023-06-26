Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0618373DAA5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Jun 2023 11:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjFZJAU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Jun 2023 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjFZI7y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Jun 2023 04:59:54 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF5B4EC0
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Jun 2023 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1687769580; c=relaxed/relaxed; h=date:from:message-id:mime-version:subject:to; bh=zuuP2jIe0pZPqoUtxjvL55N6OHfrTkFefMjYKKtwGHs=; b=P/GTSFUjdhT93uRcZ7N5Mf9yKfeZyDvDZoOOoVztHt5bqdnITZyXFbaflivWQnF6QIFzDHXsavJ57MQJugO8IeZvpobCKYgiY/URyNXHEgHYBxiQ/8itIaoISKY3S3T7bYfv5SniSzspsJJMMucbCQFHnUuPMr3v60zCz+RHEyDK5v/GSWyjmZmD3NvtmYCLj0+5RMq2j2NngJIfjanZrGScZux3Hp21GZiTgGHvcDa/bZC6o3A7beodxPw3bVl2zLLK6zK9IgVFWX3UFoBIKB9kDtf8pxZxlMBmNMMsy+ss2owpZBwdPGHct1Z9vWN8NXNjMNo4Zi6JfG6OJk44Ig==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Mon, 26 Jun 2023 17:45:39 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 334;
          Mon, 26 Jun 2023 17:47:46 +0900 (KST)
From:   Dongsoo Lee <letrhee@nsr.re.kr>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v3 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date:   Mon, 26 Jun 2023 17:47:03 +0900
Message-Id: <20230626084703.907331-5-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230626084703.907331-1-letrhee@nsr.re.kr>
References: <20230626084703.907331-1-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add LEA-256-XTS, LEA-256-CTS fscrypt support.

LEA is a South Korean 128-bit block cipher (with 128/192/256-bit keys)
included in the ISO/IEC 29192-2:2019 standard (Information security -
Lightweight cryptography - Part 2: Block ciphers). It shows fast
performance and, when SIMD instructions are available, it performs even
faster. Particularly, it outperforms AES when the dedicated crypto
instructions for AES are unavailable, regardless of the presence of SIMD
instructions. However, it is not recommended to use LEA unless there is
a clear reason (such as the absence of dedicated crypto instructions for
AES or a mandatory requirement) to do so. Also, to enable LEA support,
it needs to be enabled in the kernel crypto API.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 Documentation/filesystems/fscrypt.rst | 12 ++++++++++++
 fs/crypto/fscrypt_private.h           |  2 +-
 fs/crypto/keysetup.c                  | 15 +++++++++++++++
 fs/crypto/policy.c                    |  4 ++++
 include/uapi/linux/fscrypt.h          |  4 +++-
 tools/include/uapi/linux/fscrypt.h    |  4 +++-
 6 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index eccd327e6df5..60fb82c3382e 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -339,6 +339,7 @@ Currently, the following pairs of encryption modes are supported:
 - Adiantum for both contents and filenames
 - AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
 - SM4-XTS for contents and SM4-CTS-CBC for filenames (v2 policies only)
+- LEA-256-XTS for contents and LEA-256-CTS-CBC for filenames (v2 policies only)
 
 If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 
@@ -376,6 +377,17 @@ size.  It may be useful in cases where its use is mandated.
 Otherwise, it should not be used.  For SM4 support to be available, it
 also needs to be enabled in the kernel crypto API.
 
+LEA is a South Korean 128-bit block cipher (with 128/192/256-bit keys)
+included in the ISO/IEC 29192-2:2019 standard (Information security -
+Lightweight cryptography - Part 2: Block ciphers). It shows fast
+performance and, when SIMD instructions are available, it performs even
+faster. Particularly, it outperforms AES when the dedicated crypto
+instructions for AES are unavailable, regardless of the presence of SIMD
+instructions. However, it is not recommended to use LEA unless there is
+a clear reason (such as the absence of dedicated crypto instructions for
+AES or a mandatory requirement) to do so. Also, to enable LEA support,
+it needs to be enabled in the kernel crypto API.
+
 New encryption modes can be added relatively easily, without changes
 to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7ab5a7b7eef8..400238057219 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -31,7 +31,7 @@
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
-#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_LEA_256_CTS
 
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 361f41ef46c7..fa82579e56eb 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -74,6 +74,21 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.security_strength = 32,
 		.ivsize = 32,
 	},
+	[FSCRYPT_MODE_LEA_256_XTS] = {
+		.friendly_name = "LEA-256-XTS",
+		.cipher_str = "xts(lea)",
+		.keysize = 64,
+		.security_strength = 32,
+		.ivsize = 16,
+		.blk_crypto_mode = BLK_ENCRYPTION_MODE_LEA_256_XTS,
+	},
+	[FSCRYPT_MODE_LEA_256_CTS] = {
+		.friendly_name = "LEA-256-CTS-CBC",
+		.cipher_str = "cts(cbc(lea))",
+		.keysize = 32,
+		.security_strength = 32,
+		.ivsize = 16,
+	},
 };
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index f4456ecb3f87..9d1e80c43c6d 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -94,6 +94,10 @@ static bool fscrypt_valid_enc_modes_v2(u32 contents_mode, u32 filenames_mode)
 	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
 		return true;
 
+	if (contents_mode == FSCRYPT_MODE_LEA_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_LEA_256_CTS)
+		return true;
+
 	return fscrypt_valid_enc_modes_v1(contents_mode, filenames_mode);
 }
 
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index fd1fb0d5389d..df3c8af98210 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -30,7 +30,9 @@
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_LEA_256_XTS		11
+#define FSCRYPT_MODE_LEA_256_CTS		12
+/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index fd1fb0d5389d..df3c8af98210 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -30,7 +30,9 @@
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_LEA_256_XTS		11
+#define FSCRYPT_MODE_LEA_256_CTS		12
+/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
-- 
2.34.1
