Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3682A0EA
	for <lists+linux-fscrypt@lfdr.de>; Sat, 25 May 2019 00:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404344AbfEXWEn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 18:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404176AbfEXWEn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 18:04:43 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59C3A217F9;
        Fri, 24 May 2019 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558735481;
        bh=ZxgHKvU763F27jYNcNQ89B6QO75hoW7PKOE4wcdlm+4=;
        h=From:To:Cc:Subject:Date:From;
        b=dD/pt71ghmJqxKMWRcvdhgMX5jo9ovFhPqyjGx7KVc+wmhbfr6/3XJVqtZGJH48ZZ
         et9WN6uflvv7DmkuceihproLGhJF+H4mkifQbI0CaLAHs2cElw3nKN55vcVscSOY07
         OvbKnvq7nWvfnBIvxALb7P6O1ZwDb1f5MJH8Z8jU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH v2 0/7] xfstests: verify fscrypt-encrypted contents and filenames
Date:   Fri, 24 May 2019 15:04:18 -0700
Message-Id: <20190524220425.201170-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This series adds xfstests which verify that encrypted contents and
filenames on ext4 and f2fs are actually correct, i.e. that the
encryption uses the correct algorithms, keys, IVs, and padding amounts.
The new tests work by creating encrypted files, unmounting the
filesystem, reading the ciphertext from disk using dd and debugfs or
dump.f2fs, and then comparing it against ciphertext computed
independently by a new test program that implements the same algorithms.

These tests are important because:

- The whole point of file encryption is that the files are actually
  encrypted correctly on-disk.  Except for generic/399, current xfstests
  only tests the filesystem semantics, not the actual encryption.
  generic/399 only tests for incompressibility of encrypted file
  contents using one particular encryption setting, which isn't much.

- fscrypt now supports 4 main combinations of encryption settings,
  rather than 1 as it did originally.  This may be doubled to 8 soon
  (https://patchwork.kernel.org/patch/10952059/), and support for ext4
  encryption with sub-page blocks is in progress too.  We should test
  all settings.  And without tests, even if the initial implementation
  is correct, breakage in one specific setting could go undetected.

- Though Linux's crypto API has self-tests, these only test the
  algorithms themselves, not how they are used, e.g. by fscrypt.

Patch 1 is a cleanup patch.  Patches 2-4 add the common helpers for
ciphertext verification tests.  Patches 5-7 add the actual tests.

For ext4 these tests require e2fsprogs v1.45.1 or later, for a recent
debugfs fix.  For f2fs they require f2fs-tools built from the "dev"
branch (which should eventually become v1.13.0), for a dump.f2fs fix.
The tests check for the presence of these fixes before they run.

This series can also be retrieved from git at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
branch "ciphertext-verification".

I also have patches on top of this series which verify the ciphertext
produced from v2 encryption policies, which are proposed by my kernel
patch series "fscrypt: key management improvements"
(https://patchwork.kernel.org/cover/10951999/).  v2 encryption policies
will use a different key derivation function, and thus their ciphertext
will be different.  These additional patches can be found at branch
"fscrypt-key-mgmt-improvements" of my git repo above.  But I've arranged
things such that this shorter series can be applied earlier, to test
what's in the kernel now.

Changed since v1:

  - Drop the _require_get_encpolicy() helper function.
  - Rename some functions:
  	- _get_on_disk_filename() => _get_ciphertext_filename()
	- _get_file_block_list() => _get_ciphertext_block_list()
	- _dump_file_blocks() => _dump_ciphertext_blocks()
  - Mention minimum e2fsprogs and f2fs-tools versions in comments.
  - Use _fail() instead of _notrun() when support was already checked.
  - Minor cleanups to fscrypt-crypt-util.

Eric Biggers (7):
  common/encrypt: introduce helpers for set_encpolicy and get_encpolicy
  fscrypt-crypt-util: add utility for reproducing fscrypt encrypted data
  common/encrypt: support requiring other encryption settings
  common/encrypt: add helper for ciphertext verification tests
  generic: verify ciphertext of v1 encryption policies with AES-256
  generic: verify ciphertext of v1 encryption policies with AES-128
  generic: verify ciphertext of v1 encryption policies with Adiantum

 .gitignore               |    1 +
 common/encrypt           |  479 ++++++++++-
 src/Makefile             |    3 +-
 src/fscrypt-crypt-util.c | 1633 ++++++++++++++++++++++++++++++++++++++
 tests/ext4/024           |    3 +-
 tests/generic/395        |   26 +-
 tests/generic/395.out    |    2 +-
 tests/generic/396        |   15 +-
 tests/generic/397        |    3 +-
 tests/generic/398        |    5 +-
 tests/generic/399        |    3 +-
 tests/generic/419        |    3 +-
 tests/generic/421        |    3 +-
 tests/generic/429        |    3 +-
 tests/generic/435        |    3 +-
 tests/generic/440        |    5 +-
 tests/generic/700        |   41 +
 tests/generic/700.out    |    5 +
 tests/generic/701        |   41 +
 tests/generic/701.out    |    5 +
 tests/generic/702        |   43 +
 tests/generic/702.out    |   10 +
 tests/generic/group      |    3 +
 23 files changed, 2292 insertions(+), 46 deletions(-)
 create mode 100644 src/fscrypt-crypt-util.c
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out
 create mode 100755 tests/generic/701
 create mode 100644 tests/generic/701.out
 create mode 100755 tests/generic/702
 create mode 100644 tests/generic/702.out

-- 
2.22.0.rc1.257.g3120a18244-goog

