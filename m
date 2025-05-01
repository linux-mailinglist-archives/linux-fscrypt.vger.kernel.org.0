Return-Path: <linux-fscrypt+bounces-652-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EEB11AA6556
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 23:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90D399A54DA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 21:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796F22609EE;
	Thu,  1 May 2025 21:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4KpIxDf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DE6253350;
	Thu,  1 May 2025 21:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134668; cv=none; b=mHuHVDPjjREX5x13ma/+Mn1cTOi8SQHtIHdI8hRZ0Hn/gIdK2sjzFhGReQAgyekmNPF+gfHamV/SceOAbsTJCZPf3ocId1CqSdsNjTiHFhUFYXgGcTNqRvFuZ/CqHXJT28U9hs7nL5BrXN34GJ3Pb/SWXMPTw0nggYF3aIsMAPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134668; c=relaxed/simple;
	bh=f/H23QKsdZ3lO7p7j9w911bWgO4kzgwjX4VvQ4X/6YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOWlq0mtTeLH/KHJ2j3bRv82AGriZ5tnxJ8mwB8pKbg3Wpai+VmZRae6rFxxDzF/77R4rYtZu1SKZeO9eVLQ5VU3XHBY/TpWktHTlLutZOwQEz8GtngjuqRw9q9oOcq8oUrI/Hro7dsVusU4nFRPV84UzQUd3vIWY78RWLK29yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4KpIxDf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A87FC4CEEE;
	Thu,  1 May 2025 21:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746134667;
	bh=f/H23QKsdZ3lO7p7j9w911bWgO4kzgwjX4VvQ4X/6YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4KpIxDfxR2Sek4mls8F2i3kM9jtU6hXUQosBvlx7citOCB5UnXWcf6BFDssF+zeG
	 kJp3hY8C2wq+MAE4dF3YNUUGbArC/z0uNMJdT6e4godyVL52SKYeaBlGIMns6BFuO/
	 AmV3v78bAST9v4FXAXlBJdTx9g4sYrhX9tDZIaHUQqMVNP8n9kEkLJUYyBbYzQRXNO
	 ypyqFJceZPC9Pe+SO/3SdkTm0LT3ajK/DaRhk9Pd/Em8yQVoQUX23t3YCse068q11E
	 jLBLbngZEs2PpeD9q6Zr+8JR19W4+HGnkvS0xTfsVTwS73LS9UqgfajMRcn6OtL4LH
	 d2eTHRSwUmIMA==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 1/2] blk-crypto: export wrapped key functions
Date: Thu,  1 May 2025 14:23:19 -0700
Message-ID: <20250501212320.8281-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250501212320.8281-1-ebiggers@kernel.org>
References: <20250501212320.8281-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Export blk_crypto_derive_sw_secret(), blk_crypto_import_key(),
blk_crypto_generate_key(), and blk_crypto_prepare_key() so that they can
be used by device-mapper when passing through wrapped key support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-profile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 94a155912bf1c..81918f6e0caea 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -499,10 +499,11 @@ int blk_crypto_derive_sw_secret(struct block_device *bdev,
 	err = profile->ll_ops.derive_sw_secret(profile, eph_key, eph_key_size,
 					       sw_secret);
 	blk_crypto_hw_exit(profile);
 	return err;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_derive_sw_secret);
 
 int blk_crypto_import_key(struct blk_crypto_profile *profile,
 			  const u8 *raw_key, size_t raw_key_size,
 			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 {
@@ -518,10 +519,11 @@ int blk_crypto_import_key(struct blk_crypto_profile *profile,
 	ret = profile->ll_ops.import_key(profile, raw_key, raw_key_size,
 					 lt_key);
 	blk_crypto_hw_exit(profile);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_import_key);
 
 int blk_crypto_generate_key(struct blk_crypto_profile *profile,
 			    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 {
 	int ret;
@@ -535,10 +537,11 @@ int blk_crypto_generate_key(struct blk_crypto_profile *profile,
 	blk_crypto_hw_enter(profile);
 	ret = profile->ll_ops.generate_key(profile, lt_key);
 	blk_crypto_hw_exit(profile);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_generate_key);
 
 int blk_crypto_prepare_key(struct blk_crypto_profile *profile,
 			   const u8 *lt_key, size_t lt_key_size,
 			   u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
 {
@@ -554,10 +557,11 @@ int blk_crypto_prepare_key(struct blk_crypto_profile *profile,
 	ret = profile->ll_ops.prepare_key(profile, lt_key, lt_key_size,
 					  eph_key);
 	blk_crypto_hw_exit(profile);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(blk_crypto_prepare_key);
 
 /**
  * blk_crypto_intersect_capabilities() - restrict supported crypto capabilities
  *					 by child device
  * @parent: the crypto profile for the parent device
-- 
2.49.0


