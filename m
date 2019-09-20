Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 977FBB8879
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394377AbfITAUL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391427AbfITAUL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:11 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0F62196E;
        Fri, 20 Sep 2019 00:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938804;
        bh=f+B/RSp3cHGDYSRj0llx5Zvc9oiIdBeOdX+KbI0CfEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AyH8FhtoEjbXd0xfKORt45SGfnNTlsyfcMhgmh5jHBWuH0H+GK2rG/pciVy8tJMov
         cyIGWV8si3SgbDRiI8He3NRMmR5bXTqYpg7+/uTv1uFBqO/awyMu4JBA2CPi+AH8yu
         SIhHZKMWnM+H/EVKqJ7IlFXXClQrIgAUFgduSCdo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 6/8] xfs_io/encrypt: add 'add_enckey' command
Date:   Thu, 19 Sep 2019 17:18:20 -0700
Message-Id: <20190920001822.257411-7-ebiggers@kernel.org>
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

Add an 'add_enckey' command to xfs_io, to provide a command-line
interface to the FS_IOC_ADD_ENCRYPTION_KEY ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c      | 109 ++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |  15 +++++++
 2 files changed, 124 insertions(+)

diff --git a/io/encrypt.c b/io/encrypt.c
index 7d061c51..d38ac595 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -138,6 +138,7 @@ struct fscrypt_get_key_status_arg {
 
 static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
+static cmdinfo_t add_enckey_cmd;
 
 static void
 get_encpolicy_help(void)
@@ -183,6 +184,22 @@ set_encpolicy_help(void)
 "\n"));
 }
 
+static void
+add_enckey_help(void)
+{
+	printf(_(
+"\n"
+" add an encryption key to the filesystem\n"
+"\n"
+" Examples:\n"
+" 'add_enckey' - add key for v2 policies\n"
+" 'add_enckey -d 0000111122223333' - add key for v1 policies w/ given descriptor\n"
+"\n"
+"The key in binary is read from standard input.\n"
+" -d DESCRIPTOR -- master_key_descriptor\n"
+"\n"));
+}
+
 static const struct {
 	__u8 mode;
 	const char *name;
@@ -594,6 +611,88 @@ set_encpolicy_f(int argc, char **argv)
 	return 0;
 }
 
+static ssize_t
+read_until_limit_or_eof(int fd, void *buf, size_t limit)
+{
+	size_t bytes_read = 0;
+	ssize_t res;
+
+	while (limit) {
+		res = read(fd, buf, limit);
+		if (res < 0)
+			return res;
+		if (res == 0)
+			break;
+		buf += res;
+		bytes_read += res;
+		limit -= res;
+	}
+	return bytes_read;
+}
+
+static int
+add_enckey_f(int argc, char **argv)
+{
+	int c;
+	struct fscrypt_add_key_arg *arg;
+	ssize_t raw_size;
+
+	arg = calloc(1, sizeof(*arg) + FSCRYPT_MAX_KEY_SIZE + 1);
+	if (!arg) {
+		fprintf(stderr, "calloc failed\n");
+		exitcode = 1;
+		return 0;
+	}
+
+	arg->key_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+
+	while ((c = getopt(argc, argv, "d:")) != EOF) {
+		switch (c) {
+		case 'd':
+			arg->key_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
+			if (!str2keydesc(optarg, arg->key_spec.u.descriptor))
+				goto out;
+			break;
+		default:
+			return command_usage(&add_enckey_cmd);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc != 0)
+		return command_usage(&add_enckey_cmd);
+
+	raw_size = read_until_limit_or_eof(STDIN_FILENO, arg->raw,
+					   FSCRYPT_MAX_KEY_SIZE + 1);
+	if (raw_size < 0) {
+		fprintf(stderr, "Error reading key from stdin: %s\n",
+			strerror(errno));
+		exitcode = 1;
+		goto out;
+	}
+	if (raw_size > FSCRYPT_MAX_KEY_SIZE) {
+		fprintf(stderr,
+			"Invalid key; got > FSCRYPT_MAX_KEY_SIZE (%d) bytes on stdin!\n",
+			FSCRYPT_MAX_KEY_SIZE);
+		goto out;
+	}
+	arg->raw_size = raw_size;
+
+	if (ioctl(file->fd, FS_IOC_ADD_ENCRYPTION_KEY, arg) != 0) {
+		fprintf(stderr, "Error adding encryption key: %s\n",
+			strerror(errno));
+		exitcode = 1;
+		goto out;
+	}
+	printf("Added encryption key with %s %s\n",
+	       keyspectype(&arg->key_spec), keyspec2str(&arg->key_spec));
+out:
+	memset(arg->raw, 0, FSCRYPT_MAX_KEY_SIZE + 1);
+	free(arg);
+	return 0;
+}
+
 void
 encrypt_init(void)
 {
@@ -618,6 +717,16 @@ encrypt_init(void)
 		_("assign an encryption policy to the current file");
 	set_encpolicy_cmd.help = set_encpolicy_help;
 
+	add_enckey_cmd.name = "add_enckey";
+	add_enckey_cmd.cfunc = add_enckey_f;
+	add_enckey_cmd.args = _("[-d descriptor]");
+	add_enckey_cmd.argmin = 0;
+	add_enckey_cmd.argmax = -1;
+	add_enckey_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	add_enckey_cmd.oneline = _("add an encryption key to the filesystem");
+	add_enckey_cmd.help = add_enckey_help;
+
 	add_command(&get_encpolicy_cmd);
 	add_command(&set_encpolicy_cmd);
+	add_command(&add_enckey_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 18fcde0f..7d6a23fe 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -749,6 +749,21 @@ Test whether v2 encryption policies are supported.  Prints "supported",
 .RE
 .PD
 .TP
+.BI "add_enckey [ \-d " descriptor " ]"
+On filesystems that support encryption, add an encryption key to the filesystem
+containing the currently open file.  The key in binary (typically 64 bytes long)
+is read from standard input.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.BI \-d " descriptor"
+key descriptor, as a 16-character hex string (8 bytes).  If given, the key will
+be available for use by v1 encryption policies that use this descriptor.
+Otherwise, the key is added as a v2 policy key, and on success the resulting
+"key identifier" will be printed.
+.RE
+.PD
+.TP
 .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
 List extended inode flags on the currently open file. If the
 .B \-R
-- 
2.23.0.351.gc4317032e6-goog

