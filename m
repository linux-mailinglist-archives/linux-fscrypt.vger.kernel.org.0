Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA5E74C79E
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjGISyH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGISyG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:06 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EAE124;
        Sun,  9 Jul 2023 11:54:05 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3491880B12;
        Sun,  9 Jul 2023 14:54:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928845; bh=/gP2lo5etgBA/0m81swZ4MxB420vD3xEZzLyHrp/WV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds3fWeLUPjYekrqHmr/0mC+gkWnQZ3/LCIqNPgE8z4zYUBZnrubfLJV/Q+OPr/cPu
         5DdGFFGU9bxI+xLRQRpjalrPBmDaOVSdLNXtjDsbf3i8FrOfEEW/7yGjhjdL0NW1LW
         Z41pkSu+z76vi0ZrAfyvHVGAQXNIdU8c1UxqJHJKI12ih2/9gQgaHpr41cjhafEb0K
         Zg9KuFgrGqrkhUMxmageQG4iZJtZ8iMiNXC3BTI2S3v3BZHm1XhhKmhSVv2gi1iiH0
         KWOd2RdFFXkJnV/LuuxC4KRRTeTLhAqbdk/u3UWFgvV3wW9AQa/Fril1gqtlFKyO8j
         zOIvd82arFltQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 09/14] fscrypt: move function call warning of busy inodes
Date:   Sun,  9 Jul 2023 14:53:42 -0400
Message-Id: <cde56d55c6546a7861165acb8299e413d815e794.1688927487.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927487.git.sweettea-kernel@dorminy.me>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
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

Extent encryption will want to attempt to evict inodes, and not warn of
busy ones, before removing the key instead of after as it is at present.
Therefore pull the call for check_for_busy_inodes() out of
try_to_lock_encrypted_files() into its only callsite.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keyring.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index bfcd2ecbe481..c4499248b6cc 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -947,8 +947,7 @@ static int check_for_busy_inodes(struct super_block *sb,
 static int try_to_lock_encrypted_files(struct super_block *sb,
 				       struct fscrypt_master_key *mk)
 {
-	int err1;
-	int err2;
+	int err;
 
 	/*
 	 * An inode can't be evicted while it is dirty or has dirty pages.
@@ -960,7 +959,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 	 * already call sync_filesystem() via sys_syncfs() or sys_sync().
 	 */
 	down_read(&sb->s_umount);
-	err1 = sync_filesystem(sb);
+	err = sync_filesystem(sb);
 	up_read(&sb->s_umount);
 	/* If a sync error occurs, still try to evict as much as possible. */
 
@@ -972,16 +971,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
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
@@ -1073,14 +1063,24 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
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
 			err = 0;
 		}
 	}
+
 	/*
 	 * We return 0 if we successfully did something: removed a claim to the
 	 * key, wiped the secret, or tried locking the files again.  Users need
-- 
2.40.1

