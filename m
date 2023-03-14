Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4236B9053
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCNKkv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 06:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCNKkr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 06:40:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA938EA3F;
        Tue, 14 Mar 2023 03:40:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 981D51F894;
        Tue, 14 Mar 2023 10:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678790346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wi/DSEelWohyw8yWLL1NnkiRzPqUQBsHap+bfimcrtg=;
        b=pp8rp5gwg206RXFeooK4jU9ksfs9M6tYkg43eV6GpTap9x1zwwRTMxjHk7FhgJbTGA8VVi
        flKSk6U1iXTSvb6g1+YWsEwKatYqa6Qi8ioRY6sij7Tt/ojb3X9zYJibWrVnCxpOMxNzcN
        3lRfpTUoWhEiWOoY8n7VmQH/qWUhjcQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678790346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wi/DSEelWohyw8yWLL1NnkiRzPqUQBsHap+bfimcrtg=;
        b=mEm3aYc73pxlRITgq89dOa5lD05SfAzogKumS9LMmhmijNmclN93Sb8SETIuQUwBx4Z/U0
        EqlV/xMc7iQR9WCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F096213A1B;
        Tue, 14 Mar 2023 10:39:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oES2N8lOEGS4FQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 10:39:05 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 39770183;
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
Subject: [PATCH v2 2/2] ceph: switch atomic open to use new fscrypt helper
Date:   Tue, 14 Mar 2023 10:39:02 +0000
Message-Id: <20230314103902.32592-3-lhenriques@suse.de>
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
