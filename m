Return-Path: <linux-fscrypt+bounces-812-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CCFAB52A09
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 09:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C8975189DC4B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 07:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4746526F287;
	Thu, 11 Sep 2025 07:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="TtBYmA46"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80278329F11
	for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 07:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757575970; cv=none; b=ngOXMnCudh1ZWlDC6XpMWhVw/UvtbFqeLrUitMMDEZgBjLHy3xReOW+5IbNExs5BvpGajIlG+xeKHYnS6oZjSzha2+vGiezoAuLSa1/SI+VeQ6ab5nSg/eIVLJzx0jBrekICrKn1t7lK3gTaSrrmvJU07bMjhZIpxB1gds5M+lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757575970; c=relaxed/simple;
	bh=AAz7YSSQv6u7ioBYlTXmetOdmobu2QVMJYFy3LfyNpU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D1RYcyzmTyFjZ5qrpXelrAG55ng9+WAEuaSKZitr9udcyhZ1IP3yIqoDKyyLmgRcNZGLbJ8prYRyhfwnsVlRYZecHbqhhaVeWJB/O8KMZLHrnh4JUSP0QKcMCFyiWcJqmaKEylckTWQzGEIQnwcE4h8LZtad6y7InbSOARh/VyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=TtBYmA46; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32b5d3e1762so298664a91.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 11 Sep 2025 00:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757575967; x=1758180767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7s0darRmpAoSF4AYzaEAKr+Som3Rl5+XVaBmiwsyicM=;
        b=TtBYmA466fMxBDhpgY3ASv7uB4OuAIO6pFXOK9g9WQg1elHohrkOaYJsDmOpNuG57h
         Z3jpsiqgaP4GqKznTp/v9bIa5rtiQ4gArDCfaAgCmjMDo4eSH44EbP+BIvijU4xv+CeP
         2mHOrf10Kf+Osi5GJ81r5GaKPMjV745YiybEVQx5YiGF3P3il4V1P4HfciPejAkp78I0
         Dcs4UCjbplq0y+Ol99fIZxwJ32vgJlhKBApMNY9EbfX1mO35LbasyLLeYuSCH8scQhVp
         rlaEL85DZ968tnU6eYM68twio+nB4NiQ/TM7Zd++zgU5Yfkl3rCrNCoJImOtbZV8xdNW
         JsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757575967; x=1758180767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7s0darRmpAoSF4AYzaEAKr+Som3Rl5+XVaBmiwsyicM=;
        b=WewHWkXTy1qepU7zq3cbFLKby6pIQZ/CLae8nAGgYi0kfhWkhh+j06bq6apaE2SG2N
         +LDE+zcUa2/oHJqjKb9xuZNaX2fMeTvRE50vB4sAlgXajoXGMcL9NqEQB4oy6fF2af3L
         QxtU/XakS7drWh9pzLwACQhN268U7zncX4bQQIr6+shwPcJnbC0nz+1ZGZRAFuFqajOH
         Vu3conqVRKafRcBDXLYygPZObbU9ntR1j2LvvVWKB4WtpDmr4P9uFRQzXMwb76RyWnha
         XKdlVTiU3Bg40Wtx1gMZLeJirK+08mxpqjRj6bxZT6/MNdftz3TLHlaANx9K6rXwBqkF
         Rx5g==
X-Forwarded-Encrypted: i=1; AJvYcCXMrpip81evDlR/VuntGqqtuX58uBBRShRIDl9MuyTuufQLXkJUTy0BsrEM3vstAVXDuf527ihenghCnUc8@vger.kernel.org
X-Gm-Message-State: AOJu0YxNE1oL/QiPaG5f6ofvl6gqZy1u5e/kulTPxxoNXaQp/fejBbwt
	ypG7dkrLL7N9PiiTE77ZbU8nYqIazb5wVG06v+Ss3BUVY1FIDMPZ6o+IRbsCMuN04U0=
X-Gm-Gg: ASbGncvi08Bm+QlMQzDasJjx3aXEYoqvJQaxSFYafkPDjetOqE4IfSZCZeaSM6xf2W5
	PjhBDE/a/9ccfrz1gI720Upj7OHt3u5whlr5msd+g3QmE4lEPm2ySCE2FNybysvaQyIDNI6YPes
	JoDaanRm/Q98C9fgJzWLx3/c+7mPSH3Hx9e0E7PhLLiTEc+d42UjkAtCFaTrAjPGL6Cqws5pftr
	oOFvp/WXHLk4OxDexAG29mUGoyyd3RIx7EkBGHCJSQkOH8J7QJ+bHxASZRdxPkfW8Uj6OOF2Aqp
	kpsXYDOawW5QNI6tvyp4qgcx1U5y+3xzqUNoFdJidSCZ0vzTXQ+q1ZDE7vVxK/KywdTWQsiS86C
	8rKSVAHByX3MyxITwWsHELPWxG3qJos7q9l4kg7iWhBQJ37UVUVuZfTzJVQ==
X-Google-Smtp-Source: AGHT+IGdM58j9g1OKoy52eIFNUxwwbvD1pYUiG/9o0Yq0NDk3xchY26I1yfT4KFiKTdndSxHjuBo7Q==
X-Received: by 2002:a17:90b:1d8f:b0:329:e4d1:c20f with SMTP id 98e67ed59e1d1-32d43eff84dmr22396284a91.9.1757575966592;
        Thu, 11 Sep 2025 00:32:46 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:7811:c085:c184:85be])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd61eaa50sm1627799a91.6.2025.09.11.00.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 00:32:45 -0700 (PDT)
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: kbusch@kernel.org,
	axboe@kernel.dk,
	hch@lst.de,
	sagi@grimberg.me,
	xiubli@redhat.com,
	idryomov@gmail.com,
	ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	akpm@linux-foundation.org
Cc: visitorckw@gmail.com,
	home7438072@gmail.com,
	409411716@gms.tku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 3/5] lib: add KUnit tests for base64 encoding/decoding
Date: Thu, 11 Sep 2025 15:32:39 +0800
Message-Id: <20250911073239.579643-1-409411716@gms.tku.edu.tw>
X-Mailer: git-send-email 2.34.1
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


