Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E474DCAE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 23:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfFTVii (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 17:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfFTVii (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 17:38:38 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C455220657;
        Thu, 20 Jun 2019 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066717;
        bh=yEG3vC7ixbuXelNYA7seRr/QNRJr1EicOmlE5fCxzFQ=;
        h=From:To:Cc:Subject:Date:From;
        b=c4ZCFhbiDByOiTH43+vW/ggstzPGjebtsiDTS//cWSPMyRgzEjX9xlmMJdeEiS9Lu
         gtiaqFtR7dfrk5bT/3EKMtTLAvaHwsTH7NVDkKgNWjcVo3W/b8GS0TrG4A5as/1qtv
         xLE9QjGXP85PvgRlL1lFrR+X5jz5TGpDcBXm+xrU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v2 0/8] xfstests: add fs-verity tests
Date:   Thu, 20 Jun 2019 14:36:06 -0700
Message-Id: <20190620213614.113685-1-ebiggers@kernel.org>
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
  is compatible with version 5 of the kernel patchset, which can be
  retrieved from tag "fsverity_2019-06-20" of
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git

- The fsverity utility program from
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git

- e2fsprogs v1.45.2 or later for ext4 tests, or f2fs-tools v1.11.0 or
  later for f2fs tests.

Example with kvm-xfstests:

	$ kvm-xfstests -c ext4,f2fs -g verity

For more information about fs-verity, see the file
Documentation/filesystems/fsverity.rst from the kernel patchset.

This version of the xfstests patchset can also be retrieved from tag
"fsverity_2019-06-20" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git

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
 common/verity         | 200 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/900     | 190 +++++++++++++++++++++++++++++++++++++++
 tests/generic/900.out |  71 +++++++++++++++
 tests/generic/901     |  73 +++++++++++++++
 tests/generic/901.out |  14 +++
 tests/generic/902     | 154 ++++++++++++++++++++++++++++++++
 tests/generic/902.out |  91 +++++++++++++++++++
 tests/generic/903     | 112 +++++++++++++++++++++++
 tests/generic/903.out |   5 ++
 tests/generic/904     |  80 +++++++++++++++++
 tests/generic/904.out |  12 +++
 tests/generic/905     | 141 +++++++++++++++++++++++++++++
 tests/generic/905.out |  34 +++++++
 tests/generic/group   |   6 ++
 16 files changed, 1209 insertions(+)
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

