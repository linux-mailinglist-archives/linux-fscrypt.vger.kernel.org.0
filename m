Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED410F313
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Dec 2019 00:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfLBXCc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Dec 2019 18:02:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:59490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfLBXCc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Dec 2019 18:02:32 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A74622053B;
        Mon,  2 Dec 2019 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575327751;
        bh=0asNyhzdJ86VZdjRooqZ2Q97rIjL1CmrBTZeYvNzBiw=;
        h=From:To:Cc:Subject:Date:From;
        b=BbpJ+Mojt62C07P271EyYTpQtCHOe6AT3WK3KSyBPX+IXA7/gDmLxKpPymq2FURAX
         Y/bQT/75/1IKp+Mse6JwlfUYPq3/H23m9Wb/VSpdfBWKUnlx4K2/0p+oMWy+xCUb0M
         k2H7BU2WabxmoZdad1Yt0Zq5Po6u567sRGo+xBE8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH v2 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64 encryption policies
Date:   Mon,  2 Dec 2019 15:01:50 -0800
Message-Id: <20191202230155.99071-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This series adds an xfstest which tests that the encryption for
IV_INO_LBLK_64 encryption policies is being done correctly.

IV_INO_LBLK_64 is a new fscrypt policy flag which modifies the
encryption to be optimized for inline encryption hardware compliant with
the UFS v2.1 standard or the upcoming version of the eMMC standard.  For
more information, see the kernel patchset:
https://lore.kernel.org/linux-fscrypt/20191024215438.138489-1-ebiggers@kernel.org/T/#u

The kernel patches have been merged into mainline and will be in v5.5.

In addition to the latest kernel, to run on ext4 this test also needs a
version of e2fsprogs built from the master branch, in order to get
support for formatting the filesystem with '-O stable_inodes'.

As usual, the test will skip itself if the prerequisites aren't met.

No real changes since v1; just rebased onto the latest xfstests master
branch and updated the cover letter.

Eric Biggers (5):
  fscrypt-crypt-util: create key_and_iv_params structure
  fscrypt-crypt-util: add HKDF context constants
  common/encrypt: create named variables for UAPI constants
  common/encrypt: support verifying ciphertext of IV_INO_LBLK_64
    policies
  generic: verify ciphertext of IV_INO_LBLK_64 encryption policies

 common/encrypt           | 126 +++++++++++++++++++++++++-------
 src/fscrypt-crypt-util.c | 151 ++++++++++++++++++++++++++++-----------
 tests/generic/805        |  43 +++++++++++
 tests/generic/805.out    |   6 ++
 tests/generic/group      |   1 +
 5 files changed, 259 insertions(+), 68 deletions(-)
 create mode 100644 tests/generic/805
 create mode 100644 tests/generic/805.out

-- 
2.24.0.393.g34dc348eaf-goog

