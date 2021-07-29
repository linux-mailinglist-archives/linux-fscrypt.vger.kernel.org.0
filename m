Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C7C3D9CD8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jul 2021 06:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhG2Ejx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jul 2021 00:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233540AbhG2Ejw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jul 2021 00:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24D15604DB;
        Thu, 29 Jul 2021 04:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627533590;
        bh=Py7uHiYvnpaO5x3vt7x+I4Cdzj8pn/J9hAojlQsYNqg=;
        h=From:To:Cc:Subject:Date:From;
        b=Nm4e/Q5NpXZIm8u/BrvQEem3BHJyQgpKF82jQaxsZDTY/c2kOFyFCHPDtavaJlJOm
         +/TeEJdbV944g4NPbg0dfCIDH4vxgPBO+5vfnJWgd2QWYvN/Wkp0apuOJQcmAUeswq
         5TfYmqhfCdJxreb8LJADIB7AuHO3QpuQdkqyUUhq4nFPoP+QaaMc87cc2rBogCAf4A
         bhNS7B3RQnZXgKYGHHDWCGKB18VEhkW78dA958QrIK/LGxNzPWx0bDRRCKWNEf3f5q
         AfskjGmGzdUo1BtsEnAD5mCsPVDqcoEe12Tkbhc4zRTicnWu6Xs6ji9sJ2maIEdXTb
         oL4oDAJO0UMtg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Jeff Layton <jlayton@kernel.org>
Subject: [PATCH] fscrypt: document struct fscrypt_operations
Date:   Wed, 28 Jul 2021 21:37:28 -0700
Message-Id: <20210729043728.18480-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Document all fields of struct fscrypt_operations so that it's more clear
what filesystems that use (or plan to use) fs/crypto/ need to implement.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/linux/fscrypt.h | 109 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 105 insertions(+), 4 deletions(-)

diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index b7bfd0cd4f3e..e912ed9141d9 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -47,27 +47,128 @@ struct fscrypt_name {
 #define FSCRYPT_SET_CONTEXT_MAX_SIZE	40
 
 #ifdef CONFIG_FS_ENCRYPTION
+
 /*
- * fscrypt superblock flags
+ * If set, the fscrypt bounce page pool won't be allocated (unless another
+ * filesystem needs it).  Set this if the filesystem always uses its own bounce
+ * pages for writes and therefore won't need the fscrypt bounce page pool.
  */
 #define FS_CFLG_OWN_PAGES (1U << 1)
 
-/*
- * crypto operations for filesystems
- */
+/* Crypto operations for filesystems */
 struct fscrypt_operations {
+
+	/* Set of optional flags; see above for allowed flags */
 	unsigned int flags;
+
+	/*
+	 * If set, this is a filesystem-specific key description prefix that
+	 * will be accepted for "logon" keys for v1 fscrypt policies, in
+	 * addition to the generic prefix "fscrypt:".  This functionality is
+	 * deprecated, so new filesystems shouldn't set this field.
+	 */
 	const char *key_prefix;
+
+	/*
+	 * Get the fscrypt context of the given inode.
+	 *
+	 * @inode: the inode whose context to get
+	 * @ctx: the buffer into which to get the context
+	 * @len: length of the @ctx buffer in bytes
+	 *
+	 * Return: On success, returns the length of the context in bytes; this
+	 *	   may be less than @len.  On failure, returns -ENODATA if the
+	 *	   inode doesn't have a context, -ERANGE if the context is
+	 *	   longer than @len, or another -errno code.
+	 */
 	int (*get_context)(struct inode *inode, void *ctx, size_t len);
+
+	/*
+	 * Set an fscrypt context on the given inode.
+	 *
+	 * @inode: the inode whose context to set.  The inode won't already have
+	 *	   an fscrypt context.
+	 * @ctx: the context to set
+	 * @len: length of @ctx in bytes (at most FSCRYPT_SET_CONTEXT_MAX_SIZE)
+	 * @fs_data: If called from fscrypt_set_context(), this will be the
+	 *	     value the filesystem passed to fscrypt_set_context().
+	 *	     Otherwise (i.e. when called from
+	 *	     FS_IOC_SET_ENCRYPTION_POLICY) this will be NULL.
+	 *
+	 * i_rwsem will be held for write.
+	 *
+	 * Return: 0 on success, -errno on failure.
+	 */
 	int (*set_context)(struct inode *inode, const void *ctx, size_t len,
 			   void *fs_data);
+
+	/*
+	 * Get the dummy fscrypt policy in use on the filesystem (if any).
+	 *
+	 * Filesystems only need to implement this function if they support the
+	 * test_dummy_encryption mount option.
+	 *
+	 * Return: A pointer to the dummy fscrypt policy, if the filesystem is
+	 *	   mounted with test_dummy_encryption; otherwise NULL.
+	 */
 	const union fscrypt_policy *(*get_dummy_policy)(struct super_block *sb);
+
+	/*
+	 * Check whether a directory is empty.  i_rwsem will be held for write.
+	 */
 	bool (*empty_dir)(struct inode *inode);
+
+	/* The filesystem's maximum ciphertext filename length, in bytes */
 	unsigned int max_namelen;
+
+	/*
+	 * Check whether the filesystem's inode numbers and UUID are stable,
+	 * meaning that they will never be changed even by offline operations
+	 * such as filesystem shrinking and therefore can be used in the
+	 * encryption without the possibility of files becoming unreadable.
+	 *
+	 * Filesystems only need to implement this function if they want to
+	 * support the FSCRYPT_POLICY_FLAG_IV_INO_LBLK_{32,64} flags.  These
+	 * flags are designed to work around the limitations of UFS and eMMC
+	 * inline crypto hardware, and they shouldn't be used in scenarios where
+	 * such hardware isn't being used.
+	 *
+	 * Leaving this NULL is equivalent to always returning false.
+	 */
 	bool (*has_stable_inodes)(struct super_block *sb);
+
+	/*
+	 * Get the number of bits that the filesystem uses to represent inode
+	 * numbers and file logical block numbers.
+	 *
+	 * By default, both of these are assumed to be 64-bit.  This function
+	 * can be implemented to declare that either or both of these numbers is
+	 * shorter, which may allow the use of the
+	 * FSCRYPT_POLICY_FLAG_IV_INO_LBLK_{32,64} flags and/or the use of
+	 * inline crypto hardware whose maximum DUN length is less than 64 bits
+	 * (e.g., eMMC v5.2 spec compliant hardware).  This function only needs
+	 * to be implemented if support for one of these features is needed.
+	 */
 	void (*get_ino_and_lblk_bits)(struct super_block *sb,
 				      int *ino_bits_ret, int *lblk_bits_ret);
+
+	/*
+	 * Return the number of block devices to which the filesystem may write
+	 * encrypted file contents.
+	 *
+	 * If the filesystem can use multiple block devices (other than block
+	 * devices that aren't used for encrypted file contents, such as
+	 * external journal devices), and wants to support inline encryption,
+	 * then it must implement this function.  Otherwise it's not needed.
+	 */
 	int (*get_num_devices)(struct super_block *sb);
+
+	/*
+	 * If ->get_num_devices() returns a value greater than 1, then this
+	 * function is called to get the array of request_queues that the
+	 * filesystem is using -- one per block device.  (There may be duplicate
+	 * entries in this array, as block devices can share a request_queue.)
+	 */
 	void (*get_devices)(struct super_block *sb,
 			    struct request_queue **devs);
 };
-- 
2.32.0

