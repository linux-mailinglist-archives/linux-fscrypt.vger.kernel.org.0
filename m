Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920831E1560
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 May 2020 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388714AbgEYUzT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 May 2020 16:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbgEYUzS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 May 2020 16:55:18 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02C1A2071C;
        Mon, 25 May 2020 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440115;
        bh=H02shxXH/BOrmt8AANnwhVHFAkoSfgxCF6bcYSck3uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iF3dlSri1kmE52hTUK5OzCrbAuXYjJ/8fqyYzNywNRB7rmPlP0saEbRVLXo0vMV+K
         R0rzZxrGf2DiWrODmsSatFMZ/J/N+uNkDLtdN0zupF0TfjmyiG/FHxOC8UgSE+5diU
         ueUkjgbmizHkZtIsdFVqcd2o2RxKic7lPOx6V38Y=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: [PATCH v2 2/3] Introduce libfsverity
Date:   Mon, 25 May 2020 13:54:31 -0700
Message-Id: <20200525205432.310304-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525205432.310304-1-ebiggers@kernel.org>
References: <20200525205432.310304-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

From the 'fsverity' program, split out a library 'libfsverity'.
Currently it supports computing file measurements ("digests"), and
signing those file measurements for use with the fs-verity builtin
signature verification feature.

Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
I made a lot of improvements, e.g.:

- Separated library and program source into different directories.
- Drastically improved the Makefile.
- Added 'make check' target and rules to build test programs.
- In the shared lib, only export the functions intended to be public.
- Prefixed global functions with "libfsverity_" so that they don't cause
  conflicts when the library is built as a static library.
- Made library error messages be sent to a user-specified callback
  rather than always be printed to stderr.
- Keep showing OpenSSL error messages.
- Stopped abort()ing in library code, when possible.
- Made libfsverity_digest use native endianness.
- Moved file_size into the merkle_tree_params.
- Made libfsverity_get_hash_name() just return the static strings.
- Made some variables in the API uint32_t instead of uint16_t.
- Shared parse_hash_alg_option() between cmd_enable and cmd_sign.
- Lots of other fixes.

(Folded in a couple Makefile fixes from Jes.)

Reviewed-by: Jes Sorensen <jsorensen@fb.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .gitignore                                |  10 +-
 Makefile                                  | 191 ++++++++++++++++++--
 commands.h                                |  24 ---
 util.h => common/common_defs.h            |  47 +----
 fsverity_uapi.h => common/fsverity_uapi.h |   0
 common/libfsverity.h                      | 132 ++++++++++++++
 hash_algs.h                               |  68 -------
 lib/compute_digest.c                      | 182 ++++++++++++-------
 hash_algs.c => lib/hash_algs.c            | 129 +++++++++-----
 lib/lib_private.h                         |  83 +++++++++
 lib/sign_digest.c                         | 205 ++++++++++++++++------
 lib/utils.c                               | 109 ++++++++++++
 cmd_enable.c => programs/cmd_enable.c     |  32 +---
 cmd_measure.c => programs/cmd_measure.c   |  12 +-
 cmd_sign.c => programs/cmd_sign.c         |  91 +++++-----
 fsverity.c => programs/fsverity.c         |  52 +++++-
 programs/fsverity.h                       |  43 +++++
 util.c => programs/utils.c                |   7 +-
 programs/utils.h                          |  44 +++++
 sign.h                                    |  32 ----
 20 files changed, 1055 insertions(+), 438 deletions(-)
 delete mode 100644 commands.h
 rename util.h => common/common_defs.h (56%)
 rename fsverity_uapi.h => common/fsverity_uapi.h (100%)
 create mode 100644 common/libfsverity.h
 delete mode 100644 hash_algs.h
 rename hash_algs.c => lib/hash_algs.c (53%)
 create mode 100644 lib/lib_private.h
 create mode 100644 lib/utils.c
 rename cmd_enable.c => programs/cmd_enable.c (81%)
 rename cmd_measure.c => programs/cmd_measure.c (83%)
 rename cmd_sign.c => programs/cmd_sign.c (53%)
 rename fsverity.c => programs/fsverity.c (82%)
 create mode 100644 programs/fsverity.h
 rename util.c => programs/utils.c (96%)
 create mode 100644 programs/utils.h
 delete mode 100644 sign.h

diff --git a/.gitignore b/.gitignore
index 95457ca..d3109a8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,5 +1,11 @@
-fsverity
+*.a
 *.o
-tags
+*.patch
+*.so
+*.so.*
+/.build-config
+/fsverity
+/test_*
 cscope.*
 ncscope.*
+tags
diff --git a/Makefile b/Makefile
index c3b14a3..78180dd 100644
--- a/Makefile
+++ b/Makefile
@@ -1,22 +1,183 @@
-EXE := fsverity
-CFLAGS := -O2 -Wall
-CPPFLAGS := -D_FILE_OFFSET_BITS=64 -I.
-LDLIBS := -lcrypto
-DESTDIR := /usr/local
-SRC := $(wildcard *.c) $(wildcard lib/*.c)
-OBJ := $(SRC:.c=.o)
-HDRS := $(wildcard *.h)
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# Use 'make help' to list available targets.
+#
+# Define V=1 to enable "verbose" mode, showing all executed commands.
+#
+# Define USE_SHARED_LIB=1 to link the fsverity binary to the shared library
+# libfsverity.so rather than to the static library libfsverity.a.
+#
+# Define PREFIX to override the installation prefix, like './configure --prefix'
+# in autotools-based projects (default: /usr/local)
+#
+# Define BINDIR to override where to install binaries, like './configure
+# --bindir' in autotools-based projects (default: PREFIX/bin)
+#
+# Define INCDIR to override where to install headers, like './configure
+# --includedir' in autotools-based projects (default: PREFIX/include)
+#
+# Define LIBDIR to override where to install libraries, like './configure
+# --libdir' in autotools-based projects (default: PREFIX/lib)
+#
+# Define DESTDIR to override the installation destination directory
+# (default: empty string)
+#
+# You can also specify custom CC, CFLAGS, CPPFLAGS, and/or LDFLAGS.
+#
+##############################################################################
 
-all:$(EXE)
+cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
+	      then echo $(1); fi)
 
-$(EXE):$(OBJ)
+CFLAGS ?= -O2 -Wall -Wundef					\
+	$(call cc-option,-Wdeclaration-after-statement)		\
+	$(call cc-option,-Wimplicit-fallthrough)		\
+	$(call cc-option,-Wmissing-field-initializers)		\
+	$(call cc-option,-Wmissing-prototypes)			\
+	$(call cc-option,-Wstrict-prototypes)			\
+	$(call cc-option,-Wunused-parameter)			\
+	$(call cc-option,-Wvla)
 
-$(OBJ): %.o: %.c $(HDRS)
+override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
-clean:
-	rm -f $(EXE) $(OBJ)
+ifneq ($(V),1)
+QUIET_CC        = @echo '  CC      ' $@;
+QUIET_CCLD      = @echo '  CCLD    ' $@;
+QUIET_AR        = @echo '  AR      ' $@;
+QUIET_LN        = @echo '  LN      ' $@;
+endif
+USE_SHARED_LIB  ?=
+PREFIX          ?= /usr/local
+BINDIR          ?= $(PREFIX)/bin
+INCDIR          ?= $(PREFIX)/include
+LIBDIR          ?= $(PREFIX)/lib
+DESTDIR         ?=
+
+# Rebuild if a user-specified setting that affects the build changed.
+.build-config: FORCE
+	@flags='$(CC):$(CFLAGS):$(CPPFLAGS):$(LDFLAGS):$(USE_SHARED_LIB)'; \
+	if [ "$$flags" != "`cat $@ 2>/dev/null`" ]; then		\
+		[ -e $@ ] && echo "Rebuilding due to new settings";	\
+		echo "$$flags" > $@;					\
+	fi
+
+DEFAULT_TARGETS :=
+COMMON_HEADERS  := $(wildcard common/*.h)
+LDLIBS          := -lcrypto
+
+##############################################################################
+
+#### Library
+
+SOVERSION       := 0
+LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
+LIB_SRC         := $(wildcard lib/*.c)
+LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
+STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
+SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
+
+# Compile static library object files
+$(STATIC_LIB_OBJ): %.o: %.c $(LIB_HEADERS) .build-config
+	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(LIB_CFLAGS) $<
+
+# Compile shared library object files
+$(SHARED_LIB_OBJ): %.shlib.o: %.c $(LIB_HEADERS) .build-config
+	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(LIB_CFLAGS) -fPIC $<
+
+# Create static library
+libfsverity.a:$(STATIC_LIB_OBJ)
+	$(QUIET_AR) $(AR) cr $@ $+
+
+DEFAULT_TARGETS += libfsverity.a
+
+# Create shared library
+libfsverity.so.$(SOVERSION):$(SHARED_LIB_OBJ)
+	$(QUIET_CCLD) $(CC) -o $@ -Wl,-soname=$@ -shared $+ $(LDFLAGS) $(LDLIBS)
+
+DEFAULT_TARGETS += libfsverity.so.$(SOVERSION)
+
+# Create the symlink libfsverity.so => libfsverity.so.$(SOVERSION)
+libfsverity.so:libfsverity.so.$(SOVERSION)
+	$(QUIET_LN) ln -sf $+ $@
+
+DEFAULT_TARGETS += libfsverity.so
+
+##############################################################################
+
+#### Programs
+
+ALL_PROG_SRC      := $(wildcard programs/*.c)
+ALL_PROG_OBJ      := $(ALL_PROG_SRC:.c=.o)
+ALL_PROG_HEADERS  := $(wildcard programs/*.h) $(COMMON_HEADERS)
+PROG_COMMON_SRC   := programs/utils.c
+PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
+FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
+		     programs/cmd_enable.o	\
+		     programs/cmd_measure.o	\
+		     programs/cmd_sign.o	\
+		     programs/fsverity.o
+TEST_PROG_SRC     := $(wildcard programs/test_*.c)
+TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
+
+# Compile program object files
+$(ALL_PROG_OBJ): %.o: %.c $(ALL_PROG_HEADERS) .build-config
+	$(QUIET_CC) $(CC) -o $@ -c $(CPPFLAGS) $(CFLAGS) $<
+
+# Link the fsverity program
+ifdef USE_SHARED_LIB
+fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
+	$(QUIET_CCLD) $(CC) -o $@ $(FSVERITY_PROG_OBJ) -L. -lfsverity
+else
+fsverity: $(FSVERITY_PROG_OBJ) libfsverity.a
+	$(QUIET_CCLD) $(CC) -o $@ $+ $(LDFLAGS) $(LDLIBS)
+endif
+
+DEFAULT_TARGETS += fsverity
+
+# Link the test programs
+$(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
+	$(QUIET_CCLD) $(CC) -o $@ $+ $(LDFLAGS) $(LDLIBS)
+
+##############################################################################
+
+all:$(DEFAULT_TARGETS)
+
+test_programs:$(TEST_PROGRAMS)
+
+check:test_programs
+	for prog in $(TEST_PROGRAMS); do \
+		./$$prog || exit 1; \
+	done
+	@echo "All tests passed!"
 
 install:all
-	install -Dm755 -t $(DESTDIR)/bin $(EXE)
+	install -d $(DESTDIR)$(LIBDIR) $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
+	install -m755 fsverity $(DESTDIR)$(BINDIR)
+	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
+	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
+	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
+	install -m644 common/libfsverity.h $(DESTDIR)$(INCDIR)
+
+uninstall:
+	rm -f $(DESTDIR)$(BINDIR)/fsverity
+	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
+	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
+	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
+	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h
+
+help:
+	@echo "Available targets:"
+	@echo "------------------"
+	@for target in $(DEFAULT_TARGETS) $(TEST_PROGRAMS); do \
+		echo $$target; \
+	done
+
+clean:
+	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
+		lib/*.o programs/*.o .build-config
+
+FORCE:
+
+.PHONY: all test_programs check install uninstall help clean FORCE
 
-.PHONY: all clean install
+.DEFAULT_GOAL = all
diff --git a/commands.h b/commands.h
deleted file mode 100644
index d96f580..0000000
--- a/commands.h
+++ /dev/null
@@ -1,24 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef COMMANDS_H
-#define COMMANDS_H
-
-#include "util.h"
-
-#include <stdio.h>
-
-struct fsverity_command;
-
-void usage(const struct fsverity_command *cmd, FILE *fp);
-
-int fsverity_cmd_enable(const struct fsverity_command *cmd,
-			int argc, char *argv[]);
-int fsverity_cmd_measure(const struct fsverity_command *cmd,
-			 int argc, char *argv[]);
-int fsverity_cmd_sign(const struct fsverity_command *cmd,
-		      int argc, char *argv[]);
-
-bool parse_block_size_option(const char *arg, u32 *size_ptr);
-u32 get_default_block_size(void);
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
-
-#endif /* COMMANDS_H */
diff --git a/util.h b/common/common_defs.h
similarity index 56%
rename from util.h
rename to common/common_defs.h
index dc319b0..6c31baf 100644
--- a/util.h
+++ b/common/common_defs.h
@@ -1,16 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Utility functions and macros for the 'fsverity' program
+ * Common definitions for libfsverity and the 'fsverity' program
  *
  * Copyright 2018 Google LLC
  */
-#ifndef UTIL_H
-#define UTIL_H
+#ifndef COMMON_COMMON_DEFS_H
+#define COMMON_COMMON_DEFS_H
 
-#include <inttypes.h>
-#include <stdarg.h>
 #include <stdbool.h>
 #include <stddef.h>
+#include <stdint.h>
 
 typedef uint8_t u8;
 typedef uint16_t u16;
@@ -81,40 +80,4 @@ static inline int ilog2(unsigned long n)
 #  define le64_to_cpu(v)	(__builtin_bswap64((__force u64)(v)))
 #endif
 
-/* ========== Memory allocation ========== */
-
-void *xmalloc(size_t size);
-void *xzalloc(size_t size);
-void *xmemdup(const void *mem, size_t size);
-char *xstrdup(const char *s);
-
-/* ========== Error messages and assertions ========== */
-
-__cold void do_error_msg(const char *format, va_list va, int err);
-__printf(1, 2) __cold void error_msg(const char *format, ...);
-__printf(1, 2) __cold void error_msg_errno(const char *format, ...);
-__printf(1, 2) __cold __noreturn void fatal_error(const char *format, ...);
-__cold __noreturn void assertion_failed(const char *expr,
-					const char *file, int line);
-
-#define ASSERT(e) ({ if (!(e)) assertion_failed(#e, __FILE__, __LINE__); })
-
-/* ========== File utilities ========== */
-
-struct filedes {
-	int fd;
-	char *name;		/* filename, for logging or error messages */
-};
-
-bool open_file(struct filedes *file, const char *filename, int flags, int mode);
-bool get_file_size(struct filedes *file, u64 *size_ret);
-bool full_read(struct filedes *file, void *buf, size_t count);
-bool full_write(struct filedes *file, const void *buf, size_t count);
-bool filedes_close(struct filedes *file);
-
-/* ========== String utilities ========== */
-
-bool hex2bin(const char *hex, u8 *bin, size_t bin_len);
-void bin2hex(const u8 *bin, size_t bin_len, char *hex);
-
-#endif /* UTIL_H */
+#endif /* COMMON_COMMON_DEFS_H */
diff --git a/fsverity_uapi.h b/common/fsverity_uapi.h
similarity index 100%
rename from fsverity_uapi.h
rename to common/fsverity_uapi.h
diff --git a/common/libfsverity.h b/common/libfsverity.h
new file mode 100644
index 0000000..8e8571a
--- /dev/null
+++ b/common/libfsverity.h
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * libfsverity API
+ *
+ * Copyright 2018 Google LLC
+ * Copyright (C) 2020 Facebook
+ */
+
+#ifndef LIBFSVERITY_H
+#define LIBFSVERITY_H
+
+#include <errno.h>
+#include <stddef.h>
+#include <stdint.h>
+
+#define FS_VERITY_HASH_ALG_SHA256       1
+#define FS_VERITY_HASH_ALG_SHA512       2
+
+struct libfsverity_merkle_tree_params {
+	uint32_t version;		/* must be 1			*/
+	uint32_t hash_algorithm;	/* one of FS_VERITY_HASH_ALG_*	*/
+	uint32_t block_size;		/* Merkle tree block size in bytes */
+	uint32_t salt_size;		/* salt size in bytes (0 if unsalted) */
+	uint64_t file_size;		/* file size in bytes		*/
+	const uint8_t *salt;		/* pointer to salt (optional)	*/
+	uint64_t reserved[11];		/* must be 0			*/
+};
+
+struct libfsverity_digest {
+	uint16_t digest_algorithm;	/* one of FS_VERITY_HASH_ALG_* */
+	uint16_t digest_size;		/* size of digest in bytes */
+	uint8_t digest[];		/* the actual digest */
+};
+
+struct libfsverity_signature_params {
+	const char *keyfile;		/* path to key file (PEM format) */
+	const char *certfile;		/* path to certificate (PEM format) */
+	uint64_t reserved[11];		/* must be 0 */
+};
+
+/*
+ * libfsverity_read_fn_t - callback that incrementally provides a file's data
+ * @fd: the user-provided "file descriptor" (opaque to library)
+ * @buf: buffer into which to read the next chunk of the file's data
+ * @count: number of bytes to read in this chunk
+ *
+ * Must return 0 on success (all 'count' bytes read), or a negative errno value
+ * on failure.
+ */
+typedef int (*libfsverity_read_fn_t)(void *fd, void *buf, size_t count);
+
+/**
+ * libfsverity_compute_digest() - Compute digest of a file
+ *          An fsverity digest is the root of the Merkle tree of the file.
+ *          Not to be confused with a traditional file digests computed over
+ *          the entire file.
+ * @fd: context that will be passed to @read_fn
+ * @read_fn: a function that will read the data of the file
+ * @params: struct libfsverity_merkle_tree_params specifying hash algorithm,
+ *	    block size, version, and optional salt parameters.
+ *	    reserved parameters must be zero.
+ * @digest_ret: Pointer to pointer for computed digest.
+ *
+ * Returns:
+ * * 0 for success, -EINVAL for invalid input arguments, -ENOMEM if failed
+ *   to allocate memory, or an error returned by @read_fn.
+ * * digest_ret returns a pointer to the digest on success. The digest object
+ *   is allocated by libfsverity and must be freed by the caller.
+ */
+int
+libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
+			   const struct libfsverity_merkle_tree_params *params,
+			   struct libfsverity_digest **digest_ret);
+
+/**
+ * libfsverity_sign_digest() - Sign previously computed digest of a file
+ *          This signature is used by the file system to validate the
+ *          signed file measurement against a public key loaded into the
+ *          .fs-verity kernel keyring, when CONFIG_FS_VERITY_BUILTIN_SIGNATURES
+ *          is enabled. The signature is formatted as PKCS#7 stored in DER
+ *          format. See Documentation/filesystems/fsverity.rst in the kernel
+ *          source tree for further details.
+ * @digest: pointer to previously computed digest
+ * @sig_params: struct libfsverity_signature_params providing filenames of
+ *          the keyfile and certificate file. Reserved parameters must be zero.
+ * @sig_ret: Pointer to pointer for signed digest
+ * @sig_size_ret: Pointer to size of signed return digest
+ *
+ * Return:
+ * * 0 for success, -EINVAL for invalid input arguments or if the cryptographic
+ *   operations to sign the digest failed, -EBADMSG if the key and/or
+ *   certificate file is invalid, or another negative errno value.
+ * * sig_ret returns a pointer to the signed digest on success. This object
+ *   is allocated by libfsverity and must be freed by the caller.
+ * * sig_size_ret returns the size (in bytes) of the signed digest on success.
+ */
+int
+libfsverity_sign_digest(const struct libfsverity_digest *digest,
+			const struct libfsverity_signature_params *sig_params,
+			uint8_t **sig_ret, size_t *sig_size_ret);
+
+/**
+ * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
+ * @name: Pointer to name of hash algorithm
+ *
+ * Return: The hash algorithm number, or zero if not found.
+ */
+uint32_t libfsverity_find_hash_alg_by_name(const char *name);
+
+/**
+ * libfsverity_get_digest_size() - Get size of digest for a given algorithm
+ * @alg_num: Number of hash algorithm
+ *
+ * Return: size of digest in bytes, or -1 if algorithm is unknown.
+ */
+int libfsverity_get_digest_size(uint32_t alg_num);
+
+/**
+ * libfsverity_get_hash_name() - Get name of hash algorithm by number
+ * @alg_num: Number of hash algorithm
+ *
+ * Return: The name of the hash algorithm, or NULL if algorithm is unknown.
+ */
+const char *libfsverity_get_hash_name(uint32_t alg_num);
+
+/**
+ * libfsverity_set_error_callback() - Set callback to handle error messages
+ * @cb: the callback function
+ */
+void libfsverity_set_error_callback(void (*cb)(const char *msg));
+
+#endif /* LIBFSVERITY_H */
diff --git a/hash_algs.h b/hash_algs.h
deleted file mode 100644
index dc60b23..0000000
--- a/hash_algs.h
+++ /dev/null
@@ -1,68 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef HASH_ALGS_H
-#define HASH_ALGS_H
-
-#include "util.h"
-
-#include <stdio.h>
-
-struct fsverity_hash_alg {
-	const char *name;
-	unsigned int digest_size;
-	unsigned int block_size;
-	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
-};
-
-extern const struct fsverity_hash_alg fsverity_hash_algs[];
-
-struct hash_ctx {
-	const struct fsverity_hash_alg *alg;
-	void (*init)(struct hash_ctx *ctx);
-	void (*update)(struct hash_ctx *ctx, const void *data, size_t size);
-	void (*final)(struct hash_ctx *ctx, u8 *out);
-	void (*free)(struct hash_ctx *ctx);
-};
-
-const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name);
-const struct fsverity_hash_alg *find_hash_alg_by_num(unsigned int num);
-void show_all_hash_algs(FILE *fp);
-
-/* The hash algorithm that fsverity-utils assumes when none is specified */
-#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
-
-/*
- * Largest digest size among all hash algorithms supported by fs-verity.
- * This can be increased if needed.
- */
-#define FS_VERITY_MAX_DIGEST_SIZE	64
-
-static inline struct hash_ctx *hash_create(const struct fsverity_hash_alg *alg)
-{
-	return alg->create_ctx(alg);
-}
-
-static inline void hash_init(struct hash_ctx *ctx)
-{
-	ctx->init(ctx);
-}
-
-static inline void hash_update(struct hash_ctx *ctx,
-			       const void *data, size_t size)
-{
-	ctx->update(ctx, data, size);
-}
-
-static inline void hash_final(struct hash_ctx *ctx, u8 *digest)
-{
-	ctx->final(ctx, digest);
-}
-
-static inline void hash_free(struct hash_ctx *ctx)
-{
-	if (ctx)
-		ctx->free(ctx);
-}
-
-void hash_full(struct hash_ctx *ctx, const void *data, size_t size, u8 *digest);
-
-#endif /* HASH_ALGS_H */
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
index dbc291e..e41b23b 100644
--- a/lib/compute_digest.c
+++ b/lib/compute_digest.c
@@ -1,13 +1,13 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * compute_digest.c
+ * Implementation of libfsverity_compute_digest().
  *
  * Copyright 2018 Google LLC
+ * Copyright (C) 2020 Facebook
  */
 
-#include "sign.h"
+#include "lib_private.h"
 
-#include <fcntl.h>
 #include <stdlib.h>
 #include <string.h>
 
@@ -47,10 +47,10 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
 	/* Zero-pad the block if it's shorter than block_size. */
 	memset(&cur->data[cur->filled], 0, block_size - cur->filled);
 
-	hash_init(hash);
-	hash_update(hash, salt, salt_size);
-	hash_update(hash, cur->data, block_size);
-	hash_final(hash, &next->data[next->filled]);
+	libfsverity_hash_init(hash);
+	libfsverity_hash_update(hash, salt, salt_size);
+	libfsverity_hash_update(hash, cur->data, block_size);
+	libfsverity_hash_final(hash, &next->data[next->filled]);
 
 	next->filled += hash->alg->digest_size;
 	cur->filled = 0;
@@ -62,28 +62,42 @@ static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
  * Compute the file's Merkle tree root hash using the given hash algorithm,
  * block size, and salt.
  */
-static bool compute_root_hash(struct filedes *file, u64 file_size,
-			      struct hash_ctx *hash, u32 block_size,
-			      const u8 *salt, u32 salt_size, u8 *root_hash)
+static int compute_root_hash(void *fd, libfsverity_read_fn_t read_fn,
+			     u64 file_size, struct hash_ctx *hash,
+			     u32 block_size, const u8 *salt, u32 salt_size,
+			     u8 *root_hash)
 {
 	const u32 hashes_per_block = block_size / hash->alg->digest_size;
 	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
-	u8 *padded_salt = xzalloc(padded_salt_size);
+	u8 *padded_salt = NULL;
 	u64 blocks;
 	int num_levels = 0;
 	int level;
 	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
 	struct block_buffer *buffers = &_buffers[1];
 	u64 offset;
-	bool ok = false;
+	int err = 0;
 
-	if (salt_size != 0)
+	/* Root hash of empty file is all 0's */
+	if (file_size == 0) {
+		memset(root_hash, 0, hash->alg->digest_size);
+		return 0;
+	}
+
+	if (salt_size != 0) {
+		padded_salt = libfsverity_zalloc(padded_salt_size);
+		if (!padded_salt)
+			return -ENOMEM;
 		memcpy(padded_salt, salt, salt_size);
+	}
 
 	/* Compute number of levels */
 	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
 	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
-		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
+		if (WARN_ON(num_levels >= FS_VERITY_MAX_LEVELS)) {
+			err = -EINVAL;
+			goto out;
+		}
 		num_levels++;
 	}
 
@@ -92,22 +106,33 @@ static bool compute_root_hash(struct filedes *file, u64 file_size,
 	 * Buffers 0 <= level < num_levels are for the actual tree levels.
 	 * Buffer 'num_levels' is for the root hash.
 	 */
-	for (level = -1; level < num_levels; level++)
-		buffers[level].data = xmalloc(block_size);
+	for (level = -1; level < num_levels; level++) {
+		buffers[level].data = libfsverity_zalloc(block_size);
+		if (!buffers[level].data) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
 	buffers[num_levels].data = root_hash;
 
 	/* Hash each data block, also hashing the tree blocks as they fill up */
 	for (offset = 0; offset < file_size; offset += block_size) {
 		buffers[-1].filled = min(block_size, file_size - offset);
 
-		if (!full_read(file, buffers[-1].data, buffers[-1].filled))
+		err = read_fn(fd, buffers[-1].data, buffers[-1].filled);
+		if (err) {
+			libfsverity_error_msg("error reading file");
 			goto out;
+		}
 
 		level = -1;
 		while (hash_one_block(hash, &buffers[level], block_size,
 				      padded_salt, padded_salt_size)) {
 			level++;
-			ASSERT(level < num_levels);
+			if (WARN_ON(level >= num_levels)) {
+				err = -EINVAL;
+				goto out;
+			}
 		}
 	}
 	/* Finish all nonempty pending tree blocks */
@@ -118,67 +143,98 @@ static bool compute_root_hash(struct filedes *file, u64 file_size,
 	}
 
 	/* Root hash was filled by the last call to hash_one_block() */
-	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
-	ok = true;
+	if (WARN_ON(buffers[num_levels].filled != hash->alg->digest_size)) {
+		err = -EINVAL;
+		goto out;
+	}
+	err = 0;
 out:
 	for (level = -1; level < num_levels; level++)
 		free(buffers[level].data);
 	free(padded_salt);
-	return ok;
+	return err;
 }
 
-/*
- * Compute the fs-verity measurement of the given file.
- *
- * The fs-verity measurement is the hash of the fsverity_descriptor, which
- * contains the Merkle tree properties including the root hash.
- */
-bool compute_file_measurement(const char *filename,
-			      const struct fsverity_hash_alg *hash_alg,
-			      u32 block_size, const u8 *salt,
-			      u32 salt_size, u8 *measurement)
+LIBEXPORT int
+libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
+			   const struct libfsverity_merkle_tree_params *params,
+			   struct libfsverity_digest **digest_ret)
 {
-	struct filedes file = { .fd = -1 };
-	struct hash_ctx *hash = hash_create(hash_alg);
-	u64 file_size;
+	const struct fsverity_hash_alg *hash_alg;
+	struct hash_ctx *hash = NULL;
+	struct libfsverity_digest *digest;
 	struct fsverity_descriptor desc;
-	bool ok = false;
+	int i;
+	int err;
 
-	if (!open_file(&file, filename, O_RDONLY, 0))
-		goto out;
+	if (!read_fn || !params || !digest_ret) {
+		libfsverity_error_msg("missing required parameters for compute_digest");
+		return -EINVAL;
+	}
+	if (params->version != 1) {
+		libfsverity_error_msg("unsupported version (%u)",
+				      params->version);
+		return -EINVAL;
+	}
+	if (!is_power_of_2(params->block_size)) {
+		libfsverity_error_msg("unsupported block size (%u)",
+				      params->block_size);
+		return -EINVAL;
+	}
+	if (params->salt_size > sizeof(desc.salt)) {
+		libfsverity_error_msg("unsupported salt size (%u)",
+				      params->salt_size);
+		return -EINVAL;
+	}
+	if (params->salt_size && !params->salt)  {
+		libfsverity_error_msg("salt_size specified, but salt is NULL");
+		return -EINVAL;
+	}
+	for (i = 0; i < ARRAY_SIZE(params->reserved); i++) {
+		if (params->reserved[i]) {
+			libfsverity_error_msg("reserved bits set in merkle_tree_params");
+			return -EINVAL;
+		}
+	}
 
-	if (!get_file_size(&file, &file_size))
-		goto out;
+	hash_alg = libfsverity_find_hash_alg_by_num(params->hash_algorithm);
+	if (!hash_alg) {
+		libfsverity_error_msg("unknown hash algorithm: %u",
+				      params->hash_algorithm);
+		return -EINVAL;
+	}
+
+	hash = hash_alg->create_ctx(hash_alg);
+	if (!hash)
+		return -ENOMEM;
 
 	memset(&desc, 0, sizeof(desc));
 	desc.version = 1;
-	desc.hash_algorithm = hash_alg - fsverity_hash_algs;
-
-	ASSERT(is_power_of_2(block_size));
-	desc.log_blocksize = ilog2(block_size);
-
-	if (salt_size != 0) {
-		if (salt_size > sizeof(desc.salt)) {
-			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
-				  salt_size, sizeof(desc.salt));
-			goto out;
-		}
-		memcpy(desc.salt, salt, salt_size);
-		desc.salt_size = salt_size;
+	desc.hash_algorithm = params->hash_algorithm;
+	desc.log_blocksize = ilog2(params->block_size);
+	desc.data_size = cpu_to_le64(params->file_size);
+	if (params->salt_size != 0) {
+		memcpy(desc.salt, params->salt, params->salt_size);
+		desc.salt_size = params->salt_size;
 	}
 
-	desc.data_size = cpu_to_le64(file_size);
-
-	/* Root hash of empty file is all 0's */
-	if (file_size != 0 &&
-	    !compute_root_hash(&file, file_size, hash, block_size, salt,
-			       salt_size, desc.root_hash))
+	err = compute_root_hash(fd, read_fn, params->file_size, hash,
+				params->block_size, params->salt,
+				params->salt_size, desc.root_hash);
+	if (err)
 		goto out;
 
-	hash_full(hash, &desc, sizeof(desc), measurement);
-	ok = true;
+	digest = libfsverity_zalloc(sizeof(*digest) + hash_alg->digest_size);
+	if (!digest) {
+		err = -ENOMEM;
+		goto out;
+	}
+	digest->digest_algorithm = params->hash_algorithm;
+	digest->digest_size = hash_alg->digest_size;
+	libfsverity_hash_full(hash, &desc, sizeof(desc), digest->digest);
+	*digest_ret = digest;
+	err = 0;
 out:
-	filedes_close(&file);
-	hash_free(hash);
-	return ok;
+	libfsverity_free_hash_ctx(hash);
+	return err;
 }
diff --git a/hash_algs.c b/lib/hash_algs.c
similarity index 53%
rename from hash_algs.c
rename to lib/hash_algs.c
index c0537b8..ac3acd3 100644
--- a/hash_algs.c
+++ b/lib/hash_algs.c
@@ -5,8 +5,7 @@
  * Copyright 2018 Google LLC
  */
 
-#include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "lib_private.h"
 
 #include <openssl/evp.h>
 #include <stdlib.h>
@@ -23,29 +22,29 @@ struct openssl_hash_ctx {
 static void openssl_digest_init(struct hash_ctx *_ctx)
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
+	int ret;
 
-	if (EVP_DigestInit_ex(ctx->md_ctx, ctx->md, NULL) != 1)
-		fatal_error("EVP_DigestInit_ex() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	ret = EVP_DigestInit_ex(ctx->md_ctx, ctx->md, NULL);
+	BUG_ON(ret != 1);
 }
 
 static void openssl_digest_update(struct hash_ctx *_ctx,
 				  const void *data, size_t size)
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
+	int ret;
 
-	if (EVP_DigestUpdate(ctx->md_ctx, data, size) != 1)
-		fatal_error("EVP_DigestUpdate() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	ret = EVP_DigestUpdate(ctx->md_ctx, data, size);
+	BUG_ON(ret != 1);
 }
 
 static void openssl_digest_final(struct hash_ctx *_ctx, u8 *digest)
 {
 	struct openssl_hash_ctx *ctx = (void *)_ctx;
+	int ret;
 
-	if (EVP_DigestFinal_ex(ctx->md_ctx, digest, NULL) != 1)
-		fatal_error("EVP_DigestFinal_ex() failed for algorithm '%s'",
-			    ctx->base.alg->name);
+	ret = EVP_DigestFinal_ex(ctx->md_ctx, digest, NULL);
+	BUG_ON(ret != 1);
 }
 
 static void openssl_digest_ctx_free(struct hash_ctx *_ctx)
@@ -66,7 +65,10 @@ openssl_digest_ctx_create(const struct fsverity_hash_alg *alg, const EVP_MD *md)
 {
 	struct openssl_hash_ctx *ctx;
 
-	ctx = xzalloc(sizeof(*ctx));
+	ctx = libfsverity_zalloc(sizeof(*ctx));
+	if (!ctx)
+		return NULL;
+
 	ctx->base.alg = alg;
 	ctx->base.init = openssl_digest_init;
 	ctx->base.update = openssl_digest_update;
@@ -78,13 +80,22 @@ openssl_digest_ctx_create(const struct fsverity_hash_alg *alg, const EVP_MD *md)
 	 * with older OpenSSL versions.
 	 */
 	ctx->md_ctx = EVP_MD_CTX_create();
-	if (!ctx->md_ctx)
-		fatal_error("out of memory");
+	if (!ctx->md_ctx) {
+		libfsverity_error_msg("failed to allocate EVP_MD_CTX");
+		goto err1;
+	}
 
 	ctx->md = md;
-	ASSERT(EVP_MD_size(md) == alg->digest_size);
+	if (WARN_ON(EVP_MD_size(md) != alg->digest_size))
+		goto err2;
 
 	return &ctx->base;
+
+err2:
+	EVP_MD_CTX_destroy(ctx->md_ctx);
+err1:
+	free(ctx);
+	return NULL;
 }
 
 static struct hash_ctx *create_sha256_ctx(const struct fsverity_hash_alg *alg)
@@ -97,9 +108,42 @@ static struct hash_ctx *create_sha512_ctx(const struct fsverity_hash_alg *alg)
 	return openssl_digest_ctx_create(alg, EVP_sha512());
 }
 
+/* ========== Hash utilities ========== */
+
+void libfsverity_hash_init(struct hash_ctx *ctx)
+{
+	ctx->init(ctx);
+}
+
+void libfsverity_hash_update(struct hash_ctx *ctx, const void *data,
+			     size_t size)
+{
+	ctx->update(ctx, data, size);
+}
+
+void libfsverity_hash_final(struct hash_ctx *ctx, u8 *digest)
+{
+	ctx->final(ctx, digest);
+}
+
+/* ->init(), ->update(), and ->final() all in one step */
+void libfsverity_hash_full(struct hash_ctx *ctx, const void *data, size_t size,
+			   u8 *digest)
+{
+	libfsverity_hash_init(ctx);
+	libfsverity_hash_update(ctx, data, size);
+	libfsverity_hash_final(ctx, digest);
+}
+
+void libfsverity_free_hash_ctx(struct hash_ctx *ctx)
+{
+	if (ctx)
+		ctx->free(ctx);
+}
+
 /* ========== Hash algorithm definitions ========== */
 
-const struct fsverity_hash_alg fsverity_hash_algs[] = {
+static const struct fsverity_hash_alg libfsverity_hash_algs[] = {
 	[FS_VERITY_HASH_ALG_SHA256] = {
 		.name = "sha256",
 		.digest_size = 32,
@@ -114,48 +158,45 @@ const struct fsverity_hash_alg fsverity_hash_algs[] = {
 	},
 };
 
-const struct fsverity_hash_alg *find_hash_alg_by_name(const char *name)
+LIBEXPORT u32
+libfsverity_find_hash_alg_by_name(const char *name)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(fsverity_hash_algs); i++) {
-		if (fsverity_hash_algs[i].name &&
-		    !strcmp(name, fsverity_hash_algs[i].name))
-			return &fsverity_hash_algs[i];
+	if (!name)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(libfsverity_hash_algs); i++) {
+		if (libfsverity_hash_algs[i].name &&
+		    !strcmp(name, libfsverity_hash_algs[i].name))
+			return i;
 	}
-	error_msg("unknown hash algorithm: '%s'", name);
-	fputs("Available hash algorithms: ", stderr);
-	show_all_hash_algs(stderr);
-	putc('\n', stderr);
-	return NULL;
+	return 0;
 }
 
-const struct fsverity_hash_alg *find_hash_alg_by_num(unsigned int num)
+const struct fsverity_hash_alg *libfsverity_find_hash_alg_by_num(u32 alg_num)
 {
-	if (num < ARRAY_SIZE(fsverity_hash_algs) &&
-	    fsverity_hash_algs[num].name)
-		return &fsverity_hash_algs[num];
+	if (alg_num < ARRAY_SIZE(libfsverity_hash_algs) &&
+	    libfsverity_hash_algs[alg_num].name)
+		return &libfsverity_hash_algs[alg_num];
 
 	return NULL;
 }
 
-void show_all_hash_algs(FILE *fp)
+LIBEXPORT int
+libfsverity_get_digest_size(u32 alg_num)
 {
-	int i;
-	const char *sep = "";
+	const struct fsverity_hash_alg *alg =
+		libfsverity_find_hash_alg_by_num(alg_num);
 
-	for (i = 0; i < ARRAY_SIZE(fsverity_hash_algs); i++) {
-		if (fsverity_hash_algs[i].name) {
-			fprintf(fp, "%s%s", sep, fsverity_hash_algs[i].name);
-			sep = ", ";
-		}
-	}
+	return alg ? alg->digest_size : -1;
 }
 
-/* ->init(), ->update(), and ->final() all in one step */
-void hash_full(struct hash_ctx *ctx, const void *data, size_t size, u8 *digest)
+LIBEXPORT const char *
+libfsverity_get_hash_name(u32 alg_num)
 {
-	hash_init(ctx);
-	hash_update(ctx, data, size);
-	hash_final(ctx, digest);
+	const struct fsverity_hash_alg *alg =
+		libfsverity_find_hash_alg_by_num(alg_num);
+
+	return alg ? alg->name : NULL;
 }
diff --git a/lib/lib_private.h b/lib/lib_private.h
new file mode 100644
index 0000000..998d765
--- /dev/null
+++ b/lib/lib_private.h
@@ -0,0 +1,83 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Private header for libfsverity
+ *
+ * Copyright 2020 Google LLC
+ */
+#ifndef LIB_LIB_PRIVATE_H
+#define LIB_LIB_PRIVATE_H
+
+#include "../common/libfsverity.h"
+#include "../common/common_defs.h"
+#include "../common/fsverity_uapi.h"
+
+#include <stdarg.h>
+
+#define LIBEXPORT	__attribute__((visibility("default")))
+
+/* hash_algs.c */
+
+struct fsverity_hash_alg {
+	const char *name;
+	unsigned int digest_size;
+	unsigned int block_size;
+	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
+};
+
+const struct fsverity_hash_alg *libfsverity_find_hash_alg_by_num(u32 alg_num);
+
+struct hash_ctx {
+	const struct fsverity_hash_alg *alg;
+	void (*init)(struct hash_ctx *ctx);
+	void (*update)(struct hash_ctx *ctx, const void *data, size_t size);
+	void (*final)(struct hash_ctx *ctx, u8 *out);
+	void (*free)(struct hash_ctx *ctx);
+};
+
+void libfsverity_hash_init(struct hash_ctx *ctx);
+void libfsverity_hash_update(struct hash_ctx *ctx, const void *data,
+			     size_t size);
+void libfsverity_hash_final(struct hash_ctx *ctx, u8 *digest);
+void libfsverity_hash_full(struct hash_ctx *ctx, const void *data, size_t size,
+			   u8 *digest);
+void libfsverity_free_hash_ctx(struct hash_ctx *ctx);
+
+/* utils.c */
+
+void *libfsverity_zalloc(size_t size);
+void *libfsverity_memdup(const void *mem, size_t size);
+
+__cold void
+libfsverity_do_error_msg(const char *format, va_list va, int err);
+
+__printf(1, 2) __cold void
+libfsverity_error_msg(const char *format, ...);
+
+__printf(1, 2) __cold void
+libfsverity_error_msg_errno(const char *format, ...);
+
+__cold void
+libfsverity_warn_on(const char *condition, const char *file, int line);
+
+#define WARN_ON(condition)						\
+({									\
+	bool c = (condition);						\
+									\
+	if (c)								\
+		libfsverity_warn_on(#condition, __FILE__, __LINE__);	\
+	c;								\
+})
+
+__cold void
+libfsverity_bug_on(const char *condition, const char *file, int line);
+
+#define BUG_ON(condition)						\
+({									\
+	bool c = (condition);						\
+									\
+	if (c)								\
+		libfsverity_bug_on(#condition, __FILE__, __LINE__);	\
+	c;								\
+})
+
+#endif /* LIB_LIB_PRIVATE_H */
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index c98428f..218085d 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -1,45 +1,71 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * sign_digest.c
+ * Implementation of libfsverity_sign_digest().
  *
  * Copyright 2018 Google LLC
+ * Copyright (C) 2020 Facebook
  */
 
-#include "hash_algs.h"
-#include "sign.h"
+#include "lib_private.h"
 
 #include <limits.h>
 #include <openssl/bio.h>
 #include <openssl/err.h>
 #include <openssl/pem.h>
 #include <openssl/pkcs7.h>
+#include <string.h>
+
+/*
+ * Format in which verity file measurements are signed.  This is the same as
+ * 'struct fsverity_digest', except here some magic bytes are prepended to
+ * provide some context about what is being signed in case the same key is used
+ * for non-fsverity purposes, and here the fields have fixed endianness.
+ */
+struct fsverity_signed_digest {
+	char magic[8];			/* must be "FSVerity" */
+	__le16 digest_algorithm;
+	__le16 digest_size;
+	__u8 digest[];
+};
+
+static int print_openssl_err_cb(const char *str,
+				size_t len __attribute__((unused)),
+				void *u __attribute__((unused)))
+{
+	libfsverity_error_msg("%s", str);
+	return 1;
+}
 
 static void __printf(1, 2) __cold
 error_msg_openssl(const char *format, ...)
 {
+	int saved_errno = errno;
 	va_list va;
 
 	va_start(va, format);
-	do_error_msg(format, va, 0);
+	libfsverity_do_error_msg(format, va, 0);
 	va_end(va);
 
 	if (ERR_peek_error() == 0)
 		return;
 
-	fprintf(stderr, "OpenSSL library errors:\n");
-	ERR_print_errors_fp(stderr);
+	libfsverity_error_msg("OpenSSL library errors:");
+	ERR_print_errors_cb(print_openssl_err_cb, NULL);
+	errno = saved_errno;
 }
 
 /* Read a PEM PKCS#8 formatted private key */
-static EVP_PKEY *read_private_key(const char *keyfile)
+static int read_private_key(const char *keyfile, EVP_PKEY **pkey_ret)
 {
 	BIO *bio;
 	EVP_PKEY *pkey;
+	int err;
 
+	errno = 0;
 	bio = BIO_new_file(keyfile, "r");
 	if (!bio) {
 		error_msg_openssl("can't open '%s' for reading", keyfile);
-		return NULL;
+		return errno ? -errno : -EIO;
 	}
 
 	pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
@@ -47,38 +73,51 @@ static EVP_PKEY *read_private_key(const char *keyfile)
 		error_msg_openssl("Failed to parse private key file '%s'.\n"
 				  "       Note: it must be in PEM PKCS#8 format.",
 				  keyfile);
+		err = -EBADMSG;
+		goto out;
 	}
+	*pkey_ret = pkey;
+	err = 0;
+out:
 	BIO_free(bio);
-	return pkey;
+	return err;
 }
 
 /* Read a PEM X.509 formatted certificate */
-static X509 *read_certificate(const char *certfile)
+static int read_certificate(const char *certfile, X509 **cert_ret)
 {
 	BIO *bio;
 	X509 *cert;
+	int err;
 
+	errno = 0;
 	bio = BIO_new_file(certfile, "r");
 	if (!bio) {
 		error_msg_openssl("can't open '%s' for reading", certfile);
-		return NULL;
+		return errno ? -errno : -EIO;
 	}
 	cert = PEM_read_bio_X509(bio, NULL, NULL, NULL);
 	if (!cert) {
 		error_msg_openssl("Failed to parse X.509 certificate file '%s'.\n"
 				  "       Note: it must be in PEM format.",
 				  certfile);
+		err = -EBADMSG;
+		goto out;
 	}
+	*cert_ret = cert;
+	err = 0;
+out:
 	BIO_free(bio);
-	return cert;
+	return err;
 }
 
 #ifdef OPENSSL_IS_BORINGSSL
 
-static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
-		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, u32 *sig_size_ret)
+static int sign_pkcs7(const void *data_to_sign, size_t data_size,
+		      EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
+		      u8 **sig_ret, size_t *sig_size_ret)
 {
+	BIGNUM *serial;
 	CBB out, outer_seq, wrapped_seq, seq, digest_algos_set, digest_algo,
 		null, content_info, issuer_and_serial, signer_infos,
 		signer_info, sign_algo, signature;
@@ -86,31 +125,39 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	u8 *name_der = NULL, *sig = NULL, *pkcs7_data = NULL;
 	size_t pkcs7_data_len, sig_len;
 	int name_der_len, sig_nid;
-	bool ok = false;
+	int err;
 
 	EVP_MD_CTX_init(&md_ctx);
-	BIGNUM *serial = ASN1_INTEGER_to_BN(X509_get_serialNumber(cert), NULL);
+	serial = ASN1_INTEGER_to_BN(X509_get_serialNumber(cert), NULL);
 
 	if (!CBB_init(&out, 1024)) {
-		error_msg("out of memory");
+		error_msg_openssl("out of memory");
+		err = -ENOMEM;
 		goto out;
 	}
 
 	name_der_len = i2d_X509_NAME(X509_get_subject_name(cert), &name_der);
 	if (name_der_len < 0) {
 		error_msg_openssl("i2d_X509_NAME failed");
+		err = -EINVAL;
 		goto out;
 	}
 
 	if (!EVP_DigestSignInit(&md_ctx, NULL, md, NULL, pkey)) {
 		error_msg_openssl("EVP_DigestSignInit failed");
+		err = -EINVAL;
 		goto out;
 	}
 
 	sig_len = EVP_PKEY_size(pkey);
-	sig = xmalloc(sig_len);
+	sig = libfsverity_zalloc(sig_len);
+	if (!sig) {
+		err = -ENOMEM;
+		goto out;
+	}
 	if (!EVP_DigestSign(&md_ctx, sig, &sig_len, data_to_sign, data_size)) {
 		error_msg_openssl("EVP_DigestSign failed");
+		err = -EINVAL;
 		goto out;
 	}
 
@@ -153,12 +200,17 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	    !CBB_add_bytes(&signature, sig, sig_len) ||
 	    !CBB_finish(&out, &pkcs7_data, &pkcs7_data_len)) {
 		error_msg_openssl("failed to construct PKCS#7 data");
+		err = -EINVAL;
 		goto out;
 	}
 
-	*sig_ret = xmemdup(pkcs7_data, pkcs7_data_len);
+	*sig_ret = libfsverity_memdup(pkcs7_data, pkcs7_data_len);
+	if (!*sig_ret) {
+		err = -ENOMEM;
+		goto out;
+	}
 	*sig_size_ret = pkcs7_data_len;
-	ok = true;
+	err = 0;
 out:
 	BN_free(serial);
 	EVP_MD_CTX_cleanup(&md_ctx);
@@ -166,7 +218,7 @@ out:
 	free(sig);
 	OPENSSL_free(name_der);
 	OPENSSL_free(pkcs7_data);
-	return ok;
+	return err;
 }
 
 #else /* OPENSSL_IS_BORINGSSL */
@@ -175,7 +227,9 @@ static BIO *new_mem_buf(const void *buf, size_t size)
 {
 	BIO *bio;
 
-	ASSERT(size <= INT_MAX);
+	if (WARN_ON(size > INT_MAX))
+		return NULL;
+
 	/*
 	 * Prior to OpenSSL 1.1.0, BIO_new_mem_buf() took a non-const pointer,
 	 * despite still marking the resulting bio as read-only.  So cast away
@@ -187,9 +241,9 @@ static BIO *new_mem_buf(const void *buf, size_t size)
 	return bio;
 }
 
-static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
-		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, u32 *sig_size_ret)
+static int sign_pkcs7(const void *data_to_sign, size_t data_size,
+		      EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
+		      u8 **sig_ret, size_t *sig_size_ret)
 {
 	/*
 	 * PKCS#7 signing flags:
@@ -215,25 +269,30 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	u32 sig_size;
 	BIO *bio = NULL;
 	PKCS7 *p7 = NULL;
-	bool ok = false;
+	int err;
 
 	bio = new_mem_buf(data_to_sign, data_size);
-	if (!bio)
+	if (!bio) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	p7 = PKCS7_sign(NULL, NULL, NULL, bio, pkcs7_flags);
 	if (!p7) {
 		error_msg_openssl("failed to initialize PKCS#7 signature object");
+		err = -EINVAL;
 		goto out;
 	}
 
 	if (!PKCS7_sign_add_signer(p7, cert, pkey, md, pkcs7_flags)) {
 		error_msg_openssl("failed to add signer to PKCS#7 signature object");
+		err = -EINVAL;
 		goto out;
 	}
 
 	if (PKCS7_final(p7, bio, pkcs7_flags) != 1) {
 		error_msg_openssl("failed to finalize PKCS#7 signature");
+		err = -EINVAL;
 		goto out;
 	}
 
@@ -241,64 +300,100 @@ static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
 	bio = BIO_new(BIO_s_mem());
 	if (!bio) {
 		error_msg_openssl("out of memory");
+		err = -ENOMEM;
 		goto out;
 	}
 
 	if (i2d_PKCS7_bio(bio, p7) != 1) {
 		error_msg_openssl("failed to DER-encode PKCS#7 signature object");
+		err = -EINVAL;
 		goto out;
 	}
 
 	sig_size = BIO_get_mem_data(bio, &sig);
-	*sig_ret = xmemdup(sig, sig_size);
+	*sig_ret = libfsverity_memdup(sig, sig_size);
+	if (!*sig_ret) {
+		err = -ENOMEM;
+		goto out;
+	}
 	*sig_size_ret = sig_size;
-	ok = true;
+	err = 0;
 out:
 	PKCS7_free(p7);
 	BIO_free(bio);
-	return ok;
+	return err;
 }
 
 #endif /* !OPENSSL_IS_BORINGSSL */
 
-/*
- * Sign the specified @data_to_sign of length @data_size bytes using the private
- * key in @keyfile, the certificate in @certfile, and the hash algorithm
- * @hash_alg.  Returns the DER-formatted PKCS#7 signature in @sig_ret and
- * @sig_size_ret.
- */
-bool sign_data(const void *data_to_sign, size_t data_size,
-	       const char *keyfile, const char *certfile,
-	       const struct fsverity_hash_alg *hash_alg,
-	       u8 **sig_ret, u32 *sig_size_ret)
+LIBEXPORT int
+libfsverity_sign_digest(const struct libfsverity_digest *digest,
+			const struct libfsverity_signature_params *sig_params,
+			u8 **sig_ret, size_t *sig_size_ret)
 {
+	int i;
+	const struct fsverity_hash_alg *hash_alg;
 	EVP_PKEY *pkey = NULL;
 	X509 *cert = NULL;
 	const EVP_MD *md;
-	bool ok = false;
+	struct fsverity_signed_digest *d = NULL;
+	int err;
+
+	if (!digest || !sig_params || !sig_ret || !sig_size_ret)  {
+		libfsverity_error_msg("missing required parameters for sign_digest");
+		return -EINVAL;
+	}
+
+	if (!sig_params->keyfile || !sig_params->certfile) {
+		libfsverity_error_msg("keyfile and certfile must be specified");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(sig_params->reserved); i++) {
+		if (sig_params->reserved[i]) {
+			libfsverity_error_msg("reserved bits set in signature_params");
+			return -EINVAL;
+		}
+	}
+
+	hash_alg = libfsverity_find_hash_alg_by_num(digest->digest_algorithm);
+	if (!hash_alg || digest->digest_size != hash_alg->digest_size) {
+		libfsverity_error_msg("malformed fsverity digest");
+		return -EINVAL;
+	}
 
-	pkey = read_private_key(keyfile);
-	if (!pkey)
+	err = read_private_key(sig_params->keyfile, &pkey);
+	if (err)
 		goto out;
 
-	cert = read_certificate(certfile);
-	if (!cert)
+	err = read_certificate(sig_params->certfile, &cert);
+	if (err)
 		goto out;
 
 	OpenSSL_add_all_digests();
 	md = EVP_get_digestbyname(hash_alg->name);
 	if (!md) {
-		fprintf(stderr,
-			"Warning: '%s' algorithm not found in OpenSSL library.\n"
-			"         Falling back to SHA-256 signature.\n",
-			hash_alg->name);
-		md = EVP_sha256();
+		libfsverity_error_msg("'%s' algorithm not found in OpenSSL library",
+				      hash_alg->name);
+		err = -ENOPKG;
+		goto out;
 	}
 
-	ok = sign_pkcs7(data_to_sign, data_size, pkey, cert, md,
-			sig_ret, sig_size_ret);
-out:
+	d = libfsverity_zalloc(sizeof(*d) + digest->digest_size);
+	if (!d) {
+		err = -ENOMEM;
+		goto out;
+	}
+	memcpy(d->magic, "FSVerity", 8);
+	d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
+	d->digest_size = cpu_to_le16(digest->digest_size);
+	memcpy(d->digest, digest->digest, digest->digest_size);
+
+	err = sign_pkcs7(d, sizeof(*d) + digest->digest_size,
+			 pkey, cert, md, sig_ret, sig_size_ret);
+ out:
 	EVP_PKEY_free(pkey);
 	X509_free(cert);
-	return ok;
+	free(d);
+	return err;
 }
diff --git a/lib/utils.c b/lib/utils.c
new file mode 100644
index 0000000..53e4381
--- /dev/null
+++ b/lib/utils.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Utility functions for libfsverity
+ *
+ * Copyright 2020 Google LLC
+ */
+
+#define _GNU_SOURCE /* for asprintf() and strerror_r() */
+
+#include "lib_private.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static void *xmalloc(size_t size)
+{
+	void *p = malloc(size);
+
+	if (!p)
+		libfsverity_error_msg("out of memory (tried to allocate %zu bytes)",
+				      size);
+	return p;
+}
+
+void *libfsverity_zalloc(size_t size)
+{
+	void *p = xmalloc(size);
+
+	if (!p)
+		return NULL;
+	return memset(p, 0, size);
+}
+
+void *libfsverity_memdup(const void *mem, size_t size)
+{
+	void *p = xmalloc(size);
+
+	if (!p)
+		return NULL;
+	return memcpy(p, mem, size);
+}
+
+static void (*libfsverity_error_cb)(const char *msg);
+
+LIBEXPORT void
+libfsverity_set_error_callback(void (*cb)(const char *msg))
+{
+	libfsverity_error_cb = cb;
+}
+
+void libfsverity_do_error_msg(const char *format, va_list va, int err)
+{
+	int saved_errno = errno;
+	char *msg = NULL;
+
+	if (!libfsverity_error_cb)
+		return;
+
+	if (vasprintf(&msg, format, va) < 0)
+		goto out;
+
+	if (err) {
+		char *msg2 = NULL;
+		char errbuf[64];
+
+		if (asprintf(&msg2, "%s: %s", msg,
+			     strerror_r(err, errbuf, sizeof(errbuf))) < 0)
+			goto out2;
+		free(msg);
+		msg = msg2;
+	}
+	(*libfsverity_error_cb)(msg);
+out2:
+	free(msg);
+out:
+	errno = saved_errno;
+}
+
+void libfsverity_error_msg(const char *format, ...)
+{
+	va_list va;
+
+	va_start(va, format);
+	libfsverity_do_error_msg(format, va, 0);
+	va_end(va);
+}
+
+void libfsverity_error_msg_errno(const char *format, ...)
+{
+	va_list va;
+
+	va_start(va, format);
+	libfsverity_do_error_msg(format, va, errno);
+	va_end(va);
+}
+
+void libfsverity_warn_on(const char *condition, const char *file, int line)
+{
+	fprintf(stderr, "libfsverity internal error! %s at %s:%d\n",
+		condition, file, line);
+}
+
+void libfsverity_bug_on(const char *condition, const char *file, int line)
+{
+	fprintf(stderr, "libfsverity internal error! %s at %s:%d\n"
+		"Non-recoverable, aborting program.\n", condition, file, line);
+	abort();
+}
diff --git a/cmd_enable.c b/programs/cmd_enable.c
similarity index 81%
rename from cmd_enable.c
rename to programs/cmd_enable.c
index 38e7d65..f1c0806 100644
--- a/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -5,43 +5,13 @@
  * Copyright 2018 Google LLC
  */
 
-#include "commands.h"
-#include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "fsverity.h"
 
 #include <fcntl.h>
 #include <getopt.h>
 #include <limits.h>
-#include <stdlib.h>
-#include <string.h>
 #include <sys/ioctl.h>
 
-static bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
-{
-	char *end;
-	unsigned long n = strtoul(arg, &end, 10);
-	const struct fsverity_hash_alg *alg;
-
-	if (*alg_ptr != 0) {
-		error_msg("--hash-alg can only be specified once");
-		return false;
-	}
-
-	/* Specified by number? */
-	if (n > 0 && n < INT32_MAX && *end == '\0') {
-		*alg_ptr = n;
-		return true;
-	}
-
-	/* Specified by name? */
-	alg = find_hash_alg_by_name(arg);
-	if (alg != NULL) {
-		*alg_ptr = alg - fsverity_hash_algs;
-		return true;
-	}
-	return false;
-}
-
 static bool read_signature(const char *filename, u8 **sig_ret,
 			   u32 *sig_size_ret)
 {
diff --git a/cmd_measure.c b/programs/cmd_measure.c
similarity index 83%
rename from cmd_measure.c
rename to programs/cmd_measure.c
index 1b2fc7b..4e6cb2b 100644
--- a/cmd_measure.c
+++ b/programs/cmd_measure.c
@@ -5,12 +5,9 @@
  * Copyright 2018 Google LLC
  */
 
-#include "commands.h"
-#include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "fsverity.h"
 
 #include <fcntl.h>
-#include <stdlib.h>
 #include <sys/ioctl.h>
 
 /* Display the measurement of the given verity file(s). */
@@ -20,7 +17,6 @@ int fsverity_cmd_measure(const struct fsverity_command *cmd,
 	struct fsverity_digest *d = NULL;
 	struct filedes file;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
-	const struct fsverity_hash_alg *hash_alg;
 	char _hash_alg_name[32];
 	const char *hash_alg_name;
 	int status;
@@ -46,10 +42,8 @@ int fsverity_cmd_measure(const struct fsverity_command *cmd,
 
 		ASSERT(d->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
 		bin2hex(d->digest, d->digest_size, digest_hex);
-		hash_alg = find_hash_alg_by_num(d->digest_algorithm);
-		if (hash_alg) {
-			hash_alg_name = hash_alg->name;
-		} else {
+		hash_alg_name = libfsverity_get_hash_name(d->digest_algorithm);
+		if (!hash_alg_name) {
 			sprintf(_hash_alg_name, "ALG_%u", d->digest_algorithm);
 			hash_alg_name = _hash_alg_name;
 		}
diff --git a/cmd_sign.c b/programs/cmd_sign.c
similarity index 53%
rename from cmd_sign.c
rename to programs/cmd_sign.c
index 0e69378..3381ca5 100644
--- a/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -5,14 +5,10 @@
  * Copyright 2018 Google LLC
  */
 
-#include "commands.h"
-#include "fsverity_uapi.h"
-#include "sign.h"
+#include "fsverity.h"
 
 #include <fcntl.h>
 #include <getopt.h>
-#include <stdlib.h>
-#include <string.h>
 
 static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 {
@@ -43,55 +39,60 @@ static const struct option longopts[] = {
 	{NULL, 0, NULL, 0}
 };
 
+static int read_callback(void *file, void *buf, size_t count)
+{
+	errno = 0;
+	if (!full_read(file, buf, count))
+		return errno ? -errno : -EIO;
+	return 0;
+}
+
 /* Sign a file for fs-verity by computing its measurement, then signing it. */
 int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		      int argc, char *argv[])
 {
-	const struct fsverity_hash_alg *hash_alg = NULL;
-	u32 block_size = 0;
+	struct filedes file = { .fd = -1 };
 	u8 *salt = NULL;
-	u32 salt_size = 0;
-	const char *keyfile = NULL;
-	const char *certfile = NULL;
-	struct fsverity_signed_digest *digest = NULL;
+	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
+	struct libfsverity_signature_params sig_params = {};
+	struct libfsverity_digest *digest = NULL;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
 	u8 *sig = NULL;
-	u32 sig_size;
+	size_t sig_size;
 	int status;
 	int c;
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_HASH_ALG:
-			if (hash_alg != NULL) {
-				error_msg("--hash-alg can only be specified once");
-				goto out_usage;
-			}
-			hash_alg = find_hash_alg_by_name(optarg);
-			if (hash_alg == NULL)
+			if (!parse_hash_alg_option(optarg,
+						   &tree_params.hash_algorithm))
 				goto out_usage;
 			break;
 		case OPT_BLOCK_SIZE:
-			if (!parse_block_size_option(optarg, &block_size))
+			if (!parse_block_size_option(optarg,
+						     &tree_params.block_size))
 				goto out_usage;
 			break;
 		case OPT_SALT:
-			if (!parse_salt_option(optarg, &salt, &salt_size))
+			if (!parse_salt_option(optarg, &salt,
+					       &tree_params.salt_size))
 				goto out_usage;
+			tree_params.salt = salt;
 			break;
 		case OPT_KEY:
-			if (keyfile != NULL) {
+			if (sig_params.keyfile != NULL) {
 				error_msg("--key can only be specified once");
 				goto out_usage;
 			}
-			keyfile = optarg;
+			sig_params.keyfile = optarg;
 			break;
 		case OPT_CERT:
-			if (certfile != NULL) {
+			if (sig_params.certfile != NULL) {
 				error_msg("--cert can only be specified once");
 				goto out_usage;
 			}
-			certfile = optarg;
+			sig_params.certfile = optarg;
 			break;
 		default:
 			goto out_usage;
@@ -104,40 +105,48 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (argc != 2)
 		goto out_usage;
 
-	if (hash_alg == NULL)
-		hash_alg = &fsverity_hash_algs[FS_VERITY_HASH_ALG_DEFAULT];
+	if (tree_params.hash_algorithm == 0)
+		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
 
-	if (block_size == 0)
-		block_size = get_default_block_size();
+	if (tree_params.block_size == 0)
+		tree_params.block_size = get_default_block_size();
 
-	if (keyfile == NULL) {
+	if (sig_params.keyfile == NULL) {
 		error_msg("Missing --key argument");
 		goto out_usage;
 	}
-	if (certfile == NULL)
-		certfile = keyfile;
+	if (sig_params.certfile == NULL)
+		sig_params.certfile = sig_params.keyfile;
 
-	digest = xzalloc(sizeof(*digest) + hash_alg->digest_size);
-	memcpy(digest->magic, "FSVerity", 8);
-	digest->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
-	digest->digest_size = cpu_to_le16(hash_alg->digest_size);
+	if (!open_file(&file, argv[0], O_RDONLY, 0))
+		goto out_err;
 
-	if (!compute_file_measurement(argv[0], hash_alg, block_size,
-				      salt, salt_size, digest->digest))
+	if (!get_file_size(&file, &tree_params.file_size))
 		goto out_err;
 
-	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
-		       keyfile, certfile, hash_alg, &sig, &sig_size))
+	if (libfsverity_compute_digest(&file, read_callback,
+				       &tree_params, &digest) != 0) {
+		error_msg("failed to compute digest");
 		goto out_err;
+	}
+
+	if (libfsverity_sign_digest(digest, &sig_params,
+				    &sig, &sig_size) != 0) {
+		error_msg("failed to sign digest");
+		goto out_err;
+	}
 
 	if (!write_signature(argv[1], sig, sig_size))
 		goto out_err;
 
-	bin2hex(digest->digest, hash_alg->digest_size, digest_hex);
-	printf("Signed file '%s' (%s:%s)\n", argv[0], hash_alg->name,
+	ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
+	bin2hex(digest->digest, digest->digest_size, digest_hex);
+	printf("Signed file '%s' (%s:%s)\n", argv[0],
+	       libfsverity_get_hash_name(tree_params.hash_algorithm),
 	       digest_hex);
 	status = 0;
 out:
+	filedes_close(&file);
 	free(salt);
 	free(digest);
 	free(sig);
diff --git a/fsverity.c b/programs/fsverity.c
similarity index 82%
rename from fsverity.c
rename to programs/fsverity.c
index 3258d92..1a90cba 100644
--- a/fsverity.c
+++ b/programs/fsverity.c
@@ -5,12 +5,9 @@
  * Copyright 2018 Google LLC
  */
 
-#include "commands.h"
-#include "hash_algs.h"
+#include "fsverity.h"
 
 #include <limits.h>
-#include <stdlib.h>
-#include <string.h>
 #include <unistd.h>
 
 static const struct fsverity_command {
@@ -45,6 +42,17 @@ static const struct fsverity_command {
 	}
 };
 
+static void show_all_hash_algs(FILE *fp)
+{
+	u32 alg_num = 1;
+	const char *name;
+
+	fprintf(fp, "Available hash algorithms:");
+	while ((name = libfsverity_get_hash_name(alg_num++)) != NULL)
+		fprintf(fp, " %s", name);
+	putc('\n', fp);
+}
+
 static void usage_all(FILE *fp)
 {
 	int i;
@@ -57,10 +65,8 @@ static void usage_all(FILE *fp)
 "  Standard options:\n"
 "    fsverity --help\n"
 "    fsverity --version\n"
-"\n"
-"Available hash algorithms: ", fp);
+"\n", fp);
 	show_all_hash_algs(fp);
-	putc('\n', fp);
 }
 
 static void usage_cmd(const struct fsverity_command *cmd, FILE *fp)
@@ -125,6 +131,31 @@ static const struct fsverity_command *find_command(const char *name)
 	return NULL;
 }
 
+bool parse_hash_alg_option(const char *arg, u32 *alg_ptr)
+{
+	char *end;
+	unsigned long n = strtoul(arg, &end, 10);
+
+	if (*alg_ptr != 0) {
+		error_msg("--hash-alg can only be specified once");
+		return false;
+	}
+
+	/* Specified by number? */
+	if (n > 0 && n < INT32_MAX && *end == '\0') {
+		*alg_ptr = n;
+		return true;
+	}
+
+	/* Specified by name? */
+	*alg_ptr = libfsverity_find_hash_alg_by_name(arg);
+	if (*alg_ptr)
+		return true;
+	error_msg("unknown hash algorithm: '%s'", arg);
+	show_all_hash_algs(stderr);
+	return false;
+}
+
 bool parse_block_size_option(const char *arg, u32 *size_ptr)
 {
 	char *end;
@@ -171,10 +202,17 @@ u32 get_default_block_size(void)
 	return n;
 }
 
+static void print_libfsverity_error(const char *msg)
+{
+	error_msg("%s", msg);
+}
+
 int main(int argc, char *argv[])
 {
 	const struct fsverity_command *cmd;
 
+	libfsverity_set_error_callback(print_libfsverity_error);
+
 	if (argc < 2) {
 		error_msg("no command specified");
 		usage_all(stderr);
diff --git a/programs/fsverity.h b/programs/fsverity.h
new file mode 100644
index 0000000..9f71ea7
--- /dev/null
+++ b/programs/fsverity.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Private header for the 'fsverity' program
+ *
+ * Copyright 2018 Google LLC
+ */
+#ifndef PROGRAMS_FSVERITY_H
+#define PROGRAMS_FSVERITY_H
+
+#include "utils.h"
+#include "../common/fsverity_uapi.h"
+
+/* The hash algorithm that 'fsverity' assumes when none is specified */
+#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
+
+/*
+ * Largest digest size among all hash algorithms supported by fs-verity.
+ * This can be increased if needed.
+ */
+#define FS_VERITY_MAX_DIGEST_SIZE	64
+
+struct fsverity_command;
+
+/* cmd_enable.c */
+int fsverity_cmd_enable(const struct fsverity_command *cmd,
+			int argc, char *argv[]);
+
+/* cmd_measure.c */
+int fsverity_cmd_measure(const struct fsverity_command *cmd,
+			 int argc, char *argv[]);
+
+/* cmd_sign.c */
+int fsverity_cmd_sign(const struct fsverity_command *cmd,
+		      int argc, char *argv[]);
+
+/* fsverity.c */
+void usage(const struct fsverity_command *cmd, FILE *fp);
+bool parse_hash_alg_option(const char *arg, u32 *alg_ptr);
+bool parse_block_size_option(const char *arg, u32 *size_ptr);
+bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
+u32 get_default_block_size(void);
+
+#endif /* PROGRAMS_FSVERITY_H */
diff --git a/util.c b/programs/utils.c
similarity index 96%
rename from util.c
rename to programs/utils.c
index fcab635..02b6dab 100644
--- a/util.c
+++ b/programs/utils.c
@@ -5,15 +5,12 @@
  * Copyright 2018 Google LLC
  */
 
-#include "util.h"
+#include "utils.h"
 
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
 #include <stdarg.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
 #include <sys/stat.h>
 #include <unistd.h>
 
@@ -45,7 +42,7 @@ char *xstrdup(const char *s)
 
 /* ========== Error messages and assertions ========== */
 
-void do_error_msg(const char *format, va_list va, int err)
+static void do_error_msg(const char *format, va_list va, int err)
 {
 	fputs("ERROR: ", stderr);
 	vfprintf(stderr, format, va);
diff --git a/programs/utils.h b/programs/utils.h
new file mode 100644
index 0000000..b7d4188
--- /dev/null
+++ b/programs/utils.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Utility functions for programs
+ *
+ * Copyright 2018 Google LLC
+ */
+#ifndef PROGRAMS_UTILS_H
+#define PROGRAMS_UTILS_H
+
+#include "../common/libfsverity.h"
+#include "../common/common_defs.h"
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+void *xmalloc(size_t size);
+void *xzalloc(size_t size);
+void *xmemdup(const void *mem, size_t size);
+char *xstrdup(const char *s);
+
+__printf(1, 2) __cold void error_msg(const char *format, ...);
+__printf(1, 2) __cold void error_msg_errno(const char *format, ...);
+__printf(1, 2) __cold __noreturn void fatal_error(const char *format, ...);
+__cold __noreturn void assertion_failed(const char *expr,
+					const char *file, int line);
+
+#define ASSERT(e) ({ if (!(e)) assertion_failed(#e, __FILE__, __LINE__); })
+
+struct filedes {
+	int fd;
+	char *name;		/* filename, for logging or error messages */
+};
+
+bool open_file(struct filedes *file, const char *filename, int flags, int mode);
+bool get_file_size(struct filedes *file, u64 *size_ret);
+bool full_read(struct filedes *file, void *buf, size_t count);
+bool full_write(struct filedes *file, const void *buf, size_t count);
+bool filedes_close(struct filedes *file);
+
+bool hex2bin(const char *hex, u8 *bin, size_t bin_len);
+void bin2hex(const u8 *bin, size_t bin_len, char *hex);
+
+#endif /* PROGRAMS_UTILS_H */
diff --git a/sign.h b/sign.h
deleted file mode 100644
index 55c8be8..0000000
--- a/sign.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-#ifndef SIGN_H
-#define SIGN_H
-
-#include "hash_algs.h"
-
-#include <linux/types.h>
-
-/*
- * Format in which verity file measurements are signed.  This is the same as
- * 'struct fsverity_digest', except here some magic bytes are prepended to
- * provide some context about what is being signed in case the same key is used
- * for non-fsverity purposes, and here the fields have fixed endianness.
- */
-struct fsverity_signed_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
-bool compute_file_measurement(const char *filename,
-			      const struct fsverity_hash_alg *hash_alg,
-			      u32 block_size, const u8 *salt,
-			      u32 salt_size, u8 *measurement);
-
-bool sign_data(const void *data_to_sign, size_t data_size,
-	       const char *keyfile, const char *certfile,
-	       const struct fsverity_hash_alg *hash_alg,
-	       u8 **sig_ret, u32 *sig_size_ret);
-
-#endif /* SIGN_H */
-- 
2.26.2

