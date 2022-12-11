Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435A16492FF
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbiLKHHz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLKHHx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71433328;
        Sat, 10 Dec 2022 23:07:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7EC860CF2;
        Sun, 11 Dec 2022 07:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2EC433F1;
        Sun, 11 Dec 2022 07:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742465;
        bh=psO0ZX6nJ2FtuYgmtkGSazEI/UfM/vdZQtAlmPfn/fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inJU8Cb+PgiWi/tm9t6otqAd3//7B+h56IfSSBx4FswQdf4mGTVDWWzVhQl1UC/13
         DvDHei/manfGaCURh+AemGutOLweE6XCgPEpI/llpAiSjXb3p09KmoCB2QLeHgBPG6
         y+pur9nMRFaKScGqKlc9ZJUafTCBDtc9TYzmNA1x36IB2qsR9IMefNtrF4BXjWTJLi
         KzPFH8Yk6q6ZmRopNCJTZx1vqWA1guDCro3CpsbZ2J3CFov2o93/vnDQ9MKODBtNnG
         62YWxIMOY/xriaEt9gdsxGZHzX4JYSY6RsqxC4N7JZmISjiVOi4KJbNvkcoRuHIsNR
         w7r1ZgszjtS0g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 02/10] common/verity: set FSV_BLOCK_SIZE to an appropriate value
Date:   Sat, 10 Dec 2022 23:06:55 -0800
Message-Id: <20221211070704.341481-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211070704.341481-1-ebiggers@kernel.org>
References: <20221211070704.341481-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In order to maximize the chance that the verity tests can actually be
run, FSV_BLOCK_SIZE (the default Merkle tree size for the verity tests)
needs to be min(fs_block_size, page_size), not simply page_size.  The
only reason that page_size was okay before was because the kernel only
supported merkle_tree_block_size == fs_block_size == page_size anyway.
But that is changing.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/common/verity b/common/verity
index 1a53a7ea..a94ebf8e 100644
--- a/common/verity
+++ b/common/verity
@@ -13,6 +13,11 @@ if [ "$FSTYP" == "btrfs" ]; then
         fi
 fi
 
+# Require fs-verity support on the scratch filesystem.
+#
+# FSV_BLOCK_SIZE will be set to a Merkle tree block size that is supported by
+# the filesystem.  Other sizes may be supported too, but FSV_BLOCK_SIZE is the
+# only size that is guaranteed to work without any additional checks.
 _require_scratch_verity()
 {
 	_require_scratch
@@ -27,7 +32,7 @@ _require_scratch_verity()
 
 	# Try to mount the filesystem.  If this fails then either the kernel
 	# isn't aware of fs-verity, or the mkfs options were not compatible with
-	# verity (e.g. ext4 with block size != PAGE_SIZE).
+	# verity (e.g. ext4 with block size != PAGE_SIZE on old kernels).
 	if ! _try_scratch_mount &>>$seqres.full; then
 		_notrun "kernel is unaware of $FSTYP verity feature," \
 			"or mkfs options are not compatible with verity"
@@ -39,6 +44,27 @@ _require_scratch_verity()
 		_notrun "kernel $FSTYP isn't configured with verity support"
 	fi
 
+	# Select a default Merkle tree block size for when tests don't
+	# explicitly specify one.
+	#
+	# For consistency reasons, all 'fsverity' subcommands, including
+	# 'fsverity enable', default to 4K Merkle tree blocks.  That's generally
+	# not ideal for tests, since it's possible that the filesystem doesn't
+	# support 4K blocks but does support another size.  Specifically, the
+	# kernel originally supported only merkle_tree_block_size ==
+	# fs_block_size == page_size, and later it was updated to support
+	# merkle_tree_block_size <= min(fs_block_size, page_size).
+	#
+	# Therefore, we default to merkle_tree_block_size == min(fs_block_size,
+	# page_size).  That maximizes the chance of verity actually working.
+	local fs_block_size=$(_get_block_size $SCRATCH_MNT)
+	local page_size=$(get_page_size)
+	if (( fs_block_size <= page_size )); then
+		FSV_BLOCK_SIZE=$fs_block_size
+	else
+		FSV_BLOCK_SIZE=$page_size
+	fi
+
 	# The filesystem may have fs-verity enabled but not actually usable by
 	# default.  E.g., ext4 only supports verity on extent-based files, so it
 	# doesn't work on ext3-style filesystems.  So, try actually using it.
@@ -47,10 +73,6 @@ _require_scratch_verity()
 	fi
 
 	_scratch_unmount
-
-	# Merkle tree block size.  Currently all filesystems only support
-	# PAGE_SIZE for this.  This is also the default for 'fsverity enable'.
-	FSV_BLOCK_SIZE=$(get_page_size)
 }
 
 # Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, as well as the userspace
-- 
2.38.1

