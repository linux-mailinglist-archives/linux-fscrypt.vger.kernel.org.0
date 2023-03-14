Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EA6B904F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 11:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCNKkt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 06:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCNKkr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 06:40:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7723520066;
        Tue, 14 Mar 2023 03:40:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DC1431F88C;
        Tue, 14 Mar 2023 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678790345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXpeUENOVL0/Czrcbie4Fl5tkihbr0boSVc43vZ6le0=;
        b=Z9PfuxwIIc5rqCtweTGg3hWo59RW+/6ocULRVrpd1KEjoR7MOdPxuyb4vpFCmUm5m4+KVX
        Z/38jta4sX67vr4tp4kOx/HZHmNKU5gr+l0CbJP1ebECdbseuzb//6wa+X7VY/qZQSVs67
        j28C+8JOJp3Mz1qVCyorSR+GGoC12CU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678790345;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lXpeUENOVL0/Czrcbie4Fl5tkihbr0boSVc43vZ6le0=;
        b=/G8hseUbm1026Kcf5vnHC15iIAvWyaAvIFDJk0Ixdq6NjaopCwZiXKmHA7HCKsQbjJdZkV
        n/+zjroxfNfYefAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3378113A1B;
        Tue, 14 Mar 2023 10:39:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +EBtCclOEGS4FQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 10:39:05 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 219aa8f7;
        Tue, 14 Mar 2023 10:39:03 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v2 1/2] fscrypt: new helper function - fscrypt_prepare_atomic_open()
Date:   Tue, 14 Mar 2023 10:39:01 +0000
Message-Id: <20230314103902.32592-2-lhenriques@suse.de>
In-Reply-To: <20230314103902.32592-1-lhenriques@suse.de>
References: <20230314103902.32592-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch introduces a new helper function which prepares an atomic_open.
Because atomic open can act as a lookup if handed a dentry that is negative,
we need to set DCACHE_NOKEY_NAME if the key for the parent isn't available.

The reason for getting the encryption info before checking if the directory has
the encryption key is because we may have the key available but the encryption
info isn't yet set (maybe due to a drop_caches).  The regular open path will
call fscrypt_file_open() which uses function fscrypt_require_key() for setting
the encryption info if needed.  The atomic open needs to do something similar.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/crypto/hooks.c       | 33 +++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 2 files changed, 40 insertions(+)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b5..165ddf01bf9f 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -117,6 +117,39 @@ int __fscrypt_prepare_readdir(struct inode *dir)
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
+ * call fscrypt_file_open() which uses function fscrypt_require_key() for
+ * setting the encryption info if needed.  The atomic open needs to do something
+ * similar.
+ *
+ * Return: 0 on success, or an error code if fscrypt_get_encryption_info()
+ * fails.
+ */
+int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
+{
+	int err;
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
