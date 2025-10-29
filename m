Return-Path: <linux-fscrypt+bounces-881-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 00ED6C19A76
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 11:21:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 614A8348ED2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Oct 2025 10:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9DBC2FBDED;
	Wed, 29 Oct 2025 10:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="Y7jyWP2w"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBEF2FDC29
	for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 10:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733269; cv=none; b=niOj5QOE+zP+ZfNICOjU3qf8no+MkBUpziau4fQCju4rCy/cDtCe1slGBqPqkx2hb7IRfIyS68VDGz11aGc6ay9liuACreVrllIZSVgBCBUTcTAsTVfLzEVgwIYqFMtACEb4QP8C9ADQY/b/SoeUSWyWBMWj2EOwSY0ZZe9mynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733269; c=relaxed/simple;
	bh=dY4q8YkbiAgjzKiEsiASrXojI4Al4U1XdOPWUwH7wwg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sy5OQki7om3yoojHwIIW+xv0evGgF53o9OpMuAGu8SqBUw9QzYc2oRHGCG3SjqySD07O7nwnSIob6RVTplVguOW+d5U6uM2mfkRBPHIcDO2/U2/OeeLhtFfm6R5gWxvdfTVxFm6ogmmXbG+Cz5VW6HHChaZEOwHOCmimMT/7yLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=Y7jyWP2w; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7a226a0798cso5871946b3a.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 29 Oct 2025 03:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761733267; x=1762338067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbulqRf/JzdfAl/dtv+qftIvyvV8wiDVdKN2RHYy4TQ=;
        b=Y7jyWP2w71F6U7E40iH6TwrqZJ9SpKzBaiTTDR7tz0WgNCy58k6NyUs2mNgWEQH4qD
         q1pnSengwQ+QSnRFJmx5YJ1J1sw8Ur2c1JxvEHxq/8XeclgO/hgsdtu/8jwm5HYa7jT1
         CTHTSGpK3N9jwJWZbzXySdpqKxPvHN5y72i8PMQP9d7UkOkdm8ofpahtrLQH4A8yv/pL
         FUecIMEncs9gs+WDZQVcpZIBT7VZNkxdM8Dqk7jT0xmnlwraNIqNEhUCMluU28ZTYpro
         ilcIoAUR+IE+Ycex3wcdBrccs3q2V00N2Q4qBYp7R4a4PZEERQpfztD0LKxoxGwWdzz8
         2noA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733267; x=1762338067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HbulqRf/JzdfAl/dtv+qftIvyvV8wiDVdKN2RHYy4TQ=;
        b=UBxswkQdjQYF6k1lsuZ7hDCnWyTmRxm39sZJeQ6Nu1AtArX+H6ToT6YocBerXq+Xrb
         LN7X3IuAYP07rEOkm8vzaf9Pgy2DE3p2T83+rogZt9LC3z4at9OODq82z85uj3eAYrhj
         m7zpuoIAF1rYcOyUQC2IYEDpTbQa5yRuqALnEylqKm0ZIBQs4Vm0Re2Iz/jdt1UPe9CY
         cqVMDw8183nUfThngTwhjF7PBd6Kl0PRunknja5OdZmBw1TpIHkaRJmiwsDkHmNA8dHs
         Jnqc1pOY7MtqUU/NUDf49eK8Ys4jXnJkC3dX2YziyhgfaBtEg+HYXtkKxxOpu5SK1uHN
         /edw==
X-Forwarded-Encrypted: i=1; AJvYcCUvvkZrw1EcDJL9CLY2k8/aY6i5NQ1XB87X6Igk0WyGTejaZgOE1P+NuNjfL61vXkKo87kLWF8MCw4YAR4Z@vger.kernel.org
X-Gm-Message-State: AOJu0YwYstarDJZqBuDLUsc9Ul7ak3fPOjo3GRyN+XBqeM9uGAax30Ke
	lqh//DTIWqpdVLxY7/jzzQ4EjfYO09m16RIvF8g5CnTCxKBGl+zjf3jO/OvBYSy6zcQ=
X-Gm-Gg: ASbGncvYYLl97J17ycd9/baqY+VnGHmZQXWeN5UGpM1vhY1kkgHXkdZCW1HGgIyNf6V
	rg7+JkgRLGiGMXUyI2op6AzxTi4Mjjx7qfZ+7F/+bNKuhfSZ0hlHKUqIGWlQ0oEZSoex16dOOQG
	VQkpYT9KOJ9nUyd4ImVzUzES/Qkd+fJb80dnKLbxOxD+NYDyqTAH1kQgGcNZsvlTzcvZascddca
	YrUpiU6QK7hm/HsKTn322tJLiMxQgeYKQT7cKbi1boThAEOLBZbVjh4+rNrTbbqnddXQTdL5VeR
	Zid2EXxR3C/0xhsOEt6Yuf75MNO0EujyOtN7um6WbfmNbt9zRqPlhDlV0GOTOStcAel/W538qoY
	fFzJcuWk60UktfmCHyz6S1soUBW/bAlIlaSBRH3GyDAATiDYPZa8MNzdcnuAPsKUrAWKYfaYQls
	0p3YhORl9jDqLNJsSUmjTD1rQW
X-Google-Smtp-Source: AGHT+IHL0MICP1K9H4r8j+kOSzogqVuiVQjNGs4tt84n15SY6d/K/p8SfQsZ4RZjWKksxhhmDOquvA==
X-Received: by 2002:a05:6a00:2da5:b0:77f:4f3f:bfda with SMTP id d2e1a72fcca58-7a4e53f14dcmr2854006b3a.31.1761733267109;
        Wed, 29 Oct 2025 03:21:07 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:3fc9:8c3c:5030:1b20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a414034661sm14888261b3a.26.2025.10.29.03.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:21:06 -0700 (PDT)
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
Subject: [PATCH v4 3/6] lib/base64: rework encode/decode for speed and stricter validation
Date: Wed, 29 Oct 2025 18:21:00 +0800
Message-Id: <20251029102100.543446-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old base64 implementation relied on a bit-accumulator loop, which was
slow for larger inputs and too permissive in validation. It would accept
extra '=', missing '=', or even '=' appearing in the middle of the input,
allowing malformed strings to pass. This patch reworks the internals to
improve performance and enforce stricter validation.

Changes:
 - Encoder:
   * Process input in 3-byte blocks, mapping 24 bits into four 6-bit
     symbols, avoiding bit-by-bit shifting and reducing loop iterations.
   * Handle the final 1-2 leftover bytes explicitly and emit '=' only when
     requested.
 - Decoder:
   * Based on the reverse lookup tables from the previous patch, decode
     input in 4-character groups.
   * Each group is looked up directly, converted into numeric values, and
     combined into 3 output bytes.
   * Explicitly handle padded and unpadded forms:
      - With padding: input length must be a multiple of 4, and '=' is
        allowed only in the last two positions. Reject stray or early '='.
      - Without padding: validate tail lengths (2 or 3 chars) and require
        unused low bits to be zero.
   * Removed the bit-accumulator style loop to reduce loop iterations.

Performance (x86_64, Intel Core i7-10700 @ 2.90GHz, avg over 1000 runs,
KUnit):

Encode:
  64B   ~90ns   -> ~32ns   (~2.8x)
  1KB  ~1332ns  -> ~510ns  (~2.6x)

Decode:
  64B  ~1530ns  -> ~35ns   (~43.7x)
  1KB ~27726ns  -> ~530ns  (~52.3x)

Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 110 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 41 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index 8a0d28908..bcdbd411d 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -51,28 +51,38 @@ static const s8 base64_rev_maps[][256] = {
 int base64_encode(const u8 *src, int srclen, char *dst, bool padding, enum base64_variant variant)
 {
 	u32 ac = 0;
-	int bits = 0;
-	int i;
 	char *cp = dst;
 	const char *base64_table = base64_tables[variant];
 
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
+		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		*cp++ = base64_table[ac & 0x3f];
+
+		src += 3;
+		srclen -= 3;
 	}
-	if (padding) {
-		while (bits < 0) {
+
+	switch (srclen) {
+	case 2:
+		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		if (padding)
+			*cp++ = '=';
+		break;
+	case 1:
+		ac = (u32)src[0] << 16;
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		if (padding) {
+			*cp++ = '=';
 			*cp++ = '=';
-			bits += 2;
 		}
+		break;
 	}
 	return cp - dst;
 }
@@ -88,41 +98,59 @@ EXPORT_SYMBOL_GPL(base64_encode);
  *
  * Decodes a string using the selected Base64 variant.
  *
- * This implementation hasn't been optimized for performance.
- *
  * Return: the length of the resulting decoded binary data in bytes,
  *	   or -1 if the string isn't a valid Base64 string.
  */
 int base64_decode(const char *src, int srclen, u8 *dst, bool padding, enum base64_variant variant)
 {
-	u32 ac = 0;
-	int bits = 0;
-	int i;
 	u8 *bp = dst;
-	s8 ch;
+	s8 input[4];
+	s32 val;
+	const u8 *s = (const u8 *)src;
+	const s8 *base64_rev_tables = base64_rev_maps[variant];
 
-	for (i = 0; i < srclen; i++) {
-		if (padding) {
-			if (src[i] == '=') {
-				ac = (ac << 6);
-				bits += 6;
-				if (bits >= 8)
-					bits -= 8;
-				continue;
-			}
-		}
-		ch = base64_rev_maps[variant][(u8)src[i]];
-		if (ch == -1)
-			return -1;
-		ac = (ac << 6) | ch;
-		bits += 6;
-		if (bits >= 8) {
-			bits -= 8;
-			*bp++ = (u8)(ac >> bits);
+	while (srclen >= 4) {
+		input[0] = base64_rev_tables[s[0]];
+		input[1] = base64_rev_tables[s[1]];
+		input[2] = base64_rev_tables[s[2]];
+		input[3] = base64_rev_tables[s[3]];
+
+		val = input[0] << 18 | input[1] << 12 | input[2] << 6 | input[3];
+
+		if (unlikely(val < 0)) {
+			if (!padding || srclen != 4 || s[3] != '=')
+				return -1;
+			padding = 0;
+			srclen = s[2] == '=' ? 2 : 3;
+			break;
 		}
+
+		*bp++ = val >> 16;
+		*bp++ = val >> 8;
+		*bp++ = val;
+
+		s += 4;
+		srclen -= 4;
 	}
-	if (ac & ((1 << bits) - 1))
+
+	if (likely(!srclen))
+		return bp - dst;
+	if (padding || srclen == 1)
 		return -1;
+
+	val = (base64_rev_tables[s[0]] << 12) | (base64_rev_tables[s[1]] << 6);
+	*bp++ = val >> 10;
+
+	if (srclen == 2) {
+		if (val & 0x800003ff)
+			return -1;
+	} else {
+		val |= base64_rev_tables[s[2]];
+		if (val & 0x80000003)
+			return -1;
+		*bp++ = val >> 2;
+	}
 	return bp - dst;
 }
 EXPORT_SYMBOL_GPL(base64_decode);
+
-- 
2.34.1


