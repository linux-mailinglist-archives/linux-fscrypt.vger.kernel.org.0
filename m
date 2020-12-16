Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB332DC552
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Dec 2020 18:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgLPR2T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Dec 2020 12:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgLPR2S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Dec 2020 12:28:18 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630B9C06179C
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Dec 2020 09:27:38 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t30so5932499wrb.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 16 Dec 2020 09:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OZDMuPi3CjAaaW3mmIWW8THOyH0mWzzVPFVdtV36tOM=;
        b=D+jQtx0zZClWd1EsnrgntkTkwGY4Omlxiq80kvMpHtX6aGuA+LcD4ULOudiSFExOLz
         22SHlfmsWfetpUAcT4WPKwKAth5dseKpipJGTgiAju12caWt4Kc6BviHgAAjLzk2hBDa
         SmVs6b5B4ld4odiCJoq4FXq2FQekgZJsVJkLqTQerDyBhCdXuK+WG5s5GKJTg91kthc1
         omrixj1BlUjZ4TcBSqQcyKUDCG7AyDTZ+dQpsUGysijaFWF1ZMEjCEqVOgh573ynBn9h
         sfbaPUGHhmw88SkkQXSuoAi2Mzb+PrTODyMxv2npTH97ogBh/ksTncYT6ZxL0TOaT11p
         Ej0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OZDMuPi3CjAaaW3mmIWW8THOyH0mWzzVPFVdtV36tOM=;
        b=Lp04VjcQQ4ugLHlp9+vE117ljf2SqkeqwTafYNzsXS3uOFbMaOztJkmft5on/LryVv
         TYdoE55K8gGDs0osFLTJCPjk+G5AkMGKEuhHFGgJcuWEMv024HkzlQX4NOg4VMJgF7u0
         /U5VOzmMzFxCL06Otyj8tENyA7g7wrAQFMXdS/iAwwqC9d14On3qbuakgfQf6lFVTiB7
         xaih7gdVHgPpN4IrhgdkUs5ufECWs9wiAzwkv4LG+oie7Ges/jmPrKJnmjR7uDlhDK/Q
         4HzUEvlMUugkBDaYr/bPe9isvY2/pp4c7u1EjNMrITVoYRCYBypri8eIzj3r6AL2cwWh
         DbaQ==
X-Gm-Message-State: AOAM531NbX+3/F/Wk0Gj8/WpC/brCuLTfy7AN1nWEVmQ5diAjodqVwcB
        UxRAV6Wq66re7ADbWEbl+hz2L0ZZQiLXSQ==
X-Google-Smtp-Source: ABdhPJzPRs5NB6TnfIjCEmPYbgcJLWybkV6ZZLluaZSBGnbM0xnTRsKNxNcodePDIR3Ydwjwy88b3A==
X-Received: by 2002:adf:f681:: with SMTP id v1mr37231796wrp.133.1608139656647;
        Wed, 16 Dec 2020 09:27:36 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id j9sm4750728wrc.63.2020.12.16.09.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 09:27:35 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [fsverity-utils PATCH 2/2] Allow to build and run sign/digest on Windows
Date:   Wed, 16 Dec 2020 17:27:19 +0000
Message-Id: <20201216172719.540610-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201216172719.540610-1-luca.boccassi@gmail.com>
References: <20201216172719.540610-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Add some minimal compat type defs, and stub out the enable/measure
functions. Also add a way to handle the fact that mingw adds a
.exe extension automatically in the Makefile install rules.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
So this is proably going to look strange, and believe me the feeling is shared.
It's actually the first time _ever_ I had to compile and run something on
Windows, which is ironic in itself - the O_BINARY stuff is probably WIN32-101 and
it took me an hour to find out.
Anyway, I've got some groups building their payloads on Windows, so we need to
provide native tooling. Among these are fsverity tools to get the digest and
sign files.
This patch stubs out and returns EOPNOTSUPP from the measure/enable functions,
since they are linux-host only, and adds some (hopefully) minimal and unintrusive
compat ifdefs for the rest. There's also a change in the makefile, since the
build toolchain (yocto + mingw) for some reason automatically names executables
as .exe. Biggest chunk is the types definitions I guess. The ugliest is the
print stuff.

Note that with this I do not ask you in any way, shape or form to be responsible
for the correct functioning or even compiling on WIN32 of these utilities - if
anything ever breaks, we'll find out and take care of it. I could keep all of this
out of tree, but I figured I'd try to see if you are amenable to merge at least
some part of it.

I've tested that both Linux and WIN32 builds of digest and sign commands return
the exact same output for the same input.

 Makefile               | 13 +++++++------
 common/common_defs.h   | 24 ++++++++++++++++++++++++
 common/fsverity_uapi.h |  4 ++++
 lib/enable.c           | 27 +++++++++++++++++++++------
 lib/utils.c            | 17 ++++++++++++++++-
 programs/cmd_measure.c | 13 +++++++++++++
 programs/utils.c       |  7 ++++++-
 7 files changed, 91 insertions(+), 14 deletions(-)

diff --git a/Makefile b/Makefile
index bfe83c4..fe89e18 100644
--- a/Makefile
+++ b/Makefile
@@ -63,6 +63,7 @@ INCDIR          ?= $(PREFIX)/include
 LIBDIR          ?= $(PREFIX)/lib
 DESTDIR         ?=
 PKGCONF         ?= pkg-config
+EXEEXT          ?=
 
 # Rebuild if a user-specified setting that affects the build changed.
 .build-config: FORCE
@@ -87,9 +88,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
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
@@ -186,7 +187,7 @@ test_programs:$(TEST_PROGRAMS)
 # want to run the full tests.
 check:fsverity test_programs
 	for prog in $(TEST_PROGRAMS); do \
-		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
+		$(TEST_WRAPPER_PROG) ./$$prog$(EXEEXT) || exit 1; \
 	done
 	$(RUN_FSVERITY) --help > /dev/null
 	$(RUN_FSVERITY) --version > /dev/null
@@ -202,7 +203,7 @@ check:fsverity test_programs
 
 install:all
 	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
-	install -m755 fsverity $(DESTDIR)$(BINDIR)
+	install -m755 fsverity$(EXEEXT) $(DESTDIR)$(BINDIR)
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
@@ -215,7 +216,7 @@ install:all
 	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 
 uninstall:
-	rm -f $(DESTDIR)$(BINDIR)/fsverity
+	rm -f $(DESTDIR)$(BINDIR)/fsverity$(EXEEXT)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
@@ -232,4 +233,4 @@ help:
 
 clean:
 	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
-		lib/*.o programs/*.o .build-config fsverity.sig
+		fsverity$(EXEEXT) lib/*.o programs/*.o .build-config fsverity.sig
diff --git a/common/common_defs.h b/common/common_defs.h
index 279385a..a869532 100644
--- a/common/common_defs.h
+++ b/common/common_defs.h
@@ -15,6 +15,30 @@
 #include <stddef.h>
 #include <stdint.h>
 
+#ifdef _WIN32
+/* Some minimal definitions to allow the digest/sign commands to run under Windows */
+#  ifndef ENOPKG
+#    define ENOPKG 65
+#  endif
+#  ifndef __cold
+#    define __cold
+#  endif
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
+#endif /* _WIN32 */
+
 typedef uint8_t u8;
 typedef uint16_t u16;
 typedef uint32_t u32;
diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
index 0006c35..ec8294a 100644
--- a/common/fsverity_uapi.h
+++ b/common/fsverity_uapi.h
@@ -10,7 +10,11 @@
 #ifndef _UAPI_LINUX_FSVERITY_H
 #define _UAPI_LINUX_FSVERITY_H
 
+#ifndef _WIN32
 #include <linux/types.h>
+#else
+#include "common_defs.h"
+#endif /* _WIN32 */
 
 #define FS_VERITY_HASH_ALG_SHA256	1
 #define FS_VERITY_HASH_ALG_SHA512	2
diff --git a/lib/enable.c b/lib/enable.c
index 2478077..b49ba26 100644
--- a/lib/enable.c
+++ b/lib/enable.c
@@ -11,14 +11,10 @@
 
 #include "lib_private.h"
 
+#ifndef _WIN32
+
 #include <sys/ioctl.h>
 
-LIBEXPORT int
-libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params)
-{
-	return libfsverity_enable_with_sig(fd, params, NULL, 0);
-}
-
 LIBEXPORT int
 libfsverity_enable_with_sig(int fd,
 			    const struct libfsverity_merkle_tree_params *params,
@@ -51,3 +47,22 @@ libfsverity_enable_with_sig(int fd,
 		return -errno;
 	return 0;
 }
+
+#else /* _WIN32 */
+
+LIBEXPORT int
+libfsverity_enable_with_sig(__attribute__ ((unused)) int fd,
+			    __attribute__ ((unused)) const struct libfsverity_merkle_tree_params *params,
+			    __attribute__ ((unused)) const uint8_t *sig,
+			    __attribute__ ((unused)) size_t sig_size)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* _WIN32 */
+
+LIBEXPORT int
+libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *params)
+{
+	return libfsverity_enable_with_sig(fd, params, NULL, 0);
+}
diff --git a/lib/utils.c b/lib/utils.c
index 8b5d6cb..2ff8fd2 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -10,6 +10,16 @@
  */
 
 #define _GNU_SOURCE /* for asprintf() and strerror_r() */
+#ifndef _WIN32
+#  define SIZET_PF "zu"
+#else
+#  include <inttypes.h>
+#  ifdef _WIN64
+#    define SIZET_PF PRIu64
+#  else
+#    define SIZET_PF PRIu32
+#  endif
+#endif
 
 #include "lib_private.h"
 
@@ -22,7 +32,7 @@ static void *xmalloc(size_t size)
 	void *p = malloc(size);
 
 	if (!p)
-		libfsverity_error_msg("out of memory (tried to allocate %zu bytes)",
+		libfsverity_error_msg("out of memory (tried to allocate %" SIZET_PF " bytes)",
 				      size);
 	return p;
 }
@@ -68,8 +78,13 @@ void libfsverity_do_error_msg(const char *format, va_list va, int err)
 		char *msg2 = NULL;
 		char errbuf[64];
 
+#ifndef _WIN32
 		if (asprintf(&msg2, "%s: %s", msg,
 			     strerror_r(err, errbuf, sizeof(errbuf))) < 0)
+#else
+		strerror_s(errbuf, sizeof(errbuf), err);
+		if (asprintf(&msg2, "%s: %s", msg, errbuf) < 0)
+#endif
 			goto out2;
 		free(msg);
 		msg = msg2;
diff --git a/programs/cmd_measure.c b/programs/cmd_measure.c
index d78969c..48161d5 100644
--- a/programs/cmd_measure.c
+++ b/programs/cmd_measure.c
@@ -11,6 +11,8 @@
 
 #include "fsverity.h"
 
+#ifndef _WIN32
+
 #include <fcntl.h>
 #include <sys/ioctl.h>
 
@@ -67,3 +69,14 @@ out_usage:
 	status = 2;
 	goto out;
 }
+
+#else /* _WIN32 */
+
+int fsverity_cmd_measure(__attribute__ ((unused)) const struct fsverity_command *cmd,
+			 __attribute__ ((unused)) int argc,
+			 __attribute__ ((unused)) char *argv[])
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* _WIN32 */
diff --git a/programs/utils.c b/programs/utils.c
index facccda..fbcf248 100644
--- a/programs/utils.c
+++ b/programs/utils.c
@@ -18,6 +18,11 @@
 #include <sys/stat.h>
 #include <unistd.h>
 
+/* All file reads we do need this flag on _WIN32 */
+#ifndef O_BINARY
+#define O_BINARY 0
+#endif
+
 /* ========== Memory allocation ========== */
 
 void *xmalloc(size_t size)
@@ -102,7 +107,7 @@ void install_libfsverity_error_handler(void)
 
 bool open_file(struct filedes *file, const char *filename, int flags, int mode)
 {
-	file->fd = open(filename, flags, mode);
+	file->fd = open(filename, flags | O_BINARY, mode);
 	if (file->fd < 0) {
 		error_msg_errno("can't open '%s' for %s", filename,
 				(flags & O_ACCMODE) == O_RDONLY ? "reading" :
-- 
2.29.2

