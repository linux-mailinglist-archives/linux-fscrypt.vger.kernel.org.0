Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7989927F6A2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Oct 2020 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgJAAZc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731944AbgJAAZc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B09A42137B;
        Thu,  1 Oct 2020 00:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511931;
        bh=AGubCD10XBlKo8JYnXqWoiKHjQL8sCZMhLNdjEghw3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/om2tj8UavJ78dCqglF8OixStJc8ig0iCPkyQq6b9qWcaF/gzzvhGAIpyCY5v5hd
         TYiEyOIzHTqjBz3re7L2XK11O6P+bvyhhfyiLckgFaqHZ71u1kV/saLp1mD9eD++ix
         zEYTocaQZ+YcRuy9Qq+ZwUuiGwJ0I+p/xhGzqi0c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daeho43@gmail.com>
Subject: [PATCH 3/5] fscrypt-crypt-util: add --block-number option
Date:   Wed, 30 Sep 2020 17:25:05 -0700
Message-Id: <20201001002508.328866-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001002508.328866-1-ebiggers@kernel.org>
References: <20201001002508.328866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Currently fscrypt-crypt-util assumes that the number of the first block
encrypted/decrypted is 0.  I.e., it replicates either contents
encryption from the start of a file, or encryption of a filename.

However, to easily test compression+encryption on f2fs, we need the
ability to specify a different starting block number.

Add a --block-number option which does this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 5c065116..26698d7a 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -59,6 +59,8 @@ static void usage(FILE *fp)
 "WARNING: this program is only meant for testing, not for \"real\" use!\n"
 "\n"
 "Options:\n"
+"  --block-number=BNUM         Starting block number for IV generation.\n"
+"                                Default: 0\n"
 "  --block-size=BLOCK_SIZE     Encrypt each BLOCK_SIZE bytes independently.\n"
 "                                Default: 4096 bytes\n"
 "  --decrypt                   Decrypt instead of encrypt\n"
@@ -1787,6 +1789,7 @@ struct key_and_iv_params {
 	bool file_nonce_specified;
 	bool iv_ino_lblk_64;
 	bool iv_ino_lblk_32;
+	u64 block_number;
 	u64 inode_number;
 	u8 fs_uuid[UUID_SIZE];
 	bool fs_uuid_specified;
@@ -1839,6 +1842,9 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 
 	memset(iv, 0, sizeof(*iv));
 
+	/* Overridden later for iv_ino_lblk_{64,32} */
+	iv->block_number = cpu_to_le64(params->block_number);
+
 	if (params->iv_ino_lblk_64 || params->iv_ino_lblk_32) {
 		const char *opt = params->iv_ino_lblk_64 ? "--iv-ino-lblk-64" :
 							   "--iv-ino-lblk-32";
@@ -1852,6 +1858,8 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			die("%s requires --inode-number", opt);
 		if (params->mode_num == 0)
 			die("%s requires --mode-num", opt);
+		if (params->block_number > UINT32_MAX)
+			die("%s can't use --block-number > UINT32_MAX", opt);
 		if (params->inode_number > UINT32_MAX)
 			die("%s can't use --inode-number > UINT32_MAX", opt);
 	}
@@ -1881,6 +1889,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			info[infolen++] = params->mode_num;
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
+			iv->block_number32 = cpu_to_le32(params->block_number);
 			iv->inode_number = cpu_to_le32(params->inode_number);
 		} else if (params->iv_ino_lblk_32) {
 			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
@@ -1888,7 +1897,9 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
 			infolen += UUID_SIZE;
 			iv->block_number32 =
-				cpu_to_le32(hash_inode_number(params));
+				cpu_to_le32(hash_inode_number(params) +
+					    params->block_number);
+			iv->inode_number = 0;
 		} else if (params->mode_num != 0) {
 			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
 			info[infolen++] = params->mode_num;
@@ -1913,6 +1924,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 }
 
 enum {
+	OPT_BLOCK_NUMBER,
 	OPT_BLOCK_SIZE,
 	OPT_DECRYPT,
 	OPT_FILE_NONCE,
@@ -1927,6 +1939,7 @@ enum {
 };
 
 static const struct option longopts[] = {
+	{ "block-number",    required_argument, NULL, OPT_BLOCK_NUMBER },
 	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
@@ -1968,6 +1981,12 @@ int main(int argc, char *argv[])
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
 		switch (c) {
+		case OPT_BLOCK_NUMBER:
+			errno = 0;
+			params.block_number = strtoull(optarg, &tmp, 10);
+			if (*tmp || errno)
+				die("Invalid block number: %s", optarg);
+			break;
 		case OPT_BLOCK_SIZE:
 			errno = 0;
 			block_size = strtoul(optarg, &tmp, 10);
-- 
2.28.0

