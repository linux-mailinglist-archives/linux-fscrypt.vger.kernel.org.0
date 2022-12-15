Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652A864D654
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Dec 2022 07:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLOGGZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Dec 2022 01:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLOGGY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Dec 2022 01:06:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468443F04A;
        Wed, 14 Dec 2022 22:06:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7A9F61CF8;
        Thu, 15 Dec 2022 06:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174D3C433EF;
        Thu, 15 Dec 2022 06:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671084382;
        bh=oUUTcNGCxne4bIvsKsWaj+oTN6NR5UQmZDveEZOr+7k=;
        h=From:To:Cc:Subject:Date:From;
        b=QgYs6oa4cNZXmrblrSnFAei9T8fknp9gyrSrfDWrAv16WQQcAWeQFdCyQue8LEf37
         WbDOYX/ftTQw8DIl+QHAn82hAE1gKkKj3sI9Sw5Zn9bSRMLeHHx5qph8ZD7TWmZ8ZA
         1rSC5LnAUz+YLN0jNJTqKtl25UemjMlZ0dcVAtRliQ0STjEarwoET6uOzuMF/jdZNQ
         Kq1OSRRCeE3N3umSPoZmuBx9L4NYFfn9aj4bFAq/S+g+lMblOqmrlsixAIcAV7mNB9
         X8mH7m7BZm0PPuaws4939kx6KQadRASKqIASnTYwNuYpi/zkIF+/kcRWOe3CMXr9UA
         tx6cFNHxaPZLA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] fsverity: remove debug messages and CONFIG_FS_VERITY_DEBUG
Date:   Wed, 14 Dec 2022 22:04:20 -0800
Message-Id: <20221215060420.60692-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

I've gotten very little use out of these debug messages, and I'm not
aware of anyone else having used them.

Indeed, sprinkling pr_debug around is not really a best practice these
days, especially for filesystem code.  Tracepoints are used instead.

Let's just remove these and start from a clean slate.

This change does not affect info, warning, and error messages.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/Kconfig            |  8 --------
 fs/verity/enable.c           | 11 -----------
 fs/verity/fsverity_private.h |  4 ----
 fs/verity/init.c             |  1 -
 fs/verity/open.c             | 21 ++-------------------
 fs/verity/signature.c        |  2 --
 fs/verity/verify.c           | 13 -------------
 7 files changed, 2 insertions(+), 58 deletions(-)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index aad1f1d998b9..a7ffd718f171 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -34,14 +34,6 @@ config FS_VERITY
 
 	  If unsure, say N.
 
-config FS_VERITY_DEBUG
-	bool "FS Verity debugging"
-	depends on FS_VERITY
-	help
-	  Enable debugging messages related to fs-verity by default.
-
-	  Say N unless you are an fs-verity developer.
-
 config FS_VERITY_BUILTIN_SIGNATURES
 	bool "FS Verity builtin signature support"
 	depends on FS_VERITY
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index df6b499bf6a1..ef4df451fce7 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -70,10 +70,6 @@ static int build_merkle_tree_level(struct file *filp, unsigned int level,
 	for (i = 0; i < num_blocks_to_hash; i++) {
 		struct page *src_page;
 
-		if ((pgoff_t)i % 10000 == 0 || i + 1 == num_blocks_to_hash)
-			pr_debug("Hashing block %llu of %llu for level %u\n",
-				 i + 1, num_blocks_to_hash, level);
-
 		if (level == 0) {
 			/* Leaf: hashing a data block */
 			src_page = read_file_data_page(filp, i, &ra,
@@ -263,15 +259,12 @@ static int enable_verity(struct file *filp,
 	 * ->begin_enable_verity() and ->end_enable_verity() using the inode
 	 * lock and only allow one process to be here at a time on a given file.
 	 */
-	pr_debug("Building Merkle tree...\n");
 	BUILD_BUG_ON(sizeof(desc->root_hash) < FS_VERITY_MAX_DIGEST_SIZE);
 	err = build_merkle_tree(filp, &params, desc->root_hash);
 	if (err) {
 		fsverity_err(inode, "Error %d building Merkle tree", err);
 		goto rollback;
 	}
-	pr_debug("Done building Merkle tree.  Root hash is %s:%*phN\n",
-		 params.hash_alg->name, params.digest_size, desc->root_hash);
 
 	/*
 	 * Create the fsverity_info.  Don't bother trying to save work by
@@ -286,10 +279,6 @@ static int enable_verity(struct file *filp,
 		goto rollback;
 	}
 
-	if (arg->sig_size)
-		pr_debug("Storing a %u-byte PKCS#7 signature alongside the file\n",
-			 arg->sig_size);
-
 	/*
 	 * Tell the filesystem to finish enabling verity on the file.
 	 * Serialized with ->begin_enable_verity() by the inode lock.
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index c7fcb855e068..a16038a0ee67 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -8,10 +8,6 @@
 #ifndef _FSVERITY_PRIVATE_H
 #define _FSVERITY_PRIVATE_H
 
-#ifdef CONFIG_FS_VERITY_DEBUG
-#define DEBUG
-#endif
-
 #define pr_fmt(fmt) "fs-verity: " fmt
 
 #include <linux/fsverity.h>
diff --git a/fs/verity/init.c b/fs/verity/init.c
index c98b7016f446..023905151035 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -49,7 +49,6 @@ static int __init fsverity_init(void)
 	if (err)
 		goto err_exit_workqueue;
 
-	pr_debug("Initialized fs-verity\n");
 	return 0;
 
 err_exit_workqueue:
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 81ff94442f7b..12bf2596b173 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -77,10 +77,6 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 	params->log_arity = params->log_blocksize - ilog2(params->digest_size);
 	params->hashes_per_block = 1 << params->log_arity;
 
-	pr_debug("Merkle tree uses %s with %u-byte blocks (%u hashes/block), salt=%*phN\n",
-		 hash_alg->name, params->block_size, params->hashes_per_block,
-		 (int)salt_size, salt);
-
 	/*
 	 * Compute the number of levels in the Merkle tree and create a map from
 	 * level to the starting block of that level.  Level 'num_levels - 1' is
@@ -90,7 +86,6 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 
 	/* Compute number of levels and the number of blocks in each level */
 	blocks = ((u64)inode->i_size + params->block_size - 1) >> log_blocksize;
-	pr_debug("Data is %lld bytes (%llu blocks)\n", inode->i_size, blocks);
 	while (blocks > 1) {
 		if (params->num_levels >= FS_VERITY_MAX_LEVELS) {
 			fsverity_err(inode, "Too many levels in Merkle tree");
@@ -109,8 +104,6 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 	for (level = (int)params->num_levels - 1; level >= 0; level--) {
 		blocks = params->level_start[level];
 		params->level_start[level] = offset;
-		pr_debug("Level %d is %llu blocks starting at index %llu\n",
-			 level, blocks, offset);
 		offset += blocks;
 	}
 
@@ -176,9 +169,6 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 		fsverity_err(inode, "Error %d computing file digest", err);
 		goto out;
 	}
-	pr_debug("Computed file digest: %s:%*phN\n",
-		 vi->tree_params.hash_alg->name,
-		 vi->tree_params.digest_size, vi->file_digest);
 
 	err = fsverity_verify_signature(vi, desc->signature,
 					le32_to_cpu(desc->sig_size));
@@ -343,12 +333,8 @@ int fsverity_file_open(struct inode *inode, struct file *filp)
 	if (!IS_VERITY(inode))
 		return 0;
 
-	if (filp->f_mode & FMODE_WRITE) {
-		pr_debug("Denying opening verity file (ino %lu) for write\n",
-			 inode->i_ino);
+	if (filp->f_mode & FMODE_WRITE)
 		return -EPERM;
-	}
-
 	return ensure_verity_info(inode);
 }
 EXPORT_SYMBOL_GPL(fsverity_file_open);
@@ -365,11 +351,8 @@ EXPORT_SYMBOL_GPL(fsverity_file_open);
  */
 int fsverity_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	if (IS_VERITY(d_inode(dentry)) && (attr->ia_valid & ATTR_SIZE)) {
-		pr_debug("Denying truncate of verity file (ino %lu)\n",
-			 d_inode(dentry)->i_ino);
+	if (IS_VERITY(d_inode(dentry)) && (attr->ia_valid & ATTR_SIZE))
 		return -EPERM;
-	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fsverity_prepare_setattr);
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..e7d3ca919a1e 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -82,8 +82,6 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 		return err;
 	}
 
-	pr_debug("Valid signature for file digest %s:%*phN\n",
-		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
 	return 0;
 }
 
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 961ba248021f..92f36b5522fa 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -91,8 +91,6 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 	if (WARN_ON_ONCE(!PageLocked(data_page) || PageUptodate(data_page)))
 		return false;
 
-	pr_debug_ratelimited("Verifying data page %lu...\n", index);
-
 	/*
 	 * Starting at the leaf level, ascend the tree saving hash pages along
 	 * the way until we find a verified hash page, indicated by PageChecked;
@@ -105,9 +103,6 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 
 		hash_at_level(params, index, level, &hindex, &hoffset);
 
-		pr_debug_ratelimited("Level %d: hindex=%lu, hoffset=%u\n",
-				     level, hindex, hoffset);
-
 		hpage = inode->i_sb->s_vop->read_merkle_tree_page(inode, hindex,
 				level == 0 ? level0_ra_pages : 0);
 		if (IS_ERR(hpage)) {
@@ -122,19 +117,13 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 			memcpy_from_page(_want_hash, hpage, hoffset, hsize);
 			want_hash = _want_hash;
 			put_page(hpage);
-			pr_debug_ratelimited("Hash page already checked, want %s:%*phN\n",
-					     params->hash_alg->name,
-					     hsize, want_hash);
 			goto descend;
 		}
-		pr_debug_ratelimited("Hash page not yet checked\n");
 		hpages[level] = hpage;
 		hoffsets[level] = hoffset;
 	}
 
 	want_hash = vi->root_hash;
-	pr_debug("Want root hash: %s:%*phN\n",
-		 params->hash_alg->name, hsize, want_hash);
 descend:
 	/* Descend the tree verifying hash pages */
 	for (; level > 0; level--) {
@@ -151,8 +140,6 @@ static bool verify_page(struct inode *inode, const struct fsverity_info *vi,
 		memcpy_from_page(_want_hash, hpage, hoffset, hsize);
 		want_hash = _want_hash;
 		put_page(hpage);
-		pr_debug("Verified hash page at level %d, now want %s:%*phN\n",
-			 level - 1, params->hash_alg->name, hsize, want_hash);
 	}
 
 	/* Finally, verify the data page */

base-commit: 041fae9c105ae342a4245cf1e0dc56a23fbb9d3c
-- 
2.38.1

