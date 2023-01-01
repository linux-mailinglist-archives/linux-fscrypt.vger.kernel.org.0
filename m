Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350C465A8F9
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjAAFNt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjAAFNr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:47 -0500
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 31 Dec 2022 21:13:46 PST
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229E963CC
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:45 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 4CB8B82647;
        Sun,  1 Jan 2023 00:06:49 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549609; bh=kIBJVYH2JqSKtwNK1QBti5TNYAdm7cp7w0tqOZfFeZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxgx0hEHqqVEcnK6BIa/+pYem6g0O8j9J23+hUXjO/eDzvi6M7hh+/ECz7Up9fASz
         y6o7wXRgGLWa08X9mr5kMePPIOGN4+t0ITtx3iRSiEllAyjuzg1cHGgBu2+wXJDcZi
         nNu6Xu3RYWve/ghkpaSPn/yvzl9zv9uBoIewWw0ud89Xuv0ZUyIB8P06vAI0jMNJlU
         62eXZHV1ZHhQ5mP2arJuidwPWOrZqYpxiJNK3mtRbJmte9A9KO+DricGHIOpy28yGr
         fFiZh2VXytIB+N+whS36XbyWGK/A6LAYgBjdGOSc07wRN25oPMctAxdlrZs8SqboBI
         YfgdAZ2vtb7gQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 10/17] fscrypt: let fscrypt_infos be owned by an extent
Date:   Sun,  1 Jan 2023 00:06:14 -0500
Message-Id: <e5e72a4404601c495551ea96f80f0eca4bc8942c.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In order to notify extents when their info is part of a master key which
is going away, the fscrypt_info must have a backpointer to the extent
somehow. Similarly, if a fscrypt_info is owned by an extent, the info
must not have a pointer to an inode -- multiple inodes may reference a
extent, and the first inode to cause an extent's creation may have a
lifetime much shorter than the extent, so there is no inode pointer
safe to track in an extent-owned info. Therefore, this adds a new
pointer for extent-owned infos to track their extent and updates
fscrypt_setup_encryption_info() accordingly.

 Since it's simple to track the piece of extent memory pointing to the
info, and for the extent to then go from such a pointer to the whole
extent via container_of(), we store that. Although some sort of generic
void * or some artificial fscrypt_extent embedded structure would also
work, those would require additional plumbing which doesn't seem
strictly required or clarifying.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 6 ++++++
 fs/crypto/keysetup.c        | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 0c7b785f1d8c..dc45cd35391f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -229,6 +229,12 @@ struct fscrypt_info {
 	/* Back-pointer to the inode, for infos owned by a specific inode */
 	struct inode *ci_inode;
 
+	/*
+	 * Back-pointer to the info pointer in the extent, for infos owned
+	 * by an extent
+	 */
+	struct fscrypt_info **ci_info_ptr;
+
 	/* The superblock of the filesystem to which this fscrypt_info pertains */
 	struct super_block *ci_sb;
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 04f01da900ca..c611e2613aa6 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -567,7 +567,11 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (!crypt_info)
 		return -ENOMEM;
 
-	crypt_info->ci_inode = inode;
+	if (fscrypt_uses_extent_encryption(inode))
+		crypt_info->ci_info_ptr = info_ptr;
+	else
+		crypt_info->ci_inode = inode;
+
 	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
-- 
2.38.1

