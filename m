Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4696BD7EA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCPSOX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 14:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPSOV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 14:14:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D7E4EC1;
        Thu, 16 Mar 2023 11:14:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 758D421A3C;
        Thu, 16 Mar 2023 18:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678990459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGdKFa+t9AtyNNL810Ikd5XAxMLxqtaLrVKIwcRi6Ss=;
        b=17ThrwWhRX1o28X9jR3zdjQiJoykUsAbLq0s9gAY8NBdtXxfDzIYnhMiWp0GRO5jql9Glf
        FGib2kwWk/lBKpHZpIkY/rIyamU3vHrPnRD1ketPW7qupfyBPCVw0efBI8V00FtX0BHjAK
        dWGc5/LoK1Z5cDPc/DtjV/slIyCVcXc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678990459;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGdKFa+t9AtyNNL810Ikd5XAxMLxqtaLrVKIwcRi6Ss=;
        b=ea81TrPKoELSVxzoT3kCQD9E6h7jwVYkfxzQrODPRmnXUBAxfBZFjWS/dg/SPktflJPDSf
        /hfJmR3hC3+ZpuAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CEDDE133E0;
        Thu, 16 Mar 2023 18:14:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id KK1GL3pcE2RtXAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 16 Mar 2023 18:14:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 3553fba9;
        Thu, 16 Mar 2023 18:14:14 +0000 (UTC)
From:   =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
To:     Eric Biggers <ebiggers@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>
Subject: [PATCH v3 1/3] fscrypt: new helper function - fscrypt_prepare_lookup_partial()
Date:   Thu, 16 Mar 2023 18:14:11 +0000
Message-Id: <20230316181413.26916-2-lhenriques@suse.de>
In-Reply-To: <20230316181413.26916-1-lhenriques@suse.de>
References: <20230316181413.26916-1-lhenriques@suse.de>
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

This patch introduces a new helper function which can be used both in
lookups and in atomic_open operations by filesystems that want to handle
filename encryption and no-key dentries themselves.

The reason for this function to be used in atomic open is that this
operation can act as a lookup if handed a dentry that is negative.  And in
this case we may need to set DCACHE_NOKEY_NAME.

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/crypto/hooks.c       | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 2 files changed, 44 insertions(+)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 7b8c5a1104b5..4bebdeaadc52 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -117,6 +117,43 @@ int __fscrypt_prepare_readdir(struct inode *dir)
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_readdir);
 
+/**
+ * fscrypt_prepare_lookup_partial() - prepare lookup without filenames handling
+ * @dir: inode of parent directory
+ * @dentry: dentry to lookup
+ *
+ * This function can be used by filesystems that want/need to handle filename
+ * encryption and no-key name encoding themselves, and thus aren't able to use
+ * function fscrypt_prepare_lookup().
+
+ * This helper can be called from lookup and atomic open operations.  It will
+ * try to set the encryption info on the in @dir if the key is available and, if
+ * it isn't, it will also set the @dentry as non-key.
+ *
+ * The reason it needs to get the encryption info before checking if the
+ * directory has the encryption key is because the key may be available but the
+ * encryption info isn't yet set (maybe due to a drop_caches).  The regular open
+ * path will use fscrypt_prepare_lookup(), but if a filesystem can't use this
+ * function (because it handles the filename encryption and no-key dentries) the
+ * atomic_open requires a different approach.
+ *
+ * Return: 0 on success, or an error code if fscrypt_get_encryption_info()
+ * 	   fails.
+ */
+int fscrypt_prepare_lookup_partial(struct inode *dir, struct dentry *dentry)
+{
+	int err = fscrypt_get_encryption_info(dir, true);
+
+	if (!err && !fscrypt_has_encryption_key(dir)) {
+		spin_lock(&dentry->d_lock);
+		dentry->d_flags |= DCACHE_NOKEY_NAME;
+		spin_unlock(&dentry->d_lock);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_lookup_partial);
+
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	if (attr->ia_valid & ATTR_SIZE)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4f5f8a651213..d9a94cd56cda 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -362,6 +362,7 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
 			     struct fscrypt_name *fname);
 int __fscrypt_prepare_readdir(struct inode *dir);
+int fscrypt_prepare_lookup_partial(struct inode *dir, struct dentry *dentry);
 int __fscrypt_prepare_setattr(struct dentry *dentry, struct iattr *attr);
 int fscrypt_prepare_setflags(struct inode *inode,
 			     unsigned int oldflags, unsigned int flags);
@@ -688,6 +689,12 @@ static inline int __fscrypt_prepare_readdir(struct inode *dir)
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_prepare_lookup_partial(struct inode *dir,
+						 struct dentry *dentry)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int __fscrypt_prepare_setattr(struct dentry *dentry,
 					    struct iattr *attr)
 {
