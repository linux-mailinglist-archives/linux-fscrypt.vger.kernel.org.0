Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913055C2E7
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jul 2019 20:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfGAS1a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jul 2019 14:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfGAS13 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jul 2019 14:27:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8133E2146F;
        Mon,  1 Jul 2019 18:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562005647;
        bh=n9HcezWaSPlpcASpI2bH07EeRES7gEyf5lL/IOSWc8E=;
        h=From:To:Cc:Subject:Date:From;
        b=g1Qo0ee2j38/uPs7qrsS9ErwaCGySuFiLPsChKtm4i6DxU+to9SFsNegQrvFhJ5zL
         EznJeRRngWVGRYa6ULrkomHuYjRC6RtjAHjNCgjDJ+kilosq+APZ1ymZPJyItH2CVP
         41gLjnyCZL65dqUwPD0A/jBNGuy6iNLyt6zFAfNU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v3 0/8] xfstests: add fs-verity tests
Date:   Mon,  1 Jul 2019 11:25:39 -0700
Message-Id: <20190701182547.165856-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add tests for fs-verity, a new feature for read-only file-based
authenticity protection.  fs-verity will be supported by ext4 and f2fs,
and perhaps by other filesystems later.  Running these tests requires:

- A kernel with the fs-verity patches applied and configured with
  CONFIG_FS_VERITY.  Specifically, this version of the xfstests patchset
  is compatible with version 6 of the kernel patchset, which can be
  retrieved from tag "fsverity_2019-07-01" of
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

- The fsverity utility program from
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git
  It needs to be commit 2151209ce1da or later.

- e2fsprogs v1.45.2 or later for ext4 tests, or f2fs-tools v1.11.0 or
  later for f2fs tests.

Example with kvm-xfstests:

	$ kvm-xfstests -c ext4,f2fs -g verity

For more information about fs-verity, see the file
Documentation/filesystems/fsverity.rst from the kernel patchset.

This version of the xfstests patchset can also be retrieved from tag
"fsverity_2019-07-01" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

Changed since v2 (Jun. 2019):

  - Updated the signature verification test (generic/905) to match the
    latest kernel and fsverity-utils changes.

  - Added _fsv_sign() utility function.

  - Correctly skip the fs-verity tests on ext3-style filesystems.

Changed since v1 (Dec. 2018):

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
 tests/generic/900     | 190 +++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  71 ++++++++++++++
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
 16 files changed, 1241 insertions(+)
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
2.22.0.410.gd8fdbe21b5-goog

