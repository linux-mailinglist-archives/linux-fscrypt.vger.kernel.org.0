Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8156B2B5355
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 21:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgKPU4y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 15:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732795AbgKPU4y (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 15:56:54 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F8C222240;
        Mon, 16 Nov 2020 20:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560213;
        bh=tnCWqz5mv9N+tjIZpt+ot7OQ3T3nGlBnJyM/HIOJlJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RaoLPKrJX5gxoac5D8ERKzS4gxbfZIqeb//nKfl+i9t3O3uyNf8Iv7xGEwzjoJjFe
         +2YcTBwyRZJcEQP9KgBqjzFLSndvqCtwTUffvPL1D31SRqspf5UK+qDRjQXAqtPlVH
         PgSaljdPGz6e2E5YTlcwYZ8lNBb5si0LYXDmN5fk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH v2 1/4] programs/fsverity: change default block size from PAGE_SIZE to 4096
Date:   Mon, 16 Nov 2020 12:56:25 -0800
Message-Id: <20201116205628.262173-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
References: <20201116205628.262173-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Even though the kernel currently only supports PAGE_SIZE == Merkle tree
block size, PAGE_SIZE isn't a good default Merkle tree block size for
fsverity-utils, since it means that if someone doesn't explicitly
specify the block size, then the results of 'fsverity sign' and
'fsverity enable' will differ between different architectures.

So change the default Merkle tree block size to 4096, which is the most
common PAGE_SIZE.  This will break anyone using the fsverity program
without the --block-size option on an architecture with a non-4K page
size.  But I don't think anyone is actually doing that yet anyway.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/cmd_digest.c |  2 +-
 programs/cmd_enable.c |  2 +-
 programs/cmd_sign.c   |  2 +-
 programs/fsverity.c   | 14 --------------
 programs/fsverity.h   |  1 -
 5 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 180f438..7899b04 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -90,7 +90,7 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
 
 	if (tree_params.block_size == 0)
-		tree_params.block_size = get_default_block_size();
+		tree_params.block_size = 4096;
 
 	for (int i = 0; i < argc; i++) {
 		struct fsverity_signed_digest *d = NULL;
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index d90d208..ba5b088 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -114,7 +114,7 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
 
 	if (arg.block_size == 0)
-		arg.block_size = get_default_block_size();
+		arg.block_size = 4096;
 
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 580e4df..9cb7507 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -105,7 +105,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
 
 	if (tree_params.block_size == 0)
-		tree_params.block_size = get_default_block_size();
+		tree_params.block_size = 4096;
 
 	if (sig_params.keyfile == NULL) {
 		error_msg("Missing --key argument");
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 4a2f8df..33d0a3f 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -12,7 +12,6 @@
 #include "fsverity.h"
 
 #include <limits.h>
-#include <unistd.h>
 
 static const struct fsverity_command {
 	const char *name;
@@ -192,19 +191,6 @@ bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
 	return true;
 }
 
-u32 get_default_block_size(void)
-{
-	long n = sysconf(_SC_PAGESIZE);
-
-	if (n <= 0 || n >= INT_MAX || !is_power_of_2(n)) {
-		fprintf(stderr,
-			"Warning: invalid _SC_PAGESIZE (%ld).  Assuming 4K blocks.\n",
-			n);
-		return 4096;
-	}
-	return n;
-}
-
 int main(int argc, char *argv[])
 {
 	const struct fsverity_command *cmd;
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 669fef2..2af5527 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -46,6 +46,5 @@ void usage(const struct fsverity_command *cmd, FILE *fp);
 bool parse_hash_alg_option(const char *arg, u32 *alg_ptr);
 bool parse_block_size_option(const char *arg, u32 *size_ptr);
 bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
-u32 get_default_block_size(void);
 
 #endif /* PROGRAMS_FSVERITY_H */
-- 
2.29.2

