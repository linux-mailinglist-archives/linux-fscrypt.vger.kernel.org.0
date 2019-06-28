Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB5059EA9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Jun 2019 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfF1PV1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Jun 2019 11:21:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34618 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfF1PV0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Jun 2019 11:21:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so9577327wmd.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 28 Jun 2019 08:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=o+7yKEDqtEK1l4oK+b/ES4RAAsXKsIEa21cEXJi2IgiwlDivOuMtbO/jaDNKKwI8Kz
         USDlJ6axNNDcAuaZtXM1OLo/Rvtz7Ho0Ad26n5jk13Nk0xkDxokRlRCLrfUaVxjpyKA3
         j093/r9Y1qEUeq7oY1Bmg59tDpUa0hQ+c8zyUeBYeWmBuyWPOdS9GEG1whhy3QscQWha
         qeL+g7AiXTmu85hd87LL+MEnUrxgncuVMfpLkXoiO4E8vWvZxRoCUjX5Q1I0FQJHCZJm
         szFfXdAYW4Ky1PuhipEvmhnAeskMN2TlnPNcyDfcqG1JpEEYI6s0jpYi8JR1IN1jexpj
         tlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qsECSzDwZmZWjunZWkZ4/sxN9oyV7lbTfmYWPWEtO7o=;
        b=XgnrVujPh9Wb1VlVRHwy9uVhfheB13Xro7u+afSQ4rWkua9yUapAiS69cTKKgrpyFw
         iAZ4UDAI5M9nS1pVpBy73pOm1fbLr2SYzs77Re92ZNApkikpxBrnYXqzCeKLxyyYdzsa
         7orFDj3xRT7YLNznxywlpushBRMKWU5rmmrx13W3z8av3xOD8Mw8d0sST1M9KokXRCLJ
         98kukCob6O/dC6cg84pu063T40N8CoT/Jyk5R/CfD//voS+JjllVjVB4B31zrItVOpNZ
         LKYgWXSptwRXj6l1ZV+tOaKL7f+ypx+hK9sTTqIxoD/lbiap/9yJ7BDlc1yhlZHxVoi7
         nGYA==
X-Gm-Message-State: APjAAAWurUClP6U4rVhTKFp7hK327krQxvLtD5d/Cuppvhd3QfqIOf+2
        +ukmrvkZEbXyc6mAt5MA5DeZQg==
X-Google-Smtp-Source: APXvYqwPZ2WcHIkuqyg0P+aJ2AOQvMG3MAePNy0WhYDzpML2VIEA9+qwhg9WgnM9GBSD1k4LdJZ0oQ==
X-Received: by 2002:a7b:cd84:: with SMTP id y4mr7676832wmj.79.1561735285257;
        Fri, 28 Jun 2019 08:21:25 -0700 (PDT)
Received: from localhost.localdomain (91-167-84-221.subs.proxad.net. [91.167.84.221])
        by smtp.gmail.com with ESMTPSA id u13sm2734319wrq.62.2019.06.28.08.21.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 08:21:24 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v6 3/7] md: dm-crypt: infer ESSIV block cipher from cipher string directly
Date:   Fri, 28 Jun 2019 17:21:08 +0200
Message-Id: <20190628152112.914-4-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628152112.914-1-ard.biesheuvel@linaro.org>
References: <20190628152112.914-1-ard.biesheuvel@linaro.org>
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

