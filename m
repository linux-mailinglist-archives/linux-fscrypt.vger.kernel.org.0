Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6E61623D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiKBLyF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiKBLxk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:40 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB86BD1;
        Wed,  2 Nov 2022 04:53:39 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 523A081462;
        Wed,  2 Nov 2022 07:53:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667390019; bh=3UxUdaE8Y3AyL6HiYBztrGBNltkcHDrtYHCOHGCq7MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVca+Uocac4jRQmAsOcPgVRVxNLfHMmpAtoPD7nn/lEWCadlLA/2TZxWCgybqUU3p
         6CtUkTizFzcnSsIQ+ldHR5Ox2pIwc0qJ8Usy0PkhU1RC1NMoCL/7DFWPJ/I5xhjmUM
         oYs5kr7u/9r9NYM4ZFvdYyBD1ztCInIq5tzdb/PehvYaCBDO1ulxqZmxYmymLDoE0k
         tnq3nDiE6F6UBDezcprkLLJQmx+8O/FLpNccSWTWaNEY5FqUGK7YXu2sEcU0WCyoRN
         gSfifJgUMrHhAychPwrN3B3ImkcSKbyYhPPvTcK6VM66VxDS9EgF86E+E69FSgQFxr
         en6g33tY8GHiA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 16/18] btrfs: use correct name hash for nokey names
Date:   Wed,  2 Nov 2022 07:53:05 -0400
Message-Id: <0c127efa18553d7aec7cfdc854800a7b22fe3306.1667389116.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_FILL_THIS_FORM_SHORT autolearn=ham autolearn_force=no version=3.4.6
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
index ce046cdabbe9..70cba4003efa 100644
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
2.37.3

