Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D556DCBB5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjDJTkd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjDJTkc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:32 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB09A1BD9
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:31 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3008F8050F;
        Mon, 10 Apr 2023 15:40:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155631; bh=y6IVwyuZ/Z1XtDZG1uz1sPuBXx4FiG1yBF2gK/UM5Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otvRy+ncKp5sVS2GSrwyJHIws6yYwQlVhE4ZuGCr58emXlGlZ8aAZUUhnaURQaRVA
         1Fsa9XQFA/xXZRwl7VSj/oaALHQPKl2IX1SSuW1ieCbgXSqNnCeUtE6VATLrbucdNR
         qUnxzkkExIiUbmAz9Z9IPqj+2VkoLjAMsJuRAWA4PVmfToGPPqe2iprb9RqFy++rBs
         LSBbiJhAmM6zp+QimK5IYnWrN03l8ALC2bWyU2mGv4SnRRZkLj8acfa1Bf3azbTm4F
         OL0VDpEeZr/hBbZepaPE4aaaDhF4ANqNil1U9mftdn1832X7jYIYUkNwqt/bax+dtz
         S839wyJfAUzjg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 05/11] fscrypt: reduce special-casing of IV_INO_LBLK_32
Date:   Mon, 10 Apr 2023 15:39:58 -0400
Message-Id: <b041415c3dd69c2c93e3f4cabecafdbacbfe10ac.1681155143.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1681155143.git.sweettea-kernel@dorminy.me>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
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

Right now, the IV_INO_LBLK_32 policy is handled by its own function
called in fscrypt_setup_v2_file_key(), different from all other policies
which just call find_mode_prepared_key() with various parameters. The
function additionally sets up the relevant inode hashing key in the
master key, and uses it to hash the inode number if possible. This is
not particularly relevant to setting up a prepared key, so this change
tries to make it clear that every non-default policy uses basically the
same setup mechanism for its prepared key. The other setup is moved to
be called from the top crypt_info setup function.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 82589c370b14..8b32200dbbc0 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -304,16 +304,10 @@ void fscrypt_hash_inode_number(struct fscrypt_info *ci,
 					      &mk->mk_ino_hash_key);
 }
 
-static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
-					    struct fscrypt_master_key *mk)
+static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
 {
 	int err;
 
-	err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
-				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
-	if (err)
-		return err;
-
 	/* pairs with smp_store_release() below */
 	if (!smp_load_acquire(&mk->mk_ino_hash_key_initialized)) {
 
@@ -335,12 +329,6 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
 			return err;
 	}
 
-	/*
-	 * New inodes may not have an inode number assigned yet.
-	 * Hashing their inode number is delayed until later.
-	 */
-	if (ci->ci_inode->i_ino)
-		fscrypt_hash_inode_number(ci, mk);
 	return 0;
 }
 
@@ -373,7 +361,9 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
 					     true);
 	} else if (ci->ci_policy.v2.flags &
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
-		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
+		err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
+					     HKDF_CONTEXT_IV_INO_LBLK_32_KEY,
+					     true);
 	} else {
 		u8 derived_key[FSCRYPT_MAX_KEY_SIZE];
 
@@ -627,6 +617,20 @@ fscrypt_setup_encryption_info(struct inode *inode,
 			goto out;
 	}
 
+	/*
+	 * The IV_INO_LBLK_32 policy needs a hashed inode number, but new
+	 * inodes may not have an inode number assigned yet.
+	 */
+	if (policy->version == FSCRYPT_POLICY_V2 &&
+	    (policy->v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
+		res = fscrypt_setup_ino_hash_key(mk);
+		if (res)
+			goto out;
+
+		if (inode->i_ino)
+			fscrypt_hash_inode_number(crypt_info, mk);
+	}
+
 	/*
 	 * For existing inodes, multiple tasks may race to set ->i_crypt_info.
 	 * So use cmpxchg_release().  This pairs with the smp_load_acquire() in
-- 
2.40.0

