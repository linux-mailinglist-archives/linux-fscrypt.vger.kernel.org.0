Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82517743DB
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbjHHSK6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbjHHSK3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:10:29 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3871B1B068;
        Tue,  8 Aug 2023 10:12:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CA9DB83440;
        Tue,  8 Aug 2023 13:12:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514763; bh=zOKNZbAfiK+odlXUuWM8XxSwVUpiOYgsRZM26vBnM0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZDtWdk08CozyHJ09AUWJoLb8cMGOpA7JVPlSIWtQ3gGCaW+cbBMcoqihlF1rHLAh
         +cFSL+Fw9dCqfNeLe37FlGZe7Jsk9rdiMGRaDopV43583IMDvmWRjJnEcRt5Qfi+xd
         4ABD0IYBVoyRNBJQiIBszWmfiflkOCFTc3rdOh067wEQbrLSj+Yhz+slt5C13gGoQu
         XwTODoOHVxmWv78gA0tVm4DJbMVSBkjbma17WyhnUCdtJJWmoPp1kC/tsS6ghEJfT1
         n4ZD1VEMn30jep1hyA+9qhpy+9Jzwl/jwdfRD/BqlEnB6ZWRFx/PAO1Dg+asObBXWI
         eQ1ZccbsumDHg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 12/17] btrfs: turn on inlinecrypt mount option for encrypt
Date:   Tue,  8 Aug 2023 13:12:14 -0400
Message-ID: <c6e584da3cedef803cf994381c95c52080d17685.1691510179.git.sweettea-kernel@dorminy.me>
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

fscrypt's extent encryption requires the use of inline encryption or the
software fallback that the block layer provides; it is rather
complicated to allow software encryption with extent encryption due to
the timing of memory allocations. Thus, if btrfs has ever had a
encrypted file, or when encryption is enabled on a directory, update the
mount flags to include inlinecrypt.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ioctl.c |  3 +++
 fs/btrfs/super.c | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 91ad59519900..42525a8119ee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4574,6 +4574,9 @@ long btrfs_ioctl(struct file *file, unsigned int
 		 * state persists.
 		 */
 		btrfs_set_fs_incompat(fs_info, ENCRYPT);
+		if (!(inode->i_sb->s_flags & SB_INLINECRYPT)) {
+			inode->i_sb->s_flags |= SB_INLINECRYPT;
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
2.41.0

