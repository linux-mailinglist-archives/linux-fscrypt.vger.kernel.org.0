Return-Path: <linux-fscrypt+bounces-845-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CBBDBA2965
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 08:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C58243BA16B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 06:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8155527F18B;
	Fri, 26 Sep 2025 06:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="B7vzfC8P"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9D27EFE3
	for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 06:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869795; cv=none; b=bQJNTARdnkPp2i4MCGXqw7WlLfpxEWW0JbY3b5bhexXqJMWFnZdKcVRyK0/m8UshRiWGZiZOclHryZEyKWdfMulqx5d80ptw5BDW1NgF603AIEwjvo1KW508sS2ZlLKHG7qaeZOPldyuhrkIW51AG8gqzE+ok5+hsid+RwMh214=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869795; c=relaxed/simple;
	bh=vqUhPyP3EAx7UTCOLjBS/l0UBAlATt2TeWv7PAH1DPA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tz5+dW6j4nn73N4JkFrmZPn0LzFLPzdK46Mpdj6s4YxN1J8M2T9RSlwEc959C1iH18iu3lXlj5Nj9BmJWSJUvWKqSyImyPOkRcg6ci4b4/nBMDPgoAmw8Lx+Ns3famcona4f2pkz/IVmmbS/toH8MO5OUa5w1kGF6JKg6f7khnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=B7vzfC8P; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b55517e74e3so1877053a12.2
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Sep 2025 23:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869793; x=1759474593; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThTjOOxGShK1kR2Ph7c8m2+KgdD3vN1MOztiSeQNOJs=;
        b=B7vzfC8PG5xFByoD53WyhdrLH24gm//v3g/KZSj9yVjphuSXG0UEJpbN3fKS08GMcJ
         65KoT34FCnAJHfU3OSrZBhsWTmXcsaRYsc6tv0y62CpMZfHsmtmdaA/s186coBSPucKJ
         S2P4d/nQ57xJTKhPl+m0Ld5qBfYSFVT8TEoxk5+OdpVm1mJ1beT9uE6rvashpC3o5Zcd
         ZReQXGbGCdLjeGCc0quzXcAdElPkMHNTIWl68X7bfxIMa5OBwxnNuAi7pUfZE6NRtX0/
         mw0RK3A1Vyk9lGfGurVslrvsicDz+vslEuteXDHdQlahGUdYhDMajl2j+d18JFfrX3HG
         m4DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869793; x=1759474593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThTjOOxGShK1kR2Ph7c8m2+KgdD3vN1MOztiSeQNOJs=;
        b=UVAAXWzW6J2H3+KIjP2tZWyZ7w5YOL+28Xui6dtImV9iPjIbDzO1JkTgZJMuNFsPGV
         nJINpgUjyt2Hj/3u14FsGP6RwkUA9vKMDtaSYDXpdjUuVE6+Mr8HIIse9j6ws9raoMPx
         ZYKLIY2uy8IZXzFTgpu1wv4WpizwKOs12ysanhLfKTNDTIsYtjkz82wIQRGCKXK6iKLz
         SIyPlQ2D5DZLUOELwnElKT13pZO4RfQaEidOuHDx8L3NsZ5gn7Xy71FQU3kAxkihT00l
         Cd+SK7dyyFSP/7HGgYvCpeuWswaH/4akOSk6T+eI9mn0945a/+v+0iH3jFKi/f4OqAQY
         3wbA==
X-Forwarded-Encrypted: i=1; AJvYcCXhHTe6aL/ABVnvBp/yOXfrjVque3aoDoYNNALnaMEHiPYjvghdQaeDlEjHmoyywmvxZsz9Y0AhR5LQcXvG@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7MbR9t+6Sn1aSIpApj0iVC00Z1ocFRu8oGHZ+1sebgPxGbfIK
	qIGkIiGBd0rRp7Dj/WOxEHjJlrkHhpZSTTa2oTh5+OyX1cVyvsAs7p2QlUEQ4g8uA1k=
X-Gm-Gg: ASbGnctfFv/RwdgbOW7xlLSCIfmAUAkDUdnE46RBOgD2PzxaAJ+zb1GwaLEZpeQ7aMH
	QvuXDmpQx6STxCZNMCspGpVhtvO8jliH8CbHsWZaGPS79Tzyjl/1TLpxZj3hGPcVBza3zmejlwp
	AoOCvWjNYNHeiF/5WCnqTv+b1WayBNUwyz50L+xxvUWXa/+ezaVGwTQ20oFTQGmFJcZKJ79C4/t
	8gYg3q4rkxo18SFX0Lid4ZMS26L1r/Sl5EXMlambDkE6XbJ2Hmt8lu0xM8AzObhIhv/iCuBIu+n
	0jhyl93mFcZkiyF8Qs7Ya0TojS4cLQPdJrF6DG65IuLr8Ekj+sOYbP6BgvA41ex1faN4pDmVFFK
	KmYlapTuy7phbGM9D7JW4oKfnKOXq7xcGEalXHduSYMpBM8w=
X-Google-Smtp-Source: AGHT+IGNpOwteifS+VbNOKUqfaBSeov0n2k+u3WDmS4hQZBlmCUZXdh+j4DU1NlYFPlw0rxIClUO8A==
X-Received: by 2002:a17:902:e5c9:b0:24b:e55:360 with SMTP id d9443c01a7336-27ed4a0a053mr69081205ad.23.1758869783030;
        Thu, 25 Sep 2025 23:56:23 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cfdcfsm45203655ad.26.2025.09.25.23.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:56:22 -0700 (PDT)
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
Subject: [PATCH v3 3/6] lib/base64: rework encode/decode for speed and stricter validation
Date: Fri, 26 Sep 2025 14:56:17 +0800
Message-Id: <20250926065617.14361-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
References: <20250926065235.13623-1-409411716@gms.tku.edu.tw>
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
  64B  ~1530ns  -> ~64ns   (~23.9x)
  1KB ~27726ns  -> ~982ns  (~28.3x)

Co-developed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Co-developed-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Yu-Sheng Huang <home7438072@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/base64.c | 150 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 110 insertions(+), 40 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index b20fdf168..fd1db4611 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -93,26 +93,43 @@ static const s8 base64_rev_tables[][256] = {
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
+		ac = ((u32)src[0] << 16) |
+			 ((u32)src[1] << 8) |
+			 (u32)src[2];
+
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		*cp++ = base64_table[ac & 0x3f];
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
+		ac = ((u32)src[0] << 16) |
+		     ((u32)src[1] << 8);
+
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		*cp++ = base64_table[(ac >> 6) & 0x3f];
+		if (padding)
+			*cp++ = '=';
+		break;
+	case 1:
+		ac = ((u32)src[0] << 16);
+		*cp++ = base64_table[ac >> 18];
+		*cp++ = base64_table[(ac >> 12) & 0x3f];
+		if (padding) {
+			*cp++ = '=';
+			*cp++ = '=';
+		}
+		break;
 	}
 	return cp - dst;
 }
@@ -128,39 +145,92 @@ EXPORT_SYMBOL_GPL(base64_encode);
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
-
-	for (i = 0; i < srclen; i++) {
-		if (src[i] == '=') {
-			ac = (ac << 6);
-			bits += 6;
-			if (bits >= 8)
-				bits -= 8;
-			continue;
-		}
-		ch = base64_rev_tables[variant][(u8)src[i]];
-		if (ch == -1)
+	s8 input1, input2, input3, input4;
+	u32 val;
+
+	if (srclen == 0)
+		return 0;
+
+	/* Validate the input length for padding */
+	if (unlikely(padding && (srclen & 0x03) != 0))
+		return -1;
+
+	while (srclen >= 4) {
+		/* Decode the next 4 characters */
+		input1 = base64_rev_tables[variant][(u8)src[0]];
+		input2 = base64_rev_tables[variant][(u8)src[1]];
+		input3 = base64_rev_tables[variant][(u8)src[2]];
+		input4 = base64_rev_tables[variant][(u8)src[3]];
+
+		/* Return error if any Base64 character is invalid */
+		if (unlikely(input1 < 0 || input2 < 0 || (!padding && (input3 < 0 || input4 < 0))))
+			return -1;
+
+		/* Handle padding */
+		if (unlikely(padding && ((input3 < 0 && input4 >= 0) ||
+					 (input3 < 0 && src[2] != '=') ||
+					 (input4 < 0 && src[3] != '=') ||
+					 (srclen > 4 && (input3 < 0 || input4 < 0)))))
+			return -1;
+		val = ((u32)input1 << 18) |
+		      ((u32)input2 << 12) |
+		      ((u32)((input3 < 0) ? 0 : input3) << 6) |
+		      (u32)((input4 < 0) ? 0 : input4);
+
+		*bp++ = (u8)(val >> 16);
+
+		if (input3 >= 0)
+			*bp++ = (u8)(val >> 8);
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
+			input1 = base64_rev_tables[variant][(u8)src[0]];
+			input2 = base64_rev_tables[variant][(u8)src[1]];
+			if (unlikely(input1 < 0 || input2 < 0))
+				return -1;
+
+			val = ((u32)input1 << 6) | (u32)input2; /* 12 bits */
+			if (unlikely(val & 0x0F))
+				return -1; /* low 4 bits must be zero */
+
+			*bp++ = (u8)(val >> 4);
+			break;
+		case 3:
+			input1 = base64_rev_tables[variant][(u8)src[0]];
+			input2 = base64_rev_tables[variant][(u8)src[1]];
+			input3 = base64_rev_tables[variant][(u8)src[2]];
+			if (unlikely(input1 < 0 || input2 < 0 || input3 < 0))
+				return -1;
+
+			val = ((u32)input1 << 12) |
+			      ((u32)input2 << 6) |
+			      (u32)input3; /* 18 bits */
+
+			if (unlikely(val & 0x03))
+				return -1; /* low 2 bits must be zero */
+
+			*bp++ = (u8)(val >> 10);
+			*bp++ = (u8)((val >> 2) & 0xFF);
+			break;
+		default:
 			return -1;
-		ac = (ac << 6) | ch;
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


