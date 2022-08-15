Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F8B595159
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Aug 2022 06:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbiHPE4d (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Aug 2022 00:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233953AbiHPEzv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Aug 2022 00:55:51 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924FD1A626B;
        Mon, 15 Aug 2022 13:53:07 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 1A8BE3200935;
        Mon, 15 Aug 2022 16:53:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Aug 2022 16:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660596784; x=1660683184; bh=t4RKx5KJWfVX1MkpVI+yTo2r8
        jqS8Jk9H1Qno5Uo7Hk=; b=s+yDYulo+3F6ysBCMEsuu1/dDQjCucpzVX0mG8G5I
        2XrxIOp5NRtaUI0Lg91F8BfTtMZHbtRy4veTdK2j2pzgsEtyl9aYwjmOv63offK1
        4C5KtrSYIIzeSkPtuGrNY4E9AvqwtEosc9sQzartljhsYM7W6u2LBCTTfZzvQ3os
        W2frtFzV9caI5KwOIf9isk81hhoTe5SCcIRv95uHkGfekxo2lurdLt6MJXsA8ChX
        LPouGH286L8fFB6G8VtYouKfm7CqiLa/c9HC2jV+1UtJWbo+C7v8jHfud/xnV3Ee
        DIR/66vA/FzxTNyMx1PRZDOgZgj0FDGHS6SCypFidXoxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660596784; x=1660683184; bh=t4RKx5KJWfVX1MkpVI+yTo2r8jqS8Jk9H1Q
        no5Uo7Hk=; b=Mx3JI1tZMgJKuE0vepgjIPWT9jOiJkRzxrKyrxgkT16oUI5upND
        vD1/8KglVBv25C9wXlxPpmX0S2KWjMvD6cf0zvK4+oez19WiAS45cjm1uXYomsdu
        CnSlsg7kCxFLgMm3XT3CXoMT2UvGJITghZ+kv2pZDVmNJ+LTodDalWvl/Nu5PYRa
        iF0tOTxk03IGEPfzMo1nqVXGTIdRunJ9MZEsEFMIyDI9bt4agCc3e9dLUUNs2lbl
        mtLh3rEUzcsVt/7TC1QPczDTwM4gbh2vSKKLQ2seM5eWUjQGnkrE3BJcxvBk3LXG
        mq1ayv+J54968AhWnaM0MeqEzLEJyxaNukw==
X-ME-Sender: <xms:MLL6YnaC0jSrV8XPu74_C4_mXNpDB4u_i5df33fFgFtmuSR8Q_2UMw>
    <xme:MLL6YmaslX-xYGYBNHeWIAtmZxlEPVEYR0IORLdLhhO20qBkVnrhjP6_7kQgoItz8
    2_ZeOHKptWkb6ymFWw>
X-ME-Received: <xmr:MLL6Yp9jBiXY8PDw8eLxYMT1d6Rgm5BvIBIDs2SJMJBCqBgNt44kycJ2OIRL6sG_04Klm3pbzRyDJbKCWr6h8JGglyF3Yw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:MLL6YtqwsH59vRRdqrPJFYRrW8nR5NBpKeMgZttiFlUhQDGiOygaxw>
    <xmx:MLL6YirtWgE_oEuuIE7qedZb8lfmP0Z7ScsNR2e75Z0HlkuC_Zx9MQ>
    <xmx:MLL6YjRTadQbeZCKKR5uEuxNw1mYSrlHmr1zRg6pi6_W5uixtHOT_w>
    <xmx:MLL6YnA9dyN1PkGBmft4WaZ4Lg1PxVodSOhQnTFwXKIiNaBP3Q_1SQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 16:53:04 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v4] btrfs: send: add support for fs-verity
Date:   Mon, 15 Aug 2022 13:54:28 -0700
Message-Id: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Preserve the fs-verity status of a btrfs file across send/recv.

There is no facility for installing the Merkle tree contents directly on
the receiving filesystem, so we package up the parameters used to enable
verity found in the verity descriptor. This gives the receive side
enough information to properly enable verity again. Note that this means
that receive will have to re-compute the whole Merkle tree, similar to
how compression worked before encoded_write.

Since the file becomes read-only after verity is enabled, it is
important that verity is added to the send stream after any file writes.
Therefore, when we process a verity item, merely note that it happened,
then actually create the command in the send stream during
'finish_inode_if_needed'.

This also creates V3 of the send stream format, without any format
changes besides adding the new commands and attributes.

Signed-off-by: Boris Burkov <boris@bur.io>

--
Changes in v4:
- Use btrfs_get_verity_descriptor instead of verity ops get descriptor.
  Move that definition to ctree.h for conditional building. This cleaned
  up most of the conditional building issues, in my opinion.
- Rename process_new_verity to process_verity.
- Use le-to-cpu conversion for all fsverity descriptor fields.
- Don't check NULL for kvfree of the send descriptor.
Changes in v3:
- Fixed build failure when CONFIG_FS_VERITY was not set. This required a
  kludge to avoid a build warning as well.
Changes in v2:
- Allocate 16K with kvmalloc and keep it around till the end of send
instead of re-allocating on each file with fs-verity.
- Use unsigned literal for bitshift.
---
 fs/btrfs/ctree.h             |  6 +++
 fs/btrfs/send.c              | 99 ++++++++++++++++++++++++++++++++++++
 fs/btrfs/send.h              | 15 ++++--
 fs/btrfs/verity.c            |  3 +-
 fs/verity/fsverity_private.h |  2 -
 include/linux/fsverity.h     |  3 ++
 6 files changed, 121 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 51c480439263..7c55af4aa048 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -4106,6 +4106,7 @@ static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
 
 extern const struct fsverity_operations btrfs_verityops;
 int btrfs_drop_verity_items(struct btrfs_inode *inode);
+int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size);
 
 BTRFS_SETGET_FUNCS(verity_descriptor_encryption, struct btrfs_verity_descriptor_item,
 		   encryption, 8);
@@ -4123,6 +4124,11 @@ static inline int btrfs_drop_verity_items(struct btrfs_inode *inode)
 	return 0;
 }
 
+static inline int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
+{
+	return -EPERM;
+}
+
 #endif
 
 /* Sanity test specific functions */
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e7671afcee4f..9e8679848d54 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2012 Alexander Block.  All rights reserved.
  */
 
+#include "linux/compiler_attributes.h"
 #include <linux/bsearch.h>
 #include <linux/fs.h>
 #include <linux/file.h>
@@ -15,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/compat.h>
 #include <linux/crc32c.h>
+#include <linux/fsverity.h>
 
 #include "send.h"
 #include "ctree.h"
@@ -127,6 +129,8 @@ struct send_ctx {
 	bool cur_inode_new_gen;
 	bool cur_inode_deleted;
 	bool ignore_cur_inode;
+	bool cur_inode_needs_verity;
+	void *verity_descriptor;
 
 	u64 send_progress;
 
@@ -624,6 +628,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(8)
 TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
@@ -4886,6 +4891,79 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 	return ret;
 }
 
+static int send_verity(struct send_ctx *sctx, struct fs_path *path,
+		       struct fsverity_descriptor *desc)
+{
+	int ret;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_ENABLE_VERITY);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, path);
+	TLV_PUT_U8(sctx, BTRFS_SEND_A_VERITY_ALGORITHM, le8_to_cpu(desc->hash_algorithm));
+	TLV_PUT_U32(sctx, BTRFS_SEND_A_VERITY_BLOCK_SIZE, 1U << le8_to_cpu(desc->log_blocksize));
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SALT_DATA, desc->salt, le8_to_cpu(desc->salt_size));
+	TLV_PUT(sctx, BTRFS_SEND_A_VERITY_SIG_DATA, desc->signature, le32_to_cpu(desc->sig_size));
+
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	return ret;
+}
+
+static int process_verity(struct send_ctx *sctx)
+{
+	int ret = 0;
+	struct btrfs_fs_info *fs_info = sctx->send_root->fs_info;
+	struct inode *inode;
+	struct fs_path *p;
+
+	inode = btrfs_iget(fs_info->sb, sctx->cur_ino, sctx->send_root);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	ret = btrfs_get_verity_descriptor(inode, NULL, 0);
+	if (ret < 0)
+		goto iput;
+
+	if (ret > FS_VERITY_MAX_DESCRIPTOR_SIZE) {
+		ret = -EMSGSIZE;
+		goto iput;
+	}
+	if (!sctx->verity_descriptor) {
+		sctx->verity_descriptor = kvmalloc(FS_VERITY_MAX_DESCRIPTOR_SIZE, GFP_KERNEL);
+		if (!sctx->verity_descriptor) {
+			ret = -ENOMEM;
+			goto iput;
+		}
+	}
+
+	ret = btrfs_get_verity_descriptor(inode, sctx->verity_descriptor, ret);
+	if (ret < 0)
+		goto iput;
+
+	p = fs_path_alloc();
+	if (!p) {
+		ret = -ENOMEM;
+		goto iput;
+	}
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto free_path;
+
+	ret = send_verity(sctx, p, sctx->verity_descriptor);
+	if (ret < 0)
+		goto free_path;
+
+free_path:
+	fs_path_free(p);
+iput:
+	iput(inode);
+	return ret;
+}
+
 static inline u64 max_send_read_size(const struct send_ctx *sctx)
 {
 	return sctx->send_max_size - SZ_16K;
@@ -6377,6 +6455,11 @@ static int finish_inode_if_needed(struct send_ctx *sctx, int at_end)
 		if (ret < 0)
 			goto out;
 	}
+	if (sctx->cur_inode_needs_verity) {
+		ret = process_verity(sctx);
+		if (ret < 0)
+			goto out;
+	}
 
 	ret = send_capabilities(sctx);
 	if (ret < 0)
@@ -6785,6 +6868,18 @@ static int changed_extent(struct send_ctx *sctx,
 	return ret;
 }
 
+static int changed_verity(struct send_ctx *sctx,
+			  enum btrfs_compare_tree_result result)
+{
+	int ret = 0;
+
+	if (!sctx->cur_inode_new_gen && !sctx->cur_inode_deleted) {
+		if (result == BTRFS_COMPARE_TREE_NEW)
+			sctx->cur_inode_needs_verity = true;
+	}
+	return ret;
+}
+
 static int dir_changed(struct send_ctx *sctx, u64 dir)
 {
 	u64 orig_gen, new_gen;
@@ -6939,6 +7034,9 @@ static int changed_cb(struct btrfs_path *left_path,
 			ret = changed_xattr(sctx, result);
 		else if (key->type == BTRFS_EXTENT_DATA_KEY)
 			ret = changed_extent(sctx, result);
+		else if (key->type == BTRFS_VERITY_DESC_ITEM_KEY &&
+			 key->offset == 0)
+			ret = changed_verity(sctx, result);
 	}
 
 out:
@@ -8036,6 +8134,7 @@ long btrfs_ioctl_send(struct inode *inode, struct btrfs_ioctl_send_args *arg)
 		kvfree(sctx->clone_roots);
 		kfree(sctx->send_buf_pages);
 		kvfree(sctx->send_buf);
+		kvfree(sctx->verity_descriptor);
 
 		name_cache_free(sctx);
 
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 4bb4e6a638cb..0a4537775e0c 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -92,8 +92,11 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_ENCODED_WRITE	= 25,
 	BTRFS_SEND_C_MAX_V2		= 25,
 
+	/* Version 3 */
+	BTRFS_SEND_C_ENABLE_VERITY	= 26,
+	BTRFS_SEND_C_MAX_V3		= 26,
 	/* End */
-	BTRFS_SEND_C_MAX		= 25,
+	BTRFS_SEND_C_MAX		= 26,
 };
 
 /* attributes in send stream */
@@ -160,8 +163,14 @@ enum {
 	BTRFS_SEND_A_ENCRYPTION		= 31,
 	BTRFS_SEND_A_MAX_V2		= 31,
 
-	/* End */
-	BTRFS_SEND_A_MAX		= 31,
+	/* Version 3 */
+	BTRFS_SEND_A_VERITY_ALGORITHM	= 32,
+	BTRFS_SEND_A_VERITY_BLOCK_SIZE	= 33,
+	BTRFS_SEND_A_VERITY_SALT_DATA	= 34,
+	BTRFS_SEND_A_VERITY_SIG_DATA	= 35,
+	BTRFS_SEND_A_MAX_V3		= 35,
+
+	__BTRFS_SEND_A_MAX		= 35,
 };
 
 long btrfs_ioctl_send(struct inode *inode, struct btrfs_ioctl_send_args *arg);
diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 90eb5c2830a9..ee00e33c309e 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -659,8 +659,7 @@ static int btrfs_end_enable_verity(struct file *filp, const void *desc,
  *
  * Returns the size on success or a negative error code on failure.
  */
-static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
-				       size_t buf_size)
+int btrfs_get_verity_descriptor(struct inode *inode, void *buf, size_t buf_size)
 {
 	u64 true_size;
 	int ret = 0;
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 629785c95007..dbe1ce5b450a 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -70,8 +70,6 @@ struct fsverity_info {
 	const struct inode *inode;
 };
 
-/* Arbitrary limit to bound the kmalloc() size.  Can be changed. */
-#define FS_VERITY_MAX_DESCRIPTOR_SIZE	16384
 
 #define FS_VERITY_MAX_SIGNATURE_SIZE	(FS_VERITY_MAX_DESCRIPTOR_SIZE - \
 					 sizeof(struct fsverity_descriptor))
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 7af030fa3c36..40f14e5fed9d 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -22,6 +22,9 @@
  */
 #define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
 
+/* Arbitrary limit to bound the kmalloc() size.  Can be changed. */
+#define FS_VERITY_MAX_DESCRIPTOR_SIZE	16384
+
 /* Verity operations for filesystems */
 struct fsverity_operations {
 
-- 
2.37.0

