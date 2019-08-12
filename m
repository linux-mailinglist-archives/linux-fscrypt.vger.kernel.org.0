Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6E918A51B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfHLR6r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfHLR6r (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:47 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96528206C2;
        Mon, 12 Aug 2019 17:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632725;
        bh=gwzqn3llqC1AS6sQL4No2vAn4SYUBhOOYcgLt5xtMIA=;
        h=From:To:Cc:Subject:Date:From;
        b=Nr6GVmOEGY2Vlza95fjJ6oWVtqNPNtfpkdjFIw6BbYDuda1p8o4fFbhzdTyYfLO15
         nhTy/qjgaQX4GhQdOuFiQoEUL44OPqDSXyBrIKtXOCo7+zDQ1IsVaMyOMNLa+BY4BR
         PCzbcczfZFEtXeCF5+gik6vfov7l3deX/t3sOHLE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 0/9] xfstests: add tests for fscrypt key management improvements
Date:   Mon, 12 Aug 2019 10:58:00 -0700
Message-Id: <20190812175809.34810-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset adds xfstests for the kernel patchset
"[PATCH v8 00/20] fscrypt: key management improvements"
https://lkml.kernel.org/linux-fsdevel/20190805162521.90882-1-ebiggers@kernel.org/T/#u

These tests test the new ioctls for managing filesystem encryption keys,
and they test the new encryption policy version.

These tests depend on new xfs_io commands, for which I've sent a
separate patchset for xfsprogs.

Note: currently only ext4, f2fs, and ubifs support encryption.  But I
was told previously that since the fscrypt API is generic and may be
supported by XFS in the future, the command-line wrappers for the
fscrypt ioctls should be in xfs_io rather than in fstests directly
(https://marc.info/?l=fstests&m=147976255831951&w=2).

We'll want to wait for the kernel patches to be mainlined before merging
this, but I'm making it available now for any early feedback.

This version of the xfstests patchset can also be retrieved from tag
"fscrypt-key-mgmt-improvements_2019-08-12" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

Eric Biggers (9):
  common/encrypt: disambiguate session encryption keys
  common/encrypt: add helper functions that wrap new xfs_io commands
  common/encrypt: support checking for v2 encryption policy support
  common/encrypt: support verifying ciphertext of v2 encryption policies
  generic: add basic test for fscrypt API additions
  generic: add test for non-root use of fscrypt API additions
  generic: verify ciphertext of v2 encryption policies with AES-256
  generic: verify ciphertext of v2 encryption policies with AES-128
  generic: verify ciphertext of v2 encryption policies with Adiantum

 common/encrypt           | 180 +++++++++++++++++++----
 src/fscrypt-crypt-util.c | 304 ++++++++++++++++++++++++++++++++++-----
 tests/ext4/024           |   2 +-
 tests/generic/397        |   4 +-
 tests/generic/398        |   8 +-
 tests/generic/399        |   4 +-
 tests/generic/419        |   4 +-
 tests/generic/421        |   4 +-
 tests/generic/429        |   8 +-
 tests/generic/435        |   4 +-
 tests/generic/440        |   8 +-
 tests/generic/800        | 127 ++++++++++++++++
 tests/generic/800.out    |  91 ++++++++++++
 tests/generic/801        | 136 ++++++++++++++++++
 tests/generic/801.out    |  62 ++++++++
 tests/generic/802        |  43 ++++++
 tests/generic/802.out    |   6 +
 tests/generic/803        |  43 ++++++
 tests/generic/803.out    |   6 +
 tests/generic/804        |  45 ++++++
 tests/generic/804.out    |  11 ++
 tests/generic/group      |   5 +
 22 files changed, 1018 insertions(+), 87 deletions(-)
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out
 create mode 100755 tests/generic/801
 create mode 100644 tests/generic/801.out
 create mode 100755 tests/generic/802
 create mode 100644 tests/generic/802.out
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out
 create mode 100755 tests/generic/804
 create mode 100644 tests/generic/804.out

-- 
2.23.0.rc1.153.gdeed80330f-goog

