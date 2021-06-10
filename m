Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF23A2540
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jun 2021 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhFJHYn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Jun 2021 03:24:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhFJHYn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Jun 2021 03:24:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC355613BC;
        Thu, 10 Jun 2021 07:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623309767;
        bh=F/Ftpe1lDcCkpc6u0Y60+x9FMKhKAwISjSLNS3Whs5A=;
        h=From:To:Cc:Subject:Date:From;
        b=oJrPAQ/c2x8BZMIVnZtKlt4tOK1acGypNfL5krerS/1Wk3DetBQhlb7F8T07LSBHN
         ucDoX1WTcV1f/cqlyQxPp4eX3BQ22DGG0fA2Tijh/3kzZh4iRz9ToXCVBlWLwdxf56
         yjz7FwBHrfVXFA1v2W8fIl/gqA2yUcbn8kbJR3Y56NLRoXrb+wHpEEupsB17ieJeyA
         u41VhNklpc2UI925zUBDlI9X2PGnSpT0TEgrBkOftln6Jzxu9GmgSaQCCND3AVV+yh
         6rsWvczcVf6+VgK8Jd74bGScK1yWsqSehQoxYsA1BhzesZ6MfUQgP6SGP11Ei/Gx8k
         Ros2E1AqhleWg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Luca Boccassi <bluca@debian.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Subject: [fsverity-utils PATCH] Add man page for fsverity
Date:   Thu, 10 Jun 2021 00:20:56 -0700
Message-Id: <20210610072056.35190-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a manual page for the fsverity utility, documenting all subcommands
and options.

The page is written in Markdown and is translated to groff using pandoc.
It can be installed by 'make install-man'.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 .gitignore            |   1 +
 Makefile              |  32 ++++++-
 README.md             |  14 +++-
 man/fsverity.1.md     | 191 ++++++++++++++++++++++++++++++++++++++++++
 scripts/do-release.sh |   6 ++
 scripts/run-tests.sh  |   2 +-
 6 files changed, 239 insertions(+), 7 deletions(-)
 create mode 100644 man/fsverity.1.md

diff --git a/.gitignore b/.gitignore
index 6117e52..eba6ab6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,3 +1,4 @@
+*.[1-9]
 *.a
 *.exe
 *.o
diff --git a/Makefile b/Makefile
index fd28b06..c97790e 100644
--- a/Makefile
+++ b/Makefile
@@ -25,6 +25,9 @@
 # Define LIBDIR to override where to install libraries, like './configure
 # --libdir' in autotools-based projects (default: PREFIX/lib)
 #
+# Define MANDIR to override where to install man pages, like './configure
+# --mandir' in autotools-based projects (default: PREFIX/share/man)
+#
 # Define DESTDIR to override the installation destination directory
 # (default: empty string)
 #
@@ -61,12 +64,14 @@ QUIET_CCLD      = @echo '  CCLD    ' $@;
 QUIET_AR        = @echo '  AR      ' $@;
 QUIET_LN        = @echo '  LN      ' $@;
 QUIET_GEN       = @echo '  GEN     ' $@;
+QUIET_PANDOC    = @echo '  PANDOC  ' $@;
 endif
 USE_SHARED_LIB  ?=
 PREFIX          ?= /usr/local
 BINDIR          ?= $(PREFIX)/bin
 INCDIR          ?= $(PREFIX)/include
 LIBDIR          ?= $(PREFIX)/lib
+MANDIR          ?= $(PREFIX)/share/man
 DESTDIR         ?=
 ifneq ($(MINGW),1)
 PKGCONF         ?= pkg-config
@@ -92,6 +97,7 @@ FSVERITY        := fsverity$(EXEEXT)
 	fi
 
 DEFAULT_TARGETS :=
+EXTRA_TARGETS   :=
 COMMON_HEADERS  := $(wildcard common/*.h)
 LDLIBS          := $(shell "$(PKGCONF)" libcrypto --libs 2>/dev/null || echo -lcrypto)
 CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
@@ -187,9 +193,22 @@ DEFAULT_TARGETS += $(FSVERITY)
 $(TEST_PROGRAMS): %$(EXEEXT): programs/%.o $(PROG_COMMON_OBJ) libfsverity.a
 	$(QUIET_CCLD) $(CC) -o $@ $+ $(CFLAGS) $(LDFLAGS) $(LDLIBS)
 
+EXTRA_TARGETS += $(TEST_PROGRAMS)
+
 ##############################################################################
 
-SPECIAL_TARGETS := all test_programs check install uninstall help clean
+#### Manual pages
+
+man/fsverity.1:man/fsverity.1.md
+	$(QUIET_PANDOC) pandoc $+ -s -t man > $@
+
+MAN_PAGES := man/fsverity.1
+EXTRA_TARGETS += $(MAN_PAGES)
+
+##############################################################################
+
+SPECIAL_TARGETS := all test_programs check install install-man uninstall \
+		   help clean
 
 FORCE:
 
@@ -233,6 +252,10 @@ install:all
 		> $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 	chmod 644 $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 
+install-man:$(MAN_PAGES)
+	install -d $(DESTDIR)$(MANDIR)/man1
+	install -m644 $+ $(DESTDIR)$(MANDIR)/man1/
+
 uninstall:
 	rm -f $(DESTDIR)$(BINDIR)/$(FSVERITY)
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.a
@@ -240,15 +263,18 @@ uninstall:
 	rm -f $(DESTDIR)$(LIBDIR)/libfsverity.so
 	rm -f $(DESTDIR)$(LIBDIR)/pkgconfig/libfsverity.pc
 	rm -f $(DESTDIR)$(INCDIR)/libfsverity.h
+	for page in $(notdir $(MAN_PAGES)); do \
+		rm -f $(DESTDIR)$(MANDIR)/man1/$$page; \
+	done
 
 help:
 	@echo "Available targets:"
 	@echo "------------------"
-	@for target in $(DEFAULT_TARGETS) $(TEST_PROGRAMS) $(SPECIAL_TARGETS); \
+	@for target in $(DEFAULT_TARGETS) $(EXTRA_TARGETS) $(SPECIAL_TARGETS); \
 	do \
 		echo $$target; \
 	done
 
 clean:
-	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
+	rm -f $(DEFAULT_TARGETS) $(EXTRA_TARGETS) \
 		lib/*.o programs/*.o .build-config fsverity.sig
diff --git a/README.md b/README.md
index 2b63488..14c7bbe 100644
--- a/README.md
+++ b/README.md
@@ -24,20 +24,22 @@ See `libfsverity.h` for the API of this library.
 
 ## Building and installing
 
-fsverity-utils uses the OpenSSL library, so you first must install the
-needed development files.  For example, on Debian-based systems, run:
+To build fsverity-utils, first install the needed build dependencies.  For
+example, on Debian-based systems, run:
 
 ```bash
     sudo apt-get install libssl-dev
+    sudo apt-get install pandoc  # optional
 ```
 
-OpenSSL must be version 1.0.0 or later.
+OpenSSL must be version 1.0.0 or later.  This is the only runtime dependency.
 
 Then, to build and install fsverity-utils:
 
 ```bash
     make
     sudo make install
+    sudo make install-man  # optional
 ```
 
 By default, the following targets are built and installed: the program
@@ -45,6 +47,9 @@ By default, the following targets are built and installed: the program
 `libfsverity.so`.  You can also run `make check` to build and run the
 tests, or `make help` to display all available build targets.
 
+`make install-man` installs the `fsverity.1` manual page.  This step requires
+that `pandoc` be installed.
+
 By default, `fsverity` is statically linked to `libfsverity`.  You can
 use `make USE_SHARED_LIB=1` to use dynamic linking instead.
 
@@ -63,6 +68,9 @@ A Windows build of OpenSSL/libcrypto needs to be available.
 
 ## Examples
 
+Full usage information for `fsverity` can be found in the manual page
+(`man fsverity`).  Here, we just show some typical examples.
+
 ### Basic use
 
 ```bash
diff --git a/man/fsverity.1.md b/man/fsverity.1.md
new file mode 100644
index 0000000..5dc798f
--- /dev/null
+++ b/man/fsverity.1.md
@@ -0,0 +1,191 @@
+% FSVERITY(1) fsverity-utils v1.3 | User Commands
+%
+% June 2021
+
+# NAME
+
+fsverity - userspace utility for fs-verity
+
+# SYNOPSIS
+**fsverity digest** [*OPTION*...] *FILE*... \
+**fsverity dump_metadata** [*OPTION*...] *TYPE* *FILE* \
+**fsverity enable** [*OPTION*...] *FILE* \
+**fsverity measure** *FILE*... \
+**fsverity sign \-\-key**=*KEYFILE* [*OPTION*...] *FILE* *OUT_SIGFILE*
+
+# DESCRIPTION
+
+**fsverity** is a userspace utility for fs-verity.  fs-verity is a Linux kernel
+filesystem feature that does transparent on-demand verification of the contents
+of read-only files using Merkle trees.
+
+**fsverity** can enable fs-verity on files, retrieve the digests of fs-verity
+files, and sign files for use with fs-verity (among other things).
+**fsverity**'s functionality is divided among various subcommands.
+
+This manual page focuses on documenting all **fsverity** subcommands and
+options.  For examples and more information about the fs-verity kernel feature,
+see the references at the end of this page.
+
+# OPTIONS
+
+**fsverity** always accepts the following options:
+
+**\-\-help**
+:   Show the help, for either one subcommand or for all subcommands.
+
+**\-\-version**
+:   Show the version of fsverity-utils.
+
+# SUBCOMMANDS
+
+## **fsverity digest** [*OPTION*...] *FILE*...
+
+Compute the fs-verity digest of the given file(s).  This is mainly intended to
+used in preparation for signing the digest.  In some cases **fsverity sign**
+can be used instead to digest and sign the file in one step.
+
+Options accepted by **fsverity digest**:
+
+**\-\-block-size**=*BLOCK_SIZE*
+:   The Merkle tree block size (in bytes) to use.  This must be a power of 2 and
+    at least twice the size of the hash values.  However, note that currently
+    (as of Linux kernel v5.13), the Linux kernel implementations of fs-verity
+    only support the case where the Merkle tree block size is equal to the
+    system page size, usually 4096 bytes.  The default value of this option is
+    4096.
+
+**\-\-compact**
+:   When printing the file digest, only print the actual digest hex string;
+    don't print the algorithm name and filename.
+
+**\-\-for-builtin-sig**
+:   Format the file digest in a way that is compatible with the Linux kernel's
+    fs-verity built-in signature verification support.  This means formatting it
+    as a `struct fsverity_formatted_digest`.  Use this option if you are using
+    built-in signatures but are not using **fsverity sign** to do the signing.
+
+**\-\-hash-alg**=*HASH_ALG*
+:   The hash algorithm to use to build the Merkle tree.  Valid options are
+    sha256 and sha512.  Default is sha256.
+
+**\-\-out-merkle-tree**=*FILE*
+:   Write the computed Merkle tree to the given file.  The Merkle tree layout
+    will be the same as that used by the Linux kernel's
+    `FS_IOC_READ_VERITY_METADATA` ioctl.
+
+    Normally this option isn't useful, but it can be needed in cases where the
+    fs-verity metadata needs to be consumed by something other than one of the
+    native Linux kernel implementations of fs-verity.  This is not needed for
+    file signing.
+
+**\-\-out-descriptor**=*FILE*
+:   Write the computed fs-verity descriptor to the given file.
+
+    Normally this option isn't useful, but it can be needed in cases where the
+    fs-verity metadata needs to be consumed by something other than one of the
+    native Linux kernel implementations of fs-verity.  This is not needed for
+    file signing.
+
+**\-\-salt**=*SALT*
+:   The salt to use in the Merkle tree, as a hex string.  The salt is a value
+    that is prepended to every hashed block; it can be used to personalize the
+    hashing for a particular file or device.  The default is no salt.
+
+## **fsverity dump_metadata** [*OPTION*...] *TYPE* *FILE*
+
+Dump the fs-verity metadata of the given file.  The file must have fs-verity
+enabled, and the filesystem must support the `FS_IOC_READ_VERITY_METADATA` ioctl
+(it was added in Linux v5.12).  This subcommand normally isn't useful, but it
+can be useful in cases where a userspace server program is serving a verity file
+to a client which implements fs-verity compatible verification.
+
+*TYPE* may be "merkle\_tree", "descriptor", or "signature", indicating the type
+of metadata to dump.  "signature" refers to the built-in signature, if present;
+userspace-managed signatures will not be included.
+
+Options accepted by **fsverity dump_metadata**:
+
+**\-\-length**=*LENGTH*
+:   Length in bytes to dump from the specified metadata item.  Only accepted in
+    combination with **\-\-offset**.
+
+**\-\-offset**=*offset*
+:   Offset in bytes into the specified metadata item at which to start dumping.
+    Only accepted in combination with **\-\-length**.
+
+## **fsverity enable** [*OPTION*...] *FILE*
+
+Enable fs-verity on the specified file.  This will only work if the filesystem
+supports fs-verity.
+
+Options accepted by **fsverity enable**:
+
+**\-\-block-size**=*BLOCK_SIZE*
+:   Same as for **fsverity digest**.
+
+**\-\-hash-alg**=*HASH_ALG*
+:   Same as for **fsverity digest**.
+
+**\-\-salt**=*SALT*
+:   Same as for **fsverity digest**.
+
+**\-\-signature**=*SIGFILE*
+:   Specifies the built-in signature to apply to the file.  *SIGFILE* must be a
+    file that contains the signature in PKCS#7 DER format, e.g. as produced by
+    the **fsverity sign** command.
+
+    Note that this option is only needed if the Linux kernel's fs-verity
+    built-in signature verification support is being used.  It is not needed if
+    the signatures will be verified in userspace, as in that case the signatures
+    should be stored separately.
+
+## **fsverity measure** *FILE*...
+
+Display the fs-verity digest of the given file(s).  The files must have
+fs-verity enabled.  The output will be the same as **fsverity digest** with
+the appropriate parameters, but **fsverity measure** will take constant time
+for each file regardless of the size of the file.
+
+**fsverity measure** does not accept any options.
+
+## **fsverity sign** **\-\-key**=*KEYFILE* [*OPTION*...] *FILE* *OUT_SIGFILE*
+
+Sign the given file for fs-verity, in a way that is compatible with the Linux
+kernel's fs-verity built-in signature verification support.  The signature will
+be written to *OUT_SIGFILE* in PKCS#7 DER format.
+
+Options accepted by **fsverity sign**:
+
+**\-\-block-size**=*BLOCK_SIZE*
+:   Same as for **fsverity digest**.
+
+**\-\-cert**=*CERTFILE*
+:   Specifies the file that contains the certificate, in PEM format.  This
+    option is required if *KEYFILE* contains only the private key and not also
+    the certificate.
+
+**\-\-hash-alg**=*HASH_ALG*
+:   Same as for **fsverity digest**.
+
+**\-\-key**=*KEYFILE*
+:   Specifies the file that contains the private key, in PEM format.  This
+    option is required.
+
+**\-\-out-descriptor**=*FILE*
+:   Same as for **fsverity digest**.
+
+**\-\-out-merkle-tree**=*FILE*
+:   Same as for **fsverity digest**.
+
+**\-\-salt**=*SALT*
+:   Same as for **fsverity digest**.
+
+# SEE ALSO
+
+For example commands and more information, see the
+[README file for
+fsverity-utils](https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/tree/README.md).
+
+Also see the [kernel documentation for
+fs-verity](https://www.kernel.org/doc/html/latest/filesystems/fsverity.html).
diff --git a/scripts/do-release.sh b/scripts/do-release.sh
index 352fcf1..9f6bf73 100755
--- a/scripts/do-release.sh
+++ b/scripts/do-release.sh
@@ -25,11 +25,17 @@ git clean -fdx
 
 major=$(echo "$VERS" | cut -d. -f1)
 minor=$(echo "$VERS" | cut -d. -f2)
+month=$(LC_ALL=C date +%B)
+year=$(LC_ALL=C date +%Y)
+
 sed -E -i -e "/FSVERITY_UTILS_MAJOR_VERSION/s/[0-9]+/$major/" \
 	  -e "/FSVERITY_UTILS_MINOR_VERSION/s/[0-9]+/$minor/" \
 	  include/libfsverity.h
 sed -E -i "/Version:/s/[0-9]+\.[0-9]+/$VERS/" \
 	  lib/libfsverity.pc.in
+sed -E -i -e "/^% /s/fsverity-utils v[0-9]+(\.[0-9]+)+/fsverity-utils v$VERS/" \
+	  -e "/^% /s/[a-zA-Z]+ 2[0-9]{3}/$month $year/" \
+	  man/*.[1-9].md
 git commit -a --signoff --message="v$VERS"
 git tag --sign "v$VERS" --message="$PKG"
 
diff --git a/scripts/run-tests.sh b/scripts/run-tests.sh
index 530fe34..9cdc7c1 100755
--- a/scripts/run-tests.sh
+++ b/scripts/run-tests.sh
@@ -101,7 +101,7 @@ log "Check that all files have license and copyright info"
 list="$TMPDIR/filelist"
 filter_license_info() {
 	# files to exclude from license and copyright info checks
-	grep -E -v '(\.gitignore|LICENSE|NEWS|README|testdata|fsverity_uapi\.h|libfsverity\.pc\.in)'
+	grep -E -v '(\.gitignore|LICENSE|.*\.md|testdata|fsverity_uapi\.h|libfsverity\.pc\.in)'
 }
 git grep -L 'SPDX-License-Identifier: MIT' \
 	| filter_license_info > "$list" || true
-- 
2.32.0

