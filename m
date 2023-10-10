Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED2F7C416A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbjJJUlN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjJJUlI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:08 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF6DB0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:06 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-d89ba259964so6710111276.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970465; x=1697575265; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t3AtE57cfE4ke3TNDK2zyjx2+8CAXIno7J26EywbEhE=;
        b=tLiDHazrIRdBQE7hE24ZJ//35zg8mXot0ALA6hPjIxiFicGeSBDYKffxuVPku7RfJG
         W/8L884yPAbQbPSAeyTi9q0G1z50fN0rQq0Qb20XuEyUS1v+QqbuyfJvyKMOnh7ekl+e
         IpsbsE+tHGmspA86K8nyyP7Fr4WHLHL867GJf6JKlWcegxERdcVFpdZDpm5yzQOJJYvG
         xJhBq6AVpvflcV2zLY9HIPACje+O8NZT/NW3G5ASwIuhMRXQvFIN4g/MEX6PDfFYDATW
         IeGwsYt+PR5xWrG9YK9Oc8f9JDIVR8u7GBG/g85Bf4GrUs1BWlnyIPi1F6kxKhp8RqBg
         45jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970465; x=1697575265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t3AtE57cfE4ke3TNDK2zyjx2+8CAXIno7J26EywbEhE=;
        b=F9qzw3vPMOGBbSUuAdIOyWADren0zKDKYWPPQ7chthC3B9muK6CBDUaW4oF7ef19b6
         H5pR+EZB+FpuuxVDBCKECiZIAvk5utIXsQDNsDCTrg46tX2g7APufSBSJ8sUOJBDPq5u
         +jnsASHp3SRWOdB4Tml3eesD2NpRgvUskBrvgix4hMY6//eQZpkluHIsh402/Qld3pfn
         lq989miuVsXS/BCdVh09aZIwfb3DWAyTMa4T/LinDrpVVlcMmVr9btJBMWtlM8uUXUVk
         PfU0e1eXU0R/avXi+U8kZesOtgJ1MzLDnZE5p7RmAnFrwec7YD53nLuJSzuuuoVpK8Gs
         6RCw==
X-Gm-Message-State: AOJu0Yy2rC4s0iCVA4rfeah2q08Jl1gCpMyJWt4cuFhOo0MOFQszmwKZ
        MjhuwmRgdaFMNLrhSVq4DVML4rckZTrT/hIZNMnPBA==
X-Google-Smtp-Source: AGHT+IH+HddtrEfyeHZpxOqvjphtb2wnL6aRU96LWS6eFgRyVsdxV1iw7xuXsyX64rDKY8i5bwPDVA==
X-Received: by 2002:a25:8f8d:0:b0:d48:1936:14d0 with SMTP id u13-20020a258f8d000000b00d48193614d0mr19368582ybl.53.1696970464995;
        Tue, 10 Oct 2023 13:41:04 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id a5-20020a259805000000b00d7bb3c4893fsm3907331ybo.8.2023.10.10.13.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:04 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 01/36] fscrypt: use a flag to indicate that the master key is being evicted
Date:   Tue, 10 Oct 2023 16:40:16 -0400
Message-ID: <e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently we wipe the mk->mk_secret when we remove the master key, and
we use this status to tell everybody whether or not the master key is
available for use.

With extent based encryption we're going to need to keep the secret
around until the inode is evicted, so we need a different mechanism to
tell everybody that the key is currently unusable.

Accomplish this with a mk_flags member in the master key, and update the
is_master_key_secret_present() helper to return the status of this bit.
Update the removal and adding helpers to manipulate this bit and use it
as the source of truth about whether or not the key is available for
use.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/fscrypt_private.h | 17 ++++++++---------
 fs/crypto/hooks.c           |  2 +-
 fs/crypto/keyring.c         | 20 ++++++++++++++------
 fs/crypto/keysetup.c        |  4 ++--
 4 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 2fb4ba435d27..f44342f17269 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -471,6 +471,10 @@ struct fscrypt_master_key_secret {
 
 } __randomize_layout;
 
+enum fscrypt_mk_flags {
+	FSCRYPT_MK_FLAG_EVICTED = BIT(0),
+};
+
 /*
  * fscrypt_master_key - an in-use master key
  *
@@ -565,19 +569,14 @@ struct fscrypt_master_key {
 	siphash_key_t		mk_ino_hash_key;
 	bool			mk_ino_hash_key_initialized;
 
+	/* Flags for the master key. */
+	unsigned long		mk_flags;
 } __randomize_layout;
 
 static inline bool
-is_master_key_secret_present(const struct fscrypt_master_key_secret *secret)
+is_master_key_secret_present(const struct fscrypt_master_key *mk)
 {
-	/*
-	 * The READ_ONCE() is only necessary for fscrypt_drop_inode().
-	 * fscrypt_drop_inode() runs in atomic context, so it can't take the key
-	 * semaphore and thus 'secret' can change concurrently which would be a
-	 * data race.  But fscrypt_drop_inode() only need to know whether the
-	 * secret *was* present at the time of check, so READ_ONCE() suffices.
-	 */
-	return READ_ONCE(secret->size) != 0;
+	return !test_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags);
 }
 
 static inline const char *master_key_spec_type(
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 85d2975b69b7..f7cf724cf256 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -187,7 +187,7 @@ int fscrypt_prepare_setflags(struct inode *inode,
 			return -EINVAL;
 		mk = ci->ci_master_key;
 		down_read(&mk->mk_sem);
-		if (is_master_key_secret_present(&mk->mk_secret))
+		if (is_master_key_secret_present(mk))
 			err = fscrypt_derive_dirhash_key(ci, mk);
 		else
 			err = -ENOKEY;
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index a51fa6a33de1..e0e311ed6b88 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -102,7 +102,7 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 	 * ->mk_active_refs == 0 implies that ->mk_secret is not present and
 	 * that ->mk_decrypted_inodes is empty.
 	 */
-	WARN_ON_ONCE(is_master_key_secret_present(&mk->mk_secret));
+	WARN_ON_ONCE(is_master_key_secret_present(mk));
 	WARN_ON_ONCE(!list_empty(&mk->mk_decrypted_inodes));
 
 	for (i = 0; i <= FSCRYPT_MODE_MAX; i++) {
@@ -236,11 +236,17 @@ void fscrypt_destroy_keyring(struct super_block *sb)
 			 * the keyring due to the single active ref associated
 			 * with ->mk_secret.  There should be no structural refs
 			 * beyond the one associated with the active ref.
+			 *
+			 * We set the EVICTED flag in order to avoid the
+			 * WARN_ON_ONCE(is_master_key_secret_present(mk)) in
+			 * fscrypt_put_master_key_activeref(), as we want to
+			 * maintain that warning for improper cleanup elsewhere.
 			 */
 			WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 1);
 			WARN_ON_ONCE(refcount_read(&mk->mk_struct_refs) != 1);
-			WARN_ON_ONCE(!is_master_key_secret_present(&mk->mk_secret));
+			WARN_ON_ONCE(!is_master_key_secret_present(mk));
 			wipe_master_key_secret(&mk->mk_secret);
+			set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags);
 			fscrypt_put_master_key_activeref(sb, mk);
 		}
 	}
@@ -479,9 +485,11 @@ static int add_existing_master_key(struct fscrypt_master_key *mk,
 	}
 
 	/* Re-add the secret if needed. */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
-		if (!refcount_inc_not_zero(&mk->mk_active_refs))
+	if (test_and_clear_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags)) {
+		if (!refcount_inc_not_zero(&mk->mk_active_refs)) {
+			set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags);
 			return KEY_DEAD;
+		}
 		move_master_key_secret(&mk->mk_secret, secret);
 	}
 
@@ -1055,7 +1063,7 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 
 	/* No user claims remaining.  Go ahead and wipe the secret. */
 	err = -ENOKEY;
-	if (is_master_key_secret_present(&mk->mk_secret)) {
+	if (!test_and_set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags)) {
 		wipe_master_key_secret(&mk->mk_secret);
 		fscrypt_put_master_key_activeref(sb, mk);
 		err = 0;
@@ -1150,7 +1158,7 @@ int fscrypt_ioctl_get_key_status(struct file *filp, void __user *uarg)
 	}
 	down_read(&mk->mk_sem);
 
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
+	if (!is_master_key_secret_present(mk)) {
 		arg.status = refcount_read(&mk->mk_active_refs) > 0 ?
 			FSCRYPT_KEY_STATUS_INCOMPLETELY_REMOVED :
 			FSCRYPT_KEY_STATUS_ABSENT /* raced with full removal */;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 094d1b7a1ae6..92eca1400b2d 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -487,7 +487,7 @@ static int setup_file_encryption_key(struct fscrypt_inode_info *ci,
 	down_read(&mk->mk_sem);
 
 	/* Has the secret been removed (via FS_IOC_REMOVE_ENCRYPTION_KEY)? */
-	if (!is_master_key_secret_present(&mk->mk_secret)) {
+	if (!is_master_key_secret_present(mk)) {
 		err = -ENOKEY;
 		goto out_release_key;
 	}
@@ -808,6 +808,6 @@ int fscrypt_drop_inode(struct inode *inode)
 	 * then the thread removing the key will either evict the inode itself
 	 * or will correctly detect that it wasn't evicted due to the race.
 	 */
-	return !is_master_key_secret_present(&ci->ci_master_key->mk_secret);
+	return !is_master_key_secret_present(ci->ci_master_key);
 }
 EXPORT_SYMBOL_GPL(fscrypt_drop_inode);
-- 
2.41.0

