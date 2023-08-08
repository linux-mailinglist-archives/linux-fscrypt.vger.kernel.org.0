Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89ED07743A9
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235282AbjHHSIS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbjHHSHw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:52 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1357015C79D;
        Tue,  8 Aug 2023 10:08:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7D4C48354B;
        Tue,  8 Aug 2023 13:08:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514532; bh=xrjfPasFbA6CG7iZqMar52Dj4MLDOfsgZokr8j3aMYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvjcCO/AYRNf05nzYP7Ecc+fUiTXnbVZC42y0MBcxQByjA9HLZuxhaFxiG+4XYbRG
         +WlRRfpiDU7nx3RSeoCoNePDycqAswEFsJnVYihWunb9jrDwvwfX/KCHgZZVkHYN0X
         wTtEAHBDKZ+cVx71bVOkjzlshIRMzMZbb+hOy+tZ3pkkh5d6VkOIUGoJh5DHoL1EAt
         v21IhDurSrXojZ8Qql9IDO3U0zE069+0QvqHPv2CSyiO8Y5w5E0RQugcEuyyqD6pAU
         EnlEdQcA01Le54aJ4NanLK4CG4O9d+gtScKvIIy/DzEn94YNMVaypV1uZi7ayme/O3
         daMFyHS6FHJgA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 08/16] fscrypt: move function call warning of busy inodes
Date:   Tue,  8 Aug 2023 13:08:25 -0400
Message-ID: <2e0b78a61f26eb7c3f17df759fa5bd2513f886ea.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
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

Extent encryption will want to attempt to evict inodes, and not warn of
busy ones, before removing the key instead of after as it is at present.
Therefore pull the call for check_for_busy_inodes() out of
try_to_lock_encrypted_files() into its only callsite.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keyring.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 53e37b8a822c..9d00cadb19ee 100644
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

