Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80E04D734
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 20:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfFTSQb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 14:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbfFTSQ3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5183321530;
        Thu, 20 Jun 2019 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054588;
        bh=ZgL7RNKXSblp2oixF+/qvJrVmS/y9fhBZL7l1Ufqj/M=;
        h=From:To:Cc:Subject:Date:From;
        b=JjgOG+VU35d+Z/vZCBkqaqH2XCB/GjV/aXYz3yVpFFNPxGzXUJkH47O+wvsXlnoiS
         garaUEkSexVwPOq0/9BoaYve1/jzNY7xETbwstc+JnZfpxKl9QF1Ta7DoTfwhyB1kD
         DMoUzPr8+U9ALNwX0hQ7KPzvJKoEa5o2gNPh7mk8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] fscrypt: remove selection of CONFIG_CRYPTO_SHA256
Date:   Thu, 20 Jun 2019 11:15:05 -0700
Message-Id: <20190620181505.225232-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt only uses SHA-256 for AES-128-CBC-ESSIV, which isn't the default
and is only recommended on platforms that have hardware accelerated
AES-CBC but not AES-XTS.  There's no link-time dependency, since SHA-256
is requested via the crypto API on first use.

To reduce bloat, we should limit FS_ENCRYPTION to selecting the default
algorithms only.  SHA-256 by itself isn't that much bloat, but it's
being discussed to move ESSIV into a crypto API template, which would
incidentally bring in other things like "authenc" support, which would
all end up being built-in since FS_ENCRYPTION is now a bool.

For Adiantum encryption we already just document that users who want to
use it have to enable CONFIG_CRYPTO_ADIANTUM themselves.  So, let's do
the same for AES-128-CBC-ESSIV and CONFIG_CRYPTO_SHA256.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 4 +++-
 fs/crypto/Kconfig                     | 1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 08c23b60e01647..87d4e266ffc86d 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -191,7 +191,9 @@ Currently, the following pairs of encryption modes are supported:
 If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
 
 AES-128-CBC was added only for low-powered embedded devices with
-crypto accelerators such as CAAM or CESA that do not support XTS.
+crypto accelerators such as CAAM or CESA that do not support XTS.  To
+use AES-128-CBC, CONFIG_CRYPTO_SHA256 (or another SHA-256
+implementation) must be enabled so that ESSIV can be used.
 
 Adiantum is a (primarily) stream cipher-based mode that is fast even
 on CPUs without dedicated crypto instructions.  It's also a true
diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 24ed99e2eca0b2..5fdf24877c1785 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -7,7 +7,6 @@ config FS_ENCRYPTION
 	select CRYPTO_ECB
 	select CRYPTO_XTS
 	select CRYPTO_CTS
-	select CRYPTO_SHA256
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
-- 
2.22.0.410.gd8fdbe21b5-goog

