Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6B0C65A903
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjAAFN5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232359AbjAAFNs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B6663FB
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6994682619;
        Sun,  1 Jan 2023 00:06:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549595; bh=L8Z9jfs1qqxz9SQqCfkx1PISHOTf+3H/IZb2IdVh3RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No+Mw/CX+0ZyaAc+EYiIDWaJ6KsyXgQvOHaR2EccacW3RMBbZQdqgGzwkAddaa+xI
         QHq3peWOI0ANYkN3ZJVcnsdHpNM2En6owtcpXMZApMeyH/XYRbwtFATXEVq0M224ls
         qE89Cb1VTvoqspGl7qRbTHY3AvgoSldFiKlwNmhOoZoXrVa/TjB1KCEwmgVVn7nLni
         3LCLmvSDB7CNhx99KAiQRomYlpA7JmDkphCGASw/dr4M8BUTDLP5F2B53IYqITC+Nx
         0m/sp1tf2P40f+JG8xvFuHWCNz9nyx2O5OImuJFmd/QUBrQEWxanAMhDMBN2qeqgO5
         lQICohWqliIoA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 03/17] fscrypt: adjust effective lblks based on extents
Date:   Sun,  1 Jan 2023 00:06:07 -0500
Message-Id: <fdd515d87735087324687de6ea5c8b93d77bf8ef.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

If a filesystem uses extent-based encryption, then the offset within a
file is not a constant which can be used for calculating an IV.
For instance, the same extent could be blocks 0-8 in one file, and
blocks 100-108 in another file. Instead, the block offset within the
extent must be used instead.

Update all uses of logical block offset within the file to use logical
block offset within the extent, if applicable.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c       |  7 ++++---
 fs/crypto/inline_crypt.c | 19 +++++++++++++------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 41c60c60b74c..93b83dbe82ee 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -107,8 +107,9 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist dst, src;
-	struct fscrypt_info *ci = fscrypt_get_lblk_info(inode, lblk_num, NULL,
-							NULL);
+	u64 ci_offset = 0;
+	struct fscrypt_info *ci = fscrypt_get_lblk_info(inode, lblk_num,
+						        &ci_offset, NULL);
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
 	int res = 0;
 
@@ -117,7 +118,7 @@ int fscrypt_crypt_block(const struct inode *inode, fscrypt_direction_t rw,
 	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
 		return -EINVAL;
 
-	fscrypt_generate_iv(&iv, lblk_num, ci);
+	fscrypt_generate_iv(&iv, ci_offset, ci);
 
 	req = skcipher_request_alloc(tfm, gfp_flags);
 	if (!req)
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 56d69b231875..0ae220c8afa3 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -271,12 +271,13 @@ void fscrypt_set_bio_crypt_ctx(struct bio *bio, const struct inode *inode,
 {
 	const struct fscrypt_info *ci;
 	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
+	u64 ci_offset = 0;
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return;
-	ci = fscrypt_get_lblk_info(inode, first_lblk, NULL, NULL);
+	ci = fscrypt_get_lblk_info(inode, first_lblk, &ci_offset, NULL);
 
-	fscrypt_generate_dun(ci, first_lblk, dun);
+	fscrypt_generate_dun(ci, ci_offset, dun);
 	bio_crypt_set_ctx(bio, ci->ci_enc_key.blk_key, dun, gfp_mask);
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_bio_crypt_ctx);
@@ -354,13 +355,14 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	const struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 	u64 next_dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
 	struct fscrypt_info *ci;
+	u64 ci_offset = 0;
 
 	if (!!bc != fscrypt_inode_uses_inline_crypto(inode))
 		return false;
 	if (!bc)
 		return true;
 
-	ci = fscrypt_get_lblk_info(inode, next_lblk, NULL, NULL);
+	ci = fscrypt_get_lblk_info(inode, next_lblk, &ci_offset, NULL);
 	/*
 	 * Comparing the key pointers is good enough, as all I/O for each key
 	 * uses the same pointer.  I.e., there's currently no need to support
@@ -369,7 +371,7 @@ bool fscrypt_mergeable_bio(struct bio *bio, const struct inode *inode,
 	if (bc->bc_key != ci->ci_enc_key.blk_key)
 		return false;
 
-	fscrypt_generate_dun(ci, next_lblk, next_dun);
+	fscrypt_generate_dun(ci, ci_offset, next_dun);
 	return bio_crypt_dun_is_contiguous(bc, bio->bi_iter.bi_size, next_dun);
 }
 EXPORT_SYMBOL_GPL(fscrypt_mergeable_bio);
@@ -464,6 +466,8 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 {
 	const struct fscrypt_info *ci;
 	u32 dun;
+	u64 ci_offset;
+	u64 extent_len;
 
 	if (!fscrypt_inode_uses_inline_crypto(inode))
 		return nr_blocks;
@@ -471,14 +475,17 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
 	if (nr_blocks <= 1)
 		return nr_blocks;
 
-	ci = fscrypt_get_lblk_info(inode, lblk, NULL, NULL);
+	ci = fscrypt_get_lblk_info(inode, lblk, &ci_offset, &extent_len);
+
+	/* Spanning an extent boundary will change the DUN */
+	nr_blocks = min_t(u64, nr_blocks, extent_len);
 	if (!(fscrypt_policy_flags(&ci->ci_policy) &
 	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
 		return nr_blocks;
 
 	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
 
-	dun = ci->ci_hashed_ino + lblk;
+	dun = ci->ci_hashed_ino + ci_offset;
 
 	return min_t(u64, nr_blocks, (u64)U32_MAX + 1 - dun);
 }
-- 
2.38.1

