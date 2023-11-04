Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C417E1132
	for <lists+linux-fscrypt@lfdr.de>; Sat,  4 Nov 2023 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbjKDVRN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 4 Nov 2023 17:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjKDVRM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 4 Nov 2023 17:17:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A07EB;
        Sat,  4 Nov 2023 14:17:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FDCC433CC;
        Sat,  4 Nov 2023 21:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699132628;
        bh=ONfz1fWZ5DwqTuDyL+3p6UIvpLuzuXzxeO2FeKcYWdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2Lp597zp7FSELy67yJMaMNmBRakqEFphhXjxghGDJwhRz2+XQqkWfccfgXxr8Flm
         un7c/qIis3vo+mI0tc7tCk0wf6OxIHT4WlwCqa3j/lFyBDxgZAy8jk6CNBQsXg0sbx
         XFyZjFF4K70SGWpzU32ShD7pv/MNclGoonCBCignTW38RWFAvptH/jGUm8SsbOJDcc
         Ru6KJR9Ul3IKZXLN88Lla1J+7Pf8qHWnj1Glmu2Pd0awfcBP2I72/A40+jpig+9OR/
         su3I6uPfWPKTmT5Ezs0pfbdazIc/Xg+Ojtu1iqh3tRzqKeTwekTVW6hfxrCsTB0oWS
         SjYV/jJyz3Yyw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [RFC PATCH v8 2/4] blk-crypto: show supported key types in sysfs
Date:   Sat,  4 Nov 2023 14:12:57 -0700
Message-ID: <20231104211259.17448-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231104211259.17448-1-ebiggers@kernel.org>
References: <20231104211259.17448-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add sysfs files that indicate which type(s) of keys are supported by the
inline encryption hardware associated with a particular request queue:

	/sys/block/$disk/queue/crypto/hw_wrapped_keys
	/sys/block/$disk/queue/crypto/standard_keys

Userspace can use the presence or absence of these files to decide what
encyption settings to use.

Don't use a single key_type file, as devices might support both key
types at the same time.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ABI/stable/sysfs-block | 18 ++++++++++++++
 block/blk-crypto-sysfs.c             | 35 ++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
index 1fe9a553c37b..e396c905800c 100644
--- a/Documentation/ABI/stable/sysfs-block
+++ b/Documentation/ABI/stable/sysfs-block
@@ -159,20 +159,30 @@ What:		/sys/block/<disk>/queue/crypto/
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
 Description:
 		The presence of this subdirectory of /sys/block/<disk>/queue/
 		indicates that the device supports inline encryption.  This
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
 		numbers accepted by the device in inline encryption requests.
 
 
 What:		/sys/block/<disk>/queue/crypto/modes/<mode>
 Date:		February 2022
@@ -197,20 +207,28 @@ Description:
 
 
 What:		/sys/block/<disk>/queue/crypto/num_keyslots
 Date:		February 2022
 Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file shows the number of keyslots the device has for
 		use with inline encryption.
 
 
+What:		/sys/block/<disk>/queue/crypto/standard_keys
+Contact:	linux-block@vger.kernel.org
+Description:
+		[RO] The presence of this file indicates that the device
+		supports standard inline encryption keys, i.e. keys that are
+		managed in raw, plaintext form in software.
+
+
 What:		/sys/block/<disk>/queue/dax
 Date:		June 2016
 Contact:	linux-block@vger.kernel.org
 Description:
 		[RO] This file indicates whether the device supports Direct
 		Access (DAX), used by CPU-addressable storage to bypass the
 		pagecache.  It shows '1' if true, '0' if not.
 
 
 What:		/sys/block/<disk>/queue/discard_granularity
diff --git a/block/blk-crypto-sysfs.c b/block/blk-crypto-sysfs.c
index a304434489ba..acab50493f2c 100644
--- a/block/blk-crypto-sysfs.c
+++ b/block/blk-crypto-sysfs.c
@@ -24,46 +24,81 @@ struct blk_crypto_attr {
 static struct blk_crypto_profile *kobj_to_crypto_profile(struct kobject *kobj)
 {
 	return container_of(kobj, struct blk_crypto_kobj, kobj)->profile;
 }
 
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
 
 static ssize_t num_keyslots_show(struct blk_crypto_profile *profile,
 				 struct blk_crypto_attr *attr, char *page)
 {
 	return sysfs_emit(page, "%u\n", profile->num_slots);
 }
 
+static ssize_t standard_keys_show(struct blk_crypto_profile *profile,
+				  struct blk_crypto_attr *attr, char *page)
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
+BLK_CRYPTO_RO_ATTR(standard_keys);
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
+	if (a == &standard_keys_attr &&
+	    !(profile->key_types_supported & BLK_CRYPTO_KEY_TYPE_STANDARD))
+		return 0;
+
+	return 0444;
+}
 
 static struct attribute *blk_crypto_attrs[] = {
+	&hw_wrapped_keys_attr.attr,
 	&max_dun_bits_attr.attr,
 	&num_keyslots_attr.attr,
+	&standard_keys_attr.attr,
 	NULL,
 };
 
 static const struct attribute_group blk_crypto_attr_group = {
 	.attrs = blk_crypto_attrs,
+	.is_visible = blk_crypto_is_visible,
 };
 
 /*
  * The encryption mode attributes.  To avoid hard-coding the list of encryption
  * modes, these are initialized at boot time by blk_crypto_sysfs_init().
  */
 static struct blk_crypto_attr __blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX];
 static struct attribute *blk_crypto_mode_attrs[BLK_ENCRYPTION_MODE_MAX + 1];
 
 static umode_t blk_crypto_mode_is_visible(struct kobject *kobj,
-- 
2.42.0

