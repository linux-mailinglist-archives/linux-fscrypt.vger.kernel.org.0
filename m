Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3856E6B778B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 13:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjCMMdS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 08:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjCMMdQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 08:33:16 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D00196A1;
        Mon, 13 Mar 2023 05:33:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F39C1FE0D;
        Mon, 13 Mar 2023 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678710794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wi/DSEelWohyw8yWLL1NnkiRzPqUQBsHap+bfimcrtg=;
        b=WeshQ6Lv8biUxqcFdv2eExqvHx3pToKI8CsYvXqUzknHdkGj3Qoq55kMlKsxSWMMIIlCct
        xAzPgAjc+CuddpxPoIL1nNx4Uut1NLIpRyhHU9NNb39F445cobArmPVfidnZ5QLVoQ9CMw
        tFEHd+euX7wEShNc18ROEFAnbrMSyLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678710794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wi/DSEelWohyw8yWLL1NnkiRzPqUQBsHap+bfimcrtg=;
        b=FJUMlQwRteHpzv87KQRR0kfn9YAHAMA9aGdtpc7g/wDK893ymVQKYQ+miN/qCZ5BfGarb2
        oS5UYcCrPCDhgACw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8CA8313582;
        Mon, 13 Mar 2023 12:33:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wHpQHwkYD2RnCQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Mar 2023 12:33:13 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 42149d88;
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
Subject: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
Date:   Mon, 13 Mar 2023 12:33:10 +0000
Message-Id: <20230313123310.13040-3-lhenriques@suse.de>
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

Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fixes
a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'dir'
has been evicted but the key is still available (for example, where there's
a drop_caches).

Signed-off-by: Luís Henriques <lhenriques@suse.de>
---
 fs/ceph/file.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index dee3b445f415..5ad57cc4c13b 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	ihold(dir);
 	if (IS_ENCRYPTED(dir)) {
 		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
-		if (!fscrypt_has_encryption_key(dir)) {
-			spin_lock(&dentry->d_lock);
-			dentry->d_flags |= DCACHE_NOKEY_NAME;
-			spin_unlock(&dentry->d_lock);
-		}
+		err = fscrypt_prepare_atomic_open(dir, dentry);
+		if (err)
+			goto out_req;
 	}
 
 	if (flags & O_CREAT) {
