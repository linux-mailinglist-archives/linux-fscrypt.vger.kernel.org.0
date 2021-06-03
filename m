Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25E39AB35
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jun 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFCUCC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 16:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229719AbhFCUBv (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 16:01:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B344613FE;
        Thu,  3 Jun 2021 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622750406;
        bh=c0q/URWzQL/okWIW3plDW5iYWAcntGTdVpR0B7lCjNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggQjPXUe+eZ6gJ62JiG8G2C3Mq3CTcF8doqhYpS8Gics48bwdMO1VsRSjd9ONaXvJ
         ssLSC4yZRkptuv2uAOSRKTqUekArZsPku3u5c7HhtgWRyrCjzWqHVt1R9RRF7kvJym
         CJfZBbFFtg0seRqpo0EqPz5aHjYOYuft9Fzl0Cv8x6v3VpenKu1DQRpfOU+8s/Aem7
         X/cxbb40G2Gy4J9sroRoaUm2/yarPIZjGcN+YF7Ba6G+fNAg5n18Txn6bsP0qMvtg1
         wJBYc+WCrrY3ZZp7Pk/x/OwKK0ygy1G/rNn8/b3u7KtqQXf7iAUIUNlWDd/EIU6gUP
         q9vRpTFq+adfw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils PATCH 4/4] programs/fsverity: add --out-merkle-tree and --out-descriptor options
Date:   Thu,  3 Jun 2021 12:58:12 -0700
Message-Id: <20210603195812.50838-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603195812.50838-1-ebiggers@kernel.org>
References: <20210603195812.50838-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make 'fsverity digest' and 'fsverity sign' support writing the Merkle
tree and fs-verity descriptor to files, using new options
'--out-merkle-tree=FILE' and '--out-descriptor=FILE'.

Normally these new options aren't useful, but they can be needed in
cases where the fs-verity metadata needs to be consumed by something
other than one of the native Linux kernel implementations of fs-verity.

This is different from 'fsverity dump_metadata' in that
'fsverity dump_metadata' only works on a file with fs-verity enabled,
whereas these new options are for the userspace file digest computation.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 programs/cmd_digest.c |  7 +++-
 programs/cmd_sign.c   | 17 ++++++---
 programs/fsverity.c   | 88 ++++++++++++++++++++++++++++++++++++++++++-
 programs/fsverity.h   |  4 +-
 4 files changed, 107 insertions(+), 9 deletions(-)

diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 1a3c769..fd9f4de 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -18,6 +18,8 @@ static const struct option longopts[] = {
 	{"hash-alg",		required_argument, NULL, OPT_HASH_ALG},
 	{"block-size",		required_argument, NULL, OPT_BLOCK_SIZE},
 	{"salt",		required_argument, NULL, OPT_SALT},
+	{"out-merkle-tree",     required_argument, NULL, OPT_OUT_MERKLE_TREE},
+	{"out-descriptor",      required_argument, NULL, OPT_OUT_DESCRIPTOR},
 	{"compact",		no_argument,	   NULL, OPT_COMPACT},
 	{"for-builtin-sig",	no_argument,	   NULL, OPT_FOR_BUILTIN_SIG},
 	{NULL, 0, NULL, 0}
@@ -40,6 +42,8 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		case OPT_HASH_ALG:
 		case OPT_BLOCK_SIZE:
 		case OPT_SALT:
+		case OPT_OUT_MERKLE_TREE:
+		case OPT_OUT_DESCRIPTOR:
 			if (!parse_tree_param(c, optarg, &tree_params))
 				goto out_usage;
 			break;
@@ -114,7 +118,8 @@ int fsverity_cmd_digest(const struct fsverity_command *cmd,
 	}
 	status = 0;
 out:
-	destroy_tree_params(&tree_params);
+	if (!destroy_tree_params(&tree_params) && status == 0)
+		status = 1;
 	return status;
 
 out_err:
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 47ba6a2..81a4ddc 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -27,11 +27,13 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 }
 
 static const struct option longopts[] = {
-	{"hash-alg",	required_argument, NULL, OPT_HASH_ALG},
-	{"block-size",	required_argument, NULL, OPT_BLOCK_SIZE},
-	{"salt",	required_argument, NULL, OPT_SALT},
-	{"key",		required_argument, NULL, OPT_KEY},
-	{"cert",	required_argument, NULL, OPT_CERT},
+	{"hash-alg",	    required_argument, NULL, OPT_HASH_ALG},
+	{"block-size",	    required_argument, NULL, OPT_BLOCK_SIZE},
+	{"salt",	    required_argument, NULL, OPT_SALT},
+	{"out-merkle-tree", required_argument, NULL, OPT_OUT_MERKLE_TREE},
+	{"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
+	{"key",		    required_argument, NULL, OPT_KEY},
+	{"cert",	    required_argument, NULL, OPT_CERT},
 	{NULL, 0, NULL, 0}
 };
 
@@ -54,6 +56,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		case OPT_HASH_ALG:
 		case OPT_BLOCK_SIZE:
 		case OPT_SALT:
+		case OPT_OUT_MERKLE_TREE:
+		case OPT_OUT_DESCRIPTOR:
 			if (!parse_tree_param(c, optarg, &tree_params))
 				goto out_usage;
 			break;
@@ -117,7 +121,8 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	status = 0;
 out:
 	filedes_close(&file);
-	destroy_tree_params(&tree_params);
+	if (!destroy_tree_params(&tree_params) && status == 0)
+		status = 1;
 	free(digest);
 	free(sig);
 	return status;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 1168430..f6aff3a 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -11,6 +11,7 @@
 
 #include "fsverity.h"
 
+#include <fcntl.h>
 #include <limits.h>
 
 static const struct fsverity_command {
@@ -27,6 +28,7 @@ static const struct fsverity_command {
 		.usage_str =
 "    fsverity digest FILE...\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
+"               [--out-merkle-tree=FILE] [--out-descriptor=FILE]\n"
 "               [--compact] [--for-builtin-sig]\n"
 #ifndef _WIN32
 	}, {
@@ -58,6 +60,7 @@ static const struct fsverity_command {
 		.usage_str =
 "    fsverity sign FILE OUT_SIGFILE --key=KEYFILE\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
+"               [--out-merkle-tree=FILE] [--out-descriptor=FILE]\n"
 "               [--cert=CERTFILE]\n"
 	}
 };
@@ -200,6 +203,74 @@ static bool parse_salt_option(const char *arg, u8 **salt_ptr,
 	return true;
 }
 
+struct metadata_callback_ctx {
+	struct filedes merkle_tree_file;
+	struct filedes descriptor_file;
+	struct libfsverity_metadata_callbacks callbacks;
+};
+
+static int handle_merkle_tree_size(void *_ctx, u64 size)
+{
+	struct metadata_callback_ctx *ctx = _ctx;
+
+	if (!preallocate_file(&ctx->merkle_tree_file, size))
+		return -EIO;
+	return 0;
+}
+
+static int handle_merkle_tree_block(void *_ctx, const void *block, size_t size,
+				    u64 offset)
+{
+	struct metadata_callback_ctx *ctx = _ctx;
+
+	if (!full_pwrite(&ctx->merkle_tree_file, block, size, offset))
+		return -EIO;
+	return 0;
+}
+
+static int handle_descriptor(void *_ctx, const void *descriptor, size_t size)
+{
+	struct metadata_callback_ctx *ctx = _ctx;
+
+	if (!full_write(&ctx->descriptor_file, descriptor, size))
+		return -EIO;
+	return 0;
+}
+
+static bool parse_out_metadata_option(int opt_char, const char *arg,
+				      const struct libfsverity_metadata_callbacks **cbs)
+{
+	struct metadata_callback_ctx *ctx;
+	struct filedes *file;
+	const char *opt_name;
+
+	if (*cbs) {
+		ctx = (*cbs)->ctx;
+	} else {
+		ctx = xzalloc(sizeof(*ctx));
+		ctx->merkle_tree_file.fd = -1;
+		ctx->descriptor_file.fd = -1;
+		ctx->callbacks.ctx = ctx;
+		*cbs = &ctx->callbacks;
+	}
+
+	if (opt_char == OPT_OUT_MERKLE_TREE) {
+		file = &ctx->merkle_tree_file;
+		opt_name = "--out-merkle-tree";
+		ctx->callbacks.merkle_tree_size = handle_merkle_tree_size;
+		ctx->callbacks.merkle_tree_block = handle_merkle_tree_block;
+	} else {
+		file = &ctx->descriptor_file;
+		opt_name = "--out-descriptor";
+		ctx->callbacks.descriptor = handle_descriptor;
+	}
+	if (file->fd >= 0) {
+		error_msg("%s can only be specified once", opt_name);
+		return false;
+	}
+	return open_file(file, arg, O_WRONLY|O_CREAT|O_TRUNC, 0644);
+}
+
 bool parse_tree_param(int opt_char, const char *arg,
 		      struct libfsverity_merkle_tree_params *params)
 {
@@ -211,15 +282,30 @@ bool parse_tree_param(int opt_char, const char *arg,
 	case OPT_SALT:
 		return parse_salt_option(arg, (u8 **)&params->salt,
 					 &params->salt_size);
+	case OPT_OUT_MERKLE_TREE:
+	case OPT_OUT_DESCRIPTOR:
+		return parse_out_metadata_option(opt_char, arg,
+						 &params->metadata_callbacks);
 	default:
 		ASSERT(0);
 	}
 }
 
-void destroy_tree_params(struct libfsverity_merkle_tree_params *params)
+bool destroy_tree_params(struct libfsverity_merkle_tree_params *params)
 {
+	bool ok = true;
+
 	free((u8 *)params->salt);
+	if (params->metadata_callbacks) {
+		struct metadata_callback_ctx *ctx =
+			params->metadata_callbacks->ctx;
+
+		ok &= filedes_close(&ctx->merkle_tree_file);
+		ok &= filedes_close(&ctx->descriptor_file);
+		free(ctx);
+	}
 	memset(params, 0, sizeof(*params));
+	return ok;
 }
 
 int main(int argc, char *argv[])
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 9785013..fe24087 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -29,6 +29,8 @@ enum {
 	OPT_KEY,
 	OPT_LENGTH,
 	OPT_OFFSET,
+	OPT_OUT_DESCRIPTOR,
+	OPT_OUT_MERKLE_TREE,
 	OPT_SALT,
 	OPT_SIGNATURE,
 };
@@ -59,6 +61,6 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 void usage(const struct fsverity_command *cmd, FILE *fp);
 bool parse_tree_param(int opt_char, const char *arg,
 		      struct libfsverity_merkle_tree_params *params);
-void destroy_tree_params(struct libfsverity_merkle_tree_params *params);
+bool destroy_tree_params(struct libfsverity_merkle_tree_params *params);
 
 #endif /* PROGRAMS_FSVERITY_H */
-- 
2.31.1

