Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC2A741D3B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjF2AgQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjF2AgJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:09 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C8E1FC2;
        Wed, 28 Jun 2023 17:36:07 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 6054D8030E;
        Wed, 28 Jun 2023 20:36:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998967; bh=/c5GI1fbHHc0vOvX8HtVjo+f3WiIoAbs3+8uMWkXtqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9thH9oUeBJlAzwKJT9C3BSA4nUPW6RBDCyuokle7VeYm8S7DmjM45yGgaUU6loPM
         RvANNZ4kQ6HWN0sxRYpw79xHnqA/TojM08+54S4orN0VAnPYIBDNWf2aarPs6khZK/
         h3fPHSTiEgYsGi9C7XTQ1YxqoQX5pzSbctmMsOovfshGysdVSuUBj1r/hDGaa1L4ET
         OiKpcFmOmBO64/flbRzep+MTTSiDixeL7QgXltWdKjcgqLZNyMDsisL5bc3LT1FTMk
         c/XLpOdYK3982gC/wiChSnVTVv2ddH/M1HJGXatntQnQc7lQKvmXDM+1CGPFoFExRd
         U2hNBcL6eC3ZQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 13/17] btrfs: turn on the encryption ioctls
Date:   Wed, 28 Jun 2023 20:35:36 -0400
Message-Id: <fccd5fe6096e9c65e35f707cb05eea59a6635487.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This allows the use of encryption with btrfs. Since the extent
encryption interfaces are not currently defined, this is using the
normal inode encryption, and that is not the long-term plan. But it
allows verifying by test that the steps for inode encryption are correct
and pass fstests.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/extent_io.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 10a06719811c..3abf2b64e92e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -787,6 +787,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
 	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
 
+	if (IS_ENABLED(CONFIG_FS_ENCRYPTION)) {
+		struct inode *inode = page->mapping->host;
+		u64 lblk = pg_offset / inode->i_sb->s_blocksize;
+
+		if (!fscrypt_mergeable_bio(bio, inode, lblk))
+			return false;
+	}
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -825,6 +833,9 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 	bbio->file_offset = file_offset;
 	bio_ctrl->bbio = bbio;
 	bio_ctrl->len_to_oe_boundary = U32_MAX;
+	fscrypt_set_bio_crypt_ctx(&bbio->bio, &inode->vfs_inode,
+				  file_offset >> fs_info->sectorsize_bits,
+				  GFP_NOIO);
 
 	/* Limit data write bios to the ordered boundary. */
 	if (bio_ctrl->wbc) {
-- 
2.40.1

