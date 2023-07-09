Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B7274C79A
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjGISyD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGISyD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:03 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF6E124;
        Sun,  9 Jul 2023 11:54:01 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 182AB80B04;
        Sun,  9 Jul 2023 14:54:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928841; bh=c0ZpFqyAVXIr8pO5aROXx6op1NfcoKbP2yZeD+lzIGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H8BiDPA9T8A5pqEkHyvKxUKijHC4H/Xzcayi3WwzqrwHiykTEpBM4IjLEQum//i4e
         ZVPxp9mRSTZ/Ikmx0pR55AF3z21EMfzqz40gFphILiNwuwF5SfHgo9wd6QMCgAEmJO
         eZxHbXIv1wFlBN49G0uXjuC2igDZ1mZ85UtrkUgJgnkc586nefjGdsZAnEiszIjmfm
         ExlCtO/ajRH5QmWZXtMjVIigx6zX+e88gfOW1b7dMm4MEq6GatIhJ8sAsActydUoDU
         6yyKK57fnN+gPzRK6gukxOJ1kVTglX2g9R2uZuxFnYFnzcnKyOdz+eA8gDLgsZppaj
         LvJuG26nwysvw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 07/14] fscrypt: notify per-extent infos if master key vanishes
Date:   Sun,  9 Jul 2023 14:53:40 -0400
Message-Id: <6fa7d32a149f91be04ce1517ec6987318220ccbd.1688927487.git.sweettea-kernel@dorminy.me>
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

When fscrypt_infos can be owned by an extent, we need some way to
attempt to evict the extent infos in the same way we evict inodes.
This change adds a function pointer to allow a filesystem to optionally
provide a way to evict extents; locking if needed must be handled by the
filesystem.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keyring.c     | 11 ++++++++++-
 include/linux/fscrypt.h |  9 +++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 7cbb1fd872ac..0aad825087c1 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -875,6 +875,16 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 
 	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
 		inode = ci->ci_inode;
+		if (!inode) {
+			if (!ci->ci_sb->s_cop->forget_extent_info)
+				continue;
+
+			spin_unlock(&mk->mk_decrypted_inodes_lock);
+			ci->ci_sb->s_cop->forget_extent_info(ci->ci_info_ptr);
+			spin_lock(&mk->mk_decrypted_inodes_lock);
+			continue;
+		}
+
 		spin_lock(&inode->i_lock);
 		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
 			spin_unlock(&inode->i_lock);
@@ -887,7 +897,6 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
 		shrink_dcache_inode(inode);
 		iput(toput_inode);
 		toput_inode = inode;
-
 		spin_lock(&mk->mk_decrypted_inodes_lock);
 	}
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index c895b12737a1..378a1f41c62f 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -129,6 +129,15 @@ struct fscrypt_operations {
 	 */
 	bool (*empty_dir)(struct inode *inode);
 
+	/*
+	 * Inform the filesystem that a particular extent must forget its
+	 * fscrypt_info (for instance, for a key removal).
+	 *
+	 * @info_ptr: a pointer to the location storing the fscrypt_info pointer
+	 *            within the opaque extent whose info is to be freed
+	 */
+	void (*forget_extent_info)(struct fscrypt_info **info_ptr);
+
 	/*
 	 * Check whether the filesystem's inode numbers and UUID are stable,
 	 * meaning that they will never be changed even by offline operations
-- 
2.40.1

