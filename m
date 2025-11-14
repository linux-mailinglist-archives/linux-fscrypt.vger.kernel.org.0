Return-Path: <linux-fscrypt+bounces-958-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B5DDAC5B716
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 07:00:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 2922634DDF4
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CCF23C50F;
	Fri, 14 Nov 2025 06:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="gu25l7m6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03263207A09
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 06:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100054; cv=none; b=ZfmI6x96IWJkeDQoG6vWsN/6yMS6qL4uG9yKD+5cSj5Zs2cv4wgu4UM3+rHJvpQvmMXruFDfoWjx1LlD6s94Za0JCTXcOeyrmx5wlKa6p6+7n2ETyUhKXs0BcwwVYoVDVABF0HotdXJ41kMUVpDLBT85Ia2lP2K42AyW3PbOalU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100054; c=relaxed/simple;
	bh=RzLjsaWNfd3c5UqNh11NB/OA761QgAhvGHx5EwD+vbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GcA9qAs7FjfoU893SndoFVLScMmWdt5R+CZizc2PwFvmcCB7MVugIG/m4LvpVSPzgbsYgjsHVzUFBKmc3BuRQz/HLuCw9xNtfpvHeYXFGnF9GZT4G28ZpII6qwkrnFHsY73ez+1lSeEOXSzDBgJmjqLK5PB2oZno+Lwku03CM74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=gu25l7m6; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-298144fb9bcso17389005ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 22:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100052; x=1763704852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmGe/VGuYfrow1+cTg8GsPpK6vNwvcURmH5IbRl3Ggw=;
        b=gu25l7m6wt/Llha2kslgGi3+p77A0XG+lShFoQvGb29yJusoNW+ur1zlKyaEBuevqk
         iZZsT4sB0ZK4HV75//byHqL7LJp/q0eoHSMeaf7XM68UIsANqEFtpGPyotRS3Xm797q7
         d1nutPwaiabYWDlxJedY0LuYZ4TSMoI5QXekXVG5e0XQe6+vc3q03yGT73w285RStpNg
         zhWK0HnIBBvxPjK94AuQTkMRr5+XlUE1QZ3rZI7hP92nPeQhBvWwhRBx8et8X9QrAG2C
         i2CvOC8/5s58yPz4EbH/ZtM5E/aq7AFHAovOnxG0rvhlZz9sUUA8XyS2lgzeugGYiyHz
         4UqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100052; x=1763704852;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WmGe/VGuYfrow1+cTg8GsPpK6vNwvcURmH5IbRl3Ggw=;
        b=iIN8bZdtWKnHTAFFowThg/ACgr7agsnxglFf8f5PBI+icDe0sOzClGhKIHiZtQCTT9
         RYbszGSu/vm6tWzcWSKN02R/nmf4NexDFXo+iFGh45BbO81J0Yb8whZ2rwULhOkxwVWt
         SMl8xWONMG/+IgzEVHR5g+bIosF6S3SWDvdKKZx2IMYbVo7F0VHtxdn2I6kB9HvaJpSB
         +3x0yrgpHRhsq7PI9TAaeqewrcylJgR6HHs6yaZTZ5eNrlApDCDIjCwdTgudqYpvR3lp
         FI+b+WAP8lmLiodPRgUeFTL4yCL85LKEymFBH/EcUYVrQb1DWnQ9eyhRpKPJ1cxLJR7o
         HDHw==
X-Forwarded-Encrypted: i=1; AJvYcCX4HMG6Mf4mavJvFtSdZ/bVHBS7dm+tUUUZOhM1nX5HbX6GywwiWypX/+GLub1HzUfFhGCEntezIuMjVxnT@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+rElAkwKQm2wjK+kUrlVvoE1bbvtIvzBeLzJFKfONE6RcNYtC
	pnEdfqV6hUOGpLF3ktxhnv3aAhxB5lD2aRGJUmLe92YrRJScqFgIS31eG7CtVjf6Qf4=
X-Gm-Gg: ASbGnctL2sL4sGeg5qRTO+g7K/Ud5BNOqWtOr9V3YAY1QgRrEOlm5hnGZZcxMC7ApSH
	QOABPJbXNwEQNd2IX7WtDG2fg9xKu0mvhe2HTE3b8zTcQrnjvc8PNRhzekpU39rO0eFU+A+3FmU
	5GVHcKUuZg/w5VDPMVv06SE67G0RglfT87JhnaVvul4moh0Wzw9xCH7tfMP2yniSJoNbCLkEqTT
	Q4IRIr10SfeYsMlg8UErjhbJjMzdR/pv/x6NjaCtVzA6TP2pxsomMnR+A9d+t5vcnr4Y0xmk2NZ
	JM8lOnWJhmQdvJTzuHNYjHuCmSobT2yrAIcwnL3gkYb8nUo/2mNzPrsbFfZyc1DC1EBOE/n+UD1
	nVF87Ee16p0zTJAK0Hfzaehqo3FTMbtTN9/HJWjt/XMPvdYx5uuEHO6weGuWV6HJQJ7VzbQiSn+
	nX37z8QjEm3a/zahSh0WEoUCfg
X-Google-Smtp-Source: AGHT+IE7lHXKbSg0FY2N6GECOYDuJxXFgUxUajs+hyWaWoZbadwsoEmHcwEF6EJwnMXpyL4EQeUVcA==
X-Received: by 2002:a17:903:2f0e:b0:298:485d:5571 with SMTP id d9443c01a7336-2986a75f1f6mr19001495ad.54.1763100052199;
        Thu, 13 Nov 2025 22:00:52 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e07b4b23sm7858577a91.13.2025.11.13.22.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:00:51 -0800 (PST)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: 409411716@gms.tku.edu.tw
Cc: akpm@linux-foundation.org,
	andriy.shevchenko@intel.com,
	axboe@kernel.dk,
	ceph-devel@vger.kernel.org,
	david.laight.linux@gmail.com,
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
Subject: [PATCH v5 1/6] lib/base64: Add support for multiple variants
Date: Fri, 14 Nov 2025 14:00:45 +0800
Message-Id: <20251114060045.88792-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kuan-Wei Chiu <visitorckw@gmail.com>

Extend the base64 API to support multiple variants (standard, URL-safe,
and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes a
variant parameter and an option to control padding. Update NVMe auth
code to use the new interface with BASE64_STD.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 drivers/nvme/common/auth.c |  4 +--
 include/linux/base64.h     | 10 ++++--
 lib/base64.c               | 62 ++++++++++++++++++++++----------------
 3 files changed, 46 insertions(+), 30 deletions(-)

diff --git a/drivers/nvme/common/auth.c b/drivers/nvme/common/auth.c
index 1f51fbebd9fa..e07e7d4bf8b6 100644
--- a/drivers/nvme/common/auth.c
+++ b/drivers/nvme/common/auth.c
@@ -178,7 +178,7 @@ struct nvme_dhchap_key *nvme_auth_extract_key(unsigned char *secret,
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
-	key_len = base64_decode(secret, allocated_len, key->key);
+	key_len = base64_decode(secret, allocated_len, key->key, true, BASE64_STD);
 	if (key_len < 0) {
 		pr_debug("base64 key decoding error %d\n",
 			 key_len);
@@ -663,7 +663,7 @@ int nvme_auth_generate_digest(u8 hmac_id, u8 *psk, size_t psk_len,
 	if (ret)
 		goto out_free_digest;
 
-	ret = base64_encode(digest, digest_len, enc);
+	ret = base64_encode(digest, digest_len, enc, true, BASE64_STD);
 	if (ret < hmac_len) {
 		ret = -ENOKEY;
 		goto out_free_digest;
diff --git a/include/linux/base64.h b/include/linux/base64.h
index 660d4cb1ef31..a2c6c9222da3 100644
--- a/include/linux/base64.h
+++ b/include/linux/base64.h
@@ -8,9 +8,15 @@
 
 #include <linux/types.h>
 
+enum base64_variant {
+	BASE64_STD,       /* RFC 4648 (standard) */
+	BASE64_URLSAFE,   /* RFC 4648 (base64url) */
+	BASE64_IMAP,      /* RFC 3501 */
+};
+
 #define BASE64_CHARS(nbytes)   DIV_ROUND_UP((nbytes) * 4, 3)
 
-int base64_encode(const u8 *src, int len, char *dst);
-int base64_decode(const char *src, int len, u8 *dst);
+int base64_encode(const u8 *src, int len, char *dst, bool padding, enum base64_variant variant);
+int base64_decode(const char *src, int len, u8 *dst, bool padding, enum base64_variant variant);
 
 #endif /* _LINUX_BASE64_H */
diff --git a/lib/base64.c b/lib/base64.c
index b736a7a431c5..a7c20a8e8e98 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * base64.c - RFC4648-compliant base64 encoding
+ * base64.c - Base64 with support for multiple variants
  *
  * Copyright (c) 2020 Hannes Reinecke, SUSE
  *
  * Based on the base64url routines from fs/crypto/fname.c
- * (which are using the URL-safe base64 encoding),
- * modified to use the standard coding table from RFC4648 section 4.
+ * (which are using the URL-safe Base64 encoding),
+ * modified to support multiple Base64 variants.
  */
 
 #include <linux/kernel.h>
@@ -15,26 +15,31 @@
 #include <linux/string.h>
 #include <linux/base64.h>
 
-static const char base64_table[65] =
-	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+static const char base64_tables[][65] = {
+	[BASE64_STD] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
+	[BASE64_URLSAFE] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_",
+	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
+};
 
 /**
- * base64_encode() - base64-encode some binary data
+ * base64_encode() - Base64-encode some binary data
  * @src: the binary data to encode
  * @srclen: the length of @src in bytes
- * @dst: (output) the base64-encoded string.  Not NUL-terminated.
+ * @dst: (output) the Base64-encoded string.  Not NUL-terminated.
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Encodes data using base64 encoding, i.e. the "Base 64 Encoding" specified
- * by RFC 4648, including the  '='-padding.
+ * Encodes data using the selected Base64 variant.
  *
- * Return: the length of the resulting base64-encoded string in bytes.
+ * Return: the length of the resulting Base64-encoded string in bytes.
  */
-int base64_encode(const u8 *src, int srclen, char *dst)
+int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	char *cp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		ac = (ac << 8) | src[i];
@@ -48,44 +53,49 @@ int base64_encode(const u8 *src, int srclen, char *dst)
 		*cp++ = base64_table[(ac << (6 - bits)) & 0x3f];
 		bits -= 6;
 	}
-	while (bits < 0) {
-		*cp++ = '=';
-		bits += 2;
+	if (padding) {
+		while (bits < 0) {
+			*cp++ = '=';
+			bits += 2;
+		}
 	}
 	return cp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_encode);
 
 /**
- * base64_decode() - base64-decode a string
+ * base64_decode() - Base64-decode a string
  * @src: the string to decode.  Doesn't need to be NUL-terminated.
  * @srclen: the length of @src in bytes
  * @dst: (output) the decoded binary data
+ * @padding: whether to append '=' padding characters
+ * @variant: which base64 variant to use
  *
- * Decodes a string using base64 encoding, i.e. the "Base 64 Encoding"
- * specified by RFC 4648, including the  '='-padding.
+ * Decodes a string using the selected Base64 variant.
  *
  * This implementation hasn't been optimized for performance.
  *
  * Return: the length of the resulting decoded binary data in bytes,
- *	   or -1 if the string isn't a valid base64 string.
+ *	   or -1 if the string isn't a valid Base64 string.
  */
-int base64_decode(const char *src, int srclen, u8 *dst)
+int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
 	int bits = 0;
 	int i;
 	u8 *bp = dst;
+	const char *base64_table = base64_tables[variant];
 
 	for (i = 0; i < srclen; i++) {
 		const char *p = strchr(base64_table, src[i]);
-
-		if (src[i] == '=') {
-			ac = (ac << 6);
-			bits += 6;
-			if (bits >= 8)
-				bits -= 8;
-			continue;
+		if (padding) {
+			if (src[i] == '=') {
+				ac = (ac << 6);
+				bits += 6;
+				if (bits >= 8)
+					bits -= 8;
+				continue;
+			}
 		}
 		if (p == NULL || src[i] == 0)
 			return -1;
-- 
2.34.1


