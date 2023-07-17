Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED7DB755A4D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjGQDxZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbjGQDxN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:13 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB371BF;
        Sun, 16 Jul 2023 20:53:12 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D157B8341B;
        Sun, 16 Jul 2023 23:53:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565992; bh=gbiDEvfvbMNfGkXp7iWm6WCLnraTwU2+qNpGo99zU7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftZYO8uyZ4QYk0LbDByq8ABLiUyt0APdqeuiDA1dsKOWZh+ozVw9xfuw7h9n9kAQM
         Q+bnQAn34OtdR6YlQmoNO5iMB2HBOF3hwk8wcrRWvQzUbUQUSFSpqOdLQW89fE4Ian
         dO08s8czatflBesPkuJKqyGk5KJv9FlaTpfBbVQjjxJupZSsW5sqx41vHpZUGt8Fnd
         4v71TwMP8iUj4cSya7JzQ/DCtsL9KTcIbjNRld2i+JZaft7W1hHe69ZfGXQ0B9Bpxi
         fL1Kk9PK7H/QIiM8b6Irk/x/LQcNb/PuPtXlPmHmOvB9zc+Y13gR09xeyj+erp5by/
         YjHEW4hbl4xxg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 13/17] btrfs: turn on the encryption ioctls
Date:   Sun, 16 Jul 2023 23:52:44 -0400
Message-Id: <30133a08c7364790ad8376ccc31420667ac2d146.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 35bd673bde3e..d3b0f6533bc5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -787,6 +787,14 @@ static bool btrfs_bio_is_contig(struct btrfs_bio_ctrl *bio_ctrl,
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

