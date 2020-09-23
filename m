Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600322761F9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Sep 2020 22:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgIWUYR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Sep 2020 16:24:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbgIWUYQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Sep 2020 16:24:16 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F71206DB;
        Wed, 23 Sep 2020 20:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600892656;
        bh=m9lLy4YG7QUviV6NxrG8TOxK7p5EndnC6dSyGBjBtPc=;
        h=From:To:Cc:Subject:Date:From;
        b=xtx4f/F+09wDgWErCMvOHx74N0+91BA5eA0nyLvB+FfgO6uILFpLn2+4QepYSnNQF
         ZU5XesogRP2H8LdXcCPZC7WYJfgd05WlorosZrCzaPI/M7SxNY1Xi3sisRWRGh6VJu
         6pwcaSag7A+H44Vz97ys6xJBKkLBQwHAhhFPZaB4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Martijn Coenen <maco@android.com>
Subject: [fsverity-utils PATCH] Move libfsverity.h to its own directory
Date:   Wed, 23 Sep 2020 13:23:28 -0700
Message-Id: <20200923202328.16310-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

libfsverity.h is the public API, but the other headers in common/ are
private headers for fsverity-utils.  Move libfsverity.h to its own
directory to make this clear.  This is also needed for Android's build
system in order to restrict the exported headers to libfsverity.h.

This doesn't affect users who are using 'make install', since
'make install' still installs libfsverity.h to the same place,
and it doesn't install any private headers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Makefile                          | 4 ++--
 {common => include}/libfsverity.h | 0
 lib/lib_private.h                 | 2 +-
 programs/utils.h                  | 2 +-
 scripts/do-release.sh             | 2 +-
 scripts/run-sparse.sh             | 2 +-
 scripts/run-tests.sh              | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)
 rename {common => include}/libfsverity.h (100%)

diff --git a/Makefile b/Makefile
index ec23ed6..deffe8b 100644
--- a/Makefile
+++ b/Makefile
@@ -44,7 +44,7 @@ CFLAGS ?= -O2 -Wall -Wundef					\
 	$(call cc-option,-Wunused-parameter)			\
 	$(call cc-option,-Wvla)
 
-override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
 ifneq ($(V),1)
 QUIET_CC        = @echo '  CC      ' $@;
@@ -182,7 +182,7 @@ install:all
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
-	install -m644 common/libfsverity.h $(DESTDIR)$(INCDIR)
+	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
 
 uninstall:
 	rm -f $(DESTDIR)$(BINDIR)/fsverity
diff --git a/common/libfsverity.h b/include/libfsverity.h
similarity index 100%
rename from common/libfsverity.h
rename to include/libfsverity.h
diff --git a/lib/lib_private.h b/lib/lib_private.h
index 54f583e..ff00490 100644
--- a/lib/lib_private.h
+++ b/lib/lib_private.h
@@ -11,7 +11,7 @@
 #ifndef LIB_LIB_PRIVATE_H
 #define LIB_LIB_PRIVATE_H
 
-#include "../common/libfsverity.h"
+#include "libfsverity.h"
 #include "../common/common_defs.h"
 #include "../common/fsverity_uapi.h"
 
diff --git a/programs/utils.h b/programs/utils.h
index cd5641c..6968708 100644
--- a/programs/utils.h
+++ b/programs/utils.h
@@ -11,7 +11,7 @@
 #ifndef PROGRAMS_UTILS_H
 #define PROGRAMS_UTILS_H
 
-#include "../common/libfsverity.h"
+#include "libfsverity.h"
 #include "../common/common_defs.h"
 
 #include <stdio.h>
diff --git a/scripts/do-release.sh b/scripts/do-release.sh
index 9662919..255fc53 100755
--- a/scripts/do-release.sh
+++ b/scripts/do-release.sh
@@ -27,7 +27,7 @@ major=$(echo "$VERS" | cut -d. -f1)
 minor=$(echo "$VERS" | cut -d. -f2)
 sed -E -i -e "/FSVERITY_UTILS_MAJOR_VERSION/s/[0-9]+/$major/" \
 	  -e "/FSVERITY_UTILS_MINOR_VERSION/s/[0-9]+/$minor/" \
-	  common/libfsverity.h
+	  include/libfsverity.h
 git commit -a --signoff --message="v$VERS"
 git tag --sign "v$VERS" --message="$PKG"
 
diff --git a/scripts/run-sparse.sh b/scripts/run-sparse.sh
index 5b6a0ba..fe43ce2 100755
--- a/scripts/run-sparse.sh
+++ b/scripts/run-sparse.sh
@@ -10,5 +10,5 @@ set -e -u -o pipefail
 
 find . -name '*.c' | while read -r file; do
 	sparse "$file" -gcc-base-dir "$(gcc --print-file-name=)"	\
-		-D_FILE_OFFSET_BITS=64 -I. -Wbitwise
+		-D_FILE_OFFSET_BITS=64 -Iinclude -Wbitwise
 done
diff --git a/scripts/run-tests.sh b/scripts/run-tests.sh
index 44df304..c061e34 100755
--- a/scripts/run-tests.sh
+++ b/scripts/run-tests.sh
@@ -71,7 +71,7 @@ int main()
 	std::cout << libfsverity_get_digest_size(FS_VERITY_HASH_ALG_SHA256) << std::endl;
 }
 EOF
-c++ -Wall -Werror "$TMPDIR/test.cc" -Icommon -L. -lfsverity -o "$TMPDIR/test"
+c++ -Wall -Werror "$TMPDIR/test.cc" -Iinclude -L. -lfsverity -o "$TMPDIR/test"
 [ "$(LD_LIBRARY_PATH=. "$TMPDIR/test")" = "32" ]
 rm "${TMPDIR:?}"/*
 
-- 
2.28.0

