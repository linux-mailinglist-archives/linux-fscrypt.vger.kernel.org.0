Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4339EDF8AA
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Oct 2019 01:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfJUXcs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 19:32:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfJUXcs (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 19:32:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B07222084C;
        Mon, 21 Oct 2019 23:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571700766;
        bh=qFfFOp8WE39rqMHg4xUorKpoZ/hhSBUr/8GfumvBQXU=;
        h=From:To:Cc:Subject:Date:From;
        b=C0BHzMWoz+iTv52gUSacFl6J8kVGIZHae0UH/hfpdNHJAPttXTYcym9rQaNmgdssy
         W2DI/CvL95PujxdZi/9qBzLyWOFE0y9PiFAYDRAPQAdqyaId7rj8TQoVkwmFHc+Mvv
         e4auyISeX6KpwCFNowKxQ0PQNyb1YYrrx7Jf1uZw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Paul Crowley <paulcrowley@google.com>,
        Paul Lawrence <paullawrence@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [e2fsprogs PATCH] Support the stable_inodes feature
Date:   Mon, 21 Oct 2019 16:30:43 -0700
Message-Id: <20191021233043.36225-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Reserve the codepoint for EXT4_FEATURE_COMPAT_STABLE_INODES, allow it to
be set and cleared, and teach resize2fs to forbid shrinking the
filesystem if it is set.

This feature will allow the use of encryption policies where the inode
number is included in the IVs (initialization vectors) for encryption,
so data would be corrupted if the inodes were to be renumbered.

For more details, see the kernel patchset:
https://lkml.kernel.org/linux-fsdevel/20191021230355.23136-1-ebiggers@kernel.org/T/#u

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/e2p/feature.c    | 2 ++
 lib/ext2fs/ext2_fs.h | 2 ++
 lib/ext2fs/ext2fs.h  | 3 ++-
 misc/mke2fs.c        | 3 ++-
 misc/tune2fs.c       | 6 ++++--
 resize/main.c        | 6 ++++++
 6 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index ae7f7f0a..ad0d7f82 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -47,6 +47,8 @@ static struct feature feature_list[] = {
 			"sparse_super2" },
 	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_FAST_COMMIT,
 			"fast_commit" },
+	{	E2P_FEATURE_COMPAT, EXT4_FEATURE_COMPAT_STABLE_INODES,
+			"stable_inodes" },
 
 	{	E2P_FEATURE_RO_INCOMPAT, EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER,
 			"sparse_super" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index febcb476..3165b389 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -811,6 +811,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP	0x0100
 #define EXT4_FEATURE_COMPAT_SPARSE_SUPER2	0x0200
 #define EXT4_FEATURE_COMPAT_FAST_COMMIT		0x0400
+#define EXT4_FEATURE_COMPAT_STABLE_INODES	0x0800
 
 
 #define EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	0x0001
@@ -913,6 +914,7 @@ EXT4_FEATURE_COMPAT_FUNCS(lazy_bg,		2, LAZY_BG)
 EXT4_FEATURE_COMPAT_FUNCS(exclude_bitmap,	2, EXCLUDE_BITMAP)
 EXT4_FEATURE_COMPAT_FUNCS(sparse_super2,	4, SPARSE_SUPER2)
 EXT4_FEATURE_COMPAT_FUNCS(fast_commit,		4, FAST_COMMIT)
+EXT4_FEATURE_COMPAT_FUNCS(stable_inodes,	4, STABLE_INODES)
 
 EXT4_FEATURE_RO_COMPAT_FUNCS(sparse_super,	2, SPARSE_SUPER)
 EXT4_FEATURE_RO_COMPAT_FUNCS(large_file,	2, LARGE_FILE)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 334944d9..a5ed10fc 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -612,7 +612,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_EXT_ATTR|\
 					 EXT4_FEATURE_COMPAT_SPARSE_SUPER2|\
-					 EXT4_FEATURE_COMPAT_FAST_COMMIT)
+					 EXT4_FEATURE_COMPAT_FAST_COMMIT|\
+					 EXT4_FEATURE_COMPAT_STABLE_INODES)
 
 #ifdef CONFIG_MMP
 #define EXT4_LIB_INCOMPAT_MMP		EXT4_FEATURE_INCOMPAT_MMP
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index fe495844..ffea8233 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -1144,7 +1144,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
 		EXT2_FEATURE_COMPAT_EXT_ATTR |
 		EXT4_FEATURE_COMPAT_SPARSE_SUPER2 |
-		EXT4_FEATURE_COMPAT_FAST_COMMIT,
+		EXT4_FEATURE_COMPAT_FAST_COMMIT |
+		EXT4_FEATURE_COMPAT_STABLE_INODES,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|
 		EXT3_FEATURE_INCOMPAT_EXTENTS|
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 39fce4a9..c11e7452 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -150,7 +150,8 @@ static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
-		EXT4_FEATURE_COMPAT_FAST_COMMIT,
+		EXT4_FEATURE_COMPAT_FAST_COMMIT |
+		EXT4_FEATURE_COMPAT_STABLE_INODES,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT3_FEATURE_INCOMPAT_EXTENTS |
@@ -180,7 +181,8 @@ static __u32 clear_ok_features[3] = {
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
-		EXT4_FEATURE_COMPAT_FAST_COMMIT,
+		EXT4_FEATURE_COMPAT_FAST_COMMIT |
+		EXT4_FEATURE_COMPAT_STABLE_INODES,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
 		EXT4_FEATURE_INCOMPAT_FLEX_BG |
diff --git a/resize/main.c b/resize/main.c
index a0c31c06..cb0bf6a0 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -605,6 +605,12 @@ int main (int argc, char ** argv)
 		fprintf(stderr, _("The filesystem is already 32-bit.\n"));
 		exit(0);
 	}
+	if (new_size < ext2fs_blocks_count(fs->super) &&
+	    ext2fs_has_feature_stable_inodes(fs->super)) {
+		fprintf(stderr, _("Cannot shrink this filesystem "
+			"because it has the stable_inodes feature flag.\n"));
+		exit(1);
+	}
 	if (mount_flags & EXT2_MF_MOUNTED) {
 		retval = online_resize_fs(fs, mtpt, &new_size, flags);
 	} else {
-- 
2.23.0.866.gb869b98d4c-goog

