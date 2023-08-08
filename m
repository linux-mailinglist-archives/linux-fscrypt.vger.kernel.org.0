Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C377463A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbjHHSy3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjHHSyM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:12 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68D15C7BB;
        Tue,  8 Aug 2023 10:08:59 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 503C083548;
        Tue,  8 Aug 2023 13:08:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514539; bh=O+ozdjMuGyovsvKTmBrvw9gMGe4Wg30O95hUx8UcM0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJ0uwgzZL4nu/U/08WBPCCLT8IePa4qOS0L7fVuiWUEF4QpFk5rtikIKV6UhiOyYv
         NJDznH0Pjs4k0+PWnH4OxFAbMFKiUM8cYnghGHjiVafNsSwRjfgIp/pSDBK7Zq0l2b
         MkPnakOmEWiOewb09HZk5FeZ2/fGz2fq9LHhSPZzzHfBbqCYJ0EVMAEPVJxIh2UPFn
         DZoOTrHoHstPg8gLV4H/DzpaonYXSXbdXXCvbwTsu1ju8VHFm6ZJm8+K8THhkjkHKU
         tW+b4IWMzRz8fg1mispjQ9fbNkH6PZXQYGls6+t5ZuLJve7FQVWK8So1ECnD2XUZN0
         3YyENr5uM3uqA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 13/16] fscrypt: allow multiple extents to reference one info
Date:   Tue,  8 Aug 2023 13:08:30 -0400
Message-ID: <2fc070a3990716077dee122740f21abcea8121a8.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
 fs/crypto/keysetup.c        | 18 +++++++++++++++++-
 include/linux/fscrypt.h     |  2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index cd29c71b4349..03be2c136c0e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -287,6 +287,11 @@ struct fscrypt_info {
 
 	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
 	u32 ci_hashed_ino;
+
+	/* Reference count. Normally 1, unless a extent info is shared by
+	 * several virtual extents.
+	 */
+	refcount_t refs;
 };
 
 typedef enum {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 8d50716bdf11..12c3851b7cd6 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -598,7 +598,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 {
 	struct fscrypt_master_key *mk;
 
-	if (!ci)
+	if (!ci || !refcount_dec_and_test(&ci->refs))
 		return;
 
 	if (ci->ci_enc_key) {
@@ -686,6 +686,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	crypt_info->ci_inode = inode;
 	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
+	refcount_set(&crypt_info->refs, 1);
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
 
 	mode = select_encryption_mode(&crypt_info->ci_policy, inode);
@@ -1046,6 +1047,21 @@ int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
 }
 EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
 
+/**
+ * fscrypt_get_extent_info_ref() - mark a second extent using the same info
+ * @info: the info to be used by another extent
+ *
+ * Sometimes, an existing extent must be split into multiple extents in memory.
+ * In such a case, this function allows multiple extents to use the same extent
+ * info without allocating or taking any lock, which is necessary in certain IO
+ * paths.
+ */
+void fscrypt_get_extent_info_ref(struct fscrypt_info *info)
+{
+	if (info)
+		refcount_inc(&info->refs);
+}
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4ba624beea91..b67054a2c965 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -370,6 +370,8 @@ void fscrypt_free_extent_info(struct fscrypt_info **info_ptr);
 int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
 			     struct fscrypt_info **info_ptr);
 
+void fscrypt_get_extent_info_ref(struct fscrypt_info *info);
+
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen);
-- 
2.41.0

