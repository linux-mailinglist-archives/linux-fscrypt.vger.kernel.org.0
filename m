Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA1F7C4182
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbjJJUl3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbjJJUl0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:26 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709F7B7
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:22 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5a7ac4c3666so22887597b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970481; x=1697575281; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGaKZfQ8xEUtcj2BvoUGwcXV31Q0VFKb7VLEms82qyQ=;
        b=v+12unYu8g6cI/P3RKUDnW31FYjwKlbnTb0IrxmO/udAA3btF88eB1rHBRdxhpERTo
         adrzkWk0c96n/vGDwOw21HjzlSHmeBLsmOe/nTAAShkCZKnkTwMc+QLer9luJyLurTAr
         HqsKG6xjRWAmW0zH5bHRKMiPdfs5T4IBwJGPE7Acd3apLVCtnOX97XSaXRBPr6jD58Sk
         9BiuUZLo6KSDU2q1AUVhH+1Xsz6TD4d9bXku5wmuqSE/2DBzJ3qC1yHkxlpXWnSfepyw
         4Z08/6lM2ifAHRc30DaqUN9wDF1MAfoLEddU7msZ/Ld/25buYNv/lyw+XmNRsDdXrzBO
         bd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970481; x=1697575281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGaKZfQ8xEUtcj2BvoUGwcXV31Q0VFKb7VLEms82qyQ=;
        b=Aaorm1RiWB/GTMPkZ/qR6FA2DpvK8lHJmov6A6vO+z1WHZg3iywxPsdYIHTTm0oKo+
         7MnRjruZeCPlNhkyT+KXCXZyWMZoUYInDMf6Oz7Xye5is0HV2wauOHHtx1xSMXcviigj
         9o2tyPpWKILcHTJBly/7fq6UYQMnMkOyRUxfTZCLOfoc5yD7rx/NaFmoNcOtQ8Xo8Yxd
         BLjyHXt8/QBuDA1bu2tLcD3a828Z7O8NdiAeDIRtt5602Q62sLWaEo4i3RBJRmCNmege
         j+sSkRGEyBRuajWq1d5iy3rUF+Gm18NcIVWv7evacDljY0v6us/0N4LhQjHWSozAENQh
         rpKw==
X-Gm-Message-State: AOJu0YydQT+TdnfzBJc2hTcih6lL0yQItO9y3NC/rNnfs15W77UKCw1Q
        Z/gc3KlP6viXqveb81TTYBmN+B04iZ+mKHMNTZ+S/w==
X-Google-Smtp-Source: AGHT+IHeEj663skje7rfY8kWno/+5dW68lLPSD/+JCkdZB2lrebxfySWJGa4nOxiXvR4HoXr8G6Ejw==
X-Received: by 2002:a81:ac20:0:b0:5a7:b900:a373 with SMTP id k32-20020a81ac20000000b005a7b900a373mr4067162ywh.0.1696970481246;
        Tue, 10 Oct 2023 13:41:21 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id q2-20020a819902000000b0059bc0d766f8sm1084022ywg.34.2023.10.10.13.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 15/36] btrfs: handle nokey names.
Date:   Tue, 10 Oct 2023 16:40:30 -0400
Message-ID: <d19d5a5ab01e1eac11d8935789fe7ed1bd24ae04.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index 6a4e4f63a660..9103da28af7e 100644
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

