Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDBB5FCEA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Jul 2019 20:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfGDSar (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Jul 2019 14:30:47 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:33458 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfGDSar (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Jul 2019 14:30:47 -0400
Received: by mail-wr1-f42.google.com with SMTP id n9so7542976wru.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 04 Jul 2019 11:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=JCPKfk7ZExLY06Ns+/JxSMk3qpW7waz8rQbYKrVyVsI7deea8HckVyvq4YL3XFrUbC
         xtsO0mTEttwgKRZGcIPG1l3UARCxTePSEmP4tYU2y0aHI+vsaS0T8Pk0Ljqmo3VKmmGN
         k8BePG67m7sg2re2lqDgG2ZmMO9QKmdRu19P9bDZrCS0ZpfhdfJ4Ryr5FVfDL/w8kd9F
         6xXFaA/dwRo0RgkwouDkK8KLbmbCq3x0Jy311vMRrDG+HUgFySh36N6LO6xkVji4y05t
         E29IBsgq/HEdkIvNZK4EGM9Y1IUaQW35zd5evMQPPfU2guPp5ubuCBPc2bJuS6iR+vXa
         P/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HomCk1VsjwBWm0dP9ApxcCmxBO/okyV8Fp4po7N++dQ=;
        b=fOS2RHskSo6RPa6cym3Pzc/J1hRn1qOJIVqDHKWxuOdzfuYHYrN6A1lnZlb76zp98/
         2wAsy66E0iFWA22j8p5hUz4KwiFwUTm1U6BFOb9cC6Lxm9UJ8vPVoTOgSXyfRMlFPGIH
         6eLGZicsgqMribbIigvgLqGtIEyMgttkJRtvVJOACtqJvpMcvH5PKAqVoU/vQp+5dpD+
         ooCwHYFeenX9PcOq46dVmoAB+zZ7Mj2uSy7iIBykJJzd904U69/6WKirSlcHv3nqSGWS
         zG/aVxtx3AXec8MUkJ+5Ur5pOcXscOL2yp+OD1jsHxAmBqZ/laPXa/E2zzWR/1AkWh4Q
         RtCw==
X-Gm-Message-State: APjAAAUaYJO+kGDr/bj7PgPP7t73UY+L6U/R3Uo7nbp/raAMqqV5JT3W
        bbwucYg9k6qRq298Dsat1MZS6Q==
X-Google-Smtp-Source: APXvYqzq5Zds2jh431RjpslUcPSbnkuwn2SnCi51dyRaM8ylPkZ+ADGalrumBW7C+PPcVGKElno8NQ==
X-Received: by 2002:a5d:4403:: with SMTP id z3mr10882wrq.29.1562265045221;
        Thu, 04 Jul 2019 11:30:45 -0700 (PDT)
Received: from e111045-lin.arm.com (93-143-123-179.adsl.net.t-com.hr. [93.143.123.179])
        by smtp.gmail.com with ESMTPSA id o6sm11114695wra.27.2019.07.04.11.30.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 11:30:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v8 3/7] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Thu,  4 Jul 2019 20:30:13 +0200
Message-Id: <20190704183017.31570-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
References: <20190704183017.31570-1-ard.biesheuvel@linaro.org>
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

