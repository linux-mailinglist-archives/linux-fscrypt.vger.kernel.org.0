Return-Path: <linux-fscrypt+bounces-816-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FBA8B52A61
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A1B03ACAD1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:45:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBA12848A9;
	Thu, 11 Sep 2025 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="hMJJi4gP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0DA283C90
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757576725; cv=none; b=d7VDwNebgmv5IZBtQCzTTD8KLAu+HViOAkGtAMeHKap7Jvpi3+kCqGj0gsMHqiOgElzrlXLj0yMNpTp+BRyhs2pUFy1rXIUc9zv1X+uZU777wpRLRcUVOzYp7KbKKU7In7CYtZUpaZue7FhwcxyGJXZMXoU7Dxj3zYMvtZDtX34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757576725; c=relaxed/simple;
	bh=AAz7YSSQv6u7ioBYlTXmetOdmobu2QVMJYFy3LfyNpU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rKZWjKWpOxRv6ZQ+LfMIgKwzmyLNwU7qvIkK6ymw3vNdQdVwI2TTYUJ+aJhiQvg6wLl/QzwZejPGBYuk1lop1sp7b7YSyUdxRU7LL5QCf9bwQ6Kj6dJo8K0sPbEqN7aDyGYYdyiznC/EvGh2miRmu978XxKE8aPl1JoKsVxM9Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=hMJJi4gP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-25634c5ebdeso3420805ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757576723; x=1758181523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7s0darRmpAoSF4AYzaEAKr+Som3Rl5+XVaBmiwsyicM=;
        b=hMJJi4gPSXcBkN/JJqody53gUiKdmJv2dZbHb0MDHSo2KksGh8eXH7Qp2fwfhuyJjF
         tNY8EYWmR8SmOA2vufr4wxYzKVhvpFat/ANKvKviUw7uKDiB12lwNTVuhgWw7REfUlEd
         FUZOtGE9Ro1q8I0HOYMnoBE2UDDj8PsuauOfJ9KvjgBbDnZE2FAFZ/3WR7KiQeABNWXC
         SEvr5hBoiTu6At7yFNsXMDK5pUc1Iw5zbu8R6ZVEzf8ky/sOpwhBBpq5Ida7CzBLbfGJ
         BxM3ZlFTxBoYG+3SpyKT8le1ujbhWLPFUd0U4aRLXnfHQA9eM14AHAACpD34dp1fPTrV
         YoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757576723; x=1758181523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7s0darRmpAoSF4AYzaEAKr+Som3Rl5+XVaBmiwsyicM=;
        b=TO2Mohobv85cjYxqeEdxdPc1yS0oJ49K+lNpuGDfdicn4qeqmm0UmY0cYSVsIRnpPO
         Cn/g/RKXhdvw0eUKj/AN+Mc84c07SuZITrTfBpgbNcnIJw8O2QZ0q4ybr9pS6MZ93mCI
         w4W6K1zdTPvGxUeAmTeEdZZ2+c6GCKkk3qU/mMNNFSlf/MI1fcQHaCyga6OUsybXQSTG
         v+bFfZeBqMJmLbeNSLhLS6z3cfgkGu+iCgTYWIIaxz1ERwUC3KZHGotk2niGz32pBqNF
         kJo77GDd7qu4uFp/MU54GXg3zpVErtqED1tQnZD8vcyYSmxRBg0yqzp0rbmpvKpz2idO
         OmSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdrPXQt+qO05x3igLXacPeaONU6N3Fa8sMjIvJhrYRUZU7nj1rVTEdcKHHRIfuwP2G0BnryMUkn9EEMoCM@vger.kernel.org
X-Gm-Message-State: AOJu0YyZwEoHBxDfAFQ2SqK3JVYxmYp04pwzFxDOtzyyI6N2WEVzuJ0u
	RTwAQGD2aUBKa6CiNRVC3jYGP4awkVgLOdY6BOGnwu77g5mqmTCcigMJRwCdQheaAGo=
X-Gm-Gg: ASbGncuJjb4YDDdL2tQ/trZvvtQ9hZu6UGkpcRvmssxFOQUb6tkkd3Z+8zL1mS9mv8t
	lE237RzsrcCI/D5Fhr8Gwajy7Lbbt5dU0qvhT5VfclDXqBDIm0n5omrTU//i91QVq1XdaHzeD+k
	7crLWkorZ/nU1H+7CPZL8qXs7nXMtrMWhP/eXDWDUhk9iIFt3D7X0OuKj6xoNlfSJ8cxweOuojy
	546rUbdvDsJ9aJ3ei2rDlk7p4UgqkFJw2hUk0+JwWCA4FcSvULs+RsaboWyKLwrpUcVMdPKqH/Q
	EvFLxne3HyZVcy2gqbBCbv8syhtC8KvmwDNZ+fCky144oN+csoh9TrtFZVkwO6FBnB5XI1R81vC
	IVljU/voArhO1TDcORp1KhfKqmlleGOEY5OnPWQT/eOHscT8=
X-Google-Smtp-Source: AGHT+IEqJNXLNJAINV677IYIL5EReMelpFkf7dFD6n7F4RIuL6WJn8Kv9Y6X1eDhV8xZE+Ct5kotng==
X-Received: by 2002:a17:902:ea06:b0:24c:e6fa:2a3b with SMTP id d9443c01a7336-25170e41037mr262573745ad.38.1757576722587;
        Thu, 11 Sep 2025 00:45:22 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37294b44sm10499645ad.45.2025.09.11.00.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:45:21 -0700 (PDT)
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
Subject: [PATCH v2 3/5] lib: add KUnit tests for base64 encoding/decoding
Date: Thu, 11 Sep 2025 15:45:10 +0800
Message-Id: <20250911074510.685568-1-409411716@gms.tku.edu.tw>
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

Add a KUnit test suite for the base64 helpers. The tests exercise both
encoding and decoding, cover padded and unpadded forms per RFC 4648, and
include negative cases for malformed inputs and padding errors. The suite
also validates behavior with a caller-supplied encoding table.

In addition to functional checks, the suite includes simple microbenchmarks
which report average encode/decode latency for small (64B) and larger (1KB)
inputs. These numbers are informational only and do not gate the tests.

Kconfig (BASE64_KUNIT) and lib/tests/Makefile are updated accordingly.

Sample KUnit output:

    KTAP version 1
    # Subtest: base64
    # module: base64_kunit
    1..3
    # base64_performance_tests: [64B] encode run : 32ns
    # base64_performance_tests: [64B] decode run : 122ns
    # base64_performance_tests: [1KB] encode run : 507ns
    # base64_performance_tests: [1KB] decode run : 1870ns
    ok 1 base64_performance_tests
    ok 2 base64_encode_tests
    ok 3 base64_decode_tests
    # base64: pass:3 fail:0 skip:0 total:3
    # Totals: pass:3 fail:0 skip:0 total:3

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 lib/Kconfig.debug        |  19 +++-
 lib/tests/Makefile       |   1 +
 lib/tests/base64_kunit.c | 230 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 1 deletion(-)
 create mode 100644 lib/tests/base64_kunit.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dc0e0c6ed..1cfb12d02 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2794,8 +2794,25 @@ config CMDLINE_KUNIT_TEST
 
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
index fa6d728a8..6593a2873 100644
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
index 000000000..1941ac504
--- /dev/null
+++ b/lib/tests/base64_kunit.c
@@ -0,0 +1,230 @@
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
+static const char base64_table[65] =
+	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
+
+/* ---------- Benchmark helpers ---------- */
+static u64 bench_encode_ns(const u8 *data, int len, char *dst, int reps)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_encode(data, len, dst, true, base64_table);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static u64 bench_decode_ns(const char *data, int len, u8 *dst, int reps)
+{
+	u64 t0, t1;
+
+	t0 = ktime_get_ns();
+	for (int i = 0; i < reps; i++)
+		base64_decode(data, len, dst, true, base64_table);
+	t1 = ktime_get_ns();
+
+	return div64_u64(t1 - t0, (u64)reps);
+}
+
+static void run_perf_and_check(struct kunit *test, const char *label, int size)
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
+	int enc_len = base64_encode(in, size, enc, true, base64_table);
+	int dec_len = base64_decode(enc, enc_len, decoded, true, base64_table);
+
+	/* correctness sanity check */
+	KUNIT_EXPECT_EQ(test, dec_len, size);
+	KUNIT_EXPECT_MEMEQ(test, decoded, in, size);
+
+	/* benchmark encode */
+
+	u64 t1 = bench_encode_ns(in, size, enc, reps);
+
+	kunit_info(test, "[%s] encode run : %lluns", label, t1);
+
+	u64 t2 = bench_decode_ns(enc, enc_len, decoded, reps);
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
+	run_perf_and_check(test, "64B", 64);
+	run_perf_and_check(test, "1KB", 1024);
+}
+
+/* ---------- Helpers for encode ---------- */
+static void expect_encode_ok(struct kunit *test, const u8 *src, int srclen,
+			     const char *expected, bool padding)
+{
+	char buf[128];
+	int encoded_len = base64_encode(src, srclen, buf, padding, base64_table);
+
+	buf[encoded_len] = '\0';
+
+	KUNIT_EXPECT_EQ(test, encoded_len, strlen(expected));
+	KUNIT_EXPECT_STREQ(test, buf, expected);
+}
+
+/* ---------- Helpers for decode ---------- */
+static void expect_decode_ok(struct kunit *test, const char *src,
+			     const u8 *expected, int expected_len, bool padding)
+{
+	u8 buf[128];
+	int decoded_len = base64_decode(src, strlen(src), buf, padding, base64_table);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, expected_len);
+	KUNIT_EXPECT_MEMEQ(test, buf, expected, expected_len);
+}
+
+static void expect_decode_err(struct kunit *test, const char *src,
+			      int srclen, bool padding)
+{
+	u8 buf[64];
+	int decoded_len = base64_decode(src, srclen, buf, padding, base64_table);
+
+	KUNIT_EXPECT_EQ(test, decoded_len, -1);
+}
+
+/* ---------- Encode Tests ---------- */
+static void base64_encode_tests(struct kunit *test)
+{
+	/* With padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", true);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg==", true);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8=", true);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", true);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg==", true);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE=", true);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", true);
+
+	/* Extra cases with padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ==", true);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=", true);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=", true);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv", true);
+
+	/* Without padding */
+	expect_encode_ok(test, (const u8 *)"", 0, "", false);
+	expect_encode_ok(test, (const u8 *)"f", 1, "Zg", false);
+	expect_encode_ok(test, (const u8 *)"fo", 2, "Zm8", false);
+	expect_encode_ok(test, (const u8 *)"foo", 3, "Zm9v", false);
+	expect_encode_ok(test, (const u8 *)"foob", 4, "Zm9vYg", false);
+	expect_encode_ok(test, (const u8 *)"fooba", 5, "Zm9vYmE", false);
+	expect_encode_ok(test, (const u8 *)"foobar", 6, "Zm9vYmFy", false);
+
+	/* Extra cases without padding */
+	expect_encode_ok(test, (const u8 *)"Hello, world!", 13, "SGVsbG8sIHdvcmxkIQ", false);
+	expect_encode_ok(test, (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26,
+			 "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo", false);
+	expect_encode_ok(test, (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26,
+			 "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo", false);
+	expect_encode_ok(test, (const u8 *)"0123456789+/", 12, "MDEyMzQ1Njc4OSsv", false);
+}
+
+/* ---------- Decode Tests ---------- */
+static void base64_decode_tests(struct kunit *test)
+{
+	/* -------- With padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, true);
+	expect_decode_ok(test, "Zg==", (const u8 *)"f", 1, true);
+	expect_decode_ok(test, "Zm8=", (const u8 *)"fo", 2, true);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, true);
+	expect_decode_ok(test, "Zm9vYg==", (const u8 *)"foob", 4, true);
+	expect_decode_ok(test, "Zm9vYmE=", (const u8 *)"fooba", 5, true);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, true);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ==", (const u8 *)"Hello, world!", 13, true);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo=",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, true);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, true);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, true);
+	expect_decode_err(test, "Zm$=", 4, true);
+	expect_decode_err(test, "Z===", 4, true);
+	expect_decode_err(test, "Zg", 2, true);
+	expect_decode_err(test, "Zm9v====", 8, true);
+	expect_decode_err(test, "Zm==A", 5, true);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, true);
+	}
+
+	/* -------- Without padding --------*/
+	expect_decode_ok(test, "", (const u8 *)"", 0, false);
+	expect_decode_ok(test, "Zg", (const u8 *)"f", 1, false);
+	expect_decode_ok(test, "Zm8", (const u8 *)"fo", 2, false);
+	expect_decode_ok(test, "Zm9v", (const u8 *)"foo", 3, false);
+	expect_decode_ok(test, "Zm9vYg", (const u8 *)"foob", 4, false);
+	expect_decode_ok(test, "Zm9vYmE", (const u8 *)"fooba", 5, false);
+	expect_decode_ok(test, "Zm9vYmFy", (const u8 *)"foobar", 6, false);
+	expect_decode_ok(test, "TWFu", (const u8 *)"Man", 3, false);
+	expect_decode_ok(test, "SGVsbG8sIHdvcmxkIQ", (const u8 *)"Hello, world!", 13, false);
+	expect_decode_ok(test, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVo",
+			 (const u8 *)"ABCDEFGHIJKLMNOPQRSTUVWXYZ", 26, false);
+	expect_decode_ok(test, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo",
+			 (const u8 *)"abcdefghijklmnopqrstuvwxyz", 26, false);
+	expect_decode_ok(test, "MDEyMzQ1Njc4OSsv", (const u8 *)"0123456789+/", 12, false);
+
+	/* Error cases */
+	expect_decode_err(test, "Zg=!", 4, false);
+	expect_decode_err(test, "Zm$=", 4, false);
+	expect_decode_err(test, "Z===", 4, false);
+	expect_decode_err(test, "Zg=", 3, false);
+	expect_decode_err(test, "Zm9v====", 8, false);
+	expect_decode_err(test, "Zm==v", 4, false);
+
+	{
+		char with_nul[4] = { 'Z', 'g', '\0', '=' };
+
+		expect_decode_err(test, with_nul, 4, false);
+	}
+}
+
+/* ---------- Test registration ---------- */
+static struct kunit_case base64_test_cases[] = {
+	KUNIT_CASE(base64_performance_tests),
+	KUNIT_CASE(base64_encode_tests),
+	KUNIT_CASE(base64_decode_tests),
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


