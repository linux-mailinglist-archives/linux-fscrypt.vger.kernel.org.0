Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110878A50A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfHLR5Q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbfHLR5Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E85A214C6;
        Mon, 12 Aug 2019 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632635;
        bh=0fFeTCkHHz7+HM4rgMp50Skdeei22QOwH1bnrl1K+9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6nwjjWYIiX28uEhnUwcSXQGmPd5nyo0RhV+xn9Sd/8L9WLwCsXqSqJmysPOM2oyA
         sGUCH7FhAngsXHJStjLz8zAqlXNLLTUGQtep1Zi6+AW5NnVX8ZSPdv6unWMIUj5vkg
         JoKzQmTsMRF1u0Ey01WJBZDcra1uRXhDwqlvRC1c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 7/8] xfs_io/encrypt: add 'rm_enckey' command
Date:   Mon, 12 Aug 2019 10:56:33 -0700
Message-Id: <20190812175635.34186-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175635.34186-1-ebiggers@kernel.org>
References: <20190812175635.34186-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a 'rm_enckey' command to xfs_io, to provide a command-line interface
to the FS_IOC_REMOVE_ENCRYPTION_KEY and
FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS ioctls.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c      | 75 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 | 15 ++++++++++
 2 files changed, 90 insertions(+)

diff --git a/io/encrypt.c b/io/encrypt.c
index 038c4cce..213c9c53 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -139,6 +139,7 @@ struct fscrypt_get_key_status_arg {
 static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
 static cmdinfo_t add_enckey_cmd;
+static cmdinfo_t rm_enckey_cmd;
 
 static void
 get_encpolicy_help(void)
@@ -200,6 +201,21 @@ add_enckey_help(void)
 "\n"));
 }
 
+static void
+rm_enckey_help(void)
+{
+	printf(_(
+"\n"
+" remove an encryption key from the filesystem\n"
+"\n"
+" Examples:\n"
+" 'rm_enckey 0000111122223333' - remove key for v1 policies w/ given descriptor\n"
+" 'rm_enckey 00001111222233334444555566667777' - remove key for v2 policies w/ given identifier\n"
+"\n"
+" -a -- remove key for all users who have added it (privileged operation)\n"
+"\n"));
+}
+
 static const struct {
 	__u8 mode;
 	const char *name;
@@ -693,6 +709,54 @@ out:
 	return 0;
 }
 
+static int
+rm_enckey_f(int argc, char **argv)
+{
+	int c;
+	struct fscrypt_remove_key_arg arg;
+	int ioc = FS_IOC_REMOVE_ENCRYPTION_KEY;
+
+	memset(&arg, 0, sizeof(arg));
+
+	while ((c = getopt(argc, argv, "a")) != EOF) {
+		switch (c) {
+		case 'a':
+			ioc = FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS;
+			break;
+		default:
+			return command_usage(&rm_enckey_cmd);
+		}
+	}
+	argc -= optind;
+	argv += optind;
+
+	if (argc != 1)
+		return command_usage(&rm_enckey_cmd);
+
+	if (str2keyspec(argv[0], -1, &arg.key_spec) < 0)
+		return 0;
+
+	if (ioctl(file->fd, ioc, &arg) != 0) {
+		fprintf(stderr, "Error removing encryption key: %s\n",
+			strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+	if (arg.removal_status_flags &
+	    FSCRYPT_KEY_REMOVAL_STATUS_FLAG_OTHER_USERS) {
+		printf("Removed user's claim to encryption key with %s %s\n",
+		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
+	} else if (arg.removal_status_flags &
+		   FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY) {
+		printf("Removed encryption key with %s %s, but files still busy\n",
+		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
+	} else {
+		printf("Removed encryption key with %s %s\n",
+		       keyspectype(&arg.key_spec), keyspec2str(&arg.key_spec));
+	}
+	return 0;
+}
+
 void
 encrypt_init(void)
 {
@@ -726,7 +790,18 @@ encrypt_init(void)
 	add_enckey_cmd.oneline = _("add an encryption key to the filesystem");
 	add_enckey_cmd.help = add_enckey_help;
 
+	rm_enckey_cmd.name = "rm_enckey";
+	rm_enckey_cmd.cfunc = rm_enckey_f;
+	rm_enckey_cmd.args = _("keyspec");
+	rm_enckey_cmd.argmin = 0;
+	rm_enckey_cmd.argmax = -1;
+	rm_enckey_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	rm_enckey_cmd.oneline =
+		_("remove an encryption key from the filesystem");
+	rm_enckey_cmd.help = rm_enckey_help;
+
 	add_command(&get_encpolicy_cmd);
 	add_command(&set_encpolicy_cmd);
 	add_command(&add_enckey_cmd);
+	add_command(&rm_enckey_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 7d6a23fe..a6894778 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -764,6 +764,21 @@ Otherwise, the key is added as a v2 policy key, and on success the resulting
 .RE
 .PD
 .TP
+.BI "rm_enckey " keyspec
+On filesystems that support encryption, remove an encryption key from the
+filesystem containing the currently open file.
+.I keyspec
+is a hex string specifying the key to remove, as a 16-character "key descriptor"
+or a 32-character "key identifier".
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.BI \-a
+Remove the key for all users who have added it, not just the current user.  This
+is a privileged operation.
+.RE
+.PD
+.TP
 .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
 List extended inode flags on the currently open file. If the
 .B \-R
-- 
2.23.0.rc1.153.gdeed80330f-goog

