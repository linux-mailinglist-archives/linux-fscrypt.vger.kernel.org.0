Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955EA7AF240
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbjIZSDj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbjIZSDi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:38 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2D11F
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:30 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-7741c5bac51so464092085a.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751409; x=1696356209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TmXdaeI9xeYx0BBBrgcCT3hL6DULvaaya1NKFl2gOGI=;
        b=csRuL6/ie428vpSapLOzr+l0UYLQlXakH3ZxA9deziGbpNwS7DWSrEHjwnPEiHHQ2y
         sjvg0SP5f5i071bT9Yc7T4LEFUOEua77LlneovAhpKujYFQQt47jIwEOFS0BKFbLaPaG
         m/heSHxmLQD86b0YNtv/TXN3+zl95JdziebJmtIEhbC+u3ekzq9rKbYTvx406f01vUuj
         gq3X0pjl+5jYLhnDOAx2Vj89EvpRMGurtAtl98vvsVMoyW6RUU+oha9+DqtNNhvNO6OE
         1fRvC0YQSyxZcNzhbmPDE8ziR1plRQvtVrn3HEjO+MJGIJZ8SacohWpkjjlGizC4tfmN
         ATnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751409; x=1696356209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TmXdaeI9xeYx0BBBrgcCT3hL6DULvaaya1NKFl2gOGI=;
        b=IJC0/necehMt563BDIYzivGIu05ck2EeAoHWDlSLSuT+Jtnj/IjvKtsZwiO+Ri6OYs
         k3iRuyUyPynzZllWgvErD6HPZ0pTKBofpq5HE7FF4vA/K4cWzfbHvqm+Ie/kVoBY+XuU
         w/QDXAG09UgOU/VRk8IdbY/SZ8aASqKInqk1Z/d7jjEo76th+5GZONiieSNElYobH+zo
         dZ/XvbtHg4cix1ZX0j3hVp05LgxLmZPpeTbqCAUgS30v2nm+3bsJrw5ZoGxrODqzxzRs
         X0J96Mm/kiahqLfvsRP5mElXG/MWzl2Bz026H6AJ3P4N9vw9fBFU7uxv7LYKL22CVcP1
         gCYw==
X-Gm-Message-State: AOJu0YwvTWE6wY53E/LobPq2MPKNrgYSPb/MsXn1WzkgcxCxnCMprLN3
        TpCQ+qjUfIVLH+Ai0QyQGOF2udUlYt6SmnyY3JpWRA==
X-Google-Smtp-Source: AGHT+IH1VMMScr8itd/IGkf3v0WELyvvY4Zwh7Pl69hBp/W0isHpKhJUjVz+ZrvF1jBH1iF3em4LZw==
X-Received: by 2002:a05:620a:a1e:b0:774:20bb:2473 with SMTP id i30-20020a05620a0a1e00b0077420bb2473mr8947961qka.25.1695751409393;
        Tue, 26 Sep 2023 11:03:29 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id cx18-20020a05620a51d200b007742c2ad7dfsm2497732qkb.73.2023.09.26.11.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:29 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 14/35] btrfs: handle nokey names.
Date:   Tue, 26 Sep 2023 14:01:40 -0400
Message-ID: <705b288d259f0fde3949334250378c620ab84953.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

For encrypted or unencrypted names, we calculate the offset for the dir
item by hashing the name for the dir item. However, this doesn't work
for a long nokey name, where we do not have the complete ciphertext.
Instead, fscrypt stores the filesystem-provided hash in the nokey name,
and we can extract it from the fscrypt_name structure in such a case.

Additionally, for nokey names, if we find the nokey name on disk we can
update the fscrypt_name with the disk name, so add that to searching for
diritems.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/dir-item.c | 37 +++++++++++++++++++++++++++++++++++--
 fs/btrfs/fscrypt.c  | 27 +++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h  | 11 +++++++++++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index a64cfddff7f0..897fb5477369 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -231,6 +231,28 @@ struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 	return di;
 }
 
+/*
+ * If appropriate, populate the disk name for a fscrypt_name looked up without
+ * a key.
+ *
+ * @path:	The path to the extent buffer in which the name was found.
+ * @di:		The dir item corresponding.
+ * @fname:	The fscrypt_name to perhaps populate.
+ *
+ * Returns: 0 if the name is already populated or the dir item doesn't exist
+ * or the name was successfully populated, else an error code.
+ */
+static int ensure_disk_name_from_dir_item(struct btrfs_path *path,
+					  struct btrfs_dir_item *di,
+					  struct fscrypt_name *name)
+{
+	if (name->disk_name.name || !di)
+		return 0;
+
+	return btrfs_fscrypt_get_disk_name(path->nodes[0], di,
+					   &name->disk_name);
+}
+
 /*
  * Lookup for a directory item by fscrypt_name.
  *
@@ -257,8 +279,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
 
 	key.objectid = dir;
 	key.type = BTRFS_DIR_ITEM_KEY;
-	key.offset = btrfs_name_hash(name->disk_name.name, name->disk_name.len);
-	/* XXX get the right hash for no-key names */
+
+	if (!name->disk_name.name)
+		key.offset = name->hash | ((u64)name->minor_hash << 32);
+	else
+		key.offset = btrfs_name_hash(name->disk_name.name,
+					     name->disk_name.len);
 
 	ret = btrfs_search_slot(trans, root, &key, path, mod, -mod);
 	if (ret == 0)
@@ -266,6 +292,8 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
 
 	if (ret == -ENOENT || (di && IS_ERR(di) && PTR_ERR(di) == -ENOENT))
 		return NULL;
+	if (ret == 0)
+		ret = ensure_disk_name_from_dir_item(path, di, name);
 	if (ret < 0)
 		di = ERR_PTR(ret);
 
@@ -382,7 +410,12 @@ btrfs_search_dir_index_item(struct btrfs_root *root, struct btrfs_path *path,
 	btrfs_for_each_slot(root, &key, &key, path, ret) {
 		if (key.objectid != dirid || key.type != BTRFS_DIR_INDEX_KEY)
 			break;
+
 		di = btrfs_match_dir_item_fname(root->fs_info, path, name);
+		if (di)
+			ret = ensure_disk_name_from_dir_item(path, di, name);
+		if (ret)
+			break;
 		if (di)
 			return di;
 	}
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 588966f0414f..254e48005aec 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -14,6 +14,33 @@
 #include "transaction.h"
 #include "xattr.h"
 
+/*
+ * From a given location in a leaf, read a name into a qstr (usually a
+ * fscrypt_name's disk_name), allocating the required buffer. Used for
+ * nokey names.
+ */
+int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+				struct btrfs_dir_item *dir_item,
+				struct fscrypt_str *name)
+{
+	unsigned long de_name_len = btrfs_dir_name_len(leaf, dir_item);
+	unsigned long de_name = (unsigned long)(dir_item + 1);
+	/*
+	 * For no-key names, we use this opportunity to find the disk
+	 * name, so future searches don't need to deal with nokey names
+	 * and we know what the encrypted size is.
+	 */
+	name->name = kmalloc(de_name_len, GFP_NOFS);
+
+	if (!name->name)
+		return -ENOMEM;
+
+	read_extent_buffer(leaf, name->name, de_name, de_name_len);
+
+	name->len = de_name_len;
+	return 0;
+}
+
 /*
  * This function is extremely similar to fscrypt_match_name() but uses an
  * extent_buffer.
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 1647bbbcd609..c08fd52c99b4 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -9,11 +9,22 @@
 #include "fs.h"
 
 #ifdef CONFIG_FS_ENCRYPTION
+int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+				struct btrfs_dir_item *di,
+				struct fscrypt_str *qstr);
+
 bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 			      struct extent_buffer *leaf,
 			      unsigned long de_name, u32 de_name_len);
 
 #else
+static inline int btrfs_fscrypt_get_disk_name(struct extent_buffer *leaf,
+					      struct btrfs_dir_item *di,
+					      struct fscrypt_str *qstr)
+{
+	return 0;
+}
+
 static inline bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
 					    struct extent_buffer *leaf,
 					    unsigned long de_name,
-- 
2.41.0

