Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A0E2E02E7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLUXZZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:25:25 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45102 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLUXZZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:25:25 -0500
Received: by mail-wr1-f44.google.com with SMTP id d26so12735661wrb.12
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:25:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZciNSPCbQGtA2NU/8WEnJVBnvSm0o9mAFuYIg9uMDJg=;
        b=ikSB+X4Tf5r7d3a0xDplWEyuAd2KkdE2rERTKgIToGeTs0xmnvDlXvnsurbHaz9afO
         I+7exmJ6HjlHck8XiX6wZwJ0WbsbA1deFTuJFsaGY329KHhvUpENufMaZ5sDB9Ba4FXD
         3wGuuvLKLKPhvTRKHint22aoFSrReXaNCN2RjdLF0bsQrOaRpt81VpS4ql/zGFSvOy2B
         z/nEJYrCd7eNR+zxPVNV1XZQ8SgxdvTBMVc5zuLXg2oh8IKgI+PQxfDhKN0ePdwEde8T
         i7iIQEm2nNhYn1O5v3Qitk5yfgUhZPQ4Cy0llaqWsJQ355GnwMzOXYhhxvYW/08wp45l
         oBDg==
X-Gm-Message-State: AOAM533yqAPHQxc6hh9r9w734UrSKOAG5GjKStqE8OlNLRR6fSjnQR35
        3UU2Wg8zu48nKJR0yDXTq04BxJz7Snnd/Cqg
X-Google-Smtp-Source: ABdhPJwGLrKfBivz/5V9Rbj4bsT8IGVHHjFpMvVBlF5c9+hFuQXyvD7H55Ci7xlIdcMS0rtIeid08Q==
X-Received: by 2002:a5d:6209:: with SMTP id y9mr20837710wru.197.1608593082019;
        Mon, 21 Dec 2020 15:24:42 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id u9sm20224457wmb.32.2020.12.21.15.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 15:24:41 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, Luca Boccassi <bluca@debian.org>,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: [PATCH v6 3/3] Allow to build and run sign/digest on Windows
Date:   Mon, 21 Dec 2020 23:24:28 +0000
Message-Id: <20201221232428.298710-3-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221232428.298710-1-bluca@debian.org>
References: <20201221221953.256059-1-bluca@debian.org>
 <20201221232428.298710-1-bluca@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add some minimal compat type defs, and omit the enable/measure
sources. Also add a way to handle the fact that mingw adds a
.exe extension automatically in the Makefile install rules.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
v2: rework the stubbing out to detect mingw in the Makefile and remove
    sources from compilation, instead of ifdefs.
    add a new common/win32_defs.h for the compat definitions.
    define strerror_r using strerror_s.

    To compile with mingw:
      make CC=x86_64-w64-mingw32-gcc-8.3-win32
    note that the openssl headers and a win32 libcrypto.dll need
    to be available in the default search paths, and otherwise have
    to be specified as expected via CPPFLAGS/LDFLAGS
v3: apply suggestion to remove -D_GNU_SOURCE from the header and define
    it as a CPPFLAGS, and to add  a definition of __printf for _WIN32
    to fix compiler warnings
    removed override of -lcrypto, not needed
v4: apply suggestion to remove overrides of %zu, as it now "just works".
    no more compilation warnings.
v5: change makefile fsverity target to use $(EXEEXT), and ensure make check
    can run under Windows (tested with wine, using TEST_WRAPPER_PROG=wine)
v6: split GNU_SOURCES and TEST_WRAPPER_PROG out in separate patches.
    add note about mingw to README.md.
    note in Makefile that we don't build libfsverity.dll yet.
    ensure the TEST_PROGS targets get the .exe suffix if needed.

 Makefile               | 48 ++++++++++++++++++++++++-----------
 README.md              | 11 ++++++++
 common/common_defs.h   |  2 ++
 common/fsverity_uapi.h |  2 ++
 common/win32_defs.h    | 57 ++++++++++++++++++++++++++++++++++++++++++
 lib/utils.c            |  9 +++++++
 programs/fsverity.c    |  2 ++
 programs/utils.c       |  2 +-
 8 files changed, 117 insertions(+), 16 deletions(-)
 create mode 100644 common/win32_defs.h

diff --git a/Makefile b/Makefile
index 583db8e..0354f62 100644
--- a/Makefile
+++ b/Makefile
@@ -35,6 +35,12 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
+# Support building with MinGW for minimal Windows fsverity.exe, but not for
+# libfsverity. fsverity.exe will be statically linked.
+ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
+MINGW = 1
+endif
+
 CFLAGS ?= -O2
 
 override CFLAGS := -Wall -Wundef				\
@@ -62,7 +68,13 @@ BINDIR          ?= $(PREFIX)/bin
 INCDIR          ?= $(PREFIX)/include
 LIBDIR          ?= $(PREFIX)/lib
 DESTDIR         ?=
+ifneq ($(MINGW),1)
 PKGCONF         ?= pkg-config
+else
+PKGCONF         := false
+EXEEXT          := .exe
+endif
+FSVERITY        := fsverity$(EXEEXT)
 
 # Rebuild if a user-specified setting that affects the build changed.
 .build-config: FORCE
@@ -87,9 +99,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
 # If we are dynamically linking, when running tests we need to override
 # LD_LIBRARY_PATH as no RPATH is set
 ifdef USE_SHARED_LIB
-RUN_FSVERITY    = LD_LIBRARY_PATH=./ $(TEST_WRAPPER_PROG) ./fsverity
+RUN_FSVERITY    = LD_LIBRARY_PATH=./ $(TEST_WRAPPER_PROG) ./$(FSVERITY)
 else
-RUN_FSVERITY    = $(TEST_WRAPPER_PROG) ./fsverity
+RUN_FSVERITY    = $(TEST_WRAPPER_PROG) ./$(FSVERITY)
 endif
 
 ##############################################################################
@@ -99,6 +111,9 @@ endif
 SOVERSION       := 0
 LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
 LIB_SRC         := $(wildcard lib/*.c)
+ifeq ($(MINGW),1)
+LIB_SRC         := $(filter-out lib/enable.c,${LIB_SRC})
+endif
 LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
 STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
 SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
@@ -141,12 +156,15 @@ PROG_COMMON_SRC   := programs/utils.c
 PROG_COMMON_OBJ   := $(PROG_COMMON_SRC:.c=.o)
 FSVERITY_PROG_OBJ := $(PROG_COMMON_OBJ)		\
 		     programs/cmd_digest.o	\
-		     programs/cmd_enable.o	\
-		     programs/cmd_measure.o	\
 		     programs/cmd_sign.o	\
 		     programs/fsverity.o
+ifneq ($(MINGW),1)
+FSVERITY_PROG_OBJ += \
+		     programs/cmd_enable.o	\
+		     programs/cmd_measure.o
+endif
 TEST_PROG_SRC     := $(wildcard programs/test_*.c)
-TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
+TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%$(EXEEXT))
 
 # Compile program object files
 $(ALL_PROG_OBJ): %.o: %.c $(ALL_PROG_HEADERS) .build-config
@@ -154,18 +172,18 @@ $(ALL_PROG_OBJ): %.o: %.c $(ALL_PROG_HEADERS) .build-config
 
 # Link the fsverity program
 ifdef USE_SHARED_LIB
-fsverity: $(FSVERITY_PROG_OBJ) libfsverity.so
+$(FSVERITY): $(FSVERITY_PROG_OBJ) libfsverity.so
 	$(QUIET_CCLD) $(CC) -o $@ $(FSVERITY_PROG_OBJ) \
 		$(CFLAGS) $(LDFLAGS) -L. -lfsverity
 else
-fsverity: $(FSVERITY_PROG_OBJ) libfsverity.a
+$(FSVERITY): $(FSVERITY_PROG_OBJ) libfsverity.a
 	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 endif
 
-DEFAULT_TARGETS += fsverity
+DEFAULT_TARGETS += $(FSVERITY)
 
 # Link the test programs
-$(TEST_PROGRAMS): %: programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
+$(TEST_PROGRAMS): %$(EXEEXT): programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
 	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
 ##############################################################################
@@ -184,25 +202,25 @@ test_programs:$(TEST_PROGRAMS)
 
 # This just runs some quick, portable tests.  Use scripts/run-tests.sh if you
 # want to run the full tests.
-check:fsverity test_programs
+check:$(FSVERITY) test_programs
 	for prog in $(TEST_PROGRAMS); do \
 		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
 	done
 	$(RUN_FSVERITY) --help > /dev/null
 	$(RUN_FSVERITY) --version > /dev/null
-	$(RUN_FSVERITY) sign fsverity fsverity.sig \
+	$(RUN_FSVERITY) sign $(FSVERITY) fsverity.sig \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
-	$(RUN_FSVERITY) sign fsverity fsverity.sig --hash=sha512 \
+	$(RUN_FSVERITY) sign $(FSVERITY) fsverity.sig --hash=sha512 \
 		--block-size=512 --salt=12345678 \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
-	$(RUN_FSVERITY) digest fsverity --hash=sha512 \
+	$(RUN_FSVERITY) digest $(FSVERITY) --hash=sha512 \
 		--block-size=512 --salt=12345678 > /dev/null
 	rm -f fsverity.sig
 	@echo "All tests passed!"
 
 install:all
 	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
-	install -m755 fsverity $(DESTDIR)$(BINDIR)
+	install -m755 $(FSVERITY) $(DESTDIR)$(BINDIR)
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
@@ -215,7 +233,7 @@ install:all
 	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 
 uninstall:
-	rm -f $(DESTDIR)$(BINDIR)/fsverity
+	rm -f $(DESTDIR)$(BINDIR)/$(FSVERITY)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
diff --git a/README.md b/README.md
index 6045c75..c630f7d 100644
--- a/README.md
+++ b/README.md
@@ -50,6 +50,17 @@ use `make USE_SHARED_LIB=1` to use dynamic linking instead.
 
 See the `Makefile` for other supported build and installation options.
 
+### Building on Windows
+
+There is minimal support for building Windows executables using MinGW.
+```bash
+    make CC=x86_64-w64-mingw32-gcc-win32
+```
+
+`fsverity.exe` will be built, and it supports the `digest` and `sign` commands.
+
+A Windows build of OpenSSL/libcrypto needs to be available.
+
 ## Examples
 
 ### Basic use
diff --git a/common/common_defs.h b/common/common_defs.h
index 279385a..3ae5561 100644
--- a/common/common_defs.h
+++ b/common/common_defs.h
@@ -15,6 +15,8 @@
 #include <stddef.h>
 #include <stdint.h>
 
+#include "win32_defs.h"
+
 typedef uint8_t u8;
 typedef uint16_t u16;
 typedef uint32_t u32;
diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
index 33f4415..be1d3f6 100644
--- a/common/fsverity_uapi.h
+++ b/common/fsverity_uapi.h
@@ -10,8 +10,10 @@
 #ifndef _UAPI_LINUX_FSVERITY_H
 #define _UAPI_LINUX_FSVERITY_H
 
+#ifndef _WIN32
 #include <linux/ioctl.h>
 #include <linux/types.h>
+#endif /* _WIN32 */
 
 #define FS_VERITY_HASH_ALG_SHA256	1
 #define FS_VERITY_HASH_ALG_SHA512	2
diff --git a/common/win32_defs.h b/common/win32_defs.h
new file mode 100644
index 0000000..29ef9b2
--- /dev/null
+++ b/common/win32_defs.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * WIN32 compat definitions for libfsverity and the 'fsverity' program
+ *
+ * Copyright 2020 Microsoft
+ *
+ * Use of this source code is governed by an MIT-style
+ * license that can be found in the LICENSE file or at
+ * https://opensource.org/licenses/MIT.
+ */
+#ifndef COMMON_WIN32_DEFS_H
+#define COMMON_WIN32_DEFS_H
+
+/* Some minimal definitions to allow the digest/sign commands to run under Windows */
+
+/* All file reads we do need this flag on _WIN32 */
+#ifndef O_BINARY
+#  define O_BINARY 0
+#endif
+
+#ifdef _WIN32
+
+#include <stdint.h>
+#include <inttypes.h>
+
+#ifndef ENOPKG
+#   define ENOPKG 65
+#endif
+
+#ifndef __cold
+#  define __cold
+#endif
+
+/* For %zu in printf() */
+#ifndef __printf
+#  define __printf(fmt_idx, vargs_idx) \
+       __attribute__((format(gnu_printf, fmt_idx, vargs_idx)))
+#endif
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+typedef __signed__ long long  __s64;
+typedef unsigned long long  __u64;
+typedef __u16 __le16;
+typedef __u16 __be16;
+typedef __u32 __le32;
+typedef __u32 __be32;
+typedef __u64 __le64;
+typedef __u64 __be64;
+
+#endif /* _WIN32 */
+
+#endif /* COMMON_WIN32_DEFS_H */
diff --git a/lib/utils.c b/lib/utils.c
index 13e3b35..036dd60 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -51,6 +51,15 @@ libfsverity_set_error_callback(void (*cb)(const char *msg))
 	libfsverity_error_cb = cb;
 }
 
+#ifdef _WIN32
+static char *strerror_r(int errnum, char *buf, size_t buflen)
+{
+	strerror_s(buf, buflen, errnum);
+
+	return buf;
+}
+#endif
+
 void libfsverity_do_error_msg(const char *format, va_list va, int err)
 {
 	int saved_errno = errno;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index 5d5fbe2..f68e034 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -28,6 +28,7 @@ static const struct fsverity_command {
 "    fsverity digest FILE...\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
 "               [--compact] [--for-builtin-sig]\n"
+#ifndef _WIN32
 	}, {
 		.name = "enable",
 		.func = fsverity_cmd_enable,
@@ -43,6 +44,7 @@ static const struct fsverity_command {
 "Display the fs-verity digest of the given verity file(s)",
 		.usage_str =
 "    fsverity measure FILE...\n"
+#endif /* _WIN32 */
 	}, {
 		.name = "sign",
 		.func = fsverity_cmd_sign,
diff --git a/programs/utils.c b/programs/utils.c
index facccda..ce19b57 100644
--- a/programs/utils.c
+++ b/programs/utils.c
@@ -102,7 +102,7 @@ void install_libfsverity_error_handler(void)
 
 bool open_file(struct filedes *file, const char *filename, int flags, int mode)
 {
-	file->fd = open(filename, flags, mode);
+	file->fd = open(filename, flags | O_BINARY, mode);
 	if (file->fd < 0) {
 		error_msg_errno("can't open '%s' for %s", filename,
 				(flags & O_ACCMODE) == O_RDONLY ? "reading" :
-- 
2.29.2

