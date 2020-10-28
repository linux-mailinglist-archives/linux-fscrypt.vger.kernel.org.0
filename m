Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71229D5BA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Oct 2020 23:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730096AbgJ1WH0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Oct 2020 18:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730087AbgJ1WHY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Oct 2020 18:07:24 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94650247FF;
        Wed, 28 Oct 2020 18:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603909795;
        bh=U+YdWF3qV1nfKkG1PXMCEmJxc0W5WHZiObRaVxdbiys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hxI91FYTNCbYzLkoC+0Kx1e8ulC5zkjm6M6PgyWR39mvIZ60QR4Fp+sbOH+6xBeEr
         hhaeNK9I/yg8KzbMXpLBH04IHlPRgie6O2zpxSlBhl0o+2UC8Ar37bHY5hR9ovuljO
         kw+YB28fy7Ni9rSuz41+4zExuqvOnZN6PWf6YOks=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [fsverity-utils PATCH] Makefile: adjust CFLAGS overriding
Date:   Wed, 28 Oct 2020 11:27:16 -0700
Message-Id: <20201028182716.154790-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <5339059d53b26837d1b90217ec21eb0d99e938ad.camel@gmail.com>
References: <5339059d53b26837d1b90217ec21eb0d99e938ad.camel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make any user-specified CFLAGS only replace flags that affect the
resulting binary.  Currently that means just "-O2".  Always add the
warning flags, although they can still be disabled by -Wno-*.  This
seems to be closer to what people want; see the discussion at
https://lkml.kernel.org/linux-fscrypt/20201026204831.3337360-1-luca.boccassi@gmail.com/T/#u

Also fix up scripts/run-tests.sh to use appropriate CFLAGS.  That is,
don't specify -Wall since the Makefile now adds it, always specify
-Werror, and usually specify an optimization level too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Makefile             |  7 ++++--
 scripts/run-tests.sh | 54 ++++++++++++++++++++++----------------------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/Makefile b/Makefile
index 6c6c8c9..cff8d36 100644
--- a/Makefile
+++ b/Makefile
@@ -35,14 +35,17 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
-CFLAGS ?= -O2 -Wall -Wundef					\
+CFLAGS ?= -O2
+
+override CFLAGS := -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wimplicit-fallthrough)		\
 	$(call cc-option,-Wmissing-field-initializers)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
 	$(call cc-option,-Wunused-parameter)			\
-	$(call cc-option,-Wvla)
+	$(call cc-option,-Wvla)					\
+	$(CFLAGS)
 
 override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
diff --git a/scripts/run-tests.sh b/scripts/run-tests.sh
index 8a03968..a47cc48 100755
--- a/scripts/run-tests.sh
+++ b/scripts/run-tests.sh
@@ -39,7 +39,7 @@ exec 2> >(tee -ia run-tests.log 1>&2)
 MAKE="make -j$(getconf _NPROCESSORS_ONLN)"
 
 log "Build and test with statically linking"
-$MAKE
+$MAKE CFLAGS="-Werror"
 if ldd fsverity | grep libfsverity.so; then
 	fail "fsverity binary should be statically linked to libfsverity by default"
 fi
@@ -51,7 +51,7 @@ if nm libfsverity.a | grep ' T ' | grep -v " libfsverity_"; then
 fi
 
 log "Build and test with dynamic linking"
-$MAKE USE_SHARED_LIB=1 check
+$MAKE CFLAGS="-Werror" USE_SHARED_LIB=1 check
 if ! ldd fsverity | grep libfsverity.so; then
 	fail "fsverity binary should be dynamically linked to libfsverity when USE_SHARED_LIB=1"
 fi
@@ -75,7 +75,7 @@ c++ -Wall -Werror "$TMPDIR/test.cc" -Iinclude -L. -lfsverity -o "$TMPDIR/test"
 rm "${TMPDIR:?}"/*
 
 log "Check that build doesn't produce untracked files"
-$MAKE all test_programs
+$MAKE CFLAGS="-Werror" all test_programs
 if git status --short | grep -q '^??'; then
 	git status
 	fail "Build produced untracked files (check 'git status').  Missing gitignore entry?"
@@ -120,64 +120,64 @@ if [ -s "$list" ]; then
 fi
 rm "$list"
 
-log "Build and test with gcc"
-$MAKE CC=gcc check
-
-log "Build and test with gcc (-Wall + -Werror)"
-$MAKE CC=gcc CFLAGS="-Wall -Werror" check
+log "Build and test with gcc (-O2)"
+$MAKE CC=gcc CFLAGS="-O2 -Werror" check
 
 log "Build and test with gcc (-O3)"
-$MAKE CC=gcc CFLAGS="-O3 -Wall -Werror" check
+$MAKE CC=gcc CFLAGS="-O3 -Werror" check
 
 log "Build and test with gcc (32-bit)"
-$MAKE CC=gcc CFLAGS="-m32 -O2 -Wall -Werror" check
-
-log "Build and test with clang"
-$MAKE CC=clang check
+$MAKE CC=gcc CFLAGS="-O2 -Werror -m32" check
 
-log "Build and test with clang (-Wall + -Werror)"
-$MAKE CC=clang CFLAGS="-Wall -Werror" check
+log "Build and test with clang (-O2)"
+$MAKE CC=clang CFLAGS="-O2 -Werror" check
 
 log "Build and test with clang (-O3)"
-$MAKE CC=clang CFLAGS="-O3 -Wall -Werror" check
+$MAKE CC=clang CFLAGS="-O3 -Werror" check
 
 log "Build and test with clang + UBSAN"
-$MAKE CC=clang CFLAGS="-fsanitize=undefined -fno-sanitize-recover=undefined" \
+$MAKE CC=clang \
+	CFLAGS="-O2 -Werror -fsanitize=undefined -fno-sanitize-recover=undefined" \
 	check
 
 log "Build and test with clang + ASAN"
-$MAKE CC=clang CFLAGS="-fsanitize=address -fno-sanitize-recover=address" check
+$MAKE CC=clang \
+	CFLAGS="-O2 -Werror -fsanitize=address -fno-sanitize-recover=address" \
+	check
 
 log "Build and test with clang + unsigned integer overflow sanitizer"
-$MAKE CC=clang CFLAGS="-fsanitize=unsigned-integer-overflow -fno-sanitize-recover=unsigned-integer-overflow" \
+$MAKE CC=clang \
+	CFLAGS="-O2 -Werror -fsanitize=unsigned-integer-overflow -fno-sanitize-recover=unsigned-integer-overflow" \
 	check
 
 log "Build and test with clang + CFI"
-$MAKE CC=clang CFLAGS="-fsanitize=cfi -flto -fvisibility=hidden" check
+$MAKE CC=clang CFLAGS="-O2 -Werror -fsanitize=cfi -flto -fvisibility=hidden" \
+	check
 
 log "Build and test with valgrind"
 $MAKE TEST_WRAPPER_PROG="valgrind --quiet --error-exitcode=100 --leak-check=full --errors-for-leak-kinds=all" \
-	check
+	CFLAGS="-O2 -Werror" check
 
 log "Build and test using BoringSSL instead of OpenSSL"
 BSSL=$HOME/src/boringssl
-$MAKE LDFLAGS="-L$BSSL/build/crypto" CPPFLAGS="-I$BSSL/include" \
-	LDLIBS="-lcrypto -lpthread" check
+$MAKE CFLAGS="-O2 -Werror" LDFLAGS="-L$BSSL/build/crypto" \
+	CPPFLAGS="-I$BSSL/include" LDLIBS="-lcrypto -lpthread" check
 
 log "Build and test using -funsigned-char"
-$MAKE CFLAGS="-funsigned-char -Wall -Werror" check
+$MAKE CFLAGS="-O2 -Werror -funsigned-char" check
 
 log "Build and test using -fsigned-char"
-$MAKE CFLAGS="-fsigned-char -Wall -Werror" check
+$MAKE CFLAGS="-O2 -Werror -fsigned-char" check
 
 log "Run sparse"
 ./scripts/run-sparse.sh
 
 log "Run clang static analyzer"
-scan-build --status-bugs make all test_programs
+scan-build --status-bugs make CFLAGS="-O2 -Werror" all test_programs
 
 log "Run gcc static analyzer"
-$MAKE CC=gcc CFLAGS="-fanalyzer -Werror" all test_programs
+# Using -O2 here produces a false positive report in fsverity_cmd_sign().
+$MAKE CC=gcc CFLAGS="-O0 -Werror -fanalyzer" all test_programs
 
 log "Run shellcheck"
 shellcheck scripts/*.sh 1>&2
-- 
2.29.1

