Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7386BD7E9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjCPSOW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 14:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCPSOV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 14:14:21 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D8D3C29;
        Thu, 16 Mar 2023 11:14:20 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B984021A3B;
        Thu, 16 Mar 2023 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678990458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wPYxUl/V0E0fQjPzR03hgTUP8YMge8ZIO2XP7gX1C3s=;
        b=S6Cs9pO/cWfbFKvIjeuhYXDHc+oVPLHQVLSFtRwJGAXesXJBfftVsm6nHeA/uCRhuTPQK4
        Kgx1W9qnKxmufPDz1+3LpF4AAg2CS0nuO6OnFcDAEJbkpcWlMVThVPg0+b1yoLkJHk5wTr
        5i5hUQigWt43VgmNVR+dYg+zTKYkGXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678990458;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wPYxUl/V0E0fQjPzR03hgTUP8YMge8ZIO2XP7gX1C3s=;
        b=ylKYUdoHK6tYD29ZZc7kL6KnlL1I54rv2q+e0f/LpOy42rFxpHgCT5eR7QAjXMZ+Ax61sL
        ovSqcNwIHtqn/TBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1D18C133E0;
        Thu, 16 Mar 2023 18:14:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SSvEA3pcE2RtXAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 16 Mar 2023 18:14:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 36427925;
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
Subject: [PATCH v3 0/3] ceph: fscrypt: fix atomic open bug for encrypted directories
Date:   Thu, 16 Mar 2023 18:14:10 +0000
Message-Id: <20230316181413.26916-1-lhenriques@suse.de>
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

Changes since v2:
- Make helper more generic and to be used both in lookup and atomic open
  operations
- Modify ceph_lookup (patch 0002) and ceph_atomic_open (patch 0003) to use
  the new helper

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

Luís Henriques (3):
  fscrypt: new helper function - fscrypt_prepare_lookup_partial()
  ceph: switch ceph_open() to use new fscrypt helper
  ceph: switch ceph_open_atomic() to use the new fscrypt helper

 fs/ceph/dir.c           | 13 +++++++------
 fs/ceph/file.c          |  8 +++-----
 fs/crypto/hooks.c       | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 4 files changed, 54 insertions(+), 11 deletions(-)

