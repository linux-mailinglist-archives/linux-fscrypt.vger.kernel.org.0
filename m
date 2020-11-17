Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5F72B66D7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 15:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbgKQOHS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 09:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387527AbgKQOHR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 09:07:17 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29589C061A47
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:17 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h9so25372203ybj.10
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=gI9t9CC9GAbETMLuNAlH/ClZ/2jSqevbRrvZwCwXB2c=;
        b=RftOlyar3vMM+UuLWWoDc+3E4txH9IyOqegNk1ZKpYqJ+64DndBUuka4yGqTGvV8HZ
         kKKYIdA3FBdISG2pT5diEdurh7c6SenZdtfseQienr50nVwEs+lVPqoh/QQcPcHbxKTd
         6z7tLj8QkLtfqCHUCSwGQImVKkXObQm1qs9c+uvW7zoloZat5A0FTqmA9aG/G8SXJdsa
         XBCaiEzt4ANxyW9qoY3hqx21xVpXdpDPR+RQQfctNVrHqjmeDGIDEGd96xqHl9PF78S+
         xVP/FSmJPwvk20i6vSzW80obRBeRa+undBkZLraZ4Zn/siWNcMZHVxphaEILVDyr4sDw
         uynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gI9t9CC9GAbETMLuNAlH/ClZ/2jSqevbRrvZwCwXB2c=;
        b=e6thGDiM7G7jpA4FesC9qMExX8LmESNsIe8zPkfXeN1++NrFB8Vqdnq/WD/HdjoIln
         CaxNk9PR0r6V83CHoxcP9DTblbZtF6zZbuToqmJggGt/A5jfYEft4VwJYn5IhsRtG34Q
         Om2Kv6S6Uu1I2GsQ8vzLboF6u5EOwhWvvC6ePamuMLKbWd+qaKIU/KGncqNvLlfRx8nH
         E0/M0Qth2iBAsp7pIHveYaH39lQWayZvSKqfdzirXQ+FskKCtaWbKgKiOx1AD93+UjJq
         +KCQTYDh1lCv5Bo2A/BqdagJbXlzv67rn+CqwbCS7w5ap5oWUePC1tvqMUOmuQJ/XH7T
         x0TQ==
X-Gm-Message-State: AOAM530hTEov97y+L+AFCAUxOxzb0+acv7wYe04twogTu0jJ7oaYxZbA
        HnPv5ag5v4u/Q5U/tkIJy6bOBU9cpso=
X-Google-Smtp-Source: ABdhPJz9doXCbA2XybATuEWhl6nzDUH2qic2NqkzBZezLv85f8bG7r9mJGCgGG0IMaxYIkm8TwTZJBSohjQ=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:d7d4:: with SMTP id o203mr23633500ybg.286.1605622036343;
 Tue, 17 Nov 2020 06:07:16 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:02 +0000
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Message-Id: <20201117140708.1068688-3-satyat@google.com>
Mime-Version: 1.0
References: <20201117140708.1068688-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 2/8] blk-crypto: don't require user buffer alignment
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Previously, blk-crypto-fallback required the offset and length of each bvec
in a bio to be aligned to the crypto data unit size. This patch enables
blk-crypto-fallback to work even if that's not the case - the requirement
now is only that the total length of the data in the bio is aligned to
the crypto data unit size.

Now that blk-crypto-fallback can handle bvecs not aligned to crypto data
units, and we've ensured that bios are not split in the middle of a
crypto data unit, we can relax the alignment check done by blk-crypto.

Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 block/blk-crypto-fallback.c | 202 +++++++++++++++++++++++++++---------
 block/blk-crypto.c          |  19 +---
 2 files changed, 157 insertions(+), 64 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index db2d2c67b308..619f0746ce02 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -251,6 +251,65 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
 		iv->dun[i] = cpu_to_le64(dun[i]);
 }
 
+/*
+ * If the length of any bio segment isn't a multiple of data_unit_size
+ * (which can happen if data_unit_size > logical_block_size), then each
+ * encryption/decryption might need to be passed multiple scatterlist elements.
+ * If that will be the case, this function allocates and initializes src and dst
+ * scatterlists (or a combined src/dst scatterlist) with the needed length.
+ *
+ * If 1 element is guaranteed to be enough (which is usually the case, and is
+ * guaranteed when data_unit_size <= logical_block_size), then this function
+ * just initializes the on-stack scatterlist(s).
+ */
+static bool blk_crypto_alloc_sglists(struct bio *bio,
+				     const struct bvec_iter *start_iter,
+				     unsigned int data_unit_size,
+				     struct scatterlist **src_p,
+				     struct scatterlist **dst_p)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	bool aligned = true;
+	unsigned int count = 0;
+
+	__bio_for_each_segment(bv, bio, iter, *start_iter) {
+		count++;
+		aligned &= IS_ALIGNED(bv.bv_len, data_unit_size);
+	}
+	if (aligned) {
+		count = 1;
+	} else {
+		/*
+		 * We can't need more elements than bio segments, and we can't
+		 * need more than the number of sectors per data unit.  This may
+		 * overestimate the required length by a bit, but that's okay.
+		 */
+		count = min(count, data_unit_size >> SECTOR_SHIFT);
+	}
+
+	if (count > 1) {
+		*src_p = kmalloc_array(count, sizeof(struct scatterlist),
+				       GFP_NOIO);
+		if (!*src_p)
+			return false;
+		if (dst_p) {
+			*dst_p = kmalloc_array(count,
+					       sizeof(struct scatterlist),
+					       GFP_NOIO);
+			if (!*dst_p) {
+				kfree(*src_p);
+				*src_p = NULL;
+				return false;
+			}
+		}
+	}
+	sg_init_table(*src_p, count);
+	if (dst_p)
+		sg_init_table(*dst_p, count);
+	return true;
+}
+
 /*
  * The crypto API fallback's encryption routine.
  * Allocate a bounce bio for encryption, encrypt the input bio using crypto API,
@@ -267,9 +326,12 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	struct skcipher_request *ciph_req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
-	struct scatterlist src, dst;
+	struct scatterlist _src, *src = &_src;
+	struct scatterlist _dst, *dst = &_dst;
 	union blk_crypto_iv iv;
-	unsigned int i, j;
+	unsigned int i;
+	unsigned int sg_idx = 0;
+	unsigned int du_filled = 0;
 	bool ret = false;
 	blk_status_t blk_st;
 
@@ -281,11 +343,18 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	bc = src_bio->bi_crypt_context;
 	data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
 
+	/* Allocate scatterlists if needed */
+	if (!blk_crypto_alloc_sglists(src_bio, &src_bio->bi_iter,
+				      data_unit_size, &src, &dst)) {
+		src_bio->bi_status = BLK_STS_RESOURCE;
+		return false;
+	}
+
 	/* Allocate bounce bio for encryption */
 	enc_bio = blk_crypto_clone_bio(src_bio);
 	if (!enc_bio) {
 		src_bio->bi_status = BLK_STS_RESOURCE;
-		return false;
+		goto out_free_sglists;
 	}
 
 	/*
@@ -305,45 +374,57 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	}
 
 	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
-	sg_init_table(&src, 1);
-	sg_init_table(&dst, 1);
 
-	skcipher_request_set_crypt(ciph_req, &src, &dst, data_unit_size,
+	skcipher_request_set_crypt(ciph_req, src, dst, data_unit_size,
 				   iv.bytes);
 
-	/* Encrypt each page in the bounce bio */
+	/*
+	 * Encrypt each data unit in the bounce bio.
+	 *
+	 * Take care to handle the case where a data unit spans bio segments.
+	 * This can happen when data_unit_size > logical_block_size.
+	 */
 	for (i = 0; i < enc_bio->bi_vcnt; i++) {
-		struct bio_vec *enc_bvec = &enc_bio->bi_io_vec[i];
-		struct page *plaintext_page = enc_bvec->bv_page;
+		struct bio_vec *bv = &enc_bio->bi_io_vec[i];
+		struct page *plaintext_page = bv->bv_page;
 		struct page *ciphertext_page =
 			mempool_alloc(blk_crypto_bounce_page_pool, GFP_NOIO);
+		unsigned int offset_in_bv = 0;
 
-		enc_bvec->bv_page = ciphertext_page;
+		bv->bv_page = ciphertext_page;
 
 		if (!ciphertext_page) {
 			src_bio->bi_status = BLK_STS_RESOURCE;
 			goto out_free_bounce_pages;
 		}
 
-		sg_set_page(&src, plaintext_page, data_unit_size,
-			    enc_bvec->bv_offset);
-		sg_set_page(&dst, ciphertext_page, data_unit_size,
-			    enc_bvec->bv_offset);
-
-		/* Encrypt each data unit in this page */
-		for (j = 0; j < enc_bvec->bv_len; j += data_unit_size) {
-			blk_crypto_dun_to_iv(curr_dun, &iv);
-			if (crypto_wait_req(crypto_skcipher_encrypt(ciph_req),
-					    &wait)) {
-				i++;
-				src_bio->bi_status = BLK_STS_IOERR;
-				goto out_free_bounce_pages;
+		while (offset_in_bv < bv->bv_len) {
+			unsigned int n = min(bv->bv_len - offset_in_bv,
+					     data_unit_size - du_filled);
+			sg_set_page(&src[sg_idx], plaintext_page, n,
+				    bv->bv_offset + offset_in_bv);
+			sg_set_page(&dst[sg_idx], ciphertext_page, n,
+				    bv->bv_offset + offset_in_bv);
+			sg_idx++;
+			offset_in_bv += n;
+			du_filled += n;
+			if (du_filled == data_unit_size) {
+				blk_crypto_dun_to_iv(curr_dun, &iv);
+				if (crypto_wait_req(crypto_skcipher_encrypt(ciph_req),
+						    &wait)) {
+					src_bio->bi_status = BLK_STS_IOERR;
+					goto out_free_bounce_pages;
+				}
+				bio_crypt_dun_increment(curr_dun, 1);
+				sg_idx = 0;
+				du_filled = 0;
 			}
-			bio_crypt_dun_increment(curr_dun, 1);
-			src.offset += data_unit_size;
-			dst.offset += data_unit_size;
 		}
 	}
+	if (WARN_ON_ONCE(du_filled != 0)) {
+		src_bio->bi_status = BLK_STS_IOERR;
+		goto out_free_bounce_pages;
+	}
 
 	enc_bio->bi_private = src_bio;
 	enc_bio->bi_end_io = blk_crypto_fallback_encrypt_endio;
@@ -364,7 +445,11 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 out_put_enc_bio:
 	if (enc_bio)
 		bio_put(enc_bio);
-
+out_free_sglists:
+	if (src != &_src)
+		kfree(src);
+	if (dst != &_dst)
+		kfree(dst);
 	return ret;
 }
 
@@ -383,13 +468,21 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	DECLARE_CRYPTO_WAIT(wait);
 	u64 curr_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	union blk_crypto_iv iv;
-	struct scatterlist sg;
+	struct scatterlist _sg, *sg = &_sg;
 	struct bio_vec bv;
 	struct bvec_iter iter;
 	const int data_unit_size = bc->bc_key->crypto_cfg.data_unit_size;
-	unsigned int i;
+	unsigned int sg_idx = 0;
+	unsigned int du_filled = 0;
 	blk_status_t blk_st;
 
+	/* Allocate scatterlist if needed */
+	if (!blk_crypto_alloc_sglists(bio, &f_ctx->crypt_iter, data_unit_size,
+				      &sg, NULL)) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		goto out_no_sglists;
+	}
+
 	/*
 	 * Use the crypto API fallback keyslot manager to get a crypto_skcipher
 	 * for the algorithm and key specified for this bio.
@@ -407,33 +500,48 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	}
 
 	memcpy(curr_dun, bc->bc_dun, sizeof(curr_dun));
-	sg_init_table(&sg, 1);
-	skcipher_request_set_crypt(ciph_req, &sg, &sg, data_unit_size,
-				   iv.bytes);
+	skcipher_request_set_crypt(ciph_req, sg, sg, data_unit_size, iv.bytes);
 
-	/* Decrypt each segment in the bio */
+	/*
+	 * Decrypt each data unit in the bio.
+	 *
+	 * Take care to handle the case where a data unit spans bio segments.
+	 * This can happen when data_unit_size > logical_block_size.
+	 */
 	__bio_for_each_segment(bv, bio, iter, f_ctx->crypt_iter) {
-		struct page *page = bv.bv_page;
-
-		sg_set_page(&sg, page, data_unit_size, bv.bv_offset);
-
-		/* Decrypt each data unit in the segment */
-		for (i = 0; i < bv.bv_len; i += data_unit_size) {
-			blk_crypto_dun_to_iv(curr_dun, &iv);
-			if (crypto_wait_req(crypto_skcipher_decrypt(ciph_req),
-					    &wait)) {
-				bio->bi_status = BLK_STS_IOERR;
-				goto out;
+		unsigned int offset_in_bv = 0;
+
+		while (offset_in_bv < bv.bv_len) {
+			unsigned int n = min(bv.bv_len - offset_in_bv,
+					     data_unit_size - du_filled);
+			sg_set_page(&sg[sg_idx++], bv.bv_page, n,
+				    bv.bv_offset + offset_in_bv);
+			offset_in_bv += n;
+			du_filled += n;
+			if (du_filled == data_unit_size) {
+				blk_crypto_dun_to_iv(curr_dun, &iv);
+				if (crypto_wait_req(crypto_skcipher_decrypt(ciph_req),
+						    &wait)) {
+					bio->bi_status = BLK_STS_IOERR;
+					goto out;
+				}
+				bio_crypt_dun_increment(curr_dun, 1);
+				sg_idx = 0;
+				du_filled = 0;
 			}
-			bio_crypt_dun_increment(curr_dun, 1);
-			sg.offset += data_unit_size;
 		}
 	}
-
+	if (WARN_ON_ONCE(du_filled != 0)) {
+		bio->bi_status = BLK_STS_IOERR;
+		goto out;
+	}
 out:
 	skcipher_request_free(ciph_req);
 	blk_ksm_put_slot(slot);
 out_no_keyslot:
+	if (sg != &_sg)
+		kfree(sg);
+out_no_sglists:
 	mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
 	bio_endio(bio);
 }
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 5da43f0973b4..fcee0038f7e0 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -200,22 +200,6 @@ bool bio_crypt_ctx_mergeable(struct bio_crypt_ctx *bc1, unsigned int bc1_bytes,
 	return !bc1 || bio_crypt_dun_is_contiguous(bc1, bc1_bytes, bc2->bc_dun);
 }
 
-/* Check that all I/O segments are data unit aligned. */
-static bool bio_crypt_check_alignment(struct bio *bio)
-{
-	const unsigned int data_unit_size =
-		bio->bi_crypt_context->bc_key->crypto_cfg.data_unit_size;
-	struct bvec_iter iter;
-	struct bio_vec bv;
-
-	bio_for_each_segment(bv, bio, iter) {
-		if (!IS_ALIGNED(bv.bv_len | bv.bv_offset, data_unit_size))
-			return false;
-	}
-
-	return true;
-}
-
 blk_status_t __blk_crypto_init_request(struct request *rq)
 {
 	return blk_ksm_get_slot_for_key(rq->q->ksm, rq->crypt_ctx->bc_key,
@@ -271,7 +255,8 @@ bool __blk_crypto_bio_prep(struct bio **bio_ptr)
 		goto fail;
 	}
 
-	if (!bio_crypt_check_alignment(bio)) {
+	if (!IS_ALIGNED(bio->bi_iter.bi_size,
+			bc_key->crypto_cfg.data_unit_size)) {
 		bio->bi_status = BLK_STS_IOERR;
 		goto fail;
 	}
-- 
2.29.2.299.gdc1121823c-goog

