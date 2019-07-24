Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB06673D1E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 22:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388696AbfGXUO6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 16:14:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404354AbfGXTya (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:30 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003E922BED
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2019 19:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998069;
        bh=uuFfEUkdU87pS25GiUcJwLLrE556uweFxvGablA4ZV8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U3FzYtqQDvxAz+rIIsr90OwiBF1McNRIaOdo/OYStC2BWhS2Oj8NbXSiZz8D0ByQg
         4SwBNW/npPo/fCLU4Pk+eJR0Rdsuix58rMY/hwnMRF3je5xzADqrg78SzCJ3J+PtIG
         6Pg0d0PyYZrbXczVlD4UqSRRwQbn61f5tC52DnTE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 4/4] fscrypt: use ENOPKG when crypto API support missing
Date:   Wed, 24 Jul 2019 12:54:22 -0700
Message-Id: <20190724195422.42495-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
In-Reply-To: <20190724195422.42495-1-ebiggers@kernel.org>
References: <20190724195422.42495-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Return ENOPKG rather than ENOENT when trying to open a file that's
encrypted using algorithms not available in the kernel's crypto API.

This avoids an ambiguity, since ENOENT is also returned when the file
doesn't exist.

Note: this is the same approach I'm taking for fs-verity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyinfo.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index b75678587c3a85..2129943002335c 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -237,13 +237,14 @@ allocate_skcipher_for_mode(struct fscrypt_mode *mode, const u8 *raw_key,
 
 	tfm = crypto_alloc_skcipher(mode->cipher_str, 0, 0);
 	if (IS_ERR(tfm)) {
-		if (PTR_ERR(tfm) == -ENOENT)
+		if (PTR_ERR(tfm) == -ENOENT) {
 			fscrypt_warn(inode,
 				     "Missing crypto API support for %s (API name: \"%s\")",
 				     mode->friendly_name, mode->cipher_str);
-		else
-			fscrypt_err(inode, "Error allocating '%s' transform: %ld",
-				    mode->cipher_str, PTR_ERR(tfm));
+			return ERR_PTR(-ENOPKG);
+		}
+		fscrypt_err(inode, "Error allocating '%s' transform: %ld",
+			    mode->cipher_str, PTR_ERR(tfm));
 		return tfm;
 	}
 	if (unlikely(!mode->logged_impl_name)) {
@@ -389,13 +390,14 @@ static int derive_essiv_salt(const u8 *key, int keysize, u8 *salt)
 
 		tfm = crypto_alloc_shash("sha256", 0, 0);
 		if (IS_ERR(tfm)) {
-			if (PTR_ERR(tfm) == -ENOENT)
+			if (PTR_ERR(tfm) == -ENOENT) {
 				fscrypt_warn(NULL,
 					     "Missing crypto API support for SHA-256");
-			else
-				fscrypt_err(NULL,
-					    "Error allocating SHA-256 transform: %ld",
-					    PTR_ERR(tfm));
+				return -ENOPKG;
+			}
+			fscrypt_err(NULL,
+				    "Error allocating SHA-256 transform: %ld",
+				    PTR_ERR(tfm));
 			return PTR_ERR(tfm);
 		}
 		prev_tfm = cmpxchg(&essiv_hash_tfm, NULL, tfm);
-- 
2.22.0.657.g960e92d24f-goog

