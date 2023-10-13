Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C7F7C7DA7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjJMG0q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJMG0q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:26:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE07B7;
        Thu, 12 Oct 2023 23:26:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A100C433C8;
        Fri, 13 Oct 2023 06:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697178403;
        bh=wXCwf18WXU/XuRehE5AvSS0N52oh5k0pBpII03jJ73Y=;
        h=From:To:Cc:Subject:Date:From;
        b=g8ZwkSEfOX7ZA11DlsR+Gh9Xlwlf2M4FedtFwCAdmQy5fHrhHWkwzQNnl9+PmV+py
         BnTlMpl+4GTzv64qPX1ABjnjklrK5je3n20bnev2SI6+L9BerEbAYbhEhmEVPK9jwJ
         W1xGgrz7QROtI6NHQT2i+Lge5GAOD3gQVqami24u3Yeqr4ZXtBtC5eVTYsDih+3FSH
         FONaIyB2uwmfICCNVGUVUttHzfrU6v9tT0Oi81AgAX1EqSMnB7YDgwKbMLAwa6U4HJ
         Uk3qBeFBDVIbDgk203KsMJaGalvr3gI191LYQKBZSUFBGWj58SiYkY5PaGk/pvd+iV
         7G4+fMeHDuBog==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, fstests@vger.kernel.org
Subject: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data unit size
Date:   Thu, 12 Oct 2023 23:26:39 -0700
Message-ID: <20231013062639.141468-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
exercising the log2_data_unit_size field that is being added to struct
fscrypt_policy_v2 (kernel patch:
https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).

The xfs_io support is needed for xfstests
(https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
which currently relies on xfs_io to access the encryption ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  4 +++
 io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
 m4/package_libcdev.m4 | 21 +++++++++++++
 man/man8/xfs_io.8     |  5 ++-
 5 files changed, 84 insertions(+), 19 deletions(-)

diff --git a/configure.ac b/configure.ac
index febd0c09..2034f02e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -180,20 +180,21 @@ AC_HAVE_PREADV
 AC_HAVE_COPY_FILE_RANGE
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_SYNCFS
 AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
 AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
+AC_NEED_INTERNAL_FSCRYPT_POLICY_V2
 AC_HAVE_GETFSMAP
 AC_HAVE_STATFS_FLAGS
 AC_HAVE_MAP_SYNC
 AC_HAVE_DEVMAPPER
 AC_HAVE_MALLINFO
 AC_HAVE_MALLINFO2
 AC_PACKAGE_WANT_ATTRIBUTES_H
 AC_HAVE_LIBATTR
 if test "$enable_scrub" = "yes"; then
         if test "$enable_libicu" = "yes" || test "$enable_libicu" = "probe"; then
diff --git a/include/builddefs.in b/include/builddefs.in
index 147c9b98..43025ba4 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -103,20 +103,21 @@ HAVE_PWRITEV2 = @have_pwritev2@
 HAVE_COPY_FILE_RANGE = @have_copy_file_range@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_SYNCFS = @have_syncfs@
 HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
 NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
+NEED_INTERNAL_FSCRYPT_POLICY_V2 = @need_internal_fscrypt_policy_v2@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_STATFS_FLAGS = @have_statfs_flags@
 HAVE_MAP_SYNC = @have_map_sync@
 HAVE_DEVMAPPER = @have_devmapper@
 HAVE_MALLINFO = @have_mallinfo@
 HAVE_MALLINFO2 = @have_mallinfo2@
 HAVE_LIBATTR = @have_libattr@
 HAVE_LIBICU = @have_libicu@
 HAVE_OPENAT = @have_openat@
 HAVE_FSTATAT = @have_fstatat@
@@ -150,20 +151,23 @@ PCFLAGS+= -DHAVE_FSETXATTR
 endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
 endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
 ifeq ($(NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG
 endif
+ifeq ($(NEED_INTERNAL_FSCRYPT_POLICY_V2),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
 ifeq ($(HAVE_FALLOCATE),yes)
 PCFLAGS += -DHAVE_FALLOCATE
 endif
 
 LIBICU_LIBS = @libicu_LIBS@
 LIBICU_CFLAGS = @libicu_CFLAGS@
 ifeq ($(HAVE_LIBURCU_ATOMIC64),yes)
diff --git a/io/encrypt.c b/io/encrypt.c
index 1b347dc1..79061b07 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -1,19 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright 2016, 2019 Google LLC
  * Author: Eric Biggers <ebiggers@google.com>
  */
 
 #ifdef OVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG
 #  define fscrypt_add_key_arg sys_fscrypt_add_key_arg
 #endif
+#ifdef OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2
+#  define fscrypt_policy_v2 sys_fscrypt_policy_v2
+#  define fscrypt_get_policy_ex_arg sys_fscrypt_get_policy_ex_arg
+#endif
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
 #include "io.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 #endif
 
@@ -24,20 +28,49 @@
  */
 
 /* first batch of ioctls (Linux headers v4.6+) */
 #ifndef FS_IOC_SET_ENCRYPTION_POLICY
 #define fscrypt_policy fscrypt_policy_v1
 #define FS_IOC_SET_ENCRYPTION_POLICY		_IOR('f', 19, struct fscrypt_policy)
 #define FS_IOC_GET_ENCRYPTION_PWSALT		_IOW('f', 20, __u8[16])
 #define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy)
 #endif
 
+/*
+ * Since the log2_data_unit_size field was added later than fscrypt_policy_v2
+ * itself, we may need to override the system definition to get that field.
+ * And also fscrypt_get_policy_ex_arg since it contains fscrypt_policy_v2.
+ */
+#if !defined(FS_IOC_GET_ENCRYPTION_POLICY_EX) || \
+	defined(OVERRIDE_SYSTEM_FSCRYPT_POLICY_V2)
+#undef fscrypt_policy_v2
+struct fscrypt_policy_v2 {
+	__u8 version;
+	__u8 contents_encryption_mode;
+	__u8 filenames_encryption_mode;
+	__u8 flags;
+	__u8 log2_data_unit_size;
+	__u8 __reserved[3];
+	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+};
+
+#undef fscrypt_get_policy_ex_arg
+struct fscrypt_get_policy_ex_arg {
+	__u64 policy_size; /* input/output */
+	union {
+		__u8 version;
+		struct fscrypt_policy_v1 v1;
+		struct fscrypt_policy_v2 v2;
+	} policy; /* output */
+};
+#endif
+
 /*
  * Second batch of ioctls (Linux headers v5.4+), plus some renamings from FS_ to
  * FSCRYPT_.  We don't bother defining the old names here.
  */
 #ifndef FS_IOC_GET_ENCRYPTION_POLICY_EX
 
 #define FSCRYPT_POLICY_FLAGS_PAD_4		0x00
 #define FSCRYPT_POLICY_FLAGS_PAD_8		0x01
 #define FSCRYPT_POLICY_FLAGS_PAD_16		0x02
 #define FSCRYPT_POLICY_FLAGS_PAD_32		0x03
@@ -62,40 +95,26 @@
 struct fscrypt_policy_v1 {
 	__u8 version;
 	__u8 contents_encryption_mode;
 	__u8 filenames_encryption_mode;
 	__u8 flags;
 	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 };
 
 #define FSCRYPT_POLICY_V2		2
 #define FSCRYPT_KEY_IDENTIFIER_SIZE	16
-struct fscrypt_policy_v2 {
-	__u8 version;
-	__u8 contents_encryption_mode;
-	__u8 filenames_encryption_mode;
-	__u8 flags;
-	__u8 __reserved[4];
-	__u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
-};
+/* struct fscrypt_policy_v2 was defined earlier */
 
 #define FSCRYPT_MAX_KEY_SIZE		64
 
 #define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
-struct fscrypt_get_policy_ex_arg {
-	__u64 policy_size; /* input/output */
-	union {
-		__u8 version;
-		struct fscrypt_policy_v1 v1;
-		struct fscrypt_policy_v2 v2;
-	} policy; /* output */
-};
+/* struct fscrypt_get_policy_ex_arg was defined earlier */
 
 #define FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR	1
 #define FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER	2
 struct fscrypt_key_specifier {
 	__u32 type;	/* one of FSCRYPT_KEY_SPEC_TYPE_* */
 	__u32 __reserved;
 	union {
 		__u8 __reserved[32]; /* reserve some extra space */
 		__u8 descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 		__u8 identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
@@ -198,20 +217,21 @@ set_encpolicy_help(void)
 "                   (0000000000000000)\n"
 " 'set_encpolicy -v 2' - assign v2 policy with default key identifier\n"
 "                        (00000000000000000000000000000000)\n"
 " 'set_encpolicy 0000111122223333' - assign v1 policy with given key descriptor\n"
 " 'set_encpolicy 00001111222233334444555566667777' - assign v2 policy with given\n"
 "                                                    key identifier\n"
 "\n"
 " -c MODE -- contents encryption mode\n"
 " -n MODE -- filenames encryption mode\n"
 " -f FLAGS -- policy flags\n"
+" -s LOG2_DUSIZE -- log2 of data unit size\n"
 " -v VERSION -- policy version\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"));
 	printf("    ");
 	for (i = 0; i < ARRAY_SIZE(available_modes); i++) {
 		printf("%s", available_modes[i].name);
 		if (i != ARRAY_SIZE(available_modes) - 1)
 			printf(", ");
 	}
 	printf("\n");
@@ -581,29 +601,30 @@ get_encpolicy_f(int argc, char **argv)
 	return 0;
 }
 
 static int
 set_encpolicy_f(int argc, char **argv)
 {
 	int c;
 	__u8 contents_encryption_mode = FSCRYPT_MODE_AES_256_XTS;
 	__u8 filenames_encryption_mode = FSCRYPT_MODE_AES_256_CTS;
 	__u8 flags = FSCRYPT_POLICY_FLAGS_PAD_16;
+	__u8 log2_data_unit_size = 0;
 	int version = -1; /* unspecified */
 	struct fscrypt_key_specifier key_spec;
 	union {
 		__u8 version;
 		struct fscrypt_policy_v1 v1;
 		struct fscrypt_policy_v2 v2;
 	} policy;
 
-	while ((c = getopt(argc, argv, "c:n:f:v:")) != EOF) {
+	while ((c = getopt(argc, argv, "c:n:f:s:v:")) != EOF) {
 		switch (c) {
 		case 'c':
 			if (!parse_mode(optarg, &contents_encryption_mode)) {
 				fprintf(stderr,
 					_("invalid contents encryption mode: %s\n"),
 					optarg);
 				exitcode = 1;
 				return 0;
 			}
 			break;
@@ -617,20 +638,28 @@ set_encpolicy_f(int argc, char **argv)
 			}
 			break;
 		case 'f':
 			if (!parse_byte_value(optarg, &flags)) {
 				fprintf(stderr, _("invalid flags: %s\n"),
 					optarg);
 				exitcode = 1;
 				return 0;
 			}
 			break;
+		case 's':
+			if (!parse_byte_value(optarg, &log2_data_unit_size)) {
+				fprintf(stderr, _("invalid log2_dusize: %s\n"),
+					optarg);
+				exitcode = 1;
+				return 0;
+			}
+			break;
 		case 'v': {
 			__u8 val;
 
 			if (!parse_byte_value(optarg, &val)) {
 				fprintf(stderr,
 					_("invalid policy version: %s\n"),
 					optarg);
 				exitcode = 1;
 				return 0;
 			}
@@ -666,23 +695,30 @@ set_encpolicy_f(int argc, char **argv)
 	}
 	if (version < 0) /* version unspecified? */
 		version = FSCRYPT_POLICY_V1;
 
 	memset(&policy, 0, sizeof(policy));
 	policy.version = version;
 	if (version == FSCRYPT_POLICY_V2) {
 		policy.v2.contents_encryption_mode = contents_encryption_mode;
 		policy.v2.filenames_encryption_mode = filenames_encryption_mode;
 		policy.v2.flags = flags;
+		policy.v2.log2_data_unit_size = log2_data_unit_size;
 		memcpy(policy.v2.master_key_identifier, key_spec.u.identifier,
 		       FSCRYPT_KEY_IDENTIFIER_SIZE);
 	} else {
+		if (log2_data_unit_size != 0) {
+			fprintf(stderr,
+				"v1 policy does not support selecting the data unit size\n");
+			exitcode = 1;
+			return 0;
+		}
 		/*
 		 * xfstests passes .version = 255 for testing.  Just use
 		 * 'struct fscrypt_policy_v1' for both v1 and unknown versions.
 		 */
 		policy.v1.contents_encryption_mode = contents_encryption_mode;
 		policy.v1.filenames_encryption_mode = filenames_encryption_mode;
 		policy.v1.flags = flags;
 		memcpy(policy.v1.master_key_descriptor, key_spec.u.descriptor,
 		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
 	}
@@ -901,21 +937,21 @@ encrypt_init(void)
 	get_encpolicy_cmd.argmin = 0;
 	get_encpolicy_cmd.argmax = -1;
 	get_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	get_encpolicy_cmd.oneline =
 		_("display the encryption policy of the current file");
 	get_encpolicy_cmd.help = get_encpolicy_help;
 
 	set_encpolicy_cmd.name = "set_encpolicy";
 	set_encpolicy_cmd.cfunc = set_encpolicy_f;
 	set_encpolicy_cmd.args =
-		_("[-c mode] [-n mode] [-f flags] [-v version] [keyspec]");
+		_("[-c mode] [-n mode] [-f flags] [-s log2_dusize] [-v version] [keyspec]");
 	set_encpolicy_cmd.argmin = 0;
 	set_encpolicy_cmd.argmax = -1;
 	set_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	set_encpolicy_cmd.oneline =
 		_("assign an encryption policy to the current file");
 	set_encpolicy_cmd.help = set_encpolicy_help;
 
 	add_enckey_cmd.name = "add_enckey";
 	add_enckey_cmd.cfunc = add_enckey_f;
 	add_enckey_cmd.args = _("[-d descriptor] [-k key_id]");
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index f987aa4a..17407065 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -319,20 +319,41 @@ AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG],
           ,
           need_internal_fscrypt_add_key_arg=yes,
           [#include <linux/fs.h>]
         )
       ],,
       [#include <linux/fs.h>]
     )
     AC_SUBST(need_internal_fscrypt_add_key_arg)
   ])
 
+#
+# Check if we need to override the system struct fscrypt_policy_v2
+# with the internal definition.  This /only/ happens if the system
+# actually defines struct fscrypt_policy_v2 /and/ the system
+# definition is missing certain fields.
+#
+AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_POLICY_V2],
+  [
+    AC_CHECK_TYPE(struct fscrypt_policy_v2,
+      [
+        AC_CHECK_MEMBER(struct fscrypt_policy_v2.log2_data_unit_size,
+          ,
+          need_internal_fscrypt_policy_v2=yes,
+          [#include <linux/fs.h>]
+        )
+      ],,
+      [#include <linux/fs.h>]
+    )
+    AC_SUBST(need_internal_fscrypt_policy_v2)
+  ])
+
 #
 # Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
 #
 AC_DEFUN([AC_HAVE_GETFSMAP],
   [ AC_MSG_CHECKING([for GETFSMAP])
     AC_LINK_IFELSE(
     [	AC_LANG_PROGRAM([[
 #define _GNU_SOURCE
 #include <sys/syscall.h>
 #include <unistd.h>
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ef7087b3..52f04dd7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -706,21 +706,21 @@ Copy up to
 .I length
 bytes of data.
 .RE
 .PD
 .TP
 .BI swapext " donor_file "
 Swaps extent forks between files. The current open file is the target. The donor
 file is specified by path. Note that file data is not copied (file content moves
 with the fork(s)).
 .TP
-.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-v " version " ] [ " keyspec " ]"
+.BI "set_encpolicy [ \-c " mode " ] [ \-n " mode " ] [ \-f " flags " ] [ \-s " log2_dusize " ] [ \-v " version " ] [ " keyspec " ]"
 On filesystems that support encryption, assign an encryption policy to the
 current file.
 .I keyspec
 is a hex string which specifies the encryption key to use.  For v1 encryption
 policies,
 .I keyspec
 must be a 16-character hex string (8 bytes).  For v2 policies,
 .I keyspec
 must be a 32-character hex string (16 bytes).  If unspecified, an all-zeroes
 value is used.
@@ -729,20 +729,23 @@ value is used.
 .TP 0.4i
 .BI \-c " mode"
 contents encryption mode (e.g. AES-256-XTS)
 .TP
 .BI \-n " mode"
 filenames encryption mode (e.g. AES-256-CTS)
 .TP
 .BI \-f " flags"
 policy flags (numeric)
 .TP
+.BI \-s " log2_dusize"
+log2 of data unit size.  Not supported by v1 policies.
+.TP
 .BI \-v " version"
 policy version.  Defaults to 1 or 2 depending on the length of
 .IR keyspec ;
 or to 1 if
 .I keyspec
 is unspecified.
 .RE
 .PD
 .TP
 .BI "get_encpolicy [ \-1 ] [ \-t ]"

base-commit: 91d9bdb83deffa675d0d2323433de0748effb581
-- 
2.42.0

