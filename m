Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82FC26D2D5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Sep 2020 06:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIQEyg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Sep 2020 00:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgIQEyg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Sep 2020 00:54:36 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93E58208DB
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Sep 2020 04:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600318474;
        bh=xh6MpZLe1WKu1iGwHIrS0NlAQt994hokvyvDrArEIt0=;
        h=From:To:Subject:Date:From;
        b=tDRyNBdgG+eF5Gz+nZKG+xfjYxI0M011wcp5PI/MHIptsn7LkrMElRPMVjr8nOgvj
         S5ROX7WdPy9MS/QfLFnJ6DBeroeoSJc6z7cQ4gIw+mdURf3QGPc/T8Xu3zCGX6wdIJ
         UsHAD8fSYvsPQBRwh8bNbKQ4SBcyxUjFF1chBntw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: use sha256() instead of open coding
Date:   Wed, 16 Sep 2020 21:53:41 -0700
Message-Id: <20200917045341.324996-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that there's a library function that calculates the SHA-256 digest
of a buffer in one step, use it instead of sha256_init() +
sha256_update() + sha256_final().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 47bcfddb278ba..89a05e33e1b3b 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -61,15 +61,6 @@ struct fscrypt_nokey_name {
  */
 #define FSCRYPT_NOKEY_NAME_MAX	offsetofend(struct fscrypt_nokey_name, sha256)
 
-static void fscrypt_do_sha256(const u8 *data, unsigned int data_len, u8 *result)
-{
-	struct sha256_state sctx;
-
-	sha256_init(&sctx);
-	sha256_update(&sctx, data, data_len);
-	sha256_final(&sctx, result);
-}
-
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 {
 	if (str->len == 1 && str->name[0] == '.')
@@ -366,9 +357,9 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 	} else {
 		memcpy(nokey_name.bytes, iname->name, sizeof(nokey_name.bytes));
 		/* Compute strong hash of remaining part of name. */
-		fscrypt_do_sha256(&iname->name[sizeof(nokey_name.bytes)],
-				  iname->len - sizeof(nokey_name.bytes),
-				  nokey_name.sha256);
+		sha256(&iname->name[sizeof(nokey_name.bytes)],
+		       iname->len - sizeof(nokey_name.bytes),
+		       nokey_name.sha256);
 		size = FSCRYPT_NOKEY_NAME_MAX;
 	}
 	oname->len = base64_encode((const u8 *)&nokey_name, size, oname->name);
@@ -496,7 +487,7 @@ bool fscrypt_match_name(const struct fscrypt_name *fname,
 {
 	const struct fscrypt_nokey_name *nokey_name =
 		(const void *)fname->crypto_buf.name;
-	u8 sha256[SHA256_DIGEST_SIZE];
+	u8 digest[SHA256_DIGEST_SIZE];
 
 	if (likely(fname->disk_name.name)) {
 		if (de_name_len != fname->disk_name.len)
@@ -507,9 +498,9 @@ bool fscrypt_match_name(const struct fscrypt_name *fname,
 		return false;
 	if (memcmp(de_name, nokey_name->bytes, sizeof(nokey_name->bytes)))
 		return false;
-	fscrypt_do_sha256(&de_name[sizeof(nokey_name->bytes)],
-			  de_name_len - sizeof(nokey_name->bytes), sha256);
-	return !memcmp(sha256, nokey_name->sha256, sizeof(sha256));
+	sha256(&de_name[sizeof(nokey_name->bytes)],
+	       de_name_len - sizeof(nokey_name->bytes), digest);
+	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
 }
 EXPORT_SYMBOL_GPL(fscrypt_match_name);
 
-- 
2.28.0

