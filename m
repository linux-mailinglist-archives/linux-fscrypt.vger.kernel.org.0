Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304F12B320A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Nov 2020 04:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKODPv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 Nov 2020 22:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:59278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbgKODPv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 Nov 2020 22:15:51 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE8920773;
        Sun, 15 Nov 2020 03:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605410150;
        bh=xLUPJemfVglpcrSPqXa8cTZsEYz0D/H4dKq7o72KZRw=;
        h=From:To:Cc:Subject:Date:From;
        b=nUgS+OqFttfmlbVybEV9+vrceADYBp/G7OjlU3MLJ9vVTY+oIzn3ek3UV02M3r3bO
         /lAWJY1vrjgsjw5FtDynn4og+nlo1me6ju3/US3P86AvXY1ypo2geDFpJivFxufhD6
         UEurLwjUKm9stgwpxxquae9gLcC9qfJpAyHEqhGs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [xfstests PATCH] fscrypt-crypt-util: fix maximum IV size
Date:   Sat, 14 Nov 2020 19:15:36 -0800
Message-Id: <20201115031536.1469955-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In commit 65cd8e8a8e81 ("fscrypt-crypt-util: fix IV incrementing for
--iv-ino-lblk-32") I mistakenly decreased the size of fscrypt_iv to 24
bytes, which is the most that is explicitly needed by any of the IV
generation methods.  However, Adiantum encryption takes a 32-byte IV, so
the buffer still needs to be 32 bytes, with any extra bytes zeroed.

So restore the size to 32 bytes.

This fixes a buffer overread that caused generic/550 and generic/584 to
sometimes fail, depending on the build of the fscrypt-crypt-util binary.
(Most of the time it still worked by chance.)

Fixes: 65cd8e8a8e81 ("fscrypt-crypt-util: fix IV incrementing for --iv-ino-lblk-32")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 26698d7a..03cc3c4a 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -1642,6 +1642,7 @@ static u64 siphash_1u64(const u64 key[2], u64 data)
 #define FILE_NONCE_SIZE		16
 #define UUID_SIZE		16
 #define MAX_KEY_SIZE		64
+#define MAX_IV_SIZE		ADIANTUM_IV_SIZE
 
 static const struct fscrypt_cipher {
 	const char *name;
@@ -1715,6 +1716,8 @@ union fscrypt_iv {
 		/* IV_INO_LBLK_64: inode number */
 		__le32 inode_number;
 	};
+	/* Any extra bytes up to the algorithm's IV size must be zeroed */
+	u8 bytes[MAX_IV_SIZE];
 };
 
 static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
@@ -1736,9 +1739,9 @@ static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
 		memset(&buf[res], 0, crypt_len - res);
 
 		if (decrypting)
-			cipher->decrypt(key, (u8 *)iv, buf, buf, crypt_len);
+			cipher->decrypt(key, iv->bytes, buf, buf, crypt_len);
 		else
-			cipher->encrypt(key, (u8 *)iv, buf, buf, crypt_len);
+			cipher->encrypt(key, iv->bytes, buf, buf, crypt_len);
 
 		full_write(STDOUT_FILENO, buf, crypt_len);
 
-- 
2.29.2

