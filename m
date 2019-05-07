Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D944D16DD3
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 May 2019 01:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfEGXar (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 May 2019 19:30:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:41862 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726091AbfEGXar (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 May 2019 19:30:47 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x47NUgJk013851
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 7 May 2019 19:30:43 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 55148420024; Tue,  7 May 2019 19:30:42 -0400 (EDT)
Date:   Tue, 7 May 2019 19:30:42 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [GIT PULL] fscrypt updates for 5.2
Message-ID: <20190507233042.GA28476@mit.edu>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The following changes since commit dc4060a5dc2557e6b5aa813bf5b73677299d62d2:

  Linux 5.1-rc5 (2019-04-14 15:17:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git tags/fscrypt_for_linus

for you to fetch changes up to 2c58d548f5706d085c4b009f6abb945220460632:

  fscrypt: cache decrypted symlink target in ->i_link (2019-04-17 12:43:29 -0400)

----------------------------------------------------------------
Clean up fscrypt's dcache revalidation support, and other
miscellaneous cleanups.

----------------------------------------------------------------
Eric Biggers (10):
      fscrypt: drop inode argument from fscrypt_get_ctx()
      fscrypt: remove WARN_ON_ONCE() when decryption fails
      fscrypt: use READ_ONCE() to access ->i_crypt_info
      fscrypt: clean up and improve dentry revalidation
      fscrypt: fix race allowing rename() and link() of ciphertext dentries
      fs, fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
      fscrypt: only set dentry_operations on ciphertext dentries
      fscrypt: fix race where ->lookup() marks plaintext dentry as ciphertext
      vfs: use READ_ONCE() to access ->i_link
      fscrypt: cache decrypted symlink target in ->i_link

 fs/crypto/bio.c         |  8 +++-----
 fs/crypto/crypto.c      | 74 ++++++++++++++++++++++++++++++++++-------------------------------------
 fs/crypto/fname.c       |  5 +++--
 fs/crypto/hooks.c       | 68 +++++++++++++++++++++++++++++++++++++++++++++++++----------------
 fs/crypto/keyinfo.c     | 25 ++++++++++++++++++++++--
 fs/crypto/policy.c      |  6 +++---
 fs/dcache.c             |  2 ++
 fs/ext4/ext4.h          | 62 ++++++++++++++++++++++++++++++++++++++++++++---------------
 fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------
 fs/ext4/readpage.c      |  2 +-
 fs/ext4/super.c         |  3 +++
 fs/f2fs/namei.c         | 17 ++++++++++-------
 fs/f2fs/super.c         |  3 +++
 fs/namei.c              |  4 ++--
 fs/ubifs/dir.c          |  8 +++-----
 fs/ubifs/super.c        |  3 +++
 include/linux/dcache.h  |  2 +-
 include/linux/fscrypt.h | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++---------------------
 18 files changed, 298 insertions(+), 144 deletions(-)
