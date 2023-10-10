Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CA17C41AD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343827AbjJJUmB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234759AbjJJUlm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:42 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E3F100
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:40 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-5a7dd65052aso1311437b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970500; x=1697575300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lG6cmi+XemzHTouP6yyHX+TZQxYU9G/Ow3oUnVe924=;
        b=F+/9Adi+b3GzspzkQb5Byi98CWzU6LKQgV929RyssnxlDgvMFngGZSoTqanWlTefrz
         zoECQYkFbfuuCSKowrf5tcjaSLc3kz8xwFhQbrd3ZZ8G42qjNuBw2HXUaZvnxcT3NSgQ
         21B54bPsfvBu+vpW7Pjl2+E4XkPu6HAcegkyRSw3Dq/bHegLw94x7Zz0NR22UpKvBSyU
         alkOdTEmCMZ5kHHua/yMMsdKWTnMepKU+/ZFTO5sdAePGF0Tu0jvJH4VLLGHprxqOX24
         4laSW8n0qHdUCOen3gto0BN1vp5+Ozhx1Y7sNXZ270yrDf/caLLRaT31zHPzEPcSV0EM
         zM1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970500; x=1697575300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/lG6cmi+XemzHTouP6yyHX+TZQxYU9G/Ow3oUnVe924=;
        b=aXmORLoOyyLXhBLl6hGhtrGMbB6LHtv2WIaKaSQAmjRlUwexYIrWQMOjFkiOra6zbT
         o2cmwndMHHuw20XTSVNfJIbUmoYdUURoFJ+xQqvo1QoyjYNXVKjyaz+fk6gFGZ75R5mK
         2qgJYkrPjXKiiaDDMPBP5oRSe8arWSAiMErIMMdGjqLjzN/1qgmdac+STJR/RFu2i2f8
         H+u0GxLmHhBeMN348PWqd0t5SaSGXzgsPrCpN3ka8J/cWrYqDFITrynVIai96oKNFRKr
         BZc3HhQOzIaxg3LSe/9Aa3vgjgP25LQKd4Ie/M+DRTjDaNU3zgA+myHyNfZNrD5kHhBi
         N4YQ==
X-Gm-Message-State: AOJu0YzFTTGq6fMYhq/n89PG8EmSDAvJM3rN8v5B1z/kfEtSTJ8jtAc9
        Z4bNQlyqO0P2FxJqJYuW1cPRASgQCFJJieOwUrxSJA==
X-Google-Smtp-Source: AGHT+IGXe9amKvpJyO5M8/JuTI+aDqvTaDKYFnIZP/ZdjePk0VuktS4VhqLJ94oENqhSEDYviaFwBw==
X-Received: by 2002:a0d:d7d1:0:b0:5a7:cff3:e407 with SMTP id z200-20020a0dd7d1000000b005a7cff3e407mr1876485ywd.31.1696970499900;
        Tue, 10 Oct 2023 13:41:39 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d68-20020a0df447000000b0059f5d686479sm4671247ywf.16.2023.10.10.13.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:39 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 31/36] btrfs: setup fscrypt_extent_info for new extents
Date:   Tue, 10 Oct 2023 16:40:46 -0400
Message-ID: <a70ef886566aa8dd52c4c9713f74b632e3e3ea85.1696970227.git.josef@toxicpanda.com>
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

New extents for encrypted inodes must have a fscrypt_extent_info, which
has the necessary keys and does all the registration at the block layer
for them.  This is passed through all of the infrastructure we've
previously added to make sure the context gets saved properly with the
file extents.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4f23c3af60be..b0109b313217 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7396,7 +7396,20 @@ static struct extent_map *create_io_em(struct btrfs_inode *inode, u64 start,
 		set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		em->compress_type = compress_type;
 	}
-	em->encryption_type = BTRFS_ENCRYPTION_NONE;
+
+	if (IS_ENCRYPTED(&inode->vfs_inode)) {
+		struct fscrypt_extent_info *fscrypt_info;
+
+		em->encryption_type = BTRFS_ENCRYPTION_FSCRYPT;
+		fscrypt_info = fscrypt_prepare_new_extent(&inode->vfs_inode);
+		if (IS_ERR(fscrypt_info)) {
+			free_extent_map(em);
+			return ERR_CAST(fscrypt_info);
+		}
+		em->fscrypt_info = fscrypt_info;
+	} else {
+		em->encryption_type = BTRFS_ENCRYPTION_NONE;
+	}
 
 	ret = btrfs_replace_extent_map_range(inode, em, true);
 	if (ret) {
@@ -9785,6 +9798,9 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 	if (trans)
 		own_trans = false;
 	while (num_bytes > 0) {
+		struct fscrypt_extent_info *fscrypt_info = NULL;
+		int encryption_type = BTRFS_ENCRYPTION_NONE;
+
 		cur_bytes = min_t(u64, num_bytes, SZ_256M);
 		cur_bytes = max(cur_bytes, min_size);
 		/*
@@ -9799,6 +9815,20 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		if (ret)
 			break;
 
+		if (IS_ENCRYPTED(inode)) {
+			fscrypt_info = fscrypt_prepare_new_extent(inode);
+			if (IS_ERR(fscrypt_info)) {
+				btrfs_dec_block_group_reservations(fs_info,
+								   ins.objectid);
+				btrfs_free_reserved_extent(fs_info,
+							   ins.objectid,
+							   ins.offset, 0);
+				ret = PTR_ERR(fscrypt_info);
+				break;
+			}
+			encryption_type = BTRFS_ENCRYPTION_FSCRYPT;
+		}
+
 		/*
 		 * We've reserved this space, and thus converted it from
 		 * ->bytes_may_use to ->bytes_reserved.  Any error that happens
@@ -9810,7 +9840,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		last_alloc = ins.offset;
 		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, NULL, cur_offset);
+						    &ins, fscrypt_info,
+						    cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
@@ -9820,6 +9851,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
+			fscrypt_put_extent_info(fscrypt_info);
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
 						   ins.offset, 0);
 			break;
@@ -9827,6 +9859,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		em = alloc_extent_map();
 		if (!em) {
+			fscrypt_put_extent_info(fscrypt_info);
 			btrfs_drop_extent_map_range(BTRFS_I(inode), cur_offset,
 					    cur_offset + ins.offset - 1, false);
 			btrfs_set_inode_full_sync(BTRFS_I(inode));
@@ -9842,6 +9875,8 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		em->ram_bytes = ins.offset;
 		set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 		em->generation = trans->transid;
+		em->fscrypt_info = fscrypt_info;
+		em->encryption_type = encryption_type;
 
 		ret = btrfs_replace_extent_map_range(BTRFS_I(inode), em, true);
 		free_extent_map(em);
-- 
2.41.0

