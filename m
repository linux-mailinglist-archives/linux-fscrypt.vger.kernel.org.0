Return-Path: <linux-fscrypt+bounces-117-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE8EF82B997
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 03:31:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AE881F222BF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 02:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1801914F87;
	Fri, 12 Jan 2024 02:30:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F9814A80;
	Fri, 12 Jan 2024 02:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nsr.re.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nsr.re.kr
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Fri, 12 Jan 2024 11:30:21 +0900
X-Sender: letrhee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 155;
          Fri, 12 Jan 2024 11:30:17 +0900 (KST)
From: Dongsoo Lee <letrhee@nsr.re.kr>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v6 RESEND 4/5] fscrypt: Add LEA-256-XTS, LEA-256-CTS support
Date: Fri, 12 Jan 2024 02:28:58 +0000
Message-Id: <20240112022859.2384-5-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240112022859.2384-1-letrhee@nsr.re.kr>
References: <20240112022859.2384-1-letrhee@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 1892356cf924..1f0502999804 100644
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
index d71f7c799e79..f8b0116e43a3 100644
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
index 701259991277..b9bb175a11c7 100644
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
index 7a8f4c290187..c3c5a04f85c8 100644
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
index 7a8f4c290187..c3c5a04f85c8 100644
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
2.40.1

