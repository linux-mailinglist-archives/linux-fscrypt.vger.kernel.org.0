Return-Path: <linux-fscrypt+bounces-961-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7125AC5B749
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 07:04:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1D814EC9F3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 06:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40C52DA76B;
	Fri, 14 Nov 2025 06:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="twWJBgst"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF672DAFBB
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Nov 2025 06:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763100125; cv=none; b=ahSLuULaeETbH8kC2TVl6zwqnxvqtOxYNwEn71EAOiFP9nnHDTbS1Idv7Bp8U3Lm05oCzGfbX4Px/I1OALuDQZ46HWfFpVAfDwG5wZLy25TAtEr5AtGeFU+FyXpPPWw7AbmvwNUupEvcMNem0rW0XENP3yVVBCrCPS5AuAmgpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763100125; c=relaxed/simple;
	bh=uqCZHWXfubRIGcGUdgi2SCXRusjZcak1XApIJ5f67MQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i6mMncxPLfp2WcfWzNC8V+UWjHaXh/jkmLP0QlXnvyducs2lDEw1cwFiJKWmfBC50eFmHpFvm9vPPeQT9dbhy9vV2UBcYvAH5r1hgwdof87ucliHMeeo91Y+veb0mt6yUFLk7QUwQURIFlXGuLoAbL9EiKEE4nDoV7xFcmrgA6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=twWJBgst; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-297dc3e299bso16291305ad.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 13 Nov 2025 22:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1763100123; x=1763704923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkpDCor2TUF5YyGMpKqZC7jfjMqxofNFoS0oYVpIUCs=;
        b=twWJBgstQzHaUJU1SXOox+Vd+gGyZf5KelB2kmt5eILUwmq+j9Rmcrtr0ik0FLAyoy
         O2+oUljSxCrL9L9+m0qYdJQgcoQ7YCqbekz71B11eCJPYJzq5K58kZy2T7Fc3paVekTN
         zyb7lBEox1snDeABPb5S0VpIS1pmyQ5m2/oYOZk5d6y9P0PosSScMQ4xsCJRAxg4TpVd
         osLINc2Irhw/0wlk82FA+fgFt35lZCYXNvMd4tq4OL5GmsP4LcukMA1Mr21ypZ7Juqx2
         7AkKS5xALFnvaXa/IA3ABjPCGnnsbNA0WDcLZC8M5wC0KBV4Ljsl6Gn4T5DWh330PIBm
         NqTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763100123; x=1763704923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fkpDCor2TUF5YyGMpKqZC7jfjMqxofNFoS0oYVpIUCs=;
        b=VLDgKid6nvrXviTUCrDiJPBYk83m2nXtAP8eJEIvgf55vZgp0NeFB5+3ZkGJhuuKS6
         BVhGQKCBnGKqLqS0OUdlVuRg095k5ucFsaI4rDvK3/zV1kzTjd2MR1ylrFm98ny/vYrS
         JaMlCaq2vQvciSQzMqifGRC6Wh7SuWbW49LPwChQHJodxZATg9FB06mnVXFqupPhrAjC
         ZK5cvDk+9aBPTG/WDdnbEA95fBXyzgyPfnryvtKvEGMTDMn52sArzbaRfs8kV+eM1W/X
         t+1CHjuaRLe1kkkAvjZp77rsy6rGj9Dwcwj3zYv4jRJi16P2O+NJci2LGFOLdw6dBNg/
         EomA==
X-Forwarded-Encrypted: i=1; AJvYcCWOFPkBLHL381ZgV2sgPPIRGLHGbeAg4eARQqhPuf+Rk21Ue9g1G6WBIf5HHqCFBu+JPPgcU8QuW/AkEcD9@vger.kernel.org
X-Gm-Message-State: AOJu0Yym1hsz9SQ5zzz6Izk5QtYCkKpQvr03VoDAbq9qzd6hFrUxagkX
	HydoGl7fkimIAeMXVosCJfrCwIAKoLI3vtsgmDCdaKPwnBgACfws5lWP2aQFtkxdFl0=
X-Gm-Gg: ASbGnctK6G072L3auba5zh57mNt0Cdm7zlcBn7JBNYcEX3lU3O0ME+5Yl2b/2FM6kOa
	4lzxNWhZIesF7dmmhNliqZoRPAkv97XcoUmW8c3mkY9NVDZS92c4PUIhuL/KbztFl92YgxLNCDm
	rTC7npdTLZR/PypOoDARuoqzHduIFL2AvBFpXkVvdBE6AFnX73QAPw3M0FJL13wPxAP2R+w5Snt
	lEbeq0Id9q9Be9lY5CiM059fJFV8B73X32jc9H4eCrvluEv0NaKkK3unmpAnQjI+x4ZRq8CEjlx
	PZCOM4UnMUcv56Ugcho1xKS3anoj26m+uoT/EoLz+AENKWPnHgUjN5IAVi+A1fHIZ8JoXkPtxiG
	ynTIxM3q29BUqQLFdCAyn2wswxiEh8AYaeMmW7uVUsg9xAqqE8bGj//30aKRRHES8LbDpfD8Bdf
	RIbAmEwb4QnY8r0lOoPqdjGMMghCVF82o7pBc=
X-Google-Smtp-Source: AGHT+IHLJt5qiCwb1wnjqHRtAhuTOw76Mt+9zbvgqBMEi2RYv1ifLlCn1RvArWxwlI1zOXFfjIoqWw==
X-Received: by 2002:a17:903:b0d:b0:295:70cc:8ec4 with SMTP id d9443c01a7336-2986a74b360mr22444965ad.51.1763100122945;
        Thu, 13 Nov 2025 22:02:02 -0800 (PST)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:22d2:323c:497d:adbd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0c35sm43342225ad.52.2025.11.13.22.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 22:02:02 -0800 (PST)
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
Subject: [PATCH v5 4/6] lib: add KUnit tests for base64 encoding/decoding
Date: Fri, 14 Nov 2025 14:01:57 +0800
Message-Id: <20251114060157.89507-1-409411716@gms.tku.edu.tw>
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

Add a KUnit test suite to validate the base64 helpers. The tests cover
both encoding and decoding, including padded and unpadded forms as defined
by RFC 4648 (standard base64), and add negative cases for malformed inputs
and padding errors.

The test suite also validates other variants (URLSAFE, IMAP) to ensure
their correctness.

In addition to functional checks, the suite includes simple microbenchmarks
which report average encode/decode latency for small (64B) and larger
(1KB) inputs. These numbers are informational only and do not gate the
tests.

Kconfig (BASE64_KUNIT) and lib/tests/Makefile are updated accordingly.

Sample KUnit output:

    KTAP version 1
    # Subtest: base64
    # module: base64_kunit
    1..4
    # base64_performance_tests: [64B] encode run : 32ns
    # base64_performance_tests: [64B] decode run : 35ns
    # base64_performance_tests: [1KB] encode run : 510ns
    # base64_performance_tests: [1KB] decode run : 530ns
    ok 1 base64_performance_tests
    ok 2 base64_std_encode_tests
    ok 3 base64_std_decode_tests
    ok 4 base64_variant_tests
    # base64: pass:4 fail:0 skip:0 total:4
    # Totals: pass:4 fail:0 skip:0 total:4

Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
---
 lib/Kconfig.debug        |  19 ++-
 lib/tests/Makefile       |   1 +
 lib/tests/base64_kunit.c | 294 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/base64_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3034e294d50d..8f55ab41d62a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2815,8 +2815,25 @@ config CMDLINE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config BASE64_KUNIT
+	tristate "KUnit test for base64 decoding and encoding" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds the base64 unit tests.
+
+	  The tests cover the encoding and decoding logic of Base64 functions
+	  in the kernel.
+	  In addition to correctness checks, simple performance benchmarks
+	  for both encoding and decoding are also included.
+
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config BITS_TEST
-	tristate "KUnit test for bits.h" if !KUNIT_ALL_TESTS
+	tristate "KUnit test for bit functions and macros" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index f7460831cfdd..601dba4b7d96 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -4,6 +4,7 @@
 
 # KUnit tests
 CFLAGS_bitfield_kunit.o := $(DISABLE_STRUCTLEAK_PLUGIN)
+obj-$(CONFIG_BASE64_KUNIT) += base64_kunit.o
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
 obj-$(CONFIG_BLACKHOLE_DEV_KUNIT_TEST) += blackhole_dev_kunit.o
diff --git a/lib/tests/base64_kunit.c b/lib/tests/base64_kunit.c
new file mode 100644
index 000000000000..f7252070c359
--- /dev/null
+++ b/lib/tests/base64_kunit.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * base64_kunit_test.c - KUnit tests for base64 encoding and decoding functions
+ *
+ * Copyright (c) 2025, Guan-Chun Wu <409411716@gms.tku.edu.tw>
+ */
+
+#include <kunit/test.h>
+#include <linux/base64.h>
+
+/* ---------- Benchmark helpers ---------- */
+static u64 bench_encode_ns(const u8 *data, int len, char *dst, int reps,
+			   enum base64_variant variant)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_encode(data, len, dst, true, variant);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static u64 bench_decode_ns(const char *data, int len, u8 *dst, int reps,
+			   enum base64_variant variant)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_decode(data, len, dst, true, variant);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static void run_perf_and_check(struct kunit *test, const char *label, int size,
+			       enum base64_variant variant)
+{
+	const int reps = 1000;
+	size_t outlen = DIV_ROUND_UP(size, 3) * 4;
+	u8 *in = kmalloc(size, GFP_KERNEL);
+	char *enc = kmalloc(outlen, GFP_KERNEL);
+	u8 *decoded = kmalloc(size, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, in);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, enc);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, decoded);
+
+	get_random_bytes(in, size);
+	int enc_len = base64_encode(in, size, enc, true, variant);
+	int dec_len = base64_decode(enc, enc_len, decoded, true, variant);
+
+	/* correctness sanity check */
+	KUNIT_EXPECT_EQ(test, dec_len, size);
+	KUNIT_EXPECT_MEMEQ(test, decoded, in, size);
+
+	/* benchmark encode */
+
+	u64 t1 = bench_encode_ns(in, size, enc, reps, variant);
+
+	kunit_info(test, "[%s] encode run : %lluns", label, t1);
+
+	u64 t2 = bench_decode_ns(enc, enc_len, decoded, reps, variant);
+
+	kunit_info(test, "[%s] decode run : %lluns", label, t2);
+
+	kfree(in);
+	kfree(enc);
+	kfree(decoded);
+}
+
+static void base64_performance_tests(struct kunit *test)
+{
+	/* run on STD variant only */
+	run_perf_and_check(test, "64B", 64, BASE64_STD);
+	run_perf_and_check(test, "1KB", 1024, BASE64_STD);
+}
+
+/* ---------- Helpers for encode ---------- */
+static void expect_encode_ok(struct kunit *test, const u8 *src, int srclen,
+			     const char *expected, bool padding,
+			     enum base64_variant variant)
+{
+	char buf[128];
+	int encoded_len = base64_encode(src, srclen, buf, padding, variant);
+
+	buf[encoded_len] = '\0';
+
+	KUNIT_EXPECT_EQ(test, encoded_len, strlen(expected));
+	KUNIT_EXPECT_STREQ(test, buf, expected);
+}
+
+/* ---------- Helpers for decode ---------- */
+static void expect_decode_ok(struct kunit *test, const char *src,
+			     const u8 *expected, int expected_len, bool padding,
+			     enum base64_variant variant)
+{
+	u8 buf[128];
+	int decoded_len = base64_decode(src, strlen(src), buf, padding, variant);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, expected_len);
+	KUNIT_EXPECT_MEMEQ(test, buf, expected, expected_len);
+}
+
+static void expect_decode_err(struct kunit *test, const char *src,
+			      int srclen, bool padding,
+			      enum base64_variant variant)
+{
+	u8 buf[64];
+	int decoded_len = base64_decode(src, srclen, buf, padding, variant);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, -1);
+}
+
+/* ---------- Encode Tests ---------- */
+static void base64_std_encode_tests(struct kunit *test)
+{
+	/* With padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg==", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg==", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", true, BASE64_STD);
+
+	/* Extra cases with padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ==",
+			 true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=", true, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv",
+			 true, BASE64_STD);
+
+	/* Without padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", false, BASE64_STD);
+
+	/* Extra cases without padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ",
+			 false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo", false, BASE64_STD);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv",
+			 false, BASE64_STD);
+}
+
+/* ---------- Decode Tests ---------- */
+static void base64_std_decode_tests(struct kunit *test)
+{
+	/* -------- With padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, true, BASE64_STD);
+	expect_decode_ok(test, "Zg==", (const u8 *)"f", 1, true, BASE64_STD);
+	expect_decode_ok(test, "Zm8=", (const u8 *)"fo", 2, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYg==", (const u8 *)"foob", 4, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmE=", (const u8 *)"fooba", 5, true, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, true, BASE64_STD);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ==", (const u8 *)"Hello, world!", 13,
+			 true, BASE64_STD);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, true, BASE64_STD);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, true, BASE64_STD);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, true, BASE64_STD);
+	expect_decode_err(test, "Zm$=", 4, true, BASE64_STD);
+	expect_decode_err(test, "Z===", 4, true, BASE64_STD);
+	expect_decode_err(test, "Zg", 2, true, BASE64_STD);
+	expect_decode_err(test, "Zm9v====", 8, true, BASE64_STD);
+	expect_decode_err(test, "Zm==A", 5, true, BASE64_STD);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, true, BASE64_STD);
+	}
+
+	/* -------- Without padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, false, BASE64_STD);
+	expect_decode_ok(test, "Zg", (const u8 *)"f", 1, false, BASE64_STD);
+	expect_decode_ok(test, "Zm8", (const u8 *)"fo", 2, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYg", (const u8 *)"foob", 4, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmE", (const u8 *)"fooba", 5, false, BASE64_STD);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, false, BASE64_STD);
+	expect_decode_ok(test, "TWFu", (const u8 *)"Man", 3, false, BASE64_STD);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ", (const u8 *)"Hello, world!", 13,
+			 false, BASE64_STD);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, false, BASE64_STD);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, false, BASE64_STD);
+	expect_decode_ok(test, "MDEyMzQ1Njc4OSsv", (const u8 *)"0123456789+/", 12,
+			 false, BASE64_STD);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, false, BASE64_STD);
+	expect_decode_err(test, "Zm$=", 4, false, BASE64_STD);
+	expect_decode_err(test, "Z===", 4, false, BASE64_STD);
+	expect_decode_err(test, "Zg=", 3, false, BASE64_STD);
+	expect_decode_err(test, "Zm9v====", 8, false, BASE64_STD);
+	expect_decode_err(test, "Zm==v", 4, false, BASE64_STD);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, false, BASE64_STD);
+	}
+}
+
+/* ---------- Variant tests (URLSAFE / IMAP) ---------- */
+static void base64_variant_tests(struct kunit *test)
+{
+	const u8 sample1[] = { 0x00, 0xfb, 0xff, 0x7f, 0x80 };
+	char std_buf[128], url_buf[128], imap_buf[128];
+	u8 back[128];
+	int n_std, n_url, n_imap, m;
+	int i;
+
+	n_std = base64_encode(sample1, sizeof(sample1), std_buf, false, BASE64_STD);
+	n_url = base64_encode(sample1, sizeof(sample1), url_buf, false, BASE64_URLSAFE);
+	std_buf[n_std] = '\0';
+	url_buf[n_url] = '\0';
+
+	for (i = 0; i < n_std; i++) {
+		if (std_buf[i] == '+')
+			std_buf[i] = '-';
+		else if (std_buf[i] == '/')
+			std_buf[i] = '_';
+	}
+	KUNIT_EXPECT_STREQ(test, std_buf, url_buf);
+
+	m = base64_decode(url_buf, n_url, back, false, BASE64_URLSAFE);
+	KUNIT_EXPECT_EQ(test, m, (int)sizeof(sample1));
+	KUNIT_EXPECT_MEMEQ(test, back, sample1, sizeof(sample1));
+
+	n_std  = base64_encode(sample1, sizeof(sample1), std_buf, false, BASE64_STD);
+	n_imap = base64_encode(sample1, sizeof(sample1), imap_buf, false, BASE64_IMAP);
+	std_buf[n_std]   = '\0';
+	imap_buf[n_imap] = '\0';
+
+	for (i = 0; i < n_std; i++)
+		if (std_buf[i] == '/')
+			std_buf[i] = ',';
+	KUNIT_EXPECT_STREQ(test, std_buf, imap_buf);
+
+	m = base64_decode(imap_buf, n_imap, back, false, BASE64_IMAP);
+	KUNIT_EXPECT_EQ(test, m, (int)sizeof(sample1));
+	KUNIT_EXPECT_MEMEQ(test, back, sample1, sizeof(sample1));
+
+	{
+		const char *bad = "Zg==";
+		u8 tmp[8];
+
+		m = base64_decode(bad, strlen(bad), tmp, false, BASE64_URLSAFE);
+		KUNIT_EXPECT_EQ(test, m, -1);
+
+		m = base64_decode(bad, strlen(bad), tmp, false, BASE64_IMAP);
+		KUNIT_EXPECT_EQ(test, m, -1);
+	}
+}
+
+/* ---------- Test registration ---------- */
+static struct kunit_case base64_test_cases[] = {
+	KUNIT_CASE(base64_performance_tests),
+	KUNIT_CASE(base64_std_encode_tests),
+	KUNIT_CASE(base64_std_decode_tests),
+	KUNIT_CASE(base64_variant_tests),
+	{}
+};
+
+static struct kunit_suite base64_test_suite = {
+	.name = "base64",
+	.test_cases = base64_test_cases,
+};
+
+kunit_test_suite(base64_test_suite);
+
+MODULE_AUTHOR("Guan-Chun Wu <409411716@gms.tku.edu.tw>");
+MODULE_DESCRIPTION("KUnit tests for Base64 encoding/decoding, including performance checks");
+MODULE_LICENSE("GPL");
-- 
2.34.1


