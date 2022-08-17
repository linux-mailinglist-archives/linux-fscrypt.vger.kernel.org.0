Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B31A5971FC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbiHQOur (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237148AbiHQOun (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:43 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85303E749;
        Wed, 17 Aug 2022 07:50:42 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 2C31C80A9D;
        Wed, 17 Aug 2022 10:50:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747842; bh=COQBy9pOcpCvnrHMZE0Cv+NvvD5RaLx8uFecu+F6YvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWDAkMKB4TSwXHzok5EXjvuxfI4umyMCrzYvyklWAJZc42UvDFTKhbcjq4XXCIp08
         ZsfZ/5gHhfR0hKF6P7pnrXkROD9RAFVhRAuJl3QshDNTIyASQBygHTZqK4xkUy/0fC
         Lw+otxkemZ2Cvvd1jqJyAB+8VvQQVmfS6rlBOd0uCqeU1o4t1t6hjX/w1ZDYPkj0Yo
         6tT7JedK8m63IGviBK0cjAcgQwmHlYjD7bJnSn9ZlIRozfbSigBTJSQLax2teeRN0D
         kQqCNSa2eLmn4oUBsdd04F0fB1euvkxS5DtPlmFOdU26pPQUokuDOGIpKKYkR/Um2b
         tOJLl416ErV8A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 11/21] btrfs: add fscrypt operation table to superblock
Date:   Wed, 17 Aug 2022 10:49:55 -0400
Message-Id: <04ce4773ce1b1dd14eca4783dfe2439f44e77653.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

To use fscrypt_prepare_new_inode(), the superblock must have fscrypt
operations registered.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/fscrypt.c | 3 +++
 fs/btrfs/fscrypt.h | 1 +
 fs/btrfs/super.c   | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 2ed844dd61d0..9829d280a6bc 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -30,3 +30,6 @@ bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
 			     de_name_len - sizeof(nokey_name->bytes), digest);
 	return !memcmp(digest, nokey_name->sha256, sizeof(digest));
 }
+
+const struct fscrypt_operations btrfs_fscrypt_ops = {
+};
diff --git a/fs/btrfs/fscrypt.h b/fs/btrfs/fscrypt.h
index 7f24d12e6ee0..07884206c8a1 100644
--- a/fs/btrfs/fscrypt.h
+++ b/fs/btrfs/fscrypt.h
@@ -22,4 +22,5 @@ static bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
 }
 #endif
 
+extern const struct fscrypt_operations btrfs_fscrypt_ops;
 #endif /* BTRFS_FSCRYPT_H */
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 55af04fae075..e017e976c679 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -47,6 +47,8 @@
 #include "tests/btrfs-tests.h"
 #include "block-group.h"
 #include "discard.h"
+#include "fscrypt.h"
+
 #include "qgroup.h"
 #include "raid56.h"
 #define CREATE_TRACE_POINTS
@@ -1443,6 +1445,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	sb->s_vop = &btrfs_verityops;
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
+	fscrypt_set_ops(sb, &btrfs_fscrypt_ops);
 	sb->s_time_gran = 1;
 #ifdef CONFIG_BTRFS_FS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
-- 
2.35.1

