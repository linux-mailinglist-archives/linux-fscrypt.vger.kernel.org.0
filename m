Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9F5192B0
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 May 2022 02:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244559AbiEDAWY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 3 May 2022 20:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244563AbiEDAWV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 3 May 2022 20:22:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096D842EFE
        for <linux-fscrypt@vger.kernel.org>; Tue,  3 May 2022 17:18:45 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f4e17a5809so374937b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 03 May 2022 17:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=3ystt2sBKsPANJIeRlt5KsQj0jKBfsi5eq5UWIBZAUE=;
        b=h4oP+MzhDFBME5weR8X5Y1WwKDZDW0hqhD+fD2GD63KNq2qZ/MxGXuI5315eARGDCW
         RkFROGzBygdq0moCSfxvsxdM1TSG4cG37Bn1bJXSuvUBbOqzYAvEz382nFHwbK0lcEx8
         rzeyzptDv7RFwQpu5+14yOPZd03Sgb9BikM5ex6LFvJMACw0LyyHJL/VpG1gw4dmPqFn
         fnr815jSVTYHG641dvqX2MSx8LNpG2/F98aZoQE2qFb3KJZvJ0YCY3cAkfheASb7qZ0G
         jW0Nq52RGNXEGTeLEOogARTzNtVmI6cJF3Dr+0Cwm2BtIY2GRePmUiZxNDxC2U0IZoKh
         Z5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=3ystt2sBKsPANJIeRlt5KsQj0jKBfsi5eq5UWIBZAUE=;
        b=mfdN5Luez3TmI1EWMAWcn37TKEPs1Eb2MWcy5b6ckBf89MwAtvM3btRbdiT34PGnxn
         iAPPo4gn3FUgoDdwSFCJuUsaNoFnZ0kFCuqOwzaYc/M+HY16D1cCzZciR9k37hEL1xsU
         GLNjinvc76tg1s3X3b2ZpfTWDWVCc4qL99P5SZoRVXr6ptP3lDhkNIH4L4m3EDJZhotu
         e93dEepM1d4BE/2RqGd1glgw8Zu4sHb83spYzzzFg+MPAg+Rk0nWUKal8r7cefGeWCa0
         7SXgTjGsAKhwuzfPFSnrj3w+/RigI82dgoABJFdUhqBZ+sKOwbITT71DHBNm2J+mej/f
         QEZA==
X-Gm-Message-State: AOAM531EJcAqZyv4iBUJukYN1qdBbJUfnQmZ4Rni5hoKioaIZUntd1bc
        3SOnkd1KXX0BB5LTE9hoNoAklxXlFw==
X-Google-Smtp-Source: ABdhPJzzt0oWK+oOzYapTrfkx0Rysra+IMiORo5BmIHzqEFzviQ+r9SQoKFR9mmwMvMGeZKNoUaXm4mnEg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:d90c:0:b0:648:dbec:5391 with SMTP id
 q12-20020a25d90c000000b00648dbec5391mr17143606ybg.309.1651623524254; Tue, 03
 May 2022 17:18:44 -0700 (PDT)
Date:   Wed,  4 May 2022 00:18:17 +0000
In-Reply-To: <20220504001823.2483834-1-nhuck@google.com>
Message-Id: <20220504001823.2483834-4-nhuck@google.com>
Mime-Version: 1.0
References: <20220504001823.2483834-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 3/9] crypto: hctr2 - Add HCTR2 support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Huckleberry <nhuck@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add support for HCTR2 as a template.  HCTR2 is a length-preserving
encryption mode that is efficient on processors with instructions to
accelerate AES and carryless multiplication, e.g. x86 processors with
AES-NI and CLMUL, and ARM processors with the ARMv8 Crypto Extensions.

As a length-preserving encryption mode, HCTR2 is suitable for
applications such as storage encryption where ciphertext expansion is
not possible, and thus authenticated encryption cannot be used.
Currently, such applications usually use XTS, or in some cases Adiantum.
XTS has the disadvantage that it is a narrow-block mode: a bitflip will
only change 16 bytes in the resulting ciphertext or plaintext.  This
reveals more information to an attacker than necessary.

HCTR2 is a wide-block mode, so it provides a stronger security property:
a bitflip will change the entire message.  HCTR2 is somewhat similar to
Adiantum, which is also a wide-block mode.  However, HCTR2 is designed
to take advantage of existing crypto instructions, while Adiantum
targets devices without such hardware support.  Adiantum is also
designed with longer messages in mind, while HCTR2 is designed to be
efficient even on short messages.

HCTR2 requires POLYVAL and XCTR as components.  More information on
HCTR2 can be found here: "Length-preserving encryption with HCTR2":
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig   |  11 +
 crypto/Makefile  |   1 +
 crypto/hctr2.c   | 581 ++++++++++++++++++++++++++++++++++++++++
 crypto/tcrypt.c  |   5 +
 crypto/testmgr.c |   8 +
 crypto/testmgr.h | 672 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 1278 insertions(+)
 create mode 100644 crypto/hctr2.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 00139845d76d..0dedba74db4a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -532,6 +532,17 @@ config CRYPTO_ADIANTUM
=20
 	  If unsure, say N.
=20
+config CRYPTO_HCTR2
+	tristate "HCTR2 support"
+	select CRYPTO_XCTR
+	select CRYPTO_POLYVAL
+	select CRYPTO_MANAGER
+	help
+	  HCTR2 is a length-preserving encryption mode for storage encryption tha=
t
+	  is efficient on processors with instructions to accelerate AES and
+	  carryless multiplication, e.g. x86 processors with AES-NI and CLMUL, an=
d
+	  ARM processors with the ARMv8 crypto extensions.
+
 config CRYPTO_ESSIV
 	tristate "ESSIV support for block encryption"
 	select CRYPTO_AUTHENC
diff --git a/crypto/Makefile b/crypto/Makefile
index 561f901a91d4..2dca9dbdede6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -94,6 +94,7 @@ obj-$(CONFIG_CRYPTO_LRW) +=3D lrw.o
 obj-$(CONFIG_CRYPTO_XTS) +=3D xts.o
 obj-$(CONFIG_CRYPTO_CTR) +=3D ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) +=3D xctr.o
+obj-$(CONFIG_CRYPTO_HCTR2) +=3D hctr2.o
 obj-$(CONFIG_CRYPTO_KEYWRAP) +=3D keywrap.o
 obj-$(CONFIG_CRYPTO_ADIANTUM) +=3D adiantum.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305) +=3D nhpoly1305.o
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
new file mode 100644
index 000000000000..7d00a3bcb667
--- /dev/null
+++ b/crypto/hctr2.c
@@ -0,0 +1,581 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * HCTR2 length-preserving encryption mode
+ *
+ * Copyright 2021 Google LLC
+ */
+
+
+/*
+ * HCTR2 is a length-preserving encryption mode that is efficient on
+ * processors with instructions to accelerate AES and carryless
+ * multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
+ * processors with the ARMv8 crypto extensions.
+ *
+ * For more details, see the paper: "Length-preserving encryption with HCT=
R2"
+ * (https://eprint.iacr.org/2021/1441.pdf)
+ */
+
+#include <crypto/internal/cipher.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/polyval.h>
+#include <crypto/scatterwalk.h>
+#include <linux/module.h>
+
+#define BLOCKCIPHER_BLOCK_SIZE		16
+
+/*
+ * The specification allows variable-length tweaks, but Linux's crypto API
+ * currently only allows algorithms to support a single length.  The "natu=
ral"
+ * tweak length for HCTR2 is 16, since that fits into one POLYVAL block fo=
r
+ * the best performance.  But longer tweaks are useful for fscrypt, to avo=
id
+ * needing to derive per-file keys.  So instead we use two blocks, or 32 b=
ytes.
+ */
+#define TWEAK_SIZE		32
+
+struct hctr2_instance_ctx {
+	struct crypto_cipher_spawn blockcipher_spawn;
+	struct crypto_skcipher_spawn xctr_spawn;
+	struct crypto_shash_spawn polyval_spawn;
+};
+
+struct hctr2_tfm_ctx {
+	struct crypto_cipher *blockcipher;
+	struct crypto_skcipher *xctr;
+	struct crypto_shash *polyval;
+	u8 L[BLOCKCIPHER_BLOCK_SIZE];
+	int hashed_tweak_offset;
+	/*
+	 * This struct is allocated with extra space for two exported hash
+	 * states.  Since the hash state size is not known at compile-time, we
+	 * can't add these to the struct directly.
+	 *
+	 * hashed_tweaklen_divisible;
+	 * hashed_tweaklen_remainder;
+	 */
+};
+
+struct hctr2_request_ctx {
+	u8 first_block[BLOCKCIPHER_BLOCK_SIZE];
+	u8 xctr_iv[BLOCKCIPHER_BLOCK_SIZE];
+	struct scatterlist *bulk_part_dst;
+	struct scatterlist *bulk_part_src;
+	struct scatterlist sg_src[2];
+	struct scatterlist sg_dst[2];
+	/*
+	 * Sub-request sizes are unknown at compile-time, so they need to go
+	 * after the members with known sizes.
+	 */
+	union {
+		struct shash_desc hash_desc;
+		struct skcipher_request xctr_req;
+	} u;
+	/*
+	 * This struct is allocated with extra space for one exported hash
+	 * state.  Since the hash state size is not known at compile-time, we
+	 * can't add it to the struct directly.
+	 *
+	 * hashed_tweak;
+	 */
+};
+
+static inline u8 *hctr2_hashed_tweaklen(const struct hctr2_tfm_ctx *tctx,
+					bool has_remainder)
+{
+	u8 *p =3D (u8 *)tctx + sizeof(*tctx);
+
+	if (has_remainder) /* For messages not a multiple of block length */
+		p +=3D crypto_shash_statesize(tctx->polyval);
+	return p;
+}
+
+static inline u8 *hctr2_hashed_tweak(const struct hctr2_tfm_ctx *tctx,
+				     struct hctr2_request_ctx *rctx)
+{
+	return (u8 *)rctx + tctx->hashed_tweak_offset;
+}
+
+/*
+ * The input data for each HCTR2 hash step begins with a 16-byte block tha=
t
+ * contains the tweak length and a flag that indicates whether the input i=
s evenly
+ * divisible into blocks.  Since this implementation only supports one twe=
ak
+ * length, we precompute the two hash states resulting from hashing the tw=
o
+ * possible values of this initial block.  This reduces by one block the a=
mount of
+ * data that needs to be hashed for each encryption/decryption
+ *
+ * These precomputed hashes are stored in hctr2_tfm_ctx.
+ */
+static int hctr2_hash_tweaklen(struct hctr2_tfm_ctx *tctx, bool has_remain=
der)
+{
+	SHASH_DESC_ON_STACK(shash, tfm->polyval);
+	__le64 tweak_length_block[2];
+	int err;
+
+	shash->tfm =3D tctx->polyval;
+	memset(tweak_length_block, 0, sizeof(tweak_length_block));
+
+	tweak_length_block[0] =3D cpu_to_le64(TWEAK_SIZE * 8 * 2 + 2 + has_remain=
der);
+	err =3D crypto_shash_init(shash);
+	if (err)
+		return err;
+	err =3D crypto_shash_update(shash, (u8 *)tweak_length_block,
+				  POLYVAL_BLOCK_SIZE);
+	if (err)
+		return err;
+	return crypto_shash_export(shash, hctr2_hashed_tweaklen(tctx, has_remaind=
er));
+}
+
+static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
+			unsigned int keylen)
+{
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	u8 hbar[BLOCKCIPHER_BLOCK_SIZE];
+	int err;
+
+	crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_cipher_set_flags(tctx->blockcipher,
+				crypto_skcipher_get_flags(tfm) &
+				CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_cipher_setkey(tctx->blockcipher, key, keylen);
+	if (err)
+		return err;
+
+	crypto_skcipher_clear_flags(tctx->xctr, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(tctx->xctr,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_skcipher_setkey(tctx->xctr, key, keylen);
+	if (err)
+		return err;
+
+	memset(hbar, 0, sizeof(hbar));
+	crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);
+
+	memset(tctx->L, 0, sizeof(tctx->L));
+	tctx->L[0] =3D 0x01;
+	crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
+
+	crypto_shash_clear_flags(tctx->polyval, CRYPTO_TFM_REQ_MASK);
+	crypto_shash_set_flags(tctx->polyval, crypto_skcipher_get_flags(tfm) &
+			       CRYPTO_TFM_REQ_MASK);
+	err =3D crypto_shash_setkey(tctx->polyval, hbar, BLOCKCIPHER_BLOCK_SIZE);
+	if (err)
+		return err;
+	memzero_explicit(hbar, sizeof(hbar));
+
+	return hctr2_hash_tweaklen(tctx, true) ?: hctr2_hash_tweaklen(tctx, false=
);
+}
+
+static int hctr2_hash_tweak(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
+	const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
+	int err;
+	bool has_remainder =3D req->cryptlen % POLYVAL_BLOCK_SIZE;
+
+	hash_desc->tfm =3D tctx->polyval;
+	err =3D crypto_shash_import(hash_desc, hctr2_hashed_tweaklen(tctx, has_re=
mainder));
+	if (err)
+		return err;
+	err =3D crypto_shash_update(hash_desc, req->iv, TWEAK_SIZE);
+	if (err)
+		return err;
+
+	// Store the hashed tweak, since we need it when computing both
+	// H(T || N) and H(T || V).
+	return crypto_shash_export(hash_desc, hctr2_hashed_tweak(tctx, rctx));
+}
+
+static int hctr2_hash_message(struct skcipher_request *req,
+			      struct scatterlist *sgl,
+			      u8 digest[POLYVAL_DIGEST_SIZE])
+{
+	static const u8 padding[BLOCKCIPHER_BLOCK_SIZE] =3D { 0x1 };
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
+	const unsigned int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	struct sg_mapping_iter miter;
+	unsigned int remainder =3D bulk_len % BLOCKCIPHER_BLOCK_SIZE;
+	int i;
+	int err =3D 0;
+	int n =3D 0;
+
+	sg_miter_start(&miter, sgl, sg_nents(sgl),
+		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+	for (i =3D 0; i < bulk_len; i +=3D n) {
+		sg_miter_next(&miter);
+		n =3D min_t(unsigned int, miter.length, bulk_len - i);
+		err =3D crypto_shash_update(hash_desc, miter.addr, n);
+		if (err)
+			break;
+	}
+	sg_miter_stop(&miter);
+
+	if (err)
+		return err;
+
+	if (remainder) {
+		err =3D crypto_shash_update(hash_desc, padding,
+					  BLOCKCIPHER_BLOCK_SIZE - remainder);
+		if (err)
+			return err;
+	}
+	return crypto_shash_final(hash_desc, digest);
+}
+
+static int hctr2_finish(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
+	const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	u8 digest[POLYVAL_DIGEST_SIZE];
+	struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
+	int err;
+
+	// U =3D UU ^ H(T || V)
+	// or M =3D MM ^ H(T || N)
+	hash_desc->tfm =3D tctx->polyval;
+	err =3D crypto_shash_import(hash_desc, hctr2_hashed_tweak(tctx, rctx));
+	if (err)
+		return err;
+	err =3D hctr2_hash_message(req, rctx->bulk_part_dst, digest);
+	if (err)
+		return err;
+	crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
+
+	// Copy U (or M) into dst scatterlist
+	scatterwalk_map_and_copy(rctx->first_block, req->dst,
+				 0, BLOCKCIPHER_BLOCK_SIZE, 1);
+	return 0;
+}
+
+static void hctr2_xctr_done(struct crypto_async_request *areq,
+				    int err)
+{
+	struct skcipher_request *req =3D areq->data;
+
+	if (!err)
+		err =3D hctr2_finish(req);
+
+	skcipher_request_complete(req, err);
+}
+
+static int hctr2_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
+	const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
+	u8 digest[POLYVAL_DIGEST_SIZE];
+	int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
+	int err;
+
+	// Requests must be at least one block
+	if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
+		return -EINVAL;
+
+	// Copy M (or U) into a temporary buffer
+	scatterwalk_map_and_copy(rctx->first_block, req->src,
+				 0, BLOCKCIPHER_BLOCK_SIZE, 0);
+
+	// Create scatterlists for N and V
+	rctx->bulk_part_src =3D scatterwalk_ffwd(rctx->sg_src, req->src,
+					       BLOCKCIPHER_BLOCK_SIZE);
+	rctx->bulk_part_dst =3D scatterwalk_ffwd(rctx->sg_dst, req->dst,
+					       BLOCKCIPHER_BLOCK_SIZE);
+
+	// MM =3D M ^ H(T || N)
+	// or UU =3D U ^ H(T || V)
+	err =3D hctr2_hash_tweak(req);
+	if (err)
+		return err;
+	err =3D hctr2_hash_message(req, rctx->bulk_part_src, digest);
+	if (err)
+		return err;
+	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
+
+	// UU =3D E(MM)
+	// or MM =3D D(UU)
+	if (enc)
+		crypto_cipher_encrypt_one(tctx->blockcipher, rctx->first_block,
+					  digest);
+	else
+		crypto_cipher_decrypt_one(tctx->blockcipher, rctx->first_block,
+					  digest);
+
+	// S =3D MM ^ UU ^ L
+	crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
+	crypto_xor_cpy(rctx->xctr_iv, digest, tctx->L, BLOCKCIPHER_BLOCK_SIZE);
+
+	// V =3D XCTR(S, N)
+	// or N =3D XCTR(S, V)
+	skcipher_request_set_tfm(&rctx->u.xctr_req, tctx->xctr);
+	skcipher_request_set_crypt(&rctx->u.xctr_req, rctx->bulk_part_src,
+				   rctx->bulk_part_dst, bulk_len,
+				   rctx->xctr_iv);
+	skcipher_request_set_callback(&rctx->u.xctr_req,
+				      req->base.flags,
+				      hctr2_xctr_done, req);
+	return crypto_skcipher_encrypt(&rctx->u.xctr_req) ?:
+		hctr2_finish(req);
+}
+
+static int hctr2_encrypt(struct skcipher_request *req)
+{
+	return hctr2_crypt(req, true);
+}
+
+static int hctr2_decrypt(struct skcipher_request *req)
+{
+	return hctr2_crypt(req, false);
+}
+
+static int hctr2_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst =3D skcipher_alg_instance(tfm);
+	struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *xctr;
+	struct crypto_cipher *blockcipher;
+	struct crypto_shash *polyval;
+	unsigned int subreq_size;
+	int err;
+
+	xctr =3D crypto_spawn_skcipher(&ictx->xctr_spawn);
+	if (IS_ERR(xctr))
+		return PTR_ERR(xctr);
+
+	blockcipher =3D crypto_spawn_cipher(&ictx->blockcipher_spawn);
+	if (IS_ERR(blockcipher)) {
+		err =3D PTR_ERR(blockcipher);
+		goto err_free_xctr;
+	}
+
+	polyval =3D crypto_spawn_shash(&ictx->polyval_spawn);
+	if (IS_ERR(polyval)) {
+		err =3D PTR_ERR(polyval);
+		goto err_free_blockcipher;
+	}
+
+	tctx->xctr =3D xctr;
+	tctx->blockcipher =3D blockcipher;
+	tctx->polyval =3D polyval;
+
+	BUILD_BUG_ON(offsetofend(struct hctr2_request_ctx, u) !=3D
+				 sizeof(struct hctr2_request_ctx));
+	subreq_size =3D max(sizeof_field(struct hctr2_request_ctx, u.hash_desc) +
+			  crypto_shash_descsize(polyval),
+			  sizeof_field(struct hctr2_request_ctx, u.xctr_req) +
+			  crypto_skcipher_reqsize(xctr));
+
+	tctx->hashed_tweak_offset =3D offsetof(struct hctr2_request_ctx, u) +
+				    subreq_size;
+	crypto_skcipher_set_reqsize(tfm, tctx->hashed_tweak_offset +
+				    crypto_shash_statesize(polyval));
+	return 0;
+
+err_free_blockcipher:
+	crypto_free_cipher(blockcipher);
+err_free_xctr:
+	crypto_free_skcipher(xctr);
+	return err;
+}
+
+static void hctr2_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
+
+	crypto_free_cipher(tctx->blockcipher);
+	crypto_free_skcipher(tctx->xctr);
+	crypto_free_shash(tctx->polyval);
+}
+
+static void hctr2_free_instance(struct skcipher_instance *inst)
+{
+	struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
+
+	crypto_drop_cipher(&ictx->blockcipher_spawn);
+	crypto_drop_skcipher(&ictx->xctr_spawn);
+	crypto_drop_shash(&ictx->polyval_spawn);
+	kfree(inst);
+}
+
+static int hctr2_create_common(struct crypto_template *tmpl,
+			       struct rtattr **tb,
+			       const char *xctr_name,
+			       const char *polyval_name)
+{
+	u32 mask;
+	struct skcipher_instance *inst;
+	struct hctr2_instance_ctx *ictx;
+	struct skcipher_alg *xctr_alg;
+	struct crypto_alg *blockcipher_alg;
+	struct shash_alg *polyval_alg;
+	char blockcipher_name[CRYPTO_MAX_ALG_NAME];
+	int len;
+	int err;
+
+	err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+
+	inst =3D kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	ictx =3D skcipher_instance_ctx(inst);
+
+	/* Stream cipher, xctr(block_cipher) */
+	err =3D crypto_grab_skcipher(&ictx->xctr_spawn,
+				   skcipher_crypto_instance(inst),
+				   xctr_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	xctr_alg =3D crypto_spawn_skcipher_alg(&ictx->xctr_spawn);
+
+	err =3D -EINVAL;
+	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
+		goto err_free_inst;
+	len =3D strscpy(blockcipher_name, xctr_alg->base.cra_name + 5,
+		      sizeof(blockcipher_name));
+	if (len < 1)
+		goto err_free_inst;
+	if (blockcipher_name[len - 1] !=3D ')')
+		goto err_free_inst;
+	blockcipher_name[len - 1] =3D 0;
+
+	/* Block cipher, e.g. "aes" */
+	err =3D crypto_grab_cipher(&ictx->blockcipher_spawn,
+				 skcipher_crypto_instance(inst),
+				 blockcipher_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	blockcipher_alg =3D crypto_spawn_cipher_alg(&ictx->blockcipher_spawn);
+
+	/* Require blocksize of 16 bytes */
+	err =3D -EINVAL;
+	if (blockcipher_alg->cra_blocksize !=3D BLOCKCIPHER_BLOCK_SIZE)
+		goto err_free_inst;
+
+	/* Polyval =CE=B5-=E2=88=86U hash function */
+	err =3D crypto_grab_shash(&ictx->polyval_spawn,
+				skcipher_crypto_instance(inst),
+				polyval_name, 0, mask);
+	if (err)
+		goto err_free_inst;
+	polyval_alg =3D crypto_spawn_shash_alg(&ictx->polyval_spawn);
+
+	/* Ensure Polyval is being used */
+	err =3D -EINVAL;
+	if (strcmp(polyval_alg->base.cra_name, "polyval") !=3D 0)
+		goto err_free_inst;
+
+	/* Instance fields */
+
+	err =3D -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "hctr2(%s)",
+		     blockcipher_alg->cra_name) >=3D CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "hctr2_base(%s,%s)",
+		     xctr_alg->base.cra_driver_name,
+		     polyval_alg->base.cra_driver_name) >=3D CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	inst->alg.base.cra_blocksize =3D BLOCKCIPHER_BLOCK_SIZE;
+	inst->alg.base.cra_ctxsize =3D sizeof(struct hctr2_tfm_ctx) +
+				     polyval_alg->statesize * 2;
+	inst->alg.base.cra_alignmask =3D xctr_alg->base.cra_alignmask |
+				       polyval_alg->base.cra_alignmask;
+	/*
+	 * The hash function is called twice, so it is weighted higher than the
+	 * xctr and blockcipher.
+	 */
+	inst->alg.base.cra_priority =3D (2 * xctr_alg->base.cra_priority +
+				       4 * polyval_alg->base.cra_priority +
+				       blockcipher_alg->cra_priority) / 7;
+
+	inst->alg.setkey =3D hctr2_setkey;
+	inst->alg.encrypt =3D hctr2_encrypt;
+	inst->alg.decrypt =3D hctr2_decrypt;
+	inst->alg.init =3D hctr2_init_tfm;
+	inst->alg.exit =3D hctr2_exit_tfm;
+	inst->alg.min_keysize =3D crypto_skcipher_alg_min_keysize(xctr_alg);
+	inst->alg.max_keysize =3D crypto_skcipher_alg_max_keysize(xctr_alg);
+	inst->alg.ivsize =3D TWEAK_SIZE;
+
+	inst->free =3D hctr2_free_instance;
+
+	err =3D skcipher_register_instance(tmpl, inst);
+	if (err) {
+err_free_inst:
+		hctr2_free_instance(inst);
+	}
+	return err;
+}
+
+static int hctr2_create_base(struct crypto_template *tmpl, struct rtattr *=
*tb)
+{
+	const char *xctr_name;
+	const char *polyval_name;
+
+	xctr_name =3D crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(xctr_name))
+		return PTR_ERR(xctr_name);
+
+	polyval_name =3D crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(polyval_name))
+		return PTR_ERR(polyval_name);
+
+	return hctr2_create_common(tmpl, tb, xctr_name, polyval_name);
+}
+
+static int hctr2_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	const char *blockcipher_name;
+	char xctr_name[CRYPTO_MAX_ALG_NAME];
+
+	blockcipher_name =3D crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(blockcipher_name))
+		return PTR_ERR(blockcipher_name);
+
+	if (snprintf(xctr_name, CRYPTO_MAX_ALG_NAME, "xctr(%s)",
+		    blockcipher_name) >=3D CRYPTO_MAX_ALG_NAME)
+		return -ENAMETOOLONG;
+
+	return hctr2_create_common(tmpl, tb, xctr_name, "polyval");
+}
+
+static struct crypto_template hctr2_tmpls[] =3D {
+	{
+		/* hctr2_base(xctr_name, polyval_name) */
+		.name =3D "hctr2_base",
+		.create =3D hctr2_create_base,
+		.module =3D THIS_MODULE,
+	}, {
+		/* hctr2(blockcipher_name) */
+		.name =3D "hctr2",
+		.create =3D hctr2_create,
+		.module =3D THIS_MODULE,
+	}
+};
+
+static int __init hctr2_module_init(void)
+{
+	return crypto_register_templates(hctr2_tmpls, ARRAY_SIZE(hctr2_tmpls));
+}
+
+static void __exit hctr2_module_exit(void)
+{
+	return crypto_unregister_templates(hctr2_tmpls,
+					   ARRAY_SIZE(hctr2_tmpls));
+}
+
+subsys_initcall(hctr2_module_init);
+module_exit(hctr2_module_exit);
+
+MODULE_DESCRIPTION("HCTR2 length-preserving encryption mode");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("hctr2");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index dd9cf216029b..336598da8eac 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2191,6 +2191,11 @@ static int do_test(const char *alg, u32 type, u32 ma=
sk, int m, u32 num_mb)
 				   16, 16, aead_speed_template_19, num_mb);
 		break;
=20
+	case 226:
+		test_cipher_speed("hctr2(aes)", ENCRYPT, sec, NULL,
+				  0, speed_template_32);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d807b200edf6..3244b7e5aa7e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5030,6 +5030,14 @@ static const struct alg_test_desc alg_test_descs[] =
=3D {
 		.suite =3D {
 			.hash =3D __VECS(ghash_tv_template)
 		}
+	}, {
+		.alg =3D "hctr2(aes)",
+		.generic_driver =3D
+		    "hctr2_base(xctr(aes-generic),polyval-generic)",
+		.test =3D alg_test_skcipher,
+		.suite =3D {
+			.cipher =3D __VECS(aes_hctr2_tv_template)
+		}
 	}, {
 		.alg =3D "hmac(md5)",
 		.test =3D alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index c581e5405916..13c70dde2f89 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -35100,4 +35100,676 @@ static const struct hash_testvec polyval_tv_templ=
ate[] =3D {
=20
 };
=20
+/*
+ * Test vectors generated using https://github.com/google/hctr2
+ */
+static const struct cipher_testvec aes_hctr2_tv_template[] =3D {
+	{
+		.key	=3D "\xe1\x15\x66\x3c\x8d\xc6\x3a\xff"
+			  "\xef\x41\xd7\x47\xa2\xcc\x8a\xba",
+		.iv	=3D "\xc3\xbe\x2a\xcb\xb5\x39\x86\xf1"
+			  "\x91\xad\x6c\xf4\xde\x74\x45\x63"
+			  "\x5c\x7a\xd5\xcc\x8b\x76\xef\x0e"
+			  "\xcf\x2c\x60\x69\x37\xfd\x07\x96",
+		.ptext	=3D "\x65\x75\xae\xd3\xe2\xbc\x43\x5c"
+			  "\xb3\x1a\xd8\x05\xc3\xd0\x56\x29",
+		.ctext	=3D "\x11\x91\xea\x74\x58\xcc\xd5\xa2"
+			  "\xd0\x55\x9e\x3d\xfe\x7f\xc8\xfe",
+		.klen	=3D 16,
+		.len	=3D 16,
+	},
+	{
+		.key	=3D "\xe7\xd1\x77\x48\x76\x0b\xcd\x34"
+			  "\x2a\x2d\xe7\x74\xca\x11\x9c\xae",
+		.iv	=3D "\x71\x1c\x49\x62\xd9\x5b\x50\x5e"
+			  "\x68\x87\xbc\xf6\x89\xff\xed\x30"
+			  "\xe4\xe5\xbd\xb6\x10\x4f\x9f\x66"
+			  "\x28\x06\x5a\xf4\x27\x35\xcd\xe5",
+		.ptext	=3D "\x87\x03\x8f\x06\xa8\x61\x54\xda"
+			  "\x01\x45\xd4\x01\xef\x4a\x22\xcf"
+			  "\x78\x15\x9f\xbd\x64\xbd\x2c\xb9"
+			  "\x40\x1d\x72\xae\x53\x63\xa5",
+		.ctext	=3D "\x4e\xa1\x05\x27\xb8\x45\xe4\xa1"
+			  "\xbb\x30\xb4\xa6\x12\x74\x63\xd6"
+			  "\x17\xc9\xcc\x2f\x18\x64\xe0\x06"
+			  "\x0a\xa0\xff\x72\x10\x7b\x22",
+		.klen	=3D 16,
+		.len	=3D 31,
+	},
+	{
+		.key	=3D "\x59\x65\x3b\x1d\x43\x5e\xc0\xae"
+			  "\xb8\x9d\x9b\xdd\x22\x03\xbf\xca",
+		.iv	=3D "\xec\x95\xfa\x5a\xcf\x5e\xd2\x93"
+			  "\xa3\xb5\xe5\xbe\xf3\x01\x7b\x01"
+			  "\xd1\xca\x6c\x06\x82\xf0\xbd\x67"
+			  "\xd9\x6c\xa4\xdc\xb4\x38\x0f\x74",
+		.ptext	=3D "\x45\xdf\x75\x87\xbc\x72\xce\x55"
+			  "\xc9\xfa\xcb\xfc\x9f\x40\x82\x2b"
+			  "\xc6\x4f\x4f\x5b\x8b\x3b\x6d\x67"
+			  "\xa6\x93\x62\x89\x8c\x19\xf4\xe3"
+			  "\x08\x92\x9c\xc9\x47\x2c\x6e\xd0"
+			  "\xa3\x02\x2b\xdb\x2c\xf2\x8d\x46"
+			  "\xcd\xb0\x9d\x26\x63\x4c\x40\x6b"
+			  "\x79\x43\xe5\xce\x42\xa8\xec\x3b"
+			  "\x5b\xd0\xea\xa4\xe6\xdb\x66\x55"
+			  "\x7a\x76\xec\xab\x7d\x2a\x2b\xbd"
+			  "\xa9\xab\x22\x64\x1a\xa1\xae\x84"
+			  "\x86\x79\x67\xe9\xb2\x50\xbe\x12"
+			  "\x2f\xb2\x14\xf0\xdb\x71\xd8\xa7"
+			  "\x41\x8a\x88\xa0\x6a\x6e\x9d\x2a"
+			  "\xfa\x11\x37\x40\x32\x09\x4c\x47"
+			  "\x41\x07\x31\x85\x3d\xa8\xf7\x64",
+		.ctext	=3D "\x2d\x4b\x9f\x93\xca\x5a\x48\x26"
+			  "\x01\xcc\x54\xe4\x31\x50\x12\xf0"
+			  "\x49\xff\x59\x42\x68\xbd\x87\x8f"
+			  "\x9e\x62\x96\xcd\xb9\x24\x57\xa4"
+			  "\x0b\x7b\xf5\x2e\x0e\xa8\x65\x07"
+			  "\xab\x05\xd5\xca\xe7\x9c\x6c\x34"
+			  "\x5d\x42\x34\xa4\x62\xe9\x75\x48"
+			  "\x3d\x9e\x8f\xfa\x42\xe9\x75\x08"
+			  "\x4e\x54\x91\x2b\xbd\x11\x0f\x8e"
+			  "\xf0\x82\xf5\x24\xf1\xc4\xfc\xae"
+			  "\x42\x54\x7f\xce\x15\xa8\xb2\x33"
+			  "\xc0\x86\xb6\x2b\xe8\x44\xce\x1f"
+			  "\x68\x57\x66\x94\x6e\xad\xeb\xf3"
+			  "\x30\xf8\x11\xbd\x60\x00\xc6\xd5"
+			  "\x4c\x81\xf1\x20\x2b\x4a\x5b\x99"
+			  "\x79\x3b\xc9\x5c\x74\x23\xe6\x5d",
+		.klen	=3D 16,
+		.len	=3D 128,
+	},
+	{
+		.key	=3D "\x3e\x08\x5d\x64\x6c\x98\xec\xec"
+			  "\x70\x0e\x0d\xa1\x41\x20\x99\x82",
+		.iv	=3D "\x11\xb7\x77\x91\x0d\x99\xd9\x8d"
+			  "\x35\x3a\xf7\x14\x6b\x09\x37\xe5"
+			  "\xad\x51\xf6\xc3\x96\x4b\x64\x56"
+			  "\xa8\xbd\x81\xcc\xbe\x94\xaf\xe4",
+		.ptext	=3D "\xff\x8d\xb9\xc0\xe3\x69\xb3\xb2"
+			  "\x8b\x11\x26\xb3\x11\xec\xfb\xb9"
+			  "\x9c\xc1\x71\xd6\xe3\x26\x0e\xe0"
+			  "\x68\x40\x60\xb9\x3a\x63\x56\x8a"
+			  "\x9e\xc1\xf0\x10\xb1\x64\x32\x70"
+			  "\xf8\xcd\xc6\xc4\x49\x4c\xe1\xce"
+			  "\xf3\xe1\x03\xf8\x35\xae\xe0\x5e"
+			  "\xef\x5f\xbc\x41\x75\x26\x13\xcc"
+			  "\x37\x85\xdf\xc0\x5d\xa6\x47\x98"
+			  "\xf1\x97\x52\x58\x04\xe6\xb5\x01"
+			  "\xc0\xb8\x17\x6d\x74\xbd\x9a\xdf"
+			  "\xa4\x37\x94\x86\xb0\x13\x83\x28"
+			  "\xc9\xa2\x07\x3f\xb5\xb2\x72\x40"
+			  "\x0e\x60\xdf\x57\x07\xb7\x2c\x66"
+			  "\x10\x3f\x8d\xdd\x30\x0a\x47\xd5"
+			  "\xe8\x9d\xfb\xa1\xaf\x53\xd7\x05"
+			  "\xc7\xd2\xba\xe7\x2c\xa0\xbf\xb8"
+			  "\xd1\x93\xe7\x41\x82\xa3\x41\x3a"
+			  "\xaf\x12\xd6\xf8\x34\xda\x92\x46"
+			  "\xad\xa2\x2f\xf6\x7e\x46\x96\xd8"
+			  "\x03\xf3\x49\x64\xde\xd8\x06\x8b"
+			  "\xa0\xbc\x63\x35\x38\xb6\x6b\xda"
+			  "\x5b\x50\x3f\x13\xa5\x84\x1b\x1b"
+			  "\x66\x89\x95\xb7\xc2\x16\x3c\xe9"
+			  "\x24\xb0\x8c\x6f\x49\xef\xf7\x28"
+			  "\x6a\x24\xfd\xbe\x25\xe2\xb4\x90"
+			  "\x77\x44\x08\xb8\xda\xd2\xde\x2c"
+			  "\xa0\x57\x45\x57\x29\x47\x6b\x89"
+			  "\x4a\xf6\xa7\x2a\xc3\x9e\x7b\xc8"
+			  "\xfd\x9f\x89\xab\xee\x6d\xa3\xb4"
+			  "\x23\x90\x7a\xe9\x89\xa0\xc7\xb3"
+			  "\x17\x41\x87\x91\xfc\x97\x42",
+		.ctext	=3D "\xfc\x9b\x96\x66\xc4\x82\x2a\x4a"
+			  "\xb1\x24\xba\xc7\x78\x5f\x79\xc1"
+			  "\x57\x2e\x47\x29\x4d\x7b\xd2\x9a"
+			  "\xbd\xc6\xc1\x26\x7b\x8e\x3f\x5d"
+			  "\xd4\xb4\x9f\x6a\x02\x24\x4a\xad"
+			  "\x0c\x00\x1b\xdf\x92\xc5\x8a\xe1"
+			  "\x77\x79\xcc\xd5\x20\xbf\x83\xf4"
+			  "\x4b\xad\x11\xbf\xdb\x47\x65\x70"
+			  "\x43\xf3\x65\xdf\xb7\xdc\xb2\xb9"
+			  "\xaa\x3f\xb3\xdf\x79\x69\x0d\xa0"
+			  "\x86\x1c\xba\x48\x0b\x01\xc1\x88"
+			  "\xdf\x03\xb1\x06\x3c\x1d\x56\xa1"
+			  "\x8e\x98\xc1\xa6\x95\xa2\x5b\x72"
+			  "\x76\x59\xd2\x26\x25\xcd\xef\x7c"
+			  "\xc9\x60\xea\x43\xd1\x12\x8a\x8a"
+			  "\x63\x12\x78\xcb\x2f\x88\x1e\x88"
+			  "\x78\x59\xde\xba\x4d\x2c\x78\x61"
+			  "\x75\x37\x54\xfd\x80\xc7\x5e\x98"
+			  "\xcf\x14\x62\x8e\xfb\x72\xee\x4d"
+			  "\x9f\xaf\x8b\x09\xe5\x21\x0a\x91"
+			  "\x8f\x88\x87\xd5\xb1\x84\xab\x18"
+			  "\x08\x57\xed\x72\x35\xa6\x0e\xc6"
+			  "\xff\xcb\xfe\x2c\x48\x39\x14\x44"
+			  "\xba\x59\x32\x3a\x2d\xc4\x5f\xcb"
+			  "\xbe\x68\x8e\x7b\xee\x21\xa4\x32"
+			  "\x11\xa0\x99\xfd\x90\xde\x59\x43"
+			  "\xeb\xed\xd5\x87\x68\x46\xc6\xde"
+			  "\x0b\x07\x17\x59\x6a\xab\xca\x15"
+			  "\x65\x02\x01\xb6\x71\x8c\x3b\xaa"
+			  "\x18\x3b\x30\xae\x38\x5b\x2c\x74"
+			  "\xd4\xee\x4a\xfc\xf7\x1b\x09\xd4"
+			  "\xda\x8b\x1d\x5d\x6f\x21\x6c",
+		.klen	=3D 16,
+		.len	=3D 255,
+	},
+	{
+		.key	=3D "\x24\xf6\xe1\x62\xe5\xaf\x99\xda"
+			  "\x84\xec\x41\xb0\xa3\x0b\xd5\xa8"
+			  "\xa0\x3e\x7b\xa6\xdd\x6c\x8f\xa8",
+		.iv	=3D "\x7f\x80\x24\x62\x32\xdd\xab\x66"
+			  "\xf2\x87\x29\x24\xec\xd2\x4b\x9f"
+			  "\x0c\x33\x52\xd9\xe0\xcc\x6e\xe4"
+			  "\x90\x85\x43\x97\xc4\x62\x14\x33",
+		.ptext	=3D "\xef\x58\xe7\x7f\xa9\xd9\xb8\xd7"
+			  "\xa2\x91\x97\x07\x27\x9e\xba\xe8"
+			  "\xaa",
+		.ctext	=3D "\xd7\xc3\x81\x91\xf2\x40\x17\x73"
+			  "\x3e\x3b\x1c\x2a\x8e\x11\x9c\x17"
+			  "\xf1",
+		.klen	=3D 24,
+		.len	=3D 17,
+	},
+	{
+		.key	=3D "\xbf\xaf\xd7\x67\x8c\x47\xcf\x21"
+			  "\x8a\xa5\xdd\x32\x25\x47\xbe\x4f"
+			  "\xf1\x3a\x0b\xa6\xaa\x2d\xcf\x09",
+		.iv	=3D "\xd9\xe8\xf0\x92\x4e\xfc\x1d\xf2"
+			  "\x81\x37\x7c\x8f\xf1\x59\x09\x20"
+			  "\xf4\x46\x51\x86\x4f\x54\x8b\x32"
+			  "\x58\xd1\x99\x8b\x8c\x03\xeb\x5d",
+		.ptext	=3D "\xcd\x64\x90\xf9\x7c\xe5\x0e\x5a"
+			  "\x75\xe7\x8e\x39\x86\xec\x20\x43"
+			  "\x8a\x49\x09\x15\x47\xf4\x3c\x89"
+			  "\x21\xeb\xcf\x4e\xcf\x91\xb5\x40"
+			  "\xcd\xe5\x4d\x5c\x6f\xf2\xd2\x80"
+			  "\xfa\xab\xb3\x76\x9f\x7f\x84\x0a",
+		.ctext	=3D "\x44\x98\x64\x15\xb7\x0b\x80\xa3"
+			  "\xb9\xca\x23\xff\x3b\x0b\x68\x74"
+			  "\xbb\x3e\x20\x19\x9f\x28\x71\x2a"
+			  "\x48\x3c\x7c\xe2\xef\xb5\x10\xac"
+			  "\x82\x9f\xcd\x08\x8f\x6b\x16\x6f"
+			  "\xc3\xbb\x07\xfb\x3c\xb0\x1b\x27",
+		.klen	=3D 24,
+		.len	=3D 48,
+	},
+	{
+		.key	=3D "\xb8\x35\xa2\x5f\x86\xbb\x82\x99"
+			  "\x27\xeb\x01\x3f\x92\xaf\x80\x24"
+			  "\x4c\x66\xa2\x89\xff\x2e\xa2\x25",
+		.iv	=3D "\x0a\x1d\x96\xd3\xe0\xe8\x0c\x9b"
+			  "\x9d\x6f\x21\x97\xc2\x17\xdb\x39"
+			  "\x3f\xd8\x64\x48\x80\x04\xee\x43"
+			  "\x02\xce\x88\xe2\x81\x81\x5f\x81",
+		.ptext	=3D "\xb8\xf9\x16\x8b\x25\x68\xd0\x9c"
+			  "\xd2\x28\xac\xa8\x79\xc2\x30\xc1"
+			  "\x31\xde\x1c\x37\x1b\xa2\xb5\xe6"
+			  "\xf0\xd0\xf8\x9c\x7f\xc6\x46\x07"
+			  "\x5c\xc3\x06\xe4\xf0\x02\xec\xf8"
+			  "\x59\x7c\xc2\x5d\xf8\x0c\x21\xae"
+			  "\x9e\x82\xb1\x1a\x5f\x78\x44\x15"
+			  "\x00\xa7\x2e\x52\xc5\x98\x98\x35"
+			  "\x03\xae\xd0\x8e\x07\x57\xe2\x5a"
+			  "\x17\xbf\x52\x40\x54\x5b\x74\xe5"
+			  "\x2d\x35\xaf\x9e\x37\xf7\x7e\x4a"
+			  "\x8c\x9e\xa1\xdc\x40\xb4\x5b\x36"
+			  "\xdc\x3a\x68\xe6\xb7\x35\x0b\x8a"
+			  "\x90\xec\x74\x8f\x09\x9a\x7f\x02"
+			  "\x4d\x03\x46\x35\x62\xb1\xbd\x08"
+			  "\x3f\x54\x2a\x10\x0b\xdc\x69\xaf"
+			  "\x25\x3a\x0c\x5f\xe0\x51\xe7\x11"
+			  "\xb7\x00\xab\xbb\x9a\xb0\xdc\x4d"
+			  "\xc3\x7d\x1a\x6e\xd1\x09\x52\xbd"
+			  "\x6b\x43\x55\x22\x3a\x78\x14\x7d"
+			  "\x79\xfd\x8d\xfc\x9b\x1d\x0f\xa2"
+			  "\xc7\xb9\xf8\x87\xd5\x96\x50\x61"
+			  "\xa7\x5e\x1e\x57\x97\xe0\xad\x2f"
+			  "\x93\xe6\xe8\x83\xec\x85\x26\x5e"
+			  "\xd9\x2a\x15\xe0\xe9\x09\x25\xa1"
+			  "\x77\x2b\x88\xdc\xa4\xa5\x48\xb6"
+			  "\xf7\xcc\xa6\xa9\xba\xf3\x42\x5c"
+			  "\x70\x9d\xe9\x29\xc1\xf1\x33\xdd"
+			  "\x56\x48\x17\x86\x14\x51\x5c\x10"
+			  "\xab\xfd\xd3\x26\x8c\x21\xf5\x93"
+			  "\x1b\xeb\x47\x97\x73\xbb\x88\x10"
+			  "\xf3\xfe\xf5\xde\xf3\x2e\x05\x46"
+			  "\x1c\x0d\xa3\x10\x48\x9c\x71\x16"
+			  "\x78\x33\x4d\x0a\x74\x3b\xe9\x34"
+			  "\x0b\xa7\x0e\x9e\x61\xe9\xe9\xfd"
+			  "\x85\xa0\xcb\x19\xfd\x7c\x33\xe3"
+			  "\x0e\xce\xc2\x6f\x9d\xa4\x2d\x77"
+			  "\xfd\xad\xee\x5e\x08\x3e\xd7\xf5"
+			  "\xfb\xc3\xd7\x93\x96\x08\x96\xca"
+			  "\x58\x81\x16\x9b\x98\x0a\xe2\xef"
+			  "\x7f\xda\x40\xe4\x1f\x46\x9e\x67"
+			  "\x2b\x84\xcb\x42\xc4\xd6\x6a\xcf"
+			  "\x2d\xb2\x33\xc0\x56\xb3\x35\x6f"
+			  "\x29\x36\x8f\x6a\x5b\xec\xd5\x4f"
+			  "\xa0\x70\xff\xb6\x5b\xde\x6a\x93"
+			  "\x20\x3c\xe2\x76\x7a\xef\x3c\x79"
+			  "\x31\x65\xce\x3a\x0e\xd0\xbe\xa8"
+			  "\x21\x95\xc7\x2b\x62\x8e\x67\xdd"
+			  "\x20\x79\xe4\xe5\x01\x15\xc0\xec"
+			  "\x0f\xd9\x23\xc8\xca\xdf\xd4\x7d"
+			  "\x1d\xf8\x64\x4f\x56\xb1\x83\xa7"
+			  "\x43\xbe\xfc\xcf\xc2\x8c\x33\xda"
+			  "\x36\xd0\x52\xef\x9e\x9e\x88\xf4"
+			  "\xa8\x21\x0f\xaa\xee\x8d\xa0\x24"
+			  "\x4d\xcb\xb1\x72\x07\xf0\xc2\x06"
+			  "\x60\x65\x85\x84\x2c\x60\xcf\x61"
+			  "\xe7\x56\x43\x5b\x2b\x50\x74\xfa"
+			  "\xdb\x4e\xea\x88\xd4\xb3\x83\x8f"
+			  "\x6f\x97\x4b\x57\x7a\x64\x64\xae"
+			  "\x0a\x37\x66\xc5\x03\xad\xb5\xf9"
+			  "\x08\xb0\x3a\x74\xde\x97\x51\xff"
+			  "\x48\x4f\x5c\xa4\xf8\x7a\xb4\x05"
+			  "\x27\x70\x52\x86\x1b\x78\xfc\x18"
+			  "\x06\x27\xa9\x62\xf7\xda\xd2\x8e",
+		.ctext	=3D "\x3b\xe1\xdb\xb3\xc5\x9a\xde\x69"
+			  "\x58\x05\xcc\xeb\x02\x51\x78\x4a"
+			  "\xac\x28\xe9\xed\xd1\xc9\x15\x7d"
+			  "\x33\x7d\xc1\x47\x12\x41\x11\xf8"
+			  "\x4a\x2c\xb7\xa3\x41\xbe\x59\xf7"
+			  "\x22\xdb\x2c\xda\x9c\x00\x61\x9b"
+			  "\x73\xb3\x0b\x84\x2b\xc1\xf3\x80"
+			  "\x84\xeb\x19\x60\x80\x09\xe1\xcd"
+			  "\x16\x3a\x20\x23\xc4\x82\x4f\xba"
+			  "\x3b\x8e\x55\xd7\xa9\x0b\x75\xd0"
+			  "\xda\xce\xd2\xee\x7e\x4b\x7f\x65"
+			  "\x4d\x28\xc5\xd3\x15\x2c\x40\x96"
+			  "\x52\xd4\x18\x61\x2b\xe7\x83\xec"
+			  "\x89\x62\x9c\x4c\x50\xe6\xe2\xbb"
+			  "\x25\xa1\x0f\xa7\xb0\xb4\xb2\xde"
+			  "\x54\x20\xae\xa3\x56\xa5\x26\x4c"
+			  "\xd5\xcc\xe5\xcb\x28\x44\xb1\xef"
+			  "\x67\x2e\x93\x6d\x00\x88\x83\x9a"
+			  "\xf2\x1c\x48\x38\xec\x1a\x24\x90"
+			  "\x73\x0a\xdb\xe8\xce\x95\x7a\x2c"
+			  "\x8c\xe9\xb7\x07\x1d\xb3\xa3\x20"
+			  "\xbe\xad\x61\x84\xac\xde\x76\xb5"
+			  "\xa6\x28\x29\x47\x63\xc4\xfc\x13"
+			  "\x3f\x71\xfb\x58\x37\x34\x82\xed"
+			  "\x9e\x05\x19\x1f\xc1\x67\xc1\xab"
+			  "\xf5\xfd\x7c\xea\xfa\xa4\xf8\x0a"
+			  "\xac\x4c\x92\xdf\x65\x73\xd7\xdb"
+			  "\xed\x2c\xe0\x84\x5f\x57\x8c\x76"
+			  "\x3e\x05\xc0\xc3\x68\x96\x95\x0b"
+			  "\x88\x97\xfe\x2e\x99\xd5\xc2\xb9"
+			  "\x53\x9f\xf3\x32\x10\x1f\x1f\x5d"
+			  "\xdf\x21\x95\x70\x91\xe8\xa1\x3e"
+			  "\x19\x3e\xb6\x0b\xa8\xdb\xf8\xd4"
+			  "\x54\x27\xb8\xab\x5d\x78\x0c\xe6"
+			  "\xb7\x08\xee\xa4\xb6\x6b\xeb\x5a"
+			  "\x89\x69\x2b\xbd\xd4\x21\x5b\xbf"
+			  "\x79\xbb\x0f\xff\xdb\x23\x9a\xeb"
+			  "\x8d\xf2\xc4\x39\xb4\x90\x77\x6f"
+			  "\x68\xe2\xb8\xf3\xf1\x65\x4f\xd5"
+			  "\x24\x80\x06\xaf\x7c\x8d\x15\x0c"
+			  "\xfd\x56\xe5\xe3\x01\xa5\xf7\x1c"
+			  "\x31\xd6\xa2\x01\x1e\x59\xf9\xa9"
+			  "\x42\xd5\xc2\x34\xda\x25\xde\xc6"
+			  "\x5d\x38\xef\xd1\x4c\xc1\xd9\x1b"
+			  "\x98\xfd\xcd\x57\x6f\xfd\x46\x91"
+			  "\x90\x3d\x52\x2b\x2c\x7d\xcf\x71"
+			  "\xcf\xd1\x77\x23\x71\x36\xb1\xce"
+			  "\xc7\x5d\xf0\x5b\x44\x3d\x43\x71"
+			  "\xac\xb8\xa0\x6a\xea\x89\x5c\xff"
+			  "\x81\x73\xd4\x83\xd1\xc9\xe9\xe2"
+			  "\xa8\xa6\x0f\x36\xe6\xaa\x57\xd4"
+			  "\x27\xd2\xc9\xda\x94\x02\x1f\xfb"
+			  "\xe1\xa1\x07\xbe\xe1\x1b\x15\x94"
+			  "\x1e\xac\x2f\x57\xbb\x41\x22\xaf"
+			  "\x60\x5e\xcc\x66\xcb\x16\x62\xab"
+			  "\xb8\x7c\x99\xf4\x84\x93\x0c\xc2"
+			  "\xa2\x49\xe4\xfd\x17\x55\xe1\xa6"
+			  "\x8d\x5b\xc6\x1b\xc8\xac\xec\x11"
+			  "\x33\xcf\xb0\xe8\xc7\x28\x4f\xb2"
+			  "\x5c\xa6\xe2\x71\xab\x80\x0a\xa7"
+			  "\x5c\x59\x50\x9f\x7a\x32\xb7\xe5"
+			  "\x24\x9a\x8e\x25\x21\x2e\xb7\x18"
+			  "\xd0\xf2\xe7\x27\x6f\xda\xc1\x00"
+			  "\xd9\xa6\x03\x59\xac\x4b\xcb\xba",
+		.klen	=3D 24,
+		.len	=3D 512,
+	},
+	{
+		.key	=3D "\x9e\xeb\xb2\x49\x3c\x1c\xf5\xf4"
+			  "\x6a\x99\xc2\xc4\xdf\xb1\xf4\xdd"
+			  "\x75\x20\x57\xea\x2c\x4f\xcd\xb2"
+			  "\xa5\x3d\x7b\x49\x1e\xab\xfd\x0f",
+		.iv	=3D "\xdf\x63\xd4\xab\xd2\x49\xf3\xd8"
+			  "\x33\x81\x37\x60\x7d\xfa\x73\x08"
+			  "\xd8\x49\x6d\x80\xe8\x2f\x62\x54"
+			  "\xeb\x0e\xa9\x39\x5b\x45\x7f\x8a",
+		.ptext	=3D "\x67\xc9\xf2\x30\x84\x41\x8e\x43"
+			  "\xfb\xf3\xb3\x3e\x79\x36\x7f\xe8",
+		.ctext	=3D "\x27\x38\x78\x47\x16\xd9\x71\x35"
+			  "\x2e\x7e\xdd\x7e\x43\x3c\xb8\x40",
+		.klen	=3D 32,
+		.len	=3D 16,
+	},
+	{
+		.key	=3D "\x93\xfa\x7e\xe2\x0e\x67\xc4\x39"
+			  "\xe7\xca\x47\x95\x68\x9d\x5e\x5a"
+			  "\x7c\x26\x19\xab\xc6\xca\x6a\x4c"
+			  "\x45\xa6\x96\x42\xae\x6c\xff\xe7",
+		.iv	=3D "\xea\x82\x47\x95\x3b\x22\xa1\x3a"
+			  "\x6a\xca\x24\x4c\x50\x7e\x23\xcd"
+			  "\x0e\x50\xe5\x41\xb6\x65\x29\xd8"
+			  "\x30\x23\x00\xd2\x54\xa7\xd6\x56",
+		.ptext	=3D "\xdb\x1f\x1f\xec\xad\x83\x6e\x5d"
+			  "\x19\xa5\xf6\x3b\xb4\x93\x5a\x57"
+			  "\x6f",
+		.ctext	=3D "\xf1\x46\x6e\x9d\xb3\x01\xf0\x6b"
+			  "\xc2\xac\x57\x88\x48\x6d\x40\x72"
+			  "\x68",
+		.klen	=3D 32,
+		.len	=3D 17,
+	},
+	{
+		.key	=3D "\x36\x2b\x57\x97\xf8\x5d\xcd\x99"
+			  "\x5f\x1a\x5a\x44\x1d\x92\x0f\x27"
+			  "\xcc\x16\xd7\x2b\x85\x63\x99\xd3"
+			  "\xba\x96\xa1\xdb\xd2\x60\x68\xda",
+		.iv	=3D "\xef\x58\x69\xb1\x2c\x5e\x9a\x47"
+			  "\x24\xc1\xb1\x69\xe1\x12\x93\x8f"
+			  "\x43\x3d\x6d\x00\xdb\x5e\xd8\xd9"
+			  "\x12\x9a\xfe\xd9\xff\x2d\xaa\xc4",
+		.ptext	=3D "\x5e\xa8\x68\x19\x85\x98\x12\x23"
+			  "\x26\x0a\xcc\xdb\x0a\x04\xb9\xdf"
+			  "\x4d\xb3\x48\x7b\xb0\xe3\xc8\x19"
+			  "\x43\x5a\x46\x06\x94\x2d\xf2",
+		.ctext	=3D "\xdb\xfd\xc8\x03\xd0\xec\xc1\xfe"
+			  "\xbd\x64\x37\xb8\x82\x43\x62\x4e"
+			  "\x7e\x54\xa3\xe2\x24\xa7\x27\xe8"
+			  "\xa4\xd5\xb3\x6c\xb2\x26\xb4",
+		.klen	=3D 32,
+		.len	=3D 31,
+	},
+	{
+		.key	=3D "\x03\x65\x03\x6e\x4d\xe6\xe8\x4e"
+			  "\x8b\xbe\x22\x19\x48\x31\xee\xd9"
+			  "\xa0\x91\x21\xbe\x62\x89\xde\x78"
+			  "\xd9\xb0\x36\xa3\x3c\xce\x43\xd5",
+		.iv	=3D "\xa9\xc3\x4b\xe7\x0f\xfc\x6d\xbf"
+			  "\x56\x27\x21\x1c\xfc\xd6\x04\x10"
+			  "\x5f\x43\xe2\x30\x35\x29\x6c\x10"
+			  "\x90\xf1\xbf\x61\xed\x0f\x8a\x91",
+		.ptext	=3D "\x07\xaa\x02\x26\xb4\x98\x11\x5e"
+			  "\x33\x41\x21\x51\x51\x63\x2c\x72"
+			  "\x00\xab\x32\xa7\x1c\xc8\x3c\x9c"
+			  "\x25\x0e\x8b\x9a\xdf\x85\xed\x2d"
+			  "\xf4\xf2\xbc\x55\xca\x92\x6d\x22"
+			  "\xfd\x22\x3b\x42\x4c\x0b\x74\xec",
+		.ctext	=3D "\x7b\xb1\x43\x6d\xd8\x72\x6c\xf6"
+			  "\x67\x6a\x00\xc4\xf1\xf0\xf5\xa4"
+			  "\xfc\x60\x91\xab\x46\x0b\x15\xfc"
+			  "\xd7\xc1\x28\x15\xa1\xfc\xf7\x68"
+			  "\x8e\xcc\x27\x62\x00\x64\x56\x72"
+			  "\xa6\x17\xd7\x3f\x67\x80\x10\x58",
+		.klen	=3D 32,
+		.len	=3D 48,
+	},
+	{
+		.key	=3D "\xa5\x28\x24\x34\x1a\x3c\xd8\xf7"
+			  "\x05\x91\x8f\xee\x85\x1f\x35\x7f"
+			  "\x80\x3d\xfc\x9b\x94\xf6\xfc\x9e"
+			  "\x19\x09\x00\xa9\x04\x31\x4f\x11",
+		.iv	=3D "\xa1\xba\x49\x95\xff\x34\x6d\xb8"
+			  "\xcd\x87\x5d\x5e\xfd\xea\x85\xdb"
+			  "\x8a\x7b\x5e\xb2\x5d\x57\xdd\x62"
+			  "\xac\xa9\x8c\x41\x42\x94\x75\xb7",
+		.ptext	=3D "\x69\xb4\xe8\x8c\x37\xe8\x67\x82"
+			  "\xf1\xec\x5d\x04\xe5\x14\x91\x13"
+			  "\xdf\xf2\x87\x1b\x69\x81\x1d\x71"
+			  "\x70\x9e\x9c\x3b\xde\x49\x70\x11"
+			  "\xa0\xa3\xdb\x0d\x54\x4f\x66\x69"
+			  "\xd7\xdb\x80\xa7\x70\x92\x68\xce"
+			  "\x81\x04\x2c\xc6\xab\xae\xe5\x60"
+			  "\x15\xe9\x6f\xef\xaa\x8f\xa7\xa7"
+			  "\x63\x8f\xf2\xf0\x77\xf1\xa8\xea"
+			  "\xe1\xb7\x1f\x9e\xab\x9e\x4b\x3f"
+			  "\x07\x87\x5b\x6f\xcd\xa8\xaf\xb9"
+			  "\xfa\x70\x0b\x52\xb8\xa8\xa7\x9e"
+			  "\x07\x5f\xa6\x0e\xb3\x9b\x79\x13"
+			  "\x79\xc3\x3e\x8d\x1c\x2c\x68\xc8"
+			  "\x51\x1d\x3c\x7b\x7d\x79\x77\x2a"
+			  "\x56\x65\xc5\x54\x23\x28\xb0\x03",
+		.ctext	=3D "\xeb\xf9\x98\x86\x3c\x40\x9f\x16"
+			  "\x84\x01\xf9\x06\x0f\xeb\x3c\xa9"
+			  "\x4c\xa4\x8e\x5d\xc3\x8d\xe5\xd3"
+			  "\xae\xa6\xe6\xcc\xd6\x2d\x37\x4f"
+			  "\x99\xc8\xa3\x21\x46\xb8\x69\xf2"
+			  "\xe3\x14\x89\xd7\xb9\xf5\x9e\x4e"
+			  "\x07\x93\x6f\x78\x8e\x6b\xea\x8f"
+			  "\xfb\x43\xb8\x3e\x9b\x4c\x1d\x7e"
+			  "\x20\x9a\xc5\x87\xee\xaf\xf6\xf9"
+			  "\x46\xc5\x18\x8a\xe8\x69\xe7\x96"
+			  "\x52\x55\x5f\x00\x1e\x1a\xdc\xcc"
+			  "\x13\xa5\xee\xff\x4b\x27\xca\xdc"
+			  "\x10\xa6\x48\x76\x98\x43\x94\xa3"
+			  "\xc7\xe2\xc9\x65\x9b\x08\x14\x26"
+			  "\x1d\x68\xfb\x15\x0a\x33\x49\x84"
+			  "\x84\x33\x5a\x1b\x24\x46\x31\x92",
+		.klen	=3D 32,
+		.len	=3D 128,
+	},
+	{
+		.key	=3D "\x36\x45\x11\xa2\x98\x5f\x96\x7c"
+			  "\xc6\xb4\x94\x31\x0a\x67\x09\x32"
+			  "\x6c\x6f\x6f\x00\xf0\x17\xcb\xac"
+			  "\xa5\xa9\x47\x9e\x2e\x85\x2f\xfa",
+		.iv	=3D "\x28\x88\xaa\x9b\x59\x3b\x1e\x97"
+			  "\x82\xe5\x5c\x9e\x6d\x14\x11\x19"
+			  "\x6e\x38\x8f\xd5\x40\x2b\xca\xf9"
+			  "\x7b\x4c\xe4\xa3\xd0\xd2\x8a\x13",
+		.ptext	=3D "\x95\xd2\xf7\x71\x1b\xca\xa5\x86"
+			  "\xd9\x48\x01\x93\x2f\x79\x55\x29"
+			  "\x71\x13\x15\x0e\xe6\x12\xbc\x4d"
+			  "\x8a\x31\xe3\x40\x2a\xc6\x5e\x0d"
+			  "\x68\xbb\x4a\x62\x8d\xc7\x45\x77"
+			  "\xd2\xb8\xc7\x1d\xf1\xd2\x5d\x97"
+			  "\xcf\xac\x52\xe5\x32\x77\xb6\xda"
+			  "\x30\x85\xcf\x2b\x98\xe9\xaa\x34"
+			  "\x62\xb5\x23\x9e\xb7\xa6\xd4\xe0"
+			  "\xb4\x58\x18\x8c\x4d\xde\x4d\x01"
+			  "\x83\x89\x24\xca\xfb\x11\xd4\x82"
+			  "\x30\x7a\x81\x35\xa0\xb4\xd4\xb6"
+			  "\x84\xea\x47\x91\x8c\x19\x86\x25"
+			  "\xa6\x06\x8d\x78\xe6\xed\x87\xeb"
+			  "\xda\xea\x73\x7c\xbf\x66\xb8\x72"
+			  "\xe3\x0a\xb8\x0c\xcb\x1a\x73\xf1"
+			  "\xa7\xca\x0a\xde\x57\x2b\xbd\x2b"
+			  "\xeb\x8b\x24\x38\x22\xd3\x0e\x1f"
+			  "\x17\xa0\x84\x98\x31\x77\xfd\x34"
+			  "\x6a\x4e\x3d\x84\x4c\x0e\xfb\xed"
+			  "\xc8\x2a\x51\xfa\xd8\x73\x21\x8a"
+			  "\xdb\xb5\xfe\x1f\xee\xc4\xe8\x65"
+			  "\x54\x84\xdd\x96\x6d\xfd\xd3\x31"
+			  "\x77\x36\x52\x6b\x80\x4f\x9e\xb4"
+			  "\xa2\x55\xbf\x66\x41\x49\x4e\x87"
+			  "\xa7\x0c\xca\xe7\xa5\xc5\xf6\x6f"
+			  "\x27\x56\xe2\x48\x22\xdd\x5f\x59"
+			  "\x3c\xf1\x9f\x83\xe5\x2d\xfb\x71"
+			  "\xad\xd1\xae\x1b\x20\x5c\x47\xb7"
+			  "\x3b\xd3\x14\xce\x81\x42\xb1\x0a"
+			  "\xf0\x49\xfa\xc2\xe7\x86\xbf\xcd"
+			  "\xb0\x95\x9f\x8f\x79\x41\x54",
+		.ctext	=3D "\xf6\x57\x51\xc4\x25\x61\x2d\xfa"
+			  "\xd6\xd9\x3f\x9a\x81\x51\xdd\x8e"
+			  "\x3d\xe7\xaa\x2d\xb1\xda\xc8\xa6"
+			  "\x9d\xaa\x3c\xab\x62\xf2\x80\xc3"
+			  "\x2c\xe7\x58\x72\x1d\x44\xc5\x28"
+			  "\x7f\xb4\xf9\xbc\x9c\xb2\xab\x8e"
+			  "\xfa\xd1\x4d\x72\xd9\x79\xf5\xa0"
+			  "\x24\x3e\x90\x25\x31\x14\x38\x45"
+			  "\x59\xc8\xf6\xe2\xc6\xf6\xc1\xa7"
+			  "\xb2\xf8\xa7\xa9\x2b\x6f\x12\x3a"
+			  "\xb0\x81\xa4\x08\x57\x59\xb1\x56"
+			  "\x4c\x8f\x18\x55\x33\x5f\xd6\x6a"
+			  "\xc6\xa0\x4b\xd6\x6b\x64\x3e\x9e"
+			  "\xfd\x66\x16\xe2\xdb\xeb\x5f\xb3"
+			  "\x50\x50\x3e\xde\x8d\x72\x76\x01"
+			  "\xbe\xcc\xc9\x52\x09\x2d\x8d\xe7"
+			  "\xd6\xc3\x66\xdb\x36\x08\xd1\x77"
+			  "\xc8\x73\x46\x26\x24\x29\xbf\x68"
+			  "\x2d\x2a\x99\x43\x56\x55\xe4\x93"
+			  "\xaf\xae\x4d\xe7\x55\x4a\xc0\x45"
+			  "\x26\xeb\x3b\x12\x90\x7c\xdc\xd1"
+			  "\xd5\x6f\x0a\xd0\xa9\xd7\x4b\x89"
+			  "\x0b\x07\xd8\x86\xad\xa1\xc4\x69"
+			  "\x1f\x5e\x8b\xc4\x9e\x91\x41\x25"
+			  "\x56\x98\x69\x78\x3a\x9e\xae\x91"
+			  "\xd8\xd9\xfa\xfb\xff\x81\x25\x09"
+			  "\xfc\xed\x2d\x87\xbc\x04\x62\x97"
+			  "\x35\xe1\x26\xc2\x46\x1c\xcf\xd7"
+			  "\x14\xed\x02\x09\xa5\xb2\xb6\xaa"
+			  "\x27\x4e\x61\xb3\x71\x6b\x47\x16"
+			  "\xb7\xe8\xd4\xaf\x52\xeb\x6a\x6b"
+			  "\xdb\x4c\x65\x21\x9e\x1c\x36",
+		.klen	=3D 32,
+		.len	=3D 255,
+	},
+	{
+		.key	=3D "\xd3\x81\x72\x18\x23\xff\x6f\x4a"
+			  "\x25\x74\x29\x0d\x51\x8a\x0e\x13"
+			  "\xc1\x53\x5d\x30\x8d\xee\x75\x0d"
+			  "\x14\xd6\x69\xc9\x15\xa9\x0c\x60",
+		.iv	=3D "\x65\x9b\xd4\xa8\x7d\x29\x1d\xf4"
+			  "\xc4\xd6\x9b\x6a\x28\xab\x64\xe2"
+			  "\x62\x81\x97\xc5\x81\xaa\xf9\x44"
+			  "\xc1\x72\x59\x82\xaf\x16\xc8\x2c",
+		.ptext	=3D "\xc7\x6b\x52\x6a\x10\xf0\xcc\x09"
+			  "\xc1\x12\x1d\x6d\x21\xa6\x78\xf5"
+			  "\x05\xa3\x69\x60\x91\x36\x98\x57"
+			  "\xba\x0c\x14\xcc\xf3\x2d\x73\x03"
+			  "\xc6\xb2\x5f\xc8\x16\x27\x37\x5d"
+			  "\xd0\x0b\x87\xb2\x50\x94\x7b\x58"
+			  "\x04\xf4\xe0\x7f\x6e\x57\x8e\xc9"
+			  "\x41\x84\xc1\xb1\x7e\x4b\x91\x12"
+			  "\x3a\x8b\x5d\x50\x82\x7b\xcb\xd9"
+			  "\x9a\xd9\x4e\x18\x06\x23\x9e\xd4"
+			  "\xa5\x20\x98\xef\xb5\xda\xe5\xc0"
+			  "\x8a\x6a\x83\x77\x15\x84\x1e\xae"
+			  "\x78\x94\x9d\xdf\xb7\xd1\xea\x67"
+			  "\xaa\xb0\x14\x15\xfa\x67\x21\x84"
+			  "\xd3\x41\x2a\xce\xba\x4b\x4a\xe8"
+			  "\x95\x62\xa9\x55\xf0\x80\xad\xbd"
+			  "\xab\xaf\xdd\x4f\xa5\x7c\x13\x36"
+			  "\xed\x5e\x4f\x72\xad\x4b\xf1\xd0"
+			  "\x88\x4e\xec\x2c\x88\x10\x5e\xea"
+			  "\x12\xc0\x16\x01\x29\xa3\xa0\x55"
+			  "\xaa\x68\xf3\xe9\x9d\x3b\x0d\x3b"
+			  "\x6d\xec\xf8\xa0\x2d\xf0\x90\x8d"
+			  "\x1c\xe2\x88\xd4\x24\x71\xf9\xb3"
+			  "\xc1\x9f\xc5\xd6\x76\x70\xc5\x2e"
+			  "\x9c\xac\xdb\x90\xbd\x83\x72\xba"
+			  "\x6e\xb5\xa5\x53\x83\xa9\xa5\xbf"
+			  "\x7d\x06\x0e\x3c\x2a\xd2\x04\xb5"
+			  "\x1e\x19\x38\x09\x16\xd2\x82\x1f"
+			  "\x75\x18\x56\xb8\x96\x0b\xa6\xf9"
+			  "\xcf\x62\xd9\x32\x5d\xa9\xd7\x1d"
+			  "\xec\xe4\xdf\x1b\xbe\xf1\x36\xee"
+			  "\xe3\x7b\xb5\x2f\xee\xf8\x53\x3d"
+			  "\x6a\xb7\x70\xa9\xfc\x9c\x57\x25"
+			  "\xf2\x89\x10\xd3\xb8\xa8\x8c\x30"
+			  "\xae\x23\x4f\x0e\x13\x66\x4f\xe1"
+			  "\xb6\xc0\xe4\xf8\xef\x93\xbd\x6e"
+			  "\x15\x85\x6b\xe3\x60\x81\x1d\x68"
+			  "\xd7\x31\x87\x89\x09\xab\xd5\x96"
+			  "\x1d\xf3\x6d\x67\x80\xca\x07\x31"
+			  "\x5d\xa7\xe4\xfb\x3e\xf2\x9b\x33"
+			  "\x52\x18\xc8\x30\xfe\x2d\xca\x1e"
+			  "\x79\x92\x7a\x60\x5c\xb6\x58\x87"
+			  "\xa4\x36\xa2\x67\x92\x8b\xa4\xb7"
+			  "\xf1\x86\xdf\xdc\xc0\x7e\x8f\x63"
+			  "\xd2\xa2\xdc\x78\xeb\x4f\xd8\x96"
+			  "\x47\xca\xb8\x91\xf9\xf7\x94\x21"
+			  "\x5f\x9a\x9f\x5b\xb8\x40\x41\x4b"
+			  "\x66\x69\x6a\x72\xd0\xcb\x70\xb7"
+			  "\x93\xb5\x37\x96\x05\x37\x4f\xe5"
+			  "\x8c\xa7\x5a\x4e\x8b\xb7\x84\xea"
+			  "\xc7\xfc\x19\x6e\x1f\x5a\xa1\xac"
+			  "\x18\x7d\x52\x3b\xb3\x34\x62\x99"
+			  "\xe4\x9e\x31\x04\x3f\xc0\x8d\x84"
+			  "\x17\x7c\x25\x48\x52\x67\x11\x27"
+			  "\x67\xbb\x5a\x85\xca\x56\xb2\x5c"
+			  "\xe6\xec\xd5\x96\x3d\x15\xfc\xfb"
+			  "\x22\x25\xf4\x13\xe5\x93\x4b\x9a"
+			  "\x77\xf1\x52\x18\xfa\x16\x5e\x49"
+			  "\x03\x45\xa8\x08\xfa\xb3\x41\x92"
+			  "\x79\x50\x33\xca\xd0\xd7\x42\x55"
+			  "\xc3\x9a\x0c\x4e\xd9\xa4\x3c\x86"
+			  "\x80\x9f\x53\xd1\xa4\x2e\xd1\xbc"
+			  "\xf1\x54\x6e\x93\xa4\x65\x99\x8e"
+			  "\xdf\x29\xc0\x64\x63\x07\xbb\xea",
+		.ctext	=3D "\x9f\x72\x87\xc7\x17\xfb\x20\x15"
+			  "\x65\xb3\x55\xa8\x1c\x8e\x52\x32"
+			  "\xb1\x82\x8d\xbf\xb5\x9f\x10\x0a"
+			  "\xe8\x0c\x70\x62\xef\x89\xb6\x1f"
+			  "\x73\xcc\xe4\xcc\x7a\x3a\x75\x4a"
+			  "\x26\xe7\xf5\xd7\x7b\x17\x39\x2d"
+			  "\xd2\x27\x6e\xf9\x2f\x9e\xe2\xf6"
+			  "\xfa\x16\xc2\xf2\x49\x26\xa7\x5b"
+			  "\xe7\xca\x25\x0e\x45\xa0\x34\xc2"
+			  "\x9a\x37\x79\x7e\x7c\x58\x18\x94"
+			  "\x10\xa8\x7c\x48\xa9\xd7\x63\x89"
+			  "\x9e\x61\x4d\x26\x34\xd9\xf0\xb1"
+			  "\x2d\x17\x2c\x6f\x7c\x35\x0e\xbe"
+			  "\x77\x71\x7c\x17\x5b\xab\x70\xdb"
+			  "\x2f\x54\x0f\xa9\xc8\xf4\xf5\xab"
+			  "\x52\x04\x3a\xb8\x03\xa7\xfd\x57"
+			  "\x45\x5e\xbc\x77\xe1\xee\x79\x8c"
+			  "\x58\x7b\x1f\xf7\x75\xde\x68\x17"
+			  "\x98\x85\x8a\x18\x5c\xd2\x39\x78"
+			  "\x7a\x6f\x26\x6e\xe1\x13\x91\xdd"
+			  "\xdf\x0e\x6e\x67\xcc\x51\x53\xd8"
+			  "\x17\x5e\xce\xa7\xe4\xaf\xfa\xf3"
+			  "\x4f\x9f\x01\x9b\x04\xe7\xfc\xf9"
+			  "\x6a\xdc\x1d\x0c\x9a\xaa\x3a\x7a"
+			  "\x73\x03\xdf\xbf\x3b\x82\xbe\xb0"
+			  "\xb4\xa4\xcf\x07\xd7\xde\x71\x25"
+			  "\xc5\x10\xee\x0a\x15\x96\x8b\x4f"
+			  "\xfe\xb8\x28\xbd\x4a\xcd\xeb\x9f"
+			  "\x5d\x00\xc1\xee\xe8\x16\x44\xec"
+			  "\xe9\x7b\xd6\x85\x17\x29\xcf\x58"
+			  "\x20\xab\xf7\xce\x6b\xe7\x71\x7d"
+			  "\x4f\xa8\xb0\xe9\x7d\x70\xd6\x0b"
+			  "\x2e\x20\xb1\x1a\x63\x37\xaa\x2c"
+			  "\x94\xee\xd5\xf6\x58\x2a\xf4\x7a"
+			  "\x4c\xba\xf5\xe9\x3c\x6f\x95\x13"
+			  "\x5f\x96\x81\x5b\xb5\x62\xf2\xd7"
+			  "\x8d\xbe\xa1\x31\x51\xe6\xfe\xc9"
+			  "\x07\x7d\x0f\x00\x3a\x66\x8c\x4b"
+			  "\x94\xaa\xe5\x56\xde\xcd\x74\xa7"
+			  "\x48\x67\x6f\xed\xc9\x6a\xef\xaf"
+			  "\x9a\xb7\xae\x60\xfa\xc0\x37\x39"
+			  "\xa5\x25\xe5\x22\xea\x82\x55\x68"
+			  "\x3e\x30\xc3\x5a\xb6\x29\x73\x7a"
+			  "\xb6\xfb\x34\xee\x51\x7c\x54\xe5"
+			  "\x01\x4d\x72\x25\x32\x4a\xa3\x68"
+			  "\x80\x9a\x89\xc5\x11\x66\x4c\x8c"
+			  "\x44\x50\xbe\xd7\xa0\xee\xa6\xbb"
+			  "\x92\x0c\xe6\xd7\x83\x51\xb1\x69"
+			  "\x63\x40\xf3\xf4\x92\x84\xc4\x38"
+			  "\x29\xfb\xb4\x84\xa0\x19\x75\x16"
+			  "\x60\xbf\x0a\x9c\x89\xee\xad\xb4"
+			  "\x43\xf9\x71\x39\x45\x7c\x24\x83"
+			  "\x30\xbb\xee\x28\xb0\x86\x7b\xec"
+			  "\x93\xc1\xbf\xb9\x97\x1b\x96\xef"
+			  "\xee\x58\x35\x61\x12\x19\xda\x25"
+			  "\x77\xe5\x80\x1a\x31\x27\x9b\xe4"
+			  "\xda\x8b\x7e\x51\x4d\xcb\x01\x19"
+			  "\x4f\xdc\x92\x1a\x17\xd5\x6b\xf4"
+			  "\x50\xe3\x06\xe4\x76\x9f\x65\x00"
+			  "\xbd\x7a\xe2\x64\x26\xf2\xe4\x7e"
+			  "\x40\xf2\x80\xab\x62\xd5\xef\x23"
+			  "\x8b\xfb\x6f\x24\x6e\x9b\x66\x0e"
+			  "\xf4\x1c\x24\x1e\x1d\x26\x95\x09"
+			  "\x94\x3c\xb2\xb6\x02\xa7\xd9\x9a",
+		.klen	=3D 32,
+		.len	=3D 512,
+	},
+
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
--=20
2.36.0.464.gb9c8b46e94-goog

