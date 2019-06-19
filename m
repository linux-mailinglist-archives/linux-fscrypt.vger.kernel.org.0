Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8304BCA4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Jun 2019 17:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFSPSW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 11:18:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45143 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfFSPSV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 11:18:21 -0400
Received: by mail-lj1-f194.google.com with SMTP id m23so3616077lje.12;
        Wed, 19 Jun 2019 08:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U94P+ouHgJbaSvcfWP1axYxMhCkORcAQtztfyhiDkbk=;
        b=Y1yf/0TUIBjcxDiieCutpKW9TUN/Ic9bGh/J6Wlm0Y0CTQtxd9t7iJLMExAQYFS+Kr
         E097Rp8i9DDYbRdu/lSwHpXOw/Ud23EFJMZ0Pm1q4MGVTAYtZkfD2BnL8VrSNUZ9pn6g
         bnLfUoc8jd/1CYF416OCz8Qa8rSipZHBMgJCjiUcfbC6zpLCYyHt7Ehi90tM7TH2kh4b
         aGjJYilYEWdN7PUR52gwqdGjQHHCVOCsTCrAr6ft06R5q7iWv0YwZNd2T3o3/Yhcp5i9
         MoyfeGD7Y3IilXMOOybzju13zX7rFGcxBJD3pJl6CitufoQ+Urxk+pKZQLIz+rnZSnrR
         AexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U94P+ouHgJbaSvcfWP1axYxMhCkORcAQtztfyhiDkbk=;
        b=cq0OxsGDOPK77AMGrClpCCbt4empQ2OkyhXzgsBdwGjCo3bnjBkLw3tYqyGtV+5VTv
         G36sI0xtkNDYjJz4SAPaFMPtuauAarwZ2+usWbeVu9ZCgDpGkexRv9eXMV3l2ru4QL3r
         JJoJsw9m6o2HUE65eEYD+bkM+BMCSymBl7o9NtEFOzAv0QGuKMX6qRqOuHb8bninZ5/6
         ekvGPy6m8o4fI5GXAtuaGinmUpfyh39MjLbBihlLnXEtNp7/jI/NfZAGAi2YG9MbV7qv
         xoqw3EnrR/Pn7sMQl4n5znlpfYSkkQqwM3CoM0t6ObTEJr+S3c9hpQmhiBJ+9ywwYS5t
         NRcQ==
X-Gm-Message-State: APjAAAU/GL7l6pukrq0uodA5D6pCEOTxZHBG21BqpvsT/amiOoxtTMXY
        0O8eZOnIHvKhTqGxtY5GVWZmo3htEdQ4TA7V+yI=
X-Google-Smtp-Source: APXvYqw0rALt6eQG7l+sBu4xHCXPpOLu9YG2ioh3/vtQhoHzXBadk5rKiL0y00/Hv/68MIUA1iHEd8SphxC+m9/M5Yc=
X-Received: by 2002:a2e:9c06:: with SMTP id s6mr10380245lji.135.1560957497356;
 Wed, 19 Jun 2019 08:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190618212749.8995-1-ard.biesheuvel@linaro.org> <20190618212749.8995-2-ard.biesheuvel@linaro.org>
In-Reply-To: <20190618212749.8995-2-ard.biesheuvel@linaro.org>
From:   =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Date:   Wed, 19 Jun 2019 17:18:05 +0200
Message-ID: <CAAUqJDsi_acZj09xiimYGfyJVPt0zo=3-2PHuGnSKSaq82-RQA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Ard,

ut 18. 6. 2019 o 23:28 Ard Biesheuvel <ard.biesheuvel@linaro.org> nap=C3=AD=
sal(a):
> Implement a template that wraps a (skcipher,cipher,shash) or
> (aead,cipher,shash) tuple so that we can consolidate the ESSIV handling
> in fscrypt and dm-crypt and move it into the crypto API. This will result
> in better test coverage, and will allow future changes to make the bare
> cipher interface internal to the crypto subsystem, in order to increase
> robustness of the API against misuse.
>
> Note that especially the AEAD handling is a bit complex, and is tightly
> coupled to the way dm-crypt combines AEAD based on the authenc() template
> with the ESSIV handling.

Wouldn't it work better to have a template only for skcipher and in
dm-crypt just inject the essiv() template into the cipher string? For
example: "authenc(hmac(sha256),cbc(aes))-essiv:sha256" ->
"authenc(hmac(sha256),essiv(cbc(aes),aes,sha256))". That seems to me a
much simpler hack. (But maybe I'm missing some issue in that
approach...)


>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  |   4 +
>  crypto/Makefile |   1 +
>  crypto/essiv.c  | 624 ++++++++++++++++++++
>  3 files changed, 629 insertions(+)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 3d056e7da65f..1aa47087c1a2 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1917,6 +1917,10 @@ config CRYPTO_STATS
>  config CRYPTO_HASH_INFO
>         bool
>
> +config CRYPTO_ESSIV
> +       tristate
> +       select CRYPTO_AUTHENC
> +
>  source "drivers/crypto/Kconfig"
>  source "crypto/asymmetric_keys/Kconfig"
>  source "certs/Kconfig"
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 266a4cdbb9e2..ad1d99ba6d56 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -148,6 +148,7 @@ obj-$(CONFIG_CRYPTO_USER_API_AEAD) +=3D algif_aead.o
>  obj-$(CONFIG_CRYPTO_ZSTD) +=3D zstd.o
>  obj-$(CONFIG_CRYPTO_OFB) +=3D ofb.o
>  obj-$(CONFIG_CRYPTO_ECC) +=3D ecc.o
> +obj-$(CONFIG_CRYPTO_ESSIV) +=3D essiv.o
>
>  ecdh_generic-y +=3D ecdh.o
>  ecdh_generic-y +=3D ecdh_helper.o
> diff --git a/crypto/essiv.c b/crypto/essiv.c
> new file mode 100644
> index 000000000000..029a65afb4d7
> --- /dev/null
> +++ b/crypto/essiv.c
> @@ -0,0 +1,624 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * ESSIV skcipher template for block encryption
> + *
> + * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
> + *
> + * Heavily based on:
> + * adiantum length-preserving encryption mode
> + *
> + * Copyright 2018 Google LLC
> + */
> +
> +#include <crypto/authenc.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/module.h>
> +
> +#include "internal.h"
> +
> +#define ESSIV_IV_SIZE          sizeof(u64)     // IV size of the outer a=
lgo
> +#define MAX_INNER_IV_SIZE      16              // max IV size of inner a=
lgo
> +
> +struct essiv_instance_ctx {
> +       union {
> +               struct crypto_skcipher_spawn    blockcipher_spawn;
> +               struct crypto_aead_spawn        aead_spawn;
> +       } u;
> +       struct crypto_spawn                     essiv_cipher_spawn;
> +       struct crypto_shash_spawn               hash_spawn;
> +};
> +
> +struct essiv_tfm_ctx {
> +       union {
> +               struct crypto_skcipher  *blockcipher;
> +               struct crypto_aead      *aead;
> +       } u;
> +       struct crypto_cipher            *essiv_cipher;
> +       struct crypto_shash             *hash;
> +};
> +
> +struct essiv_skcipher_request_ctx {
> +       u8                              iv[MAX_INNER_IV_SIZE];
> +       struct skcipher_request         blockcipher_req;
> +};
> +
> +struct essiv_aead_request_ctx {
> +       u8                              iv[MAX_INNER_IV_SIZE];
> +       struct scatterlist              src[4], dst[4];
> +       struct aead_request             aead_req;
> +};
> +
> +static int essiv_skcipher_setkey(struct crypto_skcipher *tfm,
> +                                const u8 *key, unsigned int keylen)
> +{
> +       u32 flags =3D crypto_skcipher_get_flags(tfm) & CRYPTO_TFM_REQ_MAS=
K;
> +       struct essiv_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       SHASH_DESC_ON_STACK(desc, tctx->hash);
> +       unsigned int saltsize;
> +       u8 *salt;
> +       int err;
> +
> +       crypto_skcipher_clear_flags(tctx->u.blockcipher, CRYPTO_TFM_REQ_M=
ASK);
> +       crypto_skcipher_set_flags(tctx->u.blockcipher, flags);
> +       err =3D crypto_skcipher_setkey(tctx->u.blockcipher, key, keylen);
> +       crypto_skcipher_set_flags(tfm,
> +                                 crypto_skcipher_get_flags(tctx->u.block=
cipher) &
> +                                 CRYPTO_TFM_RES_MASK);
> +       if (err)
> +               return err;
> +
> +       saltsize =3D crypto_shash_digestsize(tctx->hash);
> +       salt =3D kmalloc(saltsize, GFP_KERNEL);
> +       if (!salt)
> +               return -ENOMEM;
> +
> +       desc->tfm =3D tctx->hash;
> +       crypto_shash_digest(desc, key, keylen, salt);
> +
> +       crypto_cipher_clear_flags(tctx->essiv_cipher, CRYPTO_TFM_REQ_MASK=
);
> +       crypto_cipher_set_flags(tctx->essiv_cipher, flags & CRYPTO_TFM_RE=
Q_MASK);
> +       err =3D crypto_cipher_setkey(tctx->essiv_cipher, salt, saltsize);
> +       flags =3D crypto_cipher_get_flags(tctx->essiv_cipher) & CRYPTO_TF=
M_RES_MASK;
> +       crypto_skcipher_set_flags(tfm, flags);
> +
> +       kzfree(salt);
> +       return err;
> +}
> +
> +static int essiv_aead_setkey(struct crypto_aead *tfm, const u8 *key,
> +                            unsigned int keylen)
> +{
> +       struct essiv_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +       SHASH_DESC_ON_STACK(desc, tctx->hash);
> +       struct crypto_authenc_keys keys;
> +       unsigned int saltsize;
> +       u8 *salt;
> +       int err;
> +
> +       crypto_aead_clear_flags(tctx->u.aead, CRYPTO_TFM_REQ_MASK);
> +       crypto_aead_set_flags(tctx->u.aead, crypto_aead_get_flags(tfm) &
> +                                           CRYPTO_TFM_REQ_MASK);
> +       err =3D crypto_aead_setkey(tctx->u.aead, key, keylen);
> +       crypto_aead_set_flags(tfm, crypto_aead_get_flags(tctx->u.aead) &
> +                                  CRYPTO_TFM_RES_MASK);
> +       if (err)
> +               return err;
> +
> +       if (crypto_authenc_extractkeys(&keys, key, keylen) !=3D 0) {
> +               crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +               return -EINVAL;
> +       }
> +
> +       saltsize =3D crypto_shash_digestsize(tctx->hash);
> +       salt =3D kmalloc(saltsize, GFP_KERNEL);
> +       if (!salt)
> +               return -ENOMEM;
> +
> +       desc->tfm =3D tctx->hash;
> +       crypto_shash_init(desc);
> +       crypto_shash_update(desc, keys.enckey, keys.enckeylen);
> +       crypto_shash_finup(desc, keys.authkey, keys.authkeylen, salt);
> +
> +       crypto_cipher_clear_flags(tctx->essiv_cipher, CRYPTO_TFM_REQ_MASK=
);
> +       crypto_cipher_set_flags(tctx->essiv_cipher, crypto_aead_get_flags=
(tfm) &
> +                                                   CRYPTO_TFM_REQ_MASK);
> +       err =3D crypto_cipher_setkey(tctx->essiv_cipher, salt, saltsize);
> +       crypto_aead_set_flags(tfm, crypto_cipher_get_flags(tctx->essiv_ci=
pher) &
> +                                  CRYPTO_TFM_RES_MASK);
> +
> +       kzfree(salt);
> +       return err;
> +}
> +
> +static int essiv_aead_setauthsize(struct crypto_aead *tfm,
> +                                 unsigned int authsize)
> +{
> +       struct essiv_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +
> +       return crypto_aead_setauthsize(tctx->u.aead, authsize);
> +}
> +
> +static void essiv_skcipher_done(struct crypto_async_request *areq, int e=
rr)
> +{
> +       struct skcipher_request *req =3D areq->data;
> +
> +       skcipher_request_complete(req, err);
> +}
> +
> +static void essiv_aead_done(struct crypto_async_request *areq, int err)
> +{
> +       struct aead_request *req =3D areq->data;
> +
> +       aead_request_complete(req, err);
> +}
> +
> +static void essiv_skcipher_prepare_subreq(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> +       const struct essiv_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       struct essiv_skcipher_request_ctx *rctx =3D skcipher_request_ctx(=
req);
> +       struct skcipher_request *subreq =3D &rctx->blockcipher_req;
> +
> +       memset(rctx->iv, 0, crypto_cipher_blocksize(tctx->essiv_cipher));
> +       memcpy(rctx->iv, req->iv, crypto_skcipher_ivsize(tfm));
> +
> +       crypto_cipher_encrypt_one(tctx->essiv_cipher, rctx->iv, rctx->iv)=
;
> +
> +       skcipher_request_set_tfm(subreq, tctx->u.blockcipher);
> +       skcipher_request_set_crypt(subreq, req->src, req->dst, req->crypt=
len,
> +                                  rctx->iv);
> +       skcipher_request_set_callback(subreq, req->base.flags,
> +                                     essiv_skcipher_done, req);
> +}
> +
> +static int essiv_aead_prepare_subreq(struct aead_request *req)
> +{
> +       struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
> +       const struct essiv_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +       struct essiv_aead_request_ctx *rctx =3D aead_request_ctx(req);
> +       int ivsize =3D crypto_cipher_blocksize(tctx->essiv_cipher);
> +       int ssize =3D req->assoclen - crypto_aead_ivsize(tfm);
> +       struct aead_request *subreq =3D &rctx->aead_req;
> +       struct scatterlist *sg;
> +
> +       /*
> +        * dm-crypt embeds the sector number and the IV in the AAD region=
 so we
> +        * have to splice the converted IV into the subrequest that we pa=
ss on
> +        * to the AEAD transform. This means we are tightly coupled to dm=
-crypt,
> +        * but that should be the only user of this code in AEAD mode.
> +        */
> +       if (ssize < 0 || sg_nents_for_len(req->src, ssize) !=3D 1)
> +               return -EINVAL;
> +
> +       memset(rctx->iv, 0, ivsize);
> +       memcpy(rctx->iv, req->iv, crypto_aead_ivsize(tfm));
> +
> +       crypto_cipher_encrypt_one(tctx->essiv_cipher, rctx->iv, rctx->iv)=
;
> +
> +       sg_init_table(rctx->src, 4);
> +       sg_set_page(rctx->src, sg_page(req->src), ssize, req->src->offset=
);
> +       sg_set_buf(rctx->src + 1, rctx->iv, ivsize);
> +       sg =3D scatterwalk_ffwd(rctx->src + 2, req->src, req->assoclen);
> +       if (sg !=3D rctx->src + 2)
> +               sg_chain(rctx->src, 3, sg);
> +
> +       sg_init_table(rctx->dst, 4);
> +       sg_set_page(rctx->dst, sg_page(req->dst), ssize, req->dst->offset=
);
> +       sg_set_buf(rctx->dst + 1, rctx->iv, ivsize);
> +       sg =3D scatterwalk_ffwd(rctx->dst + 2, req->dst, req->assoclen);
> +       if (sg !=3D rctx->dst + 2)
> +               sg_chain(rctx->dst, 3, sg);
> +
> +       aead_request_set_tfm(subreq, tctx->u.aead);
> +       aead_request_set_crypt(subreq, rctx->src, rctx->dst, req->cryptle=
n,
> +                              rctx->iv);
> +       aead_request_set_ad(subreq, ssize + ivsize);
> +       aead_request_set_callback(subreq, req->base.flags, essiv_aead_don=
e, req);
> +
> +       return 0;
> +}
> +
> +static int essiv_skcipher_encrypt(struct skcipher_request *req)
> +{
> +       struct essiv_skcipher_request_ctx *rctx =3D skcipher_request_ctx(=
req);
> +
> +       essiv_skcipher_prepare_subreq(req);
> +       return crypto_skcipher_encrypt(&rctx->blockcipher_req);
> +}
> +
> +static int essiv_aead_encrypt(struct aead_request *req)
> +{
> +       struct essiv_aead_request_ctx *rctx =3D aead_request_ctx(req);
> +       int err;
> +
> +       err =3D essiv_aead_prepare_subreq(req);
> +       if (err)
> +               return err;
> +       return crypto_aead_encrypt(&rctx->aead_req);
> +}
> +
> +static int essiv_skcipher_decrypt(struct skcipher_request *req)
> +{
> +       struct essiv_skcipher_request_ctx *rctx =3D skcipher_request_ctx(=
req);
> +       return crypto_skcipher_decrypt(&rctx->blockcipher_req);
> +}
> +
> +static int essiv_aead_decrypt(struct aead_request *req)
> +{
> +       struct essiv_aead_request_ctx *rctx =3D aead_request_ctx(req);
> +       int err;
> +
> +       err =3D essiv_aead_prepare_subreq(req);
> +       if (err)
> +               return err;
> +
> +       essiv_aead_prepare_subreq(req);
> +       return crypto_aead_decrypt(&rctx->aead_req);
> +}
> +
> +static int essiv_init_tfm(struct essiv_instance_ctx *ictx,
> +                         struct essiv_tfm_ctx *tctx)
> +{
> +       struct crypto_cipher *essiv_cipher;
> +       struct crypto_shash *hash;
> +       int err;
> +
> +       essiv_cipher =3D crypto_spawn_cipher(&ictx->essiv_cipher_spawn);
> +       if (IS_ERR(essiv_cipher))
> +               return PTR_ERR(essiv_cipher);
> +
> +       hash =3D crypto_spawn_shash(&ictx->hash_spawn);
> +       if (IS_ERR(hash)) {
> +               err =3D PTR_ERR(hash);
> +               goto err_free_essiv_cipher;
> +       }
> +
> +       tctx->essiv_cipher =3D essiv_cipher;
> +       tctx->hash =3D hash;
> +
> +       return 0;
> +
> +err_free_essiv_cipher:
> +       crypto_free_cipher(essiv_cipher);
> +       return err;
> +}
> +
> +static int essiv_skcipher_init_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct skcipher_instance *inst =3D skcipher_alg_instance(tfm);
> +       struct essiv_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
> +       struct essiv_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       struct crypto_skcipher *blockcipher;
> +       unsigned int subreq_size;
> +       int err;
> +
> +       BUILD_BUG_ON(offsetofend(struct essiv_skcipher_request_ctx,
> +                                blockcipher_req) !=3D
> +                    sizeof(struct essiv_skcipher_request_ctx));
> +
> +       blockcipher =3D crypto_spawn_skcipher(&ictx->u.blockcipher_spawn)=
;
> +       if (IS_ERR(blockcipher))
> +               return PTR_ERR(blockcipher);
> +
> +       subreq_size =3D FIELD_SIZEOF(struct essiv_skcipher_request_ctx,
> +                                  blockcipher_req) +
> +                     crypto_skcipher_reqsize(blockcipher);
> +
> +       crypto_skcipher_set_reqsize(tfm, offsetof(struct essiv_skcipher_r=
equest_ctx,
> +                                                 blockcipher_req) + subr=
eq_size);
> +
> +       err =3D essiv_init_tfm(ictx, tctx);
> +       if (err)
> +               crypto_free_skcipher(blockcipher);
> +
> +       tctx->u.blockcipher =3D blockcipher;
> +       return err;
> +}
> +
> +static int essiv_aead_init_tfm(struct crypto_aead *tfm)
> +{
> +       struct aead_instance *inst =3D aead_alg_instance(tfm);
> +       struct essiv_instance_ctx *ictx =3D aead_instance_ctx(inst);
> +       struct essiv_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +       struct crypto_aead *aead;
> +       unsigned int subreq_size;
> +       int err;
> +
> +       BUILD_BUG_ON(offsetofend(struct essiv_aead_request_ctx, aead_req)=
 !=3D
> +                    sizeof(struct essiv_aead_request_ctx));
> +
> +       aead =3D crypto_spawn_aead(&ictx->u.aead_spawn);
> +       if (IS_ERR(aead))
> +               return PTR_ERR(aead);
> +
> +       subreq_size =3D FIELD_SIZEOF(struct essiv_aead_request_ctx, aead_=
req) +
> +                     crypto_aead_reqsize(aead);
> +
> +       crypto_aead_set_reqsize(tfm, offsetof(struct essiv_aead_request_c=
tx,
> +                                             aead_req) + subreq_size);
> +
> +       err =3D essiv_init_tfm(ictx, tctx);
> +       if (err)
> +               crypto_free_aead(aead);
> +
> +       tctx->u.aead =3D aead;
> +       return err;
> +}
> +
> +static void essiv_skcipher_exit_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct essiv_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +
> +       crypto_free_skcipher(tctx->u.blockcipher);
> +       crypto_free_cipher(tctx->essiv_cipher);
> +       crypto_free_shash(tctx->hash);
> +}
> +
> +static void essiv_aead_exit_tfm(struct crypto_aead *tfm)
> +{
> +       struct essiv_tfm_ctx *tctx =3D crypto_aead_ctx(tfm);
> +
> +       crypto_free_aead(tctx->u.aead);
> +       crypto_free_cipher(tctx->essiv_cipher);
> +       crypto_free_shash(tctx->hash);
> +}
> +
> +static void essiv_skcipher_free_instance(struct skcipher_instance *inst)
> +{
> +       struct essiv_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
> +
> +       crypto_drop_skcipher(&ictx->u.blockcipher_spawn);
> +       crypto_drop_spawn(&ictx->essiv_cipher_spawn);
> +       crypto_drop_shash(&ictx->hash_spawn);
> +       kfree(inst);
> +}
> +
> +static void essiv_aead_free_instance(struct aead_instance *inst)
> +{
> +       struct essiv_instance_ctx *ictx =3D aead_instance_ctx(inst);
> +
> +       crypto_drop_aead(&ictx->u.aead_spawn);
> +       crypto_drop_spawn(&ictx->essiv_cipher_spawn);
> +       crypto_drop_shash(&ictx->hash_spawn);
> +       kfree(inst);
> +}
> +
> +static bool essiv_supported_algorithms(struct crypto_alg *essiv_cipher_a=
lg,
> +                                      struct shash_alg *hash_alg,
> +                                      int ivsize)
> +{
> +       if (hash_alg->digestsize < essiv_cipher_alg->cra_cipher.cia_min_k=
eysize ||
> +           hash_alg->digestsize > essiv_cipher_alg->cra_cipher.cia_max_k=
eysize)
> +               return false;
> +
> +       if (ivsize !=3D essiv_cipher_alg->cra_blocksize)
> +               return false;
> +
> +       if (ivsize > MAX_INNER_IV_SIZE)
> +               return false;
> +
> +       return true;
> +}
> +
> +static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb=
)
> +{
> +       struct crypto_attr_type *algt;
> +       const char *blockcipher_name;
> +       const char *essiv_cipher_name;
> +       const char *shash_name;
> +       struct skcipher_instance *skcipher_inst =3D NULL;
> +       struct aead_instance *aead_inst =3D NULL;
> +       struct crypto_instance *inst;
> +       struct crypto_alg *base, *block_base;
> +       struct essiv_instance_ctx *ictx;
> +       struct skcipher_alg *blockcipher_alg =3D NULL;
> +       struct aead_alg *aead_alg =3D NULL;
> +       struct crypto_alg *essiv_cipher_alg;
> +       struct crypto_alg *_hash_alg;
> +       struct shash_alg *hash_alg;
> +       int ivsize;
> +       u32 type;
> +       int err;
> +
> +       algt =3D crypto_get_attr_type(tb);
> +       if (IS_ERR(algt))
> +               return PTR_ERR(algt);
> +
> +       blockcipher_name =3D crypto_attr_alg_name(tb[1]);
> +       if (IS_ERR(blockcipher_name))
> +               return PTR_ERR(blockcipher_name);
> +
> +       essiv_cipher_name =3D crypto_attr_alg_name(tb[2]);
> +       if (IS_ERR(essiv_cipher_name))
> +               return PTR_ERR(essiv_cipher_name);
> +
> +       shash_name =3D crypto_attr_alg_name(tb[3]);
> +       if (IS_ERR(shash_name))
> +               return PTR_ERR(shash_name);
> +
> +       type =3D algt->type & algt->mask;
> +
> +       switch (type) {
> +       case CRYPTO_ALG_TYPE_BLKCIPHER:
> +               skcipher_inst =3D kzalloc(sizeof(*skcipher_inst) +
> +                                       sizeof(*ictx), GFP_KERNEL);
> +               if (!skcipher_inst)
> +                       return -ENOMEM;
> +               inst =3D skcipher_crypto_instance(skcipher_inst);
> +               base =3D &skcipher_inst->alg.base;
> +               ictx =3D crypto_instance_ctx(inst);
> +
> +               /* Block cipher, e.g. "cbc(aes)" */
> +               crypto_set_skcipher_spawn(&ictx->u.blockcipher_spawn, ins=
t);
> +               err =3D crypto_grab_skcipher(&ictx->u.blockcipher_spawn,
> +                                          blockcipher_name, 0,
> +                                          crypto_requires_sync(algt->typ=
e,
> +                                                               algt->mas=
k));
> +               if (err)
> +                       goto out_free_inst;
> +               blockcipher_alg =3D crypto_spawn_skcipher_alg(&ictx->u.bl=
ockcipher_spawn);
> +               block_base =3D &blockcipher_alg->base;
> +               ivsize =3D blockcipher_alg->ivsize;
> +               break;
> +
> +       case CRYPTO_ALG_TYPE_AEAD:
> +               aead_inst =3D kzalloc(sizeof(*aead_inst) +
> +                                   sizeof(*ictx), GFP_KERNEL);
> +               if (!aead_inst)
> +                       return -ENOMEM;
> +               inst =3D aead_crypto_instance(aead_inst);
> +               base =3D &aead_inst->alg.base;
> +               ictx =3D crypto_instance_ctx(inst);
> +
> +               /* AEAD cipher, e.g. "authenc(hmac(sha256),cbc(aes))" */
> +               crypto_set_aead_spawn(&ictx->u.aead_spawn, inst);
> +               err =3D crypto_grab_aead(&ictx->u.aead_spawn,
> +                                      blockcipher_name, 0,
> +                                      crypto_requires_sync(algt->type,
> +                                                           algt->mask));
> +               if (err)
> +                       goto out_free_inst;
> +               aead_alg =3D crypto_spawn_aead_alg(&ictx->u.aead_spawn);
> +               block_base =3D &aead_alg->base;
> +               ivsize =3D aead_alg->ivsize;
> +               break;
> +
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       /* Block cipher, e.g. "aes" */
> +       crypto_set_spawn(&ictx->essiv_cipher_spawn, inst);
> +       err =3D crypto_grab_spawn(&ictx->essiv_cipher_spawn, essiv_cipher=
_name,
> +                               CRYPTO_ALG_TYPE_CIPHER, CRYPTO_ALG_TYPE_M=
ASK);
> +       if (err)
> +               goto out_drop_blockcipher;
> +       essiv_cipher_alg =3D ictx->essiv_cipher_spawn.alg;
> +
> +       /* Synchronous hash, e.g., "sha256" */
> +       _hash_alg =3D crypto_alg_mod_lookup(shash_name,
> +                                         CRYPTO_ALG_TYPE_SHASH,
> +                                         CRYPTO_ALG_TYPE_MASK);
> +       if (IS_ERR(_hash_alg)) {
> +               err =3D PTR_ERR(_hash_alg);
> +               goto out_drop_essiv_cipher;
> +       }
> +       hash_alg =3D __crypto_shash_alg(_hash_alg);
> +       err =3D crypto_init_shash_spawn(&ictx->hash_spawn, hash_alg, inst=
);
> +       if (err)
> +               goto out_put_hash;
> +
> +       /* Check the set of algorithms */
> +       if (!essiv_supported_algorithms(essiv_cipher_alg, hash_alg, ivsiz=
e)) {
> +               pr_warn("Unsupported essiv instantiation: (%s,%s,%s)\n",
> +                       block_base->cra_name,
> +                       essiv_cipher_alg->cra_name,
> +                       hash_alg->base.cra_name);
> +               err =3D -EINVAL;
> +               goto out_drop_hash;
> +       }
> +
> +       /* Instance fields */
> +
> +       err =3D -ENAMETOOLONG;
> +       if (snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME,
> +                    "essiv(%s,%s,%s)", block_base->cra_name,
> +                    essiv_cipher_alg->cra_name,
> +                    hash_alg->base.cra_name) >=3D CRYPTO_MAX_ALG_NAME)
> +               goto out_drop_hash;
> +       if (snprintf(base->cra_driver_name, CRYPTO_MAX_ALG_NAME,
> +                    "essiv(%s,%s,%s)",
> +                    block_base->cra_driver_name,
> +                    essiv_cipher_alg->cra_driver_name,
> +                    hash_alg->base.cra_driver_name) >=3D CRYPTO_MAX_ALG_=
NAME)
> +               goto out_drop_hash;
> +
> +       base->cra_flags         =3D block_base->cra_flags & CRYPTO_ALG_AS=
YNC;
> +       base->cra_blocksize     =3D block_base->cra_blocksize;
> +       base->cra_ctxsize       =3D sizeof(struct essiv_tfm_ctx);
> +       base->cra_alignmask     =3D block_base->cra_alignmask;
> +       base->cra_priority      =3D block_base->cra_priority;
> +
> +       if (type =3D=3D CRYPTO_ALG_TYPE_BLKCIPHER) {
> +               skcipher_inst->alg.setkey       =3D essiv_skcipher_setkey=
;
> +               skcipher_inst->alg.encrypt      =3D essiv_skcipher_encryp=
t;
> +               skcipher_inst->alg.decrypt      =3D essiv_skcipher_decryp=
t;
> +               skcipher_inst->alg.init         =3D essiv_skcipher_init_t=
fm;
> +               skcipher_inst->alg.exit         =3D essiv_skcipher_exit_t=
fm;
> +
> +               skcipher_inst->alg.min_keysize  =3D crypto_skcipher_alg_m=
in_keysize(blockcipher_alg);
> +               skcipher_inst->alg.max_keysize  =3D crypto_skcipher_alg_m=
ax_keysize(blockcipher_alg);
> +               skcipher_inst->alg.ivsize       =3D ESSIV_IV_SIZE;
> +               skcipher_inst->alg.chunksize    =3D blockcipher_alg->chun=
ksize;
> +               skcipher_inst->alg.walksize     =3D blockcipher_alg->walk=
size;
> +
> +               skcipher_inst->free             =3D essiv_skcipher_free_i=
nstance;
> +
> +               err =3D skcipher_register_instance(tmpl, skcipher_inst);
> +       } else {
> +               aead_inst->alg.setkey           =3D essiv_aead_setkey;
> +               aead_inst->alg.setauthsize      =3D essiv_aead_setauthsiz=
e;
> +               aead_inst->alg.encrypt          =3D essiv_aead_encrypt;
> +               aead_inst->alg.decrypt          =3D essiv_aead_decrypt;
> +               aead_inst->alg.init             =3D essiv_aead_init_tfm;
> +               aead_inst->alg.exit             =3D essiv_aead_exit_tfm;
> +
> +               aead_inst->alg.ivsize           =3D ESSIV_IV_SIZE;
> +               aead_inst->alg.maxauthsize      =3D aead_alg->maxauthsize=
;
> +               aead_inst->alg.chunksize        =3D aead_alg->chunksize;
> +
> +               aead_inst->free                 =3D essiv_aead_free_insta=
nce;
> +
> +               err =3D aead_register_instance(tmpl, aead_inst);
> +       }
> +
> +       if (err)
> +               goto out_drop_hash;
> +
> +       crypto_mod_put(_hash_alg);
> +       return 0;
> +
> +out_drop_hash:
> +       crypto_drop_shash(&ictx->hash_spawn);
> +out_put_hash:
> +       crypto_mod_put(_hash_alg);
> +out_drop_essiv_cipher:
> +       crypto_drop_spawn(&ictx->essiv_cipher_spawn);
> +out_drop_blockcipher:
> +       if (type =3D=3D CRYPTO_ALG_TYPE_BLKCIPHER) {
> +               crypto_drop_skcipher(&ictx->u.blockcipher_spawn);
> +       } else {
> +               crypto_drop_aead(&ictx->u.aead_spawn);
> +       }
> +out_free_inst:
> +       kfree(skcipher_inst);
> +       kfree(aead_inst);
> +       return err;
> +}
> +
> +/* essiv(blockcipher_name, essiv_cipher_name, shash_name) */
> +static struct crypto_template essiv_tmpl =3D {
> +       .name   =3D "essiv",
> +       .create =3D essiv_create,
> +       .module =3D THIS_MODULE,
> +};
> +
> +static int __init essiv_module_init(void)
> +{
> +       return crypto_register_template(&essiv_tmpl);
> +}
> +
> +static void __exit essiv_module_exit(void)
> +{
> +       crypto_unregister_template(&essiv_tmpl);
> +}
> +
> +subsys_initcall(essiv_module_init);
> +module_exit(essiv_module_exit);
> +
> +MODULE_DESCRIPTION("ESSIV skcipher/aead wrapper for block encryption");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS_CRYPTO("essiv");
> --
> 2.17.1
>
