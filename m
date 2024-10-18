Return-Path: <linux-fscrypt+bounces-502-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C09619A4615
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 20:45:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B9AC1F24B8A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 18:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9AC31865F3;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jtMpLz7F"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588E6204950;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277105; cv=none; b=fevCuEaA1MKO3U6jsBw9jSxpfPFiwPQoElTLVKp5omPssRB5jNywAf7DTVOoWYDTXh9qOXpZaCFTLGPM+jr0LHzkHKDSTvEIkKcoSL09JEsJf61nZ5WQV3vDiE5/ekZTeqR+BcC/8V8CKaJMC8W35vzAhKB2Tv5HX3FEUvxZufQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277105; c=relaxed/simple;
	bh=gDP8bNinKpdnrrwyqZpwB7f4CjBe/aJ8mHb0cW6EzyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdNj5O4j4uU9whAM1Ia8xsX7cL1U/qOeC2+xahgS1auKOiaUaDA87AOqoEo/MMh9LMPavfY0IkBd/D4sdHOqdYfiPiqGT5ai9GNZ/BZOjC5carSfVfyaWKJZEm1aR2+De9JxnvM2h9weFnmZxmlE5MPn2n3GyU2ExIgYxC8ptrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jtMpLz7F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2BDC4CEC5;
	Fri, 18 Oct 2024 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277104;
	bh=gDP8bNinKpdnrrwyqZpwB7f4CjBe/aJ8mHb0cW6EzyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtMpLz7FOC53ds7U19K69hS1Vhm/axzXN37sg529ObJME8qhr+bnA90aW60XZau8z
	 CZJSrha/KceHnkk1+CeEhYSPpvcyWn1o4Zh3PoetfnWkNsljuGKYQpz1XNaLqPXGXM
	 9z0jt5TRRYvWLBU7uhfoujlZpf0mQRYchc5hSrXBwhM9iwJOsUFTBCHAbHHQlASraa
	 thUuY3tmEdQMkAL0pz+/RN2sRrJ9BaeuZFUUeojMjach+iL6XQEUXvWL50sIy03JuP
	 jCQcuuSXt2/OU+Ea+E6/VkAcQw2Exz3syuKiK9sDlkfVs2D6WVXrvsTCUvWLhnIe1M
	 02dW7di19adaw==
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
Subject: [RFC PATCH 1/4] block: export blk-crypto symbols required by dm-default-key
Date: Fri, 18 Oct 2024 11:43:36 -0700
Message-ID: <20241018184339.66601-2-ebiggers@kernel.org>
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

bio_crypt_set_ctx(), blk_crypto_init_key(), and
blk_crypto_start_using_key() are needed to use inline encryption; see
Documentation/block/inline-encryption.rst.  Export them so that
dm-default-key can use them.  The only reason these weren't exported
before was that inline encryption was previously used only by fs/crypto/
which is built-in code.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb9..5a121b1292f9a 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -104,10 +104,11 @@ void bio_crypt_set_ctx(struct bio *bio, const struct blk_crypto_key *key,
 	bc->bc_key = key;
 	memcpy(bc->bc_dun, dun, sizeof(bc->bc_dun));
 
 	bio->bi_crypt_context = bc;
 }
+EXPORT_SYMBOL_GPL(bio_crypt_set_ctx);
 
 void __bio_crypt_free_ctx(struct bio *bio)
 {
 	mempool_free(bio->bi_crypt_context, bio_crypt_ctx_pool);
 	bio->bi_crypt_context = NULL;
@@ -354,10 +355,11 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key, const u8 *raw_key,
 	blk_key->size = mode->keysize;
 	memcpy(blk_key->raw, raw_key, mode->keysize);
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
 {
 	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
@@ -396,10 +398,11 @@ int blk_crypto_start_using_key(struct block_device *bdev,
 {
 	if (blk_crypto_config_supported_natively(bdev, &key->crypto_cfg))
 		return 0;
 	return blk_crypto_fallback_start_using_mode(key->crypto_cfg.crypto_mode);
 }
+EXPORT_SYMBOL_GPL(blk_crypto_start_using_key);
 
 /**
  * blk_crypto_evict_key() - Evict a blk_crypto_key from a block_device
  * @bdev: a block_device on which I/O using the key may have been done
  * @key: the key to evict
-- 
2.47.0


