Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB0C790578
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351622AbjIBF4G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbjIBF4F (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:05 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD1810F4;
        Fri,  1 Sep 2023 22:56:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7C1AA803B8;
        Sat,  2 Sep 2023 01:56:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634162; bh=pNWZ9FSgIarpGMwNEZ5zwQ/hDUlwdOXDex/Vx8GeIk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pllgTrlUtxSzjTR/8jAxq225mCXG+YcwEhheJ8z2zdiFPYLnOym3cPce7KJxqqiXy
         3Uq/vNKO3M97fAuytDP1+KLIWtEGnMr3rc4p1yuDhnqXcbG+dKDXgkb102r4nt5JxU
         WtkkXw6FFRNGWZRBic7MnJ3SuAdxwhDlX8eNyrlr60qZYV7U4Lu9u4fszr1ynzg0Kv
         6VRCqceDfmyQyu8bX6ExdbFMlBDe+iqNYzkKU3o6IFj0N6Jz2liI9Xne5KbmyGMMAy
         eJpnFq5Crzh620R+WhlH//yNkRHVolw+1ZHsz0MpEKDOgNfgHGohNxViTi6pdb+dEa
         fVJy9hCdJ7riw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 07/13] fscrypt: store full fscrypt_contexts for each extent
Date:   Sat,  2 Sep 2023 01:54:25 -0400
Message-ID: <e0263ab5998ddf723b78ed56a545490e482c29b9.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For contrast purposes, this patch contains the entirety of the changes
necessary to switch between lightweight and heavyweight extents. This
patch could be dropped, or rolled into the former change, without
changing anything else.

Lightweight extents relying on their parent inode's context for
key and policy information do take up less disk space. Additionally,
they guarantee that if inode open succeeds, then all extents will be
readable and writeable, matching the current inode-based fscrypt
behavior.

However, heavyweight extents permit greater flexibility for future
extensions:

- Any form of changing the key for a non-empty directory's
  future writes requires that extents have some sort of policy in
  addition to the nonce, which is essentially the contents of the full
  fscrypt_context.
  - This could be approximated using overlayfs writing to a new
    encrypted directory, but this would waste space used by overwritten
    data and makes it very difficult to have nested subvolumes each with
    their own key, so it's very preferable to support this natively in
    btrfs.

- Scrub (verifying checksums) currently iterates over extents,
without interacting with inodes; in an authenticated encryption world,
scrub verifying authentication tags would need to iterate over inodes (a
large departure from the present) or need heavyweight extents storing
the necessary key information.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 20 ++++++++++----------
 fs/crypto/policy.c   |  5 ++---
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 90143377cc61..4146b1380cb5 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -1061,25 +1061,25 @@ int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
 {
 	int res;
 	union fscrypt_context ctx;
-	const union fscrypt_policy *policy;
+	union fscrypt_policy policy;
 
 	if (!fscrypt_has_encryption_key(inode))
 		return -EINVAL;
 
-	if (len != FSCRYPT_FILE_NONCE_SIZE) {
+	memcpy(&ctx, buf, len);
+
+	res = fscrypt_policy_from_context(&policy, &ctx, len);
+	if (res) {
 		fscrypt_warn(inode,
 			     "Unrecognized or corrupt encryption context");
-		return -EINVAL;
+		return res;
 	}
 
-	policy = fscrypt_policy_to_inherit(inode);
-	if (policy == NULL)
-		return 0;
-	if (IS_ERR(policy))
-		return PTR_ERR(policy);
+	if (!fscrypt_supported_policy(&policy, inode))
+		return -EINVAL;
 
-	return fscrypt_setup_extent_info(inode, policy, buf,
-					 info_ptr);
+	return fscrypt_setup_extent_info(inode, &policy,
+					 fscrypt_context_nonce(&ctx), info_ptr);
 }
 EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
 
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index cfbe83aee847..314bb6e97cec 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -778,10 +778,9 @@ EXPORT_SYMBOL_GPL(fscrypt_set_context);
 int fscrypt_set_extent_context(struct fscrypt_extent_info *ci, void *ctx,
 			       size_t len)
 {
-	if (len < FSCRYPT_EXTENT_CONTEXT_MAX_SIZE)
+	if (len < FSCRYPT_SET_CONTEXT_MAX_SIZE)
 		return -EINVAL;
-	memcpy(ctx, ci->info.ci_nonce, FSCRYPT_FILE_NONCE_SIZE);
-	return FSCRYPT_FILE_NONCE_SIZE;
+	return fscrypt_new_context(ctx, &ci->info.ci_policy, ci->info.ci_nonce);
 }
 EXPORT_SYMBOL_GPL(fscrypt_set_extent_context);
 
-- 
2.41.0

