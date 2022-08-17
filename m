Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638045971E7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiHQOuw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240442AbiHQOuv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:51 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFA2870AE;
        Wed, 17 Aug 2022 07:50:49 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 31DF180B43;
        Wed, 17 Aug 2022 10:50:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747849; bh=5ltf9+aHzLL7uF7ovh9MyC2pwbWq7b6ckluppS6/LWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+VWLScwjDI71g9mMJUqR8xeG9eF9byVgwkTzJ6net42j+7IMS7nnUHsyfPFPTgo7
         uiygcoRZSlw3OhAFY3/8TDLGRr0ch59CbPkAXIqvC4ihGSon51O04BPcDopS2laGot
         V+dK4FXkHs3h/Sy8gaTFxRbyWxQoe/Ity35ES5TbicoasxEUhWcCDZUZSTZlFCAn37
         8DE+nEEXEzQkzKSLqHPaCUi+Rp/HlBuSMLJlZSAJZe8V87qoIVFk0awCP9jajz9VX0
         V5dPNdRftBzgX+gXhAUCzSKbXZ5yY+Qx3XQUPN6HXOAbxPhxGxaozmgfwistEmngmW
         wS1O89hyEeAAg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 15/21] btrfs: add iv generation function for fscrypt
Date:   Wed, 17 Aug 2022 10:49:59 -0400
Message-Id: <229f4296f3105acb17477bf791ecbbb9e5e587a8.1660744500.git.sweettea-kernel@dorminy.me>
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

As btrfs cannot use the standard inode or logical block based encryption
for data block encryption, it must provide a IV generation function and
users must use the IV_FROM_FS policy. For filenames, we can just use the
nonce that fscrypt stores per-inode, since these encrypted datum are not
shared between inodes; later on, we will store an IV per file extent,
and return it in this function for data encryption.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fscrypt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 959efc4c179b..95a84d426d06 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -187,9 +187,21 @@ static bool btrfs_fscrypt_empty_dir(struct inode *inode)
 	return true;
 }
 
+static void btrfs_fscrypt_get_iv(u8 *iv, int ivsize, struct inode *inode,
+				 u64 lblk_num)
+{
+	/*
+	 * For encryption that doesn't involve extent data, juse use the
+	 * nonce already loaded into the iv buffer.
+	 */
+	return;
+}
+
 const struct fscrypt_operations btrfs_fscrypt_ops = {
+	.flags = FS_CFLG_ALLOW_PARTIAL,
 	.key_prefix = "btrfs:",
 	.get_context = btrfs_fscrypt_get_context,
 	.set_context = btrfs_fscrypt_set_context,
 	.empty_dir = btrfs_fscrypt_empty_dir,
+	.get_fs_defined_iv = btrfs_fscrypt_get_iv,
 };
-- 
2.35.1

