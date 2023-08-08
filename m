Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3EB27743AD
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbjHHSIT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjHHSHw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:52 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBD615C796;
        Tue,  8 Aug 2023 10:08:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BE4B383549;
        Tue,  8 Aug 2023 13:08:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514530; bh=30Kvlvez90KN6W/1ONh+BWInubmHeWXe255twvMwCxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaBI+xYcNIDamNIhrFVD0jVPQoECum0RVXnj/tXPHkZkalXn0yR1K8gcAN/AoLUzY
         UgYOXffc9cKgVU2ywf/TfIVnr7wXj50sAsTulZ7bnNEmGUNRLuf28krGNDNrhydVay
         eU4hgFh2XVjM/hHEzr/uNKGsPnuhO0TvrTymrvJNjNW2ENgA4As4GbNEIhbZUka22c
         dzGOik6oafCyDDlxLQ4+TdE3EjGG077o32U3kpKzVBqnNNbnq/addsdwPdoaCu4SD/
         YcgjhfkPX7gai2cGE91rROC2iWfRtHjD4spixJz4YCT5ObtwiU6jqR/S0lUUTJHVSX
         vGEVpaBQ8ljhA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 06/16] fscrypt: allow infos to be owned by extents
Date:   Tue,  8 Aug 2023 13:08:23 -0400
Message-ID: <6f3c4013a48c973a913fab08757fc2a4437ebf75.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In order to notify extents when their info is part of a master key which
is going away, the fscrypt_info must have a backpointer to the extent
somehow. Similarly, if a fscrypt_info is owned by an extent, the info
must not have a pointer to an inode -- multiple inodes may reference a
extent, and the first inode to cause an extent's creation may have a
lifetime much shorter than the extent, so there is no inode pointer
safe to track in an extent-owned info. Therefore, this adds a new
pointer for extent-owned infos to track their extent and updates
fscrypt_setup_encryption_info() accordingly.

Since it's simple to track the piece of extent memory pointing to the
info, and for the extent to then go from such a pointer to the whole
extent via container_of(), we store that. Although some sort of generic
void * or some artificial fscrypt_extent embedded structure would also
work, those would require additional plumbing which doesn't seem
strictly required or clarifying.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  6 +++++
 fs/crypto/keysetup.c        | 45 ++++++++++++++++++++++++++++---------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index df1c5ae82d85..1244797cd8a9 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -241,6 +241,12 @@ struct fscrypt_info {
 	/* Back-pointer to the inode */
 	struct inode *ci_inode;
 
+	/*
+	 * Back-pointer to the info pointer in the extent, for infos owned by
+	 * an extent.
+	 */
+	struct fscrypt_info **ci_info_ptr;
+
 	/* The superblock of the filesystem to which this info pertains */
 	struct super_block *ci_sb;
 
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 9b3806ab7ccb..c72f9015ed35 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -625,12 +625,17 @@ static int
 fscrypt_setup_encryption_info(struct inode *inode,
 			      const union fscrypt_policy *policy,
 			      const u8 nonce[FSCRYPT_FILE_NONCE_SIZE],
-			      bool need_dirhash_key)
+			      bool need_dirhash_key,
+			      struct fscrypt_info **info_ptr)
 {
 	struct fscrypt_info *crypt_info;
 	struct fscrypt_mode *mode;
 	struct fscrypt_master_key *mk = NULL;
 	int res;
+	bool info_for_extent = !!info_ptr;
+
+	if (!info_ptr)
+		info_ptr = &inode->i_crypt_info;
 
 	res = fscrypt_initialize(inode->i_sb);
 	if (res)
@@ -640,6 +645,9 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (!crypt_info)
 		return -ENOMEM;
 
+	if (fscrypt_uses_extent_encryption(inode) && info_for_extent)
+		crypt_info->ci_info_ptr = info_ptr;
+
 	crypt_info->ci_inode = inode;
 	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
@@ -656,6 +664,12 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	res = fscrypt_select_encryption_impl(crypt_info);
 	if (res)
 		goto out;
+	if (info_for_extent && !fscrypt_using_inline_encryption(crypt_info)) {
+		fscrypt_warn(inode,
+			     "extent encryption requires inlinecrypt mount option");
+		res = -EINVAL;
+		goto out;
+	}
 
 	res = find_and_lock_master_key(crypt_info, &mk);
 	if (res)
@@ -701,7 +715,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
 	 * RELEASE barrier so that other tasks can ACQUIRE it.
 	 */
-	if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
+	if (cmpxchg_release(info_ptr, NULL, crypt_info) == NULL) {
 		/*
 		 * We won the race and set ->i_crypt_info to our crypt_info.
 		 * Now link it into the master key's inode list.
@@ -755,7 +769,7 @@ static bool get_parent_policy_and_nonce(struct inode *inode,
  *		       %false unless the operation being performed is needed in
  *		       order for files (or directories) to be deleted.
  *
- * Set up ->i_crypt_info, if it hasn't already been done.
+ * Set up inode->i_crypt_info, if it hasn't already been done.
  *
  * Note: unless ->i_crypt_info is already set, this isn't %GFP_NOFS-safe.  So
  * generally this shouldn't be called from within a filesystem transaction.
@@ -767,7 +781,7 @@ static bool get_parent_policy_and_nonce(struct inode *inode,
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 {
 	int res;
-	union fscrypt_context ctx = { 0 };
+	union fscrypt_context ctx;
 	union fscrypt_policy policy;
 	const u8 *nonce;
 	u8 nonce_bytes[FSCRYPT_FILE_NONCE_SIZE];
@@ -778,7 +792,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 	if (fscrypt_uses_extent_encryption(inode)) {
 		/*
 		 * Nothing will be encrypted with this info, so we can borrow
-		 * the parent (dir) inode's policy and use a zero nonce.
+		 * the parent (dir) inode's policy and nonce.
 		 */
 		if (!get_parent_policy_and_nonce(inode, &policy, nonce_bytes))
 			return 0;
@@ -800,6 +814,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 				     "Unrecognized or corrupt encryption context");
 			return res;
 		}
+		nonce = fscrypt_context_nonce(&ctx);
 	}
 
 	if (!fscrypt_supported_policy(&policy, inode)) {
@@ -808,10 +823,10 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 		return -EINVAL;
 	}
 
-	res = fscrypt_setup_encryption_info(inode, &policy,
-					    fscrypt_context_nonce(&ctx),
+	res = fscrypt_setup_encryption_info(inode, &policy, nonce,
 					    IS_CASEFOLDED(inode) &&
-					    S_ISDIR(inode->i_mode));
+					    S_ISDIR(inode->i_mode),
+					    NULL);
 
 	if (res == -ENOPKG && allow_unsupported) /* Algorithm unavailable? */
 		res = 0;
@@ -845,7 +860,8 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 			      bool *encrypt_ret)
 {
 	const union fscrypt_policy *policy;
-	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+	u8 nonce_bytes[FSCRYPT_FILE_NONCE_SIZE];
+	const u8 *nonce;
 
 	policy = fscrypt_policy_to_inherit(dir);
 	if (policy == NULL)
@@ -867,10 +883,17 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 
 	*encrypt_ret = true;
 
-	get_random_bytes(nonce, FSCRYPT_FILE_NONCE_SIZE);
+	if (fscrypt_uses_extent_encryption(inode)) {
+		nonce = dir->i_crypt_info->ci_nonce;
+	} else {
+		get_random_bytes(nonce_bytes, FSCRYPT_FILE_NONCE_SIZE);
+		nonce = nonce_bytes;
+	}
+
 	return fscrypt_setup_encryption_info(inode, policy, nonce,
 					     IS_CASEFOLDED(dir) &&
-					     S_ISDIR(inode->i_mode));
+					     S_ISDIR(inode->i_mode),
+					     NULL);
 }
 EXPORT_SYMBOL_GPL(fscrypt_prepare_new_inode);
 
-- 
2.41.0

