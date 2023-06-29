Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D24741CFA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjF2Ael (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjF2Aej (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:34:39 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DC11FC2;
        Wed, 28 Jun 2023 17:34:38 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1E1EF80B08;
        Wed, 28 Jun 2023 20:34:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998878; bh=5QOeWXF39VG4eTOdkVZEzpQcyOFLzHDC+snBZKaf5vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qz3y1jbr7rfKdbz22l4cCQWgjmgFBX0CjK2Wx+TiPKLUQwM5Kz8gAUVznKEN0Guej
         8qlWr1yoaVcPGhfJ6lOWx2F5G6SnmYj57OYQdAJh9RpmUQCkMZgL01augb2o/3nuw7
         g1KCNZppaQ1YHacRPDo9FMb2eGzxLA0Wgmm1P/D18dkS/n12jfpsZRtdhsNZz/v2/f
         /VVpwGkTJIDPGFh+jv1UQjpLUFlZNMokvrvrNljMttqmffeOaqr7RIGYsKfse541sM
         Av137LjSOtpZEuJ7hEaEGxsGL+KCEOxczPFxGRKDJiDNN23ISw0XCD6lQgjEQQ0f+1
         rYYbuz+Ad/qvw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 05/12] fscrypt: setup leaf inodes for extent encryption
Date:   Wed, 28 Jun 2023 20:29:35 -0400
Message-Id: <703b51d9bd9897ddb0b290e24a1260647c96eb6f.1687988246.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988246.git.sweettea-kernel@dorminy.me>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
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

For extent-based encryption, leaf/regular file inodes are special: it's
useful to set their i_crypt_info field so that it's easy to inherit
their encryption policy for a new extent, but they never need to do any
encyption themselves. Additionally, since encryption can only be set up
on a directory, not a single file, their encryption policy can always
duplicate their parent inode's policy.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 17 +++++++++++++
 fs/crypto/keysetup.c        | 49 ++++++++++++++++++++++++++-----------
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index c04454c289fd..260635e8b558 100644
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
+	// Non-regular files don't have extents
+	if (!S_ISREG(inode->i_mode))
+		return false;
+
+	// No filesystems currently use per-extent infos
+	return false;
+}
 
 /* crypto.c */
 extern struct kmem_cache *fscrypt_info_cachep;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 67a5749a9543..d79a42a54906 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -747,27 +747,48 @@ fscrypt_setup_encryption_info(struct inode *inode,
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 {
 	int res;
-	union fscrypt_context ctx;
+	union fscrypt_context ctx = { 0 };
 	union fscrypt_policy policy;
 
 	if (fscrypt_has_encryption_key(inode))
 		return 0;
 
-	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
-	if (res < 0) {
-		if (res == -ERANGE && allow_unsupported)
-			return 0;
-		fscrypt_warn(inode, "Error %d getting encryption context", res);
-		return res;
-	}
+	if (fscrypt_uses_extent_encryption(inode)) {
+		/*
+		 * Nothing will be encrypted with this info, so we can borrow
+		 * the parent (dir) inode's policy and use a zero nonce.
+		 */
+		struct dentry *dentry = d_find_any_alias(inode);
+		struct dentry *parent_dentry = dget_parent(dentry);
+		struct inode *dir = parent_dentry->d_inode;
+		bool found = false;
 
-	res = fscrypt_policy_from_context(&policy, &ctx, res);
-	if (res) {
-		if (allow_unsupported)
+		if (dir->i_crypt_info) {
+			found = true;
+			policy = dir->i_crypt_info->ci_policy;
+			nonce = dir->i_crypt_info->ci_nonce;
+		}
+		dput(parent_dentry);
+		dput(dentry);
+		if (!found)
 			return 0;
-		fscrypt_warn(inode,
-			     "Unrecognized or corrupt encryption context");
-		return res;
+	} else {
+		res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
+		if (res < 0) {
+			if (res == -ERANGE && allow_unsupported)
+				return 0;
+			fscrypt_warn(inode, "Error %d getting encryption context", res);
+			return res;
+		}
+
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
2.40.1

