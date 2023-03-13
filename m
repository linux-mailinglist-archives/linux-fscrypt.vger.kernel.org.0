Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845D66B778C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Mar 2023 13:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCMMdT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 08:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCMMdQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 08:33:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE2E19127;
        Mon, 13 Mar 2023 05:33:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B8C0B221B4;
        Mon, 13 Mar 2023 12:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678710792; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=clL6isl+kRCjub6IYvTubyA1KWdyBcpxsCA8BvRWS64=;
        b=ynBkq9Jc8ZU6ci4AMmAMpO7o7lEmrVkCTioOZonMHMN585uolQKWXy2I5ezqIB7JzxdsiJ
        B0Yl2nkA++fdIXIHRJF0lbT0aATCcwmdmH43aeTTeZSvFTUQvpRoQj0AL9QJk0TnD9BwFN
        dxLkQuQkJ2cP28zshfsWJtQuU07BdK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678710792;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=clL6isl+kRCjub6IYvTubyA1KWdyBcpxsCA8BvRWS64=;
        b=uI4rhJsoXCvpymp30cEwbeMxOeB6fdG+1djc7TIhhBV/dDqtkwGeAGsc6WbokJOYZaP0NK
        oQbvM4+wNobryuAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2331013582;
        Mon, 13 Mar 2023 12:33:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UWyqBQgYD2RnCQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 13 Mar 2023 12:33:12 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 8f5c4974;
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
Subject: [PATCH 0/2] ceph: fscrypt: fix atomic open bug for encrypted directories
Date:   Mon, 13 Mar 2023 12:33:08 +0000
Message-Id: <20230313123310.13040-1-lhenriques@suse.de>
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
 fs/crypto/hooks.c       | 35 +++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h |  7 +++++++
 3 files changed, 45 insertions(+), 5 deletions(-)

