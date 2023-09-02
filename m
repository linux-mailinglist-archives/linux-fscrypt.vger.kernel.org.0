Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3946F790570
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351630AbjIBF4N (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbjIBF4M (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:12 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9038F10F4;
        Fri,  1 Sep 2023 22:56:09 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BC5C5803B3;
        Sat,  2 Sep 2023 01:56:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634169; bh=4enh47oqQtM1rvRngoxnIU28aYTtdxzrlpSxtwxTslU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4rbM3c56HkL7S2O0KF2bSJzJsctRFU/Gw19CvWZgm63Iahwa+ddzKIBBKCzBW6a8
         aHaBod9P21LhDqZlyRroI8woDMdiuXoS84Y0Ho5jdjmG88rNxi3+x5LrzoyOm19qg6
         egCqdidV1sr2HRUdvwz4SqixdhidAzwf2QHQ0D4TR1rmQAUbbV5K9IAAnHONYEjuEA
         csakQxBm6RuuwD6VkZU+cQhXVga/sNhfunsvpK40anxJomzmX293MlUcd+nd4ouwiS
         t8UGa4FP4WvU1LPx0CozMMFN8FiKtnE24jfTpJt/vbq9zplqF6Sno9ng+n+DiRQwAw
         fiWqTLQYw7gWg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 10/13] fscrypt: allow multiple extents to reference one info
Date:   Sat,  2 Sep 2023 01:54:28 -0400
Message-ID: <1a4861d291e08233a0f16b482af562d4fcb2caf1.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs occasionally splits in-memory extents while holding a mutex. This
means we can't just copy the info, since setting up a new inlinecrypt
key requires taking a semaphore. Thus adding a mechanism to split
extents and merely take a new reference on the info is necessary.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  5 +++++
 fs/crypto/keysetup.c        | 19 ++++++++++++++++++-
 include/linux/fscrypt.h     |  2 +-
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index dd7740105264..cf1eb7fe546f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -307,6 +307,11 @@ struct fscrypt_info {
  */
 struct fscrypt_extent_info {
 	struct fscrypt_common_info info;
+
+	/* Reference count. Normally 1, unless a extent info is shared by
+	 * several virtual extents.
+	 */
+	refcount_t refs;
 };
 
 typedef enum {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 34d4df4acb19..f0f70b888bd8 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -919,6 +919,21 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
 
+/**
+ * fscrypt_get_extent_info_ref() - mark a second extent using the same info
+ * @info: the info to be used by another extent
+ *
+ * Sometimes, an existing extent must be split into multiple extents in memory.
+ * In such a case, this function allows multiple extents to use the same extent
+ * info without allocating or taking any lock, which is necessary in certain IO
+ * paths.
+ */
+void fscrypt_get_extent_info_ref(struct fscrypt_extent_info *info)
+{
+	if (info)
+		refcount_inc(&info->refs);
+}
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
@@ -997,7 +1012,7 @@ EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
 
 static void put_crypt_extent_info(struct fscrypt_extent_info *ci)
 {
-	if (!ci)
+	if (!ci || !refcount_dec_and_test(&ci->refs))
 		return;
 
 	free_prepared_key(&ci->info);
@@ -1042,6 +1057,8 @@ fscrypt_setup_extent_info(struct inode *inode,
 	if (res)
 		goto out;
 
+	refcount_set(&crypt_extent_info->refs, 1);
+
 	*info_ptr = crypt_extent_info;
 	add_info_to_mk_decrypted_list(crypt_info, mk);
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index b57fc5645076..577f9e0a6e97 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -362,7 +362,7 @@ int fscrypt_prepare_new_extent(struct inode *inode,
 void fscrypt_free_extent_info(struct fscrypt_extent_info **info_ptr);
 int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
 			     struct fscrypt_extent_info **info_ptr);
-
+void fscrypt_get_extent_info_ref(struct fscrypt_extent_info *info);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
-- 
2.41.0

