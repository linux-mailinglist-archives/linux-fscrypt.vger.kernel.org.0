Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225895971E9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237192AbiHQOum (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240255AbiHQOuZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:25 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206D61C907;
        Wed, 17 Aug 2022 07:50:25 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 70BAC81140;
        Wed, 17 Aug 2022 10:50:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747824; bh=yY8S8o2qAHPyyq6T2MD0XGq4HDMU4SIfT6mesD4Qhxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQ7CUKaB/iRTBvh5tCjoqJzFft0Lbc/6QdGSvVJDRzz2ljnOtChqBSa9mkZqb2zyO
         hBV74jIWJs5ByMqDaXymG7uos0dt4sSciylsm96VG3siHitb9hrH0Vj17knacwo5fT
         7Sb5CmETuR17cvM9ehvD511dytd3G6w/uYZrcfdcraSfQaFJcbDv7Qno0whRwiGn76
         vrVRETyYAvjKxUyV8TqRXJo9VJ3hVGKdtfV6qhHP9irkP8nsxtxLH1A+QjgnVZ7uk+
         BwUdxKeQtVHXtc7syWcIBhyUb+C8GBLPNSdUbwvqb2vei7DHlARDtfTE2arexfWULb
         WLxBxkujxqOmA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 03/21] fscrypt: add fscrypt_have_same_policy() to check inode's compatibility
Date:   Wed, 17 Aug 2022 10:49:47 -0400
Message-Id: <0930fb773bcf56f8aacd079ec86a264cc746628a.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

btrfs will have the possibility of encrypted and unencrypted files in
the same directory, and it's important to not allow these two files to
become linked together. Therefore, add a function which allows checking
the encryption policies of two inodes to ensure they are compatible.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/policy.c      | 26 ++++++++++++++++++++++++++
 include/linux/fscrypt.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 5f858cee1e3b..5763462af9e8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -407,6 +407,32 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
 	return fscrypt_policy_from_context(policy, &ctx, ret);
 }
 
+/**
+ * fscrypt_have_same_policy() - check whether two inodes have the same policy
+ * @inode1: the first inode
+ * @inode2: the second inode
+ *
+ * Return: %true if equal, else %false
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
+		return err;
+	err = fscrypt_get_policy(inode2, &policy2);
+	if (err)
+		return err;
+	return fscrypt_policies_equal(&policy1, &policy2);
+}
+EXPORT_SYMBOL(fscrypt_have_same_policy);
+
 static int set_encryption_policy(struct inode *inode,
 				 const union fscrypt_policy *policy)
 {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index fb48961c46f6..1686b25f6d9c 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -318,6 +318,7 @@ static inline struct page *fscrypt_pagecache_page(struct page *bounce_page)
 void fscrypt_free_bounce_page(struct page *bounce_page);
 
 /* policy.c */
+int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2);
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg);
 int fscrypt_ioctl_get_policy(struct file *filp, void __user *arg);
 int fscrypt_ioctl_get_policy_ex(struct file *filp, void __user *arg);
-- 
2.35.1

