Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D265192BA
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 May 2022 02:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244590AbiEDAW7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 May 2022 20:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244589AbiEDAWj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 May 2022 20:22:39 -0400
Received: from mail-ua1-x949.google.com (mail-ua1-x949.google.com [IPv6:2607:f8b0:4864:20::949])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95B433A6
        for <linux-fscrypt@vger.kernel.org>; Tue,  3 May 2022 17:18:56 -0700 (PDT)
Received: by mail-ua1-x949.google.com with SMTP id o7-20020ab01e87000000b00362757f955aso8179423uak.15
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 May 2022 17:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=olYeAtrc6EQj6KrfY1m842AYmJybX3PxvNqvKN4NOv4=;
        b=JS/q/7hfOfj42rJzLg+hPvK4dJUS09lFHEuu3JKXlovGBkyq4HmZGGxMpvG/1HfnCz
         Murai27PgzmVY2JdFmeCjAQmEQkE1CO19sO1d8NL5M33p6zYTEChvRdURllg/Epyn/x3
         x0aokGD9tH9tIlRmRpYFKT7bL1WTtc0q0LzMLQQL0JLtyDnyvMdZdUh3nDGUnX16ghZW
         otWGptBzFWdqTkwl0Ida7m11JxLDAr4GacNd7uGog8lWloffH84rUk6piDNKfYUeIPl3
         UX3XjGaVJknBOR+jfx39xccFAR96jhpIFA05x6mg9WPsuduoZjQqpxk0wQ0naahKS+w9
         OeUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=olYeAtrc6EQj6KrfY1m842AYmJybX3PxvNqvKN4NOv4=;
        b=xCMcFawyHXVEJmDYSUEOZiiiJM5RlyVpZKik7CC789ZqNsA/+t2CQCjxxQqinoxb7h
         dc1dKgM8WgtgSMHDRBIHIruwiLgW57B0Oi/uVfn/aN2PX2GsG6uGWlViTz9s5X5SlVcn
         FTOFBMG1zgnhCR0SxZXjKh003p/+geKNYmB7ArNWP3UcV9O6KIeMF/0tivIiGe4izCSZ
         7TEqJPhoS95LmqmH+9PKrmL4f2Gc3F2UZZcSNKmLBj0h3vF9kX5CpyanWGd0pkt0gOtL
         fG3hbkbyi8sY4VCdLRhpOLhI22pukM1CrYKDI8H9LJBqSPab+fewvZ0DDJzEWmwzus+N
         FkIw==
X-Gm-Message-State: AOAM533gTxZZh2YMZ417T3TBeEmkbQGVSDuOXsRq708zQxef+lWn5Wsw
        1M1dr+SnELuCOsExm2XJeR3yPfDhbA==
X-Google-Smtp-Source: ABdhPJyfyenwCc/DxNfUtgBrrG6kP7wfCBp63o1CIij8LHcog1I2yEJ0tazM9T6tSy1yXCrCV0ZWr2sChg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6102:3091:b0:32d:204b:d489 with SMTP id
 l17-20020a056102309100b0032d204bd489mr3682347vsb.4.1651623535398; Tue, 03 May
 2022 17:18:55 -0700 (PDT)
Date:   Wed,  4 May 2022 00:18:23 +0000
In-Reply-To: <20220504001823.2483834-1-nhuck@google.com>
Message-Id: <20220504001823.2483834-10-nhuck@google.com>
Mime-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 9/9] fscrypt: Add HCTR2 support for filename encryption
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

HCTR2 is a tweakable, length-preserving encryption mode that is intended
for use on CPUs with dedicated crypto instructions.  HCTR2 has the
property that a bitflip in the plaintext changes the entire ciphertext.
This property fixes a known weakness with filename encryption: when two
filenames in the same directory share a prefix of >= 16 bytes, with
AES-CTS-CBC their encrypted filenames share a common substring, leaking
information.  HCTR2 does not have this problem.

More information on HCTR2 can be found here: "Length-preserving
encryption with HCTR2": https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 22 +++++++++++++++++-----
 fs/crypto/fscrypt_private.h           |  2 +-
 fs/crypto/keysetup.c                  |  7 +++++++
 fs/crypto/policy.c                    | 14 +++++++++++---
 include/uapi/linux/fscrypt.h          |  3 ++-
 5 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4d5d50dca65c..324149c58bf3 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -337,6 +337,7 @@ Currently, the following pairs of encryption modes are supported:
 - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
 - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
 - Adiantum for both contents and filenames
+- AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
 
 If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 
@@ -357,6 +358,17 @@ To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
 implementations of ChaCha and NHPoly1305 should be enabled, e.g.
 CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
 
+AES-256-HCTR2 is another true wide-block encryption mode that is intended for
+use on CPUs with dedicated crypto instructions.  AES-256-HCTR2 has the property
+that a bitflip in the plaintext changes the entire ciphertext.  This property
+makes it desirable for filename encryption since initialization vectors are
+reused within a directory.  For more details on AES-256-HCTR2, see the paper
+"Length-preserving encryption with HCTR2"
+(https://eprint.iacr.org/2021/1441.pdf).  To use AES-256-HCTR2,
+CONFIG_CRYPTO_HCTR2 must be enabled.  Also, fast implementations of XCTR and
+POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
+CRYPTO_AES_ARM64_CE_BLK for ARM64.
+
 New encryption modes can be added relatively easily, without changes
 to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
@@ -404,11 +416,11 @@ alternatively has the file's nonce (for `DIRECT_KEY policies`_) or
 inode number (for `IV_INO_LBLK_64 policies`_) included in the IVs.
 Thus, IV reuse is limited to within a single directory.
 
-With CTS-CBC, the IV reuse means that when the plaintext filenames
-share a common prefix at least as long as the cipher block size (16
-bytes for AES), the corresponding encrypted filenames will also share
-a common prefix.  This is undesirable.  Adiantum does not have this
-weakness, as it is a wide-block encryption mode.
+With CTS-CBC, the IV reuse means that when the plaintext filenames share a
+common prefix at least as long as the cipher block size (16 bytes for AES), the
+corresponding encrypted filenames will also share a common prefix.  This is
+undesirable.  Adiantum and HCTR2 do not have this weakness, as they are
+wide-block encryption modes.
 
 All supported filenames encryption modes accept any plaintext length
 >= 16 bytes; cipher block alignment is not required.  However,
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5b0a9e6478b5..d8617d01f7bd 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -31,7 +31,7 @@
 #define FSCRYPT_CONTEXT_V2	2
 
 /* Keep this in sync with include/uapi/linux/fscrypt.h */
-#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_ADIANTUM
+#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
 
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index eede186b04ce..ba463eb931de 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -53,6 +53,13 @@ struct fscrypt_mode fscrypt_modes[] = {
 		.ivsize = 32,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_ADIANTUM,
 	},
+	[FSCRYPT_MODE_AES_256_HCTR2] = {
+		.friendly_name = "AES-256-HCTR2",
+		.cipher_str = "hctr2(aes)",
+		.keysize = 32,
+		.security_strength = 32,
+		.ivsize = 32,
+	},
 };
 
 static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed3d623724cd..5dea7b655a64 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -40,7 +40,7 @@ fscrypt_get_dummy_policy(struct super_block *sb)
 	return sb->s_cop->get_dummy_policy(sb);
 }
 
-static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
+static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
 {
 	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
 	    filenames_mode == FSCRYPT_MODE_AES_256_CTS)
@@ -57,6 +57,14 @@ static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
 	return false;
 }
 
+static bool fscrypt_valid_enc_modes_v2(u32 contents_mode, u32 filenames_mode)
+{
+	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
+	    filenames_mode == FSCRYPT_MODE_AES_256_HCTR2)
+		return true;
+	return fscrypt_valid_enc_modes_v1(contents_mode, filenames_mode);
+}
+
 static bool supported_direct_key_modes(const struct inode *inode,
 				       u32 contents_mode, u32 filenames_mode)
 {
@@ -130,7 +138,7 @@ static bool supported_iv_ino_lblk_policy(const struct fscrypt_policy_v2 *policy,
 static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
 					const struct inode *inode)
 {
-	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+	if (!fscrypt_valid_enc_modes_v1(policy->contents_encryption_mode,
 				     policy->filenames_encryption_mode)) {
 		fscrypt_warn(inode,
 			     "Unsupported encryption modes (contents %d, filenames %d)",
@@ -166,7 +174,7 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 {
 	int count = 0;
 
-	if (!fscrypt_valid_enc_modes(policy->contents_encryption_mode,
+	if (!fscrypt_valid_enc_modes_v2(policy->contents_encryption_mode,
 				     policy->filenames_encryption_mode)) {
 		fscrypt_warn(inode,
 			     "Unsupported encryption modes (contents %d, filenames %d)",
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 9f4428be3e36..a756b29afcc2 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -27,7 +27,8 @@
 #define FSCRYPT_MODE_AES_128_CBC		5
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_ADIANTUM			9
-/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
+#define FSCRYPT_MODE_AES_256_HCTR2		10
+/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
-- 
2.36.0.464.gb9c8b46e94-goog

