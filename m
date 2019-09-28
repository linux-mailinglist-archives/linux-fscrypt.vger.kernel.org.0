Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520A5C0ED3
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Sep 2019 02:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbfI1ADp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Sep 2019 20:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfI1ADo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Sep 2019 20:03:44 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2690720869;
        Sat, 28 Sep 2019 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569629024;
        bh=FVW8c7dxtnnfeeRELqBdj69UriRU9Me3FZsaq5q0jjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgqF54/gBEz6y4Ojtwz9uIR2dAvDyQ3BhOQtPx6WrRCETl2yd4Iu3Kzneyw9mSWAc
         8tfQWfL1VuPV5GsxmhyPDTWEzs8VATi9YR8XydV3hG4FtJeamwxSB8L1BVc3dBphrG
         dHR0rApxxa3pFgmKUBQyCcd/18DhkxqmY7W8IHBI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 1/9] xfs_io/encrypt: remove unimplemented encryption modes
Date:   Fri, 27 Sep 2019 17:02:35 -0700
Message-Id: <20190928000243.77634-2-ebiggers@kernel.org>
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

Although mode numbers were originally reserved for AES-256-GCM and
AES-256-CBC, these were never implemented in the kernel, and there are
no plans to do so anymore.  These mode numbers may be used for something
else in the future.  Also, xfstests (the only known user of the xfs_io
encryption commands) doesn't try to use them.  Finally, most of the
fscrypt constants have been given new names in the UAPI header, but the
unused constants have not been given new names since userspace should
just stop referencing them instead.

So remove them from xfs_io.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 io/encrypt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/io/encrypt.c b/io/encrypt.c
index 7a0b2465..70c9e5eb 100644
--- a/io/encrypt.c
+++ b/io/encrypt.c
@@ -49,8 +49,6 @@ struct fscrypt_policy {
 
 #define FS_ENCRYPTION_MODE_INVALID	0
 #define FS_ENCRYPTION_MODE_AES_256_XTS	1
-#define FS_ENCRYPTION_MODE_AES_256_GCM	2
-#define FS_ENCRYPTION_MODE_AES_256_CBC	3
 #define FS_ENCRYPTION_MODE_AES_256_CTS	4
 #endif /* FS_ENCRYPTION_MODE_AES_256_XTS */
 
@@ -74,7 +72,7 @@ set_encpolicy_help(void)
 " -v VERSION -- version of policy structure\n"
 "\n"
 " MODE can be numeric or one of the following predefined values:\n"
-"    AES-256-XTS, AES-256-CTS, AES-256-GCM, AES-256-CBC\n"
+"    AES-256-XTS, AES-256-CTS\n"
 " FLAGS and VERSION must be numeric.\n"
 "\n"
 " Note that it's only possible to set an encryption policy on an empty\n"
@@ -88,8 +86,6 @@ static const struct {
 } available_modes[] = {
 	{FS_ENCRYPTION_MODE_AES_256_XTS, "AES-256-XTS"},
 	{FS_ENCRYPTION_MODE_AES_256_CTS, "AES-256-CTS"},
-	{FS_ENCRYPTION_MODE_AES_256_GCM, "AES-256-GCM"},
-	{FS_ENCRYPTION_MODE_AES_256_CBC, "AES-256-CBC"},
 };
 
 static bool
-- 
2.23.0.444.g18eeb5a265-goog

