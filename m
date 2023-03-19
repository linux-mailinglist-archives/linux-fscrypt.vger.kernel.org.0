Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E576C0477
	for <lists+linux-fscrypt@lfdr.de>; Sun, 19 Mar 2023 20:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCSTjf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 19 Mar 2023 15:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjCSTja (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 19 Mar 2023 15:39:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574C3125AD;
        Sun, 19 Mar 2023 12:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56ABF61176;
        Sun, 19 Mar 2023 19:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B00C4339B;
        Sun, 19 Mar 2023 19:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679254743;
        bh=7Fq+zUNk8rLcgq8ldpUhuOpwwcT0yhPQ3w5BR7Tsj9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuRv4883nem2Ox4QLe65Byk3NVW5X6w6kceL7/SLO2zYFKttTd/m2JmhyBRhW97uj
         2Z7ZpeiPz+Eqt+/gbpu0IM756JZ/HvuOdOT0aaiuzHNhxvgVVVYosRiMZ7F1EAijMr
         NWvhRcfbabLMDTTmX7SnBL4aGD0dDUv846jGW/iFMdwnnPQkG/NLGPrq8U6n2pVoBu
         V7UznT6/w0XXlDMNW/gNCR07DPL+bnW6mx27LvpqeyEOGlyw5It+JwUIu2HRsfcTk6
         M+9QP9HTwOXHfpjZsnlwQCtT0NLOjSN5poFIqfOsvvgwZfsdeHPtOZPLr0q2SoklwY
         3bTqUsIGBhQEg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 2/3] fscrypt-crypt-util: use OpenSSL EVP API for AES self-tests
Date:   Sun, 19 Mar 2023 12:38:46 -0700
Message-Id: <20230319193847.106872-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230319193847.106872-1-ebiggers@kernel.org>
References: <20230319193847.106872-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

OpenSSL 3.0 has deprecated the easy-to-use AES block cipher API in favor
of EVP.  EVP is also available in earlier OpenSSL versions.  Therefore,
update test_aes_keysize() to use the non-deprecated API to avoid
deprecation warnings when building the algorithm self-tests.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 4bb4f4e5..040b80c0 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -662,19 +662,37 @@ static void aes_decrypt(const struct aes_key *k, const u8 src[AES_BLOCK_SIZE],
 }
 
 #ifdef ENABLE_ALG_TESTS
-#include <openssl/aes.h>
+#include <openssl/evp.h>
 static void test_aes_keysize(int keysize)
 {
 	unsigned long num_tests = NUM_ALG_TEST_ITERATIONS;
+	const EVP_CIPHER *evp_cipher;
+	EVP_CIPHER_CTX *ctx;
+
+	switch (keysize) {
+	case 16:
+		evp_cipher = EVP_aes_128_ecb();
+		break;
+	case 24:
+		evp_cipher = EVP_aes_192_ecb();
+		break;
+	case 32:
+		evp_cipher = EVP_aes_256_ecb();
+		break;
+	default:
+		ASSERT(0);
+	}
 
+	ctx = EVP_CIPHER_CTX_new();
+	ASSERT(ctx != NULL);
 	while (num_tests--) {
 		struct aes_key k;
-		AES_KEY ref_k;
 		u8 key[AES_256_KEY_SIZE];
 		u8 ptext[AES_BLOCK_SIZE];
 		u8 ctext[AES_BLOCK_SIZE];
 		u8 ref_ctext[AES_BLOCK_SIZE];
 		u8 decrypted[AES_BLOCK_SIZE];
+		int outl, res;
 
 		rand_bytes(key, keysize);
 		rand_bytes(ptext, AES_BLOCK_SIZE);
@@ -682,14 +700,18 @@ static void test_aes_keysize(int keysize)
 		aes_setkey(&k, key, keysize);
 		aes_encrypt(&k, ptext, ctext);
 
-		ASSERT(AES_set_encrypt_key(key, keysize*8, &ref_k) == 0);
-		AES_encrypt(ptext, ref_ctext, &ref_k);
-
+		res = EVP_EncryptInit_ex(ctx, evp_cipher, NULL, key, NULL);
+		ASSERT(res > 0);
+		res = EVP_EncryptUpdate(ctx, ref_ctext, &outl, ptext,
+					AES_BLOCK_SIZE);
+		ASSERT(res > 0);
+		ASSERT(outl == AES_BLOCK_SIZE);
 		ASSERT(memcmp(ctext, ref_ctext, AES_BLOCK_SIZE) == 0);
 
 		aes_decrypt(&k, ctext, decrypted);
 		ASSERT(memcmp(ptext, decrypted, AES_BLOCK_SIZE) == 0);
 	}
+	EVP_CIPHER_CTX_free(ctx);
 }
 
 static void test_aes(void)
-- 
2.40.0

