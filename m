Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C701D755A46
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjGQDxW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjGQDxF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:05 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B651B0;
        Sun, 16 Jul 2023 20:53:05 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 969FB83411;
        Sun, 16 Jul 2023 23:53:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565984; bh=ygx6Fucsv/PfbNluCySqHdaXBDBAud2k2FS6o3SlCkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KYKMgYcOCwy60pGoSY9aQclg6dMdez1XxSc98Rj3St5H0X+A/xSTtmesMNMb1lofD
         FkfPLi5asv/Nzd8hNN1P//s5eyvR7YpijTc4FDr2G6oslix+NHd2X2aQvHPDjR8Eg8
         C7EEHIoMvTdjhDr+AlZov6ezShdEAm0vTnnH7jNG4JwIeUBb3DtZLa9QVlVWWQnim0
         dooYZURvCPV7yWDwHr4rRKphaMSFoKKQ2HDjIwJxCVU5C6FxNGo+kAF0Uz1Z192++m
         NfzyKOC5T6tEEod+iCpPXuH/mb562276vfduWhfNmH3znBuHyNEQgO/lDlOrDTqs52
         ryUzCx8bqVkFg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 08/17] btrfs: use correct name hash for nokey names
Date:   Sun, 16 Jul 2023 23:52:39 -0400
Message-Id: <37d94eb5c0209049165ccba38814d3f368fd4402.1689564024.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1689564024.git.sweettea-kernel@dorminy.me>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For encrypted or unencrypted names, we calculate the offset for the dir
item by hashing the name for the dir item. However, this doesn't work
for a long nokey name, where we do not have the complete ciphertext.
Instead, fscrypt stores the filesystem-provided hash in the nokey name,
and we can extract it from the fscrypt_name structure in such a case.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/dir-item.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index da95ae411d72..87993b19cd9d 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -257,8 +257,12 @@ struct btrfs_dir_item *btrfs_lookup_dir_item_fname(struct btrfs_trans_handle *tr
 
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
-- 
2.40.1

