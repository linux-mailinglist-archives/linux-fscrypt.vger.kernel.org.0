Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FD12B1D8E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 15:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgKMOfi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 09:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgKMOfi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 09:35:38 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0D5C0613D1
        for <linux-fscrypt@vger.kernel.org>; Fri, 13 Nov 2020 06:35:37 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id p8so10160287wrx.5
        for <linux-fscrypt@vger.kernel.org>; Fri, 13 Nov 2020 06:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vYGKAlJjB8cvZKw4Gd5pcvLT9EVbagcXD7uGmA9ZHE=;
        b=iNvwSgbcshAUMdbQamutGsxMlHtiD3s8I2Ri84w4tgDNUc3jtBWktlVBrZIau2pSjS
         Wyp//L7YcdeG+Q4eDqckKlFRl5CgHtcyKoqmL2ZkNrNGEXbCY+leVrH5F389wEPje/zP
         Yo1CQRRAm0WeXyyWNjBhmwGkvPQnzSlVh85SJbS7tnusjXlkn+PgRsmf+cfK0x/hU0iA
         xAqiWmuRKQWUtLu8Qd004fQsAW9vHTiEPVXDHbPq51Jvcpt377XKSyRnS4h7eYmI+dXh
         7cMvr+xAQaJvL4qp7OpeJOzOh3hIXCT2MqFR8bsM21YXFsYJBQE0HjAC/U5lL8CJ8bBy
         f5wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5vYGKAlJjB8cvZKw4Gd5pcvLT9EVbagcXD7uGmA9ZHE=;
        b=HROWseV2iS6aPjjzJOeEiUE0JvJNBdmRaEtbPFp6s/ytRl1BCaMqztBNp9SXP7AhD3
         SwykONKyOVNJq2Va7dUXPCLVsKBJX+VG/MSyZvvXjxOwup/AvVI3MYtG5B9y/2271Th0
         t6/GEaHY5+Po/tUkaPvPA/2D6kperltaeHL5zg+JjQIsfv7h0Q9QGeplllJeUOx1dI3M
         P+fRJojj4XN+LRioK7bROzEGL1VGyMbib/lhtvpwLXdQ8uRPrRIL5BHcV+jMWdUU+FF1
         mr3isV014xIn8Ez1iYSyD1mUMEriTu1FY//+ghy5zkmDALRZo/WG71cueuhgKlk4h9Fj
         9jYQ==
X-Gm-Message-State: AOAM530uw1k+iaHHSxj3IsdQb5jEVoLx2+qCCiVV+scQxk+q/fFaOT/n
        6qOKBbd693V2P+gUjmnkTgLSyJslQh8hig==
X-Google-Smtp-Source: ABdhPJy+nSdovd5TCft5VjrBjx3zxXSIfjCAfs/hZbAXEhiifrwPunz8SBjjzKrXNEoPSGTkteFn7g==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr3701674wrs.235.1605278135985;
        Fri, 13 Nov 2020 06:35:35 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id 71sm11740298wrm.20.2020.11.13.06.35.34
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 06:35:35 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils RFC PATCH] Add libfsverity_enable() API
Date:   Fri, 13 Nov 2020 14:35:27 +0000
Message-Id: <20201113143527.1097499-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Factor out the 'fsverity enable' implementation in the library, to
give users a shortcut for reading signatures and enabling a file
with the default parameters.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
Marked as RFC to get guidance on how to deal with helper functions
duplication, that right now are part of the "programs" utility objects
and not usable from the "library" objects.
There's dozens of different ways to handle this, all equally valid, so
it's down to the preference of the maintainer (eg: new common helpers,
include helpers at build time, further splits of sources, etc).
Please provide a preference and I'll follow up.

 common/common_defs.h  |   9 ++
 include/libfsverity.h |  21 +++++
 lib/enable.c          | 191 ++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_enable.c |  66 ++-------------
 programs/fsverity.h   |   9 --
 5 files changed, 227 insertions(+), 69 deletions(-)
 create mode 100644 lib/enable.c

diff --git a/common/common_defs.h b/common/common_defs.h
index 279385a..871db2c 100644
--- a/common/common_defs.h
+++ b/common/common_defs.h
@@ -90,4 +90,13 @@ static inline int ilog2(unsigned long n)
 #  define le64_to_cpu(v)	(__builtin_bswap64((__force u64)(v)))
 #endif
 
+/* The hash algorithm that 'fsverity' assumes when none is specified */
+#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
+
+/*
+ * Largest digest size among all hash algorithms supported by fs-verity.
+ * This can be increased if needed.
+ */
+#define FS_VERITY_MAX_DIGEST_SIZE	64
+
 #endif /* COMMON_COMMON_DEFS_H */
diff --git a/include/libfsverity.h b/include/libfsverity.h
index 8f78a13..8d1f93b 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -112,6 +112,27 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 			const struct libfsverity_signature_params *sig_params,
 			uint8_t **sig_ret, size_t *sig_size_ret);
 
+/**
+ * libfsverity_enable() - Enable fs-verity on a file
+ *          An fsverity_digest (also called a "file measurement") is the root of
+ *          a file's Merkle tree.  Not to be confused with a traditional file
+ *          digest computed over the entire file.
+ * @file: path to the file to enable
+ * @signature: (optional) path to signature for @file
+ * @params: struct libfsverity_merkle_tree_params specifying the fs-verity
+ *	    version, the hash algorithm, the block size, and
+ *	    optionally a salt.  Reserved fields must be zero.
+ *      All fields bar the version are optional, and defaults will be used
+ *      if set to zero.
+ *
+ * Returns:
+ * * 0 for success, -EINVAL for invalid input arguments, or a generic error
+ *   if the FS_IOC_ENABLE_VERITY ioctl fails.
+ */
+int
+libfsverity_enable(const char *file, const char *signature,
+			struct libfsverity_merkle_tree_params *params);
+
 /**
  * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
  * @name: Pointer to name of hash algorithm
diff --git a/lib/enable.c b/lib/enable.c
new file mode 100644
index 0000000..ad86cc5
--- /dev/null
+++ b/lib/enable.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Implementation of libfsverity_enable().
+ *
+ * Copyright 2020 Microsoft
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+
+#include "lib_private.h"
+
+#include <fcntl.h>
+#include <getopt.h>
+#include <limits.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <string.h>
+
+
+struct filedes {
+	int fd;
+	char *name;		/* filename, for logging or error messages */
+};
+
+static u32 get_default_block_size(void)
+{
+	long n = sysconf(_SC_PAGESIZE);
+
+	if (n <= 0 || n >= INT_MAX || !is_power_of_2(n)) {
+		libfsverity_error_msg("Warning: invalid _SC_PAGESIZE (%ld).  Assuming 4K blocks.\n",
+			n);
+		return 4096;
+	}
+	return n;
+}
+
+static bool open_file(struct filedes *file, const char *filename, int flags, int mode)
+{
+	file->fd = open(filename, flags, mode);
+	if (file->fd < 0) {
+		libfsverity_error_msg("can't open '%s' for %s", filename,
+				(flags & O_ACCMODE) == O_RDONLY ? "reading" :
+				(flags & O_ACCMODE) == O_WRONLY ? "writing" :
+				"reading and writing");
+		return false;
+	}
+	file->name = strdup(filename);
+	return true;
+}
+
+static bool get_file_size(struct filedes *file, u64 *size_ret)
+{
+	struct stat stbuf;
+
+	if (fstat(file->fd, &stbuf) != 0) {
+		libfsverity_error_msg("can't stat file '%s'", file->name);
+		return false;
+	}
+	*size_ret = stbuf.st_size;
+	return true;
+}
+
+static bool full_read(struct filedes *file, void *buf, size_t count)
+{
+	while (count) {
+		int n = read(file->fd, buf, min(count, INT_MAX));
+
+		if (n < 0) {
+			libfsverity_error_msg("reading from '%s'", file->name);
+			return false;
+		}
+		if (n == 0) {
+			libfsverity_error_msg("unexpected end-of-file on '%s'", file->name);
+			return false;
+		}
+		buf += n;
+		count -= n;
+	}
+	return true;
+}
+
+static bool filedes_close(struct filedes *file)
+{
+	int res;
+
+	if (file->fd < 0)
+		return true;
+	res = close(file->fd);
+	if (res != 0)
+		libfsverity_error_msg("closing '%s'", file->name);
+	file->fd = -1;
+	free(file->name);
+	file->name = NULL;
+	return res == 0;
+}
+
+static bool read_signature(const char *filename, u8 **sig_ret,
+			   u32 *sig_size_ret)
+{
+	struct filedes file = { .fd = -1 };
+	u64 file_size;
+	u8 *sig = NULL;
+	bool ok = false;
+
+	if (!open_file(&file, filename, O_RDONLY, 0))
+		goto out;
+	if (!get_file_size(&file, &file_size))
+		goto out;
+	if (file_size <= 0) {
+		libfsverity_error_msg("signature file '%s' is empty", filename);
+		goto out;
+	}
+	if (file_size > 1000000) {
+		libfsverity_error_msg("signature file '%s' is too large", filename);
+		goto out;
+	}
+	sig = libfsverity_zalloc(file_size);
+	if (!full_read(&file, sig, file_size))
+		goto out;
+	*sig_ret = sig;
+	*sig_size_ret = file_size;
+	sig = NULL;
+	ok = true;
+out:
+	filedes_close(&file);
+	free(sig);
+	return ok;
+}
+
+LIBEXPORT int
+libfsverity_enable(const char *file, const char *signature,
+			struct libfsverity_merkle_tree_params *params)
+{
+	struct fsverity_enable_arg arg;
+	u8 *sig = NULL;
+	struct filedes f;
+	int status;
+
+	if (!file || !params)  {
+		libfsverity_error_msg("missing required parameters for enable");
+		return -EINVAL;
+	}
+
+	arg = (struct fsverity_enable_arg) {
+			.version = params->version,
+			.hash_algorithm = params->hash_algorithm,
+			.block_size = params->block_size,
+			.salt_size = params->salt_size,
+			.salt_ptr = (uintptr_t)params->salt,
+	};
+
+	if (signature && !arg.sig_ptr) {
+		if (!read_signature(signature, &sig, &arg.sig_size))
+			return -EINVAL;
+		arg.sig_ptr = (uintptr_t)sig;
+	}
+
+	if (arg.hash_algorithm == 0)
+		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
+
+	if (arg.block_size == 0)
+		arg.block_size = get_default_block_size();
+
+	if (!open_file(&f, file, O_RDONLY, 0)) {
+		status = -EINVAL;
+		goto out;
+	}
+	if (ioctl(f.fd, FS_IOC_ENABLE_VERITY, &arg) != 0) {
+		libfsverity_error_msg("FS_IOC_ENABLE_VERITY failed on '%s'",
+				f.name);
+		filedes_close(&f);
+		goto out_err;
+	}
+	if (!filedes_close(&f))
+		goto out_err;
+
+	status = 0;
+out:
+	free(sig);
+	return status;
+
+out_err:
+	status = 1;
+	goto out;
+}
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index d90d208..085b6a3 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -11,43 +11,7 @@
 
 #include "fsverity.h"
 
-#include <fcntl.h>
 #include <getopt.h>
-#include <limits.h>
-#include <sys/ioctl.h>
-
-static bool read_signature(const char *filename, u8 **sig_ret,
-			   u32 *sig_size_ret)
-{
-	struct filedes file = { .fd = -1 };
-	u64 file_size;
-	u8 *sig = NULL;
-	bool ok = false;
-
-	if (!open_file(&file, filename, O_RDONLY, 0))
-		goto out;
-	if (!get_file_size(&file, &file_size))
-		goto out;
-	if (file_size <= 0) {
-		error_msg("signature file '%s' is empty", filename);
-		goto out;
-	}
-	if (file_size > 1000000) {
-		error_msg("signature file '%s' is too large", filename);
-		goto out;
-	}
-	sig = xmalloc(file_size);
-	if (!full_read(&file, sig, file_size))
-		goto out;
-	*sig_ret = sig;
-	*sig_size_ret = file_size;
-	sig = NULL;
-	ok = true;
-out:
-	filedes_close(&file);
-	free(sig);
-	return ok;
-}
 
 enum {
 	OPT_HASH_ALG,
@@ -68,10 +32,8 @@ static const struct option longopts[] = {
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[])
 {
-	struct fsverity_enable_arg arg = { .version = 1 };
-	u8 *salt = NULL;
-	u8 *sig = NULL;
-	struct filedes file;
+	struct libfsverity_merkle_tree_params arg = { .version = 1 };
+	char *sig = NULL;
 	int status;
 	int c;
 
@@ -86,18 +48,17 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 				goto out_usage;
 			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt, &arg.salt_size))
+			if (!parse_salt_option(optarg, (uint8_t **)&arg.salt, &arg.salt_size))
 				goto out_usage;
-			arg.salt_ptr = (uintptr_t)salt;
 			break;
 		case OPT_SIGNATURE:
 			if (sig != NULL) {
 				error_msg("--signature can only be specified once");
 				goto out_usage;
 			}
-			if (!read_signature(optarg, &sig, &arg.sig_size))
+			sig = strdup(optarg);
+			if (!sig)
 				goto out_err;
-			arg.sig_ptr = (uintptr_t)sig;
 			break;
 		default:
 			goto out_usage;
@@ -110,26 +71,11 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 	if (argc != 1)
 		goto out_usage;
 
-	if (arg.hash_algorithm == 0)
-		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (arg.block_size == 0)
-		arg.block_size = get_default_block_size();
-
-	if (!open_file(&file, argv[0], O_RDONLY, 0))
-		goto out_err;
-	if (ioctl(file.fd, FS_IOC_ENABLE_VERITY, &arg) != 0) {
-		error_msg_errno("FS_IOC_ENABLE_VERITY failed on '%s'",
-				file.name);
-		filedes_close(&file);
-		goto out_err;
-	}
-	if (!filedes_close(&file))
+	if (libfsverity_enable(argv[0], sig, &arg))
 		goto out_err;
 
 	status = 0;
 out:
-	free(salt);
 	free(sig);
 	return status;
 
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 669fef2..5e33eee 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -14,15 +14,6 @@
 #include "utils.h"
 #include "../common/fsverity_uapi.h"
 
-/* The hash algorithm that 'fsverity' assumes when none is specified */
-#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
-
-/*
- * Largest digest size among all hash algorithms supported by fs-verity.
- * This can be increased if needed.
- */
-#define FS_VERITY_MAX_DIGEST_SIZE	64
-
 struct fsverity_command;
 
 /* cmd_digest.c */
-- 
2.27.0

