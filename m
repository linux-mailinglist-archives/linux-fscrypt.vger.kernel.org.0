Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AA8274E38
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Sep 2020 03:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIWBJj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Sep 2020 21:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgIWBJ1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Sep 2020 21:09:27 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C0FC061755
        for <linux-fscrypt@vger.kernel.org>; Tue, 22 Sep 2020 18:09:27 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y10so265398plp.14
        for <linux-fscrypt@vger.kernel.org>; Tue, 22 Sep 2020 18:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=6Jea0D8IQymzKa0cePGlWsc3mYiPTYFJmjhFuidHEKk=;
        b=Fw/pQ9kOsMZOp4qcT//rGk0Ty0QnPBIDZAQyCHbGz+EB0pENDjiV0Msb9s3Us7Rqy8
         LW694CF7h2UAEaewdIWmuHdo6GPeQxAY3OMDp4A30swVcAgrTfLA9IKzxZJbhW2PZdV4
         4El+U8pvEnZ2ke/FYErM9S7pWsuw25W9oV0xGx2RW3h0AZQ0QWD/TCHm+TdQsnsVamCU
         HP8rIZr6ZqIXyFSFq6oumaQoSIMxhMCoxpT8dXxHepR7EUpmiSTu9hAWCSGTl1ejKyC7
         Z5ARTwIW+48S7v6wv+Ryn4ULJPl8AS1R4hZUc5xYPa2P7yyEnjnn8uzXiByNpwqIICgl
         lI8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6Jea0D8IQymzKa0cePGlWsc3mYiPTYFJmjhFuidHEKk=;
        b=EbN3/oEiuSUkdNM5w1OuZkRrpyjxdHEPrIRhrjLlJf+qDSSofPw/Ccg1CmRsNt+6V5
         TgQ31rAeQyZdWkccNXHWjVvK34MoD1/YJ7yr1Cq1gnZLT6e5VNuIfbK9zPt5sf6Ny0pr
         d6rCErTT6wIqqKcxjFxxO1JBQxU7iEYFZl6rXpIuKtHg83H6QAujG21ZsC0ZijtpAEvk
         fe0P6TKlr1lf5OBXe5hI8fBSEmRMCcfwAG8XWb7HCPldKteO5tLQ8Iz5uPiy5QcC8pJq
         iq3eeS3PSJ8KXpw5yBOsn+36HXEruvGVGoeLyjPU4N18o4WNEbq8fHtyDpTkoG1Fz3au
         zyuQ==
X-Gm-Message-State: AOAM530vF26xTQmqDkV5D39nPpsETDcczmeG2msBjCBQ8t8zpGJ3gdbl
        +m6+/ugPovwMUeOrpzAI2FsHDSesnrA=
X-Google-Smtp-Source: ABdhPJw5cOhPCfYuz52eXjYlgKJA9wCJZI1O/01lTyF39qWXyCNTFLUsASASM8K3SUHFB6H7JtIckRIlheI=
Sender: "drosen via sendgmr" <drosen@drosen.c.googlers.com>
X-Received: from drosen.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:4e6f])
 (user=drosen job=sendgmr) by 2002:a62:1451:0:b029:13e:d13d:a058 with SMTP id
 78-20020a6214510000b029013ed13da058mr6581273pfu.30.1600823367027; Tue, 22 Sep
 2020 18:09:27 -0700 (PDT)
Date:   Wed, 23 Sep 2020 01:01:49 +0000
In-Reply-To: <20200923010151.69506-1-drosen@google.com>
Message-Id: <20200923010151.69506-4-drosen@google.com>
Mime-Version: 1.0
References: <20200923010151.69506-1-drosen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 3/5] libfs: Add generic function for setting dentry_ops
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This adds a function to set dentry operations at lookup time that will
work for both encrypted files and casefolded filenames.

A filesystem that supports both features simultaneously can use this
function during lookup preperations to set up its dentry operations once
fscrypt no longer does that itself.

Currently the casefolding dentry operation are always set because the
feature is toggleable on empty directories. Since we don't know what
set of functions we'll eventually need, and cannot change them later,
we add just add them.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/libfs.c         | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index fc34361c1489..83303858f1fe 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1449,4 +1449,53 @@ int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str)
 	return 0;
 }
 EXPORT_SYMBOL(generic_ci_d_hash);
+
+static const struct dentry_operations generic_ci_dentry_ops = {
+	.d_hash = generic_ci_d_hash,
+	.d_compare = generic_ci_d_compare,
+};
+#endif
+
+#ifdef CONFIG_FS_ENCRYPTION
+static const struct dentry_operations generic_encrypted_dentry_ops = {
+	.d_revalidate = fscrypt_d_revalidate,
+};
+#endif
+
+#if IS_ENABLED(CONFIG_UNICODE) && IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static const struct dentry_operations generic_encrypted_ci_dentry_ops = {
+	.d_hash = generic_ci_d_hash,
+	.d_compare = generic_ci_d_compare,
+	.d_revalidate = fscrypt_d_revalidate,
+};
+#endif
+
+/**
+ * generic_set_encrypted_ci_d_ops - helper for setting d_ops for given dentry
+ * @dentry:	dentry to set ops on
+ *
+ * This function sets the dentry ops for the given dentry to handle both
+ * casefolding and encryption of the dentry name.
+ */
+void generic_set_encrypted_ci_d_ops(struct dentry *dentry)
+{
+#ifdef CONFIG_FS_ENCRYPTION
+	if (dentry->d_flags & DCACHE_ENCRYPTED_NAME) {
+#ifdef CONFIG_UNICODE
+		if (dentry->d_sb->s_encoding) {
+			d_set_d_op(dentry, &generic_encrypted_ci_dentry_ops);
+			return;
+		}
 #endif
+		d_set_d_op(dentry, &generic_encrypted_dentry_ops);
+		return;
+	}
+#endif
+#ifdef CONFIG_UNICODE
+	if (dentry->d_sb->s_encoding) {
+		d_set_d_op(dentry, &generic_ci_dentry_ops);
+		return;
+	}
+#endif
+}
+EXPORT_SYMBOL(generic_set_encrypted_ci_d_ops);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bc5417c61e12..6627896db835 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3277,6 +3277,7 @@ extern int generic_ci_d_hash(const struct dentry *dentry, struct qstr *str);
 extern int generic_ci_d_compare(const struct dentry *dentry, unsigned int len,
 				const char *str, const struct qstr *name);
 #endif
+extern void generic_set_encrypted_ci_d_ops(struct dentry *dentry);
 
 #ifdef CONFIG_MIGRATION
 extern int buffer_migrate_page(struct address_space *,
-- 
2.28.0.681.g6f77f65b4e-goog

