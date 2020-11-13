Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C372B26FA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbgKMVe0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:34:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726158AbgKMVeJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:34:09 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19DF222256;
        Fri, 13 Nov 2020 21:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605303246;
        bh=bNLy9LGrd6IhofG6muI+GXT86C5EDFohOuuYxRajStk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dW7WdERy8CfuTXz6HJdbAkQPZmgUyv1BFcJ51UuotGT51CTLiQ6VNAIwOg3e+nBko
         4T2Bouo9tLtNyTaU0GQwFDIW13f53cbGJbNWNxqOdp7ba/XPTg7GfFGzA2mq/AXANs
         ktDshad/rGNnhd2clSFCf0hQoX2M6fD1gJklAbms=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [fsverity-utils PATCH 2/2] Rename "file measurement" to "file digest"
Date:   Fri, 13 Nov 2020 13:33:14 -0800
Message-Id: <20201113213314.73616-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113213314.73616-1-ebiggers@kernel.org>
References: <20201113213314.73616-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As was done in the kernel, rename "file measurement" to "file digest".
"File digest" has ended up being the more intuitive name, and it avoids
using multiple names for the same thing.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 NEWS.md                |  6 +++---
 README.md              | 20 ++++++++++----------
 include/libfsverity.h  | 18 +++++++++---------
 programs/cmd_digest.c  |  2 +-
 programs/cmd_measure.c |  2 +-
 programs/cmd_sign.c    |  2 +-
 programs/fsverity.c    |  4 ++--
 7 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/NEWS.md b/NEWS.md
index 87896cf..116ff0f 100644
--- a/NEWS.md
+++ b/NEWS.md
@@ -8,9 +8,9 @@
 
 ## Version 1.1
 
-* Split the file measurement computation and signing functionality
-  of the `fsverity` program into a library `libfsverity`.  See
-  `README.md` and `Makefile` for more details.
+* Split the file digest computation and signing functionality of the
+  `fsverity` program into a library `libfsverity`.  See `README.md`
+  and `Makefile` for more details.
 
 * Improved the Makefile.
 
diff --git a/README.md b/README.md
index 36a52e9..6045c75 100644
--- a/README.md
+++ b/README.md
@@ -18,9 +18,9 @@ might add support for fs-verity in the future.
 
 fsverity-utils currently contains just one program, `fsverity`.  The
 `fsverity` program allows you to set up fs-verity protected files.
-In addition, the file measurement computation and signing
-functionality of `fsverity` is optionally exposed through a C library
-`libfsverity`.  See `libfsverity.h` for the API of this library.
+In addition, the file digest computation and signing functionality of
+`fsverity` is optionally exposed through a C library `libfsverity`.
+See `libfsverity.h` for the API of this library.
 
 ## Building and installing
 
@@ -66,13 +66,13 @@ See the `Makefile` for other supported build and installation options.
     # Enable verity on the file
     fsverity enable file
 
-    # Show the verity file measurement
+    # Show the verity file digest
     fsverity measure file
 
     # File should still be readable as usual.  However, all data read
     # is now transparently checked against a hidden Merkle tree, whose
-    # root hash is incorporated into the verity file measurement.
-    # Reads of any corrupted parts of the data will fail.
+    # root hash is incorporated into the verity file digest.  Reads of
+    # any corrupted parts of the data will fail.
     sha256sum file
 ```
 
@@ -84,10 +84,10 @@ against a trusted value.
 ### Using builtin signatures
 
 With `CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y`, the filesystem supports
-automatically verifying a signed file measurement that has been
-included in the verity metadata.  The signature is verified against
-the set of X.509 certificates that have been loaded into the
-".fs-verity" kernel keyring.  Here's an example:
+automatically verifying a signed file digest that has been included in
+the verity metadata.  The signature is verified against the set of
+X.509 certificates that have been loaded into the ".fs-verity" kernel
+keyring.  Here's an example:
 
 ```bash
     # Generate a new certificate and private key:
diff --git a/include/libfsverity.h b/include/libfsverity.h
index 8f78a13..d6c3092 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -64,9 +64,9 @@ typedef int (*libfsverity_read_fn_t)(void *fd, void *buf, size_t count);
 
 /**
  * libfsverity_compute_digest() - Compute digest of a file
- *          An fsverity_digest (also called a "file measurement") is the root of
- *          a file's Merkle tree.  Not to be confused with a traditional file
- *          digest computed over the entire file.
+ *          A fs-verity file digest is the hash of a file's fsverity_descriptor.
+ *          Not to be confused with a traditional file digest computed over the
+ *          entire file, or with the bare fsverity_descriptor::root_hash.
  * @fd: context that will be passed to @read_fn
  * @read_fn: a function that will read the data of the file
  * @params: struct libfsverity_merkle_tree_params specifying the fs-verity
@@ -87,12 +87,12 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
 
 /**
  * libfsverity_sign_digest() - Sign previously computed digest of a file
- *          This signature is used by the file system to validate the
- *          signed file measurement against a public key loaded into the
- *          .fs-verity kernel keyring, when CONFIG_FS_VERITY_BUILTIN_SIGNATURES
- *          is enabled. The signature is formatted as PKCS#7 stored in DER
- *          format. See Documentation/filesystems/fsverity.rst in the kernel
- *          source tree for further details.
+ *          This signature is used by the filesystem to validate the signed file
+ *          digest against a public key loaded into the .fs-verity kernel
+ *          keyring, when CONFIG_FS_VERITY_BUILTIN_SIGNATURES is enabled. The
+ *          signature is formatted as PKCS#7 stored in DER format. See
+ *          Documentation/filesystems/fsverity.rst in the kernel source tree for
+ *          further details.
  * @digest: pointer to previously computed digest
  * @sig_params: struct libfsverity_signature_params providing filenames of
  *          the keyfile and certificate file. Reserved fields must be zero.
diff --git a/programs/cmd_digest.c b/programs/cmd_digest.c
index 420ba82..31dfd45 100644
--- a/programs/cmd_digest.c
+++ b/programs/cmd_digest.c
@@ -32,7 +32,7 @@ static const struct option longopts[] = {
 };
 
 /*
- * Compute the fs-verity measurement of the given file(s), for offline signing.
+ * Compute the fs-verity digest of the given file(s), for offline signing.
  */
 int fsverity_cmd_digest(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
diff --git a/programs/cmd_measure.c b/programs/cmd_measure.c
index 98382ab..d78969c 100644
--- a/programs/cmd_measure.c
+++ b/programs/cmd_measure.c
@@ -14,7 +14,7 @@
 #include <fcntl.h>
 #include <sys/ioctl.h>
 
-/* Display the measurement of the given verity file(s). */
+/* Display the fs-verity digest of the given verity file(s). */
 int fsverity_cmd_measure(const struct fsverity_command *cmd,
 			 int argc, char *argv[])
 {
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 580e4df..2f06007 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -43,7 +43,7 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
-/* Sign a file for fs-verity by computing its measurement, then signing it. */
+/* Sign a file for fs-verity by computing its digest, then signing it. */
 int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 4a2f8df..b12c878 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -24,7 +24,7 @@ static const struct fsverity_command {
 		.name = "digest",
 		.func = fsverity_cmd_digest,
 		.short_desc =
-"Compute the fs-verity measurement of the given file(s), for offline signing",
+"Compute the fs-verity digest of the given file(s), for offline signing",
 		.usage_str =
 "    fsverity digest FILE...\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
@@ -41,7 +41,7 @@ static const struct fsverity_command {
 		.name = "measure",
 		.func = fsverity_cmd_measure,
 		.short_desc =
-"Display the measurement of the given verity file(s)",
+"Display the fs-verity digest of the given verity file(s)",
 		.usage_str =
 "    fsverity measure FILE...\n"
 	}, {
-- 
2.29.2

