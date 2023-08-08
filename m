Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560687743C9
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235295AbjHHSKd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbjHHSJ6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:09:58 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40A51B073;
        Tue,  8 Aug 2023 10:12:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 430F783441;
        Tue,  8 Aug 2023 13:12:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514764; bh=qpXAcm4K7bOAkjEWFWEcnGwbfn1r/rAuBu2to8Bk8DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jmhGNiDLrSlDWTuDGJaz7ylBl/8CLgG+ppSIjuIpkAv61va8nlmkd8166rAUJTKIy
         Rk7Oms8SxIE3BBIZGohoMxedWVY+omAA8tTr/nZnPOmuzBVTUPl/pyZyG0babBi+wk
         J+QM3ydu7IIcWbfjP2irQ32fjolI/3fuCdyA+5Uzp+K+pdIz9Uqj5mUBAxfJvEOz7V
         o90Oif7SYGd90nVihhasIr5Xp4L3oCWx7APfaRqOQko/5hRw0dQ3dEn2OgBa0/+fNp
         Sw5pBMlpJdC4g+V6DKeZD4c1524+tBRDXOVj8hWaR1L/da/kokx8ZUT/YoSJqTEWhj
         bYiys6l+XqXdQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 13/17] btrfs: turn on the encryption ioctls
Date:   Tue,  8 Aug 2023 13:12:15 -0400
Message-ID: <dd1d86a0d37a64d47263136ee57aae4e7afe8a4c.1691510179.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691510179.git.sweettea-kernel@dorminy.me>
References: <cover.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
index 4de42b7ce796..2e13bb615fa6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -715,6 +715,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
 	const sector_t sector = disk_bytenr >> SECTOR_SHIFT;
 
+	if (IS_ENABLED(CONFIG_FS_ENCRYPTION)) {
+		struct inode *inode = page->mapping->host;
+		u64 lblk = (page_offset(page) + pg_offset) / inode->i_sb->s_blocksize;
+
+		if (!fscrypt_mergeable_bio(bio, inode, lblk))
+			return false;
+	}
+
 	if (bio_ctrl->compress_type != BTRFS_COMPRESS_NONE) {
 		/*
 		 * For compression, all IO should have its logical bytenr set
@@ -753,6 +761,9 @@ static void alloc_new_bio(struct btrfs_inode *inode,
 	bbio->file_offset = file_offset;
 	bio_ctrl->bbio = bbio;
 	bio_ctrl->len_to_oe_boundary = U32_MAX;
+	fscrypt_set_bio_crypt_ctx(&bbio->bio, &inode->vfs_inode,
+				  file_offset >> fs_info->sectorsize_bits,
+				  GFP_NOIO);
 
 	/* Limit data write bios to the ordered boundary. */
 	if (bio_ctrl->wbc) {
-- 
2.41.0

