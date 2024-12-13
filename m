Return-Path: <linux-fscrypt+bounces-564-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B680A9F03B4
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7343428178E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A72C218FDB1;
	Fri, 13 Dec 2024 04:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dlFmUH/a"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796BD1822E5;
	Fri, 13 Dec 2024 04:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063630; cv=none; b=sm1Vq/gP9lObSGGyzei4/sj1hBsk9C4ICFXkwM/cAPMsfG9KxFGfYPBQ3g/Lt0CCvHiAsxrPPoO6T6km/Mx2b0i/FSGxnJFarVw7G4Z49RlJgCDaFSc8O+2OuXGlhUqzIZ6coC78tBBebUU0yYqVycIg5l9vJ1wJIaptzdiKo2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063630; c=relaxed/simple;
	bh=22ghSgDD0aTGAPWx6pR0JpKHQj5XbWbyT/l/D1na1pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHYqW2zOd5dEly9TtdntShhq//3zZeOiFXMR3JuYMqlEvw+N4FLpZFahPCH36lsrLxrp6KUusPeUApp5w6u16DMYds2akNxMLE8gtTJXHLphmkP1JEXN6phb9zhPyEQwufXTFAcBLvA3lRtOX+0zsXDJhcqrCAn372qB0T6djuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dlFmUH/a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BC4C4AF11;
	Fri, 13 Dec 2024 04:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063630;
	bh=22ghSgDD0aTGAPWx6pR0JpKHQj5XbWbyT/l/D1na1pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dlFmUH/aL7/+JKvNuZbbbga7DvqeI8TfCJUp6I/jOOgL+DNnktAp4e3JkcwSlVgyw
	 helqK5OFJyx6bXTWYtMc5EIx6saYLBqh99Rgiho3HhQNJGcF4wEqeXCNGT1YLoT4aY
	 ksfUnZ1joVHOfQvW9RdGZ2zdYfPMe+smeORAOxmCir6uNWwyC8+3i9C1XgDRcT2EsI
	 h1HC+tfr+No2YvRhLOLTYiJkVINnGss4Xscf37A3LONk7go7ZuV79c8Q3TwTuxwniE
	 IdbgTeq4bTWH/+blsVfM2RSJVaxA/PdfsU+Go0rljM6VRB/aYk1VkM3HGUrRqL2piS
	 x/PVVYwOkVjgQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <axboe@kernel.dk>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH v10 12/15] blk-crypto: add ioctls to create and prepare hardware-wrapped keys
Date: Thu, 12 Dec 2024 20:19:55 -0800
Message-ID: <20241213041958.202565-13-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213041958.202565-1-ebiggers@kernel.org>
References: <20241213041958.202565-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Until this point, the kernel can use hardware-wrapped keys to do
encryption if userspace provides one -- specifically a key in
ephemerally-wrapped form.  However, no generic way has been provided for
userspace to get such a key in the first place.

Getting such a key is a two-step process.  First, the key needs to be
imported from a raw key or generated by the hardware, producing a key in
long-term wrapped form.  This happens once in the whole lifetime of the
key.  Second, the long-term wrapped key needs to be converted into
ephemerally-wrapped form.  This happens each time the key is "unlocked".

In Android, these operations are supported in a generic way through
KeyMint, a userspace abstraction layer.  However, that method is
Android-specific and can't be used on other Linux systems, may rely on
proprietary libraries, and also misleads people into supporting KeyMint
features like rollback resistance that make sense for other KeyMint keys
but don't make sense for hardware-wrapped inline encryption keys.

Therefore, this patch provides a generic kernel interface for these
operations by introducing new block device ioctls:

- BLKCRYPTOIMPORTKEY: convert a raw key to long-term wrapped form.

- BLKCRYPTOGENERATEKEY: have the hardware generate a new key, then
  return it in long-term wrapped form.

- BLKCRYPTOPREPAREKEY: convert a key from long-term wrapped form to
  ephemerally-wrapped form.

These ioctls are implemented using new operations in blk_crypto_ll_ops.

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/block/inline-encryption.rst     |  32 ++++
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 block/blk-crypto-internal.h                   |   9 ++
 block/blk-crypto-profile.c                    |  57 +++++++
 block/blk-crypto.c                            | 143 ++++++++++++++++++
 block/ioctl.c                                 |   5 +
 include/linux/blk-crypto-profile.h            |  53 +++++++
 include/linux/blk-crypto.h                    |   1 +
 include/uapi/linux/blk-crypto.h               |  44 ++++++
 include/uapi/linux/fs.h                       |   6 +-
 10 files changed, 348 insertions(+), 4 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h

diff --git a/Documentation/block/inline-encryption.rst b/Documentation/block/inline-encryption.rst
index f03bd5b090d8..004b230c80ad 100644
--- a/Documentation/block/inline-encryption.rst
+++ b/Documentation/block/inline-encryption.rst
@@ -490,10 +490,42 @@ when hardware support is available.  This works in the following way:
   keys being passed to these methods.
 
 blk-crypto-fallback doesn't support hardware-wrapped keys.  Therefore,
 hardware-wrapped keys can only be used with actual inline encryption hardware.
 
+All the above deals with hardware-wrapped keys in ephemerally-wrapped form only.
+To get such keys in the first place, new block device ioctls have been added to
+provide a generic interface to creating and preparing such keys:
+
+- ``BLKCRYPTOIMPORTKEY`` converts a raw key to long-term wrapped form.  It takes
+  in a pointer to a ``struct blk_crypto_import_key_arg``.  The caller must set
+  ``raw_key_ptr`` and ``raw_key_size`` to the pointer and size (in bytes) of the
+  raw key to import.  On success, ``BLKCRYPTOIMPORTKEY`` returns 0 and writes
+  the resulting long-term wrapped key blob to the buffer pointed to by
+  ``lt_key_ptr``, which is of maximum size ``lt_key_size``.  It also updates
+  ``lt_key_size`` to be the actual size of the key.  On failure, it returns -1
+  and sets errno.
+
+- ``BLKCRYPTOGENERATEKEY`` is like ``BLKCRYPTOIMPORTKEY``, but it has the
+  hardware generate the key instead of importing one.  It takes in a pointer to
+  a ``struct blk_crypto_generate_key_arg``.
+
+- ``BLKCRYPTOPREPAREKEY`` converts a key from long-term wrapped form to
+  ephemerally-wrapped form.  It takes in a pointer to a ``struct
+  blk_crypto_prepare_key_arg``.  The caller must set ``lt_key_ptr`` and
+  ``lt_key_size`` to the pointer and size (in bytes) of the long-term wrapped
+  key blob to convert.  On success, ``BLKCRYPTOPREPAREKEY`` returns 0 and writes
+  the resulting ephemerally-wrapped key blob to the buffer pointed to by
+  ``eph_key_ptr``, which is of maximum size ``eph_key_size``.  It also updates
+  ``eph_key_size`` to be the actual size of the key.  On failure, it returns -1
+  and sets errno.
+
+Userspace needs to use either ``BLKCRYPTOIMPORTKEY`` or ``BLKCRYPTOGENERATEKEY``
+once to create a key, and then ``BLKCRYPTOPREPAREKEY`` each time the key is
+unlocked and added to the kernel.  Note that these ioctls have no relevance for
+raw keys; they are only for hardware-wrapped keys.
+
 Testability
 -----------
 
 Both the hardware KDF and the inline encryption itself are well-defined
 algorithms that don't depend on any secrets other than the unwrapped key.
diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 243f1f1b554a..b9d385e3c7bc 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -83,10 +83,12 @@ Code  Seq#    Include File                                           Comments
 0x10  00-0F  drivers/char/s390/vmcp.h
 0x10  10-1F  arch/s390/include/uapi/sclp_ctl.h
 0x10  20-2F  arch/s390/include/uapi/asm/hypfs.h
 0x12  all    linux/fs.h                                              BLK* ioctls
              linux/blkpg.h
+             linux/blkzoned.h
+             linux/blk-crypto.h
 0x15  all    linux/fs.h                                              FS_IOC_* ioctls
 0x1b  all                                                            InfiniBand Subsystem
                                                                      <http://infiniband.sourceforge.net/>
 0x20  all    drivers/cdrom/cm206.h
 0x22  all    scsi/sg.h
diff --git a/block/blk-crypto-internal.h b/block/blk-crypto-internal.h
index 1893df9a8f06..ccf6dff6ff6b 100644
--- a/block/blk-crypto-internal.h
+++ b/block/blk-crypto-internal.h
@@ -81,10 +81,13 @@ int __blk_crypto_evict_key(struct blk_crypto_profile *profile,
 			   const struct blk_crypto_key *key);
 
 bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
 				const struct blk_crypto_config *cfg);
 
+int blk_crypto_ioctl(struct block_device *bdev, unsigned int cmd,
+		     void __user *argp);
+
 #else /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 static inline int blk_crypto_sysfs_register(struct gendisk *disk)
 {
 	return 0;
@@ -128,10 +131,16 @@ static inline bool blk_crypto_rq_is_encrypted(struct request *rq)
 static inline bool blk_crypto_rq_has_keyslot(struct request *rq)
 {
 	return false;
 }
 
+static inline int blk_crypto_ioctl(struct block_device *bdev, unsigned int cmd,
+				   void __user *argp)
+{
+	return -ENOTTY;
+}
+
 #endif /* CONFIG_BLK_INLINE_ENCRYPTION */
 
 void __bio_crypt_advance(struct bio *bio, unsigned int bytes);
 static inline void bio_crypt_advance(struct bio *bio, unsigned int bytes)
 {
diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index 1b92276ed2fc..f6419502fcbe 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -500,10 +500,67 @@ int blk_crypto_derive_sw_secret(struct block_device *bdev,
 					       sw_secret);
 	blk_crypto_hw_exit(profile);
 	return err;
 }
 
+int blk_crypto_import_key(struct blk_crypto_profile *profile,
+			  const u8 *raw_key, size_t raw_key_size,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int ret;
+
+	if (!profile)
+		return -EOPNOTSUPP;
+	if (!(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED))
+		return -EOPNOTSUPP;
+	if (!profile->ll_ops.import_key)
+		return -EOPNOTSUPP;
+	blk_crypto_hw_enter(profile);
+	ret = profile->ll_ops.import_key(profile, raw_key, raw_key_size,
+					 lt_key);
+	blk_crypto_hw_exit(profile);
+	return ret;
+}
+
+int blk_crypto_generate_key(struct blk_crypto_profile *profile,
+			    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int ret;
+
+	if (!profile)
+		return -EOPNOTSUPP;
+	if (!(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED))
+		return -EOPNOTSUPP;
+	if (!profile->ll_ops.generate_key)
+		return -EOPNOTSUPP;
+
+	blk_crypto_hw_enter(profile);
+	ret = profile->ll_ops.generate_key(profile, lt_key);
+	blk_crypto_hw_exit(profile);
+	return ret;
+}
+
+int blk_crypto_prepare_key(struct blk_crypto_profile *profile,
+			   const u8 *lt_key, size_t lt_key_size,
+			   u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE])
+{
+	int ret;
+
+	if (!profile)
+		return -EOPNOTSUPP;
+	if (!(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED))
+		return -EOPNOTSUPP;
+	if (!profile->ll_ops.prepare_key)
+		return -EOPNOTSUPP;
+
+	blk_crypto_hw_enter(profile);
+	ret = profile->ll_ops.prepare_key(profile, lt_key, lt_key_size,
+					  eph_key);
+	blk_crypto_hw_exit(profile);
+	return ret;
+}
+
 /**
  * blk_crypto_intersect_capabilities() - restrict supported crypto capabilities
  *					 by child device
  * @parent: the crypto profile for the parent device
  * @child: the crypto profile for the child device, or NULL
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index b55b3d8bffa0..2f6e0294eddc 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -465,5 +465,148 @@ void blk_crypto_evict_key(struct block_device *bdev,
 	 */
 	if (err)
 		pr_warn_ratelimited("%pg: error %d evicting key\n", bdev, err);
 }
 EXPORT_SYMBOL_GPL(blk_crypto_evict_key);
+
+static int blk_crypto_ioctl_import_key(struct blk_crypto_profile *profile,
+				       void __user *argp)
+{
+	struct blk_crypto_import_key_arg arg;
+	u8 raw_key[BLK_CRYPTO_MAX_RAW_KEY_SIZE];
+	u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE];
+	int ret;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
+		return -EINVAL;
+
+	if (arg.raw_key_size < 16 || arg.raw_key_size > sizeof(raw_key))
+		return -EINVAL;
+
+	if (copy_from_user(raw_key, u64_to_user_ptr(arg.raw_key_ptr),
+			   arg.raw_key_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = blk_crypto_import_key(profile, raw_key, arg.raw_key_size, lt_key);
+	if (ret < 0)
+		goto out;
+	if (ret > arg.lt_key_size) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	arg.lt_key_size = ret;
+	if (copy_to_user(u64_to_user_ptr(arg.lt_key_ptr), lt_key,
+			 arg.lt_key_size) ||
+	    copy_to_user(argp, &arg, sizeof(arg))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	memzero_explicit(raw_key, sizeof(raw_key));
+	memzero_explicit(lt_key, sizeof(lt_key));
+	return ret;
+}
+
+static int blk_crypto_ioctl_generate_key(struct blk_crypto_profile *profile,
+					 void __user *argp)
+{
+	struct blk_crypto_generate_key_arg arg;
+	u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE];
+	int ret;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
+		return -EINVAL;
+
+	ret = blk_crypto_generate_key(profile, lt_key);
+	if (ret < 0)
+		goto out;
+	if (ret > arg.lt_key_size) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	arg.lt_key_size = ret;
+	if (copy_to_user(u64_to_user_ptr(arg.lt_key_ptr), lt_key,
+			 arg.lt_key_size) ||
+	    copy_to_user(argp, &arg, sizeof(arg))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	memzero_explicit(lt_key, sizeof(lt_key));
+	return ret;
+}
+
+static int blk_crypto_ioctl_prepare_key(struct blk_crypto_profile *profile,
+					void __user *argp)
+{
+	struct blk_crypto_prepare_key_arg arg;
+	u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE];
+	u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE];
+	int ret;
+
+	if (copy_from_user(&arg, argp, sizeof(arg)))
+		return -EFAULT;
+
+	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
+		return -EINVAL;
+
+	if (arg.lt_key_size > sizeof(lt_key))
+		return -EINVAL;
+
+	if (copy_from_user(lt_key, u64_to_user_ptr(arg.lt_key_ptr),
+			   arg.lt_key_size)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = blk_crypto_prepare_key(profile, lt_key, arg.lt_key_size, eph_key);
+	if (ret < 0)
+		goto out;
+	if (ret > arg.eph_key_size) {
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	arg.eph_key_size = ret;
+	if (copy_to_user(u64_to_user_ptr(arg.eph_key_ptr), eph_key,
+			 arg.eph_key_size) ||
+	    copy_to_user(argp, &arg, sizeof(arg))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	ret = 0;
+
+out:
+	memzero_explicit(lt_key, sizeof(lt_key));
+	memzero_explicit(eph_key, sizeof(eph_key));
+	return ret;
+}
+
+int blk_crypto_ioctl(struct block_device *bdev, unsigned int cmd,
+		     void __user *argp)
+{
+	struct blk_crypto_profile *profile =
+		bdev_get_queue(bdev)->crypto_profile;
+
+	if (!profile)
+		return -EOPNOTSUPP;
+
+	switch (cmd) {
+	case BLKCRYPTOIMPORTKEY:
+		return blk_crypto_ioctl_import_key(profile, argp);
+	case BLKCRYPTOGENERATEKEY:
+		return blk_crypto_ioctl_generate_key(profile, argp);
+	case BLKCRYPTOPREPAREKEY:
+		return blk_crypto_ioctl_prepare_key(profile, argp);
+	default:
+		return -ENOTTY;
+	}
+}
diff --git a/block/ioctl.c b/block/ioctl.c
index 6554b728bae6..faa40f383e27 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -13,10 +13,11 @@
 #include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/io_uring/cmd.h>
 #include <uapi/linux/blkdev.h>
 #include "blk.h"
+#include "blk-crypto-internal.h"
 
 static int blkpg_do_ioctl(struct block_device *bdev,
 			  struct blkpg_partition __user *upart, int op)
 {
 	struct gendisk *disk = bdev->bd_disk;
@@ -618,10 +619,14 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 				mode | BLK_OPEN_STRICT_SCAN);
 	case BLKTRACESTART:
 	case BLKTRACESTOP:
 	case BLKTRACETEARDOWN:
 		return blk_trace_ioctl(bdev, cmd, argp);
+	case BLKCRYPTOIMPORTKEY:
+	case BLKCRYPTOGENERATEKEY:
+	case BLKCRYPTOPREPAREKEY:
+		return blk_crypto_ioctl(bdev, cmd, argp);
 	case IOC_PR_REGISTER:
 		return blkdev_pr_register(bdev, mode, argp);
 	case IOC_PR_RESERVE:
 		return blkdev_pr_reserve(bdev, mode, argp);
 	case IOC_PR_RELEASE:
diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
index 7764b4f7b45b..a719a0aea122 100644
--- a/include/linux/blk-crypto-profile.h
+++ b/include/linux/blk-crypto-profile.h
@@ -69,10 +69,52 @@ struct blk_crypto_ll_ops {
 	 * -errno code on other errors.
 	 */
 	int (*derive_sw_secret)(struct blk_crypto_profile *profile,
 				const u8 *eph_key, size_t eph_key_size,
 				u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE]);
+
+	/**
+	 * @import_key: Create a hardware-wrapped key by importing a raw key.
+	 *
+	 * This only needs to be implemented if BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
+	 * is supported.
+	 *
+	 * On success, must write the new key in long-term wrapped form to
+	 * @lt_key and return its size in bytes.  On failure, must return a
+	 * -errno value.
+	 */
+	int (*import_key)(struct blk_crypto_profile *profile,
+			  const u8 *raw_key, size_t raw_key_size,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+
+	/**
+	 * @generate_key: Generate a hardware-wrapped key.
+	 *
+	 * This only needs to be implemented if BLK_CRYPTO_KEY_TYPE_HW_WRAPPED
+	 * is supported.
+	 *
+	 * On success, must write the new key in long-term wrapped form to
+	 * @lt_key and return its size in bytes.  On failure, must return a
+	 * -errno value.
+	 */
+	int (*generate_key)(struct blk_crypto_profile *profile,
+			    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+
+	/**
+	 * @prepare_key: Prepare a hardware-wrapped key to be used.
+	 *
+	 * Prepare a hardware-wrapped key to be used by converting it from
+	 * long-term wrapped form to ephemerally-wrapped form.  This only needs
+	 * to be implemented if BLK_CRYPTO_KEY_TYPE_HW_WRAPPED is supported.
+	 *
+	 * On success, must write the key in ephemerally-wrapped form to
+	 * @eph_key and return its size in bytes.  On failure, must return a
+	 * -errno value.
+	 */
+	int (*prepare_key)(struct blk_crypto_profile *profile,
+			   const u8 *lt_key, size_t lt_key_size,
+			   u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
 };
 
 /**
  * struct blk_crypto_profile - inline encryption profile for a device
  *
@@ -161,10 +203,21 @@ unsigned int blk_crypto_keyslot_index(struct blk_crypto_keyslot *slot);
 
 void blk_crypto_reprogram_all_keys(struct blk_crypto_profile *profile);
 
 void blk_crypto_profile_destroy(struct blk_crypto_profile *profile);
 
+int blk_crypto_import_key(struct blk_crypto_profile *profile,
+			  const u8 *raw_key, size_t raw_key_size,
+			  u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+
+int blk_crypto_generate_key(struct blk_crypto_profile *profile,
+			    u8 lt_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+
+int blk_crypto_prepare_key(struct blk_crypto_profile *profile,
+			   const u8 *lt_key, size_t lt_key_size,
+			   u8 eph_key[BLK_CRYPTO_MAX_HW_WRAPPED_KEY_SIZE]);
+
 void blk_crypto_intersect_capabilities(struct blk_crypto_profile *parent,
 				       const struct blk_crypto_profile *child);
 
 bool blk_crypto_has_capabilities(const struct blk_crypto_profile *target,
 				 const struct blk_crypto_profile *reference);
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 0e63287e2175..c1ef8c3cea64 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -6,10 +6,11 @@
 #ifndef __LINUX_BLK_CRYPTO_H
 #define __LINUX_BLK_CRYPTO_H
 
 #include <linux/minmax.h>
 #include <linux/types.h>
+#include <uapi/linux/blk-crypto.h>
 
 enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_INVALID,
 	BLK_ENCRYPTION_MODE_AES_256_XTS,
 	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
diff --git a/include/uapi/linux/blk-crypto.h b/include/uapi/linux/blk-crypto.h
new file mode 100644
index 000000000000..97302c6eb6af
--- /dev/null
+++ b/include/uapi/linux/blk-crypto.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_BLK_CRYPTO_H
+#define _UAPI_LINUX_BLK_CRYPTO_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+struct blk_crypto_import_key_arg {
+	/* Raw key (input) */
+	__u64 raw_key_ptr;
+	__u64 raw_key_size;
+	/* Long-term wrapped key blob (output) */
+	__u64 lt_key_ptr;
+	__u64 lt_key_size;
+	__u64 reserved[4];
+};
+
+struct blk_crypto_generate_key_arg {
+	/* Long-term wrapped key blob (output) */
+	__u64 lt_key_ptr;
+	__u64 lt_key_size;
+	__u64 reserved[4];
+};
+
+struct blk_crypto_prepare_key_arg {
+	/* Long-term wrapped key blob (input) */
+	__u64 lt_key_ptr;
+	__u64 lt_key_size;
+	/* Ephemerally-wrapped key blob (output) */
+	__u64 eph_key_ptr;
+	__u64 eph_key_size;
+	__u64 reserved[4];
+};
+
+/*
+ * These ioctls share the block device ioctl space; see uapi/linux/fs.h.
+ * 140-141 are reserved for future blk-crypto ioctls; any more than that would
+ * require an additional allocation from the block device ioctl space.
+ */
+#define BLKCRYPTOIMPORTKEY _IOWR(0x12, 137, struct blk_crypto_import_key_arg)
+#define BLKCRYPTOGENERATEKEY _IOWR(0x12, 138, struct blk_crypto_generate_key_arg)
+#define BLKCRYPTOPREPAREKEY _IOWR(0x12, 139, struct blk_crypto_prepare_key_arg)
+
+#endif /* _UAPI_LINUX_BLK_CRYPTO_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9070ef19f0a3..ba5bc5369b3c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -210,14 +210,12 @@ struct fsxattr {
 #define BLKDISCARDZEROES _IO(0x12,124)
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
 #define BLKGETDISKSEQ _IOR(0x12,128,__u64)
-/*
- * A jump here: 130-136 are reserved for zoned block devices
- * (see uapi/linux/blkzoned.h)
- */
+/* 130-136 are used by zoned block device ioctls (uapi/linux/blkzoned.h) */
+/* 137-141 are used by blk-crypto ioctls (uapi/linux/blk-crypto.h) */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
 #define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
-- 
2.47.1


