Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349726C2433
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 23:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCTWEi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 18:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCTWEh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 18:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C9925BB5;
        Mon, 20 Mar 2023 15:04:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E856184B;
        Mon, 20 Mar 2023 22:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858B8C4339B;
        Mon, 20 Mar 2023 22:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679349859;
        bh=cAslXi62sJIVHd6+NFmaT7Xk8pUs2KN8PuiZHUYjWmc=;
        h=From:To:Cc:Subject:Date:From;
        b=lafm2lGYhwRC1uGENGHfIoN84QFEDrPsWDEHwFvGTaim0Ya7GNqYy4t0cmLoi6pkp
         2KoW+Dztu9BTOPTKvU+hW69BamHDgADsgrIIrzo33WUsKGaOwLRWf3VcxVt9j1yLiW
         ot2GK+afQnSgGkawNRwtB+kzmaBZZM2Z1h8ggNi1YivI7eT3t/msztb2FMu4AIs7Wq
         2oUXcziEI3M06DFQ/2sdspH0cBIxSLNCymdkzFJGb9sCmxbHGvk3g8+zitm5MrIVjf
         5ya8Cyp+UIPCpAOPGIrXwC2d5vpKxwGRPPiy/eH+BSwFoGO+W2zR66Eq6kzYKK/P7Z
         o5X8IAR78/4+A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ceph-devel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH v4] fscrypt: new helper function - fscrypt_prepare_lookup_partial()
Date:   Mon, 20 Mar 2023 15:01:49 -0700
Message-Id: <20230320220149.21863-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

This patch introduces a new helper function which can be used both in
lookups and in atomic_open operations by filesystems that want to handle
filename encryption and no-key dentries themselves.

The reason for this function to be used in atomic open is that this
operation can act as a lookup if handed a dentry that is negative.  And in
this case we may need to set DCACHE_NOKEY_NAME.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
Tested-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
[ebiggers: improved the function comment, and moved the function to just
           below __fscrypt_prepare_lookup()]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c       | 30 ++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b58..9151934c50866 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -111,6 +111,36 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
 
+/**
+ * fscrypt_prepare_lookup_partial() - prepare lookup without filename setup
+ * @dir: the encrypted directory being searched
+ * @dentry: the dentry being looked up in @dir
+ *
+ * This function should be used by the ->lookup and ->atomic_open methods of
+ * filesystems that handle filename encryption and no-key name encoding
+ * themselves and thus can't use fscrypt_prepare_lookup().  Like
+ * fscrypt_prepare_lookup(), this will try to set up the directory's encryption
+ * key and will set DCACHE_NOKEY_NAME on the dentry if the key is unavailable.
+ * However, this function doesn't set up a struct fscrypt_name for the filename.
+ *
+ * Return: 0 on success; -errno on error.  Note that the encryption key being
+ *	   unavailable is not considered an error.  It is also not an error if
+ *	   the encryption policy is unsupported by this kernel; that is treated
+ *	   like the key being unavailable, so that files can still be deleted.
+ */
+int fscrypt_prepare_lookup_partial(struct inode *dir, struct dentry *dentry)
+{
+	int err = fscrypt_get_encryption_info(dir, true);
+
+	if (!err && !fscrypt_has_encryption_key(dir)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_NOKEY_NAME;
+		spin_unlock(&dentry->d_lock);
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_lookup_partial);
+
 int __fscrypt_prepare_readdir(struct inode *dir)
 {
 	return fscrypt_get_encryption_info(dir, true);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e0a49c3125ebc..a69f1302051d3 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -359,6 +359,7 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 			     unsigned int flags);
 int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 			     struct fscrypt_name *fname);
+int fscrypt_prepare_lookup_partial(struct inode *dir, struct dentry *dentry);
 int __fscrypt_prepare_readdir(struct inode *dir);
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 int fscrypt_prepare_setflags(struct inode *inode,
@@ -673,6 +674,12 @@ static inline int __fscrypt_prepare_lookup(struct inode *dir,
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_prepare_lookup_partial(struct inode *dir,
+						 struct dentry *dentry)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __fscrypt_prepare_readdir(struct inode *dir)
 {
 	return -EOPNOTSUPP;
-- 
2.40.0

