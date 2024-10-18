Return-Path: <linux-fscrypt+bounces-504-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C7AA9A4623
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 20:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00DB71F24030
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Oct 2024 18:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8529205AB6;
	Fri, 18 Oct 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KRKQQW8p"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF90205144;
	Fri, 18 Oct 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729277106; cv=none; b=lQJzVyi1cq3azXqmtf5G5vxZSC7TceVczyBTUswleWbzxOsRgT9Brljjf3mwgWZGc1QiWCAklHWhu0yh8p+hemChPEJ5Vk4iLL75Onx/SNhbajcWc6h92Iob3+tqUAyRnJgyYp4XYmR77PnSJGsygAv4cNpaOVGo0yn9XF7tXYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729277106; c=relaxed/simple;
	bh=YNR1kvNbQQR1kTa73HYuLBTBit5Z481N6jlagYv4A1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/Cq7RUK5mu+RkDKfrh++B2dnXi+HZZPuiRy8mCx47ZoKSTG6NAG2MDrORBdEBzIAL8cLOT/fGCQhPw1VMqrkHm0vmP82BCvXyX48jjMlXVz31NekNRQ3J52caCDKyF3UO2pDaTjEDhS6GMZpgl3RrE37hHYNz7fz1vPPgZ/2wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KRKQQW8p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C65C4CED1;
	Fri, 18 Oct 2024 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729277105;
	bh=YNR1kvNbQQR1kTa73HYuLBTBit5Z481N6jlagYv4A1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRKQQW8pEO/NABbHS2/S6tF5Ns6Wcw72l1verXHlkOoePWdGLdJx8YemyTbEt/Pgv
	 HepukA82wKyk+MdSlXPl56iBaLN4U2bFo/OGI/itBj4m6x04iDmXyIQA64/CGkz97b
	 kt9cLFHxKdH2tYNH8yKsnq0DTcva0/xmWKtq5ZRBhGypPEmj4htU/dobtSC+OVI+P5
	 MG297Q+M/Zvm4n63veOmdl77xA/P+0WZetY+kckUo2X5rLGPvyGKniwsfw18ufo0Mt
	 qLQq3z72PMF5nKU6qZAeXcYbCqUFgb2F8TVux4Tx+i1Sm/LUpMtMEmj8Iu/E9cPRlF
	 voVi9dUmmMysw==
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
Subject: [RFC PATCH 3/4] dm-default-key: add target for filesystem metadata encryption
Date: Fri, 18 Oct 2024 11:43:38 -0700
Message-ID: <20241018184339.66601-4-ebiggers@kernel.org>
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

Add a new device-mapper target "dm-default-key" that is similar to
dm-crypt but has two main differences:

- It uses the blk-crypto API instead of the regular crypto API.  This
  allows it to take advantage of inline encryption hardware such as that
  commonly built into UFS host controllers.

- It supports a passthrough flag, which will be used by ext4 and f2fs to
  avoid double encryption of encrypted files.  In this setup,
  dm-default-key provides the "metadata encryption" layer.

The table syntax matches dm-crypt's, but for now only a stripped-down
set of parameters is supported.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/Kconfig          |  20 ++
 drivers/md/Makefile         |   1 +
 drivers/md/dm-default-key.c | 431 ++++++++++++++++++++++++++++++++++++
 3 files changed, 452 insertions(+)
 create mode 100644 drivers/md/dm-default-key.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 1e9db8e4acdf6..a9f35a8efbade 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -268,10 +268,30 @@ config DM_CRYPT
 	  To compile this code as a module, choose M here: the module will
 	  be called dm-crypt.
 
 	  If unsure, say N.
 
+config DM_DEFAULT_KEY
+	tristate "Default-key target support"
+	depends on BLK_DEV_DM
+	depends on BLK_INLINE_ENCRYPTION
+	# dm-default-key doesn't require -o inlinecrypt, but it does currently
+	# rely on the inline encryption hooks being built into the kernel.
+	depends on FS_ENCRYPTION_INLINE_CRYPT
+	help
+	  This device-mapper target allows you to create a device that
+	  assigns a default encryption key to bios that aren't for the
+	  contents of an encrypted file.
+
+	  This ensures that all blocks on-disk will be encrypted with
+	  some key, without the performance hit of file contents being
+	  encrypted twice when fscrypt is used.
+
+	  It is only appropriate to use dm-default-key when key
+	  configuration is tightly controlled such that all fscrypt keys
+	  are at least as hard to compromise as the default key.
+
 config DM_SNAPSHOT
        tristate "Snapshot target"
        depends on BLK_DEV_DM
        select DM_BUFIO
 	help
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 476a214e4bdc2..1dc4b20b506db 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -49,10 +49,11 @@ obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
 obj-$(CONFIG_DM_UNSTRIPED)	+= dm-unstripe.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
+obj-$(CONFIG_DM_DEFAULT_KEY)	+= dm-default-key.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
 obj-$(CONFIG_DM_DUST)		+= dm-dust.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
diff --git a/drivers/md/dm-default-key.c b/drivers/md/dm-default-key.c
new file mode 100644
index 0000000000000..f5533418b4456
--- /dev/null
+++ b/drivers/md/dm-default-key.c
@@ -0,0 +1,431 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2024 Google LLC
+ */
+
+#include <linux/blk-crypto.h>
+#include <linux/device-mapper.h>
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX		"default-key"
+
+static const struct dm_default_key_cipher {
+	const char *name;
+	enum blk_crypto_mode_num mode_num;
+	int key_size;
+} dm_default_key_ciphers[] = {
+	{
+		.name = "aes-xts-plain64",
+		.mode_num = BLK_ENCRYPTION_MODE_AES_256_XTS,
+		.key_size = 64,
+	}, {
+		.name = "xchacha12,aes-adiantum-plain64",
+		.mode_num = BLK_ENCRYPTION_MODE_ADIANTUM,
+		.key_size = 32,
+	},
+};
+
+/**
+ * struct dm_default_c - private data of a default-key target
+ * @dev: the underlying device
+ * @start: starting sector of the range of @dev which this target actually maps.
+ *	   For this purpose a "sector" is 512 bytes.
+ * @cipher_string: the name of the encryption algorithm being used
+ * @iv_offset: starting offset for IVs.  IVs are generated as if the target were
+ *	       preceded by @iv_offset 512-byte sectors.
+ * @sector_size: crypto sector size in bytes (usually 4096)
+ * @sector_bits: log2(sector_size)
+ * @key: the encryption key to use
+ * @max_dun: the maximum DUN that may be used (computed from other params)
+ */
+struct default_key_c {
+	struct dm_dev *dev;
+	sector_t start;
+	const char *cipher_string;
+	u64 iv_offset;
+	unsigned int sector_size;
+	unsigned int sector_bits;
+	struct blk_crypto_key key;
+	u64 max_dun;
+};
+
+static const struct dm_default_key_cipher *
+lookup_cipher(const char *cipher_string)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dm_default_key_ciphers); i++) {
+		if (strcmp(cipher_string, dm_default_key_ciphers[i].name) == 0)
+			return &dm_default_key_ciphers[i];
+	}
+	return NULL;
+}
+
+static void default_key_dtr(struct dm_target *ti)
+{
+	struct default_key_c *dkc = ti->private;
+
+	if (dkc->dev) {
+		if (dkc->key.size)
+			blk_crypto_evict_key(dkc->dev->bdev, &dkc->key);
+		dm_put_device(ti, dkc->dev);
+	}
+	kfree_sensitive(dkc->cipher_string);
+	kfree_sensitive(dkc);
+}
+
+static int default_key_ctr_optional(struct dm_target *ti,
+				    unsigned int argc, char **argv)
+{
+	struct default_key_c *dkc = ti->private;
+	struct dm_arg_set as;
+	static const struct dm_arg _args[] = {
+		{0, 3, "Invalid number of feature args"},
+	};
+	unsigned int opt_params;
+	const char *opt_string;
+	bool iv_large_sectors = false;
+	char dummy;
+	int err;
+
+	as.argc = argc;
+	as.argv = argv;
+
+	err = dm_read_arg_group(_args, &as, &opt_params, &ti->error);
+	if (err)
+		return err;
+
+	while (opt_params--) {
+		opt_string = dm_shift_arg(&as);
+		if (!opt_string) {
+			ti->error = "Not enough feature arguments";
+			return -EINVAL;
+		}
+		if (!strcmp(opt_string, "allow_discards")) {
+			ti->num_discard_bios = 1;
+		} else if (sscanf(opt_string, "sector_size:%u%c",
+				  &dkc->sector_size, &dummy) == 1) {
+			if (dkc->sector_size < SECTOR_SIZE ||
+			    dkc->sector_size > 4096 ||
+			    !is_power_of_2(dkc->sector_size)) {
+				ti->error = "Invalid sector_size";
+				return -EINVAL;
+			}
+		} else if (!strcmp(opt_string, "iv_large_sectors")) {
+			iv_large_sectors = true;
+		} else {
+			ti->error = "Invalid feature arguments";
+			return -EINVAL;
+		}
+	}
+
+	/* dm-default-key doesn't implement iv_large_sectors=false. */
+	if (dkc->sector_size != SECTOR_SIZE && !iv_large_sectors) {
+		ti->error = "iv_large_sectors must be specified";
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * Construct a default-key mapping:
+ * <cipher> <key> <iv_offset> <dev_path> <start>
+ *
+ * This syntax matches dm-crypt's, but the set of supported functionality has
+ * been stripped down.
+ */
+static int default_key_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct default_key_c *dkc;
+	const struct dm_default_key_cipher *cipher;
+	u8 raw_key[BLK_CRYPTO_MAX_KEY_SIZE];
+	unsigned int dun_bytes;
+	unsigned long long tmpll;
+	char dummy;
+	int err;
+
+	if (argc < 5) {
+		ti->error = "Not enough arguments";
+		return -EINVAL;
+	}
+
+	dkc = kzalloc(sizeof(*dkc), GFP_KERNEL);
+	if (!dkc) {
+		ti->error = "Out of memory";
+		return -ENOMEM;
+	}
+	ti->private = dkc;
+
+	/* <cipher> */
+	dkc->cipher_string = kstrdup(argv[0], GFP_KERNEL);
+	if (!dkc->cipher_string) {
+		ti->error = "Out of memory";
+		err = -ENOMEM;
+		goto bad;
+	}
+	cipher = lookup_cipher(dkc->cipher_string);
+	if (!cipher) {
+		ti->error = "Unsupported cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <key> */
+	if (strlen(argv[1]) != 2 * cipher->key_size) {
+		ti->error = "Incorrect key size for cipher";
+		err = -EINVAL;
+		goto bad;
+	}
+	if (hex2bin(raw_key, argv[1], cipher->key_size) != 0) {
+		ti->error = "Malformed key string";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <iv_offset> */
+	if (sscanf(argv[2], "%llu%c", &dkc->iv_offset, &dummy) != 1) {
+		ti->error = "Invalid iv_offset sector";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	/* <dev_path> */
+	err = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table),
+			    &dkc->dev);
+	if (err) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	/* <start> */
+	if (sscanf(argv[4], "%llu%c", &tmpll, &dummy) != 1 ||
+	    tmpll != (sector_t)tmpll) {
+		ti->error = "Invalid start sector";
+		err = -EINVAL;
+		goto bad;
+	}
+	dkc->start = tmpll;
+
+	if (bdev_is_zoned(dkc->dev->bdev)) {
+		/*
+		 * dm-default-key needs proper sector numbers because they
+		 * determine the IVs with which the data is encrypted.
+		 */
+		DMDEBUG("Zone append operations will be emulated");
+		ti->emulate_zone_append = true;
+	}
+
+	/* optional arguments */
+	dkc->sector_size = SECTOR_SIZE;
+	if (argc > 5) {
+		err = default_key_ctr_optional(ti, argc - 5, &argv[5]);
+		if (err)
+			goto bad;
+	}
+	dkc->sector_bits = ilog2(dkc->sector_size);
+	if (ti->len & ((dkc->sector_size >> SECTOR_SHIFT) - 1)) {
+		ti->error = "Device size is not a multiple of sector_size";
+		err = -EINVAL;
+		goto bad;
+	}
+
+	dkc->max_dun = (dkc->iv_offset + ti->len - 1) >>
+		       (dkc->sector_bits - SECTOR_SHIFT);
+	dun_bytes = DIV_ROUND_UP(fls64(dkc->max_dun), 8);
+
+	err = blk_crypto_init_key(&dkc->key, raw_key, cipher->mode_num,
+				  dun_bytes, dkc->sector_size);
+	if (err) {
+		ti->error = "Error initializing blk-crypto key";
+		goto bad;
+	}
+
+	err = blk_crypto_start_using_key(dkc->dev->bdev, &dkc->key);
+	if (err) {
+		ti->error = "Error starting to use blk-crypto";
+		goto bad;
+	}
+
+	ti->num_flush_bios = 1;
+
+	err = 0;
+	goto out;
+
+bad:
+	default_key_dtr(ti);
+out:
+	memzero_explicit(raw_key, sizeof(raw_key));
+	return err;
+}
+
+static int default_key_map(struct dm_target *ti, struct bio *bio)
+{
+	const struct default_key_c *dkc = ti->private;
+	sector_t sector_in_target;
+	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE] = {};
+
+	bio_set_dev(bio, dkc->dev->bdev);
+
+	/*
+	 * If the bio is a device-level request which doesn't target a specific
+	 * sector, there's nothing more to do.
+	 */
+	if (bio_sectors(bio) == 0)
+		return DM_MAPIO_REMAPPED;
+
+	/* Map the bio's sector to the underlying device. (512-byte sectors) */
+	sector_in_target = dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = dkc->start + sector_in_target;
+
+	/*
+	 * If the bio should skip dm-default-key (i.e. if it's for an encrypted
+	 * file's contents), or if it doesn't have any data (e.g. if it's a
+	 * DISCARD request), there's nothing more to do.
+	 */
+	if (bio_should_skip_dm_default_key(bio) || !bio_has_data(bio))
+		return DM_MAPIO_REMAPPED;
+
+	/*
+	 * Else, dm-default-key needs to set this bio's encryption context.
+	 * It must not already have one.
+	 */
+	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
+		return DM_MAPIO_KILL;
+
+	/* Calculate the DUN and enforce data-unit (crypto sector) alignment. */
+	dun[0] = dkc->iv_offset + sector_in_target; /* 512-byte sectors */
+	if (dun[0] & ((dkc->sector_size >> SECTOR_SHIFT) - 1))
+		return DM_MAPIO_KILL;
+	dun[0] >>= dkc->sector_bits - SECTOR_SHIFT; /* crypto sectors */
+
+	/*
+	 * This check isn't necessary as we should have calculated max_dun
+	 * correctly, but be safe.
+	 */
+	if (WARN_ON_ONCE(dun[0] > dkc->max_dun))
+		return DM_MAPIO_KILL;
+
+	bio_crypt_set_ctx(bio, &dkc->key, dun, GFP_NOIO);
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static void default_key_status(struct dm_target *ti, status_type_t type,
+			       unsigned int status_flags, char *result,
+			       unsigned int maxlen)
+{
+	const struct default_key_c *dkc = ti->private;
+	unsigned int sz = 0;
+	int num_feature_args = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+	case STATUSTYPE_IMA:
+		result[0] = '\0';
+		break;
+
+	case STATUSTYPE_TABLE:
+		/* Omit the key for now. */
+		DMEMIT("%s - %llu %s %llu", dkc->cipher_string, dkc->iv_offset,
+		       dkc->dev->name, (unsigned long long)dkc->start);
+
+		num_feature_args += !!ti->num_discard_bios;
+		if (dkc->sector_size != SECTOR_SIZE)
+			num_feature_args += 2;
+		if (num_feature_args != 0) {
+			DMEMIT(" %d", num_feature_args);
+			if (ti->num_discard_bios)
+				DMEMIT(" allow_discards");
+			if (dkc->sector_size != SECTOR_SIZE) {
+				DMEMIT(" sector_size:%u", dkc->sector_size);
+				DMEMIT(" iv_large_sectors");
+			}
+		}
+		break;
+	}
+}
+
+static int default_key_prepare_ioctl(struct dm_target *ti,
+				     struct block_device **bdev)
+{
+	const struct default_key_c *dkc = ti->private;
+	const struct dm_dev *dev = dkc->dev;
+
+	*bdev = dev->bdev;
+
+	/* Only pass ioctls through if the device sizes match exactly. */
+	return dkc->start != 0 || ti->len != bdev_nr_sectors(dev->bdev);
+}
+
+static int default_key_iterate_devices(struct dm_target *ti,
+				       iterate_devices_callout_fn fn,
+				       void *data)
+{
+	const struct default_key_c *dkc = ti->private;
+
+	return fn(ti, dkc->dev, dkc->start, ti->len, data);
+}
+
+#ifdef CONFIG_BLK_DEV_ZONED
+static int default_key_report_zones(struct dm_target *ti,
+				    struct dm_report_zones_args *args,
+				    unsigned int nr_zones)
+{
+	const struct default_key_c *dkc = ti->private;
+
+	return dm_report_zones(dkc->dev->bdev, dkc->start,
+			dkc->start + dm_target_offset(ti, args->next_sector),
+			args, nr_zones);
+}
+#else
+#define default_key_report_zones NULL
+#endif
+
+static void default_key_io_hints(struct dm_target *ti,
+				 struct queue_limits *limits)
+{
+	const struct default_key_c *dkc = ti->private;
+	const unsigned int sector_size = dkc->sector_size;
+
+	limits->logical_block_size =
+		max_t(unsigned int, limits->logical_block_size, sector_size);
+	limits->physical_block_size =
+		max_t(unsigned int, limits->physical_block_size, sector_size);
+	limits->io_min = max_t(unsigned int, limits->io_min, sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
+}
+
+static struct target_type default_key_target = {
+	.name			= "default-key",
+	.version		= {1, 0, 0},
+	.features		= DM_TARGET_PASSES_CRYPTO | DM_TARGET_ZONED_HM,
+	.module			= THIS_MODULE,
+	.ctr			= default_key_ctr,
+	.dtr			= default_key_dtr,
+	.map			= default_key_map,
+	.status			= default_key_status,
+	.prepare_ioctl		= default_key_prepare_ioctl,
+	.iterate_devices	= default_key_iterate_devices,
+	.report_zones		= default_key_report_zones,
+	.io_hints		= default_key_io_hints,
+};
+
+static int __init dm_default_key_init(void)
+{
+	return dm_register_target(&default_key_target);
+}
+
+static void __exit dm_default_key_exit(void)
+{
+	dm_unregister_target(&default_key_target);
+}
+
+module_init(dm_default_key_init);
+module_exit(dm_default_key_exit);
+
+MODULE_AUTHOR("Paul Lawrence <paullawrence@google.com>");
+MODULE_AUTHOR("Paul Crowley <paulcrowley@google.com>");
+MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
+MODULE_DESCRIPTION(DM_NAME " target for encrypting filesystem metadata");
+MODULE_LICENSE("GPL");
-- 
2.47.0


