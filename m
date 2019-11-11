Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25A3F81D9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Nov 2019 22:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKKVFm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 Nov 2019 16:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbfKKVFm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 Nov 2019 16:05:42 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 512B0206BB;
        Mon, 11 Nov 2019 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573506341;
        bh=8LGZlQ9PjzhCJsXqUDgAmcCdBPdgGqN761KBPA+4UOs=;
        h=From:To:Cc:Subject:Date:From;
        b=bivwWQiB7QbNInWItFThfZloqxdcKLLAINjOVaFwh5ed+L5RJKzfVRT9pywiw1ebR
         Mawl4c5WbTQEMYCA6ZBv2rACB+jZQlBglczMjlHpz++AiQMU0e0rbrvMdJoeh/NeQQ
         k2Rc6PSdMnSYmdKD2L/UYPGhAprKqbojjB8M/Dbk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64 encryption policies
Date:   Mon, 11 Nov 2019 13:04:22 -0800
Message-Id: <20191111210427.137256-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
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

This is RFC for now since the kernel patches aren't in mainline yet
(they're queued for 5.5).

To run on ext4 this test also needs a version of e2fsprogs built from
the master branch, for support for the stable_inodes filesystem feature.

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
2.24.0.rc1.363.gb1bccd3e3d-goog

