Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C72597207
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbiHQOun (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240312AbiHQOu2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:28 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF4933A26;
        Wed, 17 Aug 2022 07:50:27 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E24C88042B;
        Wed, 17 Aug 2022 10:50:26 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747827; bh=JHa6cPgPBqm+c/l427NbSPkp5eYmufffl4SozhKvgaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HXfA/tBlDmIjYMx7blrpDRIeKa4OoG9RVTZXgCuyMRPhW3ILu0EzLusuAGDriz/vl
         aAkEdpuQRfRLBxcPfrsasjyuA2Nn7+EjmN5sk4xQ2EtXFu2I1v2NQclXm+ZijiBLsf
         CfeJLfG2eqBZMsPK77MOlW1gsXz69Io9i0alFHKX4y3PTL11dZ7kc4ajKBsroLGc55
         NjjWuXtxF9bpQhiHBhwKryeffDie0Ui4HI8bFKWMcCinL0rDTgAW4hLyggXzdS4ghz
         UvRjKXz2gqP5Hg/MyV+XsDBqLXCUc9hHnZUD8s5jZNY6o4/sKNkxzeeUAzhx1uTVtt
         FMyYalr2DP8Tg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 04/21] fscrypt: add a function for a filesystem to generate an IV
Date:   Wed, 17 Aug 2022 10:49:48 -0400
Message-Id: <40f17d7f64a80e0d2746972b4f6b4b5831d4f455.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Unlike other filesystems, which store all necessary encryption context
in the per-inode fscrypt context, btrfs will need to store an IV per
extent in order to support snapshots and reflinks. To avoid exposing the
internal details of extents to fscrypt, and to centralize IV generation
in fscrypt, this change provides fscrypt_generate_random_iv(), which
will be called for each newly created btrfs extent and will populate a
btrfs-provided buffer with a new IV. Additionally, a function to get
the necessary buffer size, fscrypt_mode_ivsize(), is also necessary.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c      | 26 ++++++++++++++++++++++++++
 include/linux/fscrypt.h |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..e0e30d64837e 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -23,6 +23,7 @@
 #include <linux/pagemap.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <linux/scatterlist.h>
 #include <linux/ratelimit.h>
 #include <crypto/skcipher.h>
@@ -69,6 +70,31 @@ void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
+int fscrypt_mode_ivsize(struct inode *inode)
+{
+	struct fscrypt_info *ci;
+
+	if (!fscrypt_needs_contents_encryption(inode))
+		return 0;
+
+	ci = inode->i_crypt_info;
+	if (WARN_ON_ONCE(!ci))
+		return 0;
+	return ci->ci_mode->ivsize;
+}
+EXPORT_SYMBOL(fscrypt_mode_ivsize);
+
+/**
+ * fscrypt_generate_random_iv() - initialize a new iv for an IV_FROM_FS filesystem
+ * @inode: the inode to which the new IV will belong
+ * @iv: an output buffer, long enough for the requisite IV
+ */
+void fscrypt_generate_random_iv(struct inode *inode, u8 *iv)
+{
+	get_random_bytes(iv, fscrypt_mode_ivsize(inode));
+}
+EXPORT_SYMBOL(fscrypt_generate_random_iv);
+
 /*
  * Generate the IV for the given logical block number within the given file.
  * For filenames encryption, lblk_num == 0.
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 1686b25f6d9c..ff572f8a88f8 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -317,6 +317,9 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 
 void fscrypt_free_bounce_page(struct page *bounce_page);
 
+int fscrypt_mode_ivsize(struct inode *inode);
+void fscrypt_generate_random_iv(struct inode *inode, u8 *iv);
+
 /* policy.c */
 int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2);
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
-- 
2.35.1

