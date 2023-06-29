Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B276C741D04
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbjF2Aex (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjF2Aew (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:34:52 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D34F1FC2;
        Wed, 28 Jun 2023 17:34:51 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 12DD080B08;
        Wed, 28 Jun 2023 20:34:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998891; bh=yT+T/CU256NsOeG+y9Jts+NtvBICj/npbIOSdxl6kVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzZT/dw1aegN2l+yDpghXsX0Lm1disa882zzEVZ/YPd20ClKQczWAI+z/YpupcCc/
         q8KcW8EoPCtiIaoeCOzPb3aVf3tzuJXjKOlCotEvvs9bXrwIWSqD+cygN9aGNdabTt
         np1pf8DgLblSOiJzDNgxQmmfObI503Ijtu599k5If8/mzvOK93eNkQ4X8auiFfJ1F/
         trL8zUR5EGjEcBgeUFiLNsP4Iy0dkPWfTKACsEhvDrjl+HhdhV0rFxO1aiMr2WZOyR
         hv2UTw2W3/PAn/Jv4PIviSEHZX+bt4AX/OSM1j/unf9aIR6MgtBuV/3oEFK+X2oAzF
         DMNbdgclplL4w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 11/12] fscrypt: save session key credentials for extent infos
Date:   Wed, 28 Jun 2023 20:29:41 -0400
Message-Id: <0c8d98959d1498611452be66fe5704773ac860d1.1687988246.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988246.git.sweettea-kernel@dorminy.me>
References: <cover.1687988246.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
 fs/crypto/keysetup.c        | 13 +++++++++++++
 fs/crypto/keysetup_v1.c     |  1 +
 3 files changed, 22 insertions(+)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5eafa50a3298..5c7649717aac 100644
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
index 50fa8955ae2c..cfe0f93919fe 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -617,6 +617,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 		spin_unlock(&mk->mk_decrypted_inodes_lock);
 		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
 	}
+	if (ci->ci_session_creds)
+		abort_creds(ci->ci_session_creds);
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
@@ -633,6 +635,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	struct fscrypt_master_key *mk = NULL;
 	int res;
 	bool info_for_extent = !!info_ptr;
+	const struct cred *creds = NULL;
 
 	if (!info_ptr)
 		info_ptr = &inode->i_crypt_info;
@@ -677,7 +680,17 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
+	if (info_for_extent && inode->i_crypt_info->ci_session_creds)
+		 creds = override_creds(inode->i_crypt_info->ci_session_creds);
+		/*
+		 * The inode this is being created for is using a session key,
+		 * so we have to join this thread to that session temporarily
+		 * in order to be able to find the right key...
+		 */
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

