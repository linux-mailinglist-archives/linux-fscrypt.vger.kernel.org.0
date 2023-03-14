Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA846B904D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 11:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjCNKks (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 06:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCNKkr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 06:40:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FCE12F1A;
        Tue, 14 Mar 2023 03:40:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1E93D21A77;
        Tue, 14 Mar 2023 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678790345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TPaFgIn5XsBkfQryStFIW5OHbcwX6REOoz2u1qCHyXU=;
        b=RsljtV6Se2Ekyu7uWAYBBLNav53UimNGlJqxQQ/In2Q95zc1u8c5VyMnpzl+CwaqEwOlLP
        k1dhXhrsbz90sVw6J8i3uI7xF5NBAoBkrv81P0p4PFTEDbTUhPTnd7PPbEdSb9DLGpYnCb
        6L8zwrdVgsfTpKPnkgqpCKkV5S27kUQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678790345;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TPaFgIn5XsBkfQryStFIW5OHbcwX6REOoz2u1qCHyXU=;
        b=kl8uGVRQrmkfk7omxzCcHdZ+51KsLEPSp7wm+DOnDVI7dzHrWs/q5mRw0VwGXIlqEIV0F9
        ZN7GODppyMSfLjAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B9D013A1B;
        Tue, 14 Mar 2023 10:39:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jR35GshOEGS4FQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 14 Mar 2023 10:39:04 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id ab8d290f;
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
Subject: [PATCH v2 0/2] ceph: fscrypt: fix atomic open bug for encrypted directories
Date:   Tue, 14 Mar 2023 10:39:00 +0000
Message-Id: <20230314103902.32592-1-lhenriques@suse.de>
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

Hi!

I started seeing fstest generic/123 failing in ceph fscrypt, when running it
with 'test_dummy_encryption'.  This test is quite simple:

1. Creates a directory with write permissions for root only
2. Writes into a file in that directory
3. Uses 'su' to try to modify that file as a different user, and
   gets -EPERM

All the test steps succeed, but the test fails to cleanup: 'rm -rf <dir>'
will fail with -ENOTEMPTY.  'strace' shows that calling unlinkat() to remove
the file got a -ENOENT and then -ENOTEMPTY for the directory.

This is because 'su' does a drop_caches ('su (874): drop_caches: 2' in
dmesg), and ceph's atomic open will do:

	if (IS_ENCRYPTED(dir)) {
		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
		if (!fscrypt_has_encryption_key(dir)) {
			spin_lock(&dentry->d_lock);
			dentry->d_flags |= DCACHE_NOKEY_NAME;
			spin_unlock(&dentry->d_lock);
		}
	}

Although 'dir' has the encryption key available, fscrypt_has_encryption_key()
will return 'false' because fscrypt info isn't yet set after the cache
cleanup.

The first patch will add a new helper for the atomic_open that will force
the fscrypt info to be loaded into an inode that has been evicted recently
but for which the key is still available.

The second patch switches ceph atomic_open to use the new fscrypt helper.

Cheers,
--
Luís

Changes since v1:
- Dropped IS_ENCRYPTED() from helper function because kerneldoc says
  already that it applies to encrypted directories and, most importantly,
  because it would introduce a different behaviour for
  CONFIG_FS_ENCRYPTION and !CONFIG_FS_ENCRYPTION.
- Rephrased helper kerneldoc

Changes since initial RFC (after Eric's review):
- Added kerneldoc comments to the new fscrypt helper
- Dropped '__' from helper name (now fscrypt_prepare_atomic_open())
- Added IS_ENCRYPTED() check in helper
- DCACHE_NOKEY_NAME is not set if fscrypt_get_encryption_info() returns an
  error
- Fixed helper for !CONFIG_FS_ENCRYPTION (now defined 'static inline')

Luís Henriques (2):
  fscrypt: new helper function - fscrypt_prepare_atomic_open()
  ceph: switch atomic open to use new fscrypt helper

 fs/ceph/file.c          |  8 +++-----
 fs/crypto/hooks.c       | 33 +++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 3 files changed, 43 insertions(+), 5 deletions(-)

