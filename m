Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8EF65A905
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjAAFN6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbjAAFNt (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:49 -0500
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063976411
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:47 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id F3D288261F;
        Sun,  1 Jan 2023 00:06:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549599; bh=BK2x5JjPz2d/0HlcZ+8yzxCScpwOk36OlzpYONoG0DI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vS87mZIMAShTDrjR2xqGIL0SCNrvS1G6oE/nQp+vFRr7u0ENVI/SEqAWbrGnl2RQp
         cJNiaZGvrUT/d8bFiWCGyiXx2mc6yu1kUgPyw3EdkDAdUuBP+BkEmY/lV1raoWWG8u
         f4rOFyHiDC331id+1Y3/wDI0M6W0HM9SRrX9fDh0JmyyI280ou0EqcgmpyXObCRNaF
         cC12yWFVYRRnNap6WjW7fX/9ybaqqF9tRkuohZm2d4jE9ysIRPjKNiuKyS7xz4j+yS
         vPnASvibitHAP86lEZ8EvaSLrVPIwqnryaWRBmg7KyZDV2SYALZCaeSJ6YBeRNabkC
         dngzRVDSbMluQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 05/17] fscrypt: use parent dir's info for extent-based encryption.
Date:   Sun,  1 Jan 2023 00:06:09 -0500
Message-Id: <d145985930958d2c15955438af7468276547d2d3.1672547582.git.sweettea-kernel@dorminy.me>
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

For regular files in filesystems using extent-based encryption, the
corresponding inode does
not need a fscrypt_info structure of its own as for inode-based fscrypt, as they will not be
encrypting anything using it. Any new extents written to the inode will
use a per-extent info structure derived from the inode's parent
directory's info structure. However, it is convenient to cache that
parent directory's info structure in the inode; it makes it easy to
check whether the parents' info exists, so that we don't have to get and
put a reference to the parent inode every time we want to get the inode
info. So do that.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 18 ++++++++++++++++++
 fs/crypto/keysetup.c        | 27 ++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2df28c6fe558..e4c9c483114f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -262,6 +262,24 @@ typedef enum {
 	FS_ENCRYPT,
 } fscrypt_direction_t;
 
+/**
+ * fscrypt_uses_extent_encryption() -- whether an inode uses per-extent
+ *                                     encryption
+ *
+ * @param inode	 the inode in question
+ *
+ * Return: true if the inode uses per-extent encryption infos, false otherwise
+ */
+static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
+{
+	// Non-regular files don't have extents
+	if (!S_ISREG(inode->i_mode))
+		return false;
+
+	// No filesystem currently uses per-extent infos
+	return false;
+}
+
 /**
  * fscrypt_get_inode_info() - get the fscrypt_info for a particular inode
  *
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 4d7ff8244c55..52244e0dd1e4 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -622,6 +622,22 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 	if (fscrypt_has_encryption_key(inode))
 		return 0;
 
+	if (fscrypt_uses_extent_encryption(inode)) {
+		struct dentry *dentry = d_find_any_alias(inode);
+		struct dentry *parent_dentry = dget_parent(dentry);
+		struct inode *dir = parent_dentry->d_inode;
+		struct fscrypt_info *dir_info = fscrypt_get_inode_info(dir);
+		struct fscrypt_master_key *mk = NULL;
+
+		if (dir_info)
+			mk = dir_info->ci_master_key;
+
+		fscrypt_set_inode_info(inode, dir_info, mk);
+		dput(parent_dentry);
+		dput(dentry);
+		return 0;
+	}
+
 	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
 	if (res < 0) {
 		if (res == -ERANGE && allow_unsupported)
@@ -704,6 +720,14 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 
 	*encrypt_ret = true;
 
+	if (fscrypt_uses_extent_encryption(inode)) {
+		struct fscrypt_info *dir_info = fscrypt_get_inode_info(dir);
+
+		fscrypt_set_inode_info(inode, dir_info,
+				       dir_info->ci_master_key);
+		return 0;
+	}
+
 	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
 	return fscrypt_setup_encryption_info(inode, policy, nonce,
 					     IS_CASEFOLDED(dir) &&
@@ -720,7 +744,8 @@ EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
  */
 void fscrypt_put_encryption_info(struct inode *inode)
 {
-	put_crypt_info(fscrypt_get_inode_info(inode));
+	if (!fscrypt_uses_extent_encryption(inode))
+		put_crypt_info(fscrypt_get_inode_info(inode));
 	fscrypt_set_inode_info(inode, NULL, NULL);
 }
 EXPORT_SYMBOL(fscrypt_put_encryption_info);
-- 
2.38.1

