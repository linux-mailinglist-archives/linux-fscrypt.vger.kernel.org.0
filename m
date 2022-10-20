Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47885606695
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJTQ7s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJTQ7r (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:47 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03263868A;
        Thu, 20 Oct 2022 09:59:38 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 96BBA811D9;
        Thu, 20 Oct 2022 12:59:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285177; bh=1u0d8iP5nfqxQg851foxOJPhSz2wPJ2duDKUPLVO/Bw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mluFgKxcZyleY2OehJya5oT3wZ+22RsQ3dBdEHWlNs78ANbd+JZI+MY01l9QjI9WJ
         KGHGb9YZSkz72Pk2EfZERiVOon1Wr12Lww1BS2Vgjraxs3TacCYQmIW0Q6gB6/dgS8
         ww6a2mprV6c263YfSh0FZKzHk3ZBy+wz9fGOF8728kliqFfiv8EKycYqkhaSIwtDwM
         nOeKyUBTgaL2n4tXDK271hpxy+9Whhr4V8jiIrQbNSl2Z8Dnpnbo8bqs+r7+3Mfz9a
         rI9Yf5QGAr9owIxRZ2sy9Rw6y2kBVodc6DUC25MKHA9yLYsMkdiVHdkJNvG1Av61tK
         IyO26SLm81NrA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 20/22] btrfs: adapt lookup for partially encrypted directories
Date:   Thu, 20 Oct 2022 12:58:39 -0400
Message-Id: <b9ed56c4b9e254f10ea296dc013fb9a93f9b66e3.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

With the possibility of partially encrypted directories, lookup needs to
try both the unencrypted and encrypted names.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/dir-item.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index d49bc19b91da..dc95ac987006 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -469,21 +469,40 @@ struct btrfs_dir_item *btrfs_match_dir_item_fname(struct btrfs_fs_info *fs_info,
 	u32 cur = 0;
 	u32 this_len;
 	struct extent_buffer *leaf;
+	bool encrypted = (name->crypto_buf.name != NULL);
+	struct fscrypt_name unencrypted_name;
+
+	if (encrypted) {
+		unencrypted_name = (struct fscrypt_name){
+			.usr_fname = name->usr_fname,
+			.disk_name = {
+				.name = (unsigned char *)name->usr_fname->name,
+				.len = name->usr_fname->len,
+			},
+		};
+	}
 
 	leaf = path->nodes[0];
 	dir_item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_dir_item);
 
 	total_len = btrfs_item_size(leaf, path->slots[0]);
 	while (cur < total_len) {
-		this_len = sizeof(*dir_item) +
-			btrfs_dir_name_len(leaf, dir_item) +
+		u64 dir_name_len = btrfs_dir_name_len(leaf, dir_item);
+
+		this_len = sizeof(*dir_item) + dir_name_len +
 			btrfs_dir_data_len(leaf, dir_item);
 		name_ptr = (unsigned long)(dir_item + 1);
 
 		if (btrfs_fscrypt_match_name(name, leaf, name_ptr,
-					     btrfs_dir_name_len(leaf, dir_item)))
+					     dir_name_len))
 			return dir_item;
 
+		if (encrypted &&
+		    btrfs_fscrypt_match_name(&unencrypted_name, leaf,
+					     name_ptr, dir_name_len)) {
+			return dir_item;
+		}
+
 		cur += this_len;
 		dir_item = (struct btrfs_dir_item *)((char *)dir_item +
 						     this_len);
-- 
2.35.1

