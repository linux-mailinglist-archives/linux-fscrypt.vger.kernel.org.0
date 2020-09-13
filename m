Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9111A267EB7
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgIMIiE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgIMIiA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:00 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F603207C3;
        Sun, 13 Sep 2020 08:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986277;
        bh=1dWd0eaN+m2UtgMk0cP4qKXLdHH/WAl+lzlyqYHMukk=;
        h=From:To:Cc:Subject:Date:From;
        b=ipJmfRdPkFyhu56cjRGr0ZeqiutvWztlif5XXFufzYsh3cnphGpzhFj2St50YuRzV
         UEc86raNPAcu7mQKxuK5RikeZDuMTvQ05Qd714yLvl9T7hh+qV9FTm54tRi7DnLjpa
         b5bXy5JjPybx7ZRKtencxAsn2Ls25CJ+ro5fI+7A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 00/11] fscrypt: improve file creation flow
Date:   Sun, 13 Sep 2020 01:36:09 -0700
Message-Id: <20200913083620.170627-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This series reworks the implementation of creating new encrypted files
by introducing new helper functions that allow filesystems to set up the
inodes' keys earlier, prior to taking too many filesystem locks.

This fixes deadlocks that are possible during memory reclaim because
fscrypt_get_encryption_info() isn't GFP_NOFS-safe, yet it's called
during an ext4 transaction or under f2fs_lock_op().  It also fixes a
similar deadlock where f2fs can try to recursively lock a page when the
test_dummy_encryption mount option is in use.

It also solves an ordering problem that the ceph support for fscrypt
will have.  For more details about this ordering problem, see the
discussion on Jeff Layton's RFC patchsets for ceph fscrypt support
(v1: https://lkml.kernel.org/linux-fscrypt/20200821182813.52570-1-jlayton@kernel.org/T/#u
 v2: https://lkml.kernel.org/linux-fscrypt/20200904160537.76663-1-jlayton@kernel.org/T/#u).
Note that v2 of the ceph patchset is based on v1 of this patchset.

Patch 1 adds the above-mentioned new helper functions.  Patches 2-5
convert ext4, f2fs, and ubifs to use them, and patches 6-8 clean up a
few things afterwards.

Finally, patches 9-11 change the implementation of test_dummy_encryption
to no longer set up an encryption key for unencrypted directories, which
was confusing and was causing problems.

This patchset applies to the master branch of
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git.
It can also be retrieved from tag "fscrypt-file-creation-v2" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git.

I'm looking to apply this for 5.10; reviews are greatly appreciated!

Changed v1 => v2:
  - Added mention of another deadlock this fixes.
  - Added patches to improve the test_dummy_encryption implementation.
  - Dropped an ext4 cleanup patch that can be done separately later.
  - Lots of small cleanups, and a couple small fixes.

Eric Biggers (11):
  fscrypt: add fscrypt_prepare_new_inode() and fscrypt_set_context()
  ext4: factor out ext4_xattr_credits_for_new_inode()
  ext4: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  f2fs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  ubifs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  fscrypt: remove fscrypt_inherit_context()
  fscrypt: require that fscrypt_encrypt_symlink() already has key
  fscrypt: stop pretending that key setup is nofs-safe
  fscrypt: make "#define fscrypt_policy" user-only
  fscrypt: move fscrypt_prepare_symlink() out-of-line
  fscrypt: handle test_dummy_encryption in more logical way

 fs/crypto/fname.c            |  11 ++-
 fs/crypto/fscrypt_private.h  |  10 +-
 fs/crypto/hooks.c            |  65 +++++++++----
 fs/crypto/inline_crypt.c     |   7 +-
 fs/crypto/keysetup.c         | 163 +++++++++++++++++++++++--------
 fs/crypto/keysetup_v1.c      |   8 +-
 fs/crypto/policy.c           | 180 +++++++++++++++++++++--------------
 fs/ext4/ext4.h               |   6 +-
 fs/ext4/ialloc.c             | 119 ++++++++++++-----------
 fs/ext4/super.c              |  17 ++--
 fs/f2fs/dir.c                |   2 +-
 fs/f2fs/f2fs.h               |  25 +----
 fs/f2fs/namei.c              |   7 +-
 fs/f2fs/super.c              |  16 ++--
 fs/ubifs/dir.c               |  38 ++++----
 include/linux/fscrypt.h      | 121 ++++++++---------------
 include/uapi/linux/fscrypt.h |   6 +-
 17 files changed, 446 insertions(+), 355 deletions(-)

-- 
2.28.0

