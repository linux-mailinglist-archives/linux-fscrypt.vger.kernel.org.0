Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842F9774638
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjHHSy1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232623AbjHHSyI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:08 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE4C15C7B6;
        Tue,  8 Aug 2023 10:08:58 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E5F0F83546;
        Tue,  8 Aug 2023 13:08:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514538; bh=scRHF9SMuL/YJh7S5rHdvyOT2nCxaggyg6QYNEXbEho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLDePPmrKReyQx+C6UHsWvZZ0zHYvUuEoF1sBUUHG4Iom+ZKTRVljpsPWUtcv01q3
         Tw3StOWG5q5QY3EZ/RakMsPSsaDPXvDeCHk5zAZiO/SJy7fDUbyqHrlGmHK/wadKCx
         5nfYcbLcu+17MqjbosJJngjMWarvqxOD71ftfKQqU6QXPRKZFUcaBi0rR+EhDSt2Np
         baY5qMZ6WQUAI0Pz+7m6VB1ajO2hVaj9IZutp4erwpOWEzsIE706yqLB42ZUbSCHg5
         9r3A/TuuPQwTNj+1pn735KdmF2TTDxq/ehQLtb3YPvmReHafCbN6FPUrqSM+D+GiM7
         8P/SW30R6N3zQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 12/16] fscrypt: save session key credentials for extent infos
Date:   Tue,  8 Aug 2023 13:08:29 -0400
Message-ID: <bb78cdd486094afb51c431c089d92f951f391c6d.1691505882.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691505882.git.sweettea-kernel@dorminy.me>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
index c6bf0bd0259a..cd29c71b4349 100644
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
index 0076c7f2af3d..8d50716bdf11 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -649,6 +649,8 @@ static void put_crypt_info(struct fscrypt_info *ci)
 
 		fscrypt_put_master_key_activeref(ci->ci_sb, mk);
 	}
+	if (ci->ci_session_creds)
+		abort_creds(ci->ci_session_creds);
 	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
@@ -665,6 +667,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	struct fscrypt_master_key *mk = NULL;
 	int res;
 	bool info_for_extent = !!info_ptr;
+	const struct cred *creds = NULL;
 
 	if (!info_ptr)
 		info_ptr = &inode->i_crypt_info;
@@ -707,7 +710,18 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	if (res)
 		goto out;
 
+	if (info_for_extent && inode->i_crypt_info->ci_session_creds) {
+		/*
+		 * The inode this is being created for is using a session key,
+		 * so we have to join this thread to that session temporarily
+		 * in order to be able to find the right key...
+		 */
+		creds = override_creds(inode->i_crypt_info->ci_session_creds);
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
2.41.0

