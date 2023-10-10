Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EF97C418A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbjJJUlZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbjJJUlW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:22 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6CCDA
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:19 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-59f6441215dso75757347b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970479; x=1697575279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SlmN2ch9baX8IZyM28LiaPpdp2pXGpixSS5OJltBALc=;
        b=k9nLHT4L6iPjqh8Y1F0CQkvJ/Hsyq1hyFka1onCldQI9p0C4SjJyVAxdnkzWmHFsp6
         3a5CTFRsiaOwPEbgExXxZYX+cHDMPXnzxNRBeiPOC+L5IjbeYAgR5PLlTusssZiOlGdp
         kGJMP7BermmqSasw/6Epk3RuwYC9g0j3scpAT49bgLzrvsN4ln6MvrKy5Yz1e2vfnaKz
         RL2OAScX0gW65eGJ1QOQhGm8hUSpnTUuzIii0y68DccD0WONFZ8hwXWo8Wgx3tMIILzq
         HiTslKw9xUps4nZVsC3G5E4r6xuqL5cOWVDiQzv1JNAP1rVRBabw3q4YYWQn9T1wFPil
         sxig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970479; x=1697575279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SlmN2ch9baX8IZyM28LiaPpdp2pXGpixSS5OJltBALc=;
        b=IKdNJUMmzyjCQ6Ektce9h9QTJeAMTotMNrIXKtERVQ77NrGYHS8k9smQDigNWEzpkX
         9U4jcN1GPH5Dve5hovWDYRDZAIhj+YLydkIPMFq3GeW3AZWpGW4SIR6WDja3yP93GQZ/
         2LSqC+MIJSC1vEfNU644j3elIHOh5z2Qew+Gis+t6k9I0ohQV3/PjxRVc6JodSocc45N
         fCekmRcXYZEnNQN8zcowaufk3tM5sSd0F4yN/RZrEBCjZHZes4tFOabDNTD3fVrQQzOZ
         H1+ueMBRMTiXim3aTTLw+02APJpuAIGLWxpDTqRVAfD4juV6PEFu8t2n0oluHxS53YoG
         HyjA==
X-Gm-Message-State: AOJu0YxQmT7F4Rk30WRLlpOefm6wwxVoQRx+FV4YEROR5/4UwmifT3TF
        zOAiwO/2bg2Clw60kMXiyeXOZ73MgHzSBFIsukh0DQ==
X-Google-Smtp-Source: AGHT+IHAa6+/r7bIvaeYU3BVjfbRQwVyiROgPjJ+6sqmGPSFggul8YnsYIEAc0rrxKA8oF3Ppi4C0g==
X-Received: by 2002:a81:7103:0:b0:59b:586c:c65e with SMTP id m3-20020a817103000000b0059b586cc65emr23052765ywc.36.1696970478797;
        Tue, 10 Oct 2023 13:41:18 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id p6-20020a0dff06000000b0059c8387f673sm4698455ywf.51.2023.10.10.13.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:18 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 13/36] btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
Date:   Tue, 10 Oct 2023 16:40:28 -0400
Message-ID: <fd90ba2a74d0a4963a432ae5bc44260decca1af5.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

As encrypted files will be incompatible with older filesystem versions,
new filesystems should be created with an incompat flag for fscrypt,
which will gate access to the encryption ioctls.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/fs.h              | 3 ++-
 fs/btrfs/super.c           | 5 +++++
 fs/btrfs/sysfs.c           | 6 ++++++
 include/uapi/linux/btrfs.h | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 318df6f9d9cb..4a3b1bb61849 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -231,7 +231,8 @@ enum {
 #define BTRFS_FEATURE_INCOMPAT_SUPP		\
 	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |	\
 	 BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE | \
-	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2)
+	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
+	 BTRFS_FEATURE_INCOMPAT_ENCRYPT)
 
 #else
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0d88f871ba09..bacf5c4f2a5c 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2383,6 +2383,11 @@ static int __init btrfs_print_mod_info(void)
 			", fsverity=yes"
 #else
 			", fsverity=no"
+#endif
+#ifdef CONFIG_FS_ENCRYPTION
+			", fscrypt=yes"
+#else
+			", fscrypt=no"
 #endif
 			;
 	pr_info("Btrfs loaded%s\n", options);
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index e6b51fb3ddc1..4ece703d9d5f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -304,6 +304,9 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_STRIPE_TREE);
 #ifdef CONFIG_FS_VERITY
 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+BTRFS_FEAT_ATTR_INCOMPAT(encryption, ENCRYPT);
+#endif /* CONFIG_FS_ENCRYPTION */
 
 /*
  * Features which depend on feature bits and may differ between each fs.
@@ -336,6 +339,9 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 #ifdef CONFIG_FS_VERITY
 	BTRFS_FEAT_ATTR_PTR(verity),
 #endif
+#ifdef CONFIG_FS_ENCRYPTION
+	BTRFS_FEAT_ATTR_PTR(encryption),
+#endif /* CONFIG_FS_ENCRYPTION */
 	NULL
 };
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 7c29d82db9ee..6a0f4c0e4096 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -334,6 +334,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_ZONED		(1ULL << 12)
 #define BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2	(1ULL << 13)
 #define BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE	(1ULL << 14)
+#define BTRFS_FEATURE_INCOMPAT_ENCRYPT		(1ULL << 15)
 #define BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA	(1ULL << 16)
 
 struct btrfs_ioctl_feature_flags {
-- 
2.41.0

