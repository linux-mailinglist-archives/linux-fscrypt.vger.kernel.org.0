Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D464D27E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 23:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLNWpq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 17:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiLNWpn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 17:45:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A72FCED;
        Wed, 14 Dec 2022 14:45:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1B6661C3C;
        Wed, 14 Dec 2022 22:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E012AC433D2;
        Wed, 14 Dec 2022 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057942;
        bh=s8dg1vvBSOe1uFDb6X0c7Lo1qJtF6A37tS92++ok0e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtUriyDzkRFPg4njwQjjGG6jpMpkutiINigs/Wv2bMtLBVzTvcSX4F5DkYlXNiZOt
         zLA9iiJCMQ3dst+01fJVh6ksPbvnjoWW5M6UXO2N5jNXTZQB2Wb2dC12IRz+7yv0yf
         AywvCVZfvh/7oc0LOlOccnongCuLUyuDFOp/joMg6Yo9JnskD4c6R9CtRAIdUtb79e
         291m10yspAAJpN2MO+vco+K2vsZBOX/bmAIDYE9shLc5qmXFi4PSEfZ2HUeyS5Y0On
         5VGX6RdU1ac8VCy/Lm+g1FHyrRbL4CBEVPNT7GdB2vjS0VkzmVcAohXGzFklXzqf1K
         vLLQDWD25QVPA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] fsverity: optimize fsverity_cleanup_inode() on non-verity files
Date:   Wed, 14 Dec 2022 14:43:03 -0800
Message-Id: <20221214224304.145712-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221214224304.145712-1-ebiggers@kernel.org>
References: <20221214224304.145712-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make fsverity_cleanup_inode() an inline function that checks for
non-NULL ->i_verity_info, then (if needed) calls
__fsverity_cleanup_inode() to do the real work.  This reduces the
overhead on non-verity files.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/open.c         | 10 ++--------
 include/linux/fsverity.h | 14 +++++++++++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index e1e531d5e09a..c723a62841db 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -348,18 +348,12 @@ int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 }
 EXPORT_SYMBOL_GPL(__fsverity_prepare_setattr);
 
-/**
- * fsverity_cleanup_inode() - free the inode's verity info, if present
- * @inode: an inode being evicted
- *
- * Filesystems must call this on inode eviction to free ->i_verity_info.
- */
-void fsverity_cleanup_inode(struct inode *inode)
+void __fsverity_cleanup_inode(struct inode *inode)
 {
 	fsverity_free_info(inode->i_verity_info);
 	inode->i_verity_info = NULL;
 }
-EXPORT_SYMBOL_GPL(fsverity_cleanup_inode);
+EXPORT_SYMBOL_GPL(__fsverity_cleanup_inode);
 
 int __init fsverity_init_info_cache(void)
 {
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 84b498fff7ec..203f4962c54a 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -150,7 +150,19 @@ int fsverity_get_digest(struct inode *inode,
 
 int __fsverity_file_open(struct inode *inode, struct file *filp);
 int __fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr);
-void fsverity_cleanup_inode(struct inode *inode);
+void __fsverity_cleanup_inode(struct inode *inode);
+
+/**
+ * fsverity_cleanup_inode() - free the inode's verity info, if present
+ * @inode: an inode being evicted
+ *
+ * Filesystems must call this on inode eviction to free ->i_verity_info.
+ */
+static inline void fsverity_cleanup_inode(struct inode *inode)
+{
+	if (inode->i_verity_info)
+		__fsverity_cleanup_inode(inode);
+}
 
 /* read_metadata.c */
 
-- 
2.38.1

