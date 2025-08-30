Return-Path: <linux-fscrypt+bounces-803-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E93B3CB3E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 30 Aug 2025 15:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDFAC1BA52D5
	for <lists+linux-fscrypt@lfdr.de>; Sat, 30 Aug 2025 13:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15D9A27B34A;
	Sat, 30 Aug 2025 13:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="HvbLUUaD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA0427B330
	for <linux-fscrypt@vger.kernel.org>; Sat, 30 Aug 2025 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756560520; cv=none; b=MFLNldWgg3QLAlEdicgTwyPBIhfW7PXQdWkWMZ5l/Qiq+ebqxb4AgwTFimKrkLyjBowIA+C4arsH62yDOjYU42xDt1FZ+EmEetBAP1Jhr28sTbc31O2su/E6FjYVxoaOWUERsNO/kPfqDs5gXEr8u8CfQKqqy2EiFum+dX1H52M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756560520; c=relaxed/simple;
	bh=DA7DnF0XN9lY+stgan8XI4Zz9ca12JKXCOrU6GYdA6s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tf3dz5EQ41PreY02a+/ZEIP30oSV54QTc8+CCktEKqFS6+akkYrbqjQSYdd9Qc/vLpoyFKmdjEo+KZ9ZEMThkCy0Avwd83lHhrOV6/1wql8EauLihgpP2Ugrz+Jz+qRlj/avY5kFD34gfbEAZ6LLLA2PT/CdVwo3h66MjAXaFKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=HvbLUUaD; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2489acda3bbso23230845ad.1
        for <linux-fscrypt@vger.kernel.org>; Sat, 30 Aug 2025 06:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1756560517; x=1757165317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cH2v1QcRr8JcEsaWWcb0QAb5PdIid9UdMR0UYOpPn/g=;
        b=HvbLUUaD4KlI8STB5655JCW+TTBgrOPDidgSHLWutaMnaVThZ+pZ16JBY2vcPbQsuA
         UCTYIy/Ic6rocIF9rM5B9wargXZLOZB+4sjGawClCBKklXtaKGerOnUHkAA4n9EDbduc
         3IWVK1dBWcFDxMZOXb8LN83ZYfwHf0s/End0PNCFY6eiCJ2DaCaer0jGUVjS1y8FYcj3
         oRbCFOg61tkmpwWf5/kN+jvWgasbfEKdvHgXZ3JxMQvaKVICncHD9zW29xjH2M1I1g6c
         dg3OCmwuLSIpDKsqkvVjboyso5a++Pxfli+NDjiJl5/gT1YITGQpv6L+SRLizk4+bg3u
         Aowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756560517; x=1757165317;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cH2v1QcRr8JcEsaWWcb0QAb5PdIid9UdMR0UYOpPn/g=;
        b=XgvGlz5jnQvkp1Ds+UDqni32zbJxYN+nCZa25mn0yQPGwQP8wX2qAluPLit+xtOO2L
         nAuFqsbPTT0dHLejfe69y3Sso5mAf/FlW6B7eac+c1gaFAJ8Y9RURGZ8i2WO0H/dtYmi
         Kbhn3X2RdytKZtPDFKRS1ejraxw4Rd5uDQEwAXs+xz8LOOXA2DroScaAF6EQa1O9Iy5D
         YMOPFS0DB0FnoVipUDAeTtCC0ZpSyrAketM7ZyS0oYg6gKvXMh8AlnPf4UkSdCPRd16g
         0lvygt0f5D8IjsV5B7kmU7TFbGXU8G9IaRAAUkauceZF8Bo/5uOPxULoH/+teDh7AEee
         njGg==
X-Gm-Message-State: AOJu0YxU3rHe0zszr5oTbQjJb0fcOjQrf/YtKqMrgOGZ0zDE722Yl/UY
	4qEk/74PupBWHRHra8nU1A5GG/3tzlWblSZoi6/8HMAR2pQCWJDsMJ4JdUNSchL3RG0=
X-Gm-Gg: ASbGncsxFvoKjoqIhtwr3LROOE68EKgCpYl+sKZ98m5KKCb4YTOul9bUDXCBt7MXyuv
	/r1iJRELXFEWN8x8fggXs/KrtyZf7Y6U4D8ErUSQrgxgIS7s7ukBgdpNPT/MgaHNIcKGQVCkEOT
	UUmRl0TtdxWm3YAwrp+Qq95ETn5/Oiwj5fuI8DHa4hNQ2z32wjjPRJmjlFtg4BwIrujamA3XfWq
	DMT47MlZ5R+H+jrnsiuS+NZlxPyQqcSgC4YcrP17F10F1kxsTVDEIFUjpSRHu86C5c4ccjsLwky
	EX3V7v9PreU2MJ6CYV5VS8gNS3+4q+ETFhxhCwor7gWrpaj79ktMz8brC0eIvC0smYNLQkIJI2M
	hhEUNzBZeoI/sDJwrFzzGEB846i4H+2vj6QbOB8UtbKPE4iI=
X-Google-Smtp-Source: AGHT+IGBAlCgkcm3nrwMC3nhI3g6hU3d8goMhXPzQv7o9StgfPRy27tBqmBWSCPuHEJ4cC763SbNpw==
X-Received: by 2002:a17:903:1d2:b0:248:e3d0:46ec with SMTP id d9443c01a7336-24944ab7f52mr26274385ad.37.1756560517138;
        Sat, 30 Aug 2025 06:28:37 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7a16:5a8f:5bc5:6642])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2490373eb17sm52512195ad.54.2025.08.30.06.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Aug 2025 06:28:36 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Subject: [PATCH] fscrypt: optimize fscrypt_base64url_encode() with block processing
Date: Sat, 30 Aug 2025 21:28:32 +0800
Message-Id: <20250830132832.7911-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previously, fscrypt_base64url_encode() processed input one byte at a
time, using a bitstream, accumulating bits and emitting characters when
6 bits were available. This was correct but added extra computation.

This patch processes input in 3-byte blocks, mapping directly to 4 output
characters. Any remaining 1 or 2 bytes are handled according to Base64 URL
rules. This reduces computation and improves performance.

Performance test (5 runs) for fscrypt_base64url_encode():

64B input:
-------------------------------------------------------
| Old method | 131 | 108 | 114 | 122 | 123 | avg ~120 ns |
-------------------------------------------------------
| New method |  84 |  81 |  84 |  82 |  84 | avg ~83 ns  |
-------------------------------------------------------

1KB input:
--------------------------------------------------------
| Old method | 1152 | 1121 | 1142 | 1147 | 1148 | avg ~1142 ns |
--------------------------------------------------------
| New method |  767 |  752 |  765 |  771 |  776 | avg ~766 ns  |
--------------------------------------------------------

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
Tested on Linux 6.8.0-64-generic x86_64
with Intel Core i7-10700 @ 2.90GHz

Test is executed in the form of kernel module.

Test script:

static int encode_v1(const u8 *src, int srclen, char *dst)
{
	u32 ac = 0;
	int bits = 0;
	int i;
	char *cp = dst;

	for (i = 0; i < srclen; i++) {
		ac = (ac << 8) | src[i];
		bits += 8;
		do {
			bits -= 6;
			*cp++ = base64url_table[(ac >> bits) & 0x3f];
		} while (bits >= 6);
	}
	if (bits)
		*cp++ = base64url_table[(ac << (6 - bits)) & 0x3f];
	return cp - dst;
}

static int encode_v2(const u8 *src, int srclen, char *dst)
{
	u32 ac = 0;
	int i = 0;
	char *cp = dst;

	while (i + 2 < srclen) {
		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
		*cp++ = base64url_table[(ac >> 18) & 0x3f];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		*cp++ = base64url_table[(ac >> 6) & 0x3f];
		*cp++ = base64url_table[ac & 0x3f];
		i += 3;
	}

	switch (srclen - i) {
	case 2:
		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8);
		*cp++ = base64url_table[(ac >> 18) & 0x3f];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		*cp++ = base64url_table[(ac >> 6) & 0x3f];
		break;
	case 1:
		ac = ((u32)src[i] << 16);
		*cp++ = base64url_table[(ac >> 18) & 0x3f];
		*cp++ = base64url_table[(ac >> 12) & 0x3f];
		break;
	}
	return cp - dst;
}

static void run_test(const char *label, const u8 *data, int len)
{
    char *dst1, *dst2;
    int n1, n2;
    u64 start, end;

    dst1 = kmalloc(len * 2, GFP_KERNEL);
    dst2 = kmalloc(len * 2, GFP_KERNEL);

    if (!dst1 || !dst2) {
        pr_err("%s: Failed to allocate dst buffers\n", label);
        goto out;
    }

    pr_info("[%s] input size = %d bytes\n", label, len);

    start = ktime_get_ns();
    n1 = encode_v1(data, len, dst1);
    end = ktime_get_ns();
    pr_info("[%s] encode_v1 time: %lld ns\n", label, end - start);

    start = ktime_get_ns();
    n2 = encode_v2(data, len, dst2);
    end = ktime_get_ns();
    pr_info("[%s] encode_v2 time: %lld ns\n", label, end - start);

    if (n1 != n2 || memcmp(dst1, dst2, n1) != 0)
        pr_err("[%s] Mismatch detected between encode_v1 and encode_v2!\n", label);
    else
        pr_info("[%s] Outputs are identical.\n", label);

out:
    kfree(dst1);
    kfree(dst2);
}

static int __init base64_perf_init(void)
{
    u8 *data1k;

    pr_info("Module init - running multi-size tests\n");

    {
        static u8 test64[64];
        get_random_bytes(test64, sizeof(test64));
        run_test("64B", test64, sizeof(test64));
    }

    data1k = kmalloc(1024, GFP_KERNEL);
    if (data1k) {
        get_random_bytes(data1k, 1024);
        run_test("1KB", data1k, 1024);
        kfree(data1k);
    } else {
        pr_err("Failed to allocate 1KB test buffer\n");
    }

    return 0;
}
---
 fs/crypto/fname.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 010f9c0a4c2f..adaa16905498 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -204,20 +204,31 @@ static const char base64url_table[65] =
 static int fscrypt_base64url_encode(const u8 *src, int srclen, char *dst)
 {
 	u32 ac = 0;
-	int bits = 0;
-	int i;
+	int i = 0;
 	char *cp = dst;
 
-	for (i = 0; i < srclen; i++) {
-		ac = (ac << 8) | src[i];
-		bits += 8;
-		do {
-			bits -= 6;
-			*cp++ = base64url_table[(ac >> bits) & 0x3f];
-		} while (bits >= 6);
+	while (i + 2 < srclen) {
+		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8) | (u32)src[i + 2];
+		*cp++ = base64url_table[(ac >> 18) & 0x3f];
+		*cp++ = base64url_table[(ac >> 12) & 0x3f];
+		*cp++ = base64url_table[(ac >> 6) & 0x3f];
+		*cp++ = base64url_table[ac & 0x3f];
+		i += 3;
+	}
+
+	switch (srclen - i) {
+	case 2:
+		ac = ((u32)src[i] << 16) | ((u32)src[i + 1] << 8);
+		*cp++ = base64url_table[(ac >> 18) & 0x3f];
+		*cp++ = base64url_table[(ac >> 12) & 0x3f];
+		*cp++ = base64url_table[(ac >> 6) & 0x3f];
+		break;
+	case 1:
+		ac = ((u32)src[i] << 16);
+		*cp++ = base64url_table[(ac >> 18) & 0x3f];
+		*cp++ = base64url_table[(ac >> 12) & 0x3f];
+		break;
 	}
-	if (bits)
-		*cp++ = base64url_table[(ac << (6 - bits)) & 0x3f];
 	return cp - dst;
 }
 
-- 
2.34.1


