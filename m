Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFD22200DE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Jul 2020 01:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGNXKQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jul 2020 19:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbgGNXKQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jul 2020 19:10:16 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0412065E;
        Tue, 14 Jul 2020 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594768215;
        bh=n1oN1Qr3P3Uv5BVMqP8hutjoneZjpdktEX3mmmuQoIQ=;
        h=From:To:Cc:Subject:Date:From;
        b=u/udhNAsz5nFq0nkmvC+u3K1hexN7SmLaLQe3bnRbDjrDsuw1sJ9G7DJ5G49Mzhmv
         1IrNOrwJHNDd/MQc50NTQHxnBbCwYSg3st6DnmVdUCVMNSUA8J5yKo9u7HmEAi6j8w
         owj4IDeOYxFSaokUDYSK4VqrnuA08IAP5aqAEFe4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Cc:     linux-fscrypt@vger.kernel.org, Jiaheng Hu <jiahengh@google.com>
Subject: [PATCH] ext4: use generic names for generic ioctls
Date:   Tue, 14 Jul 2020 16:09:09 -0700
Message-Id: <20200714230909.56349-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Don't define EXT4_IOC_* aliases to ioctls that already have a generic
FS_IOC_* name.  These aliases are unnecessary, and they make it unclear
which ioctls are ext4-specific and which are generic.

Exception: leave EXT4_IOC_GETVERSION_OLD and EXT4_IOC_SETVERSION_OLD
as-is for now, since renaming them to FS_IOC_GETVERSION and
FS_IOC_SETVERSION would probably make them more likely to be confused
with EXT4_IOC_GETVERSION and EXT4_IOC_SETVERSION which also exist.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/admin-guide/ext4.rst | 20 +++++++++----------
 fs/ext4/ext4.h                     | 12 +----------
 fs/ext4/ioctl.c                    | 32 +++++++++++++++---------------
 3 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/Documentation/admin-guide/ext4.rst b/Documentation/admin-guide/ext4.rst
index 9443fcef1876..7fc6a72920c9 100644
--- a/Documentation/admin-guide/ext4.rst
+++ b/Documentation/admin-guide/ext4.rst
@@ -522,21 +522,21 @@ Files in /sys/fs/ext4/<devname>:
 Ioctls
 ======
 
-There is some Ext4 specific functionality which can be accessed by applications
-through the system call interfaces. The list of all Ext4 specific ioctls are
-shown in the table below.
+Ext4 implements various ioctls which can be used by applications to access
+ext4-specific functionality. An incomplete list of these ioctls is shown in the
+table below. This list includes truly ext4-specific ioctls (``EXT4_IOC_*``) as
+well as ioctls that may have been ext4-specific originally but are now supported
+by some other filesystem(s) too (``FS_IOC_*``).
 
-Table of Ext4 specific ioctls
+Table of Ext4 ioctls
 
-  EXT4_IOC_GETFLAGS
+  FS_IOC_GETFLAGS
         Get additional attributes associated with inode.  The ioctl argument is
-        an integer bitfield, with bit values described in ext4.h. This ioctl is
-        an alias for FS_IOC_GETFLAGS.
+        an integer bitfield, with bit values described in ext4.h.
 
-  EXT4_IOC_SETFLAGS
+  FS_IOC_SETFLAGS
         Set additional attributes associated with inode.  The ioctl argument is
-        an integer bitfield, with bit values described in ext4.h. This ioctl is
-        an alias for FS_IOC_SETFLAGS.
+        an integer bitfield, with bit values described in ext4.h.
 
   EXT4_IOC_GETVERSION, EXT4_IOC_GETVERSION_OLD
         Get the inode i_generation number stored for each inode. The
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42f5060f3cdf..fe71533afe71 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -437,7 +437,7 @@ struct flex_groups {
 #define EXT4_FL_USER_VISIBLE		0x725BDFFF /* User visible flags */
 #define EXT4_FL_USER_MODIFIABLE		0x624BC0FF /* User modifiable flags */
 
-/* Flags we can manipulate with through EXT4_IOC_FSSETXATTR */
+/* Flags we can manipulate with through FS_IOC_FSSETXATTR */
 #define EXT4_FL_XFLAG_VISIBLE		(EXT4_SYNC_FL | \
 					 EXT4_IMMUTABLE_FL | \
 					 EXT4_APPEND_FL | \
@@ -669,8 +669,6 @@ enum {
 /*
  * ioctl commands
  */
-#define	EXT4_IOC_GETFLAGS		FS_IOC_GETFLAGS
-#define	EXT4_IOC_SETFLAGS		FS_IOC_SETFLAGS
 #define	EXT4_IOC_GETVERSION		_IOR('f', 3, long)
 #define	EXT4_IOC_SETVERSION		_IOW('f', 4, long)
 #define	EXT4_IOC_GETVERSION_OLD		FS_IOC_GETVERSION
@@ -687,17 +685,11 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_PRECACHE_EXTENTS	_IO('f', 18)
-#define EXT4_IOC_SET_ENCRYPTION_POLICY	FS_IOC_SET_ENCRYPTION_POLICY
-#define EXT4_IOC_GET_ENCRYPTION_PWSALT	FS_IOC_GET_ENCRYPTION_PWSALT
-#define EXT4_IOC_GET_ENCRYPTION_POLICY	FS_IOC_GET_ENCRYPTION_POLICY
 /* ioctl codes 19--39 are reserved for fscrypt */
 #define EXT4_IOC_CLEAR_ES_CACHE		_IO('f', 40)
 #define EXT4_IOC_GETSTATE		_IOW('f', 41, __u32)
 #define EXT4_IOC_GET_ES_CACHE		_IOWR('f', 42, struct fiemap)
 
-#define EXT4_IOC_FSGETXATTR		FS_IOC_FSGETXATTR
-#define EXT4_IOC_FSSETXATTR		FS_IOC_FSSETXATTR
-
 #define EXT4_IOC_SHUTDOWN _IOR ('X', 125, __u32)
 
 /*
@@ -722,8 +714,6 @@ enum {
 /*
  * ioctl commands in 32 bit emulation
  */
-#define EXT4_IOC32_GETFLAGS		FS_IOC32_GETFLAGS
-#define EXT4_IOC32_SETFLAGS		FS_IOC32_SETFLAGS
 #define EXT4_IOC32_GETVERSION		_IOR('f', 3, int)
 #define EXT4_IOC32_SETVERSION		_IOW('f', 4, int)
 #define EXT4_IOC32_GETRSVSZ		_IOR('f', 5, int)
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 999cf6add39c..6e70a63dcca7 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -819,12 +819,12 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case FS_IOC_GETFSMAP:
 		return ext4_ioc_getfsmap(sb, (void __user *)arg);
-	case EXT4_IOC_GETFLAGS:
+	case FS_IOC_GETFLAGS:
 		flags = ei->i_flags & EXT4_FL_USER_VISIBLE;
 		if (S_ISREG(inode->i_mode))
 			flags &= ~EXT4_PROJINHERIT_FL;
 		return put_user(flags, (int __user *) arg);
-	case EXT4_IOC_SETFLAGS: {
+	case FS_IOC_SETFLAGS: {
 		int err;
 
 		if (!inode_owner_or_capable(inode))
@@ -1129,12 +1129,12 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_PRECACHE_EXTENTS:
 		return ext4_ext_precache(inode);
 
-	case EXT4_IOC_SET_ENCRYPTION_POLICY:
+	case FS_IOC_SET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
 		return fscrypt_ioctl_set_policy(filp, (const void __user *)arg);
 
-	case EXT4_IOC_GET_ENCRYPTION_PWSALT: {
+	case FS_IOC_GET_ENCRYPTION_PWSALT: {
 #ifdef CONFIG_FS_ENCRYPTION
 		int err, err2;
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1174,7 +1174,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -EOPNOTSUPP;
 #endif
 	}
-	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
@@ -1236,7 +1236,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_GET_ES_CACHE:
 		return ext4_ioctl_get_es_cache(filp, arg);
 
-	case EXT4_IOC_FSGETXATTR:
+	case FS_IOC_FSGETXATTR:
 	{
 		struct fsxattr fa;
 
@@ -1247,7 +1247,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			return -EFAULT;
 		return 0;
 	}
-	case EXT4_IOC_FSSETXATTR:
+	case FS_IOC_FSSETXATTR:
 	{
 		struct fsxattr fa, old_fa;
 		int err;
@@ -1313,11 +1313,11 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	/* These are just misnamed, they actually get/put from/to user an int */
 	switch (cmd) {
-	case EXT4_IOC32_GETFLAGS:
-		cmd = EXT4_IOC_GETFLAGS;
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
 		break;
-	case EXT4_IOC32_SETFLAGS:
-		cmd = EXT4_IOC_SETFLAGS;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
 		break;
 	case EXT4_IOC32_GETVERSION:
 		cmd = EXT4_IOC_GETVERSION;
@@ -1361,9 +1361,9 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_RESIZE_FS:
 	case FITRIM:
 	case EXT4_IOC_PRECACHE_EXTENTS:
-	case EXT4_IOC_SET_ENCRYPTION_POLICY:
-	case EXT4_IOC_GET_ENCRYPTION_PWSALT:
-	case EXT4_IOC_GET_ENCRYPTION_POLICY:
+	case FS_IOC_SET_ENCRYPTION_POLICY:
+	case FS_IOC_GET_ENCRYPTION_PWSALT:
+	case FS_IOC_GET_ENCRYPTION_POLICY:
 	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
 	case FS_IOC_ADD_ENCRYPTION_KEY:
 	case FS_IOC_REMOVE_ENCRYPTION_KEY:
@@ -1377,8 +1377,8 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC_CLEAR_ES_CACHE:
 	case EXT4_IOC_GETSTATE:
 	case EXT4_IOC_GET_ES_CACHE:
-	case EXT4_IOC_FSGETXATTR:
-	case EXT4_IOC_FSSETXATTR:
+	case FS_IOC_FSGETXATTR:
+	case FS_IOC_FSSETXATTR:
 		break;
 	default:
 		return -ENOIOCTLCMD;
-- 
2.27.0

