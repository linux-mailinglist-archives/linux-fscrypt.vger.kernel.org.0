Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513885D49C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2019 18:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGBQsh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 2 Jul 2019 12:48:37 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:35519 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfGBQsg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 2 Jul 2019 12:48:36 -0400
Received: by mail-lf1-f41.google.com with SMTP id p197so1524105lfa.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 02 Jul 2019 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=kGbzR475Fk1fnv5DaMFggiI54T2jNgT0VfoTwrbGvLoGWXuBb84+6vXzgRGOv3lHD3
         pFnmstTbfqpQ3r+5GGapEUM/AFpcxk1qkqCeD/hYJeQv1nXCsioGDiiz3vB+0qwkUf+x
         ymm9GqdyrQz69UDZoUR/o3Lg3cqzx2dd6s5sOcugMOF2FGSh7IWDv75ds/N4sd+iDJEq
         7Fd6DawFuubuNNR5DGCqGtRSre8yWN6EkF8UYPrGv0+ShfCwt2iUIDRn3/5YMvTHaUAf
         BueHb4O6F8TB4SWbLJtd55hq0gO6UOPrvWy3MG9jktf1tU9K5nqa5QkeFwkQWcwbLY9v
         bUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=XyNL7CoxiA/dLhmDF8BCv1VEgG+JaJUpfg2QKtUYabgr4MdHXw2RlrmoOrz5h6oqpz
         qGeDEnhS7ZUAXFOZOeUwswA3LsApMLoOjbalqZHqFds/SLOcQ0/3l94uLyh0W0HBhv/V
         K6H+Q0VyBc/0QTc2RYBd6Z8SwXFPcPUlcyMZbWS04n1tIgLoE0deGy4sxUScPgauQwFH
         lpBMGeM1I3xb6OzfS8eFlV6uVVnRbO3baeiJFqaoIOpLdE20PkX00h+OOjmBk1X9sCSx
         vkHtI+YePWqUu1Ksv+p/IfKds0+4asSSPZbBvtV0cb5C79NyZsJAS60PCOvKLBSubb4n
         0Sxw==
X-Gm-Message-State: APjAAAUgvuCoiN9+akwIgj1/yhIjRtiF///vaNWgG9l8nNaxO3t9q8z5
        g1asN03r2Dy5eQzWbs4b0MOEZQ==
X-Google-Smtp-Source: APXvYqxvEwu5ZUm3B0pwXGdK64Ks8SPUEVibo6YB2I56UF8Y/EAl21aBD/lQ9kQOnyQ9cDW+o6pjuw==
X-Received: by 2002:a19:41cc:: with SMTP id o195mr13813141lfa.166.1562086113634;
        Tue, 02 Jul 2019 09:48:33 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id r17sm3906055ljc.85.2019.07.02.09.48.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 09:48:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v7 3/7] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Tue,  2 Jul 2019 18:48:11 +0200
Message-Id: <20190702164815.6341-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702164815.6341-1-ard.biesheuvel@linaro.org>
References: <20190702164815.6341-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Instead of allocating a crypto skcipher tfm 'foo' and attempting to
infer the encapsulated block cipher from the driver's 'name' field,
directly parse the string that we used to allocated the tfm. These
are always identical (unless the allocation failed, in which case
we bail anyway), but using the string allows us to use it in the
allocation, which is something we will need when switching to the
'essiv' crypto API template.

Reviewed-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 41 +++++++++-----------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..3c17d588f6db 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2321,25 +2321,17 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
  * The cc->cipher is currently used only in ESSIV.
  * This should be probably done by crypto-api calls (once available...)
  */
-static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
+static int crypt_ctr_blkdev_cipher(struct crypt_config *cc, char *alg_name)
 {
-	const char *alg_name = NULL;
 	char *start, *end;
 
 	if (crypt_integrity_aead(cc)) {
-		alg_name = crypto_tfm_alg_name(crypto_aead_tfm(any_tfm_aead(cc)));
-		if (!alg_name)
-			return -EINVAL;
 		if (crypt_integrity_hmac(cc)) {
 			alg_name = strchr(alg_name, ',');
 			if (!alg_name)
 				return -EINVAL;
 		}
 		alg_name++;
-	} else {
-		alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
-		if (!alg_name)
-			return -EINVAL;
 	}
 
 	start = strchr(alg_name, '(');
@@ -2434,32 +2426,35 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
 
-	cc->key_parts = cc->tfms_count;
-
-	/* Allocate cipher */
-	ret = crypt_alloc_tfms(cc, cipher_api);
-	if (ret < 0) {
-		ti->error = "Error allocating crypto tfm";
-		return ret;
-	}
-
 	/* Alloc AEAD, can be used only in new format. */
 	if (crypt_integrity_aead(cc)) {
 		ret = crypt_ctr_auth_cipher(cc, cipher_api);
 		if (ret < 0) {
 			ti->error = "Invalid AEAD cipher spec";
 			return -ENOMEM;
-		}
-		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
-	} else
-		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+	       }
+	}
 
-	ret = crypt_ctr_blkdev_cipher(cc);
+	ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Cannot allocate cipher string";
 		return -ENOMEM;
 	}
 
+	cc->key_parts = cc->tfms_count;
+
+	/* Allocate cipher */
+	ret = crypt_alloc_tfms(cc, cipher_api);
+	if (ret < 0) {
+		ti->error = "Error allocating crypto tfm";
+		return ret;
+	}
+
+	if (crypt_integrity_aead(cc))
+		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
+	else
+		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+
 	return 0;
 }
 
-- 
2.17.1

