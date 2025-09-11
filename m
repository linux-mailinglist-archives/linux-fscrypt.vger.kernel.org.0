Return-Path: <linux-fscrypt+bounces-815-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE79FB52A49
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96AC2563A51
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7766627A47C;
	Thu, 11 Sep 2025 07:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="iEF0cQLV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F9B27A11B
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757576546; cv=none; b=YRapcXa4C1HL/wpJleBRAKrc+neEtWnV0qQKjY+rc4xP4g59O/0XeRaP7Ti0jP1dKPJIMFCBBi/75sjQTBKS3SSBXUVAp4M99VUz6y/g4nXv08fTUHFh+tsedueRihEiwGeeOcGnETdNIu7aFLHjyIf3WtA33d+xtVJIdXIMYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757576546; c=relaxed/simple;
	bh=DbBRKdVH+9Q89Q8i0n6xkt59hwQ6Vht8OFO/4eKnAYE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=miBXveKS2uvctI0UncUmhyHYXqYEteUu4CzXVVBmJttQ1tzVJowGZjR9Va6ATCOIihMh3BXT/9FwIxqKFzEPBpv5XSgX5HW5s7aQS3MttfCnclUjlvgzxhq2BYAb7VbIMTwv+2ZEn1rYWzJdVpwxpLvOddsZ/+iJd3/iq5oLfgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=iEF0cQLV; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24eb713b2dfso3442235ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757576543; x=1758181343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F67NXKwM5gojyeH+csfDMKkA7qAECq4psBmSZp1Issg=;
        b=iEF0cQLVPqyOtzBTxocRmOAEsBj9Xc3+l68oXNkBINDuaR7lCFLjbODIrGUCJX9W1w
         eJcAVy4UNp73b8Qc2FHUQVplWKF/VeRlIqBafyalptNMYsFJKeo0t7G2F/eMKUxzfIfl
         Nut4kSi8DCcQopdcF3ITHHzYGtybv4V7jsqul+IIbRzuKJUI408hma2+DHJmCmbWCrRU
         EMWGZrFwUr4E3Y68vODcL5rfrV21zRUck6wUOHrhy89olwSiPGYQUKJZ4o57mOur9dgg
         Rxrxz9yn77oVI7RNv9rJstBjDfFI/17CM3zd64xBbxd39ZbhwCVaNlMFzUNBouUsHGzk
         hdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757576543; x=1758181343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F67NXKwM5gojyeH+csfDMKkA7qAECq4psBmSZp1Issg=;
        b=IK3KBVWXlCuRqxbCiURpGRs2on8tjF2UueiIKLmbcwnvOPadnd/ofEgzGoovs9svmc
         AhZYvwUF6Cm28GGvU4MLecp8+ObR/OIQKmx+MLZBci9ipMaCViykOtoCRCoxpoLRMgpn
         XReicGn2FpqdxfVGKi5NOcfCoTi3qgHDv+xz6EBZJ8mP/d3SaF74f/twZXmY6g37gxju
         sDfyj8EAGUoDKBcr1NgIOp4d4TiJE9jwl++eflHZvDMphWvYBfTUIbUB75sY1C4PgQdI
         ONBXfbANFFUTDzCpG699T8Jp1RkZKDBUW9gXsyP3MTrNCZ17stvuOHQKpCtXt0Y3fe0r
         SHGg==
X-Forwarded-Encrypted: i=1; AJvYcCXfDB1qk979Cc+Mk9MEROSMxD3wO+2tUjzm93QZeIE6h14XOxvWubFXhCmOkK8vRaQBE9+lXmwcaH2GIeRa@vger.kernel.org
X-Gm-Message-State: AOJu0YwKXL2Z0mrNau3MlhfweSqFpcCYZPOijhIcRLqmdyDfVv/ZF4yL
	PZwc15kypsSHk52sUjJVv91UGDbz6vajTyghiHYPNcodPpyzIGtQKjD8bOnouwTN19Y=
X-Gm-Gg: ASbGnctR6kZXRRR1XtABhBlmTrTqQkDLelIx3VAB+wJ7x11WhnADRdhwxki8t2Au1St
	cnUKvvbAxtSP6JjBODy4KdPmY0g9NouagMVm/1Ew7O8q6/VoKGbRF6Er3NyBK6cTi2lNMZSypfp
	JEfa4+ohjMAyzBqTTBTyZ24QgkXuJuV/DMi44vDJgZL/n2SHMwYXo58jsVDeYdmMkJrwQRdagf7
	kWoaAWPDLI1VT99ixmaFJeMDfyW0AgHO+3kEaUU3bZ5IqG6WN05+aRNjdwm6ns5zl3wgwunUYHV
	4stcV6nD0DujnICjEdPRS5iV2aEf7ITKwXNRb7/9LjEEw7u9t1Wssy2WSkq+RPXYvuTW4eeHv0W
	8NK32CWX6zWrZxD7UEI+MpyTugeG4RNccVLfvdKqD2hG86JU=
X-Google-Smtp-Source: AGHT+IHpwQZR4pOG/m4IsGz46fLea1EeKJTzCL8WS3vqubstcq/YoLDI8C/oWhXYWGU773jLDfy7zQ==
X-Received: by 2002:a17:902:db0a:b0:250:1c22:e78 with SMTP id d9443c01a7336-2516d33bb3bmr251815775ad.1.1757576543202;
        Thu, 11 Sep 2025 00:42:23 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd6306eecsm1657905a91.15.2025.09.11.00.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:42:22 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	ebiggers@kernel.org,
	hch@lst.de,
	home7438072@gmail.com,
	idryomov@gmail.com,
	jaegeuk@kernel.org,
	kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	sagi@grimberg.me,
	tytso@mit.edu,
	visitorckw@gmail.com,
	xiubli@redhat.com
Subject: [PATCH v2 2/5] lib/base64: rework encoder/decoder with customizable support and update nvme-auth
Date: Thu, 11 Sep 2025 15:41:59 +0800
Message-Id: <20250911074159.656943-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework base64_encode() and base64_decode() with extended interfaces
that support custom 64-character tables and optional '=' padding.
This makes them flexible enough to cover both standard RFC4648 Base64
and non-standard variants such as base64url.

The encoder is redesigned to process input in 3-byte blocks, each
mapped directly into 4 output symbols. Base64 naturally encodes
24 bits of input as four 6-bit values, so operating on aligned
3-byte chunks matches the algorithm's structure. This block-based
approach eliminates the need for bit-by-bit streaming, reduces shifts,
masks, and loop iterations, and removes data-dependent branches from
the main loop. Only the final 1 or 2 leftover bytes are handled
separately according to the standard rules. As a result, the encoder
achieves ~2.8x speedup for small inputs (64B) and up to ~2.6x
speedup for larger inputs (1KB), while remaining fully RFC4648-compliant.

The decoder replaces strchr()-based lookups with direct table-indexed
mapping. It processes input in 4-character groups and supports both
padded and non-padded forms. Validation has been strengthened: illegal
characters and misplaced '=' padding now cause errors, preventing
silent data corruption.

These changes improve decoding performance by ~12-15x.

Benchmarks on x86_64 (Intel Core i7-10700 @ 2.90GHz, averaged
over 1000 runs, tested with KUnit):

Encode:
 - 64B input: avg ~90ns -> ~32ns  (~2.8x faster)
 - 1KB input: avg ~1332ns -> ~510ns  (~2.6x faster)

Decode:
 - 64B input: avg ~1530ns -> ~122ns   (~12.5x faster)
 - 1KB input: avg ~27726ns -> ~1859ns (~15x faster)

Update nvme-auth to use the reworked base64_encode() and base64_decode()
interfaces, which now require explicit padding and table parameters.
A static base64_table is defined to preserve RFC4648 standard encoding
with padding enabled, ensuring functional behavior remains unchanged.

While this is a mechanical update following the lib/base64 rework,
nvme-auth also benefits from the performance improvements in the new
encoder/decoder, achieving faster encode/decode without altering the
output format.

The reworked encoder and decoder unify Base64 handling across the kernel
with higher performance, stricter correctness, and flexibility to support
subsystem-specific variants.

Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 drivers/nvme/common/auth.c |   7 +-
 include/linux/base64.h     |   4 +-
 lib/base64.c               | 238 ++++++++++++++++++++++++++++---------
 3 files changed, 192 insertions(+), 57 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 91e273b89..4d57694f8 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -161,6 +161,9 @@ u32 nvme_auth_key_struct_size(u32 key_len)
 }
 EXPORT_SYMBOL_GPL(nvme_auth_key_struct_size);
 
+static const char base64_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
 struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 					      u8 key_hash)
 {
@@ -178,7 +181,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
-	key_len = base64_decode(secret, allocated_len, key->key);
+	key_len = base64_decode(secret, allocated_len, key->key, true, base64_table);
 	if (key_len < 0) {
 		pr_debug("base64 key decoding error %d\n",
 			 key_len);
@@ -663,7 +666,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 	if (ret)
 		goto out_free_digest;
 
-	ret = base64_encode(digest, digest_len, enc);
+	ret = base64_encode(digest, digest_len, enc, true, base64_table);
 	if (ret < hmac_len) {
 		ret = -ENOKEY;
 		goto out_free_digest;
diff --git a/include/linux/base64.h b/include/linux/base64.h
index 660d4cb1e..22351323d 100644
--- a/include/linux/base64.h
+++ b/include/linux/base64.h
@@ -10,7 +10,7 @@
 
 #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
 
-int base64_encode(const u8 *src, int len, char *dst);
-int base64_decode(const char *src, int len, u8 *dst);
+int base64_encode(const u8 *src, int len, char *dst, bool padding, const char *table);
+int base64_decode(const char *src, int len, u8 *dst, bool padding, const char *table);
 
 #endif /* _LINUX_BASE64_H */
diff --git a/lib/base64.c b/lib/base64.c
index 9416bded2..b2bd5dab5 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -15,104 +15,236 @@
 #include <linux/string.h>
 #include <linux/base64.h>
 
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+#define BASE64_6BIT_MASK      0x3f /* Mask to extract lowest 6 bits */
+#define BASE64_BITS_PER_BYTE  8
+#define BASE64_CHUNK_BITS     6
+
+/* Output-char-indexed shifts: for output chars 0,1,2,3 respectively */
+#define BASE64_SHIFT_OUT0	(BASE64_CHUNK_BITS * 3) /* 18 */
+#define BASE64_SHIFT_OUT1	(BASE64_CHUNK_BITS * 2) /* 12 */
+#define BASE64_SHIFT_OUT2	(BASE64_CHUNK_BITS * 1) /* 6  */
+/* OUT3 uses 0 shift and just masks with BASE64_6BIT_MASK */
+
+/* For extracting bytes from the 24-bit value (decode main loop) */
+#define BASE64_SHIFT_BYTE0        (BASE64_BITS_PER_BYTE * 2) /* 16 */
+#define BASE64_SHIFT_BYTE1        (BASE64_BITS_PER_BYTE * 1) /* 8  */
+
+/* Tail (no padding) shifts to extract bytes */
+#define BASE64_TAIL2_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 2) - BASE64_BITS_PER_BYTE)       /* 4  */
+#define BASE64_TAIL3_BYTE0_SHIFT  ((BASE64_CHUNK_BITS * 3) - BASE64_BITS_PER_BYTE)       /* 10 */
+#define BASE64_TAIL3_BYTE1_SHIFT  ((BASE64_CHUNK_BITS * 3) - (BASE64_BITS_PER_BYTE * 2)) /* 2  */
+
+/* Extra: masks for leftover validation (no padding) */
+#define BASE64_MASK(n) ({        \
+	unsigned int __n = (n);  \
+	__n ? ((1U << __n) - 1U) : 0U; \
+})
+#define BASE64_TAIL2_UNUSED_BITS  (BASE64_CHUNK_BITS * 2 - BASE64_BITS_PER_BYTE)     /* 4 */
+#define BASE64_TAIL3_UNUSED_BITS  (BASE64_CHUNK_BITS * 3 - BASE64_BITS_PER_BYTE * 2) /* 2 */
 
 static inline const char *find_chr(const char *base64_table, char ch)
 {
 	if ('A' <= ch && ch <= 'Z')
-		return base64_table + ch - 'A';
+		return base64_table + (ch - 'A');
 	if ('a' <= ch && ch <= 'z')
-		return base64_table + 26 + ch - 'a';
+		return base64_table + 26 + (ch - 'a');
 	if ('0' <= ch && ch <= '9')
-		return base64_table + 26 * 2 + ch - '0';
-	if (ch == base64_table[26 * 2 + 10])
-		return base64_table + 26 * 2 + 10;
-	if (ch == base64_table[26 * 2 + 10 + 1])
-		return base64_table + 26 * 2 + 10 + 1;
+		return base64_table + 52 + (ch - '0');
+	if (ch == base64_table[62])
+		return &base64_table[62];
+	if (ch == base64_table[63])
+		return &base64_table[63];
 	return NULL;
 }
 
 /**
- * base64_encode() - base64-encode some binary data
+ * base64_encode() - base64-encode with custom table and optional padding
  * @src: the binary data to encode
  * @srclen: the length of @src in bytes
- * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ * @dst: (output) the base64-encoded string. Not NUL-terminated.
+ * @padding: whether to append '=' characters so output length is a multiple of 4
+ * @table: 64-character encoding table to use (e.g. standard or URL-safe variant)
  *
- * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
- * by RFC 4648, including the  '='-padding.
+ * Encodes data using the given 64-character @table. If @padding is true,
+ * the output is padded with '=' as described in RFC 4648; otherwise padding
+ * is omitted. This allows generation of both standard and non-standard
+ * Base64 variants (e.g. URL-safe encoding).
  *
  * Return: the length of the resulting base64-encoded string in bytes.
  */
-int base64_encode(const u8 *src, int srclen, char *dst)
+int base64_encode(const u8 *src, int srclen, char *dst, bool padding, const char *table)
 {
 	u32 ac = 0;
-	int bits = 0;
-	int i;
 	char *cp = dst;
 
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
-	}
-	if (bits) {
-		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
-		bits -= 6;
+	while (srclen >= 3) {
+		ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2)) |
+			 ((u32)src[1] << (BASE64_BITS_PER_BYTE)) |
+			 (u32)src[2];
+
+		*cp++ = table[ac >> BASE64_SHIFT_OUT0];
+		*cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
+		*cp++ = table[(ac >> BASE64_SHIFT_OUT2) & BASE64_6BIT_MASK];
+		*cp++ = table[ac & BASE64_6BIT_MASK];
+
+		src += 3;
+		srclen -= 3;
 	}
-	while (bits < 0) {
-		*cp++ = '=';
-		bits += 2;
+
+	switch (srclen) {
+	case 2:
+		ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2)) |
+		     ((u32)src[1] << (BASE64_BITS_PER_BYTE));
+
+		*cp++ = table[ac >> BASE64_SHIFT_OUT0];
+		*cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
+		*cp++ = table[(ac >> BASE64_SHIFT_OUT2) & BASE64_6BIT_MASK];
+		if (padding)
+			*cp++ = '=';
+		break;
+	case 1:
+		ac = ((u32)src[0] << (BASE64_BITS_PER_BYTE * 2));
+		*cp++ = table[ac >> BASE64_SHIFT_OUT0];
+		*cp++ = table[(ac >> BASE64_SHIFT_OUT1) & BASE64_6BIT_MASK];
+		if (padding) {
+			*cp++ = '=';
+			*cp++ = '=';
+		}
+		break;
 	}
 	return cp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_encode);
 
 /**
- * base64_decode() - base64-decode a string
+ * base64_decode() - base64-decode with custom table and optional padding
  * @src: the string to decode.  Doesn't need to be NUL-terminated.
  * @srclen: the length of @src in bytes
  * @dst: (output) the decoded binary data
+ * @padding: when true, accept and handle '=' padding as per RFC 4648;
+ *           when false, '=' is treated as invalid
+ * @table: 64-character encoding table to use (e.g. standard or URL-safe variant)
  *
- * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
- * specified by RFC 4648, including the  '='-padding.
+ * Decodes a string using the given 64-character @table. If @padding is true,
+ * '=' padding is accepted as described in RFC 4648; otherwise '=' is
+ * treated as an error. This allows decoding of both standard and
+ * non-standard Base64 variants (e.g. URL-safe decoding).
  *
  * This implementation hasn't been optimized for performance.
  *
  * Return: the length of the resulting decoded binary data in bytes,
  *	   or -1 if the string isn't a valid base64 string.
  */
-int base64_decode(const char *src, int srclen, u8 *dst)
+static inline int base64_decode_table(char ch, const char *table)
+{
+	if (ch == '\0')
+		return -1;
+	const char *p = find_chr(table, ch);
+
+	return p ? (p - table) : -1;
+}
+
+static inline int decode_base64_block(const char *src, const char *table,
+				      int *input1, int *input2,
+				      int *input3, int *input4,
+				      bool padding)
+{
+	*input1 = base64_decode_table(src[0], table);
+	*input2 = base64_decode_table(src[1], table);
+	*input3 = base64_decode_table(src[2], table);
+	*input4 = base64_decode_table(src[3], table);
+
+	/* Return error if any base64 character is invalid */
+	if (*input1 < 0 || *input2 < 0 || (!padding && (*input3 < 0 || *input4 < 0)))
+		return -1;
+
+	/* Handle padding */
+	if (padding) {
+		if (*input3 < 0 && *input4 >= 0)
+			return -1;
+		if (*input3 < 0 && src[2] != '=')
+			return -1;
+		if (*input4 < 0 && src[3] != '=')
+			return -1;
+	}
+	return 0;
+}
+
+int base64_decode(const char *src, int srclen, u8 *dst, bool padding, const char *table)
 {
-	u32 ac = 0;
-	int bits = 0;
-	int i;
 	u8 *bp = dst;
+	int input1, input2, input3, input4;
+	u32 val;
 
-	for (i = 0; i < srclen; i++) {
-		const char *p = find_chr(base64_table, src[i]);
+	if (srclen == 0)
+		return 0;
 
-		if (src[i] == '=') {
-			ac = (ac << 6);
-			bits += 6;
-			if (bits >= 8)
-				bits -= 8;
-			continue;
+	/* Validate the input length for padding */
+	if (padding && (srclen & 0x03) != 0)
+		return -1;
+
+	while (srclen >= 4) {
+		/* Decode the next 4 characters */
+		if (decode_base64_block(src, table, &input1, &input2, &input3,
+					&input4, padding) < 0)
+			return -1;
+		if (padding && srclen > 4) {
+			if (input3 < 0 || input4 < 0)
+				return -1;
 		}
-		if (p == NULL || src[i] == 0)
+		val = ((u32)input1 << BASE64_SHIFT_OUT0) |
+		      ((u32)input2 << BASE64_SHIFT_OUT1) |
+		      ((u32)((input3 < 0) ? 0 : input3) << BASE64_SHIFT_OUT2) |
+		      (u32)((input4 < 0) ? 0 : input4);
+
+		*bp++ = (u8)(val >> BASE64_SHIFT_BYTE0);
+
+		if (input3 >= 0)
+			*bp++ = (u8)(val >> BASE64_SHIFT_BYTE1);
+		if (input4 >= 0)
+			*bp++ = (u8)val;
+
+		src += 4;
+		srclen -= 4;
+	}
+
+	/* Handle leftover characters when padding is not used */
+	if (!padding && srclen > 0) {
+		switch (srclen) {
+		case 2:
+			input1 = base64_decode_table(src[0], table);
+			input2 = base64_decode_table(src[1], table);
+			if (input1 < 0 || input2 < 0)
+				return -1;
+
+			val = ((u32)input1 << BASE64_CHUNK_BITS) | (u32)input2; /* 12 bits */
+			if (val & BASE64_MASK(BASE64_TAIL2_UNUSED_BITS))
+				return -1; /* low 4 bits must be zero */
+
+			*bp++ = (u8)(val >> BASE64_TAIL2_BYTE0_SHIFT);
+			break;
+		case 3:
+			input1 = base64_decode_table(src[0], table);
+			input2 = base64_decode_table(src[1], table);
+			input3 = base64_decode_table(src[2], table);
+			if (input1 < 0 || input2 < 0 || input3 < 0)
+				return -1;
+
+			val = ((u32)input1 << (BASE64_CHUNK_BITS * 2)) |
+			      ((u32)input2 << BASE64_CHUNK_BITS) |
+			      (u32)input3; /* 18 bits */
+
+			if (val & BASE64_MASK(BASE64_TAIL3_UNUSED_BITS))
+				return -1; /* low 2 bits must be zero */
+
+			*bp++ = (u8)(val >> BASE64_TAIL3_BYTE0_SHIFT);
+			*bp++ = (u8)((val >> BASE64_TAIL3_BYTE1_SHIFT) & 0xFF);
+			break;
+		default:
 			return -1;
-		ac = (ac << 6) | (p - base64_table);
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
 		}
 	}
-	if (ac & ((1 << bits) - 1))
-		return -1;
+
 	return bp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_decode);
-- 
2.34.1


