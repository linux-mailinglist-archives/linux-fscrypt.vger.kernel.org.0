Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97AF74C798
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjGISyB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGISyB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:01 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FC010C;
        Sun,  9 Jul 2023 11:53:59 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8207180AE0;
        Sun,  9 Jul 2023 14:53:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928839; bh=upAy56A6l083KyT4V+A+qKKwtlUP/4wnRhbs0dAxB8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuXsmHgFWlrzO2314RpQcc4kzdiaEGwrKlAmX7b6YNCjJdoSEfqmkDcNAsveUGDa/
         rgHJkbRQxjSCWvzH1LRr+mYvIDMIPurTiPhbFC0RgNuEG+1F/kmZCDdAoSPelg2KVZ
         cpYkPzgVvBi8rHt4v4boZGVwUkAjQaeR66EiOQORTCGCJWiXymm1+y85ttDVuYyZ0I
         AEXFPyBp0KA+fTrmCmxL+Tlp+u2utfC4QC2YVciGu7zkLuMB5DBykfP3/AqTdJ6ZKy
         6bPFTHwYolWBPolkQYIdC5yW573KGU1qBtujNNPsv3cE95dhb0YhR4TniYM7G+mErt
         66zzOZCK0lkKQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 06/14] fscrypt: allow infos to be owned by extents
Date:   Sun,  9 Jul 2023 14:53:39 -0400
Message-Id: <9f21224a6ab1751b2ee9c419446033bec4351410.1688927487.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688927487.git.sweettea-kernel@dorminy.me>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 fs/crypto/keysetup.c        | 49 ++++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 260635e8b558..1674e66e72e3 100644
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
index 7469b2d8ac87..29565338d9c0 100644
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
@@ -640,7 +645,11 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (!crypt_info)
 		return -ENOMEM;
 
-	crypt_info->ci_inode = inode;
+	if (fscrypt_uses_extent_encryption(inode) && info_for_extent)
+		crypt_info->ci_info_ptr = info_ptr;
+	else
+		crypt_info->ci_inode = inode;
+
 	crypt_info->ci_sb = inode->i_sb;
 	crypt_info->ci_policy = *policy;
 	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
@@ -656,6 +665,12 @@ fscrypt_setup_encryption_info(struct inode *inode,
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
@@ -701,7 +716,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	 * fscrypt_get_info().  I.e., here we publish ->i_crypt_info with a
 	 * RELEASE barrier so that other tasks can ACQUIRE it.
 	 */
-	if (cmpxchg_release(&inode->i_crypt_info, NULL, crypt_info) == NULL) {
+	if (cmpxchg_release(info_ptr, NULL, crypt_info) == NULL) {
 		/*
 		 * We won the race and set ->i_crypt_info to our crypt_info.
 		 * Now link it into the master key's inode list.
@@ -735,7 +750,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
  *		       %false unless the operation being performed is needed in
  *		       order for files (or directories) to be deleted.
  *
- * Set up ->i_crypt_info, if it hasn't already been done.
+ * Set up inode->i_crypt_info, if it hasn't already been done.
  *
  * Note: unless ->i_crypt_info is already set, this isn't %GFP_NOFS-safe.  So
  * generally this shouldn't be called from within a filesystem transaction.
@@ -747,8 +762,9 @@ fscrypt_setup_encryption_info(struct inode *inode,
 int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 {
 	int res;
-	union fscrypt_context ctx = { 0 };
+	union fscrypt_context ctx;
 	union fscrypt_policy policy;
+	const u8 *nonce;
 
 	if (fscrypt_has_encryption_key(inode))
 		return 0;
@@ -756,7 +772,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 	if (fscrypt_uses_extent_encryption(inode)) {
 		/*
 		 * Nothing will be encrypted with this info, so we can borrow
-		 * the parent (dir) inode's policy and use a zero nonce.
+		 * the parent (dir) inode's policy and nonce.
 		 */
 		struct dentry *dentry = d_find_any_alias(inode);
 		struct dentry *parent_dentry = dget_parent(dentry);
@@ -789,6 +805,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 				     "Unrecognized or corrupt encryption context");
 			return res;
 		}
+		nonce = fscrypt_context_nonce(&ctx);
 	}
 
 	if (!fscrypt_supported_policy(&policy, inode)) {
@@ -797,10 +814,10 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
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
@@ -834,7 +851,8 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 			      bool *encrypt_ret)
 {
 	const union fscrypt_policy *policy;
-	u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+	u8 nonce_bytes[FSCRYPT_FILE_NONCE_SIZE];
+	const u8 *nonce;
 
 	policy = fscrypt_policy_to_inherit(dir);
 	if (policy == NULL)
@@ -856,10 +874,17 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 
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
2.40.1

