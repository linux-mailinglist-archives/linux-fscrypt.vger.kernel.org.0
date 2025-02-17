Return-Path: <linux-fscrypt+bounces-611-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84286A38B98
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 19:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53CA4188E40B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Feb 2025 18:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F1922A1EC;
	Mon, 17 Feb 2025 18:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BYImHYQi"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A8225A32;
	Mon, 17 Feb 2025 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739818424; cv=none; b=Eh3gsDptsIcbbuAuiaLE+RV+r4vpf4DZI948dVHDlYYEKC+D9/GQM4ejy32FPpdm7b2ghXJ3HzPnRQ/wvW4prRareuVW3XwB7bl7viewfxd5/6z6c7uQQjJTxOT3FyXDE8UuKCThO4GnZ8fytZMGZNb/McJ+HcVlp2KV8nhDHrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739818424; c=relaxed/simple;
	bh=zlrdpP846LMHypmFUMqPSXpXcnB4rfCjrDX4w7yfJng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OpNktWKaXMIHg+k6wDFQrII0BtGda29Fve6TYi8FFnLkA53LcdnRVfBB0wIDbckP5BkBjA9Z+SX7kib+doiWgZNuJPcByY6Q/7qw2MCx5HDagLZy5JGzHCSpTSwH+A6guVN3Mx+W6F8yRQ3p2YFhMX6AWpAoffrOFazxbwdgzNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BYImHYQi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98536C4CED1;
	Mon, 17 Feb 2025 18:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739818423;
	bh=zlrdpP846LMHypmFUMqPSXpXcnB4rfCjrDX4w7yfJng=;
	h=From:To:Cc:Subject:Date:From;
	b=BYImHYQiCMk7/T0E8Jr40xVLwMHi5Fwf1nrcVsdv0OrDF4bdPkYOAVi0Sc0CmXWnz
	 kgeaRkTUAT6hEpcjvZc3+jXEML1ALCngHDf/YMZhY1DvMNu3sEyiQHLMfG2fqSKkXc
	 J6v8MT1Tbn5GRaUQdYg2i7+iCrUkO1f9uMKfCg76bgVt5F0GJfUm/iqR8gO68Mf9UH
	 PULB+YRQ7K2MJmBjnZhnK7Disd+adiKxQonYr35si08Pj1dDhobGbVHEvnZhEP4Jn8
	 oJ/ycJmgE5IC8ykGIb07KIhgHfFjLDHsdPMWEj3KecbIyGUmg+IeEwcK7rrEq1T4NC
	 FQTx8AlV3w2Iw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] Revert "fscrypt: relax Kconfig dependencies for crypto API algorithms"
Date: Mon, 17 Feb 2025 10:53:14 -0800
Message-ID: <20250217185314.27345-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This mostly reverts commit a0fc20333ee4bac1147c4cf75dea098c26671a2f.
Keep the relevant parts of the comment added by that commit.

The problem with that commit is that it allowed people to create broken
configurations that enabled FS_ENCRYPTION but not the mandatory
algorithms.  An example of this can be found here:
https://lore.kernel.org/r/1207325.1737387826@warthog.procyon.org.uk/

The commit did allow people to disable specific generic algorithm
implementations that aren't needed.  But that at best allowed saving a
bit of code.  In the real world people are unlikely to intentionally and
correctly make such a tweak anyway, as they tend to just be confused by
what all the different crypto kconfig options mean.

Of course we really need the crypto API to enable the correct
implementations automatically, but that's for a later fix.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/Kconfig | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 5aff5934baa12..332d828fe6fa5 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -22,24 +22,20 @@ config FS_ENCRYPTION
 # as Adiantum encryption, then those other modes need to be explicitly enabled
 # in the crypto API; see Documentation/filesystems/fscrypt.rst for details.
 #
 # Also note that this option only pulls in the generic implementations of the
 # algorithms, not any per-architecture optimized implementations.  It is
-# strongly recommended to enable optimized implementations too.  It is safe to
-# disable these generic implementations if corresponding optimized
-# implementations will always be available too; for this reason, these are soft
-# dependencies ('imply' rather than 'select').  Only disable these generic
-# implementations if you're sure they will never be needed, though.
+# strongly recommended to enable optimized implementations too.
 config FS_ENCRYPTION_ALGS
 	tristate
-	imply CRYPTO_AES
-	imply CRYPTO_CBC
-	imply CRYPTO_CTS
-	imply CRYPTO_ECB
-	imply CRYPTO_HMAC
-	imply CRYPTO_SHA512
-	imply CRYPTO_XTS
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_CTS
+	select CRYPTO_ECB
+	select CRYPTO_HMAC
+	select CRYPTO_SHA512
+	select CRYPTO_XTS
 
 config FS_ENCRYPTION_INLINE_CRYPT
 	bool "Enable fscrypt to use inline crypto"
 	depends on FS_ENCRYPTION && BLK_INLINE_ENCRYPTION
 	help

base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.48.1


