Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B930C79056B
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351624AbjIBF4I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343615AbjIBF4I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:56:08 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF2610F6;
        Fri,  1 Sep 2023 22:56:05 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 97D2B803B3;
        Sat,  2 Sep 2023 01:56:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634165; bh=sjWPfktkz8U2Au2Wkmak2i4sH8J6VID8oPHMkxQ2yGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvst1U6FgIWYDBkxUlcrZlYIIVsihu2GkWqBIb4O++VEX8mc9erQJ261K9garY3AI
         pX8L3DfOmlC2+ztsuvgvogOmxASUfhlBbb5oK2OTJOgn/Nr937h0mH0nmeJMWdyGtg
         0p/m/OK+LT7UO/0Ofy7PzyOuVpfnLz+ugN+B+2RfF9n0Yx3lAHpjzy2EX2888v2BJT
         kf9icbC4BTVbZLM8B5t9KN2y32hRR84LD2IvfqkDlhZjS5UqZFwIL9VLShYYPmc7Np
         8uO+GJlCSPUxoS2r4LwviPj0vO4hGQae3fd4FG/a03l7a6lm7H3uGjQxln6HdJMYKb
         JD1l9Lbioc/xg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 08/13] fscrypt: save session key credentials for extent infos
Date:   Sat,  2 Sep 2023 01:54:26 -0400
Message-ID: <fd61bc691a89a48a5cf8ae5417c607d3d945d198.1693630890.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1693630890.git.sweettea-kernel@dorminy.me>
References: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 fs/crypto/fscrypt_private.h |  9 +++++++++
 fs/crypto/keysetup.c        | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 9320428f8915..fe48b61a524b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -284,6 +284,15 @@ struct fscrypt_common_info {
 struct fscrypt_info {
 	struct fscrypt_common_info info;
 
+	/* Credential struct from the thread which created this info. This is
+	 * only used in v1 session keyrings with extent encryption; it allows
+	 * the thread creating extents for an inode to join the session
+	 * keyring temporarily, since otherwise the thread is usually part of
+	 * kernel writeback and therefore unrelated to the thread with the
+	 * right session key.
+	 */
+	struct cred *ci_session_creds;
+
 	/*
 	 * This inode's hash key for filenames.  This is a 128-bit SipHash-2-4
 	 * key.  This is only set for directories that use a keyed dirhash over
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 4146b1380cb5..5e944ec4e36f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -619,6 +619,9 @@ static void put_crypt_inode_info(struct fscrypt_info *ci)
 	free_prepared_key(&ci->info);
 	remove_info_from_mk_decrypted_list(&ci->info);
 
+	if (ci->ci_session_creds)
+		abort_creds(ci->ci_session_creds);
+
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_inode_info_cachep, ci);
 }
@@ -727,6 +730,9 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
+	if (!mk)
+		crypt_inode_info->ci_session_creds = prepare_creds();
+
 	/*
 	 * Derive a secret dirhash key for directories that need it. It
 	 * should be impossible to set flags such that a v1 policy sets
@@ -979,6 +985,7 @@ fscrypt_setup_extent_info(struct inode *inode,
 	struct fscrypt_extent_info *crypt_extent_info;
 	struct fscrypt_common_info *crypt_info;
 	struct fscrypt_master_key *mk = NULL;
+	const struct cred *creds = NULL;
 	int res;
 
 	crypt_extent_info = kmem_cache_zalloc(fscrypt_extent_info_cachep,
@@ -987,8 +994,20 @@ fscrypt_setup_extent_info(struct inode *inode,
 		return -ENOMEM;
 	crypt_info = &crypt_extent_info->info;
 
+	if (inode->i_crypt_info->ci_session_creds) {
+		/*
+		 * The inode this is being created for is using a session key,
+		 * so we have to join this thread to that session temporarily
+		 * in order to be able to find the right key...
+		 */
+		creds = override_creds(inode->i_crypt_info->ci_session_creds);
+	}
+
 	res = fscrypt_setup_common_info(crypt_info, inode, policy, nonce,
 					CI_EXTENT, &mk);
+	if (creds)
+		revert_creds(creds);
+
 	if (res)
 		goto out;
 
-- 
2.41.0

