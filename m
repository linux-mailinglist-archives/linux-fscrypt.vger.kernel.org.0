Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733396B23F7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Mar 2023 13:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbjCIMTT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Mar 2023 07:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCIMTS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Mar 2023 07:19:18 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EABE9CDC;
        Thu,  9 Mar 2023 04:19:17 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B8FFA21B92;
        Thu,  9 Mar 2023 12:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678364355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gkKulOGIgQcOiccW8SiWFbG5uMFAl4MHpehodedeHSc=;
        b=1wEPudR2xQ1GZWaU4drB20//AEVuWkCc5Lidb2lMvEpcSdinGnULBy5ZIZQER3YSxE+J+N
        bhABYqqxNWbxFQdvS4iHWE/sk0JWvc0CpWwIe6DmyxTqI3Jj2t6FTOdXqHZ7RMe2Ap7MHV
        SGdzRcPTEWLNNw6T6Vl+l4y5MfuY+Rw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678364355;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gkKulOGIgQcOiccW8SiWFbG5uMFAl4MHpehodedeHSc=;
        b=N5rJGRIVDLnZRfm5xv0pFjnznGJwFgGQlZu08Dzrj2tnJ9Sr4vK8V0dt2pvL2d1zaxK+TD
        ic+Nd89XBOztHsDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0BDE913A10;
        Thu,  9 Mar 2023 12:19:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qIx2O8LOCWSqbAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Mar 2023 12:19:14 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d897faab;
        Thu, 9 Mar 2023 12:19:13 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [RFC PATCH 1/2] fscrypt: new helper function - __fscrypt_prepare_atomic_open()
Date:   Thu,  9 Mar 2023 12:19:09 +0000
Message-Id: <20230309121910.18939-2-lhenriques@suse.de>
In-Reply-To: <20230309121910.18939-1-lhenriques@suse.de>
References: <20230309121910.18939-1-lhenriques@suse.de>
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
 fs/crypto/hooks.c       | 14 ++++++++++++++
 include/linux/fscrypt.h |  6 ++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b5..cbb828ecc5eb 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -117,6 +117,20 @@ int __fscrypt_prepare_readdir(struct inode *dir)
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
 
+int __fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
+{
+	int err = fscrypt_get_encryption_info(dir, true);
+
+	if (err || (!err && !fscrypt_has_encryption_key(dir))) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_NOKEY_NAME;
+		spin_unlock(&dentry->d_lock);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(__fscrypt_prepare_atomic_open);
+
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	if (attr->ia_valid & ATTR_SIZE)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4f5f8a651213..51c4b216a625 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -362,6 +362,7 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 			     struct fscrypt_name *fname);
 int __fscrypt_prepare_readdir(struct inode *dir);
+int __fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry);
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags);
@@ -688,6 +689,11 @@ static inline int __fscrypt_prepare_readdir(struct inode *dir)
 	return -EOPNOTSUPP;
 }
 
+int __fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __fscrypt_prepare_setattr(struct dentry *dentry,
 					    struct iattr *attr)
 {
