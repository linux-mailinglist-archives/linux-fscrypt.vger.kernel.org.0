Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297B76B23F5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Mar 2023 13:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjCIMTS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Mar 2023 07:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCIMTR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Mar 2023 07:19:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5268D1C7FC;
        Thu,  9 Mar 2023 04:19:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EB262219B9;
        Thu,  9 Mar 2023 12:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678364354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YtlE06MK38v4wUEGCfv9Lya1P+SBRtcUPdCKrIFmkWY=;
        b=QwhEfbgNYoa66mBXwPIK8+kmgDqlUpWJkv6ic6Gy6A7Rq9mKxoPQHH0y4k/0UxBPIHIQD0
        t6jTVm0xwkpiQBSBAt4Nf4r9NC3dflMXxqe8ns4QsiAPFD/5PQwL9Rvvds/MVfplCxK6ih
        ihqL+OtK1toFylXVi5L7C8629S9aKvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678364354;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YtlE06MK38v4wUEGCfv9Lya1P+SBRtcUPdCKrIFmkWY=;
        b=WIhze/eSN4I/rAvLyoYJrZuLC+wJtkXKfuRQSukyV+HhYD79jz9HhL9NvBqZqMXS717V9b
        UJHzZ04V1VSwo2Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4D12913A10;
        Thu,  9 Mar 2023 12:19:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id V2WpD8LOCWSqbAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Mar 2023 12:19:14 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id a07c9311;
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
Subject: [RFC PATCH 0/2] ceph: fscrypt: fix atomic open bug for encrypted directories
Date:   Thu,  9 Mar 2023 12:19:08 +0000
Message-Id: <20230309121910.18939-1-lhenriques@suse.de>
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
Luís Henriques

Luís Henriques (2):
  fscrypt: new helper function - __fscrypt_prepare_atomic_open()
  ceph: switch atomic open to use new fscrypt helper

 fs/ceph/file.c          |  8 +++-----
 fs/crypto/hooks.c       | 14 ++++++++++++++
 include/linux/fscrypt.h |  6 ++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

