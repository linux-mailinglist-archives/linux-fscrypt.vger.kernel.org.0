Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDE83246F2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Feb 2021 23:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhBXWhc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 17:37:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232923AbhBXWhc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 17:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BEF064EDD;
        Wed, 24 Feb 2021 22:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614206211;
        bh=x/nWnbB+3ivlCcgV1cOpuSCQqmW8mE7ylvkwFkL5xN0=;
        h=From:To:Cc:Subject:Date:From;
        b=IGEzCV4CeIA6vT4lG2a+/xuBqZSLxGP3QLfmhYZwNrU9rFjuEdfZNiOGENx9OAaQG
         1sRdDwULVuXeAXIBlzc4VzC9M65HJ6GC0E7qmZ5liJy8s7ArQG2HCpszKLWU/a7DnD
         VNHq/VUFoVr3U+rUJoCmQUkmx9bf6VVxX03xwasrXKd6IeVEOJZJic9tpMSTTo11Um
         K3QFS8gpFXH1MH0EFBCY0cHDBTPrBnFpaz0BnK4kwKM4Atp25y5xH7H8cVXLCWUF+l
         DIMhg1EDm0W+3YmsEDLxYS2Bg+DP3oXLfk8NIMkT2LSesfP+Y/VGj/UQreJYFvtRCA
         C5xhwpkJx3OYA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v2 0/4] Test the FS_IOC_READ_VERITY_METADATA ioctl
Date:   Wed, 24 Feb 2021 14:35:33 -0800
Message-Id: <20210224223537.110491-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset adds tests for the FS_IOC_READ_VERITY_METADATA ioctl
(https://lkml.kernel.org/linux-fscrypt/20210115181819.34732-1-ebiggers@kernel.org/T/#u).

Running these tests requires a kernel at commit f7b36dc5cb37 or later
for FS_IOC_READ_VERITY_METADATA support, and fsverity-utils at commit
cf8fa5e5a7ac or later for 'dump_metadata' subcommand support.

Like the other fs-verity tests, they also require an ext4 or f2fs
filesystem, and CONFIG_FS_VERITY=y.  The second test also requires
CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y.

As usual the tests will skip themselves if the prerequisites aren't met.

Changed v1 => v2:
   - Updated cover letter and removed RFC tag, now that the kernel and
     fsverity-utils patches have been merged.
   - Added executable bit to generic/902.
   - Improved some comments in common/verity.

Eric Biggers (4):
  generic: factor out helpers for fs-verity built-in signatures
  generic: add helpers for dumping fs-verity metadata
  generic: test retrieving verity Merkle tree and descriptor
  generic: test retrieving verity signature

 common/verity         | 73 ++++++++++++++++++++++++++++++++++++++-
 tests/generic/577     | 15 ++------
 tests/generic/901     | 79 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/901.out | 16 +++++++++
 tests/generic/902     | 66 ++++++++++++++++++++++++++++++++++++
 tests/generic/902.out |  7 ++++
 tests/generic/group   |  2 ++
 7 files changed, 245 insertions(+), 13 deletions(-)
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out
 create mode 100644 tests/generic/902
 create mode 100644 tests/generic/902.out

-- 
2.30.1

