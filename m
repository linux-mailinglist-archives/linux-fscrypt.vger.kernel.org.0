Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF76741D3D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjF2AgQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbjF2AgJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:36:09 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AC12D4E;
        Wed, 28 Jun 2023 17:36:06 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1B56980727;
        Wed, 28 Jun 2023 20:36:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998966; bh=j/41nbP/PqVxCE9M/BBFHhnZO/6K9lDr/ywwQLgMU1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NSrLdJ6dH7hsOTkeSObTPUrZC1apBCFcr0mitS1NP/px3p2RtamVcrSXryGvI4/5v
         1Ylf4PL9GStMu0h5ezhOXjTfKx8CCM5zQCtfO6bZPTJNzhUAySaOQXKO2QSmk1byEX
         tAt/elfCU5YJE80Inze6czsU3XkAJ39Os435DYYmMEAvl5qcbiIJMn+zO0xH5QpE/A
         AX1vUuuYe17AWKE/gCGdPiVY2pfRPXLGRBrsqbWDYlpqUast+wwRpHdFOnNZ+XsBym
         OWj3Vf96W4QmTet5DVKxwxL3HC3z11tSUj6Crxl/rUtHCS5QiEABQniXrFvMbW81Hp
         MQJQkP4SYFhPw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 12/17] btrfs: turn on inlinecrypt mount option for encrypt
Date:   Wed, 28 Jun 2023 20:35:35 -0400
Message-Id: <d83d85bbde9df50ddc7c51f1fed59f1bd28b2137.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
---
 fs/btrfs/ioctl.c |  4 ++++
 fs/btrfs/super.c | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7c4360b59aae..384bad37fa9d 100644
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
index ad18127cee10..d1c192dcd800 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1161,6 +1161,16 @@ static int btrfs_fill_super(struct super_block *sb,
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

