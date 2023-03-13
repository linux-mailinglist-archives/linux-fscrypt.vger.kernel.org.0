Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4CE6B778E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 13:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjCMMdT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCMMdR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 08:33:17 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B091969F;
        Mon, 13 Mar 2023 05:33:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 78D4C1FE0C;
        Mon, 13 Mar 2023 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678710793; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bc2iGS3vObLzmQ9MIUXqwa39aRJrh3amfgSHRWBj7bQ=;
        b=HBhJiQauaNSAKXRLDJb4C7AN5y6XV0PAD4EEEx2JLMUMBp+an4mWFkMLojnQVNSmxJgMJh
        aGaV6v48u3t1lZdzBwVD68G9CsNELpiOe+bULzVR4nuT0u7cs+IrPAe+hevLfRl81pOIgC
        VYJqVLTp2Ef34aSqeSAvnznhZBuaGf4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678710793;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bc2iGS3vObLzmQ9MIUXqwa39aRJrh3amfgSHRWBj7bQ=;
        b=eBB7qNSiDz9RNbMBX1zyQcYZ0ITMLS1WEE/w/sPjr+8d47mKjBdyHcIu2ZIrv/mqYecZOW
        Tme07aX8VkAPeiCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CBB8F13582;
        Mon, 13 Mar 2023 12:33:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4LfeLggYD2RnCQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Mar 2023 12:33:12 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 0119dc8c;
        Mon, 13 Mar 2023 12:33:11 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH 1/2] fscrypt: new helper function - fscrypt_prepare_atomic_open()
Date:   Mon, 13 Mar 2023 12:33:09 +0000
Message-Id: <20230313123310.13040-2-lhenriques@suse.de>
In-Reply-To: <20230313123310.13040-1-lhenriques@suse.de>
References: <20230313123310.13040-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch introduces a new helper function which prepares an atomic_open.
Because atomic open can act as a lookup if handed a dentry that is negative,
we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.

The reason for getting the encryption info before checking if the directory
has the encryption key is because we may have the key available but the
encryption info isn't yet set (maybe due to a drop_caches).  The regular
open path will use fscrypt_file_open for that but in the atomic open a
different approach is required.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/crypto/hooks.c       | 35 +++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 2 files changed, 42 insertions(+)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b5..8be1e35984f1 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -117,6 +117,41 @@ int __fscrypt_prepare_readdir(struct inode *dir)
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
 
+/**
+ * fscrypt_prepare_atomic_open() - prepare an atomic open on an encrypted directory
+ * @dir: inode of parent directory
+ * @dentry: dentry being open
+ *
+ * Because atomic open can act as a lookup if handed a dentry that is negative,
+ * we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.
+ *
+ * The reason for getting the encryption info before checking if the directory
+ * has the encryption key is because the key may be available but the encryption
+ * info isn't yet set (maybe due to a drop_caches).  The regular open path will
+ * use fscrypt_file_open for that, but in the atomic open a different approach
+ * is required.
+ *
+ * Return: 0 on success, or an error code if fscrypt_get_encryption_info()
+ * fails.
+ */
+int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
+{
+	int err;
+
+	if (!IS_ENCRYPTED(dir))
+		return 0;
+
+	err = fscrypt_get_encryption_info(dir, true);
+	if (!err && !fscrypt_has_encryption_key(dir)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_NOKEY_NAME;
+		spin_unlock(&dentry->d_lock);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
+
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	if (attr->ia_valid & ATTR_SIZE)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4f5f8a651213..c70acb2a737a 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -362,6 +362,7 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 			     struct fscrypt_name *fname);
 int __fscrypt_prepare_readdir(struct inode *dir);
+int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry);
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags);
@@ -688,6 +689,12 @@ static inline int __fscrypt_prepare_readdir(struct inode *dir)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_prepare_atomic_open(struct inode *dir,
+					      struct dentry *dentry)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __fscrypt_prepare_setattr(struct dentry *dentry,
 					    struct iattr *attr)
 {
