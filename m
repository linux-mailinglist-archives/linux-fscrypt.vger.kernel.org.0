Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D32102F69
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Nov 2019 23:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfKSWfo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Nov 2019 17:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfKSWfo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Nov 2019 17:35:44 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F98122449;
        Tue, 19 Nov 2019 22:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574202942;
        bh=LlKJsgsUeADvLLy81A2dvgQYKFYUOtvPPmXnIL6rDRs=;
        h=From:To:Cc:Subject:Date:From;
        b=gzOhm2d/vblWOzB4huynAQAmCVKXsM3NUR61KCuFYxuAnowA6PJXlorCcTgu29fHL
         epVTCFDnwKRoq+5FlFU0L61rrVXTDTet1oAy+oocF2u7GQqXd+2og48vBv1w4BZCNf
         1Nr71zTbfK/OXQxDBUWhq+lYLbyuwK2g3NfM5b+I=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [xfsprogs RFC PATCH] xfs_io/encrypt: support passing a keyring key to add_enckey
Date:   Tue, 19 Nov 2019 14:34:56 -0800
Message-Id: <20191119223456.230696-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a '-k' option to the 'add_enckey' xfs_io command to allow exercising
the key_id field that is being added to struct fscrypt_add_key_arg.

This is needed for the corresponding test in xfstests.

For more details, see the corresponding xfstests and kernel patches.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I'm sending this out for comment now, but it shouldn't be merged until
the corresponding kernel patch has reached mainline.

 configure.ac          |  1 +
 include/builddefs.in  |  4 ++
 io/encrypt.c          | 90 +++++++++++++++++++++++++++++++------------
 m4/package_libcdev.m4 | 21 ++++++++++
 man/man8/xfs_io.8     | 10 +++--
 5 files changed, 98 insertions(+), 28 deletions(-)

diff --git a/configure.ac b/configure.ac
index 30b1213b..3323181c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -176,6 +176,7 @@ AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
 AC_HAVE_MREMAP
 AC_NEED_INTERNAL_FSXATTR
+AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG
 AC_HAVE_GETFSMAP
 AC_HAVE_STATFS_FLAGS
 AC_HAVE_MAP_SYNC
diff --git a/include/builddefs.in b/include/builddefs.in
index 4700b527..3b6b1c1b 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,6 +102,7 @@ HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
 NEED_INTERNAL_FSXATTR = @need_internal_fsxattr@
+NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG = @need_internal_fscrypt_add_key_arg@
 HAVE_GETFSMAP = @have_getfsmap@
 HAVE_STATFS_FLAGS = @have_statfs_flags@
 HAVE_MAP_SYNC = @have_map_sync@
@@ -141,6 +142,9 @@ endif
 ifeq ($(NEED_INTERNAL_FSXATTR),yes)
 PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
 endif
+ifeq ($(NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG
+endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
diff --git a/io/encrypt.c b/io/encrypt.c
index de48c50c..01b7e0df 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -4,6 +4,9 @@
  * Author: Eric Biggers <ebiggers@google.com>
  */
 
+#ifdef OVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG
+#  define fscrypt_add_key_arg sys_fscrypt_add_key_arg
+#endif
 #include "platform_defs.h"
 #include "command.h"
 #include "init.h"
@@ -99,13 +102,7 @@ struct fscrypt_key_specifier {
 	} u;
 };
 
-#define FS_IOC_ADD_ENCRYPTION_KEY		_IOWR('f', 23, struct fscrypt_add_key_arg)
-struct fscrypt_add_key_arg {
-	struct fscrypt_key_specifier key_spec;
-	__u32 raw_size;
-	__u32 __reserved[9];
-	__u8 raw[];
-};
+/* FS_IOC_ADD_ENCRYPTION_KEY is defined later */
 
 #define FS_IOC_REMOVE_ENCRYPTION_KEY		_IOWR('f', 24, struct fscrypt_remove_key_arg)
 #define FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS	_IOWR('f', 25, struct fscrypt_remove_key_arg)
@@ -136,6 +133,26 @@ struct fscrypt_get_key_status_arg {
 
 #endif /* !FS_IOC_GET_ENCRYPTION_POLICY_EX */
 
+/*
+ * Since the key_id field was added later than struct fscrypt_add_key_arg
+ * itself, we may need to override the system definition to get that field.
+ */
+#if !defined(FS_IOC_ADD_ENCRYPTION_KEY) || \
+	defined(OVERRIDE_SYSTEM_FSCRYPT_ADD_KEY_ARG)
+#undef fscrypt_add_key_arg
+struct fscrypt_add_key_arg {
+	struct fscrypt_key_specifier key_spec;
+	__u32 raw_size;
+	__u32 key_id;
+	__u32 __reserved[8];
+	__u8 raw[];
+};
+#endif
+
+#ifndef FS_IOC_ADD_ENCRYPTION_KEY
+#  define FS_IOC_ADD_ENCRYPTION_KEY		_IOWR('f', 23, struct fscrypt_add_key_arg)
+#endif
+
 static const struct {
 	__u8 mode;
 	const char *name;
@@ -217,8 +234,9 @@ add_enckey_help(void)
 " 'add_enckey' - add key for v2 policies\n"
 " 'add_enckey -d 0000111122223333' - add key for v1 policies w/ given descriptor\n"
 "\n"
-"The key in binary is read from standard input.\n"
+"Unless -k is given, the key in binary is read from standard input.\n"
 " -d DESCRIPTOR -- master_key_descriptor\n"
+" -k KEY_ID -- ID of fscrypt-provisioning key containing the raw key\n"
 "\n"));
 }
 
@@ -431,6 +449,21 @@ str2keyspec(const char *str, int policy_version,
 	return policy_version;
 }
 
+static int
+parse_key_id(const char *arg)
+{
+	long value;
+	char *tmp;
+
+	value = strtol(arg, &tmp, 0);
+	if (value <= 0 || value > INT_MAX || tmp == arg || *tmp != '\0') {
+		fprintf(stderr, _("invalid key ID: %s\n"), arg);
+		/* 0 is never a valid Linux key ID. */
+		return 0;
+	}
+	return value;
+}
+
 static void
 test_for_v2_policy_support(void)
 {
@@ -689,13 +722,18 @@ add_enckey_f(int argc, char **argv)
 
 	arg->key_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
 
-	while ((c = getopt(argc, argv, "d:")) != EOF) {
+	while ((c = getopt(argc, argv, "d:k:")) != EOF) {
 		switch (c) {
 		case 'd':
 			arg->key_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
 			if (!str2keydesc(optarg, arg->key_spec.u.descriptor))
 				goto out;
 			break;
+		case 'k':
+			arg->key_id = parse_key_id(optarg);
+			if (arg->key_id == 0)
+				goto out;
+			break;
 		default:
 			retval = command_usage(&add_enckey_cmd);
 			goto out;
@@ -709,21 +747,23 @@ add_enckey_f(int argc, char **argv)
 		goto out;
 	}
 
-	raw_size = read_until_limit_or_eof(STDIN_FILENO, arg->raw,
-					   FSCRYPT_MAX_KEY_SIZE + 1);
-	if (raw_size < 0) {
-		fprintf(stderr, _("Error reading key from stdin: %s\n"),
-			strerror(errno));
-		exitcode = 1;
-		goto out;
-	}
-	if (raw_size > FSCRYPT_MAX_KEY_SIZE) {
-		fprintf(stderr,
-			_("Invalid key; got > FSCRYPT_MAX_KEY_SIZE (%d) bytes on stdin!\n"),
-			FSCRYPT_MAX_KEY_SIZE);
-		goto out;
-	}
-	arg->raw_size = raw_size;
+	if (arg->key_id == 0) {
+		raw_size = read_until_limit_or_eof(STDIN_FILENO, arg->raw,
+						   FSCRYPT_MAX_KEY_SIZE + 1);
+		if (raw_size < 0) {
+			fprintf(stderr, _("Error reading key from stdin: %s\n"),
+				strerror(errno));
+			exitcode = 1;
+			goto out;
+		}
+		if (raw_size > FSCRYPT_MAX_KEY_SIZE) {
+			fprintf(stderr,
+				_("Invalid key; got > FSCRYPT_MAX_KEY_SIZE (%d) bytes on stdin!\n"),
+				FSCRYPT_MAX_KEY_SIZE);
+			goto out;
+		}
+		arg->raw_size = raw_size;
+	} /* else, raw key is given via key with ID 'key_id' */
 
 	if (ioctl(file->fd, FS_IOC_ADD_ENCRYPTION_KEY, arg) != 0) {
 		fprintf(stderr, _("Error adding encryption key: %s\n"),
@@ -859,7 +899,7 @@ encrypt_init(void)
 
 	add_enckey_cmd.name = "add_enckey";
 	add_enckey_cmd.cfunc = add_enckey_f;
-	add_enckey_cmd.args = _("[-d descriptor]");
+	add_enckey_cmd.args = _("[-d descriptor] [-k key_id]");
 	add_enckey_cmd.argmin = 0;
 	add_enckey_cmd.argmax = -1;
 	add_enckey_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 2c0c72ce..adab9bb9 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -278,6 +278,27 @@ AC_DEFUN([AC_NEED_INTERNAL_FSXATTR],
     AC_SUBST(need_internal_fsxattr)
   ])
 
+#
+# Check if we need to override the system struct fscrypt_add_key_arg
+# with the internal definition.  This /only/ happens if the system
+# actually defines struct fscrypt_add_key_arg /and/ the system
+# definition is missing certain fields.
+#
+AC_DEFUN([AC_NEED_INTERNAL_FSCRYPT_ADD_KEY_ARG],
+  [
+    AC_CHECK_TYPE(struct fscrypt_add_key_arg,
+      [
+        AC_CHECK_MEMBER(struct fscrypt_add_key_arg.key_id,
+          ,
+          need_internal_fscrypt_add_key_arg=yes,
+          [#include <linux/fs.h>]
+        )
+      ],,
+      [#include <linux/fs.h>]
+    )
+    AC_SUBST(need_internal_fscrypt_add_key_arg)
+  ])
+
 #
 # Check if we have a FS_IOC_GETFSMAP ioctl (Linux)
 #
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index c69b295d..0afe3e7f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -749,10 +749,10 @@ Test whether v2 encryption policies are supported.  Prints "supported",
 .RE
 .PD
 .TP
-.BI "add_enckey [ \-d " descriptor " ]"
+.BI "add_enckey [ \-d " descriptor " ] [ \-k " key_id " ]"
 On filesystems that support encryption, add an encryption key to the filesystem
-containing the currently open file.  The key in binary (typically 64 bytes long)
-is read from standard input.
+containing the currently open file.  By default, the raw key in binary
+(typically 64 bytes long) is read from standard input.
 .RS 1.0i
 .PD 0
 .TP 0.4i
@@ -761,6 +761,10 @@ key descriptor, as a 16-character hex string (8 bytes).  If given, the key will
 be available for use by v1 encryption policies that use this descriptor.
 Otherwise, the key is added as a v2 policy key, and on success the resulting
 "key identifier" will be printed.
+.TP
+.BI \-k " key_id"
+ID of kernel keyring key of type "fscrypt-provisioning".  If given, the raw key
+will be taken from here rather than from standard input.
 .RE
 .PD
 .TP
-- 
2.24.0.432.g9d3f5f5b63-goog

