Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B040F39AB37
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jun 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhFCUCB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 16:02:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhFCUBv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 16:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 155F7613F8;
        Thu,  3 Jun 2021 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750406;
        bh=FyxqNFXOsJAjD5ZjY8O3sH1AcSKIs+m3wBMDe7VatAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQHwyOVllvBMZvrrjEa1EiRpo/5aexnE9PrwMuEOgr5tG9FOBdD1o+PjhK9jQzJNe
         8AdS0k1XxaB1s4CnFOrgytKqcErJI/BEozLpqzEYUhMwbtudacxOMFDCYcY3mcR+pM
         V5ZYClD+i0vNzRYwrUNV/N6lVEFEFF1NHkBWbicwXktphy841KtF2aBZ3GggwEhX2t
         p1zsl5LELMtoF7KZvUtB2SQ8n47cqvPye4DCb4vNQZ7IZ+lcPX8iL3G9ODxgZx2ze8
         lpBArrM7mEo9bj6vHv2Xa9Hn7SQrjOeA7aztenlKyd86raCQjQFLSgffDVqlYkZn+D
         NgQVp1BwyL4+Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH 2/4] programs/test_compute_digest: test the metadata callbacks
Date:   Thu,  3 Jun 2021 12:58:10 -0700
Message-Id: <20210603195812.50838-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
References: <20210603195812.50838-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test that the libfsverity_metadata_callbacks support seems to be working
correctly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/test_compute_digest.c | 133 +++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/programs/test_compute_digest.c b/programs/test_compute_digest.c
index e7f2645..67266fa 100644
--- a/programs/test_compute_digest.c
+++ b/programs/test_compute_digest.c
@@ -13,6 +13,7 @@
 
 #include <ctype.h>
 #include <inttypes.h>
+#include <openssl/sha.h>
 
 struct mem_file {
 	u8 *data;
@@ -37,6 +38,13 @@ static int error_read_fn(void *fd __attribute__((unused)),
 	return -EIO;
 }
 
+static int zeroes_read_fn(void *fd __attribute__((unused)),
+			  void *buf, size_t count)
+{
+	memset(buf, 0, count);
+	return 0;
+}
+
 static const struct test_case {
 	u32 hash_algorithm;
 	u32 block_size;
@@ -249,6 +257,130 @@ static void test_invalid_params(void)
 	ASSERT(d == NULL);
 }
 
+static struct {
+	u64 merkle_tree_size;
+	u64 merkle_tree_block;
+	u64 descriptor;
+} metadata_callback_counts;
+
+static int handle_merkle_tree_size(void *ctx, u64 size)
+{
+	metadata_callback_counts.merkle_tree_size++;
+
+	/* Test that the ctx argument is passed through correctly. */
+	ASSERT(ctx == (void *)1);
+
+	/* Test that the expected Merkle tree size is reported. */
+	ASSERT(size == 5 * 1024);
+	return 0;
+}
+
+static int handle_merkle_tree_block(void *ctx, const void *block, size_t size,
+				    u64 offset)
+{
+	u8 digest[SHA256_DIGEST_LENGTH];
+	u64 count = metadata_callback_counts.merkle_tree_block++;
+	const char *expected_digest;
+
+	/* Test that ->merkle_tree_size() was called first. */
+	ASSERT(metadata_callback_counts.merkle_tree_size == 1);
+
+	/* Test that the ctx argument is passed through correctly. */
+	ASSERT(ctx == (void *)1);
+
+	/*
+	 * Test that this Merkle tree block has the expected size, offset, and
+	 * contents.  The 4 blocks at "level 0" should be reported first, in
+	 * order; then the 1 block at "level 1" should be reported last (but the
+	 * level 1 block should have the smallest offset).
+	 */
+	ASSERT(size == 1024);
+	SHA256(block, size, digest);
+	if (count == 4) {
+		/* 1 block at level 1 */
+		ASSERT(offset == 0);
+		expected_digest = "\x68\xc5\x38\xe1\x19\x58\xd6\x5d"
+				  "\x68\xb6\xfe\x8e\x9f\xb8\xcc\xab"
+				  "\xec\xfd\x92\x8b\x01\xd0\x63\x44"
+				  "\xe2\x23\xed\x41\xdd\xc4\x54\x4a";
+	} else {
+		/* 4 blocks at level 0 */
+		ASSERT(offset == 1024 + (count * 1024));
+		if (count < 3) {
+			expected_digest = "\xf7\x89\xba\xab\x53\x85\x9f\xaf"
+					  "\x36\xd6\xd7\x5d\x10\x42\x06\x42"
+					  "\x94\x20\x2d\x6e\x13\xe7\x71\x6f"
+					  "\x39\x4f\xba\x43\x4c\xcc\x49\x86";
+		} else {
+			expected_digest = "\x00\xfe\xd0\x3c\x5d\x6e\xab\x21"
+					  "\x31\x43\xf3\xd9\x6a\x5c\xa3\x1c"
+					  "\x2b\x89\xf5\x68\x4e\x6c\x8e\x07"
+					  "\x87\x3e\x5e\x97\x65\x17\xb4\x8f";
+		}
+	}
+	ASSERT(!memcmp(digest, expected_digest, SHA256_DIGEST_LENGTH));
+	return 0;
+}
+
+static const u8 expected_file_digest[SHA256_DIGEST_LENGTH] =
+	"\x09\xcb\xba\xee\xd2\xa0\x4c\x2d\xa2\x42\xc1\x0e\x15\x68\xd9\x6f"
+	"\x35\x8a\x16\xaa\x1e\xbe\x8c\xf0\x28\x61\x20\xc1\x3c\x93\x66\xd1";
+
+static int handle_descriptor(void *ctx, const void *descriptor, size_t size)
+{
+	u8 digest[SHA256_DIGEST_LENGTH];
+
+	metadata_callback_counts.descriptor++;
+	/* Test that the ctx argument is passed through correctly. */
+	ASSERT(ctx == (void *)1);
+
+	/* Test that the fs-verity descriptor is reported correctly. */
+	ASSERT(size == 256);
+	SHA256(descriptor, size, digest);
+	ASSERT(!memcmp(digest, expected_file_digest, SHA256_DIGEST_LENGTH));
+	return 0;
+}
+
+static const struct libfsverity_metadata_callbacks metadata_callbacks = {
+	.ctx = (void *)1, /* arbitrary value for testing purposes */
+	.merkle_tree_size = handle_merkle_tree_size,
+	.merkle_tree_block = handle_merkle_tree_block,
+	.descriptor = handle_descriptor,
+};
+
+/* Test that the libfsverity_metadata_callbacks work correctly. */
+static void test_metadata_callbacks(void)
+{
+	/*
+	 * For a useful test, we want a file whose Merkle tree will have at
+	 * least 2 levels (this one will have exactly 2).  The contents of the
+	 * file aren't too important.
+	 */
+	struct libfsverity_merkle_tree_params params = {
+		.version = 1,
+		.hash_algorithm = FS_VERITY_HASH_ALG_SHA256,
+		.block_size = 1024,
+		.file_size = 100000,
+		.metadata_callbacks = &metadata_callbacks,
+	};
+	struct libfsverity_digest *d;
+
+	ASSERT(libfsverity_compute_digest(NULL, zeroes_read_fn,
+					  &params, &d) == 0);
+
+	/* Test that the callbacks were called the correct number of times. */
+	ASSERT(metadata_callback_counts.merkle_tree_size == 1);
+	ASSERT(metadata_callback_counts.merkle_tree_block == 5);
+	ASSERT(metadata_callback_counts.descriptor == 1);
+
+	/* Test that the computed file digest is as expected. */
+	ASSERT(d->digest_algorithm == FS_VERITY_HASH_ALG_SHA256);
+	ASSERT(d->digest_size == SHA256_DIGEST_LENGTH);
+	ASSERT(!memcmp(d->digest, expected_file_digest, SHA256_DIGEST_LENGTH));
+
+	free(d);
+}
+
 int main(int argc, char *argv[])
 {
 	const bool update = (argc == 2 && !strcmp(argv[1], "--update"));
@@ -305,6 +437,7 @@ int main(int argc, char *argv[])
 	}
 
 	test_invalid_params();
+	test_metadata_callbacks();
 	printf("test_compute_digest passed\n");
 	return 0;
 }
-- 
2.31.1

