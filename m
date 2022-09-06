Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 663575ADC74
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiIFAfs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiIFAfq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:35:46 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8457267C97;
        Mon,  5 Sep 2022 17:35:45 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E716F81041;
        Mon,  5 Sep 2022 20:35:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424545; bh=31tak+bQ7sOpodTtj1F9GEdWxgKjOvfSzMwGFTIcn7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmowLzgV+u+yd1LjLrWPbLXKZHegJX25ISzMSxcXNcQwWXZiDdTyJETqcxxEGzaoW
         p6QfM9QVZs3V2JWjHGbIkWDDus/hxcnCqBPVnGJvo7d/lrcHb6CYq7C2hy0F1f7kCf
         kNbg08PFe26HCBrESL5k6imDM/WIPU0rlsqsG+7/U817TH4oCSSxmqj+T9zrdmsSFu
         J86IqfDingkEBb0SrwDnxFvhZVaozYqFU+EgqgxW1qPg9k+D76Psl5WKC/CC3JIKNg
         3kPHbTZIfaAIwbwH4/KOjD8/rhQyETRekPRQTDxL2hQ0SGSi5KvpFflPKMw4xACeBC
         D4uS9yIfxgTVg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 03/20] fscrypt: add fscrypt_have_same_policy() to check inode compatibility
Date:   Mon,  5 Sep 2022 20:35:18 -0400
Message-Id: <59fe9cb2916e7bad3bc57abc211a35f0a85990bc.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
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
 include/linux/fscrypt.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 80b8ca0f340b..ed8b7b6531e5 100644
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
index a4e00314c91b..16d2252d5562 100644
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

