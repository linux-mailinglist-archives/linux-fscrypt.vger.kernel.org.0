Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5C36DC5B9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 12:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjDJK04 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 06:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjDJK0x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 06:26:53 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83571273A
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 03:26:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1060880606;
        Mon, 10 Apr 2023 06:16:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681121814; bh=T/GWz5x9N9tt4cSe2QC2OCcSFKjxdBbLNMYUMT75UCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESLEhBeen0IrmdKJocUZdwlFu5Ud9s6YBd6Mxb7sDIXY5i7+79a+on5p2Ri8emcWE
         eQfdglhZzpEkwa6D352hp8LQIIgw3LVS8d5dtCMzs1Y/M44iATI81aJ6JOaUny2Fdn
         4Djj8HnTN3eJMV/jakTt4U3bPTobnWehhQ6Xlq4PbL7NqHmRYM6vumuDIqvrCHsQY/
         pFVpifXM7OJLLLZiejzlXSVgcqbFeD5kwo03VpkqbRvj6RYN5v/RqbEUUPCqDTB6tG
         OA6tPzVy4t0WvATVAAB7Zc8z25A0fBCcNI+2lNNRHpWmagq8QyPO9OlBTNEk6T7tKf
         Ux2UvOdALUufw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 07/10] fscrypt: make ci->ci_direct_key a bool not a pointer
Date:   Mon, 10 Apr 2023 06:16:28 -0400
Message-Id: <5001d8e2c732cf905744ef6e55ab5ee00f57d658.1681116740.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681116739.git.sweettea-kernel@dorminy.me>
References: <cover.1681116739.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The ci_direct_key field is only used for v1 direct key policies,
recording the direct key that needs to have its refcount reduced when
the crypt_info is freed. However, now that crypt_info->ci_enc_key is a
pointer to the authoritative prepared key -- embedded in the direct key,
in this case, we no longer need to keep a full pointer to the direct key
-- we can use container_of() to go from the prepared key to its
surrounding direct key. Thus we can make ci_direct_key a bool instead of
a pointer, saving a few bytes.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h | 7 +++----
 fs/crypto/keysetup.c        | 2 +-
 fs/crypto/keysetup_v1.c     | 7 +++++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5011737b60b3..b575fb58a506 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -234,10 +234,9 @@ struct fscrypt_info {
 	struct list_head ci_master_key_link;
 
 	/*
-	 * If non-NULL, then encryption is done using the master key directly
-	 * and ci_enc_key will equal ci_direct_key->dk_key.
+	 * If true, then encryption is done using the master key directly.
 	 */
-	struct fscrypt_direct_key *ci_direct_key;
+	bool ci_direct_key;
 
 	/*
 	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
@@ -641,7 +640,7 @@ static inline int fscrypt_require_key(struct inode *inode)
 
 /* keysetup_v1.c */
 
-void fscrypt_put_direct_key(struct fscrypt_direct_key *dk);
+void fscrypt_put_direct_key(struct fscrypt_prepared_key *prep_key);
 
 int fscrypt_setup_v1_file_key(struct fscrypt_info *ci,
 			      const u8 *raw_master_key);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 845a92203c87..d81001bf0a51 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -578,7 +578,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		return;
 
 	if (ci->ci_direct_key)
-		fscrypt_put_direct_key(ci->ci_direct_key);
+		fscrypt_put_direct_key(ci->ci_enc_key);
 	else if (ci->ci_owns_key) {
 		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
 					     ci->ci_enc_key);
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index e1d761e8067f..09de84c65368 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -160,8 +160,11 @@ static void free_direct_key(struct fscrypt_direct_key *dk)
 	}
 }
 
-void fscrypt_put_direct_key(struct fscrypt_direct_key *dk)
+void fscrypt_put_direct_key(struct fscrypt_prepared_key *prep_key)
 {
+	struct fscrypt_direct_key *dk =
+		container_of(prep_key, struct fscrypt_direct_key, dk_key);
+
 	if (!refcount_dec_and_lock(&dk->dk_refcount, &fscrypt_direct_keys_lock))
 		return;
 	hash_del(&dk->dk_node);
@@ -258,7 +261,7 @@ static int setup_v1_file_key_direct(struct fscrypt_info *ci,
 	dk = fscrypt_get_direct_key(ci, raw_master_key);
 	if (IS_ERR(dk))
 		return PTR_ERR(dk);
-	ci->ci_direct_key = dk;
+	ci->ci_direct_key = true;
 	ci->ci_enc_key = &dk->dk_key;
 	return 0;
 }
-- 
2.40.0

