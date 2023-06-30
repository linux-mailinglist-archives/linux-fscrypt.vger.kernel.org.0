Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B07047433E5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 07:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjF3FD7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 01:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjF3FD6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 01:03:58 -0400
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6480B2D5B;
        Thu, 29 Jun 2023 22:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; s=LIY0OQ3MUMW6182UNI14; d=nsr.re.kr; t=1688101300; c=relaxed/relaxed; h=date:from:message-id:mime-version:subject:to; bh=4riMpAEG3a+AKNlM2Mz7oNKOqSY8PrUto7G2laVfLCQ=; b=bPzYj2smsTYuuJ9lodQ+9GvooF5cmZlDpc/a08lfjlqKWH3l6oCC/j+411TIhw9Hb3LGoZZyYVF0hFBHPHb+eDCyNI5RyYr+PD8wrswbOzyr4Gu9U+Pdbfyd8jvnENsbh5WRSC0drEGEFK09hfMvVsSit2EnymF0MXzK56EOvJAhbD2YGAPclDXhR0ks+wwswjt/gY8UAwU2nJYEfAHUBL4gepDjhXmyDFMO+wBtFYc1cftzDAcHAQIET8mc0EXAztc0cGLJJzvEUIRbxy8Z0YuD+s2kVMD7U8CQf+czwfDu4CEkanRFpsSpBwDJPbch3kH77xFGhx2RGdkaoqAnRA==
Received: from 210.104.33.70 (nsr.re.kr)
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
        by mail.nsr.re.kr with SMTP; Fri, 30 Jun 2023 14:01:25 +0900
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 128;
          Fri, 30 Jun 2023 14:03:31 +0900 (KST)
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
Subject: [PATCH v4 4/4] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date:   Fri, 30 Jun 2023 14:03:23 +0900
Message-Id: <20230630050323.984216-5-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230630050323.984216-1-letrhee@nsr.re.kr>
References: <20230630050323.984216-1-letrhee@nsr.re.kr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

It uses LEA-256-XTS for file encryption and LEA-256-CTS-CBC for
filename encryption. Includes constant changes as the number of
supported ciphers increases.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 fs/crypto/fscrypt_private.h        |  2 +-
 fs/crypto/keysetup.c               | 15 +++++++++++++++
 fs/crypto/policy.c                 |  4 ++++
 include/uapi/linux/fscrypt.h       |  4 +++-
 tools/include/uapi/linux/fscrypt.h |  4 +++-
 5 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2d63da48635a..df8075478f11 100644
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
