Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB12298B91
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772066AbgJZLPQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:15:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38290 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1771572AbgJZLPO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:15:14 -0400
Received: by mail-wr1-f66.google.com with SMTP id n18so11942648wrs.5
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ubkBDmZ36moemRY857V7V27532caUr8KTSFMalKzQFY=;
        b=fS78408vFcxvfj42zB66CZWGC7MTCuOor4+ku6gLR25PQsAXTFvupPugKxTJzLH1UY
         T7ldr8y6hzTgwXuRpQu8Zr++dSk60hXdRfo0HavfFfym5rezN01BGHW6OSWE3uN8vnFs
         rsuEP/7UBfPODTNMz+i1PxhRbJPF+yKpFQGjmXOoV0u98Jx/X72MHxPqWRHjorpod9y2
         01ZG7hZ7sS+mN1/X/hDYvAkEwfMWwdt5mGaqIDb5pbRCXVhfuVumhgLysy8JCsN2tDLW
         94BreWTw6tOWWx2M4lnepHvk+Ze521vkGlMa6kXSCGEqm6b0TjmtBD7018mga9PF9A41
         mh5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ubkBDmZ36moemRY857V7V27532caUr8KTSFMalKzQFY=;
        b=tBLftVuA2Alwvkx51OS/pumo6gFXiT8SggOEe+No0jQrrom3lb0SktgGdnNaw+MaI4
         1X8t2ettHk8BQaNSEIqzC3Fi96YzcSrSRGc9nRtLin/x6IeglobtRsHOacHqxudpnG2k
         FdM3vPrWebHh07bb0axOJRA/fxEPrcURBzmda4qTP6lH7w/bvhOohqsMPa5LGijy4eEW
         qqOy1zzVfZ0kbuGbaigp3+F772GIpxd1V3IHMaxKTHrA3YCGJkCDB9AgfgOYpO6bH5QM
         AY30kSZeiGrM8vHrkQZazL8OJnMFeV8IlgGeRSDvQQJWD3h0YOKQxowwX6Pj40I3O4l3
         hJsQ==
X-Gm-Message-State: AOAM530pdlL9fOo/0uoaWAjy3U/C4GycIysjlnfvpw/5KGHcHjC91TbR
        7rlUxsXFYEWVUV0JJ/6NI75klIc7j4FGRuyr
X-Google-Smtp-Source: ABdhPJzHXJXukgdKXAmJyAeNZIjYcB2giT5EYwmRiv9wkosAu5A4xD4S22+QHSKn7WLhV3T/DhGQKg==
X-Received: by 2002:adf:f4ca:: with SMTP id h10mr16827455wrp.89.1603710912212;
        Mon, 26 Oct 2020 04:15:12 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id d142sm3519437wmd.11.2020.10.26.04.15.11
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:15:11 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH v2 2/2] Generate and install libfsverity.pc
Date:   Mon, 26 Oct 2020 11:15:06 +0000
Message-Id: <20201026111506.3215328-2-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201026111506.3215328-1-luca.boccassi@gmail.com>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
 <20201026111506.3215328-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

pkg-config is commonly used by libraries to convey information about
compiler flags and dependencies.
As packagers, we heavily rely on it so that all our tools do the right
thing by default regardless of the environment.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
v2: add pc file to .gitignore
    add and use QUIET_GEN prefix
    add install variables to .build-config
    have libfsverity.pc depend on lib/libfsverity.pc.in

 .gitignore            |  1 +
 Makefile              | 16 ++++++++++++++--
 lib/libfsverity.pc.in | 10 ++++++++++
 scripts/do-release.sh |  2 ++
 4 files changed, 27 insertions(+), 2 deletions(-)
 create mode 100644 lib/libfsverity.pc.in

diff --git a/.gitignore b/.gitignore
index 04f9a6f..572da31 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,5 +9,6 @@
 /run-tests.log
 /test_*
 cscope.*
+libfsverity.pc
 ncscope.*
 tags
diff --git a/Makefile b/Makefile
index d7e6eb2..6fdf91a 100644
--- a/Makefile
+++ b/Makefile
@@ -51,6 +51,7 @@ QUIET_CC        = @echo '  CC      ' $@;
 QUIET_CCLD      = @echo '  CCLD    ' $@;
 QUIET_AR        = @echo '  AR      ' $@;
 QUIET_LN        = @echo '  LN      ' $@;
+QUIET_GEN       = @echo '  GEN     ' $@;
 endif
 USE_SHARED_LIB  ?=
 PREFIX          ?= /usr/local
@@ -62,7 +63,7 @@ PKGCONF         ?= pkg-config
 
 # Rebuild if a user-specified setting that affects the build changed.
 .build-config: FORCE
-	@flags='$(CC):$(CFLAGS):$(CPPFLAGS):$(LDFLAGS):$(USE_SHARED_LIB)'; \
+	@flags='$(CC):$(CFLAGS):$(CPPFLAGS):$(LDFLAGS):$(USE_SHARED_LIB):$(PREFIX):$(LIBDIR):$(INCDIR):$(BINDIR)'; \
 	if [ "$$flags" != "`cat $@ 2>/dev/null`" ]; then		\
 		[ -e $@ ] && echo "Rebuilding due to new settings";	\
 		echo "$$flags" > $@;					\
@@ -119,6 +120,15 @@ libfsverity.so:libfsverity.so.$(SOVERSION)
 
 DEFAULT_TARGETS += libfsverity.so
 
+# Create the pkg-config file
+libfsverity.pc: lib/libfsverity.pc.in
+	$(QUIET_GEN) sed -e "s|@PREFIX@|$(PREFIX)|" \
+		-e "s|@LIBDIR@|$(LIBDIR)|" \
+		-e "s|@INCDIR@|$(INCDIR)|" \
+		$< > $@
+
+DEFAULT_TARGETS += libfsverity.pc
+
 ##############################################################################
 
 #### Programs
@@ -190,11 +200,12 @@ check:fsverity test_programs
 	@echo "All tests passed!"
 
 install:all
-	install -d $(DESTDIR)$(LIBDIR) $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
+	install -d $(DESTDIR)$(LIBDIR)/pkgconfig $(DESTDIR)$(INCDIR) $(DESTDIR)$(BINDIR)
 	install -m755 fsverity $(DESTDIR)$(BINDIR)
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
+	install -m644 libfsverity.pc $(DESTDIR)$(LIBDIR)/pkgconfig
 	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
 
 uninstall:
@@ -202,6 +213,7 @@ uninstall:
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so.$(SOVERSION)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
+	rm -f $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h
 
 help:
diff --git a/lib/libfsverity.pc.in b/lib/libfsverity.pc.in
new file mode 100644
index 0000000..613e9bc
--- /dev/null
+++ b/lib/libfsverity.pc.in
@@ -0,0 +1,10 @@
+prefix=@PREFIX@
+libdir=@LIBDIR@
+includedir=@INCDIR@
+
+Name: libfsverity
+Description: fs-verity library
+Version: 1.2
+Libs: -L${libdir} -lfsverity
+Requires.private: libcrypto
+Cflags: -I${includedir}
diff --git a/scripts/do-release.sh b/scripts/do-release.sh
index 255fc53..352fcf1 100755
--- a/scripts/do-release.sh
+++ b/scripts/do-release.sh
@@ -28,6 +28,8 @@ minor=$(echo "$VERS" | cut -d. -f2)
 sed -E -i -e "/FSVERITY_UTILS_MAJOR_VERSION/s/[0-9]+/$major/" \
 	  -e "/FSVERITY_UTILS_MINOR_VERSION/s/[0-9]+/$minor/" \
 	  include/libfsverity.h
+sed -E -i "/Version:/s/[0-9]+\.[0-9]+/$VERS/" \
+	  lib/libfsverity.pc.in
 git commit -a --signoff --message="v$VERS"
 git tag --sign "v$VERS" --message="$PKG"
 
-- 
2.20.1

