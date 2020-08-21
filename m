Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D4424DF76
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgHUS2Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgHUS2S (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:18 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E92C23105;
        Fri, 21 Aug 2020 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034497;
        bh=SZwwaY4kzg1f2etJWydeWhfXiR5upplKAGhJlRtoNnA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XZEx2CU8YW4wKk63ME5WADq6CWBvbjBmFkOTe8PpqgHRKtCS88O5dUdndv9k3wOGW
         q2sX9fm1nPXkBa4Ycgomm5r4nzyNSQKLL4psiCDzWJT7WjdheAkYav18JRc59jnNZh
         zE1B96l7cBGPc2qp5dryrkYBrtNjIUjiT33MLljQ=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 05/14] lib: lift fscrypt base64 conversion into lib/
Date:   Fri, 21 Aug 2020 14:28:04 -0400
Message-Id: <20200821182813.52570-6-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Once we allow encrypted filenames we'll end up with names that may have
illegal characters in them (embedded '\0' or '/'), or characters that
aren't printable.

It'll be safer to use strings that are printable. It turns out that the
MDS doesn't really care about the length of filenames, so we can just
base64 encode and decode filenames before writing and reading them.

Lift the base64 implementation that's in fscrypt into lib/. Make fscrypt
select it when it's enabled.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/Kconfig      |  1 +
 fs/crypto/fname.c      | 59 +----------------------------------
 include/linux/base64.h | 11 +++++++
 lib/Kconfig            |  3 ++
 lib/Makefile           |  1 +
 lib/base64.c           | 71 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 88 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/base64.h
 create mode 100644 lib/base64.c

diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index a5f5c30368a2..49219017f7e9 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -6,6 +6,7 @@ config FS_ENCRYPTION
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_SHA256
 	select KEYS
+	select BASE64
 	help
 	  Enable encryption of files and directories.  This
 	  feature is similar to ecryptfs, but it is more memory
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 9440a44e24ac..6a6bbe8f8db7 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -11,6 +11,7 @@
  * This has not yet undergone a rigorous security audit.
  */
 
+#include <linux/base64.h>
 #include <linux/namei.h>
 #include <linux/scatterlist.h>
 #include <crypto/hash.h>
@@ -184,64 +185,6 @@ static int fname_decrypt(const struct inode *inode,
 	return 0;
 }
 
-static const char lookup_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
-
-#define BASE64_CHARS(nbytes)	DIV_ROUND_UP((nbytes) * 4, 3)
-
-/**
- * base64_encode() - base64-encode some bytes
- * @src: the bytes to encode
- * @len: number of bytes to encode
- * @dst: (output) the base64-encoded string.  Not NUL-terminated.
- *
- * Encodes the input string using characters from the set [A-Za-z0-9+,].
- * The encoded string is roughly 4/3 times the size of the input string.
- *
- * Return: length of the encoded string
- */
-static int base64_encode(const u8 *src, int len, char *dst)
-{
-	int i, bits = 0, ac = 0;
-	char *cp = dst;
-
-	for (i = 0; i < len; i++) {
-		ac += src[i] << bits;
-		bits += 8;
-		do {
-			*cp++ = lookup_table[ac & 0x3f];
-			ac >>= 6;
-			bits -= 6;
-		} while (bits >= 6);
-	}
-	if (bits)
-		*cp++ = lookup_table[ac & 0x3f];
-	return cp - dst;
-}
-
-static int base64_decode(const char *src, int len, u8 *dst)
-{
-	int i, bits = 0, ac = 0;
-	const char *p;
-	u8 *cp = dst;
-
-	for (i = 0; i < len; i++) {
-		p = strchr(lookup_table, src[i]);
-		if (p == NULL || src[i] == 0)
-			return -2;
-		ac += (p - lookup_table) << bits;
-		bits += 6;
-		if (bits >= 8) {
-			*cp++ = ac & 0xff;
-			ac >>= 8;
-			bits -= 8;
-		}
-	}
-	if (ac)
-		return -1;
-	return cp - dst;
-}
-
 bool fscrypt_fname_encrypted_size(const struct inode *inode, u32 orig_len,
 				  u32 max_len, u32 *encrypted_len_ret)
 {
diff --git a/include/linux/base64.h b/include/linux/base64.h
new file mode 100644
index 000000000000..bde7a936ed21
--- /dev/null
+++ b/include/linux/base64.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#ifndef _LIB_BASE64_H
+#define _LIB_BASE64_H
+#include <linux/types.h>
+
+#define BASE64_CHARS(nbytes)	DIV_ROUND_UP((nbytes) * 4, 3)
+
+int base64_encode(const u8 *src, int len, char *dst);
+int base64_decode(const char *src, int len, u8 *dst);
+#endif /* _LIB_BASE64_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index b4b98a03ff98..507e851d220b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -684,3 +684,6 @@ config GENERIC_LIB_UCMPDI2
 config PLDMFW
 	bool
 	default n
+
+config BASE64
+	tristate
diff --git a/lib/Makefile b/lib/Makefile
index e290fc5707ea..4d76755e609c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -166,6 +166,7 @@ obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
 obj-$(CONFIG_CRC8)	+= crc8.o
 obj-$(CONFIG_XXHASH)	+= xxhash.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
+obj-$(CONFIG_BASE64) += base64.o
 
 obj-$(CONFIG_842_COMPRESS) += 842/
 obj-$(CONFIG_842_DECOMPRESS) += 842/
diff --git a/lib/base64.c b/lib/base64.c
new file mode 100644
index 000000000000..5f1480da6559
--- /dev/null
+++ b/lib/base64.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64 encode/decode functions
+ *
+ * Originally lifted from fs/crypto/fname.c
+ *
+ * Copyright (C) 2015, Jaegeuk Kim
+ * Copyright (C) 2015, Eric Biggers
+ */
+
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/string.h>
+
+static const char lookup_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,";
+
+/**
+ * base64_encode() - base64-encode some bytes
+ * @src: the bytes to encode
+ * @len: number of bytes to encode
+ * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ *
+ * Encodes the input string using characters from the set [A-Za-z0-9+,].
+ * The encoded string is roughly 4/3 times the size of the input string.
+ *
+ * Return: length of the encoded string
+ */
+int base64_encode(const u8 *src, int len, char *dst)
+{
+	int i, bits = 0, ac = 0;
+	char *cp = dst;
+
+	for (i = 0; i < len; i++) {
+		ac += src[i] << bits;
+		bits += 8;
+		do {
+			*cp++ = lookup_table[ac & 0x3f];
+			ac >>= 6;
+			bits -= 6;
+		} while (bits >= 6);
+	}
+	if (bits)
+		*cp++ = lookup_table[ac & 0x3f];
+	return cp - dst;
+}
+EXPORT_SYMBOL(base64_encode);
+
+int base64_decode(const char *src, int len, u8 *dst)
+{
+	int i, bits = 0, ac = 0;
+	const char *p;
+	u8 *cp = dst;
+
+	for (i = 0; i < len; i++) {
+		p = strchr(lookup_table, src[i]);
+		if (p == NULL || src[i] == 0)
+			return -2;
+		ac += (p - lookup_table) << bits;
+		bits += 6;
+		if (bits >= 8) {
+			*cp++ = ac & 0xff;
+			ac >>= 8;
+			bits -= 8;
+		}
+	}
+	if (ac)
+		return -1;
+	return cp - dst;
+}
+EXPORT_SYMBOL(base64_decode);
-- 
2.26.2

