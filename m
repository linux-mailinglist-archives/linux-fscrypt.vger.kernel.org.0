Return-Path: <linux-fscrypt+bounces-653-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB51AA6558
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 23:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C14C91BA1788
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 May 2025 21:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7044D264FA4;
	Thu,  1 May 2025 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FV/w5keK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41616264F96;
	Thu,  1 May 2025 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746134669; cv=none; b=njoMDSMbhvtDpLrQDK6BXi2pDeI+Pb8qsZsTdudnOGQGT4PGvO6Ml17Ing8IuoFAw2yv7kazGPfy+Cb5Lq2FlyFgvemcx0+I5h3BLZxP+RraXHM9fZisf3CF4UxMOpozmMcKrL+w1BL07eGqeU4O+qvhe0gKcG/wGSFf/sd6f5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746134669; c=relaxed/simple;
	bh=jFsFoE7A5fqF3r4J9RuulyP8XJdFV/hqvJUzPhKTZJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkpQX+uFaAGHuwwUFQ8OEZCHgJqWx7ClH+Qxy1o3UXCMjmd2AYtncre/CI3SGX7ElcWw9fgm8hl8onDaTRSNmKz0L+Iv6E1Al0CH38COmzey4JVV0e6jVf7l4QmGdY5/Dn7YZySYvZHApcc4UZhyyRl4nB3GIIW5VjmH6ZTusW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FV/w5keK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C70C4CEF2;
	Thu,  1 May 2025 21:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746134669;
	bh=jFsFoE7A5fqF3r4J9RuulyP8XJdFV/hqvJUzPhKTZJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV/w5keKkEY913OZziINq+cRUFfFaUpDUpOwJg4itK9A4mkknEWeMU4MnolYjsHjz
	 zyHIjEqsKTjgWTsBdLktzchQsFhjKVWsG4X9Bk6UtSTtdVtHTHvHYqNa2/+6JA5fZH
	 dy8CfiuIVDi5qLI47IxT2pji8vGoyaasBlysi6rGXj6JelZhfKEW7Qzx6J+k8diGOM
	 5t7X+Ykde9/6TXz+CxFm8WW0el7njPxKUIMVUoBo2LDxNkyWrQCD/I/PhGK/M0dYzI
	 HPB8HKs8F6bga1nVWthY9KzS5tGpaIIjq8KGAZveXnmrr5nqcJVqbPqUAIEd5dNKT/
	 nBcFhpd534wTg==
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
Subject: [PATCH v2 2/2] dm: pass through operations on wrapped inline crypto keys
Date: Thu,  1 May 2025 14:23:20 -0700
Message-ID: <20250501212320.8281-3-ebiggers@kernel.org>
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
 drivers/md/dm-table.c | 177 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 177 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a937e1e12482e..0a71bedff81c5 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1189,10 +1189,180 @@ static int dm_keyslot_evict(struct blk_crypto_profile *profile,
 
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
+	args->err = -EOPNOTSUPP;
+
+	t = dm_get_live_table(md, &srcu_idx);
+	if (!t)
+		goto out;
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
+	for (i = 0; i < t->num_targets; i++) {
+		ti = dm_table_get_target(t, i);
+		if (!ti->type->iterate_devices)
+			continue;
+		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
+		if (!args->err)
+			break;
+	}
+out:
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
@@ -1263,10 +1433,17 @@ static int dm_table_construct_crypto_profile(struct dm_table *t)
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


