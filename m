Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B94627F6A1
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Oct 2020 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgJAAZc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730258AbgJAAZb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 20:25:31 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2805420578;
        Thu,  1 Oct 2020 00:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511931;
        bh=/nNZ5RevJQaMc15vRjvv8jrBatzCUxzaN3jBuV22Zr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6m1Y03NmMKIk6azX9TyBZkc6TzIBTIdebrPSPYsg5sI3wKQo4jwXfJw+kUAH0eAD
         rPYOc9u75/qvgzpmhc3UQs62L6MJsh3tjJaVumqM9O9Ya84gGqxcThwywaNSGnMnBN
         3Ec82EHRpnE2YZyr60rUI0dwY3ytBEygxPbTMefs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daeho43@gmail.com>
Subject: [PATCH 1/5] fscrypt-crypt-util: clean up parsing --block-size and --inode-number
Date:   Wed, 30 Sep 2020 17:25:03 -0700
Message-Id: <20201001002508.328866-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001002508.328866-1-ebiggers@kernel.org>
References: <20201001002508.328866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For --block-size, check for strtoul() reporting an overflow.

For --inode-number, check for strtoull() reporting an overflow.

Also, move the check for 32-bit inode numbers into a more logical place
(the place where we check the encryption format-specific limitations).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index ce9da85d..d9189346 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <stdarg.h>
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -1756,18 +1757,6 @@ static u8 parse_mode_number(const char *arg)
 	return num;
 }
 
-static u32 parse_inode_number(const char *arg)
-{
-	char *tmp;
-	unsigned long long num = strtoull(arg, &tmp, 10);
-
-	if (num <= 0 || *tmp)
-		die("Invalid inode number: %s", arg);
-	if ((u32)num != num)
-		die("Inode number %s is too large; must be 32-bit", arg);
-	return num;
-}
-
 struct key_and_iv_params {
 	u8 master_key[MAX_KEY_SIZE];
 	int master_key_size;
@@ -1777,7 +1766,7 @@ struct key_and_iv_params {
 	bool file_nonce_specified;
 	bool iv_ino_lblk_64;
 	bool iv_ino_lblk_32;
-	u32 inode_number;
+	u64 inode_number;
 	u8 fs_uuid[UUID_SIZE];
 	bool fs_uuid_specified;
 };
@@ -1842,6 +1831,8 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			die("%s requires --inode-number", opt);
 		if (params->mode_num == 0)
 			die("%s requires --mode-num", opt);
+		if (params->inode_number > UINT32_MAX)
+			die("%s can't use --inode-number > UINT32_MAX", opt);
 	}
 
 	switch (params->kdf) {
@@ -1957,8 +1948,9 @@ int main(int argc, char *argv[])
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
 		case OPT_BLOCK_SIZE:
+			errno = 0;
 			block_size = strtoul(optarg, &tmp, 10);
-			if (block_size <= 0 || *tmp)
+			if (block_size <= 0 || *tmp || errno)
 				die("Invalid block size: %s", optarg);
 			break;
 		case OPT_DECRYPT:
@@ -1980,7 +1972,10 @@ int main(int argc, char *argv[])
 			usage(stdout);
 			return 0;
 		case OPT_INODE_NUMBER:
-			params.inode_number = parse_inode_number(optarg);
+			errno = 0;
+			params.inode_number = strtoull(optarg, &tmp, 10);
+			if (params.inode_number <= 0 || *tmp || errno)
+				die("Invalid inode number: %s", optarg);
 			break;
 		case OPT_IV_INO_LBLK_32:
 			params.iv_ino_lblk_32 = true;
-- 
2.28.0

