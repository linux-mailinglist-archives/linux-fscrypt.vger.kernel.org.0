Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A589616217
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiKBLxQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiKBLxP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:15 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297FE28714;
        Wed,  2 Nov 2022 04:53:14 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 989F68146E;
        Wed,  2 Nov 2022 07:53:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667389993; bh=ikGo+VvZ8X13dvcigfL01v7Xa1i4xUOngR+ezlUxGAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBKuGEIhHJ3DSqyy9WBF/ZkHB9PPd/fznxQOabOcP33e9+84ZdTgymVtDaKZdGhes
         6z/U5jYorIF7hhmTvtjXWrtBWM/X9JeSvdQ1295i1/wQkVzpUEB9D6Esfl0n3bJinX
         TnYJFqhkfPLB5BhEXAH7VG7qK8sgjdSOrdiC5Qdxawnrqr6C4zpMs6V26E9WFlYRJv
         5vsMkxYeyEc75ZcPhcNMwVut8lPj6wJSERdJC87ElUeTgAJhqsOld3N30+bnMeNkim
         02zM8tVvbm7I09lpg20/H0H2AIQOks2Ljl7OW/Gj3DNLBZuyQFVY4srRs9p6IdC0Qu
         9LTHPV/W7asBw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 02/18] fscrypt: add fscrypt_have_same_policy() to check inode compatibility
Date:   Wed,  2 Nov 2022 07:52:51 -0400
Message-Id: <0c9c616c46ae86e51d153316d55918eac74b83ad.1667389115.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
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
 fs/crypto/policy.c      | 35 +++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  8 ++++++++
 2 files changed, 43 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 46757c3052ef..715870d4e530 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -415,6 +415,41 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
 	return fscrypt_policy_from_context(policy, &ctx, ret);
 }
 
+/**
+ * fscrypt_have_same_policy() - check whether two inodes have the same policy
+ * @inode1: the first inode
+ * @inode2: the second inode
+ * @same_ptr: a pointer to return whether they are the same
+ *
+ * Return: 0 or an error code.
+ */
+int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2,
+			     bool *same_ptr)
+{
+	union fscrypt_policy policy1, policy2;
+	int err;
+
+	if (!IS_ENCRYPTED(inode1) && !IS_ENCRYPTED(inode2)) {
+		*same_ptr = true;
+		return 0;
+	}
+	if (!IS_ENCRYPTED(inode1) || !IS_ENCRYPTED(inode2)) {
+		*same_ptr = false;
+		return 0;
+	}
+
+	err = fscrypt_get_policy(inode1, &policy1);
+	if (err)
+		return err;
+	err = fscrypt_get_policy(inode2, &policy2);
+	if (err)
+		return err;
+
+	*same_ptr = fscrypt_policies_equal(&policy1, &policy2);
+	return 0;
+}
+EXPORT_SYMBOL(fscrypt_have_same_policy);
+
 static int set_encryption_policy(struct inode *inode,
 				 const union fscrypt_policy *policy)
 {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 7661db0b5bec..0069f92ee3da 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -313,6 +313,8 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 void fscrypt_free_bounce_page(struct page *bounce_page);
 
 /* policy.c */
+int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2,
+			     bool *same_ptr);
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
 int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
@@ -490,6 +492,12 @@ static inline void fscrypt_free_bounce_page(struct page *bounce_page)
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
2.37.3

