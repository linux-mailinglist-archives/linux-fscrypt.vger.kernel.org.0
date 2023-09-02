Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5695790567
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351609AbjIBFzy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbjIBFzx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:55:53 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0966210F4;
        Fri,  1 Sep 2023 22:55:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 68C88807EE;
        Sat,  2 Sep 2023 01:55:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634150; bh=b0hkPiFJJoeGPFIcEAEMWTWUyHVLSXX4xFrlWcwMaGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZxXhxmXRGRsxJDu7m5kcD2liS3Heh4gquDSrd5mBzDMrOJJbsQvtcDFU0NtRTb8i
         oIkPDu0lfiKYQ9FLr12s0V+cY6RVK2typusK6A1pAqtMmz/FJRVtrtd+ULH/NWN3lU
         sUbovEf6vMb5A6cgb7dLXcJf1CIsN/2dF5eTlXQ7/H8oLJYwCiJlJSvgrjppqc9ynl
         z72uAewr1PVBPL0kM/PexsENM6vBCmCU/4I1aXScU3oFue0galMV9UAfYGFJ/D7bOK
         FBXlJUL4A5CSxOZMV/1Ipd34hdLQ4SLnblpk01lNwpY6Mv/1tF0FmmVP0MQ7+M+BuP
         UjdAqm9sCc82g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 03/13] fscrypt: move function call warning of busy inodes
Date:   Sat,  2 Sep 2023 01:54:21 -0400
Message-ID: <bc0729de13b00eebc1e1c8b7b832c994b07b4d6c.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Extent encryption will want to attempt to evict inodes, and not warn of
busy ones, before removing the key instead of after as it is at present.
Therefore pull the call for check_for_busy_inodes() out of
try_to_lock_encrypted_files() into its only callsite.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keyring.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7cbb1fd872ac..d153988b7403 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -938,8 +938,7 @@ static int check_for_busy_inodes(struct super_block *sb,
 static int try_to_lock_encrypted_files(struct super_block *sb,
 				       struct fscrypt_master_key *mk)
 {
-	int err1;
-	int err2;
+	int err;
 
 	/*
 	 * An inode can't be evicted while it is dirty or has dirty pages.
@@ -951,7 +950,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 	 * already call sync_filesystem() via sys_syncfs() or sys_sync().
 	 */
 	down_read(&sb->s_umount);
-	err1 = sync_filesystem(sb);
+	err = sync_filesystem(sb);
 	up_read(&sb->s_umount);
 	/* If a sync error occurs, still try to evict as much as possible. */
 
@@ -963,16 +962,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 	 */
 	evict_dentries_for_decrypted_inodes(mk);
 
-	/*
-	 * evict_dentries_for_decrypted_inodes() already iput() each inode in
-	 * the list; any inodes for which that dropped the last reference will
-	 * have been evicted due to fscrypt_drop_inode() detecting the key
-	 * removal and telling the VFS to evict the inode.  So to finish, we
-	 * just need to check whether any inodes couldn't be evicted.
-	 */
-	err2 = check_for_busy_inodes(sb, mk);
-
-	return err1 ?: err2;
+	return err;
 }
 
 /*
@@ -1064,8 +1054,17 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	up_write(&mk->mk_sem);
 
 	if (inodes_remain) {
+		int err2;
 		/* Some inodes still reference this key; try to evict them. */
 		err = try_to_lock_encrypted_files(sb, mk);
+		/* We already tried to iput() each inode referencing this key
+		 * which would cause the inode to be evicted if that was the
+		 * last reference (since fscrypt_drop_inode() would see the
+		 * key removal). So the only remaining inodes referencing this
+		 * key are still busy and couldn't be evicted; check for them.
+		 */
+		err2 = check_for_busy_inodes(sb, mk);
+		err = err ?: err2;
 		if (err == -EBUSY) {
 			status_flags |=
 				FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY;
-- 
2.41.0

