Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876967AF24E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbjIZSDc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbjIZSDb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:31 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C721912A
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:23 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-77432add7caso287740885a.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751402; x=1696356202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvUgsr/82Ad7po+7Bh9YYtXxzP0gfJA3GRIgY9dfAeo=;
        b=AWm/6cW0kMaq9m44tHQdv6b+NO5uKpIoenxkbg9kRsjd6V0AGeMLvDJNgUNwnE/nXw
         ugXwmZn6qpzNP3KH8d7/VSQxj6zEXF/fVJCYJ+T5TkPpPMxupYk/9ENiYdGGh+UM008T
         fyLeWxwotiFDX9W69rB29bf4ak4XAorHRWc2nGkUNxY/5MoFRtZaey96J1bRTVBq8I04
         kmlAiJg86HvjWWGnUL/Y4CjkEUy0yPsXBJjtoII9chEBTq+GoSnIzn/rje6QFT/SIYnZ
         Q1uXwYFKd+li9TQQWagx4zirVIutHN2Fl8P9k9lmUQCWPnYoV8KvT2GH70K9xt800ZVZ
         gegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751402; x=1696356202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvUgsr/82Ad7po+7Bh9YYtXxzP0gfJA3GRIgY9dfAeo=;
        b=Ds2E7/sXo8c4YvgkY3orZOBZil7APrDqsXqOByxI5HYiz1AfM4bOHf11KaKR0017z5
         5gaXOqYDLKByCgFS5G+3opbH5E/d0sUDMD2dfghJBYglSx2HasxvXQD7Adw/fmNZVI+4
         VClDkPm/3WcA8JjdM8XCCL96E2oDQ6btzu1/2J9nEGlbleynxumryspAFqdT9VNEhiTp
         vPRHQpkgTrqfVYIy2VUfdJZL20vMShtkQeTf+yaB2NpVySEYyCRVsYIH1d6u4EADhK7b
         XXZvA0lPh+gOd6/Ou20WIC+Ap2LYkOhBReRMhrBw2pz/waF2HNKnpv/aIpNue2gmOWaB
         moow==
X-Gm-Message-State: AOJu0YyCYg8XuJtbn0tegpiKz9yF3IbI1Vc3ZT6T+u3mZFTtGdNCgOD7
        MgOX6FhXk0wQiTW4ei8Igndnzg==
X-Google-Smtp-Source: AGHT+IEYeHPXf3QIxe/GVAvfnuEqDK1wXoiieUM37Xo4d063NQugH/UxgIQmqwE0WwURZVtFCGLlFQ==
X-Received: by 2002:a05:620a:288d:b0:76c:e7b7:1d9d with SMTP id j13-20020a05620a288d00b0076ce7b71d9dmr10200605qkp.27.1695751402655;
        Tue, 26 Sep 2023 11:03:22 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id oq36-20020a05620a612400b0076ef004f659sm4950020qkn.1.2023.09.26.11.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:22 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 08/35] btrfs: disable various operations on encrypted inodes
Date:   Tue, 26 Sep 2023 14:01:34 -0400
Message-ID: <18da950f00bca068377700367d6b0bc091f72fdf.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Initially, only normal data extents will be encrypted. This change
forbids various other bits:
- allows reflinking only if both inodes have the same encryption status
- disable inline data on encrypted inodes

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c   | 3 ++-
 fs/btrfs/reflink.c | 7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 52576deda654..6cba648d5656 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -630,7 +630,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 * compressed) data fits in a leaf and the configured maximum inline
 	 * size.
 	 */
-	if (size < i_size_read(&inode->vfs_inode) ||
+	if (IS_ENCRYPTED(&inode->vfs_inode) ||
+	    size < i_size_read(&inode->vfs_inode) ||
 	    size > fs_info->sectorsize ||
 	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info) ||
 	    data_len > fs_info->max_inline)
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index fabd856e5079..3c66630d87ee 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/blkdev.h>
+#include <linux/fscrypt.h>
 #include <linux/iversion.h>
 #include "ctree.h"
 #include "fs.h"
@@ -809,6 +810,12 @@ static int btrfs_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 		ASSERT(inode_in->i_sb == inode_out->i_sb);
 	}
 
+	/*
+	 * Can only reflink encrypted files if both files are encrypted.
+	 */
+	if (IS_ENCRYPTED(inode_in) != IS_ENCRYPTED(inode_out))
+		return -EINVAL;
+
 	/* Don't make the dst file partly checksummed */
 	if ((BTRFS_I(inode_in)->flags & BTRFS_INODE_NODATASUM) !=
 	    (BTRFS_I(inode_out)->flags & BTRFS_INODE_NODATASUM)) {
-- 
2.41.0

