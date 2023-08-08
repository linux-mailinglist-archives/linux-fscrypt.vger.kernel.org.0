Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1DB7743B3
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjHHSIV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjHHSH6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:58 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB34A7AB;
        Tue,  8 Aug 2023 10:08:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 665A083548;
        Tue,  8 Aug 2023 13:08:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514528; bh=Epty68b+w8wZKhrQqqPg88yNrPvpeNikltq+NN0Z/+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bn/e8kTFFt4qaUKGuHYO6S/0ynZL5nYfkl+/nI9ga6XNTvzNnSVwgWIm6Yf650sz6
         2j48R5flz6y6kti2Rr9BUIqgZQY8LuerNqBFEOuTdm/6Lxp6zShCwOjnAoTaTUh/WG
         3oTbfuqCBbnDLT1zPJgppWF0BEdZjp/ej9j3U028yfwOPEpQxH9WmxfTnFKIYru5Cc
         UovZGzlsUHonV1XU9pU4RqK1hRdqufeloxSlPVi+GlLl+eYImVsFBESzjUyqFPgO5j
         MdF/9r/cm6LZVg1Zt8nQ6P/PhzV4PfgRLLnNIS3c5+r4L7RVhcor4pS7OgPqbhjc74
         HRZhlnseIKk2g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 05/16] fscrypt: setup leaf inodes for extent encryption
Date:   Tue,  8 Aug 2023 13:08:22 -0400
Message-ID: <7db769e801bc4a2b9ff935d76bc83cf3c1232235.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For extent-based encryption, leaf/regular file inodes are special: it's
useful to set their i_crypt_info field so that it's easy to inherit
their encryption policy for a new extent, but they never need to do any
encyption themselves. Additionally, since encryption can only be set up
on a directory, not a single file, their encryption policy can always
duplicate their parent inode's policy.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 17 +++++++++++
 fs/crypto/keysetup.c        | 60 ++++++++++++++++++++++++++++---------
 2 files changed, 63 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8a6e359f96cf..df1c5ae82d85 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -308,6 +308,23 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
 	return inode->i_crypt_info;
 }
 
+/**
+ * fscrypt_uses_extent_encryption() -- whether an inode uses per-extent
+ *				       encryption
+ *
+ * @inode: the inode in question
+ *
+ * Return: true if the inode uses per-extent fscrypt_infos, false otherwise
+ */
+static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
+{
+	/* Non-regular files don't have extents */
+	if (!S_ISREG(inode->i_mode))
+		return false;
+
+	/* No filesystems currently use per-extent infos */
+	return false;
+}
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c5f68cf65a6f..9b3806ab7ccb 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -726,6 +726,26 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	return res;
 }
 
+static bool get_parent_policy_and_nonce(struct inode *inode,
+					union fscrypt_policy *policy,
+					u8 *nonce)
+{
+	struct dentry *dentry = d_find_any_alias(inode);
+	struct dentry *parent_dentry = dget_parent(dentry);
+	struct inode *dir = parent_dentry->d_inode;
+	bool found = false;
+
+	if (dir->i_crypt_info) {
+		found = true;
+		*policy = dir->i_crypt_info->ci_policy;
+		memcpy(nonce, dir->i_crypt_info->ci_nonce,
+		       FSCRYPT_FILE_NONCE_SIZE);
+	}
+	dput(parent_dentry);
+	dput(dentry);
+	return found;
+}
+
 /**
  * fscrypt_get_encryption_info() - set up an inode's encryption key
  * @inode: the inode to set up the key for.  Must be encrypted.
@@ -747,27 +767,39 @@ fscrypt_setup_encryption_info(struct inode *inode,
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 {
 	int res;
-	union fscrypt_context ctx;
+	union fscrypt_context ctx = { 0 };
 	union fscrypt_policy policy;
+	const u8 *nonce;
+	u8 nonce_bytes[FSCRYPT_FILE_NONCE_SIZE];
 
 	if (fscrypt_has_encryption_key(inode))
 		return 0;
 
-	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res < 0) {
-		if (res == -ERANGE && allow_unsupported)
+	if (fscrypt_uses_extent_encryption(inode)) {
+		/*
+		 * Nothing will be encrypted with this info, so we can borrow
+		 * the parent (dir) inode's policy and use a zero nonce.
+		 */
+		if (!get_parent_policy_and_nonce(inode, &policy, nonce_bytes))
 			return 0;
-		fscrypt_warn(inode, "Error %d getting encryption context", res);
-		return res;
-	}
+		nonce = nonce_bytes;
+	} else {
+		res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+		if (res < 0) {
+			if (res == -ERANGE && allow_unsupported)
+				return 0;
+			fscrypt_warn(inode, "Error %d getting encryption context", res);
+			return res;
+		}
 
-	res = fscrypt_policy_from_context(&policy, &ctx, res);
-	if (res) {
-		if (allow_unsupported)
-			return 0;
-		fscrypt_warn(inode,
-			     "Unrecognized or corrupt encryption context");
-		return res;
+		res = fscrypt_policy_from_context(&policy, &ctx, res);
+		if (res) {
+			if (allow_unsupported)
+				return 0;
+			fscrypt_warn(inode,
+				     "Unrecognized or corrupt encryption context");
+			return res;
+		}
 	}
 
 	if (!fscrypt_supported_policy(&policy, inode)) {
-- 
2.41.0

