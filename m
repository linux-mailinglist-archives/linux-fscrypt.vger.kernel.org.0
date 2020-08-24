Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8514024F253
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 08:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHXGSS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 02:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgHXGSS (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 02:18:18 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6CF206B5;
        Mon, 24 Aug 2020 06:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598249898;
        bh=5Cg/F/P1MsSIqNAEKm5EcA85tMzmQDFgxtq+BwsOiXY=;
        h=From:To:Cc:Subject:Date:From;
        b=f893nZOHOk74YywNd+s2c7KM7U+ApkFK+G5wAxPqs247sQ2FcptH0qP9EtwzvEYBf
         LROjPrF6b7H17wnj5KGsZaPkgvTF6yctFlLpC0zde7Uvt1Qfhq8ilvE8jBprCzObNr
         jbaGalIhOAIFifcUwA2qyoWoyI0iCcGdq4CofU6w=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>
Subject: [RFC PATCH 0/8] fscrypt: avoid GFP_NOFS-unsafe key setup during transaction
Date:   Sun, 23 Aug 2020 23:17:04 -0700
Message-Id: <20200824061712.195654-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series fixes some deadlocks which are theoretically possible due to
fscrypt_get_encryption_info() being GFP_NOFS-unsafe, and thus not safe
to be called from within an ext4 transaction or under f2fs_lock_op().

The problem is solved by new helper functions which allow setting up the
key for new inodes earlier.  Patch 1 adds these helper functions.  Also
see that patch for a more detailed description of this problem.

Patches 2-6 then convert ext4, f2fs, and ubifs to use these new helpers.

Patch 7-8 then clean up a few things afterwards.

Coincidentally, this also solves some of the ordering problems that
ceph fscrypt support will have.  For more details about this, see the
discussion on Jeff Layton's RFC patchset for ceph fscrypt support
(https://lkml.kernel.org/linux-fscrypt/20200821182813.52570-1-jlayton@kernel.org/T/#u)
However, fscrypt_prepare_new_inode() still requires that the new
'struct inode' exist already, so it might not be enough for ceph yet.

This patchset applies to v5.9-rc2.

Eric Biggers (8):
  fscrypt: add fscrypt_prepare_new_inode() and fscrypt_set_context()
  ext4: factor out ext4_xattr_credits_for_new_inode()
  ext4: remove some #ifdefs in ext4_xattr_credits_for_new_inode()
  ext4: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  f2fs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  ubifs: use fscrypt_prepare_new_inode() and fscrypt_set_context()
  fscrypt: remove fscrypt_inherit_context()
  fscrypt: stop pretending that key setup is nofs-safe

 fs/crypto/fscrypt_private.h |   3 +
 fs/crypto/hooks.c           |  10 +-
 fs/crypto/inline_crypt.c    |   7 +-
 fs/crypto/keysetup.c        | 190 ++++++++++++++++++++++++++++--------
 fs/crypto/keysetup_v1.c     |   8 +-
 fs/crypto/policy.c          |  64 +++++++-----
 fs/ext4/ialloc.c            | 118 +++++++++++-----------
 fs/f2fs/dir.c               |   2 +-
 fs/f2fs/f2fs.h              |  16 ---
 fs/f2fs/namei.c             |   7 +-
 fs/ubifs/dir.c              |  26 ++---
 include/linux/fscrypt.h     |  18 +++-
 12 files changed, 293 insertions(+), 176 deletions(-)

-- 
2.28.0

