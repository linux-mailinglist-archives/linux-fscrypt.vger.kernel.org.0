Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDDD36668D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 21 Apr 2021 09:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbhDUHz5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 21 Apr 2021 03:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:54764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235107AbhDUHzy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 21 Apr 2021 03:55:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F6E761438;
        Wed, 21 Apr 2021 07:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618991720;
        bh=9wo1DQLdtI3MuzZYxymV2WhK5mxjl2O3K1NxVhptqfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GL+4S18dnKDLGfuGPTaV/mn/Ndh1H0XCUa13oQ74/pkRdtNzZFJHrpdyUFEQt4gWJ
         yrH5n1k8Wo5YZkq5TYEmkagDFk10qcqf3Lsv9drNTEsTzUKvHjlIGaWBq9dQ9Cj22O
         LpXwG906Hc4ARA9eUBquK9E4mAI3KgnhVVGRMf3T4XuAcPcwimY57JwtSkKqQJoc48
         0jTL8NoW1uiBR0KIv792vUDHeABSk3N3+yLrV6im5GlaR+KKcQMrrXpDiYQS9zUh8/
         aGrVNy07viqtuJZHgg2z7jrHMLV0N0cOYQdmftOcm3QODn0xJ+71FeK8NYKkaORdb9
         cE9aM/6k+PdeQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/2] fscrypt: relax Kconfig dependencies for crypto API algorithms
Date:   Wed, 21 Apr 2021 09:55:10 +0200
Message-Id: <20210421075511.45321-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421075511.45321-1-ardb@kernel.org>
References: <20210421075511.45321-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Even if FS encryption has strict functional dependencies on various
crypto algorithms and chaining modes. those dependencies could potentially
be satisified by other implementations than the generic ones, and no link
time dependency exists on the 'depends on' claused defined by
CONFIG_FS_ENCRYPTION_ALGS.

So let's relax these clauses to 'imply', so that the default behavior
is still to pull in those generic algorithms, but in a way that permits
them to be disabled again in Kconfig.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 fs/crypto/Kconfig | 30 ++++++++++++++------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index a5f5c30368a2..2d0c8922f635 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -14,16 +14,30 @@ config FS_ENCRYPTION
 	  F2FS and UBIFS make use of this feature.
 
 # Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
-# allows the algorithms to be built as modules when all the filesystems are.
+# allows the algorithms to be built as modules when all the filesystems are,
+# whereas selecting them from FS_ENCRYPTION would force them to be built-in.
+#
+# Note: this option only pulls in the algorithms that filesystem encryption
+# needs "by default".  If userspace will use "non-default" encryption modes such
+# as Adiantum encryption, then those other modes need to be explicitly enabled
+# in the crypto API; see Documentation/filesystems/fscrypt.rst for details.
+#
+# Also note that this option only pulls in the generic implementations of the
+# algorithms, not any per-architecture optimized implementations.  It is
+# strongly recommended to enable optimized implementations too.  It is safe to
+# disable these generic implementations if corresponding optimized
+# implementations will always be available too; for this reason, these are soft
+# dependencies ('imply' rather than 'select').  Only disable these generic
+# implementations if you're sure they will never be needed, though.
 config FS_ENCRYPTION_ALGS
 	tristate
-	select CRYPTO_AES
-	select CRYPTO_CBC
-	select CRYPTO_CTS
-	select CRYPTO_ECB
-	select CRYPTO_HMAC
-	select CRYPTO_SHA512
-	select CRYPTO_XTS
+	imply CRYPTO_AES
+	imply CRYPTO_CBC
+	imply CRYPTO_CTS
+	imply CRYPTO_ECB
+	imply CRYPTO_HMAC
+	imply CRYPTO_SHA512
+	imply CRYPTO_XTS
 
 config FS_ENCRYPTION_INLINE_CRYPT
 	bool "Enable fscrypt to use inline crypto"
-- 
2.30.2

