Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42542F844B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 19:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbhAOSZR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 13:25:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388133AbhAOSZR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 13:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F9CE23359;
        Fri, 15 Jan 2021 18:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610735076;
        bh=XNHyURzeegVGJqOA0F0Z0GMFYwj9KfC+0LNtOIa5e5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBomb3bdb9+qxBzXasiTSO7d1ujKX0BEpaqOokhkQSVTkn/o5YC1fkC7sLiP1vjpN
         tjNdsmjxtJ0lIVzLAjIDgu4UB/ZhcjCq7WSsvZmhnum4P3m5HkD9eHxJXlSxn2Zx8G
         qcUAcKGj3XZ3mcR6861HgdolC9IAjlyV/N2FHmrjMulgMpdDpLihKdKqgN44BwW7+c
         CzgNDQ+j5sYuc4SDIOaroCBiXKmvBlcF4j1zxeNF9R9wQ7GEuyJHx1dIMSUVHQZzqY
         iREVuLOGlIEz/KQVbDZNJCxTbJaD00Da++U+hO0jLXPU05IiugJs74kp9guuWEEnN5
         Dmo10UgwJqUgQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils RFC PATCH 2/2] programs/fsverity: Add dump_metadata subcommand
Date:   Fri, 15 Jan 2021 10:24:02 -0800
Message-Id: <20210115182402.35691-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115182402.35691-1-ebiggers@kernel.org>
References: <20210115182402.35691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a 'fsverity dump_metadata' subcommand which calls
FS_IOC_READ_VERITY_METADATA on a file and prints the returned metadata
to stdout.  There are three subsubcommands, one for each type of
metadata that can be read using the ioctl:

	fsverity dump_metadata merkle_tree FILE
	fsverity dump_metadata descriptor FILE
	fsverity dump_metadata signature FILE

By default the whole metadata item is dumped.  --length and --offset can
be specified to dump only a particular range of the item.

This subcommand will be used by xfstests to test the
FS_IOC_READ_VERITY_METADATA ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Makefile                     |   1 +
 programs/cmd_dump_metadata.c | 167 +++++++++++++++++++++++++++++++++++
 programs/fsverity.c          |   6 ++
 programs/fsverity.h          |   6 ++
 4 files changed, 180 insertions(+)
 create mode 100644 programs/cmd_dump_metadata.c

diff --git a/Makefile b/Makefile
index 0354f62..fd28b06 100644
--- a/Makefile
+++ b/Makefile
@@ -160,6 +160,7 @@ FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
 		     programs/fsverity.o
 ifneq ($(MINGW),1)
 FSVERITY_PROG_OBJ += \
+		     programs/cmd_dump_metadata.o \
 		     programs/cmd_enable.o	\
 		     programs/cmd_measure.o
 endif
diff --git a/programs/cmd_dump_metadata.c b/programs/cmd_dump_metadata.c
new file mode 100644
index 0000000..9b249ba
--- /dev/null
+++ b/programs/cmd_dump_metadata.c
@@ -0,0 +1,167 @@
+// SPDX-License-Identifier: MIT
+/*
+ * The 'fsverity dump_metadata' command
+ *
+ * Copyright 2021 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+
+#include "fsverity.h"
+
+#include <fcntl.h>
+#include <getopt.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+
+static const struct option longopts[] = {
+	{"offset",	required_argument, NULL, OPT_OFFSET},
+	{"length",	required_argument, NULL, OPT_LENGTH},
+	{NULL, 0, NULL, 0}
+};
+
+static const struct {
+	const char *name;
+	int val;
+} metadata_types[] = {
+	{"merkle_tree", FS_VERITY_METADATA_TYPE_MERKLE_TREE},
+	{"descriptor", FS_VERITY_METADATA_TYPE_DESCRIPTOR},
+	{"signature", FS_VERITY_METADATA_TYPE_SIGNATURE},
+};
+
+static bool parse_metadata_type(const char *name, __u64 *val_ret)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(metadata_types); i++) {
+		if (strcmp(name, metadata_types[i].name) == 0) {
+			*val_ret = metadata_types[i].val;
+			return true;
+		}
+	}
+	error_msg("unknown metadata type: %s", name);
+	fputs("       Expected", stderr);
+	for (i = 0; i < ARRAY_SIZE(metadata_types); i++) {
+		if (i != 0 && ARRAY_SIZE(metadata_types) > 2)
+			putc(',', stderr);
+		putc(' ', stderr);
+		if (i != 0 && i == ARRAY_SIZE(metadata_types) - 1)
+			fputs("or ", stderr);
+		fprintf(stderr, "\"%s\"", metadata_types[i].name);
+	}
+	fprintf(stderr, "\n");
+	return false;
+}
+
+/* Dump the fs-verity metadata of the given file. */
+int fsverity_cmd_dump_metadata(const struct fsverity_command *cmd,
+			       int argc, char *argv[])
+{
+	bool offset_specified = false;
+	bool length_specified = false;
+	struct filedes file = { .fd = -1 };
+	struct filedes stdout_filedes = { .fd = STDOUT_FILENO,
+					  .name = "stdout" };
+	/*
+	 * FS_VERITY_METADATA_TYPE_MERKLE_TREE requires Merkle tree block
+	 * alignment.  Use a 64K buffer which should always be enough.
+	 */
+	struct fsverity_read_metadata_arg arg = { .length = 65536 };
+	void *buf = NULL;
+	char *tmp;
+	int c;
+	int status;
+	int bytes_read;
+
+	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
+		switch (c) {
+		case OPT_OFFSET:
+			if (offset_specified) {
+				error_msg("--offset can only be specified once");
+				goto out_usage;
+			}
+			errno = 0;
+			arg.offset = strtoull(optarg, &tmp, 10);
+			if (errno || *tmp) {
+				error_msg("invalid value for --offset");
+				goto out_usage;
+			}
+			offset_specified = true;
+			break;
+		case OPT_LENGTH:
+			if (length_specified) {
+				error_msg("--length can only be specified once");
+				goto out_usage;
+			}
+			errno = 0;
+			arg.length = strtoull(optarg, &tmp, 10);
+			if (errno || *tmp || arg.length > SIZE_MAX) {
+				error_msg("invalid value for --length");
+				goto out_usage;
+			}
+			length_specified = true;
+			break;
+		default:
+			goto out_usage;
+		}
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (argc != 2)
+		goto out_usage;
+
+	if (!parse_metadata_type(argv[0], &arg.metadata_type))
+		goto out_usage;
+
+	if (length_specified && !offset_specified) {
+		error_msg("--length specified without --offset");
+		goto out_usage;
+	}
+	if (offset_specified && !length_specified) {
+		error_msg("--offset specified without --length");
+		goto out_usage;
+	}
+
+	buf = xzalloc(arg.length);
+	arg.buf_ptr = (uintptr_t)buf;
+
+	if (!open_file(&file, argv[1], O_RDONLY, 0))
+		goto out_err;
+
+	/*
+	 * If --offset and --length were specified, then do only the single read
+	 * requested.  Otherwise read until EOF.
+	 */
+	do {
+		bytes_read = ioctl(file.fd, FS_IOC_READ_VERITY_METADATA, &arg);
+		if (bytes_read < 0) {
+			error_msg_errno("FS_IOC_READ_VERITY_METADATA failed on '%s'",
+					file.name);
+			goto out_err;
+		}
+		if (bytes_read == 0)
+			break;
+		if (!full_write(&stdout_filedes, buf, bytes_read))
+			goto out_err;
+		arg.offset += bytes_read;
+	} while (!length_specified);
+
+	status = 0;
+out:
+	free(buf);
+	filedes_close(&file);
+	return status;
+
+out_err:
+	status = 1;
+	goto out;
+
+out_usage:
+	usage(cmd, stderr);
+	status = 2;
+	goto out;
+}
diff --git a/programs/fsverity.c b/programs/fsverity.c
index b911b2e..1168430 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -29,6 +29,12 @@ static const struct fsverity_command {
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
 "               [--compact] [--for-builtin-sig]\n"
 #ifndef _WIN32
+	}, {
+		.name = "dump_metadata",
+		.func = fsverity_cmd_dump_metadata,
+		.short_desc = "Dump the fs-verity metadata of the given file",
+		.usage_str =
+"    fsverity dump_metadata TYPE FILE [--offset=OFFSET] [--length=LENGTH]\n"
 	}, {
 		.name = "enable",
 		.func = fsverity_cmd_enable,
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 45c4fe1..9785013 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -27,6 +27,8 @@ enum {
 	OPT_FOR_BUILTIN_SIG,
 	OPT_HASH_ALG,
 	OPT_KEY,
+	OPT_LENGTH,
+	OPT_OFFSET,
 	OPT_SALT,
 	OPT_SIGNATURE,
 };
@@ -37,6 +39,10 @@ struct fsverity_command;
 int fsverity_cmd_digest(const struct fsverity_command *cmd,
 			int argc, char *argv[]);
 
+/* cmd_dump_metadata.c */
+int fsverity_cmd_dump_metadata(const struct fsverity_command *cmd,
+			       int argc, char *argv[]);
+
 /* cmd_enable.c */
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[]);
-- 
2.30.0

