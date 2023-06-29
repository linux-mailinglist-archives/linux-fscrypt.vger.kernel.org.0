Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3FA741CFE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjF2Aet (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjF2Aep (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:34:45 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A3E1FC2;
        Wed, 28 Jun 2023 17:34:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3191580B08;
        Wed, 28 Jun 2023 20:34:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998884; bh=c0ZpFqyAVXIr8pO5aROXx6op1NfcoKbP2yZeD+lzIGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr3nvXEu0O4RY6fAC4+AXC8MPu1n2mgpcJRHW6U5V+D9YVivvApO3b8wxJJ0m0EKt
         uE2ANX2c5EM3+IGxmfQDbsWVGEa1M539K+xubrMGO00i6YQEolaXRFO7ZGEhclxyJn
         w2K3ZzOM5kXFaCuJIvi0tXCLbPM0uWL/1rm1cdn3tz+2VdJc7Vu8a+GRjUJyDRVrcY
         dL2KZIb/4rjKyjuU9qqikEnI+yECzv7+Tn6kerg+bOcgctZDZowBKTBkr3NtE2ardX
         6cEpXuU7e5TL139U/926yBZuRsK3C8txqciDuLYd7sWS/lsWAqbI4aCAoTggYP+qhT
         UeNmcwaWeG7kA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 07/12] fscrypt: notify per-extent infos if master key vanishes
Date:   Wed, 28 Jun 2023 20:29:37 -0400
Message-Id: <0d2d18a27ed7a24cbca6d3fe8b33f6677e541dfd.1687988246.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988246.git.sweettea-kernel@dorminy.me>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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

