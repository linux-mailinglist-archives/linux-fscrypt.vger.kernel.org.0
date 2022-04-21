Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA4A5096AC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384304AbiDUF0k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:40 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6F0DFB1;
        Wed, 20 Apr 2022 22:23:51 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id l127so3973641pfl.6;
        Wed, 20 Apr 2022 22:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nAKdB7OlNBPLSXEPrWPj54rwnqnTQlbZgYB1Swf5oy4=;
        b=fkYbjCMvDg0qkUwF8guksF3TwEPZnQCCyg+zk1xlXSgeArgoyfGnKnrKLPBs0qThB4
         PolkXz0oOctKv/X/ci91Slc/6IT+N3IjoYoOm69wDvrw4lOmyzZ9EgEoKVnz1GDu+c5c
         80TZHM6EVilHh7s/SX5B9ryEUVpRJ74FC6sBBO5oABST8iQTsmyzqjCv6VYrrb7IXByE
         cRMqcMlh8OVPdj2h4XfI82griaJfgzR/uoH/GlSl17BZ0Nac50F/xIeNtD8vsMHPPYyG
         xLSItzsmxjaW3G3TNSqtTdEb3qPlsW7NvVI/ovPauLyXaxx+KalgDgY0dwIKRD9tdEL8
         znnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nAKdB7OlNBPLSXEPrWPj54rwnqnTQlbZgYB1Swf5oy4=;
        b=eR/6215F6R+KEK+iTJhuY2qJMJz0VYtHK58CEfTiP29/y2wXE7d/pC4lRqJS2kIlRQ
         TkeTzjAIVaIIau6WFOZgC6p2Z9tZXeOKxoBkzljQgibbvdM52IMYjU2vqVLDdQUVjrYx
         Xk+t4MDeWY9rgjuWWuaKOsy36TKcyScKSF0p2PG0KiDV0RkD4wR4L4JAHSDZs/GxYHKX
         +UOb40YeJJ5yvWqP/aAI6iMBc5P72n8WH60soeC7TQiLwmg69ZhR4R7yUlppD7+z3gTJ
         E+pNoKClmVxoiJ17zrLD2opw7z4P+Z2bqZfSaCjj2Wza/gcjFK8v5kzGuocBJNw6AlLb
         HW1A==
X-Gm-Message-State: AOAM530J/Nsz8JPGU1QbArVRykItswIRvpqZgVDL99elStEEM8N9b1K5
        KggepoH1wzZZ8DxLyBtUsdxF2pCkyo8=
X-Google-Smtp-Source: ABdhPJx8/NhAAgdA1VPtYLg+J5vqrTzY9NcllaF/sbVbOO2uH0D/6Pm8IexY0znMLR7jFTrpMUmz3A==
X-Received: by 2002:a63:3e0a:0:b0:3aa:646f:f445 with SMTP id l10-20020a633e0a000000b003aa646ff445mr6597605pga.30.1650518631381;
        Wed, 20 Apr 2022 22:23:51 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id w187-20020a6230c4000000b00505cde77826sm21554169pfw.159.2022.04.20.22.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:51 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 4/6] ext4: Cleanup function defs from ext4.h into ext4_crypto.c
Date:   Thu, 21 Apr 2022 10:53:20 +0530
Message-Id: <e719bdd947a372d777ca425c99352f708fb04e26.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Some of these functions when CONFIG_FS_ENCRYPTION is enabled are not
really inline (let compiler be the best judge of it).
Remove inline and move them into ext4_crypto.c where they should be present.

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/ext4.h        | 70 ++++---------------------------------------
 fs/ext4/ext4_crypto.c | 65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 64 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8bac8af25ed8..caf154db4680 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2731,73 +2731,15 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
 extern const struct fscrypt_operations ext4_cryptops;
 
 #ifdef CONFIG_FS_ENCRYPTION
-static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
-						const struct fscrypt_name *src)
-{
-	memset(dst, 0, sizeof(*dst));
-
-	dst->usr_fname = src->usr_fname;
-	dst->disk_name = src->disk_name;
-	dst->hinfo.hash = src->hash;
-	dst->hinfo.minor_hash = src->minor_hash;
-	dst->crypto_buf = src->crypto_buf;
-}
-
-static inline int ext4_fname_setup_filename(struct inode *dir,
-					    const struct qstr *iname,
-					    int lookup,
-					    struct ext4_filename *fname)
-{
-	struct fscrypt_name name;
-	int err;
+int ext4_fname_setup_filename(struct inode *dir,
+			      const struct qstr *iname, int lookup,
+			      struct ext4_filename *fname);
 
-	err = fscrypt_setup_filename(dir, iname, lookup, &name);
-	if (err)
-		return err;
+int ext4_fname_prepare_lookup(struct inode *dir, struct dentry *dentry,
+			      struct ext4_filename *fname);
 
-	ext4_fname_from_fscrypt_name(fname, &name);
+void ext4_fname_free_filename(struct ext4_filename *fname);
 
-#if IS_ENABLED(CONFIG_UNICODE)
-	err = ext4_fname_setup_ci_filename(dir, iname, fname);
-#endif
-	return err;
-}
-
-static inline int ext4_fname_prepare_lookup(struct inode *dir,
-					    struct dentry *dentry,
-					    struct ext4_filename *fname)
-{
-	struct fscrypt_name name;
-	int err;
-
-	err = fscrypt_prepare_lookup(dir, dentry, &name);
-	if (err)
-		return err;
-
-	ext4_fname_from_fscrypt_name(fname, &name);
-
-#if IS_ENABLED(CONFIG_UNICODE)
-	err = ext4_fname_setup_ci_filename(dir, &dentry->d_name, fname);
-#endif
-	return err;
-}
-
-static inline void ext4_fname_free_filename(struct ext4_filename *fname)
-{
-	struct fscrypt_name name;
-
-	name.crypto_buf = fname->crypto_buf;
-	fscrypt_free_filename(&name);
-
-	fname->crypto_buf.name = NULL;
-	fname->usr_fname = NULL;
-	fname->disk_name.name = NULL;
-
-#if IS_ENABLED(CONFIG_UNICODE)
-	kfree(fname->cf_name.name);
-	fname->cf_name.name = NULL;
-#endif
-}
 #else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,
diff --git a/fs/ext4/ext4_crypto.c b/fs/ext4/ext4_crypto.c
index e5413c0970ee..7e89f86a4429 100644
--- a/fs/ext4/ext4_crypto.c
+++ b/fs/ext4/ext4_crypto.c
@@ -6,6 +6,71 @@
 #include "xattr.h"
 #include "ext4_jbd2.h"
 
+void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
+				  const struct fscrypt_name *src)
+{
+	memset(dst, 0, sizeof(*dst));
+
+	dst->usr_fname = src->usr_fname;
+	dst->disk_name = src->disk_name;
+	dst->hinfo.hash = src->hash;
+	dst->hinfo.minor_hash = src->minor_hash;
+	dst->crypto_buf = src->crypto_buf;
+}
+
+int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
+			      int lookup, struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+	int err;
+
+	err = fscrypt_setup_filename(dir, iname, lookup, &name);
+	if (err)
+		return err;
+
+	ext4_fname_from_fscrypt_name(fname, &name);
+
+#if IS_ENABLED(CONFIG_UNICODE)
+	err = ext4_fname_setup_ci_filename(dir, iname, fname);
+#endif
+	return err;
+}
+
+int ext4_fname_prepare_lookup(struct inode *dir, struct dentry *dentry,
+			      struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+	int err;
+
+	err = fscrypt_prepare_lookup(dir, dentry, &name);
+	if (err)
+		return err;
+
+	ext4_fname_from_fscrypt_name(fname, &name);
+
+#if IS_ENABLED(CONFIG_UNICODE)
+	err = ext4_fname_setup_ci_filename(dir, &dentry->d_name, fname);
+#endif
+	return err;
+}
+
+void ext4_fname_free_filename(struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+
+	name.crypto_buf = fname->crypto_buf;
+	fscrypt_free_filename(&name);
+
+	fname->crypto_buf.name = NULL;
+	fname->usr_fname = NULL;
+	fname->disk_name.name = NULL;
+
+#if IS_ENABLED(CONFIG_UNICODE)
+	kfree(fname->cf_name.name);
+	fname->cf_name.name = NULL;
+#endif
+}
+
 static int ext4_get_context(struct inode *inode, void *ctx, size_t len)
 {
 	return ext4_xattr_get(inode, EXT4_XATTR_INDEX_ENCRYPTION,
-- 
2.31.1

