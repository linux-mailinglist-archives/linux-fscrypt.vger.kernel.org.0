Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803425618B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 26 Jun 2019 06:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfFZEtq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 26 Jun 2019 00:49:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725308AbfFZEtp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 26 Jun 2019 00:49:45 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 083652080C;
        Wed, 26 Jun 2019 04:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561524584;
        bh=tkCPbp9GSHOv3qLaNI5Ff3KJwFFeN2RzUsEB0O+zzRU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ODbHC0SQ+Sf84IQkNvVU0OXjS8gzH+muY4UJH46J9ie8blnmrTKSjofteqWf3oSFS
         LMqd7XFj6Fxu6gkyYRYgl3mKHvrpeApAKQ18h+wg1mGQuttnKlGlKcFWXsGVCmIrGi
         oGKf0CcxLW4ny8ksnRjw8xxNQQ7xMUF0GY9P/sI8=
Date:   Tue, 25 Jun 2019 21:49:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [PATCH v4 0/6] crypto: switch to crypto API for ESSIV
 generation
Message-ID: <20190626044942.GB23471@sol.localdomain>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
 <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jun 23, 2019 at 11:30:41AM +0200, Ard Biesheuvel wrote:
> On Fri, 21 Jun 2019 at 10:09, Ard Biesheuvel <ard.biesheuvel@arm.com> wrote:
> >
> > From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> ...
> >
> > - given that hardware already exists that can perform en/decryption including
> >   ESSIV generation of a range of blocks, it would be useful to encapsulate
> >   this in the ESSIV template, and teach at least dm-crypt how to use it
> >   (given that it often processes 8 512-byte sectors at a time)
> 
> I thought about this a bit more, and it occurred to me that the
> capability of issuing several sectors at a time and letting the lower
> layers increment the IV between sectors is orthogonal to whether ESSIV
> is being used or not, and so it probably belongs in another wrapper.
> 
> I.e., if we define a skcipher template like dmplain64le(), which is
> defined as taking a sector size as part of the key, and which
> increments a 64 LE counter between sectors if multiple are passed, it
> can be used not only for ESSIV but also for XTS, which I assume can be
> h/w accelerated in the same way.
> 
> So with that in mind, I think we should decouple the multi-sector
> discussion and leave it for a followup series, preferably proposed by
> someone who also has access to some hardware to prototype it on.
> 

This makes sense, but if we're going to leave that functionality out of the
essiv template, I think we should revisit whether the essiv template takes a
__le64 sector number vs. just an IV matching the cipher block size.  To me,
defining the IV to be a __le64 seems like a layering violation.  Also, dm-crypt
and fscrypt already know how to zero-pad the sector number to form the full 16
byte IV, and your patch just duplicates that logic in the essiv template too,
which makes it more complicated than necessary.

E.g., the following incremental patch for the skcipher case would simplify it:

(You'd have to do it for the AEAD case too.)

diff --git a/crypto/essiv.c b/crypto/essiv.c
index 8e80814ec7d6..737e92ebcbd8 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -57,11 +57,6 @@ struct essiv_tfm_ctx {
 	struct crypto_shash		*hash;
 };
 
-struct essiv_skcipher_request_ctx {
-	u8				iv[MAX_INNER_IV_SIZE];
-	struct skcipher_request		skcipher_req;
-};
-
 struct essiv_aead_request_ctx {
 	u8				iv[2][MAX_INNER_IV_SIZE];
 	struct scatterlist		src[4], dst[4];
@@ -161,39 +156,32 @@ static void essiv_skcipher_done(struct crypto_async_request *areq, int err)
 	skcipher_request_complete(req, err);
 }
 
-static void essiv_skcipher_prepare_subreq(struct skcipher_request *req)
+static int essiv_skcipher_crypt(struct skcipher_request *req, bool enc)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	const struct essiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
-	struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
-	struct skcipher_request *subreq = &rctx->skcipher_req;
-
-	memset(rctx->iv, 0, crypto_cipher_blocksize(tctx->essiv_cipher));
-	memcpy(rctx->iv, req->iv, crypto_skcipher_ivsize(tfm));
+	struct skcipher_request *subreq = skcipher_request_ctx(req);
 
-	crypto_cipher_encrypt_one(tctx->essiv_cipher, rctx->iv, rctx->iv);
+	crypto_cipher_encrypt_one(tctx->essiv_cipher, req->iv, req->iv);
 
 	skcipher_request_set_tfm(subreq, tctx->u.skcipher);
 	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen,
-				   rctx->iv);
+				   req->iv);
 	skcipher_request_set_callback(subreq, skcipher_request_flags(req),
 				      essiv_skcipher_done, req);
+
+	return enc ? crypto_skcipher_encrypt(subreq) :
+		     crypto_skcipher_decrypt(subreq);
 }
 
 static int essiv_skcipher_encrypt(struct skcipher_request *req)
 {
-	struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
-
-	essiv_skcipher_prepare_subreq(req);
-	return crypto_skcipher_encrypt(&rctx->skcipher_req);
+	return essiv_skcipher_crypt(req, true);
 }
 
 static int essiv_skcipher_decrypt(struct skcipher_request *req)
 {
-	struct essiv_skcipher_request_ctx *rctx = skcipher_request_ctx(req);
-
-	essiv_skcipher_prepare_subreq(req);
-	return crypto_skcipher_decrypt(&rctx->skcipher_req);
+	return essiv_skcipher_crypt(req, false);
 }
 
 static void essiv_aead_done(struct crypto_async_request *areq, int err)
@@ -300,24 +288,14 @@ static int essiv_skcipher_init_tfm(struct crypto_skcipher *tfm)
 	struct essiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
 	struct essiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
 	struct crypto_skcipher *skcipher;
-	unsigned int subreq_size;
 	int err;
 
-	BUILD_BUG_ON(offsetofend(struct essiv_skcipher_request_ctx,
-				 skcipher_req) !=
-		     sizeof(struct essiv_skcipher_request_ctx));
-
 	skcipher = crypto_spawn_skcipher(&ictx->u.skcipher_spawn);
 	if (IS_ERR(skcipher))
 		return PTR_ERR(skcipher);
 
-	subreq_size = FIELD_SIZEOF(struct essiv_skcipher_request_ctx,
-				   skcipher_req) +
-		      crypto_skcipher_reqsize(skcipher);
-
-	crypto_skcipher_set_reqsize(tfm,
-				    offsetof(struct essiv_skcipher_request_ctx,
-					     skcipher_req) + subreq_size);
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct skcipher_request) +
+				    crypto_skcipher_reqsize(skcipher));
 
 	err = essiv_init_tfm(ictx, tctx);
 	if (err) {
@@ -567,9 +545,9 @@ static int essiv_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 		skcipher_inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(skcipher_alg);
 		skcipher_inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(skcipher_alg);
-		skcipher_inst->alg.ivsize	= ESSIV_IV_SIZE;
-		skcipher_inst->alg.chunksize	= skcipher_alg->chunksize;
-		skcipher_inst->alg.walksize	= skcipher_alg->walksize;
+		skcipher_inst->alg.ivsize	= crypto_skcipher_alg_ivsize(skcipher_alg);
+		skcipher_inst->alg.chunksize	= crypto_skcipher_alg_chunksize(skcipher_alg);
+		skcipher_inst->alg.walksize	= crypto_skcipher_alg_walksize(skcipher_alg);
 
 		skcipher_inst->free		= essiv_skcipher_free_instance;
 
