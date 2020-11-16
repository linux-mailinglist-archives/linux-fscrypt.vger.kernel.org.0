Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1DC2B534F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 21:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732815AbgKPU4z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 15:56:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728760AbgKPU4z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 15:56:55 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E312078D;
        Mon, 16 Nov 2020 20:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605560214;
        bh=rDDP1dPWYvs6cKaNIgaxG29BHVije+drPkGJ+U5TZOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ax/PLfRpP2lKezqCHqoGTrvn+4UHv9OZjvCntRPpcillBt3q3+WlFsl+YDzZaRKTT
         4mfQBj6uoyDp7y/4XK19i0B9nmYSUAgadZuuji7+0IK0JLTXBVEBv+GP6vDTC2On3S
         ujJxvVaFQti6MvHMILpUFsof1O5Z8ynOY+EE8u0A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH v2 3/4] lib: add libfsverity_enable() and libfsverity_enable_with_sig()
Date:   Mon, 16 Nov 2020 12:56:27 -0800
Message-Id: <20201116205628.262173-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
References: <20201116205628.262173-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
'struct libfsverity_merkle_tree_params' instead of
'struct fsverity_enable_arg'.  This is useful because it allows
libfsverity users to deal with one common struct, and also get the
default parameter handling that libfsverity_compute_digest() does.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/libfsverity.h | 36 +++++++++++++++++++++++++++++++++
 lib/enable.c          | 47 +++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_enable.c | 26 +++++++++++-------------
 programs/fsverity.h   |  3 ---
 4 files changed, 95 insertions(+), 17 deletions(-)
 create mode 100644 lib/enable.c

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 985b364..369e1cf 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -137,6 +137,42 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 			const struct libfsverity_signature_params *sig_params,
 			uint8_t **sig_ret, size_t *sig_size_ret);
 
+/**
+ * libfsverity_enable() - Enable fs-verity on a file
+ * @fd: read-only file descriptor to the file
+ * @params: pointer to the Merkle tree parameters
+ *
+ * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioctl.
+ *
+ * Return: 0 on success, -EINVAL for invalid arguments, or a negative errno
+ *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
+ *	   Documentation/filesystems/fsverity.rst in the kernel source tree for
+ *	   the possible error codes from FS_IOC_ENABLE_VERITY.
+ */
+int
+libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params);
+
+/**
+ * libfsverity_enable_with_sig() - Enable fs-verity on a file, with a signature
+ * @fd: read-only file descriptor to the file
+ * @params: pointer to the Merkle tree parameters
+ * @sig: pointer to the file's signature
+ * @sig_size: size of the file's signature in bytes
+ *
+ * Like libfsverity_enable(), but allows specifying a built-in signature (i.e. a
+ * singature created with libfsverity_sign_digest()) to associate with the file.
+ * This is only needed if the in-kernel signature verification support is being
+ * used; it is not needed if signatures are being verified in userspace.
+ *
+ * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_enable().
+ *
+ * Return: See libfsverity_enable().
+ */
+int
+libfsverity_enable_with_sig(int fd,
+			    const struct libfsverity_merkle_tree_params *params,
+			    const uint8_t *sig, size_t sig_size);
+
 /**
  * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
  * @name: Pointer to name of hash algorithm
diff --git a/lib/enable.c b/lib/enable.c
new file mode 100644
index 0000000..c27ec89
--- /dev/null
+++ b/lib/enable.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: MIT
+/*
+ * Implementation of libfsverity_enable() and libfsverity_enable_with_sig().
+ *
+ * Copyright 2020 Google LLC
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+
+#include "lib_private.h"
+
+#include <sys/ioctl.h>
+
+LIBEXPORT int
+libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params)
+{
+	return libfsverity_enable_with_sig(fd, params, NULL, 0);
+}
+
+LIBEXPORT int
+libfsverity_enable_with_sig(int fd,
+			    const struct libfsverity_merkle_tree_params *params,
+			    const uint8_t *sig, size_t sig_size)
+{
+	struct fsverity_enable_arg arg = {};
+
+	if (!params) {
+		libfsverity_error_msg("missing required parameters for enable");
+		return -EINVAL;
+	}
+
+	arg.version = 1;
+	arg.hash_algorithm =
+		params->hash_algorithm ?: FS_VERITY_HASH_ALG_DEFAULT;
+	arg.block_size =
+		params->block_size ?: FS_VERITY_BLOCK_SIZE_DEFAULT;
+	arg.salt_size = params->salt_size;
+	arg.salt_ptr = (uintptr_t)params->salt;
+	arg.sig_size = sig_size;
+	arg.sig_ptr = (uintptr_t)sig;
+
+	if (ioctl(fd, FS_IOC_ENABLE_VERITY, &arg) != 0)
+		return -errno;
+	return 0;
+}
diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index ba5b088..b0e0c98 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -68,9 +68,10 @@ static const struct option longopts[] = {
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[])
 {
-	struct fsverity_enable_arg arg = { .version = 1 };
+	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
 	u8 *salt = NULL;
 	u8 *sig = NULL;
+	u32 sig_size = 0;
 	struct filedes file;
 	int status;
 	int c;
@@ -78,26 +79,28 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (!parse_hash_alg_option(optarg, &arg.hash_algorithm))
+			if (!parse_hash_alg_option(optarg,
+						   &tree_params.hash_algorithm))
 				goto out_usage;
 			break;
 		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg, &arg.block_size))
+			if (!parse_block_size_option(optarg,
+						     &tree_params.block_size))
 				goto out_usage;
 			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt, &arg.salt_size))
+			if (!parse_salt_option(optarg, &salt,
+					       &tree_params.salt_size))
 				goto out_usage;
-			arg.salt_ptr = (uintptr_t)salt;
+			tree_params.salt = salt;
 			break;
 		case OPT_SIGNATURE:
 			if (sig != NULL) {
 				error_msg("--signature can only be specified once");
 				goto out_usage;
 			}
-			if (!read_signature(optarg, &sig, &arg.sig_size))
+			if (!read_signature(optarg, &sig, &sig_size))
 				goto out_err;
-			arg.sig_ptr = (uintptr_t)sig;
 			break;
 		default:
 			goto out_usage;
@@ -110,15 +113,10 @@ int fsverity_cmd_enable(const struct fsverity_command *cmd,
 	if (argc != 1)
 		goto out_usage;
 
-	if (arg.hash_algorithm == 0)
-		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
-
-	if (arg.block_size == 0)
-		arg.block_size = 4096;
-
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
-	if (ioctl(file.fd, FS_IOC_ENABLE_VERITY, &arg) != 0) {
+
+	if (libfsverity_enable_with_sig(file.fd, &tree_params, sig, sig_size)) {
 		error_msg_errno("FS_IOC_ENABLE_VERITY failed on '%s'",
 				file.name);
 		filedes_close(&file);
diff --git a/programs/fsverity.h b/programs/fsverity.h
index 2af5527..37a6294 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -14,9 +14,6 @@
 #include "utils.h"
 #include "../common/fsverity_uapi.h"
 
-/* The hash algorithm that 'fsverity' assumes when none is specified */
-#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
-
 /*
  * Largest digest size among all hash algorithms supported by fs-verity.
  * This can be increased if needed.
-- 
2.29.2

