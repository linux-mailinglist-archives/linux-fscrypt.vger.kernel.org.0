Return-Path: <linux-fscrypt+bounces-182-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0B78622C1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Feb 2024 06:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43841C2196B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Feb 2024 05:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB7F79F4;
	Sat, 24 Feb 2024 05:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pq0IRw35"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B202563
	for <linux-fscrypt@vger.kernel.org>; Sat, 24 Feb 2024 05:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708753006; cv=none; b=ivh8vAgf8pWpvADlQ0idNXa27ZN6Q87KETUeBnNOyX6XDjIZzUSlPT9w/kodFPdoyOpDjK554ud/llF4TEQ70pdg7GNqKWUmjMovh3lBe3r/X1cA2gYBsZlnkZDng5UDz6zEmbACiVa938J2zG6iSL4lFYunIBKu0MW/VVCpR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708753006; c=relaxed/simple;
	bh=ZbH5E5m2BeGzD4qGtIHEm0AXKI0QzfKofEbF8ywnfjw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GDNO8GsjO/ur6VvY7FugQ2Zx6SjPRvl4ogWsD6MWf0ypgMyF3cuh01Dm7OHNVs2pahNH/+Kl2c6g+Q7Hxx5DweHLg/m5KLFYKYMf/lK1Z6hHsYrX1Jpk+ian7giYb63SJIfgAdnD4PT5KdDNWYVylBAjhqnFYWaI+vCc+fkoXwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pq0IRw35; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7E9C433C7
	for <linux-fscrypt@vger.kernel.org>; Sat, 24 Feb 2024 05:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708753005;
	bh=ZbH5E5m2BeGzD4qGtIHEm0AXKI0QzfKofEbF8ywnfjw=;
	h=From:To:Subject:Date:From;
	b=Pq0IRw35n7DPxVcwae4xQnjofL11tKcL7zzyXXucQ7uJ5wL921op0S/9fO5IIY461
	 UDwv6FplnV8o7mldPdnqyK6jVBgAEtSCxNIVN1puWwE+Iuz8qlN7GS3P25eF3fRI2C
	 IyQJ0p+6zVYGFHFdk6vF560oOcUjtMQOEnLdFYzHgq8Q8IAFFTETBj9Q65TY9e5HtZ
	 3OwKsQnFBo+72t5LsDESYvhe7TcjqaA+5aQe6TYvWmqq0j0Z6HnaJCRYyq14ldYM3L
	 43oXaJmVs3ABVs3WoPuf3a9JTTs2brfud7zcPdkfs11Bu8odx2BqoLlq2Whu3/fWH9
	 8n5559Y5CWHIg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: write CBC-CTS instead of CTS-CBC
Date: Fri, 23 Feb 2024 21:35:49 -0800
Message-ID: <20240224053550.44659-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Calling CBC with ciphertext stealing "CBC-CTS" seems to be more common
than calling it "CTS-CBC".  E.g., CBC-CTS is used by OpenSSL, Crypto++,
RFC3962, and RFC6803.  The NIST SP800-38A addendum uses CBC-CS1,
CBC-CS2, and CBC-CS3, distinguishing between different CTS conventions
but similarly putting the CBC part first.  In the interest of avoiding
any idiosyncratic terminology, update the fscrypt documentation and the
fscrypt_mode "friendly names" to align with the more common convention.

Changing the "friendly names" only affects some log messages.  The
actual mode constants in the API are unchanged; those call it simply
"CTS".  Add a note to the documentation that clarifies that "CBC" and
"CTS" in the API really mean CBC-ESSIV and CBC-CTS, respectively.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 27 +++++++++++++++------------
 fs/crypto/keysetup.c                  |  6 +++---
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index e86b886b64d0e..04eaab01314bc 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -331,90 +331,93 @@ Encryption modes and usage
 
 fscrypt allows one encryption mode to be specified for file contents
 and one encryption mode to be specified for filenames.  Different
 directory trees are permitted to use different encryption modes.
 
 Supported modes
 ---------------
 
 Currently, the following pairs of encryption modes are supported:
 
-- AES-256-XTS for contents and AES-256-CTS-CBC for filenames
+- AES-256-XTS for contents and AES-256-CBC-CTS for filenames
 - AES-256-XTS for contents and AES-256-HCTR2 for filenames
 - Adiantum for both contents and filenames
-- AES-128-CBC-ESSIV for contents and AES-128-CTS-CBC for filenames
-- SM4-XTS for contents and SM4-CTS-CBC for filenames
+- AES-128-CBC-ESSIV for contents and AES-128-CBC-CTS for filenames
+- SM4-XTS for contents and SM4-CBC-CTS for filenames
+
+Note: in the API, "CBC" means CBC-ESSIV, and "CTS" means CBC-CTS.
+So, for example, FSCRYPT_MODE_AES_256_CTS means AES-256-CBC-CTS.
 
 Authenticated encryption modes are not currently supported because of
 the difficulty of dealing with ciphertext expansion.  Therefore,
 contents encryption uses a block cipher in `XTS mode
 <https://en.wikipedia.org/wiki/Disk_encryption_theory#XTS>`_ or
 `CBC-ESSIV mode
 <https://en.wikipedia.org/wiki/Disk_encryption_theory#Encrypted_salt-sector_initialization_vector_(ESSIV)>`_,
 or a wide-block cipher.  Filenames encryption uses a
-block cipher in `CTS-CBC mode
+block cipher in `CBC-CTS mode
 <https://en.wikipedia.org/wiki/Ciphertext_stealing>`_ or a wide-block
 cipher.
 
-The (AES-256-XTS, AES-256-CTS-CBC) pair is the recommended default.
+The (AES-256-XTS, AES-256-CBC-CTS) pair is the recommended default.
 It is also the only option that is *guaranteed* to always be supported
 if the kernel supports fscrypt at all; see `Kernel config options`_.
 
 The (AES-256-XTS, AES-256-HCTR2) pair is also a good choice that
 upgrades the filenames encryption to use a wide-block cipher.  (A
 *wide-block cipher*, also called a tweakable super-pseudorandom
 permutation, has the property that changing one bit scrambles the
 entire result.)  As described in `Filenames encryption`_, a wide-block
-cipher is the ideal mode for the problem domain, though CTS-CBC is the
+cipher is the ideal mode for the problem domain, though CBC-CTS is the
 "least bad" choice among the alternatives.  For more information about
 HCTR2, see `the HCTR2 paper <https://eprint.iacr.org/2021/1441.pdf>`_.
 
 Adiantum is recommended on systems where AES is too slow due to lack
 of hardware acceleration for AES.  Adiantum is a wide-block cipher
 that uses XChaCha12 and AES-256 as its underlying components.  Most of
 the work is done by XChaCha12, which is much faster than AES when AES
 acceleration is unavailable.  For more information about Adiantum, see
 `the Adiantum paper <https://eprint.iacr.org/2018/720.pdf>`_.
 
-The (AES-128-CBC-ESSIV, AES-128-CTS-CBC) pair exists only to support
+The (AES-128-CBC-ESSIV, AES-128-CBC-CTS) pair exists only to support
 systems whose only form of AES acceleration is an off-CPU crypto
 accelerator such as CAAM or CESA that does not support XTS.
 
 The remaining mode pairs are the "national pride ciphers":
 
-- (SM4-XTS, SM4-CTS-CBC)
+- (SM4-XTS, SM4-CBC-CTS)
 
 Generally speaking, these ciphers aren't "bad" per se, but they
 receive limited security review compared to the usual choices such as
 AES and ChaCha.  They also don't bring much new to the table.  It is
 suggested to only use these ciphers where their use is mandated.
 
 Kernel config options
 ---------------------
 
 Enabling fscrypt support (CONFIG_FS_ENCRYPTION) automatically pulls in
 only the basic support from the crypto API needed to use AES-256-XTS
-and AES-256-CTS-CBC encryption.  For optimal performance, it is
+and AES-256-CBC-CTS encryption.  For optimal performance, it is
 strongly recommended to also enable any available platform-specific
 kconfig options that provide acceleration for the algorithm(s) you
 wish to use.  Support for any "non-default" encryption modes typically
 requires extra kconfig options as well.
 
 Below, some relevant options are listed by encryption mode.  Note,
 acceleration options not listed below may be available for your
 platform; refer to the kconfig menus.  File contents encryption can
 also be configured to use inline encryption hardware instead of the
 kernel crypto API (see `Inline encryption support`_); in that case,
 the file contents mode doesn't need to supported in the kernel crypto
 API, but the filenames mode still does.
 
-- AES-256-XTS and AES-256-CTS-CBC
+- AES-256-XTS and AES-256-CBC-CTS
     - Recommended:
         - arm64: CONFIG_CRYPTO_AES_ARM64_CE_BLK
         - x86: CONFIG_CRYPTO_AES_NI_INTEL
 
 - AES-256-HCTR2
     - Mandatory:
         - CONFIG_CRYPTO_HCTR2
     - Recommended:
         - arm64: CONFIG_CRYPTO_AES_ARM64_CE_BLK
         - arm64: CONFIG_CRYPTO_POLYVAL_ARM64_CE
@@ -426,21 +429,21 @@ API, but the filenames mode still does.
         - CONFIG_CRYPTO_ADIANTUM
     - Recommended:
         - arm32: CONFIG_CRYPTO_CHACHA20_NEON
         - arm32: CONFIG_CRYPTO_NHPOLY1305_NEON
         - arm64: CONFIG_CRYPTO_CHACHA20_NEON
         - arm64: CONFIG_CRYPTO_NHPOLY1305_NEON
         - x86: CONFIG_CRYPTO_CHACHA20_X86_64
         - x86: CONFIG_CRYPTO_NHPOLY1305_SSE2
         - x86: CONFIG_CRYPTO_NHPOLY1305_AVX2
 
-- AES-128-CBC-ESSIV and AES-128-CTS-CBC:
+- AES-128-CBC-ESSIV and AES-128-CBC-CTS:
     - Mandatory:
         - CONFIG_CRYPTO_ESSIV
         - CONFIG_CRYPTO_SHA256 or another SHA-256 implementation
     - Recommended:
         - AES-CBC acceleration
 
 fscrypt also uses HMAC-SHA512 for key derivation, so enabling SHA-512
 acceleration is recommended:
 
 - SHA-512
@@ -514,21 +517,21 @@ Filenames encryption
 For filenames, each full filename is encrypted at once.  Because of
 the requirements to retain support for efficient directory lookups and
 filenames of up to 255 bytes, the same IV is used for every filename
 in a directory.
 
 However, each encrypted directory still uses a unique key, or
 alternatively has the file's nonce (for `DIRECT_KEY policies`_) or
 inode number (for `IV_INO_LBLK_64 policies`_) included in the IVs.
 Thus, IV reuse is limited to within a single directory.
 
-With CTS-CBC, the IV reuse means that when the plaintext filenames share a
+With CBC-CTS, the IV reuse means that when the plaintext filenames share a
 common prefix at least as long as the cipher block size (16 bytes for AES), the
 corresponding encrypted filenames will also share a common prefix.  This is
 undesirable.  Adiantum and HCTR2 do not have this weakness, as they are
 wide-block encryption modes.
 
 All supported filenames encryption modes accept any plaintext length
 >= 16 bytes; cipher block alignment is not required.  However,
 filenames shorter than 16 bytes are NUL-padded to 16 bytes before
 being encrypted.  In addition, to reduce leakage of filename lengths
 via their ciphertexts, all filenames are NUL-padded to the next 4, 8,
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 9a0a40c81bf29..b4fe01ea4bd4c 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -16,51 +16,51 @@
 struct fscrypt_mode fscrypt_modes[] = {
 	[FSCRYPT_MODE_AES_256_XTS] = {
 		.friendly_name = "AES-256-XTS",
 		.cipher_str = "xts(aes)",
 		.keysize = 64,
 		.security_strength = 32,
 		.ivsize = 16,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_AES_256_XTS,
 	},
 	[FSCRYPT_MODE_AES_256_CTS] = {
-		.friendly_name = "AES-256-CTS-CBC",
+		.friendly_name = "AES-256-CBC-CTS",
 		.cipher_str = "cts(cbc(aes))",
 		.keysize = 32,
 		.security_strength = 32,
 		.ivsize = 16,
 	},
 	[FSCRYPT_MODE_AES_128_CBC] = {
 		.friendly_name = "AES-128-CBC-ESSIV",
 		.cipher_str = "essiv(cbc(aes),sha256)",
 		.keysize = 16,
 		.security_strength = 16,
 		.ivsize = 16,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	},
 	[FSCRYPT_MODE_AES_128_CTS] = {
-		.friendly_name = "AES-128-CTS-CBC",
+		.friendly_name = "AES-128-CBC-CTS",
 		.cipher_str = "cts(cbc(aes))",
 		.keysize = 16,
 		.security_strength = 16,
 		.ivsize = 16,
 	},
 	[FSCRYPT_MODE_SM4_XTS] = {
 		.friendly_name = "SM4-XTS",
 		.cipher_str = "xts(sm4)",
 		.keysize = 32,
 		.security_strength = 16,
 		.ivsize = 16,
 		.blk_crypto_mode = BLK_ENCRYPTION_MODE_SM4_XTS,
 	},
 	[FSCRYPT_MODE_SM4_CTS] = {
-		.friendly_name = "SM4-CTS-CBC",
+		.friendly_name = "SM4-CBC-CTS",
 		.cipher_str = "cts(cbc(sm4))",
 		.keysize = 16,
 		.security_strength = 16,
 		.ivsize = 16,
 	},
 	[FSCRYPT_MODE_ADIANTUM] = {
 		.friendly_name = "Adiantum",
 		.cipher_str = "adiantum(xchacha12,aes)",
 		.keysize = 32,
 		.security_strength = 32,

base-commit: d3a7bd4200762d11c33ebe7e2c47c5813ddc65b4
-- 
2.43.2


