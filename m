Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4636B7C4196
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343941AbjJJUls (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbjJJUll (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:41 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BA4F1
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:37 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-5a2536adaf3so75234617b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970496; x=1697575296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDlZH9qthcW82Qll/N8PtWNZ+HAtcElgL4HleKPl0K8=;
        b=OfjMT72y9sTlQD5vC8E7t/FmzGMKx7jvZt6u2cg/pHZhg4NhByCfaZY2L1vKHFRUlx
         0uabjOIE8pmM8gto/EW202BLCYgf/nkOf79JMzvL6cA1InwqcGXduWuw0d2A234UXaiX
         r3eNuXV6XU2yl26YnbBtwvkGiWq7C2e5P/JHHgeMlNEozNOGD6s7wfvszDrSRR25fS1k
         xhn1zCwQxac0UuRPwkIPAqiXhY3uwJJPY+rpOOx0HKkhUsh5asuRKMH7a0C6EZTJSdHC
         xKqlWGcGx2YNQXaYZengPiVQfr3qovXhmtqUm+x7FE1QYLbM/KJ+unqWZlXlpK1s8MNy
         n/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970496; x=1697575296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UDlZH9qthcW82Qll/N8PtWNZ+HAtcElgL4HleKPl0K8=;
        b=d+/kl7ItyY/vHwaGNoLP26hckwmZwteytAq1efE+PBvaHrpibt7OHX6pEFabwoRXVp
         mhKPOa1WR/urZvdfd/gOtmujSwfEhhUqNOjWLaFrPEEccJTM0xjMsRbCAWvoiB8Y1Yfr
         1o21G7u79+riWxJp05cCySdgjiCq0Su+Rr25lSkChN6llJH/LIzFLHX0FPDQNWt0PWwi
         L4h8Sj0+UiikUWBD5qIEqj2CJIFtIDt2RxSNEsIizRosOmDlyP+P7d7qVVfU804PJqAu
         CEvmo33HXSyP6Ld2hFE2wRSTlnlQ9snlpV7O4H4Ts5WzFotS3tuwKk/sCLlkwfUD8tmY
         KaDA==
X-Gm-Message-State: AOJu0Yyd2MuF3h9pFJhcSWxWgMWbw89u6xNzqxnNIPC8K4KVnyS6Wdmx
        EYLoe3+7gf8zy0VLb9+ZuJ2ioIzTVYURcHPVB6ljsg==
X-Google-Smtp-Source: AGHT+IFbidE243+FsCFNoU0+NDimYRSNe0NqDe1FQUB69Xp0KLGt12SaQc4Z5+m710j4wTVvELOuEA==
X-Received: by 2002:a0d:cbd3:0:b0:578:5e60:dcc9 with SMTP id n202-20020a0dcbd3000000b005785e60dcc9mr19163026ywd.10.1696970496405;
        Tue, 10 Oct 2023 13:41:36 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id j131-20020a816e89000000b005956b451fb8sm4616426ywc.100.2023.10.10.13.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:35 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 28/36] btrfs: pass through fscrypt_extent_info to the file extent helpers
Date:   Tue, 10 Oct 2023 16:40:43 -0400
Message-ID: <e62e0ed2d6b090472791cc69d6160329f8028d54.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
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

Now that we have the fscrypt_extnet_info in all of the supporting
structures, pass this through and set the file extent encryption bit
accordingly from the supporting structures.  In subsequent patches code
will be added to populate these appropriately.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c    | 18 +++++++++++-------
 fs/btrfs/tree-log.c |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 03bc9f41bd33..87b38be47d0b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2882,7 +2882,9 @@ int btrfs_writepage_cow_fixup(struct page *page)
 }
 
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-				       struct btrfs_inode *inode, u64 file_pos,
+				       struct btrfs_inode *inode,
+				       struct fscrypt_extent_info *fscrypt_info,
+				       u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
 				       const bool update_inode_bytes,
 				       u64 qgroup_reserved)
@@ -3014,8 +3016,7 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_file_extent_num_bytes(&stack_fi, num_bytes);
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, ram_bytes);
 	btrfs_set_stack_file_extent_compression(&stack_fi, oe->compress_type);
-	btrfs_set_stack_file_extent_encryption(&stack_fi,
-					       BTRFS_ENCRYPTION_NONE);
+	btrfs_set_stack_file_extent_encryption(&stack_fi, oe->encryption_type);
 	/* Other encoding is reserved and always 0 */
 
 	/*
@@ -3029,8 +3030,9 @@ static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 			     test_bit(BTRFS_ORDERED_TRUNCATED, &oe->flags);
 
 	return insert_reserved_file_extent(trans, BTRFS_I(oe->inode),
-					   oe->file_offset, &stack_fi,
-					   update_inode_bytes, oe->qgroup_rsv);
+					   oe->fscrypt_info, oe->file_offset,
+					   &stack_fi, update_inode_bytes,
+					   oe->qgroup_rsv);
 }
 
 /*
@@ -9662,6 +9664,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 				       struct btrfs_trans_handle *trans_in,
 				       struct btrfs_inode *inode,
 				       struct btrfs_key *ins,
+				       struct fscrypt_extent_info *fscrypt_info,
 				       u64 file_offset)
 {
 	struct btrfs_file_extent_item stack_fi;
@@ -9683,6 +9686,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 	btrfs_set_stack_file_extent_ram_bytes(&stack_fi, len);
 	btrfs_set_stack_file_extent_compression(&stack_fi, BTRFS_COMPRESS_NONE);
 	btrfs_set_stack_file_extent_encryption(&stack_fi,
+					       fscrypt_info ? BTRFS_ENCRYPTION_FSCRYPT :
 					       BTRFS_ENCRYPTION_NONE);
 	/* Other encoding is reserved and always 0 */
 
@@ -9691,7 +9695,7 @@ static struct btrfs_trans_handle *insert_prealloc_file_extent(
 		return ERR_PTR(qgroup_released);
 
 	if (trans) {
-		ret = insert_reserved_file_extent(trans, inode,
+		ret = insert_reserved_file_extent(trans, inode, fscrypt_info,
 						  file_offset, &stack_fi,
 						  true, qgroup_released);
 		if (ret)
@@ -9785,7 +9789,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 
 		last_alloc = ins.offset;
 		trans = insert_prealloc_file_extent(trans, BTRFS_I(inode),
-						    &ins, cur_offset);
+						    &ins, NULL, cur_offset);
 		/*
 		 * Now that we inserted the prealloc extent we can finally
 		 * decrement the number of reservations in the block group.
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6cdb924944d1..85267cf1f372 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4629,7 +4629,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	u64 block_len;
 	int ret;
 	size_t fscrypt_context_size = 0;
-	u8 encryption = BTRFS_ENCRYPTION_NONE;
+	u8 encryption = em->encryption_type;
 
 	btrfs_set_stack_file_extent_generation(&fi, trans->transid);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
-- 
2.41.0

