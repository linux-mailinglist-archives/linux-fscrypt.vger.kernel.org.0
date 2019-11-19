Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C745E102F5D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Nov 2019 23:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfKSWcg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Nov 2019 17:32:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfKSWcg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Nov 2019 17:32:36 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3357922449;
        Tue, 19 Nov 2019 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574202755;
        bh=94/JMC3Z7dDoSfyF7dKHew9Qbo73AFzIdrdAOiJOQDE=;
        h=From:To:Cc:Subject:Date:From;
        b=NeTIeKLRbR7FRameC06vRfS0N11QiB4hGdrkTVooc6GJfiDdaD5plsEzFchgoVYti
         u6ZqXX23zTEJppHrHvKxfqiSLiTCRFQZPjWK+bVI7AjdE8P+jk1FZmeMbETWq8mlRb
         7aDHCQIktUIO9YWh3Om1xIwItxv491WrBi/KdWik=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [RFC PATCH 0/3] xfstests: test adding filesystem-level fscrypt key via key_id
Date:   Tue, 19 Nov 2019 14:31:27 -0800
Message-Id: <20191119223130.228341-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series adds a test which tests adding a key to a filesystem's
fscrypt keyring via an "fscrypt-provisioning" keyring key.  This is an
alternative to the normal method where the raw key is given directly.

I'm sending this out for comment, but it shouldn't be merged until the
corresponding kernel patch has reached mainline.  For more details, see
the kernel patch:
https://lkml.kernel.org/linux-fscrypt/20191119222447.226853-1-ebiggers@kernel.org/T/#u

This test depends on an xfs_io patch which adds the '-k' option to the
'add_enckey' command, e.g.:

	xfs_io -c "add_enckey -k KEY_ID" MOUNTPOINT

This test is skipped if the needed kernel or xfs_io support is absent.

This has been tested on ext4, f2fs, and ubifs.

To apply cleanly, my other xfstests patch series
"[RFC PATCH 0/5] xfstests: verify ciphertext of IV_INO_LBLK_64 encryption policies"
must be applied first.

This series can also be retrieved from
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
tag "fscrypt-provisioning_2019-11-19".

Eric Biggers (3):
  common/rc: handle option with argument in _require_xfs_io_command()
  common/encrypt: move constant test key to common code
  generic: test adding filesystem-level fscrypt key via key_id

 common/encrypt        |  95 +++++++++++++++++++++----
 common/rc             |   2 +-
 tests/generic/580     |  17 ++---
 tests/generic/806     | 156 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out |  73 ++++++++++++++++++++
 tests/generic/group   |   1 +
 6 files changed, 316 insertions(+), 28 deletions(-)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

-- 
2.24.0.432.g9d3f5f5b63-goog

