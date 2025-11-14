Return-Path: <linux-fscrypt+bounces-960-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC67AC5B72E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 07:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4E5ED3558C6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660E42DA76B;
	Fri, 14 Nov 2025 06:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="wX58QEpg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503CD2DC773
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 06:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100102; cv=none; b=iRySjjxlNSyAbGY7W8T8cYSHbu1kyWykvGv8wcdWbY+EMfXkjmdR4u6ADNROExWkZphbXuGiJIlHpbaWgxDOdXsRibDlmSNYJpC1azFrPJQvgH5ez2RZpvwHyRVe27y9BoOGamOMLuHQ1+/9/BWlCEHT5tK7CPCEBLJcmfV7e8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100102; c=relaxed/simple;
	bh=iA2hBVRXx0YemEHPsh/s0OtYYJaZyVmkN06w/iID+7o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nrzuWv6sgsdqLhGI1iceh6LUPKWKZEdQj0p8w3VsYp8FCSTtNa49SAXnfuD9fQvy8GblqvGWvU/li79uw5rffUXhthU+we8Qj1wvg71WC7jrGU67zHU7rZe/pS5lV1WKjUvCzyIau1+5nYxMGG9qLGT+L6R8q8BJRe8v5OrQ/Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=wX58QEpg; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34381ec9197so1544424a91.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 22:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100100; x=1763704900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q1IGQOBRzs6BjZdUR3pYUPttP+jjYEqCfWUHv2cldxw=;
        b=wX58QEpg7f1aY5M0lu5SBt44yNLnb40/gCOEIdgMqbpCPJGFtCYK+To/agDuQcqKlz
         xxoH/Y0FMmFpDTi53SkNCbUoD07QK+09VMpAGI3hNz3iUanCMVAP+8CRvu7aFb74x4GD
         26fK3uhsryfDX9bV5BY42J3su/1po5juWRY1XHH1uEbAdJQi0BF9KxjjU2eSBSoBdyPl
         k1NjFg2MwXvsiz8yg9Iccw61ivsu/Lu6wF4Zbn6/OFcWM/XIG9qEuFNd+vm1pnolpraw
         IWKXIU8YMX8TV8rAdYM1NnPN04Kp1Y/ClzZUS1ceeqxEzLZzN0aFkG+9OWhpbZiyLXkJ
         B86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100100; x=1763704900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q1IGQOBRzs6BjZdUR3pYUPttP+jjYEqCfWUHv2cldxw=;
        b=vUZwU/Su3CF4w3Z47VGsNG9+OnIvtnrS/XprZ4Kl/q8DsMOrmUrmHUJ+WKWbnwUKSp
         NlpbvYEffvM8ZH8AoZQonDH7YoWfpklsl5pT/zgHSlqHp4SQkLBIWp+S7FuspImSTRPX
         Sy6tWpJYdP2fsOluzN16kWdPM5PUtpMw2waS4RA2wNm+kzaPrOt1W0F7P0NF3lqctrda
         sl2ITFu0Yu2jcHn3iIrKKalMMWOVva5FS7fhmflIPfs/6Lbg7pvWqQjZtaZfpmwj5za4
         kkONBhoSFuPaVVZd0wTD1Yw0eXUbejIZcoAN9Y0IC8c07NCGZi5CyoTh30HAgE6iDZRj
         bvpA==
X-Forwarded-Encrypted: i=1; AJvYcCXVuTRSzxnjr+cH/SrwiQjiZpgBjNzJhiAMRsvEzreDMrMF5fbHhRM+1s9Mq7dQmDJL5KwHXnsu1Zf6X3tJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxMh3trbI8ZaxzdCAXM6qKPZSoHDb0TZNU+gjXx5T5lT0zTXgge
	HcpT7xSqOP2SRSgNr0djDnTCPfo7gCdL1+G7h+jXrxPdpNFaoaka23gC19IX/wtuTbc=
X-Gm-Gg: ASbGncsSHGIsEUH3rFlwQ0MREpDkoyNQ30tyf+6yZ7vBxTJEHl8efSd/Hmy67n3n4xZ
	hoajgggQY6vokWpaa5HER29arwFfeEXEjXLeUTXE5+O/re54W2JVVrgoqhUyY/+7NWkX8ITdhKx
	GgH2riUct2FqtNWJwr9xSCEi98DwdZ72V2QgMojoo0W/stpl284Ooc/XoXKQ3dp3x83pTYjJL4a
	Ee61bEp6TeIYJ37N6pXS9APK6Oqtd+QbqMEE2O62IoO01A7C+73BxFuVo73u80bz+d8H8OH+RPG
	KlkL2pMpoCqxmfZYq74eIvJ8hAqKw97odWyQ5kYhfN0IDoKSsXu1COPAV7qWYyjjKWH4CPmex3n
	zmzFUcXUqFP2+1gF8wvIcxAQL119p6LsNnm6DP5aM3wBtWilwJVJDwwdfZwInofVd7Ee5SfL2Vi
	FnV8UH1NprajRXrUXqMCOsHcnV
X-Google-Smtp-Source: AGHT+IGm/DcFCjii9Cj0HeKdnayirMai9hbtcC7DKvoxz9MTk6adf+dWGrkM2fl+VogccyRz+p4CTA==
X-Received: by 2002:a17:90b:3b4b:b0:343:a631:28a8 with SMTP id 98e67ed59e1d1-343fa754b6emr2387408a91.37.1763100098951;
        Thu, 13 Nov 2025 22:01:38 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ed55564dsm4354199a91.13.2025.11.13.22.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:01:38 -0800 (PST)
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
Subject: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and stricter validation
Date: Fri, 14 Nov 2025 14:01:32 +0800
Message-Id: <20251114060132.89279-1-409411716@gms.tku.edu.tw>
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
 lib/base64.c | 109 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 68 insertions(+), 41 deletions(-)

diff --git a/lib/base64.c b/lib/base64.c
index 9d1074bb821c..1a6d8fe37eda 100644
--- a/lib/base64.c
+++ b/lib/base64.c
@@ -79,28 +79,38 @@ static const s8 base64_rev_maps[][256] = {
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
@@ -116,41 +126,58 @@ EXPORT_SYMBOL_GPL(base64_encode);
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
-- 
2.34.1


