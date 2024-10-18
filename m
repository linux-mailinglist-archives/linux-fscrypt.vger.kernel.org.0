Return-Path: <linux-fscrypt+bounces-503-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C38D9A461F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 20:45:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C67EC1F240A6
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 18:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB52204F9C;
	Fri, 18 Oct 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lP58+IJ7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75F9204F8A;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277106; cv=none; b=IVX23BjE4Iejx6QqwRmHNS1kv7DuYRCwWVNuOA0yBAPwMcgpKuu7j8WEU1Lt3on7PBeaCCDaFMpRYvTT98gZlgdS//EpWJ6NINPwB+ZI7lgnc7rcszThr139LDrUm7gaHgTe+xgAVk7YXw4NnB+LFHwevUO7MMfbRulAgYEv+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277106; c=relaxed/simple;
	bh=0qchzt7gBgYJL42I9oOzic2a5iFiBbDN8bBm6iTAtt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPEmT7mUbXyxcRDdSEQHBdJx2Eev9ZbeabVAVAEa0ZHG7CrMgQHCzsmUXXuBZwufoZYkGmHdXB7RgF9LIs6UhsO6wtLr5RLQnbUbetYjjvvr+YTAdeqcTv8wdaTglzWW4n90rAcmggrqmOHcSvKRRRQH4a2ysfuIL0CHS+v7sG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lP58+IJ7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EAFEC4CEC7;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277105;
	bh=0qchzt7gBgYJL42I9oOzic2a5iFiBbDN8bBm6iTAtt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lP58+IJ7tGDLYShN+HUc2tPy2kDe9kB2VqDCKrSP6RWS26eooYpruQeVtU2dhKkK/
	 Ht7Q+1lADA2gM5X72mZwvZy/G7nScEOmvsxjuv6aZnoxsTusK1mNr/LfPBpHF1I81s
	 5zb0CTfAUvRGXhEr9gKp6s8GqULfYpIWUiZw73DvYHDnqWC6dN0wJzgMFEjmOPNOr0
	 qKzR3STi+6oT/BbwRt8xkKviKGO5s/KlwFDyqY5H0bRmaL3u8RWdoVvOY2+zErcn0D
	 a9M++TZCS/MGO5T52V4k0d2cADGh45aICwEL2UF3Cv4OKu8/uMY7kqJUmUZxO1ksZG
	 IYIl2RSqXYj0A==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Adrian Vovk <adrianvovk@gmail.com>
Subject: [RFC PATCH 2/4] block: add the bi_skip_dm_default_key flag
Date: Fri, 18 Oct 2024 11:43:37 -0700
Message-ID: <20241018184339.66601-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241018184339.66601-1-ebiggers@kernel.org>
References: <20241018184339.66601-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add a flag bi_skip_dm_default_key to struct bio.  This flag indicates
that dm-default-key should not en/decrypt the bio, due to it targeting
the contents of an encrypted file.

When a bio is cloned, copy the bi_skip_dm_default_key flag.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/bio.c                 |  3 +++
 block/blk-crypto-fallback.c |  2 ++
 include/linux/blk-crypto.h  | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/blk_types.h   |  3 +++
 4 files changed, 44 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index ac4d77c889322..5ff0b66e47a42 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -267,10 +267,13 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_iocost_cost = 0;
 #endif
 #endif
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	bio->bi_crypt_context = NULL;
+#if IS_ENABLED(CONFIG_DM_DEFAULT_KEY)
+	bio->bi_skip_dm_default_key = false;
+#endif
 #endif
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 	bio->bi_integrity = NULL;
 #endif
 	bio->bi_vcnt = 0;
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index b1e7415f8439c..dd5f1edcc44b3 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -179,10 +179,12 @@ static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
 	bio_for_each_segment(bv, bio_src, iter)
 		bio->bi_io_vec[bio->bi_vcnt++] = bv;
 
 	bio_clone_blkg_association(bio, bio_src);
 
+	bio_clone_skip_dm_default_key(bio, bio_src);
+
 	return bio;
 }
 
 static bool
 blk_crypto_fallback_alloc_cipher_req(struct blk_crypto_keyslot *slot,
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee41..f1f3d546c53e5 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -110,10 +110,13 @@ static inline bool bio_has_crypt_ctx(struct bio *bio)
 	return false;
 }
 
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
 
+static inline void bio_clone_skip_dm_default_key(struct bio *dst,
+						 const struct bio *src);
+
 int __bio_crypt_clone(struct bio *dst, struct bio *src, gfp_t gfp_mask);
 /**
  * bio_crypt_clone - clone bio encryption context
  * @dst: destination bio
  * @src: source bio
@@ -125,11 +128,44 @@ int __bio_crypt_clone(struct bio *dst, struct bio *src, gfp_t gfp_mask);
  *	   @gfp_mask doesn't include %__GFP_DIRECT_RECLAIM.
  */
 static inline int bio_crypt_clone(struct bio *dst, struct bio *src,
 				  gfp_t gfp_mask)
 {
+	bio_clone_skip_dm_default_key(dst, src);
 	if (bio_has_crypt_ctx(src))
 		return __bio_crypt_clone(dst, src, gfp_mask);
 	return 0;
 }
 
+#if IS_ENABLED(CONFIG_DM_DEFAULT_KEY)
+static inline void bio_set_skip_dm_default_key(struct bio *bio)
+{
+	bio->bi_skip_dm_default_key = true;
+}
+
+static inline bool bio_should_skip_dm_default_key(const struct bio *bio)
+{
+	return bio->bi_skip_dm_default_key;
+}
+
+static inline void bio_clone_skip_dm_default_key(struct bio *dst,
+						 const struct bio *src)
+{
+	dst->bi_skip_dm_default_key = src->bi_skip_dm_default_key;
+}
+#else /* CONFIG_DM_DEFAULT_KEY */
+static inline void bio_set_skip_dm_default_key(struct bio *bio)
+{
+}
+
+static inline bool bio_should_skip_dm_default_key(const struct bio *bio)
+{
+	return false;
+}
+
+static inline void bio_clone_skip_dm_default_key(struct bio *dst,
+						 const struct bio *src)
+{
+}
+#endif /* !CONFIG_DM_DEFAULT_KEY */
+
 #endif /* __LINUX_BLK_CRYPTO_H */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7e..2ee6a7e570796 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -247,10 +247,13 @@ struct bio {
 #endif
 #endif
 
 #ifdef CONFIG_BLK_INLINE_ENCRYPTION
 	struct bio_crypt_ctx	*bi_crypt_context;
+#if IS_ENABLED(CONFIG_DM_DEFAULT_KEY)
+	bool			bi_skip_dm_default_key;
+#endif
 #endif
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 	struct bio_integrity_payload *bi_integrity; /* data integrity */
 #endif
-- 
2.47.0


