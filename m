Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8F50057D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Apr 2022 07:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiDNFgy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Apr 2022 01:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiDNFgx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Apr 2022 01:36:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF79128E13;
        Wed, 13 Apr 2022 22:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5057EB827CE;
        Thu, 14 Apr 2022 05:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFABC385A1;
        Thu, 14 Apr 2022 05:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649914466;
        bh=wHbFG3DggZ5vxAeshgXbgApNdQmT+w1qK86JQDvki8E=;
        h=From:To:Cc:Subject:Date:From;
        b=fHniNMHUCqyzPkzAsSGFbtjmt6AjfV14lpNnO97SL1jR349g/X0gEpW/z11V6Sl/w
         ZVQp4EWGIFDMLMEKxR8PKB182HFzETU+w5CJA+B3L9eF39VR6PSLwcI0xkCZfij45d
         043nWiH4sdCuL6LOsGlI+YnhuwZXPFxOV87EFACKHwaN1R+jBo96JAnxhQTug0nLGO
         /7dgWqE5NdtYSyGK1eCwfMfyvXXRrhkGC93S00GUyPzDLpmybfeDAQOP62oxcamx2g
         gKa3xHucGV/ub9ESxIKFhL5LItIrQImq+W7vAYOdlGE1Hl4g+iDXhz2C0OpwaOtZTi
         ge7kYdo7qebAA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] fscrypt: log when starting to use inline encryption
Date:   Wed, 13 Apr 2022 22:34:15 -0700
Message-Id: <20220414053415.158986-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When inline encryption is used, the usual message "fscrypt: AES-256-XTS
using implementation <impl>" doesn't appear in the kernel log.  Add a
similar message for the blk-crypto case that indicates that inline
encryption was used, and whether blk-crypto-fallback was used or not.
This can be useful for debugging performance problems.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  4 +++-
 fs/crypto/inline_crypt.c    | 33 ++++++++++++++++++++++++++++++++-
 fs/crypto/keysetup.c        |  2 +-
 3 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5b0a9e6478b5d..33f08f1b1974e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -561,7 +561,9 @@ struct fscrypt_mode {
 	int keysize;		/* key size in bytes */
 	int security_strength;	/* security strength in bytes */
 	int ivsize;		/* IV size in bytes */
-	int logged_impl_name;
+	int logged_cryptoapi_impl;
+	int logged_blk_crypto_native;
+	int logged_blk_crypto_fallback;
 	enum blk_crypto_mode_num blk_crypto_mode;
 };
 
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 93c2ca8580923..90f3e68f166e3 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -12,7 +12,7 @@
  * provides the key and IV to use.
  */
 
-#include <linux/blk-crypto.h>
+#include <linux/blk-crypto-profile.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
 #include <linux/sched/mm.h>
@@ -64,6 +64,35 @@ static unsigned int fscrypt_get_dun_bytes(const struct fscrypt_info *ci)
 	return DIV_ROUND_UP(lblk_bits, 8);
 }
 
+/*
+ * Log a message when starting to use blk-crypto (native) or blk-crypto-fallback
+ * for an encryption mode for the first time.  This is the blk-crypto
+ * counterpart to the message logged when starting to use the crypto API for the
+ * first time.  A limitation is that these messages don't convey which specific
+ * filesystems or files are using each implementation.  However, *usually*
+ * systems use just one implementation per mode, which makes these messages
+ * helpful for debugging problems where the "wrong" implementation is used.
+ */
+static void fscrypt_log_blk_crypto_impl(struct fscrypt_mode *mode,
+					struct request_queue **devs,
+					int num_devs,
+					const struct blk_crypto_config *cfg)
+{
+	int i;
+
+	for (i = 0; i < num_devs; i++) {
+		if (!IS_ENABLED(CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK) ||
+		    __blk_crypto_cfg_supported(devs[i]->crypto_profile, cfg)) {
+			if (!xchg(&mode->logged_blk_crypto_native, 1))
+				pr_info("fscrypt: %s using blk-crypto (native)\n",
+					mode->friendly_name);
+		} else if (!xchg(&mode->logged_blk_crypto_fallback, 1)) {
+			pr_info("fscrypt: %s using blk-crypto-fallback\n",
+				mode->friendly_name);
+		}
+	}
+}
+
 /* Enable inline encryption for this file if supported. */
 int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 {
@@ -117,6 +146,8 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 			goto out_free_devs;
 	}
 
+	fscrypt_log_blk_crypto_impl(ci->ci_mode, devs, num_devs, &crypto_cfg);
+
 	ci->ci_inlinecrypt = true;
 out_free_devs:
 	kfree(devs);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index eede186b04ce3..6b509af13e0da 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -94,7 +94,7 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			    mode->cipher_str, PTR_ERR(tfm));
 		return tfm;
 	}
-	if (!xchg(&mode->logged_impl_name, 1)) {
+	if (!xchg(&mode->logged_cryptoapi_impl, 1)) {
 		/*
 		 * fscrypt performance can vary greatly depending on which
 		 * crypto algorithm implementation is used.  Help people debug

base-commit: 63cec1389e116ae0e2a15e612a5b49651e04be3f
-- 
2.35.1

