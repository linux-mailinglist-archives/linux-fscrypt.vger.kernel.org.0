Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5831572B4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jun 2019 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFZUk5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Jun 2019 16:40:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42163 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfFZUk5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Jun 2019 16:40:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so4249328wrl.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 26 Jun 2019 13:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=FuRzHg6WARvoMr4E98EICb8lwwzIkbNBKvhn//9fQIZP0++3MvWAoCSrdGYu8BCegm
         5ISVo6liu2D7Wo8iyygHWiH0pepQFFzZ59L+Y5efKzNWIRpBllpV+SBsfvNuTG9GnNny
         ZUMOlkGUgaQT3cliACBRB6tqcbJ2jE9miSPiinOPLUrNbI+M/uQBIDhKlbpmZ6pOw9+z
         Y7J0Wogs6S1do87Ht/xrJhSzF1Fii0Drd+eM/u8hTZKTyXw547DaqLmLCuox/Egkbyuh
         NbILSRFmsOXMBCiPHzh3brPgtl7mkkYGIGJSSyO9ATt7lHHJv+H+Pw2f988YEk1NyzF8
         B/qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=iIpoc8Q23bxVXqwG16Zf+nmvHwtjMQ7bb11NbkyHke2bR8ELj/dYgq69PTOyZpqysZ
         HuMc6oRiguN/t4DALxy0UIw+yLjWHu0B7NYRqCbeEYe/B17KAZDCykBjGhSsTxdp6J9u
         66n2nwB1kaXH75yTrL7/CPE6v1agIRVr8SFJVFrCchdBbuxFTIYoBXL1g5J14y6pe76D
         BoECe3L+Rri7NVPCem85rzYWMAfhYmK6w3tK1C1U3VCoLliAV5ST3rndM/rWK65N9YPW
         VTj73NIAhw11bUm7KfYDNkMgCPFPPBNH7teNYDt7WOlTSS8mOCailTkg3K6gQi9PQNAv
         r4lQ==
X-Gm-Message-State: APjAAAVdxrJ3PRRsonHXnYTclJrQWkJKaJ78Md9QVOwXK7zyN/dBDd7Y
        KV7Irh2PFvwnpzuqtzO3QfjJVQ==
X-Google-Smtp-Source: APXvYqwT2vdUDZjOVAKI7TP1MpC5tHuP5aufQx/van5wF9QyBVhZM2u4wH+aKT/EYsX6kPH2BZ1frA==
X-Received: by 2002:adf:e691:: with SMTP id r17mr5121901wrm.67.1561581655279;
        Wed, 26 Jun 2019 13:40:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:9c7f:f574:ee94:7dec])
        by smtp.gmail.com with ESMTPSA id 32sm35164587wra.35.2019.06.26.13.40.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 13:40:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v5 3/7] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Wed, 26 Jun 2019 22:40:43 +0200
Message-Id: <20190626204047.32131-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
References: <20190626204047.32131-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 35 +++++++++-----------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1b16d34bb785..f001f1104cb5 100644
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
@@ -2434,6 +2426,20 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
 
+	if (crypt_integrity_aead(cc)) {
+		ret = crypt_ctr_auth_cipher(cc, cipher_api);
+		if (ret < 0) {
+			ti->error = "Invalid AEAD cipher spec";
+			return -ENOMEM;
+	       }
+	}
+
+	ret = crypt_ctr_blkdev_cipher(cc, cipher_api);
+	if (ret < 0) {
+		ti->error = "Cannot allocate cipher string";
+		return -ENOMEM;
+	}
+
 	cc->key_parts = cc->tfms_count;
 
 	/* Allocate cipher */
@@ -2445,21 +2451,10 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 
 	/* Alloc AEAD, can be used only in new format. */
 	if (crypt_integrity_aead(cc)) {
-		ret = crypt_ctr_auth_cipher(cc, cipher_api);
-		if (ret < 0) {
-			ti->error = "Invalid AEAD cipher spec";
-			return -ENOMEM;
-		}
 		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
 	} else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
-	ret = crypt_ctr_blkdev_cipher(cc);
-	if (ret < 0) {
-		ti->error = "Cannot allocate cipher string";
-		return -ENOMEM;
-	}
-
 	return 0;
 }
 
-- 
2.20.1

