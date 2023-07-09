Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D77374C796
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjGISyA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjGISx7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:59 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCDB128;
        Sun,  9 Jul 2023 11:53:58 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EA06280B12;
        Sun,  9 Jul 2023 14:53:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928838; bh=oOvzWavp9q8pjjvCmgnJz1nKe1na598tMbJz3v9zZrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kR2JFeOI/qtu1iT52/o83iGZAn4zwZgCuQBYx3YHewzVICNStxNSr2JrR44TF2SUE
         mNqsDcPf3KVQiW2ESoZDe2p7G7LPsX/LrNi2FdbRe7JjNDjrPZpE2sYo9D/KrudOHA
         mpb5QhiOihEkbzMwE0ZoTcP3Jc3Xp976NpA4bQdQ0P7WLhIwMSFMRaP+91Uz0+cpSJ
         HkxnvlSSfNLew60tbIO+vJg+5LCXhlCsVo/x50UnH6znmnmK6tTqS5MjDK+oM6HQCS
         LMvWq+jZybZTJS2up4X3cmm9wOcYJtByp5GtAkUvkYkvl8FjKjZtTPsyELeW7b4Agm
         Yb1hR3yN/w+zA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 05/14] fscrypt: setup leaf inodes for extent encryption
Date:   Sun,  9 Jul 2023 14:53:38 -0400
Message-Id: <9a4890026719e5d6dc16ee9338f309f3fa452d16.1688927487.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927487.git.sweettea-kernel@dorminy.me>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index c5f68cf65a6f..7469b2d8ac87 100644
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

