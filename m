Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE34C52734F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 19:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiENRXM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 13:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiENRXJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 13:23:09 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D68101EA;
        Sat, 14 May 2022 10:23:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id p8so10384322pfh.8;
        Sat, 14 May 2022 10:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQwy2TXFojnREtRP7UzV1zaEesI5jCcgp2eHJEFcnLg=;
        b=XLEM2AAshCIk0rTZg+IO7FhrgHD8k0etKL8VLAMPUatj/aOLL76zH54ss18P255jo0
         wF9xL5lOIC1jH4l46uK6IsCzNI6Gq1boU93Edmrn3XtP8LrQrY3DvtoQ8qTb+OP9EeYs
         KqSm6mU/ZH05VXhs2KxxlDcg1AjoIKIr0gNGOFV/5vke6rb8IaOv9Cm85Ea3MPcHazZY
         tGel5Sl4XfwuBDktIeXC+01uZD0lhuWkDicMBitEMsLWLlh5fNRx8hvp5CKO7RmE+HNv
         oKCP1H/wtxD1g6aCgIqCmElxWCdo+ya/sleXtyKG3NtIlGLEELdExXTGzHPUcX9kQnAI
         rKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQwy2TXFojnREtRP7UzV1zaEesI5jCcgp2eHJEFcnLg=;
        b=QGcyqVFeQ6gW58Yzw3onLfNWnau9P+zC/qPVaOJ0JQ8YFCQIRZ+Lal5X0qX+5cZI02
         EjZn0Eu6r4aA6JK8q0s68nNUox+b87MFLbjZ8HCtpx5aLNst2T7Wr7KiV3MkqqoTx6Eo
         Bn9Vf7fRwXQxWQulHNffYsCYjV8tsDIWnxTvyn0ZT+i8yIehrXJoGMhqbrblllc4Ass8
         u+t0lJ2stxACPl2oohwOMmLp60loTz4ifOw3COC8vwecAjDykoNBq3YJaxmRdtLOr4wg
         YisRsTZfZxks4R7H2IFRLSlRa4KbaT33W2EtYNaNAPc45AdW/Rg4cixYX2mv3SOpaZ1b
         39Mg==
X-Gm-Message-State: AOAM5316btn06jsZxDt7TV+zvHeDmkTP4u+aRNC+IefmmRk9SAc9hWM1
        ZynKsgH/bduWZvWmrfQW7zgK9PlZiOw=
X-Google-Smtp-Source: ABdhPJxQyIZIPeOsePJp4Zk119skicFaVrOqRrF2qNeYS4XI9MvwYjSbaHnHOJdEdxjqGJzxXErYpg==
X-Received: by 2002:a63:8b42:0:b0:3c6:2f31:2dfc with SMTP id j63-20020a638b42000000b003c62f312dfcmr8455776pge.285.1652548988106;
        Sat, 14 May 2022 10:23:08 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id r19-20020a170903021300b0015e8d4eb26esm3960538plh.184.2022.05.14.10.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 10:23:07 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 2/3] ext4: Cleanup function defs from ext4.h into crypto.c
Date:   Sat, 14 May 2022 22:52:47 +0530
Message-Id: <4120e61a1f68c225eb7a27a7a529fd0847270010.1652539361.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1652539361.git.ritesh.list@gmail.com>
References: <cover.1652539361.git.ritesh.list@gmail.com>
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

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/crypto.c | 65 ++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   | 70 +++++-------------------------------------------
 2 files changed, 71 insertions(+), 64 deletions(-)

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
index 9100f0ba4a52..11bb0d2ee2eb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2735,73 +2735,15 @@ extern int ext4_fname_setup_ci_filename(struct inode *dir,
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
-- 
2.31.1

