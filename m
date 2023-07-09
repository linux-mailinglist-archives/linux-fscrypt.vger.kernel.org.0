Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D5174C78F
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjGISxy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGISxx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:53 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626AD10C;
        Sun,  9 Jul 2023 11:53:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id CC0B380AE5;
        Sun,  9 Jul 2023 14:53:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928832; bh=Qqcfl53cPmh4OIEbhXCiDyAhbNtCJ6Zoccrgh1oMTys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lE0imX0dIFzNn100yxOe4BhIvK2s9fSIyFlToxPxJyLMYT+pyg/yzmvmHcF0qPJ5z
         c9uF9LRVMNmBmdmiZQMDBAibP9QhK8t/5zE3yfpCQGDnitMwMC9th1GqZZHl5DLnpc
         DYolSFbzkDqv0fJFQWNvL+bvOURjqGlKRVitTPc+oTEGQFBvq8Wmm/lgIeENNBYSvh
         8qSDgdd98wIvQ0uFLwjnMRvXRL1UWkDqu56k8v2WrcfQYt2wHed8UNIdMC70l2fFfn
         FNniyuD8KaUWQw/kRl7rbdQVXUMDZQk0cYdpUZiiVcmRTtAEbcdE8Y0JDwJPrvGNtF
         CMTbJTNTZtGAg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 01/14] fscrypt: factor helper for locking master key
Date:   Sun,  9 Jul 2023 14:53:34 -0400
Message-Id: <8de542dc6ec30ded52713c0e56c14f4ade3d0528.1688927487.git.sweettea-kernel@dorminy.me>
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

When we are making extent infos, we'll need to lock the master key in
more places, so go on and factor out a helper.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index a19650f954e2..c3d3da5da449 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -106,7 +106,18 @@ select_encryption_mode(const union fscrypt_policy *policy,
 	return ERR_PTR(-EINVAL);
 }
 
-/* Create a symmetric cipher object for the given encryption mode and key */
+static int lock_master_key(struct fscrypt_master_key *mk)
+{
+	down_read(&mk->mk_sem);
+
+	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
+	if (!is_master_key_secret_present(&mk->mk_secret))
+		return -ENOKEY;
+
+	return 0;
+}
+
+/* Create a symmetric cipher object for the given encryption mode */
 static struct crypto_skcipher *
 fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 			  const struct inode *inode)
@@ -556,13 +567,10 @@ static int find_and_lock_master_key(const struct fscrypt_info *ci,
 		*mk_ret = NULL;
 		return 0;
 	}
-	down_read(&mk->mk_sem);
 
-	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
-		err = -ENOKEY;
+	err = lock_master_key(mk);
+	if (err)
 		goto out_release_key;
-	}
 
 	if (!fscrypt_valid_master_key_size(mk, ci)) {
 		err = -ENOKEY;
-- 
2.40.1

