Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18A5774636
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbjHHSyY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjHHSyG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:06 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F01715C7AB;
        Tue,  8 Aug 2023 10:08:56 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8E1C983545;
        Tue,  8 Aug 2023 13:08:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514536; bh=2ZaZcvfT6uFM7Cddjz5wTfSOll3Q7q+Pkodda/OJVXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CS59DW8dgnl2QJcxT1wvYPH4cgF9BQpn/xf3es2ccHX6kv2xa3TNpZ6fehsy3zuhm
         3DIkUF7E6/RW/6fhoCHOMLiq+B3Hmbtdp/nkXzmiOepZHBh0ztm8fXCLGxDlGuqBhk
         YHKxB5soApS/Vht3RcZPJlTQfhGseJPL8/4/NXaLqXGAD0U05qX0bNrEIX5gZylHq/
         e87Fy0BcLbalc7jhTDNb321kq1dD2aLAR6XBctJuoMfU6eKWTwOEWbrwjK4ugdj+5p
         RUdgPVR+qJJ83eQ6EzFxlfjyqyRp7ZsMlJsQSiNc9OC3DyvqbUVTcu2h6tdD1y2nP+
         yI6f0mU6ct6/Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 11/16] fscrypt: allow load/save of extent contexts
Date:   Tue,  8 Aug 2023 13:08:28 -0400
Message-ID: <6088e52bd6565c4e896033d0e79955b576f05048.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The other half of using per-extent infos is saving and loading them from
disk.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c    | 49 +++++++++++++++++++++++++++++++++++++++++
 fs/crypto/policy.c      | 20 +++++++++++++++++
 include/linux/fscrypt.h | 17 ++++++++++++++
 3 files changed, 86 insertions(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index c4ec042ca892..0076c7f2af3d 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -983,6 +983,55 @@ void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
 }
 EXPORT_SYMBOL_GPL(fscrypt_free_extent_info);
 
+/**
+ * fscrypt_load_extent_info() - set up a preexisting extent's fscrypt_info
+ * @inode: the inode to which the extent belongs. Must be encrypted.
+ * @buf: a buffer containing the extent's stored context
+ * @len: the length of the @ctx buffer
+ * @info_ptr: a pointer to return the extent's fscrypt_info into. Should be
+ *	      a pointer to a member of the extent struct, as it will be passed
+ *	      back to the filesystem if key removal demands removal of the
+ *	      info from the extent
+ *
+ * This is not %GFP_NOFS safe, so the caller is expected to call
+ * memalloc_nofs_save/restore() if appropriate.
+ *
+ * Return: 0 if successful, or -errno if it fails.
+ */
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_info **info_ptr)
+{
+	int res;
+	union fscrypt_context ctx;
+	union fscrypt_policy policy;
+
+	if (!fscrypt_has_encryption_key(inode))
+		return -EINVAL;
+
+	memcpy(&ctx, buf, len);
+
+	res = fscrypt_policy_from_context(&policy, &ctx, len);
+	if (res) {
+		fscrypt_warn(inode,
+			     "Unrecognized or corrupt encryption context");
+		return res;
+	}
+
+	if (!fscrypt_supported_policy(&policy, inode))
+		return -EINVAL;
+
+	res = fscrypt_setup_encryption_info(inode, &policy,
+					    fscrypt_context_nonce(&ctx),
+					    IS_CASEFOLDED(inode) &&
+					    S_ISDIR(inode->i_mode),
+					    info_ptr);
+
+	if (res == -ENOPKG) /* Algorithm unavailable? */
+		res = 0;
+	return res;
+}
+EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
+
 /**
  * fscrypt_put_encryption_info() - free most of an inode's fscrypt data
  * @inode: an inode being evicted
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index f4456ecb3f87..9ecb01e49d33 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -762,6 +762,26 @@ int fscrypt_set_context(struct inode *inode, void *fs_data)
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_context);
 
+/**
+ * fscrypt_set_extent_context() - Set the fscrypt context for an extent
+ * @ci: info from which to fetch policy and nonce
+ * @ctx: where context should be written
+ * @len: the size of ctx
+ *
+ * Given an fscrypt_info belonging to an extent (generated via
+ * fscrypt_prepare_new_extent()), generate a new context and write it to @ctx.
+ * len is checked to be at least FSCRYPT_SET_CONTEXT_MAX_SIZE bytes.
+ *
+ * Return: size of the resulting context or a negative error code.
+ */
+int fscrypt_set_extent_context(struct fscrypt_info *ci, void *ctx, size_t len)
+{
+	if (len < FSCRYPT_SET_CONTEXT_MAX_SIZE)
+		return -EINVAL;
+	return fscrypt_new_context(ctx, &ci->ci_policy, ci->ci_nonce);
+}
+EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
+
 /**
  * fscrypt_parse_test_dummy_encryption() - parse the test_dummy_encryption mount option
  * @param: the mount option
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e39165fbed41..4ba624beea91 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -325,6 +325,8 @@ int fscrypt_ioctl_get_nonce(struct file *filp, void __user *arg);
 int fscrypt_has_permitted_context(struct inode *parent, struct inode *child);
 int fscrypt_context_for_new_inode(void *ctx, struct inode *inode);
 int fscrypt_set_context(struct inode *inode, void *fs_data);
+int fscrypt_set_extent_context(struct fscrypt_info *info, void *ctx,
+			       size_t len);
 
 struct fscrypt_dummy_policy {
 	const union fscrypt_policy *policy;
@@ -365,6 +367,8 @@ int fscrypt_drop_inode(struct inode *inode);
 int fscrypt_prepare_new_extent(struct inode *inode,
 			       struct fscrypt_info **info_ptr);
 void fscrypt_free_extent_info(struct fscrypt_info **info_ptr);
+int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
+			     struct fscrypt_info **info_ptr);
 
 /* fname.c */
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
@@ -541,6 +545,12 @@ static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_set_extent_context(struct fscrypt_info *info,
+					     void *ctx, size_t len)
+{
+	return -EOPNOTSUPP;
+}
+
 struct fscrypt_dummy_policy {
 };
 
@@ -639,6 +649,13 @@ static inline void fscrypt_free_extent_info(struct fscrypt_info **info_ptr)
 {
 }
 
+static inline int fscrypt_load_extent_info(struct inode *inode, void *buf,
+					   size_t len,
+					   struct fscrypt_info **info_ptr)
+{
+	return -EOPNOTSUPP;
+}
+
  /* fname.c */
 static inline int fscrypt_setup_filename(struct inode *dir,
 					 const struct qstr *iname,
-- 
2.41.0

