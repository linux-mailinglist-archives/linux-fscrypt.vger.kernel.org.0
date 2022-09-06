Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03755ADC6C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbiIFAfv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232486AbiIFAfs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:35:48 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B2967C97;
        Mon,  5 Sep 2022 17:35:47 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D0F468110B;
        Mon,  5 Sep 2022 20:35:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424547; bh=FHQb/jBsuApS00FJLWrCuzmPZJWToYiV0GtCBqAspI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmVKeEMxOk1Nwbh91WG58zWiiTQgXqdMJAtYOd/qvjJxA8aZhXz9L2VhhX7/B35D2
         hpY0/cRAExHs8m2nVO3Pc6UDfBIVTugaRqDte409nLwR3vmxjlk4ArpS7CbPN4+ZKc
         hsPPgjlkM1SRWxh/IcCIlfshSo82X71w99oKbu5ShNNcx7nCU4Gc38AR64rE4vu+UM
         dp8WjWjLEJl4B2/M8MGUJXs5BgBj3K6VOw144KQg54HqFIZ/QQ02ialCh2XTHUea6c
         bB/Gz0uU63DoY32ZikKVexj+7cM/84Lb0PT1nXvtiOZ6niHVYPIU0EFiTa0xA3invN
         zU5UIFIsI1XlA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 04/20] fscrypt: allow fscrypt_generate_iv() to distinguish filenames
Date:   Mon,  5 Sep 2022 20:35:19 -0400
Message-Id: <bc34486c30d3d0bfd5404358f7bd566d802748be.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

With the introduction of extent-based file content encryption, filenames
and file contents might no longer use the same IV generation scheme, and
so should not upass the same logical block number to
fscrypt_generate_iv(). In preparation, start passing U64_MAX as the
block number for filename IV generation, and make fscrypt_generate_iv()
translate this to 0 if extent-based encryption is not being used.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c | 9 ++++++++-
 fs/crypto/fname.c  | 4 ++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..7fe5979fbea2 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
 /*
  * Generate the IV for the given logical block number within the given file.
- * For filenames encryption, lblk_num == 0.
+ * For filenames encryption, lblk_num == U64_MAX.
  *
  * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
  * needs to know about any IV generation methods where the low bits of IV don't
@@ -84,6 +84,13 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 
 	memset(iv, 0, ci->ci_mode->ivsize);
 
+	/*
+	 * Filename encryption. For inode-based policies, filenames are
+	 * encrypted as though they are lblk 0.
+	 */
+	if (lblk_num == U64_MAX)
+		lblk_num = 0;
+
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 3bdece33e14d..16b64e0589e4 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -79,7 +79,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 	memset(out + iname->len, 0, olen - iname->len);
 
 	/* Initialize the IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, U64_MAX, ci);
 
 	/* Set up the encryption request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
@@ -134,7 +134,7 @@ static int fname_decrypt(const struct inode *inode,
 		crypto_req_done, &wait);
 
 	/* Initialize IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, U64_MAX, ci);
 
 	/* Create decryption request */
 	sg_init_one(&src_sg, iname->name, iname->len);
-- 
2.35.1

