Return-Path: <linux-fscrypt+bounces-563-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 719BC9F03AF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:21:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0DF2188B4B3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 04:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A050A18FDDF;
	Fri, 13 Dec 2024 04:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSf1lEOK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7018FDB1;
	Fri, 13 Dec 2024 04:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734063629; cv=none; b=e7zZQuth9VG7JEju9UcDyEDP5nAN74Sz2kbUA0DLgQ4zigNujCA6GoJLPihL9VjkWYpseVozNP1qiQGPSzAJ4eJINWTKEpX+roDIdyaRxaojL9JmTEgdQWklWbor+xFuYCTtiqm1uvpqfByggAwNYiKBywyZL7ERWBO527+WKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734063629; c=relaxed/simple;
	bh=8TuGsaITkc/j3AviI7xs52V61eElIiTTYnQaE2vaZvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odxf5CNaBFqMph3HIEiawiudGPyEQgnyeJIy0qYmz/Mdwd5sv1pTR5nJofUhXvnBDNJEpS68I6TBEKCEXzao9huMIw7nTj3F6TexKxwO8tfEJpiXoZOGiAhSUZbMd1RiH9bX9eLcicoe7Ny7tvGxiqkioa41FjH28APBTLKH7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSf1lEOK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CC1C4CED6;
	Fri, 13 Dec 2024 04:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734063629;
	bh=8TuGsaITkc/j3AviI7xs52V61eElIiTTYnQaE2vaZvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSf1lEOKs0PWV5MasBAQCDFTvGNW1nEK35XWvTqsUrudUJcx1/MPeIUUH4hIFSSAv
	 zq/rwxf5I6Iy4Y7Rq55m99kmw+Z0BPs+mwGHw3FMobxDEIEaCSevdXE94qWanYI+X3
	 h33dLjk79HpnbkF959HL9uB8szvPpzx4SAEL5jqKtN3c2teJ3Sxhh0NYdheRU3B6be
	 PoCNE9N7BJqdPXMEEjgox5XVbP6K/RGHX/M5ry9JVYvKnUgtIs5Cq7/O+kt2aEL55x
	 WTpgl0qDT91RLzY+vubd4jXw8JeuT/EakzqiCtNDJv5F1549exFQLBNGcUBqGz4bZ2
	 jHxZwKm/Pm0Dw==
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
Subject: [PATCH v10 11/15] blk-crypto: show supported key types in sysfs
Date: Thu, 12 Dec 2024 20:19:54 -0800
Message-ID: <20241213041958.202565-12-ebiggers@kernel.org>
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

Add sysfs files that indicate which type(s) of keys are supported by the
inline encryption hardware associated with a particular request queue:

	/sys/block/$disk/queue/crypto/hw_wrapped_keys
	/sys/block/$disk/queue/crypto/raw_keys

Userspace can use the presence or absence of these files to decide what
encyption settings to use.

Don't use a single key_type file, as devices might support both key
types at the same time.

Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ABI/stable/sysfs-block | 18 ++++++++++++++
 block/blk-crypto-sysfs.c             | 35 ++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 0cceb2badc83..75f0997926e9 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -227,10 +227,20 @@ Description:
 		subdirectory contains files which describe the inline encryption
 		capabilities of the device.  For more information about inline
 		encryption, refer to Documentation/block/inline-encryption.rst.
 
 
+What:		/sys/block/<disk>/queue/crypto/hw_wrapped_keys
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
@@ -265,10 +275,18 @@ Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file shows the number of keyslots the device has for
 		use with inline encryption.
 
 
+What:		/sys/block/<disk>/queue/crypto/raw_keys
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
index a304434489ba..e832f403f200 100644
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
2.47.1


