Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA2074354B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 08:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjF3GtF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 30 Jun 2023 02:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjF3Gs7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 30 Jun 2023 02:48:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3842E30F6;
        Thu, 29 Jun 2023 23:48:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD390616D2;
        Fri, 30 Jun 2023 06:48:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00052C433C9;
        Fri, 30 Jun 2023 06:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688107736;
        bh=DfWuOBR9K4rvCO7QX3b8VowNL+xIbvXG7I8WafSQ+v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krUDSGCcPBsiWXAUcwpPB702MfeaQafZy/5jlqBGSC0P8nXwCpzRokDdVsBUHjA5E
         p9beHQW7pFU65LsgzVHZDB2ucN6nQaxeyG4MomxZM7xI6TkZecjeIuiMEMkrnNLYq2
         bTsUKCTTf4pgDXGNLxEkwr5yo9IqdNN4Pt6vcuETlOu6QpfzoGbtdiObSojXGoVUgW
         b8vuRpKCes9kjiNg8BcAb5KQ4p/Q2A6GkE6R70dx/oQKAXX14J/0OMQ7uIcR7fJ4iI
         /VBp5JiGUlSIcewDz6fNaK/CdTPaLw5Z/j1mXK0qK1AR8er8e1YtwU0YuK8oGGjywQ
         kaxj+YFJVUsRA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org, Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH 1/2] fscrypt: improve the "Encryption modes and usage" section
Date:   Thu, 29 Jun 2023 23:48:10 -0700
Message-ID: <20230630064811.22569-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630064811.22569-1-ebiggers@kernel.org>
References: <20230630064811.22569-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As the number of supported encryption modes has grown, the part of the
"Encryption modes and usage" section that describes the supported
encryption modes has gotten a bit messy.  It presents useful
information, but it's a bit lacking in high-level context.

Rework the section to hopefully be much more useful.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 164 +++++++++++++++++++-------
 1 file changed, 119 insertions(+), 45 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index eccd327e6df50..a624e92f2687f 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -332,54 +332,121 @@ Encryption modes and usage
 fscrypt allows one encryption mode to be specified for file contents
 and one encryption mode to be specified for filenames.  Different
 directory trees are permitted to use different encryption modes.
+
+Supported modes
+---------------
+
 Currently, the following pairs of encryption modes are supported:
 
 - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
-- AES-128-CBC for contents and AES-128-CTS-CBC for filenames
+- AES-256-XTS for contents and AES-256-HCTR2 for filenames
 - Adiantum for both contents and filenames
-- AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
-- SM4-XTS for contents and SM4-CTS-CBC for filenames (v2 policies only)
-
-If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
-
-AES-128-CBC was added only for low-powered embedded devices with
-crypto accelerators such as CAAM or CESA that do not support XTS.  To
-use AES-128-CBC, CONFIG_CRYPTO_ESSIV and CONFIG_CRYPTO_SHA256 (or
-another SHA-256 implementation) must be enabled so that ESSIV can be
-used.
-
-Adiantum is a (primarily) stream cipher-based mode that is fast even
-on CPUs without dedicated crypto instructions.  It's also a true
-wide-block mode, unlike XTS.  It can also eliminate the need to derive
-per-file encryption keys.  However, it depends on the security of two
-primitives, XChaCha12 and AES-256, rather than just one.  See the
-paper "Adiantum: length-preserving encryption for entry-level
-processors" (https://eprint.iacr.org/2018/720.pdf) for more details.
-To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
-implementations of ChaCha and NHPoly1305 should be enabled, e.g.
-CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
-
-AES-256-HCTR2 is another true wide-block encryption mode that is intended for
-use on CPUs with dedicated crypto instructions.  AES-256-HCTR2 has the property
-that a bitflip in the plaintext changes the entire ciphertext.  This property
-makes it desirable for filename encryption since initialization vectors are
-reused within a directory.  For more details on AES-256-HCTR2, see the paper
-"Length-preserving encryption with HCTR2"
-(https://eprint.iacr.org/2021/1441.pdf).  To use AES-256-HCTR2,
-CONFIG_CRYPTO_HCTR2 must be enabled.  Also, fast implementations of XCTR and
-POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
-CRYPTO_AES_ARM64_CE_BLK for ARM64.
-
-SM4 is a Chinese block cipher that is an alternative to AES.  It has
-not seen as much security review as AES, and it only has a 128-bit key
-size.  It may be useful in cases where its use is mandated.
-Otherwise, it should not be used.  For SM4 support to be available, it
-also needs to be enabled in the kernel crypto API.
-
-New encryption modes can be added relatively easily, without changes
-to individual filesystems.  However, authenticated encryption (AE)
-modes are not currently supported because of the difficulty of dealing
-with ciphertext expansion.
+- AES-128-CBC-ESSIV for contents and AES-128-CTS-CBC for filenames
+- SM4-XTS for contents and SM4-CTS-CBC for filenames
+
+Authenticated encryption modes are not currently supported because of
+the difficulty of dealing with ciphertext expansion.  Therefore,
+contents encryption uses a block cipher in `XTS mode
+<https://en.wikipedia.org/wiki/Disk_encryption_theory#XTS>`_ or
+`CBC-ESSIV mode
+<https://en.wikipedia.org/wiki/Disk_encryption_theory#Encrypted_salt-sector_initialization_vector_(ESSIV)>`_,
+or a wide-block cipher.  Filenames encryption uses a
+block cipher in `CTS-CBC mode
+<https://en.wikipedia.org/wiki/Ciphertext_stealing>`_ or a wide-block
+cipher.
+
+The (AES-256-XTS, AES-256-CTS-CBC) pair is the recommended default.
+It is also the only option that is *guaranteed* to always be supported
+if the kernel supports fscrypt at all; see `Kernel config options`_.
+
+The (AES-256-XTS, AES-256-HCTR2) pair is also a good choice that
+upgrades the filenames encryption to use a wide-block cipher.  (A
+*wide-block cipher*, also called a tweakable super-pseudorandom
+permutation, has the property that changing one bit scrambles the
+entire result.)  As described in `Filenames encryption`_, a wide-block
+cipher is the ideal mode for the problem domain, though CTS-CBC is the
+"least bad" choice among the alternatives.  For more information about
+HCTR2, see `the HCTR2 paper <https://eprint.iacr.org/2021/1441.pdf>`_.
+
+Adiantum is recommended on systems where AES is too slow due to lack
+of hardware acceleration for AES.  Adiantum is a wide-block cipher
+that uses XChaCha12 and AES-256 as its underlying components.  Most of
+the work is done by XChaCha12, which is much faster than AES when AES
+acceleration is unavailable.  For more information about Adiantum, see
+`the Adiantum paper <https://eprint.iacr.org/2018/720.pdf>`_.
+
+The (AES-128-CBC-ESSIV, AES-128-CTS-CBC) pair exists only to support
+systems whose only form of AES acceleration is an off-CPU crypto
+accelerator such as CAAM or CESA that does not support XTS.
+
+The remaining mode pairs are the "national pride ciphers":
+
+- (SM4-XTS, SM4-CTS-CBC)
+
+Generally speaking, these ciphers aren't "bad" per se, but they
+receive limited security review compared to the usual choices such as
+AES and ChaCha.  They also don't bring much new to the table.  It is
+suggested to only use these ciphers where their use is mandated.
+
+Kernel config options
+---------------------
+
+Enabling fscrypt support (CONFIG_FS_ENCRYPTION) automatically pulls in
+only the basic support from the crypto API needed to use AES-256-XTS
+and AES-256-CTS-CBC encryption.  For optimal performance, it is
+strongly recommended to also enable any available platform-specific
+kconfig options that provide acceleration for the algorithm(s) you
+wish to use.  Support for any "non-default" encryption modes typically
+requires extra kconfig options as well.
+
+Below, some relevant options are listed by encryption mode.  Note,
+acceleration options not listed below may be available for your
+platform; refer to the kconfig menus.  File contents encryption can
+also be configured to use inline encryption hardware instead of the
+kernel crypto API (see `Inline encryption support`_); in that case,
+the file contents mode doesn't need to supported in the kernel crypto
+API, but the filenames mode still does.
+
+- AES-256-XTS and AES-256-CTS-CBC
+    - Recommended:
+        - arm64: CONFIG_CRYPTO_AES_ARM64_CE_BLK
+        - x86: CONFIG_CRYPTO_AES_NI_INTEL
+
+- AES-256-HCTR2
+    - Mandatory:
+        - CONFIG_CRYPTO_HCTR2
+    - Recommended:
+        - arm64: CONFIG_CRYPTO_AES_ARM64_CE_BLK
+        - arm64: CONFIG_CRYPTO_POLYVAL_ARM64_CE
+        - x86: CONFIG_CRYPTO_AES_NI_INTEL
+        - x86: CONFIG_CRYPTO_POLYVAL_CLMUL_NI
+
+- Adiantum
+    - Mandatory:
+        - CONFIG_CRYPTO_ADIANTUM
+    - Recommended:
+        - arm32: CONFIG_CRYPTO_CHACHA20_NEON
+        - arm32: CONFIG_CRYPTO_NHPOLY1305_NEON
+        - arm64: CONFIG_CRYPTO_CHACHA20_NEON
+        - arm64: CONFIG_CRYPTO_NHPOLY1305_NEON
+        - x86: CONFIG_CRYPTO_CHACHA20_X86_64
+        - x86: CONFIG_CRYPTO_NHPOLY1305_SSE2
+        - x86: CONFIG_CRYPTO_NHPOLY1305_AVX2
+
+- AES-128-CBC-ESSIV and AES-128-CTS-CBC:
+    - Mandatory:
+        - CONFIG_CRYPTO_ESSIV
+        - CONFIG_CRYPTO_SHA256 or another SHA-256 implementation
+    - Recommended:
+        - AES-CBC acceleration
+
+fscrypt also uses HMAC-SHA512 for key derivation, so enabling SHA-512
+acceleration is recommended:
+
+- SHA-512
+    - Recommended:
+        - arm64: CONFIG_CRYPTO_SHA512_ARM64_CE
+        - x86: CONFIG_CRYPTO_SHA512_SSSE3
 
 Contents encryption
 -------------------
@@ -493,7 +560,14 @@ This structure must be initialized as follows:
   be set to constants from ``<linux/fscrypt.h>`` which identify the
   encryption modes to use.  If unsure, use FSCRYPT_MODE_AES_256_XTS
   (1) for ``contents_encryption_mode`` and FSCRYPT_MODE_AES_256_CTS
-  (4) for ``filenames_encryption_mode``.
+  (4) for ``filenames_encryption_mode``.  For details, see `Encryption
+  modes and usage`_.
+
+  v1 encryption policies only support three combinations of modes:
+  (FSCRYPT_MODE_AES_256_XTS, FSCRYPT_MODE_AES_256_CTS),
+  (FSCRYPT_MODE_AES_128_CBC, FSCRYPT_MODE_AES_128_CTS), and
+  (FSCRYPT_MODE_ADIANTUM, FSCRYPT_MODE_ADIANTUM).  v2 policies support
+  all combinations documented in `Supported modes`_.
 
 - ``flags`` contains optional flags from ``<linux/fscrypt.h>``:
 
-- 
2.41.0

