Return-Path: <linux-fscrypt+bounces-650-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 305CAA979AB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Apr 2025 23:45:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F97C7AF975
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Apr 2025 21:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DCE25CC72;
	Tue, 22 Apr 2025 21:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VR0N0n3F"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2E825C801;
	Tue, 22 Apr 2025 21:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745358167; cv=none; b=qstLJ19N9+md6kxG8rX+LSvLsblhpJKVwEKJVS5gbBpTuUsm/q2tSKDPZ3KpYQPHBKsYhcbmHWOWcLJmTg+hONUC5t2t/5vq+itwPoWnpFGtaeQrXJRA/4ZM44pkGr2E4MxVe1pE9iFTn1EKZr4VzDFheWOV0IAebjlEnDc0Eqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745358167; c=relaxed/simple;
	bh=XSAHz7JbAhLf+gT0Q13MkajgK7jceJ56hzcCBjL9Ho0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFLxs0pPrmWTCV41iBNki6EQKtdBRc5I9GszX8Ya5bKdNIYla+EfQg6nNDLRlK94tjTqhctweC98FVGcGph62Zc9w8byhpUigVyuc8L+hBxN/EmsCA31cFG4TQTPgVdr8ZBgQXz/f1cui8/frld+mdKBEDk+Qeh5yHaNk6tyyQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VR0N0n3F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22BBC4CEEF;
	Tue, 22 Apr 2025 21:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745358167;
	bh=XSAHz7JbAhLf+gT0Q13MkajgK7jceJ56hzcCBjL9Ho0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VR0N0n3FMmK9XnJ7znKrRU+RSxuPqj/2SHbgssZ4EVDF8q9GcN7OwY8W4zx9VJNSe
	 oT55sUlJiOarupjVwu644RbcpGuoyeKdzDt1ekLKuWa2uI4c75oIWPE6Mj7NG+Xhq1
	 6+qgHr7S8rVvdMsIzNA9WtYgh2PsyStswqMmc5WXpZF7U4DhoOqanutDx5IpCLgh7b
	 a7XkZ3UCIk8lhi7CQ75ctHdadyoGZY+rwYOjQXIy/Z/FLTJ/bof9F9GYiUjehK1wYS
	 m6AuP4L+asbwtBZrRPwF/DNztFIym2p/B6hR45aY1Jm5wBAOsuJkXXTZSLByzel+Jf
	 ax7xK5lKEEwQg==
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
Subject: [PATCH 2/2] dm: pass through operations on wrapped inline crypto keys
Date: Tue, 22 Apr 2025 14:42:11 -0700
Message-ID: <20250422214211.242382-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422214211.242382-1-ebiggers@kernel.org>
References: <20250422214211.242382-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Make the device-mapper layer pass through the derive_sw_secret,
import_key, generate_key, and prepare_key blk-crypto operations when all
underlying devices support hardware-wrapped inline crypto keys and are
passing through inline crypto support.

Commit ebc4176551cd ("blk-crypto: add basic hardware-wrapped key
support") already made BLK_CRYPTO_KEY_TYPE_HW_WRAPPED be passed through
in the same way that the other crypto capabilities are.  But the wrapped
key support also includes additional operations in blk_crypto_ll_ops,
and the dm layer needs to implement those to pass them through.
derive_sw_secret is needed by fscrypt, while the other operations are
needed for the new blk-crypto ioctls to work on device-mapper devices
and not just the raw partitions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

I've tried to share code between the different operations, but it was a
little difficult since currently dm device iteration is callback-based.
Hopefully the current patch is okay, but we can also duplicate the
iteration code for each operation if that's preferred.

 drivers/md/dm-table.c | 175 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 175 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 35100a435c88b..9922607a25ddc 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1188,10 +1188,178 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }
 
+enum dm_wrappedkey_op {
+	DERIVE_SW_SECRET,
+	IMPORT_KEY,
+	GENERATE_KEY,
+	PREPARE_KEY,
+};
+
+struct dm_wrappedkey_op_args {
+	enum dm_wrappedkey_op op;
+	int err;
+	union {
+		struct {
+			const u8 *eph_key;
+			size_t eph_key_size;
+			u8 *sw_secret;
+		} derive_sw_secret;
+		struct {
+			const u8 *raw_key;
+			size_t raw_key_size;
+			u8 *lt_key;
+		} import_key;
+		struct {
+			u8 *lt_key;
+		} generate_key;
+		struct {
+			const u8 *lt_key;
+			size_t lt_key_size;
+			u8 *eph_key;
+		} prepare_key;
+	};
+};
+
+static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
+				     sector_t start, sector_t len, void *data)
+{
+	struct dm_wrappedkey_op_args *args = data;
+	struct block_device *bdev = dev->bdev;
+	struct blk_crypto_profile *profile =
+		bdev_get_queue(bdev)->crypto_profile;
+	int err = -EOPNOTSUPP;
+
+	if (!args->err)
+		return 0;
+
+	switch (args->op) {
+	case DERIVE_SW_SECRET:
+		err = blk_crypto_derive_sw_secret(
+					bdev,
+					args->derive_sw_secret.eph_key,
+					args->derive_sw_secret.eph_key_size,
+					args->derive_sw_secret.sw_secret);
+		break;
+	case IMPORT_KEY:
+		err = blk_crypto_import_key(profile,
+					    args->import_key.raw_key,
+					    args->import_key.raw_key_size,
+					    args->import_key.lt_key);
+		break;
+	case GENERATE_KEY:
+		err = blk_crypto_generate_key(profile,
+					      args->generate_key.lt_key);
+		break;
+	case PREPARE_KEY:
+		err = blk_crypto_prepare_key(profile,
+					     args->prepare_key.lt_key,
+					     args->prepare_key.lt_key_size,
+					     args->prepare_key.eph_key);
+		break;
+	}
+	args->err = err;
+
+	/* Try another device in case this fails. */
+	return 0;
+}
+
+static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
+				 struct dm_wrappedkey_op_args *args)
+{
+	struct mapped_device *md =
+		container_of(profile, struct dm_crypto_profile, profile)->md;
+	struct dm_target *ti;
+	struct dm_table *t;
+	int srcu_idx;
+	int i;
+
+	t = dm_get_live_table(md, &srcu_idx);
+	if (!t)
+		return -EOPNOTSUPP;
+
+	/*
+	 * blk-crypto currently has no support for multiple incompatible
+	 * implementations of wrapped inline crypto keys on a single system.
+	 * It was already checked earlier that support for wrapped keys was
+	 * declared on all underlying devices.  Thus, all the underlying devices
+	 * should support all wrapped key operations and they should behave
+	 * identically, i.e. work with the same keys.  So, just executing the
+	 * operation on the first device on which it works suffices for now.
+	 */
+	args->err = -EOPNOTSUPP;
+	for (i = 0; i < t->num_targets; i++) {
+		ti = dm_table_get_target(t, i);
+		if (!ti->type->iterate_devices)
+			continue;
+		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
+		if (!args->err)
+			break;
+	}
+	dm_put_live_table(md, srcu_idx);
+	return args->err;
+}
+
+static int dm_derive_sw_secret(struct blk_crypto_profile *profile,
+			       const u8 *eph_key, size_t eph_key_size,
+			       u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
+{
+	struct dm_wrappedkey_op_args args = {
+		.op = DERIVE_SW_SECRET,
+		.derive_sw_secret = {
+			.eph_key = eph_key,
+			.eph_key_size = eph_key_size,
+			.sw_secret = sw_secret,
+		},
+	};
+	return dm_exec_wrappedkey_op(profile, &args);
+}
+
+static int dm_import_key(struct blk_crypto_profile *profile,
+			 const u8 *raw_key, size_t raw_key_size,
+			 u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct dm_wrappedkey_op_args args = {
+		.op = IMPORT_KEY,
+		.import_key = {
+			.raw_key = raw_key,
+			.raw_key_size = raw_key_size,
+			.lt_key = lt_key,
+		},
+	};
+	return dm_exec_wrappedkey_op(profile, &args);
+}
+
+static int dm_generate_key(struct blk_crypto_profile *profile,
+			   u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct dm_wrappedkey_op_args args = {
+		.op = GENERATE_KEY,
+		.generate_key = {
+			.lt_key = lt_key,
+		},
+	};
+	return dm_exec_wrappedkey_op(profile, &args);
+}
+
+static int dm_prepare_key(struct blk_crypto_profile *profile,
+			  const u8 *lt_key, size_t lt_key_size,
+			  u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	struct dm_wrappedkey_op_args args = {
+		.op = PREPARE_KEY,
+		.prepare_key = {
+			.lt_key = lt_key,
+			.lt_key_size = lt_key_size,
+			.eph_key = eph_key,
+		},
+	};
+	return dm_exec_wrappedkey_op(profile, &args);
+}
+
 static int
 device_intersect_crypto_capabilities(struct dm_target *ti, struct dm_dev *dev,
 				     sector_t start, sector_t len, void *data)
 {
 	struct blk_crypto_profile *parent = data;
@@ -1262,10 +1430,17 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
 		ti->type->iterate_devices(ti,
 					  device_intersect_crypto_capabilities,
 					  profile);
 	}
 
+	if (profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED) {
+		profile->ll_ops.derive_sw_secret = dm_derive_sw_secret;
+		profile->ll_ops.import_key = dm_import_key;
+		profile->ll_ops.generate_key = dm_generate_key;
+		profile->ll_ops.prepare_key = dm_prepare_key;
+	}
+
 	if (t->md->queue &&
 	    !blk_crypto_has_capabilities(profile,
 					 t->md->queue->crypto_profile)) {
 		DMERR("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
 		dm_destroy_crypto_profile(profile);
-- 
2.49.0


