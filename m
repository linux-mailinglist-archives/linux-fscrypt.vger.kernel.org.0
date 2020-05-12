Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364FE1D0319
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2020 01:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbgELXgH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 12 May 2020 19:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELXgH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 12 May 2020 19:36:07 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81FBD206F5;
        Tue, 12 May 2020 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589326567;
        bh=dUF4crkDJeVEpBzU47y9vojUlDTZiw0M+TOOvUz27To=;
        h=From:To:Cc:Subject:Date:From;
        b=afRq1cf5WfvzrPj28yGvgevWspYFNzgMZQgKcHyFYPR8VWWT/lmrfs0Qp0W4OBWac
         VPkSZMBGDAbKBltNqjKetKmJv4TN8MLM5nhsjla7Jv8NNrCEVVt7hnOExK3PBlq32H
         17Vq4/E4jU5X1pEAbWPA2sr/YRHRMuavi6kFLBuE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 0/4] fscrypt: make '-o test_dummy_encryption' support v2 policies
Date:   Tue, 12 May 2020 16:32:47 -0700
Message-Id: <20200512233251.118314-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

v1 encryption policies are deprecated in favor of v2, and some new
features (e.g. encryption+casefolding) are only being added for v2.

As a result, the "test_dummy_encryption" mount option (which is used for
encryption I/O testing with xfstests) needs to support v2 policies.

Therefore, this patchset adds support for specifying
"test_dummy_encryption=v2" (or "test_dummy_encryption=v1").
To make this possible, it reworks the way the test_dummy_encryption
mount option is handled to make it more flexible than a flag, and to
automatically add the test dummy key to the filesystem's keyring.

Patch 4 additionally changes the default to "v2".

This patchset applies to v5.7-rc4.

Eric Biggers (4):
  linux/parser.h: add include guards
  fscrypt: add fscrypt_add_test_dummy_key()
  fscrypt: support test_dummy_encryption=v2
  fscrypt: make test_dummy_encryption use v2 by default

 Documentation/filesystems/f2fs.rst |   6 +-
 fs/crypto/fscrypt_private.h        |   3 +
 fs/crypto/keyring.c                | 117 +++++++++++++++++----------
 fs/crypto/keysetup.c               |  15 ++--
 fs/crypto/policy.c                 | 125 +++++++++++++++++++++++++++++
 fs/ext4/ext4.h                     |   7 +-
 fs/ext4/super.c                    |  68 ++++++++++++----
 fs/f2fs/f2fs.h                     |   4 +-
 fs/f2fs/super.c                    |  85 ++++++++++++++------
 include/linux/fscrypt.h            |  52 ++++++++++--
 include/linux/parser.h             |   5 +-
 11 files changed, 383 insertions(+), 104 deletions(-)

-- 
2.26.2

