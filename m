Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08169362526
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Apr 2021 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbhDPQHT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Apr 2021 12:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239183AbhDPQHS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Apr 2021 12:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050AD613B0;
        Fri, 16 Apr 2021 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618589213;
        bh=BuDdLNq+a5myEjWt3+SxtbuydJd0suwiIyzOBikPkl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOhJfHCTtCe99iZ3wPALnl12b6A/uZm/nNGox6+085bkTyCIxbYK38XjtHoLayGmn
         /ubPHCRi925fzGb/Jb6xrL0j1WsfEs7KDrqCtuCVwRJnJnspKq85v42djSkq3GlwQ/
         6q1ydHfTYbiSYGaz5w97F+muhyOF7BQjdTfhPc27b36dEk9MBtNhrWiLqfuCAQI3p8
         yUZy1sN4ZY2MMl1fd71CZ43AtFdIILDmpQTQG2Wayr2kfA5IZIKtx1+xXiBPgwydNw
         P4g9bvhbdCe+M695HuC9yxmtfOJ9FUOsP44dHLxYKx4+2ikFFXAgcPkOJbxIaLs4xy
         68wLOJBSosJSg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] fscrypt: relax Kconfig dependencies for crypto API algorithms
Date:   Fri, 16 Apr 2021 18:06:41 +0200
Message-Id: <20210416160642.85387-2-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416160642.85387-1-ardb@kernel.org>
References: <20210416160642.85387-1-ardb@kernel.org>
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
 fs/crypto/Kconfig | 23 ++++++++++++++------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index a5f5c30368a2..1e6c11de95c8 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -17,13 +17,22 @@ config FS_ENCRYPTION
 # allows the algorithms to be built as modules when all the filesystems are.
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
+	help
+	  This pulls in the generic implementations of the various
+	  cryptographic algorithms and chaining modes that filesystem
+	  encryption relies on. These are 'soft' dependencies only, as
+	  architectures may supersede these generic implementations with
+	  special, optimized ones.
+
+	  If unsure, keep the generic algorithms enabled, as they can
+	  happily co-exist with per-architecture implementations.
 
 config FS_ENCRYPTION_INLINE_CRYPT
 	bool "Enable fscrypt to use inline crypto"
-- 
2.30.2

