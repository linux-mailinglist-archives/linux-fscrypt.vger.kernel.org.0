Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DD5527613
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 08:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbiEOGiM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 02:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiEOGiG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 02:38:06 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAED18E32;
        Sat, 14 May 2022 23:38:05 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gg20so1520495pjb.1;
        Sat, 14 May 2022 23:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q6y+0lX759c+2WJjjX/nFBkDj4oS0A4V3jBwi0l0tSI=;
        b=N82Y3juMSkceUBHwtluXMWplKjj5Yl9CFAnUZHHK8YYwFrGzwjcUAo7FfK573klkHn
         YGnPOV0lGIIAOUSTztjVMnYnSyPUZ/AsR5G9CEgxsJw09qwsPHPafkKJZMklyrbW0hL1
         /epCG8vVtw8uWaD/Gs98V2TUIKfUbpro28LyN1vorKdfovyvtRZKMUnT2EWoMUaPAc1p
         92Cv6e+wPAvD96UCkJsviXs3D1oYZLDAI6PWAvdEllDjtSsfu5jjIzdCcPHuFcKSPdOV
         jLFNYiwxDjl5Wq7ETzVpxQYgMgk+EZGm+7a4sT05iDohjracr3VnnD/n43Hfp/pRWmJl
         6FFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q6y+0lX759c+2WJjjX/nFBkDj4oS0A4V3jBwi0l0tSI=;
        b=BQo2hgaTkty/9tLf+jr74R8xFNwpIFNxkvgbbxafOluOHQCxKaa0cNMSCm/H+ODopK
         f8UeNXKE3by+7aHf2TWiSqDfvoteeFN8EOa8A141Bf0B05WtQh3l9vxt1rrwdzUdcp5b
         fqe+ZE+5wI54dZ2VCTMf+Pg6rqI4cE+d2Kit3slN/8QncXnTaRdE6Pmu7u80ufmc5VLc
         eWYFrYFAqzBdlwq+1Ga2ZSCQU/1WNx0Ua1Q1zM4X8rwSiH1hSRblVlZ2yeaWISNXwgdt
         rtAFOMUIjCT5cq5vbbiK6/3K0Dg4LAnGmINm34dEdRvxdXb8d2nGt/DndZxWTomMRZFV
         XylQ==
X-Gm-Message-State: AOAM530bTZboA0JFGWwmnaQzovGHyMYlovd7EY2iiPn0eTGUOVO0pYRs
        3PPg4HLrrbkrThot0Axrt5sA2h0T4j4=
X-Google-Smtp-Source: ABdhPJxjecJGMuY/H3MnDdEN89qRiR7j45XHY6o3OHgC+CuKa4a//fPQFqYg7C6eHLkiJyhGsmatxw==
X-Received: by 2002:a17:90a:d3d2:b0:1dd:30bb:6a45 with SMTP id d18-20020a17090ad3d200b001dd30bb6a45mr24894782pjw.206.1652596684912;
        Sat, 14 May 2022 23:38:04 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id h31-20020a63f91f000000b003c14af50621sm4390092pgi.57.2022.05.14.23.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:38:04 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCHv3 2/3] ext4: Cleanup function defs from ext4.h into crypto.c
Date:   Sun, 15 May 2022 12:07:47 +0530
Message-Id: <b7b9de2c7226298663fb5a0c28909135e2ab220f.1652595565.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1652595565.git.ritesh.list@gmail.com>
References: <cover.1652595565.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Some of these functions when CONFIG_FS_ENCRYPTION is enabled are not
really inline (let compiler be the best judge of it).
Remove inline and move them into crypto.c where they should be present.

Reviewed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/crypto.c | 65 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   | 69 ++++--------------------------------------------
 2 files changed, 70 insertions(+), 64 deletions(-)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index e5413c0970ee..f8333927f0f6 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -6,6 +6,71 @@
 #include "xattr.h"
 #include "ext4_jbd2.h"
 
+static void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
+					 const struct fscrypt_name *src)
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
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 95d87641ad87..3c474c9623af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2735,73 +2735,14 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
 #ifdef CONFIG_FS_ENCRYPTION
 extern const struct fscrypt_operations ext4_cryptops;
 
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
+int ext4_fname_setup_filename(struct inode *dir, const struct qstr *iname,
+			      int lookup, struct ext4_filename *fname);
 
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
-- 
2.31.1

