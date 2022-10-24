Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF9E160BFC8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 02:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbiJYAma (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Oct 2022 20:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiJYAmO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Oct 2022 20:42:14 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA532BC870;
        Mon, 24 Oct 2022 16:13:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7E3F4811D7;
        Mon, 24 Oct 2022 19:13:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666653220; bh=m68pzGpTBuRr0q39jXG75JcKJtUdtM4aUKLmegEGH3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kDk6qi/b+yZzZrcaVZK8K3uONtC7gEVZabCVWokAvQLYqYkahy+AG0KYNzPSnhksP
         mxfBX7bpSQ/LM/LX+bxI+3QJdGWrSQhYoDBBLA7lvUQoHWJaaAf7I8zYAIZD8DNY2u
         v/EQVkaq2qqtvoo85ydydLtnzCIxb8hHlJMJM91amc3ru/9HfXgWcrNdkNt/vOQJM2
         M270e/es9f2ZSg9i570yv1t49FJIa8Tb0nWel3rF1vxsIjFpX8Rqau39xL8Lqb1/Oj
         V6EydICY/27odb7+nhM+zkYO2idkaD/rOr267abF1WCqPtj7v7JcjL7WRwpfb9dYkB
         l2vM1DO3A1XAg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 02/21] fscrypt: add fscrypt_have_same_policy() to check inode compatibility
Date:   Mon, 24 Oct 2022 19:13:12 -0400
Message-Id: <aa40bc0b110601d20cd49e1db1d2435d07da26b2.1666651724.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666651724.git.sweettea-kernel@dorminy.me>
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

Btrfs will need to check whether inode policies are identical for
various purposes: if two inodes want to share an extent, they must have
the same policy, including key identifier; symlinks must not span the
encrypted/unencrypted border; and certain encryption policies will allow
btrfs to store one fscrypt_context for multiple objects. Therefore, add
a function which allows checking the encryption policies of two inodes
to ensure they are identical.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/policy.c      | 26 ++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 2 files changed, 33 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 46757c3052ef..b7c4820a8001 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -415,6 +415,32 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
 	return fscrypt_policy_from_context(policy, &ctx, ret);
 }
 
+/**
+ * fscrypt_have_same_policy() - check whether two inodes have the same policy
+ * @inode1: the first inode
+ * @inode2: the second inode
+ *
+ * Return: %true if they are definitely equal, else %false
+ */
+int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2)
+{
+	union fscrypt_policy policy1, policy2;
+	int err;
+
+	if (!IS_ENCRYPTED(inode1) && !IS_ENCRYPTED(inode2))
+		return true;
+	else if (!IS_ENCRYPTED(inode1) || !IS_ENCRYPTED(inode2))
+		return false;
+	err = fscrypt_get_policy(inode1, &policy1);
+	if (err)
+		return false;
+	err = fscrypt_get_policy(inode2, &policy2);
+	if (err)
+		return false;
+	return fscrypt_policies_equal(&policy1, &policy2);
+}
+EXPORT_SYMBOL(fscrypt_have_same_policy);
+
 static int set_encryption_policy(struct inode *inode,
 				 const union fscrypt_policy *policy)
 {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4cdff7c15544..9cc5a61c1200 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -313,6 +313,7 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 void fscrypt_free_bounce_page(struct page *bounce_page);
 
 /* policy.c */
+int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2);
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
 int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
@@ -490,6 +491,12 @@ static inline void fscrypt_free_bounce_page(struct page *bounce_page)
 }
 
 /* policy.c */
+static inline int fscrypt_have_same_policy(struct inode *inode1,
+					   struct inode *inode2)
+{
+	return 1;
+}
+
 static inline int fscrypt_ioctl_set_policy(struct file *filp,
 					   const void __user *arg)
 {
-- 
2.35.1

