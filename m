Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4206473A07
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 21:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390690AbfGXTqO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 15:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390683AbfGXTqN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 15:46:13 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C35022BE8
        for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jul 2019 19:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997572;
        bh=auDbzUjeVfLsgj7HCI00tYKOZQImsUQTeECfM7He64s=;
        h=From:To:Subject:Date:From;
        b=L2YJJ30pderfeF9onRGG7HqnjhtB10Zev4ZurgAPO1E2Ig57r8MIFGvB/yu16GIe5
         rsgzdR2U8U8Kir215lCInv8K9eyZpCfLSZGAIHVcinX70DlRaGOvTT+FwpqUeC4UsW
         Ng11ag02P0Ziw01IL9QJhA2hIakeQDs1WNHddUGk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: clean up base64 encoding/decoding
Date:   Wed, 24 Jul 2019 12:46:06 -0700
Message-Id: <20190724194606.40483-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Some minor cleanups for the code that base64 encodes and decodes
encrypted filenames and long name digests:

- Rename "digest_{encode,decode}()" => "base64_{encode,decode}()" since
  they are used for filenames too, not just for long name digests.
- Replace 'while' loops with more conventional 'for' loops.
- Use 'u8' for binary data.  Keep 'char' for string data.
- Fully constify the lookup table (pointer was not const).
- Improve comment.

No actual change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 00d150ff30332b..6f9daba991684e 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -127,44 +127,45 @@ static int fname_decrypt(struct inode *inode,
 	return 0;
 }
 
-static const char *lookup_table =
+static const char lookup_table[65] =
 	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
 
 #define BASE64_CHARS(nbytes)	DIV_ROUND_UP((nbytes) * 4, 3)
 
 /**
- * digest_encode() -
+ * base64_encode() -
  *
- * Encodes the input digest using characters from the set [a-zA-Z0-9_+].
+ * Encodes the input string using characters from the set [A-Za-z0-9+,].
  * The encoded string is roughly 4/3 times the size of the input string.
+ *
+ * Return: length of the encoded string
  */
-static int digest_encode(const char *src, int len, char *dst)
+static int base64_encode(const u8 *src, int len, char *dst)
 {
-	int i = 0, bits = 0, ac = 0;
+	int i, bits = 0, ac = 0;
 	char *cp = dst;
 
-	while (i < len) {
-		ac += (((unsigned char) src[i]) << bits);
+	for (i = 0; i < len; i++) {
+		ac += src[i] << bits;
 		bits += 8;
 		do {
 			*cp++ = lookup_table[ac & 0x3f];
 			ac >>= 6;
 			bits -= 6;
 		} while (bits >= 6);
-		i++;
 	}
 	if (bits)
 		*cp++ = lookup_table[ac & 0x3f];
 	return cp - dst;
 }
 
-static int digest_decode(const char *src, int len, char *dst)
+static int base64_decode(const char *src, int len, u8 *dst)
 {
-	int i = 0, bits = 0, ac = 0;
+	int i, bits = 0, ac = 0;
 	const char *p;
-	char *cp = dst;
+	u8 *cp = dst;
 
-	while (i < len) {
+	for (i = 0; i < len; i++) {
 		p = strchr(lookup_table, src[i]);
 		if (p == NULL || src[i] == 0)
 			return -2;
@@ -175,7 +176,6 @@ static int digest_decode(const char *src, int len, char *dst)
 			ac >>= 8;
 			bits -= 8;
 		}
-		i++;
 	}
 	if (ac)
 		return -1;
@@ -272,7 +272,7 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 		return fname_decrypt(inode, iname, oname);
 
 	if (iname->len <= FSCRYPT_FNAME_MAX_UNDIGESTED_SIZE) {
-		oname->len = digest_encode(iname->name, iname->len,
+		oname->len = base64_encode(iname->name, iname->len,
 					   oname->name);
 		return 0;
 	}
@@ -287,7 +287,7 @@ int fscrypt_fname_disk_to_usr(struct inode *inode,
 	       FSCRYPT_FNAME_DIGEST(iname->name, iname->len),
 	       FSCRYPT_FNAME_DIGEST_SIZE);
 	oname->name[0] = '_';
-	oname->len = 1 + digest_encode((const char *)&digested_name,
+	oname->len = 1 + base64_encode((const u8 *)&digested_name,
 				       sizeof(digested_name), oname->name + 1);
 	return 0;
 }
@@ -380,8 +380,8 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (fname->crypto_buf.name == NULL)
 		return -ENOMEM;
 
-	ret = digest_decode(iname->name + digested, iname->len - digested,
-				fname->crypto_buf.name);
+	ret = base64_decode(iname->name + digested, iname->len - digested,
+			    fname->crypto_buf.name);
 	if (ret < 0) {
 		ret = -ENOENT;
 		goto errout;
-- 
2.22.0.657.g960e92d24f-goog

