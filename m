Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F799266A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 19 Aug 2019 16:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfHSOSP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 19 Aug 2019 10:18:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36419 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbfHSOSP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 19 Aug 2019 10:18:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so8928649wrt.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 19 Aug 2019 07:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BcWIB76wg48RNo08lQlhwQQhiL627ab4K7WqNmtJSMg=;
        b=JUQQil9Zee9PPbfDU3Wj/L0QBMqdVkUDst6RWO6HlYv5Mj3Z6IPKIW8cwmnq25GGMQ
         u8+CxiAh4rJpXmGO/qwZ5X7yhG3za4lYT2gEKPZgr4RvoT3nZ/igWNHC02FHY943d6CF
         oZHLjWaf61MSLhESpZh5Pv07laTq6AdLAfzWSqRLo8Kl3vWVd/V5VkFMVBISSqWpyfqv
         g90Umfne9z1NWnBM/Y8n/ygzbrCSOXoxRKH2IJXvMCYpkdvI+SMlneOm9xWTNFOOXwp1
         C18FQbXJILWDgOdzBu5+gQ/Khh/xOs68iKx3b8nPFypCUUeba72zEBFA5jIUX8Nhc2cs
         yf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BcWIB76wg48RNo08lQlhwQQhiL627ab4K7WqNmtJSMg=;
        b=fcPQELBwM7dObqQ8L8Zxj7QOkvB1jYfYpd2gNbZv/xRP2TGRfftaBRR8PYLNi5/iy8
         jIspKO5MtTFZPhe71PfXTjkAogB6SDlXaYx8qsdv8wUMhPbW72bsEkZX06YrpdiJ1rdn
         XSV1RQ00x+FYnuSgLb6FHRLb/1D218SP3jdrz9Z65PBdRR6NbaZ78J9t23lA0utqCNYB
         om8uGkgkSlLh1+J7TzihQUcfw36cJavlQEXzBid+9EMsI8wO0b7rRnzvk7SFEbviHsU1
         Pxe89N28JbElWFN2aiyYrI/R+yCpz2/tJDW63hAFFo50ekHW2XDfrg6OXpnP9jhgRhL1
         1hDQ==
X-Gm-Message-State: APjAAAWGl735fwDkqpufBJFY3Bvptq1WC8C3T4GJy9wE3jNbnZRBtaXx
        5N84RoPFnaRPThus2BT5e7rq4w==
X-Google-Smtp-Source: APXvYqxnnDgpcxuVnjV8UMvXSNIreuvxZc0o89LtNA/qSFe+VivBnj0lbtd5OOt5LH2yqFsQcVcQIQ==
X-Received: by 2002:adf:ff8e:: with SMTP id j14mr28349096wrr.141.1566224292789;
        Mon, 19 Aug 2019 07:18:12 -0700 (PDT)
Received: from localhost.localdomain (11.172.185.81.rev.sfr.net. [81.185.172.11])
        by smtp.gmail.com with ESMTPSA id b26sm12693352wmj.14.2019.08.19.07.18.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:18:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: [PATCH v13 5/6] md: dm-crypt: switch to ESSIV crypto API template
Date:   Mon, 19 Aug 2019 17:17:37 +0300
Message-Id: <20190819141738.1231-6-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Replace the explicit ESSIV handling in the dm-crypt driver with calls
into the crypto API, which now possesses the capability to perform
this processing within the crypto subsystem.

Note that we reorder the AEAD cipher_api string parsing with the TFM
instantiation: this is needed because cipher_api is mangled by the
ESSIV handling, and throws off the parsing of "authenc(" otherwise.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/Kconfig    |   1 +
 drivers/md/dm-crypt.c | 213 ++++----------------
 2 files changed, 44 insertions(+), 170 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 3834332f4963..b727e8f15264 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -271,6 +271,7 @@ config DM_CRYPT
 	depends on BLK_DEV_DM
 	select CRYPTO
 	select CRYPTO_CBC
+	select CRYPTO_ESSIV
 	---help---
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5216bcc4649..e3e6e111edfc 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -98,11 +98,6 @@ struct crypt_iv_operations {
 		    struct dm_crypt_request *dmreq);
 };
 
-struct iv_essiv_private {
-	struct crypto_shash *hash_tfm;
-	u8 *salt;
-};
-
 struct iv_benbi_private {
 	int shift;
 };
@@ -159,7 +154,6 @@ struct crypt_config {
 
 	const struct crypt_iv_operations *iv_gen_ops;
 	union {
-		struct iv_essiv_private essiv;
 		struct iv_benbi_private benbi;
 		struct iv_lmk_private lmk;
 		struct iv_tcw_private tcw;
@@ -170,8 +164,6 @@ struct crypt_config {
 	unsigned short int sector_size;
 	unsigned char sector_shift;
 
-	/* ESSIV: struct crypto_cipher *essiv_tfm */
-	void *iv_private;
 	union {
 		struct crypto_skcipher **tfms;
 		struct crypto_aead **tfms_aead;
@@ -329,157 +321,15 @@ static int crypt_iv_plain64be_gen(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
-/* Initialise ESSIV - compute salt but no local memory allocations */
-static int crypt_iv_essiv_init(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	SHASH_DESC_ON_STACK(desc, essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	desc->tfm = essiv->hash_tfm;
-
-	err = crypto_shash_digest(desc, cc->key, cc->key_size, essiv->salt);
-	shash_desc_zero(desc);
-	if (err)
-		return err;
-
-	essiv_tfm = cc->iv_private;
-
-	err = crypto_cipher_setkey(essiv_tfm, essiv->salt,
-			    crypto_shash_digestsize(essiv->hash_tfm));
-	if (err)
-		return err;
-
-	return 0;
-}
-
-/* Wipe salt and reset key derived from volume key */
-static int crypt_iv_essiv_wipe(struct crypt_config *cc)
-{
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-	unsigned salt_size = crypto_shash_digestsize(essiv->hash_tfm);
-	struct crypto_cipher *essiv_tfm;
-	int r, err = 0;
-
-	memset(essiv->salt, 0, salt_size);
-
-	essiv_tfm = cc->iv_private;
-	r = crypto_cipher_setkey(essiv_tfm, essiv->salt, salt_size);
-	if (r)
-		err = r;
-
-	return err;
-}
-
-/* Allocate the cipher for ESSIV */
-static struct crypto_cipher *alloc_essiv_cipher(struct crypt_config *cc,
-						struct dm_target *ti,
-						const u8 *salt,
-						unsigned int saltsize)
-{
-	struct crypto_cipher *essiv_tfm;
-	int err;
-
-	/* Setup the essiv_tfm with the given salt */
-	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
-	if (IS_ERR(essiv_tfm)) {
-		ti->error = "Error allocating crypto tfm for ESSIV";
-		return essiv_tfm;
-	}
-
-	if (crypto_cipher_blocksize(essiv_tfm) != cc->iv_size) {
-		ti->error = "Block size of ESSIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(-EINVAL);
-	}
-
-	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
-	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
-		crypto_free_cipher(essiv_tfm);
-		return ERR_PTR(err);
-	}
-
-	return essiv_tfm;
-}
-
-static void crypt_iv_essiv_dtr(struct crypt_config *cc)
-{
-	struct crypto_cipher *essiv_tfm;
-	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
-
-	crypto_free_shash(essiv->hash_tfm);
-	essiv->hash_tfm = NULL;
-
-	kzfree(essiv->salt);
-	essiv->salt = NULL;
-
-	essiv_tfm = cc->iv_private;
-
-	if (essiv_tfm)
-		crypto_free_cipher(essiv_tfm);
-
-	cc->iv_private = NULL;
-}
-
-static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			      const char *opts)
-{
-	struct crypto_cipher *essiv_tfm = NULL;
-	struct crypto_shash *hash_tfm = NULL;
-	u8 *salt = NULL;
-	int err;
-
-	if (!opts) {
-		ti->error = "Digest algorithm missing for ESSIV mode";
-		return -EINVAL;
-	}
-
-	/* Allocate hash algorithm */
-	hash_tfm = crypto_alloc_shash(opts, 0, 0);
-	if (IS_ERR(hash_tfm)) {
-		ti->error = "Error initializing ESSIV hash";
-		err = PTR_ERR(hash_tfm);
-		goto bad;
-	}
-
-	salt = kzalloc(crypto_shash_digestsize(hash_tfm), GFP_KERNEL);
-	if (!salt) {
-		ti->error = "Error kmallocing salt storage in ESSIV";
-		err = -ENOMEM;
-		goto bad;
-	}
-
-	cc->iv_gen_private.essiv.salt = salt;
-	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
-
-	essiv_tfm = alloc_essiv_cipher(cc, ti, salt,
-				       crypto_shash_digestsize(hash_tfm));
-	if (IS_ERR(essiv_tfm)) {
-		crypt_iv_essiv_dtr(cc);
-		return PTR_ERR(essiv_tfm);
-	}
-	cc->iv_private = essiv_tfm;
-
-	return 0;
-
-bad:
-	if (hash_tfm && !IS_ERR(hash_tfm))
-		crypto_free_shash(hash_tfm);
-	kfree(salt);
-	return err;
-}
-
 static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv,
 			      struct dm_crypt_request *dmreq)
 {
-	struct crypto_cipher *essiv_tfm = cc->iv_private;
-
+	/*
+	 * ESSIV encryption of the IV is now handled by the crypto API,
+	 * so just pass the plain sector number here.
+	 */
 	memset(iv, 0, cc->iv_size);
 	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector);
-	crypto_cipher_encrypt_one(essiv_tfm, iv, iv);
 
 	return 0;
 }
@@ -921,10 +771,6 @@ static const struct crypt_iv_operations crypt_iv_plain64be_ops = {
 };
 
 static const struct crypt_iv_operations crypt_iv_essiv_ops = {
-	.ctr       = crypt_iv_essiv_ctr,
-	.dtr       = crypt_iv_essiv_dtr,
-	.init      = crypt_iv_essiv_init,
-	.wipe      = crypt_iv_essiv_wipe,
 	.generator = crypt_iv_essiv_gen
 };
 
@@ -2490,7 +2336,7 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 				char **ivmode, char **ivopts)
 {
 	struct crypt_config *cc = ti->private;
-	char *tmp, *cipher_api;
+	char *tmp, *cipher_api, buf[CRYPTO_MAX_ALG_NAME];
 	int ret = -EINVAL;
 
 	cc->tfms_count = 1;
@@ -2516,9 +2362,32 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 	/* The rest is crypto API spec */
 	cipher_api = tmp;
 
+	/* Alloc AEAD, can be used only in new format. */
+	if (crypt_integrity_aead(cc)) {
+		ret = crypt_ctr_auth_cipher(cc, cipher_api);
+		if (ret < 0) {
+			ti->error = "Invalid AEAD cipher spec";
+			return -ENOMEM;
+		}
+	}
+
 	if (*ivmode && !strcmp(*ivmode, "lmk"))
 		cc->tfms_count = 64;
 
+	if (*ivmode && !strcmp(*ivmode, "essiv")) {
+		if (!*ivopts) {
+			ti->error = "Digest algorithm missing for ESSIV mode";
+			return -EINVAL;
+		}
+		ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s)",
+			       cipher_api, *ivopts);
+		if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
+			ti->error = "Cannot allocate cipher string";
+			return -ENOMEM;
+		}
+		cipher_api = buf;
+	}
+
 	cc->key_parts = cc->tfms_count;
 
 	/* Allocate cipher */
@@ -2528,15 +2397,9 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 		return ret;
 	}
 
-	/* Alloc AEAD, can be used only in new format. */
-	if (crypt_integrity_aead(cc)) {
-		ret = crypt_ctr_auth_cipher(cc, cipher_api);
-		if (ret < 0) {
-			ti->error = "Invalid AEAD cipher spec";
-			return -ENOMEM;
-		}
+	if (crypt_integrity_aead(cc))
 		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
-	} else
+	else
 		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
 	ret = crypt_ctr_blkdev_cipher(cc);
@@ -2605,9 +2468,19 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 	if (!cipher_api)
 		goto bad_mem;
 
-	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
-		       "%s(%s)", chainmode, cipher);
-	if (ret < 0) {
+	if (*ivmode && !strcmp(*ivmode, "essiv")) {
+		if (!*ivopts) {
+			ti->error = "Digest algorithm missing for ESSIV mode";
+			kfree(cipher_api);
+			return -EINVAL;
+		}
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
+			       "essiv(%s(%s),%s)", chainmode, cipher, *ivopts);
+	} else {
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
+			       "%s(%s)", chainmode, cipher);
+	}
+	if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
 		kfree(cipher_api);
 		goto bad_mem;
 	}
-- 
2.17.1

