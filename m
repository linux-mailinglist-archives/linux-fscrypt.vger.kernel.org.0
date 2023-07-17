Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6536755A4C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbjGQDxZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjGQDxL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:11 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6011BC;
        Sun, 16 Jul 2023 20:53:10 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 713D783411;
        Sun, 16 Jul 2023 23:53:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565990; bh=WMhaRXoxQl+Z3EjoyJXLyi5qtVynebyjLZiAX8ONeno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CC+4ZXMYww3J7ED4uStGTGHhdGHlkCXto4G8HlRnWpHSfyffaQ9DI6ZiEPAJNNOF7
         qoJtsWB+9JPpzoaAYNNRg29ukm7ty9p9bjXlmOYHo3fxKfS6+e8pXnDgpeUtzocrB2
         wm8+nCSjasbnqye61IC3hYADsOUZAM+WUOWpV2JUybqg0y8GVGfg8mPiEObmaPuKsa
         hdTmewMzgLPJwAHh07p1t2P9xoJw8j1fPmHWTGAovnKF5UVk3Cf4bzAiUDZIp5MfpW
         2JFfOxGedxCrmWw9Kl9lsVeZtrTULXyn60HkxD6yeklBCjx+PCTmFnZWBMdXB2r8HY
         OtoSxUT7bS4lg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 12/17] btrfs: turn on inlinecrypt mount option for encrypt
Date:   Sun, 16 Jul 2023 23:52:43 -0400
Message-Id: <303b721e0c738ebb8ee3ada3d4b867a07d6d5bfb.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

fscrypt's extent encryption requires the use of inline encryption or the
software fallback that the block layer provides; it is rather
complicated to allow software encryption with extent encryption due to
the timing of memory allocations. Thus, if btrfs has ever had a
encrypted file, or when encryption is enabled on a directory, update the
mount flags to include inlinecrypt.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ioctl.c |  4 ++++
 fs/btrfs/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 91ad59519900..11866a88e33f 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4574,6 +4574,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		 * state persists.
 		 */
 		btrfs_set_fs_incompat(fs_info, ENCRYPT);
+		if (!(inode->i_sb->s_flags & SB_INLINECRYPT)) {
+			inode->i_sb->s_flags |= SB_INLINECRYPT;
+			mb();
+		}
 		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
 	}
 	case FS_IOC_GET_ENCRYPTION_POLICY:
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0cc9c2909f64..1e9a93c6750a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1165,6 +1165,16 @@ static int btrfs_fill_super(struct super_block *sb,
 		return err;
 	}
 
+	if (btrfs_fs_incompat(fs_info, ENCRYPT)) {
+		if (IS_ENABLED(CONFIG_FS_ENCRYPTION_INLINE_CRYPT)) {
+			sb->s_flags |= SB_INLINECRYPT;
+		} else {
+			btrfs_err(fs_info, "encryption not supported");
+			err = -EINVAL;
+			goto fail_close;
+		}
+	}
+
 	inode = btrfs_iget(sb, BTRFS_FIRST_FREE_OBJECTID, fs_info->fs_root);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
-- 
2.40.1

