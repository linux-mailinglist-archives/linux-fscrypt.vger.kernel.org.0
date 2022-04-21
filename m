Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F185096AD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384307AbiDUF0p (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0p (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:45 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1434DFAF;
        Wed, 20 Apr 2022 22:23:56 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id iq10so192464pjb.0;
        Wed, 20 Apr 2022 22:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kqyIPRpEKHi3QFbh2k8vw2KJbGiX1tCP5QuWevqqO4c=;
        b=J0neBI/t2C848zvRKU4xgW7MW/VFnC1S1H5xglcX5U5iZRhV+I/sqt28r7Z8stJLDf
         JFOzBlyvXHzTPfwMyu0LcKwYgLLClLpwXBIYQiVY/TsymAtGAMeBWwQ330SPwAjc6onl
         1BTpOXN4Phzr33WoJFjYuZG4sKqhBoieCBOhQeUeCiBKSC0FNGaCqwp+y40VCJnYBAGl
         YEJpGSEcxiA7YCvdJTlUI1aKQrYlgL2UnpKhK5NFYGSmHeVoptmIDW3ipUR8QxwtV/u+
         d5BPE3Go5PCJ/HJbYuBOv/xCm4cghS9qmyEs7bRL7qEVlGlrHmTCpXyNmmhWAkoBPnrN
         hj5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kqyIPRpEKHi3QFbh2k8vw2KJbGiX1tCP5QuWevqqO4c=;
        b=scBFqn9+nfI22CxPe6O7S7DNZ8T3AUabiJaXgCKOttIKTgqkeAa8loONPjDoh9X+4H
         zT7KGOy6VbpRJkTPVmM3/gh0dmpr5dVcVWD8RDPZ6XWIwg8Ss5qWrR3TEQXhF+jH/2Ow
         rOWh4idvr5a+nQ2GANERGvuHGcAN54Na4oKKIRCflzkt5sp2NiARhoNVMtaN83RZRXhN
         xMH8mnXvMemR47HJR0nweP+7nqR9LXbshYXSC5YGPMwGHVu3FzQg6m5PLaHk4kW2LeD5
         J1K0IioozQkvPB/pXEvvhKQHTqJVrmZExaVsfsbF8uzHeU99QBIMcF/BZa4w6CijBDkO
         VslA==
X-Gm-Message-State: AOAM530rh4T2IlAJCl3OPnqgDMds5lI1enfOjD/JEuFMjGw4ZzoEiW2i
        kWBSrP7HBp5HhQdEVtE/Ir5xoPKwqHY=
X-Google-Smtp-Source: ABdhPJw+yV11ELgKTtNfxUw/xsRDwao3556g5tiFbEVMrv43Lm9Fx9hzmkeHRrXJeo65ocMjoGiuPw==
X-Received: by 2002:a17:90a:f00c:b0:1cb:8361:c78e with SMTP id bt12-20020a17090af00c00b001cb8361c78emr8457233pjb.133.1650518636156;
        Wed, 20 Apr 2022 22:23:56 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id s62-20020a635e41000000b003a9eb7f65absm4346225pgb.85.2022.04.20.22.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:55 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 5/6] ext4: Move all encryption related into a common #ifdef
Date:   Thu, 21 Apr 2022 10:53:21 +0530
Message-Id: <74855c5d50db92722213a738c0fb43a878dc6557.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This just moves left over usages of #ifdef CONFIG_FS_ENCRYPTION
into a common place for function/macro definitions.

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/ext4.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index caf154db4680..2fb69c500063 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1440,12 +1440,6 @@ struct ext4_super_block {

 #ifdef __KERNEL__

-#ifdef CONFIG_FS_ENCRYPTION
-#define DUMMY_ENCRYPTION_ENABLED(sbi) ((sbi)->s_dummy_enc_policy.policy != NULL)
-#else
-#define DUMMY_ENCRYPTION_ENABLED(sbi) (0)
-#endif
-
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 3

@@ -2740,6 +2734,8 @@ int ext4_fname_prepare_lookup(struct inode *dir, struct dentry *dentry,

 void ext4_fname_free_filename(struct ext4_filename *fname);

+#define DUMMY_ENCRYPTION_ENABLED(sbi) ((sbi)->s_dummy_enc_policy.policy != NULL)
+
 #else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
 					    const struct qstr *iname,
@@ -2772,6 +2768,8 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname)
 	fname->cf_name.name = NULL;
 #endif
 }
+
+#define DUMMY_ENCRYPTION_ENABLED(sbi) (0)
 #endif /* !CONFIG_FS_ENCRYPTION */

 /* dir.c */
--
2.31.1

