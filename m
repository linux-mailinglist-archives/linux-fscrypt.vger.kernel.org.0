Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D793FA27C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Aug 2021 02:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhH1AkO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Aug 2021 20:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhH1AkL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Aug 2021 20:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5284E61002;
        Sat, 28 Aug 2021 00:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630111160;
        bh=l5Vpd8qLldhdLBsaeFFh7lJFqpH9UlBDOD+tHUaAoq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=phcI7TjRjCPVmm1t0Racj2Hj4xRqJBkMBJ8Ja4Zib7LVyD3j3omCYJjIpcz4j2QLw
         CPsGRQjeW2JhhQynhWFNZyUVxRufRtEIObyLEQ87Pe620KtX1bOHD6KduDHuH+TnEQ
         HNkyJKcHJmN+VBAV8G3ehTOcRr+QR28JqN9yun+AULkaKhPS23qxuiI7re0iBTjTKE
         Tl3fkVrzA4w778FlFa/fou2SvV7AUeUZU08lkhF1INu2b4i27EJVvcs3MfIsLUDJDI
         PIOQ8mPEyuqH04driyvxxDhYMpU5xGoWgNd0rS0ULl89LkECGgJzNEpqLh2MYnKBcd
         XtR08hXLHWsHA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [RFC PATCH 2/4] fscrypt: improve documentation for inline encryption
Date:   Fri, 27 Aug 2021 17:32:22 -0700
Message-Id: <20210828003224.33346-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210828003224.33346-1-ebiggers@kernel.org>
References: <20210828003224.33346-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently the fscrypt inline encryption support is documented in the
"Implementation details" section, and it doesn't go into much detail.
It's really more than just an "implementation detail" though, as there
is a user-facing mount option.  Also, hardware-wrapped key support (an
upcoming feature) will depend on inline encryption and will affect the
on-disk format; by definition that's not just an implementation detail.

Therefore, move this documentation into its own section and expand it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst |  2 +
 Documentation/filesystems/fscrypt.rst     | 73 +++++++++++++++++------
 2 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index dc141a7eab53c..5befd2d088719 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0
 
+.. _inline_encryption:
+
 =================
 Inline Encryption
 =================
diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 44b67ebd6e40d..d8bc2a005a738 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -77,11 +77,11 @@ Side-channel attacks
 
 fscrypt is only resistant to side-channel attacks, such as timing or
 electromagnetic attacks, to the extent that the underlying Linux
-Cryptographic API algorithms are.  If a vulnerable algorithm is used,
-such as a table-based implementation of AES, it may be possible for an
-attacker to mount a side channel attack against the online system.
-Side channel attacks may also be mounted against applications
-consuming decrypted data.
+Cryptographic API algorithms or inline encryption hardware are.  If a
+vulnerable algorithm is used, such as a table-based implementation of
+AES, it may be possible for an attacker to mount a side channel attack
+against the online system.  Side channel attacks may also be mounted
+against applications consuming decrypted data.
 
 Unauthorized file access
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -1140,6 +1140,50 @@ where applications may later write sensitive data.  It is recommended
 that systems implementing a form of "verified boot" take advantage of
 this by validating all top-level encryption policies prior to access.
 
+Inline encryption support
+=========================
+
+By default, fscrypt uses the kernel crypto API for all cryptographic
+operations (other than HKDF, which fscrypt partially implements
+itself).  The kernel crypto API supports hardware crypto accelerators,
+but only ones that work in the traditional way where all inputs and
+outputs (e.g. plaintexts and ciphertexts) are in memory.  fscrypt can
+take advantage of such hardware, but the traditional acceleration
+model isn't particularly efficient and fscrypt hasn't been optimized
+for it.
+
+Instead, many newer systems (especially mobile SoCs) have *inline
+encryption hardware* that can encrypt/decrypt data while it is on its
+way to/from the storage device.  Linux supports inline encryption
+through a set of extensions to the block layer called *blk-crypto*.
+blk-crypto allows filesystems to attach encryption contexts to bios
+(I/O requests) to specify how the data will be encrypted or decrypted
+in-line.  For more information about blk-crypto, see
+:ref:`Documentation/block/inline-encryption.rst <inline_encryption>`.
+
+On supported filesystems (currently ext4 and f2fs), fscrypt can use
+blk-crypto instead of the kernel crypto API to encrypt/decrypt file
+contents.  To enable this, set CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y in
+the kernel configuration, and specify the "inlinecrypt" mount option
+when mounting the filesystem.
+
+Note that the "inlinecrypt" mount option just specifies to use inline
+encryption when possible; it doesn't force its use.  fscrypt will
+still fall back to using the kernel crypto API on files where the
+inline encryption hardware doesn't have the needed crypto capabilities
+(e.g. support for the needed encryption algorithm and data unit size)
+and where blk-crypto-fallback is unusable.  (For blk-crypto-fallback
+to be usable, it must be enabled in the kernel configuration with
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK=y.)
+
+Currently fscrypt always uses the filesystem block size (which is
+usually 4096 bytes) as the data unit size.  Therefore, it can only use
+inline encryption hardware that supports that data unit size.
+
+Inline encryption doesn't affect the ciphertext or other aspects of
+the on-disk format, so users may freely switch back and forth between
+using "inlinecrypt" and not using "inlinecrypt".
+
 Implementation details
 ======================
 
@@ -1189,6 +1233,13 @@ keys`_ and `DIRECT_KEY policies`_.
 Data path changes
 -----------------
 
+When inline encryption is used, filesystems just need to associate
+encryption contexts with bios to specify how the block layer or the
+inline encryption hardware will encrypt/decrypt the file contents.
+
+When inline encryption isn't used, filesystems must encrypt/decrypt
+the file contents themselves, as described below:
+
 For the read path (->readpage()) of regular files, filesystems can
 read the ciphertext into the page cache and decrypt it in-place.  The
 page lock must be held until decryption has finished, to prevent the
@@ -1202,18 +1253,6 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
 buffers regardless of encryption.  Other filesystems, such as ext4 and
 F2FS, have to allocate bounce pages specially for encryption.
 
-Fscrypt is also able to use inline encryption hardware instead of the
-kernel crypto API for en/decryption of file contents.  When possible,
-and if directed to do so (by specifying the 'inlinecrypt' mount option
-for an ext4/F2FS filesystem), it adds encryption contexts to bios and
-uses blk-crypto to perform the en/decryption instead of making use of
-the above read/write path changes.  Of course, even if directed to
-make use of inline encryption, fscrypt will only be able to do so if
-either hardware inline encryption support is available for the
-selected encryption algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK
-is selected.  If neither is the case, fscrypt will fall back to using
-the above mentioned read/write path changes for en/decryption.
-
 Filename hashing and encoding
 -----------------------------
 
-- 
2.32.0

