Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B55B8873
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393865AbfITAUJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391427AbfITAUI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:08 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EEFA21928;
        Fri, 20 Sep 2019 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938803;
        bh=CK7mg5Js52t3O0qxmlvDRO/FTd4SxmqfrYdmh70yRyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzNTsy+A4tKdbFSyvfSgxQEUj5PGiTmLPxMhw1l/Ks1kXwNtjtwIv9oxIMYd4LNZV
         Seo4N/fQFLU2+YkSaUutIBU0dtbQxGDA+FSuzvoEw7Ax35PYqPSbz21xJWPDMRDnO/
         FeE6X6cIvuvCFCEi28tBKzg1dzBhkUFHjzyCHgZE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 4/8] xfs_io/encrypt: extend 'get_encpolicy' to support v2 policies
Date:   Thu, 19 Sep 2019 17:18:18 -0700
Message-Id: <20190920001822.257411-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920001822.257411-1-ebiggers@kernel.org>
References: <20190920001822.257411-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

get_encpolicy uses the FS_IOC_GET_ENCRYPTION_POLICY ioctl to retrieve
the file's encryption policy, then displays it.  But that only works for
v1 encryption policies.  A new ioctl, FS_IOC_GET_ENCRYPTION_POLICY_EX,
has been introduced which is more flexible and can retrieve both v1 and
v2 encryption policies.

Make get_encpolicy use the new ioctl if the kernel supports it and
display the resulting the v1 or v2 encryption policy.  Otherwise, fall
back to the old ioctl and display the v1 policy.

Also add new options:

  -1: Use the old ioctl only.  This will be used to test the old ioctl
      even when the kernel supports the new one.

  -t: Test whether the new ioctl is supported.  This will be useful to
      determine whether v2 policies should be tested or not.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c      | 150 +++++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_io.8 |  15 ++++-
 2 files changed, 147 insertions(+), 18 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index f5046e5b..b8141d96 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (c) 2016 Google, Inc.  All Rights Reserved.
+ * Copyright 2016, 2019 Google LLC
  * Author: Eric Biggers <ebiggers@google.com>
  */
 
@@ -139,6 +139,20 @@ struct fscrypt_get_key_status_arg {
 static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
 
+static void
+get_encpolicy_help(void)
+{
+	printf(_(
+"\n"
+" display the encryption policy of the current file\n"
+"\n"
+" -1 -- Use only the old ioctl to get the encryption policy.\n"
+"       This only works if the file has a v1 encryption policy.\n"
+" -t -- Test whether v2 encryption policies are supported.\n"
+"       Prints \"supported\", \"unsupported\", or an error message.\n"
+"\n"));
+}
+
 static void
 set_encpolicy_help(void)
 {
@@ -218,7 +232,7 @@ mode2str(__u8 mode)
 }
 
 static const char *
-keydesc2str(__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
+keydesc2str(const __u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
 {
 	static char buf[2 * FSCRYPT_KEY_DESCRIPTOR_SIZE + 1];
 	int i;
@@ -229,29 +243,131 @@ keydesc2str(__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE])
 	return buf;
 }
 
+static const char *
+keyid2str(const __u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE])
+{
+	static char buf[2 * FSCRYPT_KEY_IDENTIFIER_SIZE + 1];
+	int i;
+
+	for (i = 0; i < FSCRYPT_KEY_IDENTIFIER_SIZE; i++)
+		sprintf(&buf[2 * i], "%02x", master_key_identifier[i]);
+
+	return buf;
+}
+
+static void
+test_for_v2_policy_support(void)
+{
+	struct fscrypt_get_policy_ex_arg arg;
+
+	arg.policy_size = sizeof(arg.policy);
+
+	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY_EX, &arg) == 0 ||
+	    errno == ENODATA /* file unencrypted */) {
+		printf("supported\n");
+		return;
+	}
+	if (errno == ENOTTY) {
+		printf("unsupported\n");
+		return;
+	}
+	fprintf(stderr,
+		"%s: unexpected error checking for FS_IOC_GET_ENCRYPTION_POLICY_EX support: %s\n",
+		file->name, strerror(errno));
+	exitcode = 1;
+}
+
+static void
+show_v1_encryption_policy(const struct fscrypt_policy_v1 *policy)
+{
+	printf("Encryption policy for %s:\n", file->name);
+	printf("\tPolicy version: %u\n", policy->version);
+	printf("\tMaster key descriptor: %s\n",
+	       keydesc2str(policy->master_key_descriptor));
+	printf("\tContents encryption mode: %u (%s)\n",
+	       policy->contents_encryption_mode,
+	       mode2str(policy->contents_encryption_mode));
+	printf("\tFilenames encryption mode: %u (%s)\n",
+	       policy->filenames_encryption_mode,
+	       mode2str(policy->filenames_encryption_mode));
+	printf("\tFlags: 0x%02x\n", policy->flags);
+}
+
+static void
+show_v2_encryption_policy(const struct fscrypt_policy_v2 *policy)
+{
+	printf("Encryption policy for %s:\n", file->name);
+	printf("\tPolicy version: %u\n", policy->version);
+	printf("\tMaster key identifier: %s\n",
+	       keyid2str(policy->master_key_identifier));
+	printf("\tContents encryption mode: %u (%s)\n",
+	       policy->contents_encryption_mode,
+	       mode2str(policy->contents_encryption_mode));
+	printf("\tFilenames encryption mode: %u (%s)\n",
+	       policy->filenames_encryption_mode,
+	       mode2str(policy->filenames_encryption_mode));
+	printf("\tFlags: 0x%02x\n", policy->flags);
+}
+
 static int
 get_encpolicy_f(int argc, char **argv)
 {
-	struct fscrypt_policy policy;
+	int c;
+	struct fscrypt_get_policy_ex_arg arg;
+	bool only_use_v1_ioctl = false;
+	int res;
 
-	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY, &policy) < 0) {
+	while ((c = getopt(argc, argv, "1t")) != EOF) {
+		switch (c) {
+		case '1':
+			only_use_v1_ioctl = true;
+			break;
+		case 't':
+			test_for_v2_policy_support();
+			return 0;
+		default:
+			return command_usage(&get_encpolicy_cmd);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc != 0)
+		return command_usage(&get_encpolicy_cmd);
+
+	/* first try the new ioctl */
+	if (only_use_v1_ioctl) {
+		res = -1;
+		errno = ENOTTY;
+	} else {
+		arg.policy_size = sizeof(arg.policy);
+		res = ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY_EX, &arg);
+	}
+
+	/* fall back to the old ioctl */
+	if (res != 0 && errno == ENOTTY)
+		res = ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY,
+			    &arg.policy.v1);
+
+	if (res != 0) {
 		fprintf(stderr, "%s: failed to get encryption policy: %s\n",
 			file->name, strerror(errno));
 		exitcode = 1;
 		return 0;
 	}
 
-	printf("Encryption policy for %s:\n", file->name);
-	printf("\tPolicy version: %u\n", policy.version);
-	printf("\tMaster key descriptor: %s\n",
-	       keydesc2str(policy.master_key_descriptor));
-	printf("\tContents encryption mode: %u (%s)\n",
-	       policy.contents_encryption_mode,
-	       mode2str(policy.contents_encryption_mode));
-	printf("\tFilenames encryption mode: %u (%s)\n",
-	       policy.filenames_encryption_mode,
-	       mode2str(policy.filenames_encryption_mode));
-	printf("\tFlags: 0x%02x\n", policy.flags);
+	switch (arg.policy.version) {
+	case FSCRYPT_POLICY_V1:
+		show_v1_encryption_policy(&arg.policy.v1);
+		break;
+	case FSCRYPT_POLICY_V2:
+		show_v2_encryption_policy(&arg.policy.v2);
+		break;
+	default:
+		printf("Encryption policy for %s:\n", file->name);
+		printf("\tPolicy version: %u (unknown)\n", arg.policy.version);
+		break;
+	}
 	return 0;
 }
 
@@ -351,11 +467,13 @@ encrypt_init(void)
 {
 	get_encpolicy_cmd.name = "get_encpolicy";
 	get_encpolicy_cmd.cfunc = get_encpolicy_f;
+	get_encpolicy_cmd.args = _("[-1] [-t]");
 	get_encpolicy_cmd.argmin = 0;
-	get_encpolicy_cmd.argmax = 0;
+	get_encpolicy_cmd.argmax = -1;
 	get_encpolicy_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	get_encpolicy_cmd.oneline =
 		_("display the encryption policy of the current file");
+	get_encpolicy_cmd.help = get_encpolicy_help;
 
 	set_encpolicy_cmd.name = "set_encpolicy";
 	set_encpolicy_cmd.cfunc = set_encpolicy_f;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6e064bdd..3dd34a0c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -724,10 +724,21 @@ version of policy structure (numeric)
 .RE
 .PD
 .TP
-.BR get_encpolicy
+.BI "get_encpolicy [ \-1 ] [ \-t ]"
 On filesystems that support encryption, display the encryption policy of the
 current file.
-
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.BI \-1
+Use only the old ioctl to get the encryption policy.  This only works if the
+file has a v1 encryption policy.
+.TP
+.BI \-t
+Test whether v2 encryption policies are supported.  Prints "supported",
+"unsupported", or an error message.
+.RE
+.PD
 .TP
 .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
 List extended inode flags on the currently open file. If the
-- 
2.23.0.351.gc4317032e6-goog

