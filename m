Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB5C2898
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Sep 2019 23:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbfI3VT1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Sep 2019 17:19:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729880AbfI3VT0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Sep 2019 17:19:26 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CFBE20815;
        Mon, 30 Sep 2019 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569878365;
        bh=N/TprzOxAigJeHUbeoC5sDTujOY4691iZuzSOaznIiw=;
        h=From:To:Cc:Subject:Date:From;
        b=FH/Djm4rvJWYoH6uP0N9cFbRyM+jNW3pnMk1UsAYtjcACtNUatLKdYteYTd94JsBG
         zGFffIWJNCTH7QDzhdA9QqUFNXiBBc3F36+VjrrWXfXJCZ7NIA8S8tTuCDegg7CE+j
         C6W3VOtK1fmBFUQpm3C+eu4K9QW8ZnJPcRd55tjI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [PATCH v4 0/8] xfstests: add fs-verity tests
Date:   Mon, 30 Sep 2019 14:15:45 -0700
Message-Id: <20190930211553.64208-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add tests for fs-verity.  fs-verity is an ext4 and f2fs filesystem
feature which provides Merkle tree based hashing (similar to dm-verity)
for individual read-only files, mainly for the purpose of efficient
authenticity verification.  Other filesystems may add fs-verity support
later, using the same API.

Running these tests requires:

- Kernel v5.4-rc1 or later configured with CONFIG_FS_VERITY=y,
  and optionally CONFIG_FS_ENCRYPTION=y (for generic/904),
  CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y (for generic/905), and
  CONFIG_CRYPTO_SHA512=y (for generic/903 to cover SHA-512).

- The 'fsverity' utility program from
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git

- e2fsprogs v1.45.2 or later for ext4 tests, or f2fs-tools v1.11.0 or
  later for f2fs tests

- generic/905 also requires the 'openssl' program.

Example with kvm-xfstests:

    $ kvm-xfstests -c ext4,f2fs -g verity

For more information about fs-verity, see
https://www.kernel.org/doc/html/latest/filesystems/fsverity.html

This patchset can also be retrieved from tag "fsverity_2019-09-30" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

Note: my other pending xfstests patchset
"xfstests: add tests for fscrypt key management improvements"
renames the function _generate_encryption_key(), which is used by
generic/904 in this patchset.  This will need to be fixed up when the
second of these two patchsets is merged.

Changed since v3:

  - Update generic/900 to also test executing FS_IOC_ENABLE_VERITY while
    another process is already executing it on the same file.

Changed since v2:

  - Updated the signature verification test (generic/905) to match the
    latest kernel and fsverity-utils changes.

  - Added _fsv_sign() utility function.

  - Correctly skip the fs-verity tests on ext3-style filesystems.

Changed since v1:

  - Updated all tests to use the new fs-verity kernel API.

  - Many cleanups, additional checks in the tests, and other improvements.

  - Addressed review comments from Eryu Guan.

  - Added a test for the built-in signature verification feature.

  - Removed the fs-verity descriptor validation test, since the on-disk
    format of this part was greatly simplified and made fs-specific.

Eric Biggers (8):
  common/filter: add _filter_xfs_io_fiemap()
  common/verity: add common functions for testing fs-verity
  generic: test general behavior of verity files
  generic: test access controls on the fs-verity ioctls
  generic: test corrupting verity files
  generic: test that fs-verity is using the correct measurement values
  generic: test using fs-verity and fscrypt simultaneously
  generic: test the fs-verity built-in signature verification support

 common/config         |   2 +
 common/filter         |  24 +++++
 common/verity         | 215 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900     | 199 ++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  74 +++++++++++++++
 tests/generic/901     |  73 ++++++++++++++
 tests/generic/901.out |  14 +++
 tests/generic/902     | 154 ++++++++++++++++++++++++++++++
 tests/generic/902.out |  91 ++++++++++++++++++
 tests/generic/903     | 112 ++++++++++++++++++++++
 tests/generic/903.out |   5 +
 tests/generic/904     |  80 ++++++++++++++++
 tests/generic/904.out |  12 +++
 tests/generic/905     | 150 +++++++++++++++++++++++++++++
 tests/generic/905.out |  42 +++++++++
 tests/generic/group   |   6 ++
 16 files changed, 1253 insertions(+)
 create mode 100644 common/verity
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out
 create mode 100755 tests/generic/902
 create mode 100644 tests/generic/902.out
 create mode 100755 tests/generic/903
 create mode 100644 tests/generic/903.out
 create mode 100755 tests/generic/904
 create mode 100644 tests/generic/904.out
 create mode 100755 tests/generic/905
 create mode 100644 tests/generic/905.out

-- 
2.23.0.444.g18eeb5a265-goog

