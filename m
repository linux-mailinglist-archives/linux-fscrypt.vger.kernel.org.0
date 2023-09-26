Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDF27AF21C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbjIZSDz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbjIZSDw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:52 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565DE11F
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:43 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-4181bd07f25so25435171cf.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751422; x=1696356222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DRKZzy6fAzE+FLjFaVzJb4Ci7b8/zie5hfsfMucJOQc=;
        b=yBHIBmB6GV1pMeMk8Up2yVvmCuaKy2rSToa/jsvO/G7DqynVUQPuvxQF/nKTPYt3NJ
         mMIpup3y2gdoRexPgqL3erMjXpfpYFS/3d8tHPpNQbGZ0ygTM4Lm60z+HvE7Iq0SqmAi
         MtD12IjYe2iDfrQNsO8S9yTmsxpiH/i0grx9tm5l2+cA9Vphr0CCUN9snosPm9SCzCDc
         sf5857Q5LlSQxsBdjYSVw9mkBEdBFvm0o37vbWjK+U8ER30qJ/B6uZ18u7bLURgiJto1
         qS/2twgZ9wX77hRFc57rtk0LO6MypuijAk/zCt8dSIR0AE+LluJZhArMFe67nWSH4TNO
         X/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751422; x=1696356222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DRKZzy6fAzE+FLjFaVzJb4Ci7b8/zie5hfsfMucJOQc=;
        b=gzfqZTLlXOtSdSKgziQ++9ikY/FCOFXaWnM2Msw2DdeSJoGgxZshCDQfYKp/zeQl7B
         Yfps4iY8kjSbekI5j2I80YrBcpj1L/wbTxEXiOE4EjqFjws2BUhxmEDM5/GWI5AUI1Xf
         MoAp8PfZpjPclxnAWhmEKHzQJDLoXJz7gdUIM2b16kMX1qxLb8WM0Q7u4T2Ohe7ls3et
         jKZ4gwi9T5Q+VwlLhXEv8nAjDV+jK2a6Y/17EOiwMqPNZeC06vxN0reUf3ptRDJhp6K0
         Ykrjx6bqnvg2IS/ONUt7Y4lgnwVfOBxijN+saTBlLlbzjePlxTKje2jQcAJ7CZPxTTTV
         EFTg==
X-Gm-Message-State: AOJu0YxCorrVq4KzQQ6Mmtd4ctnXJSkjr4yTUaCM+nNiWGo4ubo5oZx5
        Z7Wd5eRqSmzmk9hHYqltHKB2FA==
X-Google-Smtp-Source: AGHT+IGGa1wNABYl8BdVeILE7yPoKsOqH3jgC1N060dV3OkODJYsuhtp3DZLUzCXUL0yY7e2gkpAIA==
X-Received: by 2002:a05:622a:1913:b0:417:914a:104d with SMTP id w19-20020a05622a191300b00417914a104dmr15198508qtc.49.1695751421627;
        Tue, 26 Sep 2023 11:03:41 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id t16-20020ac85310000000b00405553305casm4798417qtn.86.2023.09.26.11.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:41 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 25/35] btrfs: add an optional encryption context to the end of file extents
Date:   Tue, 26 Sep 2023 14:01:51 -0400
Message-ID: <80494ada394d2a9ffeee2e4864cea194d9a75d9b.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The fscrypt encryption context can be extended to include different
things in the future.  To facilitate future expansion add an optional
btrfs_encryption_info to the end of the file extent.  This will hold the
size of the context and then will have the binary context tacked onto
the end of the extent item.

Add the appropriate accessors to make it easy to read this information
if we have encryption set, and then update the tree-checker to validate
that if this is indeed set properly that the size matches properly.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/accessors.h            | 48 +++++++++++++++++++++++++++
 fs/btrfs/tree-checker.c         | 58 ++++++++++++++++++++++++++++-----
 include/uapi/linux/btrfs_tree.h | 17 +++++++++-
 3 files changed, 113 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 5627f13a3d3e..3e6c81449ce7 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -934,6 +934,10 @@ BTRFS_SETGET_STACK_FUNCS(super_uuid_tree_generation, struct btrfs_super_block,
 BTRFS_SETGET_STACK_FUNCS(super_nr_global_roots, struct btrfs_super_block,
 			 nr_global_roots, 64);
 
+/* struct btrfs_file_extent_encryption_info */
+BTRFS_SETGET_FUNCS(encryption_info_size, struct btrfs_encryption_info, size,
+		   32);
+
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item,
 			 type, 8);
@@ -975,6 +979,50 @@ BTRFS_SETGET_FUNCS(file_extent_encryption, struct btrfs_file_extent_item,
 BTRFS_SETGET_FUNCS(file_extent_other_encoding, struct btrfs_file_extent_item,
 		   other_encoding, 16);
 
+static inline struct btrfs_encryption_info *btrfs_file_extent_encryption_info(
+					const struct btrfs_file_extent_item *ei)
+{
+	unsigned long offset = (unsigned long)ei;
+
+	offset += offsetof(struct btrfs_file_extent_item, encryption_info);
+	return (struct btrfs_encryption_info *)offset;
+}
+
+static inline unsigned long btrfs_file_extent_encryption_ctx_offset(
+					const struct btrfs_file_extent_item *ei)
+{
+	unsigned long offset = (unsigned long)ei;
+
+	offset += offsetof(struct btrfs_file_extent_item, encryption_info);
+	return offset + offsetof(struct btrfs_encryption_info, context);
+}
+
+static inline u32 btrfs_file_extent_encryption_ctx_size(
+					const struct extent_buffer *eb,
+					const struct btrfs_file_extent_item *ei)
+{
+	return btrfs_encryption_info_size(eb,
+					  btrfs_file_extent_encryption_info(ei));
+}
+
+static inline void btrfs_set_file_extent_encryption_ctx_size(
+						const struct extent_buffer *eb,
+						struct btrfs_file_extent_item *ei,
+						u32 val)
+{
+	btrfs_set_encryption_info_size(eb,
+				       btrfs_file_extent_encryption_info(ei),
+				       val);
+}
+
+static inline u32 btrfs_file_extent_encryption_info_size(
+					const struct extent_buffer *eb,
+					const struct btrfs_file_extent_item *ei)
+{
+	return btrfs_encryption_info_size(eb,
+					  btrfs_file_extent_encryption_info(ei));
+}
+
 /* btrfs_qgroup_status_item */
 BTRFS_SETGET_FUNCS(qgroup_status_generation, struct btrfs_qgroup_status_item,
 		   generation, 64);
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c2afdf65c2bf..7fe6210c243a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -211,6 +211,7 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 	u32 item_size = btrfs_item_size(leaf, slot);
 	u64 extent_end;
 	u8 policy;
+	u8 fe_type;
 
 	if (unlikely(!IS_ALIGNED(key->offset, sectorsize))) {
 		file_extent_err(leaf, slot,
@@ -241,12 +242,12 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 				SZ_4K);
 		return -EUCLEAN;
 	}
-	if (unlikely(btrfs_file_extent_type(leaf, fi) >=
-		     BTRFS_NR_FILE_EXTENT_TYPES)) {
+
+	fe_type = btrfs_file_extent_type(leaf, fi);
+	if (unlikely(fe_type >= BTRFS_NR_FILE_EXTENT_TYPES)) {
 		file_extent_err(leaf, slot,
 		"invalid type for file extent, have %u expect range [0, %u]",
-			btrfs_file_extent_type(leaf, fi),
-			BTRFS_NR_FILE_EXTENT_TYPES - 1);
+			fe_type, BTRFS_NR_FILE_EXTENT_TYPES - 1);
 		return -EUCLEAN;
 	}
 
@@ -295,12 +296,51 @@ static int check_extent_data_item(struct extent_buffer *leaf,
 		return 0;
 	}
 
-	/* Regular or preallocated extent has fixed item size */
-	if (unlikely(item_size != sizeof(*fi))) {
-		file_extent_err(leaf, slot,
+	if (policy == BTRFS_ENCRYPTION_FSCRYPT) {
+		size_t fe_size = sizeof(*fi) +
+			sizeof(struct btrfs_encryption_info);
+		u32 ctxsize;
+
+		if (unlikely(item_size < fe_size)) {
+			file_extent_err(leaf, slot,
+	"invalid item size for encrypted file extent, have %u expect = %zu + size of u32",
+					item_size, sizeof(*fi));
+			return -EUCLEAN;
+		}
+
+		ctxsize = btrfs_file_extent_encryption_info_size(leaf, fi);
+		if (unlikely(item_size != (fe_size + ctxsize))) {
+			file_extent_err(leaf, slot,
+	"invalid item size for encrypted file extent, have %u expect = %zu + context of size %u",
+					item_size, fe_size, ctxsize);
+			return -EUCLEAN;
+		}
+
+		if (unlikely(ctxsize > BTRFS_MAX_EXTENT_CTX_SIZE)) {
+			file_extent_err(leaf, slot,
+	"invalid file extent context size, have %u expect a maximum of %u",
+					ctxsize, BTRFS_MAX_EXTENT_CTX_SIZE);
+			return -EUCLEAN;
+		}
+
+		/*
+		 * Only regular and prealloc extents should have an encryption
+		 * context.
+		 */
+		if (unlikely(fe_type != BTRFS_FILE_EXTENT_REG &&
+			     fe_type != BTRFS_FILE_EXTENT_PREALLOC)) {
+			file_extent_err(leaf, slot,
+		"invalid type for encrypted file extent, have %u",
+					btrfs_file_extent_type(leaf, fi));
+			return -EUCLEAN;
+		}
+	} else {
+		if (unlikely(item_size != sizeof(*fi))) {
+			file_extent_err(leaf, slot,
 	"invalid item size for reg/prealloc file extent, have %u expect %zu",
-			item_size, sizeof(*fi));
-		return -EUCLEAN;
+					item_size, sizeof(*fi));
+			return -EUCLEAN;
+		}
 	}
 	if (unlikely(CHECK_FE_ALIGNED(leaf, slot, fi, ram_bytes, sectorsize) ||
 		     CHECK_FE_ALIGNED(leaf, slot, fi, disk_bytenr, sectorsize) ||
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index dee650f0082c..5d9563fb6e7f 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -1067,12 +1067,24 @@ enum {
 	BTRFS_NR_FILE_EXTENT_TYPES = 3,
 };
 
+/*
+ * Currently just the FSCRYPT_SET_CONTEXT_MAX_SIZE, which is larger than the
+ * current extent context size from fscrypt, so this should give us plenty of
+ * breathing room for expansion later.
+ */
+#define BTRFS_MAX_EXTENT_CTX_SIZE 40
+
 enum {
 	BTRFS_ENCRYPTION_NONE,
 	BTRFS_ENCRYPTION_FSCRYPT,
 	BTRFS_NR_ENCRYPTION_TYPES,
 };
 
+struct btrfs_encryption_info {
+	__le32 size;
+	__u8 context[0];
+};
+
 struct btrfs_file_extent_item {
 	/*
 	 * transaction id that created this extent
@@ -1128,7 +1140,10 @@ struct btrfs_file_extent_item {
 	 * always reflects the size uncompressed and without encoding.
 	 */
 	__le64 num_bytes;
-
+	/*
+	 * the encryption info, if any
+	 */
+	struct btrfs_encryption_info encryption_info[0];
 } __attribute__ ((__packed__));
 
 struct btrfs_csum_item {
-- 
2.41.0

