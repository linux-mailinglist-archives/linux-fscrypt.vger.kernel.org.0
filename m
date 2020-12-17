Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFD52DD93A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQTRJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQTRI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:17:08 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9450C0617A7
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:16:27 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id t30so9667304wrb.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaXE7ZnnU8bZdaumfXx0R+NJQg024COm7U0+pMuPdyI=;
        b=JMFSWROqjwIpFm67/d8OXXmAjpY2c+ZKl3bubPcRUjVgYlp6JupfWhfJA3TLoDX58D
         GQe+hyvuIbQ/gzsV9asrek5R4y0V23i3ZkTFvHwmIiQtyYXCLHB++45aheQ0cnwBF6gM
         vmnzCni8fDd3kxa0s36Iak6TjsidGvJIuQ6R69+XW12zTj6pX89/ZutGO7d410qWFsKn
         lFjJZomkU6RWIoaecBQCSedEavTwN7x0BLiCKrCw6FtkN91xsq0LElpqWVczebACofSt
         b3pFsBqWRlZ6sTJbki1RSHSZ8Y6LbYm5Kr67KKqrNR+0aS1qTKtoxiZE/13ObxxQlbIq
         ZgKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaXE7ZnnU8bZdaumfXx0R+NJQg024COm7U0+pMuPdyI=;
        b=HMNhLAeP/xO3P9xwYmBJyOjvRyfOLod1a9llwQ9/6/dOnJ1yQfkIFCWsDEMFqXfaVF
         zZ0HnelQ9XWWxDYjA9J/iH2m24h1ibu8GrbSAP4H2VWB37dO8kqhCBR23Qh+9uZrmENx
         T2nICaxcB3lwFi6mwos5UEvkuYCaIYyvCx1y7WDNkCHPZ9mfTOhI2CgjL5CHpJxEGwNn
         K3LnSGHQzfirDxbhkHlLbZWReVSnFBTlgDqgYB2XzjaJlRbo/k8N/paZ060HeVu5yvhe
         aK13MhDfpBdmd0/WAyaWSo7nZ5OXBfB9/e4BLsCp87w3zJWoBueXL9DqZCTwEegMK0VR
         Hm0w==
X-Gm-Message-State: AOAM532nUjKb51bl29jRDdC+9EQ6YfDX8i5DnWCy/cKVV5xCx+E/vyg4
        BbOjb/WblTHltMftJpuvL16Ub7368+eD6g==
X-Google-Smtp-Source: ABdhPJwabw5VGE2HsB/n+8gndOOq+HDw2e5J44XtUur4kxFvvUUa1aSBnzurqRGEkrzp7q/nKaL0Og==
X-Received: by 2002:a5d:558a:: with SMTP id i10mr270374wrv.363.1608232586123;
        Thu, 17 Dec 2020 11:16:26 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id l5sm10549312wrv.44.2020.12.17.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:16:25 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [fsverity-utils PATCH v3 2/2] Allow to build and run sign/digest on Windows
Date:   Thu, 17 Dec 2020 19:16:18 +0000
Message-Id: <20201217191618.3681450-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217191618.3681450-1-luca.boccassi@gmail.com>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
 <20201217191618.3681450-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Add some minimal compat type defs, and stub out the enable/measure
sources. Also add a way to handle the fact that mingw adds a
.exe extension automatically in the Makefile install rules, and
that there is not pkg-config and the libcrypto linker flag is
different.

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

 Makefile               | 34 ++++++++++++++++------
 common/common_defs.h   |  2 ++
 common/fsverity_uapi.h |  2 ++
 common/win32_defs.h    | 66 ++++++++++++++++++++++++++++++++++++++++++
 lib/utils.c            | 13 +++++++--
 programs/fsverity.c    |  2 ++
 programs/utils.c       |  2 +-
 7 files changed, 108 insertions(+), 13 deletions(-)
 create mode 100644 common/win32_defs.h

diff --git a/Makefile b/Makefile
index bfe83c4..a5aa900 100644
--- a/Makefile
+++ b/Makefile
@@ -35,6 +35,11 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
+# Support building with MinGW for minimal Windows fsverity.exe
+ifneq ($(findstring -mingw,$(shell $(CC) -dumpmachine 2>/dev/null)),)
+MINGW = 1
+endif
+
 CFLAGS ?= -O2
 
 override CFLAGS := -Wall -Wundef				\
@@ -47,7 +52,7 @@ override CFLAGS := -Wall -Wundef				\
 	$(call cc-option,-Wvla)					\
 	$(CFLAGS)
 
-override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
 
 ifneq ($(V),1)
 QUIET_CC        = @echo '  CC      ' $@;
@@ -62,7 +67,12 @@ BINDIR          ?= $(PREFIX)/bin
 INCDIR          ?= $(PREFIX)/include
 LIBDIR          ?= $(PREFIX)/lib
 DESTDIR         ?=
+ifneq ($(MINGW),1)
 PKGCONF         ?= pkg-config
+else
+PKGCONF         := false
+EXEEXT          := .exe
+endif
 
 # Rebuild if a user-specified setting that affects the build changed.
 .build-config: FORCE
@@ -87,9 +97,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
 # If we are dynamically linking, when running tests we need to override
 # LD_LIBRARY_PATH as no RPATH is set
 ifdef USE_SHARED_LIB
-RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
+RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity$(EXEEXT)
 else
-RUN_FSVERITY    = ./fsverity
+RUN_FSVERITY    = ./fsverity$(EXEEXT)
 endif
 
 ##############################################################################
@@ -99,6 +109,9 @@ endif
 SOVERSION       := 0
 LIB_CFLAGS      := $(CFLAGS) -fvisibility=hidden
 LIB_SRC         := $(wildcard lib/*.c)
+ifeq ($(MINGW),1)
+LIB_SRC         := $(filter-out lib/enable.c,${LIB_SRC})
+endif
 LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
 STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
 SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
@@ -141,10 +154,13 @@ PROG_COMMON_SRC   := programs/utils.c
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
 TEST_PROGRAMS     := $(TEST_PROG_SRC:programs/%.c=%)
 
@@ -186,7 +202,7 @@ test_programs:$(TEST_PROGRAMS)
 # want to run the full tests.
 check:fsverity test_programs
 	for prog in $(TEST_PROGRAMS); do \
-		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
+		$(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
 	done
 	$(RUN_FSVERITY) --help > /dev/null
 	$(RUN_FSVERITY) --version > /dev/null
@@ -202,7 +218,7 @@ check:fsverity test_programs
 
 install:all
 	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
-	install -m755 fsverity $(DESTDIR)$(BINDIR)
+	install -m755 fsverity$(EXEEXT) $(DESTDIR)$(BINDIR)
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
@@ -215,7 +231,7 @@ install:all
 	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 
 uninstall:
-	rm -f $(DESTDIR)$(BINDIR)/fsverity
+	rm -f $(DESTDIR)$(BINDIR)/fsverity$(EXEEXT)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
@@ -232,4 +248,4 @@ help:
 
 clean:
 	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
-		lib/*.o programs/*.o .build-config fsverity.sig
+		fsverity$(EXEEXT) lib/*.o programs/*.o .build-config fsverity.sig
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
index 0000000..2fd4887
--- /dev/null
+++ b/common/win32_defs.h
@@ -0,0 +1,66 @@
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
+#ifdef _WIN64
+#  define SIZET_PF PRIu64
+#else
+#  define SIZET_PF PRIu32
+#endif
+
+#ifndef ENOPKG
+#   define ENOPKG 65
+#endif
+
+#ifndef __cold
+#  define __cold
+#endif
+
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
+#else
+
+#define SIZET_PF "zu"
+
+#endif /* _WIN32 */
+
+#endif /* COMMON_WIN32_DEFS_H */
diff --git a/lib/utils.c b/lib/utils.c
index 8b5d6cb..55a4045 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -9,8 +9,6 @@
  * https://opensource.org/licenses/MIT.
  */
 
-#define _GNU_SOURCE /* for asprintf() and strerror_r() */
-
 #include "lib_private.h"
 
 #include <stdio.h>
@@ -22,7 +20,7 @@ static void *xmalloc(size_t size)
 	void *p = malloc(size);
 
 	if (!p)
-		libfsverity_error_msg("out of memory (tried to allocate %zu bytes)",
+		libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
 				      size);
 	return p;
 }
@@ -53,6 +51,15 @@ libfsverity_set_error_callback(void (*cb)(const char *msg))
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

