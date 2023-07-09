Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD6E74C7A6
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjGISyN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjGISyM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:54:12 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C691126;
        Sun,  9 Jul 2023 11:54:11 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C55E880B12;
        Sun,  9 Jul 2023 14:54:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928851; bh=jmlspEy8D/2FL49Zjt+7/SolvNvuxxDkisxxhNKQ/qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHllH+7rRhRNNtUEaJMtR8lsVgCh7SrGYu1inq+rNte+m4Qmk60u9ACgSeM/EqBiC
         JwTCGYYLhKccQnM/Rtb68gO0bWJRIflPzENl1nk+WAD0qUkPKpFO3Ickv9zg2Q3qWm
         qw5mfWmzlDT6mv3liYm2Mt1z7UIKLvW6O6jgZNUymwpdgJfLU4vSr/zhGa2jcNXFXW
         5kN2unS8Gr774QLTycSRma275/p3ZEJgK7tfM4N+mQyqB3Jgb1FI/wRf4xgP+xxxV1
         JdVGjAHEWRh00kSEh2fyMx8pjx5xWQSMdpqdpxAPf3mYxcEe6L/a5+FnM0lQEAor+s
         K/qk0dlMTxh2A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 13/14] fscrypt: save session key credentials for extent infos
Date:   Sun,  9 Jul 2023 14:53:46 -0400
Message-Id: <7ad2677a3c27039167e95bfe67c75336b540fd17.1688927487.git.sweettea-kernel@dorminy.me>
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

For v1 encryption policies using per-session keys, the thread which
opens the inode and therefore initializes the encryption info is part of
the session, so it can get the key from the session keyring. However,
for extent encryption, the extent infos are likely loaded from a
different thread, which does not have access to the session keyring.
This change saves the credentials of the inode opening thread and reuses
those credentials temporarily when dealing with extent infos, allowing
finding the encryption key correctly.

v1 encryption policies using per-session keys should probably not exist
for new usages such as extent encryption, but this makes more tests
work without change; maybe the right answer is to disallow v1 session
keys plus extent encryption and deal with editing tests to not use v1
session encryption so much.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fscrypt_private.h |  8 ++++++++
 fs/crypto/keysetup.c        | 14 ++++++++++++++
 fs/crypto/keysetup_v1.c     |  1 +
 3 files changed, 23 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 6e6020f7746c..a1c484511ba3 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -231,6 +231,14 @@ struct fscrypt_info {
 	 */
 	bool ci_inlinecrypt;
 #endif
+	/* Credential struct from the thread which created this info. This is
+	 * only used in v1 session keyrings with extent encryption; it allows
+	 * the thread creating extents for an inode to join the session
+	 * keyring temporarily, since otherwise the thread is usually part of
+	 * kernel writeback and therefore unrelated to the thread with the
+	 * right session key.
+	 */
+	struct cred *ci_session_creds;
 
 	/*
 	 * Encryption mode used for this inode.  It corresponds to either the
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 3b80e7061039..9c56ef8d2eb6 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -646,6 +646,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 
 		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
 	}
+	if (ci->ci_session_creds)
+		abort_creds(ci->ci_session_creds);
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
@@ -662,6 +664,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	struct fscrypt_master_key *mk = NULL;
 	int res;
 	bool info_for_extent = !!info_ptr;
+	const struct cred *creds = NULL;
 
 	if (!info_ptr)
 		info_ptr = &inode->i_crypt_info;
@@ -705,7 +708,18 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
+	if (info_for_extent && inode->i_crypt_info->ci_session_creds) {
+		 creds = override_creds(inode->i_crypt_info->ci_session_creds);
+		/*
+		 * The inode this is being created for is using a session key,
+		 * so we have to join this thread to that session temporarily
+		 * in order to be able to find the right key...
+		 */
+	}
+
 	res = fscrypt_setup_file_key(crypt_info, mk);
+	if (creds)
+		revert_creds(creds);
 	if (res)
 		goto out;
 
diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 41d317f08aeb..4f2be2377dfa 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -318,6 +318,7 @@ int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci)
 		return PTR_ERR(key);
 
 	err = fscrypt_setup_v1_file_key(ci, payload->raw);
+	ci->ci_session_creds = prepare_creds();
 	up_read(&key->sem);
 	key_put(key);
 	return err;
-- 
2.40.1

