Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DD763B93A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Nov 2022 05:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235463AbiK2Exf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 23:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235453AbiK2ExQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 23:53:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB78D20373;
        Mon, 28 Nov 2022 20:53:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EF05B81029;
        Tue, 29 Nov 2022 04:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EFCC4347C;
        Tue, 29 Nov 2022 04:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669697587;
        bh=ey9UXzvfqx/BSuHIRwR61JJeRJiLXpY0AsvQVwSg0Gc=;
        h=From:To:Cc:Subject:Date:From;
        b=rVvj/pgXaTPWLMK8r2hEwLgg5PadZPPKXfXTRGeLsGzN1VqDxnQ63WPWzR6wRghNK
         01id4w6fKWcgdQPqSoRN+O2v5hYh151oFi67l7AlZRWCoPiHu8Hz73FlXBmjdFfHxe
         mW1VN2SGO0bEbmMxyRCj35w2588ndC1bSB0npFS7sOEGtiYcarG8ZTeAiaeHKpbQlF
         oSjgJdGcnV4cIawIjOYfWhf8OC/ak9T+zyBHkqZlPDDmGeLAg8opFNtQbBoiFrsxQn
         h2ABX80p9fn84zO/zE/b8rsAeQ+CY6yl7KArVpU4OtURh+SAucLXTX29sDDH39lOpi
         K+snWQ0Hot7ug==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Subject: [PATCH] fsverity: simplify fsverity_get_digest()
Date:   Mon, 28 Nov 2022 20:51:39 -0800
Message-Id: <20221129045139.69803-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of looking up the algorithm by name in hash_algo_name[] to get
its hash_algo ID, just store the hash_algo ID in the fsverity_hash_alg
struct.  Verify at build time that every fsverity_hash_alg has a valid
hash_algo ID with matching digest size.

Remove an unnecessary memset() of the whole digest array to 0 before the
digest is copied into it.

Finally, remove the pr_debug statement.  There is already a pr_debug for
the fsverity digest when the file is opened.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/fsverity_private.h |  5 +++++
 fs/verity/hash_algs.c        |  6 ++++++
 fs/verity/measure.c          | 19 ++-----------------
 3 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index dbe1ce5b450a8..c7fcb855e0682 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -32,6 +32,11 @@ struct fsverity_hash_alg {
 	unsigned int digest_size; /* digest size in bytes, e.g. 32 for SHA-256 */
 	unsigned int block_size;  /* block size in bytes, e.g. 64 for SHA-256 */
 	mempool_t req_pool;	  /* mempool with a preallocated hash request */
+	/*
+	 * The HASH_ALGO_* constant for this algorithm.  This is different from
+	 * FS_VERITY_HASH_ALG_*, which uses a different numbering scheme.
+	 */
+	enum hash_algo algo_id;
 };
 
 /* Merkle tree parameters: hash algorithm, initial hash state, and topology */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index 71d0fccb6d4c4..6f8170cf4ae71 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -16,11 +16,13 @@ struct fsverity_hash_alg fsverity_hash_algs[] = {
 		.name = "sha256",
 		.digest_size = SHA256_DIGEST_SIZE,
 		.block_size = SHA256_BLOCK_SIZE,
+		.algo_id = HASH_ALGO_SHA256,
 	},
 	[FS_VERITY_HASH_ALG_SHA512] = {
 		.name = "sha512",
 		.digest_size = SHA512_DIGEST_SIZE,
 		.block_size = SHA512_BLOCK_SIZE,
+		.algo_id = HASH_ALGO_SHA512,
 	},
 };
 
@@ -324,5 +326,9 @@ void __init fsverity_check_hash_algs(void)
 		 */
 		BUG_ON(!is_power_of_2(alg->digest_size));
 		BUG_ON(!is_power_of_2(alg->block_size));
+
+		/* Verify that there is a valid mapping to HASH_ALGO_*. */
+		BUG_ON(alg->algo_id == 0);
+		BUG_ON(alg->digest_size != hash_digest_size[alg->algo_id]);
 	}
 }
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index e99c00350c28d..5c79ea1b24687 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -65,8 +65,7 @@ EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
  * @alg: (out) pointer to the hash algorithm enumeration
  *
  * Return the file hash algorithm and digest of an fsverity protected file.
- * Assumption: before calling fsverity_get_digest(), the file must have been
- * opened.
+ * Assumption: before calling this, the file must have been opened.
  *
  * Return: 0 on success, -errno on failure
  */
@@ -76,27 +75,13 @@ int fsverity_get_digest(struct inode *inode,
 {
 	const struct fsverity_info *vi;
 	const struct fsverity_hash_alg *hash_alg;
-	int i;
 
 	vi = fsverity_get_info(inode);
 	if (!vi)
 		return -ENODATA; /* not a verity file */
 
 	hash_alg = vi->tree_params.hash_alg;
-	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
-
-	/* convert the verity hash algorithm name to a hash_algo_name enum */
-	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
-	if (i < 0)
-		return -EINVAL;
-	*alg = i;
-
-	if (WARN_ON_ONCE(hash_alg->digest_size != hash_digest_size[*alg]))
-		return -EINVAL;
 	memcpy(digest, vi->file_digest, hash_alg->digest_size);
-
-	pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
-		 hash_digest_size[*alg], digest);
-
+	*alg = hash_alg->algo_id;
 	return 0;
 }

base-commit: f7976d6a8be0efd1fdeb41bbd1828eed795b338d
-- 
2.38.1

