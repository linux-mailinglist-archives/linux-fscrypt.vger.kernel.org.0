Return-Path: <linux-fscrypt+bounces-588-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2AD4A26BBD
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 07:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EE653A2F1D
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Feb 2025 06:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA48920371C;
	Tue,  4 Feb 2025 06:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jp8fqQ8F"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F967202C4D;
	Tue,  4 Feb 2025 06:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738649002; cv=none; b=I6d2mBn18Teth+2TjAclw5h54bhcCdDnwKjvnchOZUY9UDavshSgrVr1U3zFXoUit1L55n6co8vHFBmyanBVQSAaEhcyMuAU9B4H2vC+ftTcD2ORUzp7f+y7NL/n/bleDFS72LuMF+M7v020U7SJZR11GpvOEU6a36HJfY7PWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738649002; c=relaxed/simple;
	bh=2Tte54TUDVLcPYS9n+Sc9AyUCpGqQ1pGHhPEHfjRkOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsGRKShdAtt7iAdQqWntX7RJFy045bF0frShKotlODoE39ALZirLEqqOzEbfYIcuLS0H34hu+WXHTyRg1YAI7RgdR67vxnRaT13ObIfPEGeBhpSPl94G7O+kbIRwFjvFOqTI6FX5hbeRGzVTupBA9pGfSeQpKfbWsgt0EVTdnKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jp8fqQ8F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0C7C4CEE8;
	Tue,  4 Feb 2025 06:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738649002;
	bh=2Tte54TUDVLcPYS9n+Sc9AyUCpGqQ1pGHhPEHfjRkOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jp8fqQ8FsHEfV6Ao6eylUk2w3fi7DikzzRRBr1p7uoTR6T3YXnK2RW6/UH4h4Rq8q
	 qz4Ph2hQ+E6mU5uyclE24g1+G2KuppgcOMcuDGtETNidTBs314jSaFf7rpxCcHhhHw
	 XWI9OfgUbTjkefgM0ItBs+ueivJEM5x2lJHcTFtxgrrrvNWxUx9RramIWZqIOLZ2Q8
	 nkh2dyJPoZRiGpIwERnHbmbMBHdcmO7bc2UP+njuXdYHeCxfXK/ixYtElTMO8jqKtH
	 2f6wKwslDRkcr3jP6QkvUER1tBL78l5e7JtXs481a9KUFIpDza+GPn1kDq4gCpglUR
	 jHKyg8Y2QdMQA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-fscrypt@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH v11 2/7] blk-crypto: show supported key types in sysfs
Date: Mon,  3 Feb 2025 22:00:36 -0800
Message-ID: <20250204060041.409950-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250204060041.409950-1-ebiggers@kernel.org>
References: <20250204060041.409950-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Add sysfs files that indicate which type(s) of keys are supported by the
inline encryption hardware associated with a particular request queue:

	/sys/block/$disk/queue/crypto/hw_wrapped_keys
	/sys/block/$disk/queue/crypto/raw_keys

Userspace can use the presence or absence of these files to decide what
encyption settings to use.

Don't use a single key_type file, as devices might support both key
types at the same time.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ABI/stable/sysfs-block | 20 ++++++++++++++++
 block/blk-crypto-sysfs.c             | 35 ++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 0cceb2badc836..890cde28bf90d 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -227,10 +227,21 @@ Description:
 		subdirectory contains files which describe the inline encryption
 		capabilities of the device.  For more information about inline
 		encryption, refer to Documentation/block/inline-encryption.rst.
 
 
+What:		/sys/block/<disk>/queue/crypto/hw_wrapped_keys
+Date:		February 2025
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] The presence of this file indicates that the device
+		supports hardware-wrapped inline encryption keys, i.e. key blobs
+		that can only be unwrapped and used by dedicated hardware.  For
+		more information about hardware-wrapped inline encryption keys,
+		see Documentation/block/inline-encryption.rst.
+
+
 What:		/sys/block/<disk>/queue/crypto/max_dun_bits
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file shows the maximum length, in bits, of data unit
@@ -265,10 +276,19 @@ Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file shows the number of keyslots the device has for
 		use with inline encryption.
 
 
+What:		/sys/block/<disk>/queue/crypto/raw_keys
+Date:		February 2025
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] The presence of this file indicates that the device
+		supports raw inline encryption keys, i.e. keys that are managed
+		in raw, plaintext form in software.
+
+
 What:		/sys/block/<disk>/queue/dax
 Date:		June 2016
 Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file indicates whether the device supports Direct
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
index a304434489bac..e832f403f2002 100644
--- a/block/blk-crypto-sysfs.c
+++ b/block/blk-crypto-sysfs.c
@@ -29,10 +29,17 @@ static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
 static struct blk_crypto_attr *attr_to_crypto_attr(struct attribute *attr)
 {
 	return container_of(attr, struct blk_crypto_attr, attr);
 }
 
+static ssize_t hw_wrapped_keys_show(struct blk_crypto_profile *profile,
+				    struct blk_crypto_attr *attr, char *page)
+{
+	/* Always show supported, since the file doesn't exist otherwise. */
+	return sysfs_emit(page, "supported\n");
+}
+
 static ssize_t max_dun_bits_show(struct blk_crypto_profile *profile,
 				 struct blk_crypto_attr *attr, char *page)
 {
 	return sysfs_emit(page, "%u\n", 8 * profile->max_dun_bytes_supported);
 }
@@ -41,24 +48,52 @@ static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
 				 struct blk_crypto_attr *attr, char *page)
 {
 	return sysfs_emit(page, "%u\n", profile->num_slots);
 }
 
+static ssize_t raw_keys_show(struct blk_crypto_profile *profile,
+			     struct blk_crypto_attr *attr, char *page)
+{
+	/* Always show supported, since the file doesn't exist otherwise. */
+	return sysfs_emit(page, "supported\n");
+}
+
 #define BLK_CRYPTO_RO_ATTR(_name) \
 	static struct blk_crypto_attr _name##_attr = __ATTR_RO(_name)
 
+BLK_CRYPTO_RO_ATTR(hw_wrapped_keys);
 BLK_CRYPTO_RO_ATTR(max_dun_bits);
 BLK_CRYPTO_RO_ATTR(num_keyslots);
+BLK_CRYPTO_RO_ATTR(raw_keys);
+
+static umode_t blk_crypto_is_visible(struct kobject *kobj,
+				     struct attribute *attr, int n)
+{
+	struct blk_crypto_profile *profile = kobj_to_crypto_profile(kobj);
+	struct blk_crypto_attr *a = attr_to_crypto_attr(attr);
+
+	if (a == &hw_wrapped_keys_attr &&
+	    !(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_HW_WRAPPED))
+		return 0;
+	if (a == &raw_keys_attr &&
+	    !(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_RAW))
+		return 0;
+
+	return 0444;
+}
 
 static struct attribute *blk_crypto_attrs[] = {
+	&hw_wrapped_keys_attr.attr,
 	&max_dun_bits_attr.attr,
 	&num_keyslots_attr.attr,
+	&raw_keys_attr.attr,
 	NULL,
 };
 
 static const struct attribute_group blk_crypto_attr_group = {
 	.attrs = blk_crypto_attrs,
+	.is_visible = blk_crypto_is_visible,
 };
 
 /*
  * The encryption mode attributes.  To avoid hard-coding the list of encryption
  * modes, these are initialized at boot time by blk_crypto_sysfs_init().
-- 
2.48.1


