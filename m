Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49DC0EE6
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Sep 2019 02:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfI1ADp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Sep 2019 20:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfI1ADp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Sep 2019 20:03:45 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1883217D9;
        Sat, 28 Sep 2019 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569629024;
        bh=3U5C9V4mtkfRFfuGPXOxRamHWW9N5CsHL6wyIeN+iHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExWdGS14nyGYod4uFoOLCCFVSavxkjQOYcBZl/u+NXgkB/DubphYgbjEmnL24Wuu4
         ckaTRBtvy8/u+5Xyx2/pcRAq8X8UNxb1fudLqzFSb3kV6KfLopbrGjrj/m+X+v6RLc
         yRI4Zee0ph6Oqgvnjq1KDEsKCNdDhJGQndYU5Pgw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 3/9] xfs_io/encrypt: generate encryption modes for 'help set_encpolicy'
Date:   Fri, 27 Sep 2019 17:02:37 -0700
Message-Id: <20190928000243.77634-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
In-Reply-To: <20190928000243.77634-1-ebiggers@kernel.org>
References: <20190928000243.77634-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Print all encryption modes that are defined in the code, rather than
hardcoding the modes in the help text.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 011a6410..7d3e3b73 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -136,12 +136,22 @@ struct fscrypt_get_key_status_arg {
 
 #endif /* !FS_IOC_GET_ENCRYPTION_POLICY_EX */
 
+static const struct {
+	__u8 mode;
+	const char *name;
+} available_modes[] = {
+	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
+	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
+};
+
 static cmdinfo_t get_encpolicy_cmd;
 static cmdinfo_t set_encpolicy_cmd;
 
 static void
 set_encpolicy_help(void)
 {
+	int i;
+
 	printf(_(
 "\n"
 " assign an encryption policy to the currently open file\n"
@@ -155,8 +165,15 @@ set_encpolicy_help(void)
 " -f FLAGS -- policy flags\n"
 " -v VERSION -- version of policy structure\n"
 "\n"
-" MODE can be numeric or one of the following predefined values:\n"
-"    AES-256-XTS, AES-256-CTS\n"
+" MODE can be numeric or one of the following predefined values:\n"));
+	printf("    ");
+	for (i = 0; i < ARRAY_SIZE(available_modes); i++) {
+		printf("%s", available_modes[i].name);
+		if (i != ARRAY_SIZE(available_modes) - 1)
+			printf(", ");
+	}
+	printf("\n");
+	printf(_(
 " FLAGS and VERSION must be numeric.\n"
 "\n"
 " Note that it's only possible to set an encryption policy on an empty\n"
@@ -164,14 +181,6 @@ set_encpolicy_help(void)
 "\n"));
 }
 
-static const struct {
-	__u8 mode;
-	const char *name;
-} available_modes[] = {
-	{FSCRYPT_MODE_AES_256_XTS, "AES-256-XTS"},
-	{FSCRYPT_MODE_AES_256_CTS, "AES-256-CTS"},
-};
-
 static bool
 parse_byte_value(const char *arg, __u8 *value_ret)
 {
-- 
2.23.0.444.g18eeb5a265-goog

