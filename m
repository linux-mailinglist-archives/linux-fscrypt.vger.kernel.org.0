Return-Path: <linux-fscrypt+bounces-846-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 251C0BA296B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 08:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B484173358
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Sep 2025 06:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D6027EFFE;
	Fri, 26 Sep 2025 06:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="f7Z4MxIs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696AE27D784
	for <linux-fscrypt@vger.kernel.org>; Fri, 26 Sep 2025 06:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758869809; cv=none; b=hKv/3zW7kkF+i1PlVjitx7c3oDdXEVSsLEPmImi/0u8Pte9MpsviIdHCRJ4VOx6KpWfPLyesQUrJ7iyO91VCR5dZtlCquCgeAm3wr91oi9F+dY9eMLW1pksJgAUsaaN6becTcxcGlZDujNB5TSpXSMpOawC+dzMGrHTbv73bUic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758869809; c=relaxed/simple;
	bh=jdYdTn1+hvqCTOO8QO1zlfLzErWnI3zWGLknU8FBx8w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VWQiUvVZqbUdbJn+l136rmyvS8pTCrpoNnayHx1U4jOPwl/4Vp9Lid7fiVgOaw4G13xim+8SVtbC4S8/F1JCgS5Vwid+qLHfsWo51cyiAySjHWtMZ7AhrhPraB2IcNuFCjzSL2rTeYvvMFiBVVFU8hx+96kWmgsvioK0vKGTQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=f7Z4MxIs; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24457f581aeso18872875ad.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 25 Sep 2025 23:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1758869806; x=1759474606; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtMxni3UZTcKUY99mN8/6WhaPozi7K0URxKXIhOzWGU=;
        b=f7Z4MxIsYjpClhSQKi7i+C8iMoHszGu/gxwOKJymLF0HIdyE1YS6MJAuUtr37u4STP
         Kg5yWfLYTbzro7IoSWF/YdOAZjQ4ACJgeZIDEcnM6ywJR+Y2wI7eejKFVXF4PW8vwhYK
         MJDYf0Ka2hsx0yd1NDvjec0dKGGQRp3rQuqRAY/Mu487/IJ74tKUSLve1YHXII1bQRPA
         OzNo9TXecvPAFT9ikNa+/N4wbgEarQ+0vi7jgZfZ150TsLLyiOPJ/SjA0FXNIumWtvTC
         124GpqGWLPCbLRTGnyfSB4fUEfOdVO0B5/XchbdEhpzlCUChb/kGtMj5ojE4SUZ671XX
         tcDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758869806; x=1759474606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TtMxni3UZTcKUY99mN8/6WhaPozi7K0URxKXIhOzWGU=;
        b=DiavnkQlzSoVPzs4/Cf0BMLOYcui3fTULwbyj7mKjN/lH4CKIQPEwluQrNaIL/PeFe
         ygtcAAt+t5iufUqy3ncrufiMqdfndOx120edDImCHCnpcHvx/gSqSXpY6nBDBhWeFe8H
         DHHn0w25qCYKnKapL950o1aKRIXqnovCr8PdPPZefiKOiP8Joh+wddrYxL6VdgUQLgZM
         Xhm2eJG3TlqBoJ36m7kKAEpQgMwARpALSkO9uR1hcOtAjMf3Rqx6qRJG5tfU/X/bPIaW
         O8fbN3r3XhFu9MnSgtEyPHZGWGaryLmWJzQBNvnwWhOFp8CL5t5t8hRiXYfo6IXTOPmS
         wJNA==
X-Forwarded-Encrypted: i=1; AJvYcCXQYV1F0yg4wtSYXG7rE1MgjvMxiaZA39a7aH5AwaC/doMWTgDEvG6bJasD8YqNa8hpN4eqNca+UnLN117I@vger.kernel.org
X-Gm-Message-State: AOJu0YyvoGn4+tI3wy4xw7Gu9fl5sNSI/btjHbcSmUd1CC/v/rq8nOJx
	Zlb7cmxRfPWzW+lrNV4oNAGEALcb2LMrFDD7EJ0sSVIJQfc45brA3vEu2w5L8GNRX74=
X-Gm-Gg: ASbGnctZ2qDD2BM+mgJ1y4VD/Azzi6KA8sD9btwDkfeGYC1dXjaGxPZ97TfWxiiAphU
	CETaoYlk0fx0nyhYaBGIzEBU82bQ4rPdyR+jSfdibdm+aH/QWqztWAkNtmouHXHkRah0Yp/w+Z/
	Pt2wqZx42Ujwqzb9qlNFuxhNrIPq8/owDGauwrTDB4OGFiRTsx/LyiAojQr7z98d2CethPe634X
	pTN1KC5hoKFKJlj16vVpcwQKqmi5HNArZwpVPS2lRHIxCiCmu4GjoYMiChYlASIbfrKjNncr+tT
	eBCtucbqorU7SWpHy4lAeWVlhWHkAMjS0EbaWAuiLOE0jL5cB9WdAG2QSUgHC2ntEnggrJfVkdf
	+jt8m3IQeAOuNy1VO4B1E2NcqXmxROqqcwnnoHOmVZzju1Jg=
X-Google-Smtp-Source: AGHT+IE4JrK/hVqmOvlFOQG3KOukxxPTgXT7tn0oKkRM/rsF9Q+oUR1eHke18YdvIWt0KHYTrSPSPA==
X-Received: by 2002:a17:902:d4c3:b0:265:57dc:977b with SMTP id d9443c01a7336-27ed4aea9d1mr66943015ad.61.1758869805711;
        Thu, 25 Sep 2025 23:56:45 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T.. ([2001:288:7001:2703:94ad:363a:4161:464c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6882133sm45029085ad.89.2025.09.25.23.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 23:56:44 -0700 (PDT)
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
Subject: [PATCH v3 4/6] lib: add KUnit tests for base64 encoding/decoding
Date: Fri, 26 Sep 2025 14:56:39 +0800
Message-Id: <20250926065639.14455-1-409411716@gms.tku.edu.tw>
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
    # base64_performance_tests: [64B] decode run : 64ns
    # base64_performance_tests: [1KB] encode run : 510ns
    # base64_performance_tests: [1KB] decode run : 980ns
    ok 1 base64_performance_tests
    ok 2 base64_std_encode_tests
    ok 3 base64_std_decode_tests
    ok 4 base64_variant_tests
    # base64: pass:4 fail:0 skip:0 total:4
    # Totals: pass:4 fail:0 skip:0 total:4

Signed-off-by: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Reviewed-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 lib/Kconfig.debug        |  19 ++-
 lib/tests/Makefile       |   1 +
 lib/tests/base64_kunit.c | 294 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 313 insertions(+), 1 deletion(-)
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
index 000000000..f7252070c
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


