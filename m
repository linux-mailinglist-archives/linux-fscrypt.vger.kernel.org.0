Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8683F77439C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjHHSII (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjHHSHb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:31 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27561A79F;
        Tue,  8 Aug 2023 10:08:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id AAD3083542;
        Tue,  8 Aug 2023 13:08:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514522; bh=EpXn3+Jbg9QKzxgKqdj40m8q6/qRVvmn6DMf3mB1H6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SlBcPQozXmlyllCwjaKAuBH4FEgYdsv3LWrftDWC75PKg7esjTRKMinZtmpIYqKHU
         adjzybnJzXDBysonXM3x5RG/iqitMXGEhcl6TpswsuL3A7DOlwVDrcErunSri032MH
         76yldCK0iQI7MFlI0tYI71Pci4y3SuH2jxYzaDjbOX57Pu6/JPxFJdUyl3aGGF0jy0
         bl6gyUdiwOJ0R5mJOQZL6KvayinHTtWyOF82e3MGbhV8RPJXrZE9P8jkE6PjrlLBNm
         nUlbqENTn5cdPe/bRzuW8uh4yUliGxre2t0YsEUoeJ8Q+Gra5svbdDV+RvA+Cqsd7f
         TN6BalfJhoSJg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 01/16] fscrypt: factor helper for locking master key
Date:   Tue,  8 Aug 2023 13:08:18 -0400
Message-ID: <5b791b93e0697db89c8a02df633f7be97f5ba58c.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.41.0

