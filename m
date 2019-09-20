Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E6BB8878
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394380AbfITAUM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394379AbfITAUM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:12 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 659CC21A49;
        Fri, 20 Sep 2019 00:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938804;
        bh=15s3hwrzkVFeRRfqhw+wOdxUkp/3LCHzjvI+wPq9t9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9Nl/Eq1fOFtro0/3Flp487IHI1XPL38+AWEwOcGlLpUYiB0sKu2vOi6wdlAstlY3
         edPjRG5/vjqY4lf1edQAwWOtwOIrbDf8M4IeYvntK3MjPoFds5GbQPhQMYZrQ6gayg
         A2kj4hHQ97TDsuB4BjVDY5yaGSsLWenMwgIMgMmg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 8/8] xfs_io/encrypt: add 'enckey_status' command
Date:   Thu, 19 Sep 2019 17:18:22 -0700
Message-Id: <20190920001822.257411-9-ebiggers@kernel.org>
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

Add an 'enckey_status' command to xfs_io, to provide a command-line
interface to the FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c      | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |  6 ++++
 2 files changed, 77 insertions(+)

diff --git a/io/encrypt.c b/io/encrypt.c
index 7531c4ad..426040e9 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -140,6 +140,7 @@ static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
 static cmdinfo_t add_enckey_cmd;
 static cmdinfo_t rm_enckey_cmd;
+static cmdinfo_t enckey_status_cmd;
 
 static void
 get_encpolicy_help(void)
@@ -216,6 +217,19 @@ rm_enckey_help(void)
 "\n"));
 }
 
+static void
+enckey_status_help(void)
+{
+	printf(_(
+"\n"
+" get the status of a filesystem encryption key\n"
+"\n"
+" Examples:\n"
+" 'enckey_status 0000111122223333' - get status of v1 policy key\n"
+" 'enckey_status 00001111222233334444555566667777' - get status of v2 policy key\n"
+"\n"));
+}
+
 static const struct {
 	__u8 mode;
 	const char *name;
@@ -757,6 +771,52 @@ rm_enckey_f(int argc, char **argv)
 	return 0;
 }
 
+static int
+enckey_status_f(int argc, char **argv)
+{
+	struct fscrypt_get_key_status_arg arg;
+
+	memset(&arg, 0, sizeof(arg));
+
+	if (str2keyspec(argv[1], -1, &arg.key_spec) < 0)
+		return 0;
+
+	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_KEY_STATUS, &arg) != 0) {
+		fprintf(stderr, "Error getting encryption key status: %s\n",
+			strerror(errno));
+		exitcode = 1;
+		return 0;
+	}
+
+	switch (arg.status) {
+	case FSCRYPT_KEY_STATUS_PRESENT:
+		printf("Present");
+		if (arg.user_count || arg.status_flags) {
+			printf(" (user_count=%u", arg.user_count);
+			if (arg.status_flags &
+			    FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF)
+				printf(", added_by_self");
+			arg.status_flags &=
+				~FSCRYPT_KEY_STATUS_FLAG_ADDED_BY_SELF;
+			if (arg.status_flags)
+				printf(", unknown_flags=0x%08x",
+				       arg.status_flags);
+			printf(")");
+		}
+		printf("\n");
+		return 0;
+	case FSCRYPT_KEY_STATUS_ABSENT:
+		printf("Absent\n");
+		return 0;
+	case FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED:
+		printf("Incompletely removed\n");
+		return 0;
+	default:
+		printf("Unknown status (%u)\n", arg.status);
+		return 0;
+	}
+}
+
 void
 encrypt_init(void)
 {
@@ -800,8 +860,19 @@ encrypt_init(void)
 		_("remove an encryption key from the filesystem");
 	rm_enckey_cmd.help = rm_enckey_help;
 
+	enckey_status_cmd.name = "enckey_status";
+	enckey_status_cmd.cfunc = enckey_status_f;
+	enckey_status_cmd.args = _("keyspec");
+	enckey_status_cmd.argmin = 1;
+	enckey_status_cmd.argmax = 1;
+	enckey_status_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	enckey_status_cmd.oneline =
+		_("get the status of a filesystem encryption key");
+	enckey_status_cmd.help = enckey_status_help;
+
 	add_command(&get_encpolicy_cmd);
 	add_command(&set_encpolicy_cmd);
 	add_command(&add_enckey_cmd);
 	add_command(&rm_enckey_cmd);
+	add_command(&enckey_status_cmd);
 }
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index a6894778..9af6e542 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -779,6 +779,12 @@ is a privileged operation.
 .RE
 .PD
 .TP
+.BI "enckey_status " keyspec
+On filesystems that support encryption, display the status of an encryption key.
+.I keyspec
+is a hex string specifying the key for which to display the status, as a
+16-character "key descriptor" or a 32-character "key identifier".
+.TP
 .BR lsattr " [ " \-R " | " \-D " | " \-a " | " \-v " ]"
 List extended inode flags on the currently open file. If the
 .B \-R
-- 
2.23.0.351.gc4317032e6-goog

