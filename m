Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA5CAB8899
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393789AbfITAiE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390299AbfITAiE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:38:04 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D22D214AF;
        Fri, 20 Sep 2019 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568939883;
        bh=WbuOsuhjC0bioKUi3VjQYXVnuVcga6YF51D3nBe9M/s=;
        h=From:To:Cc:Subject:Date:From;
        b=2sobyj9Yi6r/ge91qHmfP/AePbgiXad8o3qDREL04pIBh/de67tzTpzmBPCga5UsL
         JRs49p1hddLFyuTH9vkpcwiNStJ2dHpbsbxkmpeL+tZXWlRku1hykXbAuS7N0Hra9k
         1LFKQxV2APMwmiKLy10RuEYFI19OfvLVWdtHCAjw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 0/9] xfstests: add tests for fscrypt key management improvements
Date:   Thu, 19 Sep 2019 17:37:44 -0700
Message-Id: <20190920003753.40281-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset adds xfstests for the new fscrypt ioctls that were merged
for 5.4 (https://git.kernel.org/torvalds/c/734d1ed83e1f9b7b), namely the
new ioctls for managing filesystem encryption keys and the new/updated
ioctls for v2 encryption policy support.  It also includes ciphertext
verification tests for v2 encryption policies.

These tests depend on new xfs_io commands, for which I've sent a
separate patchset for xfsprogs.  They also need a kernel built from the
very latest mainline.  As is usual for xfstests, the tests will skip
themselves if the needed prerequisites aren't met.

Note: currently only ext4, f2fs, and ubifs support encryption.  But I
was told previously that since the fscrypt API is generic and may be
supported by XFS in the future, the command-line wrappers for the
fscrypt ioctls should be in xfs_io rather than in xfstests directly
(https://marc.info/?l=fstests&m=147976255831951&w=2).

This version of the xfstests patchset can also be retrieved from tag
"fscrypt-key-mgmt-improvements_2019-09-19" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

Changes since v1:

- Addressed comments from Eryu Guan regarding
  _require_encryption_policy_support().

- In generic/801, handle the fsgqa user having part of their key quota
  already consumed before beginning the test, in order to avoid a false
  test failure on some systems.

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

 common/encrypt           | 181 +++++++++++++++++++----
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
 tests/generic/801        | 144 +++++++++++++++++++
 tests/generic/801.out    |  62 ++++++++
 tests/generic/802        |  43 ++++++
 tests/generic/802.out    |   6 +
 tests/generic/803        |  43 ++++++
 tests/generic/803.out    |   6 +
 tests/generic/804        |  45 ++++++
 tests/generic/804.out    |  11 ++
 tests/generic/group      |   5 +
 22 files changed, 1028 insertions(+), 86 deletions(-)
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
2.23.0.351.gc4317032e6-goog

