Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C73150F38
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Feb 2020 19:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgBCSTN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Feb 2020 13:19:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:33396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727936AbgBCSTM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Feb 2020 13:19:12 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50DED20838;
        Mon,  3 Feb 2020 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580753952;
        bh=PRpA5nojw0LgQoNjUD6Ljs3ht9OPRMhDWbwEkI/W0gQ=;
        h=From:To:Cc:Subject:Date:From;
        b=D4pm7jG2h3mfu5kDYwCenB/eTHrFUrthPWKvl8Tw+feXHZ2klVB3k5g4pmg/pTdAh
         WOKUcMBP1Tu0q8RuoOuynQadz+nc85NvhwoJJx//un1rd6BfRh/BnscyXY2Z8doBJY
         WioOVC+ajbXcUL0TqlhYWEPdObS/o7UKEOBOF+70=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH v2 0/3] xfstests: test adding filesystem-level fscrypt key via key_id
Date:   Mon,  3 Feb 2020 10:18:52 -0800
Message-Id: <20200203181855.42987-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series adds a test which tests adding a key to a filesystem's
fscrypt keyring via an "fscrypt-provisioning" keyring key.  This is an
alternative to the normal method where the raw key is given directly.

The needed kernel support was merged in 5.6, so currently this test
needs the latest mainline kernel to run.

This test also depends on an xfs_io patch which adds the '-k' option to
the 'add_enckey' command, e.g.:

        xfs_io -c "add_enckey -k KEY_ID" MOUNTPOINT

This test is skipped if the needed kernel or xfs_io support is absent.

This has been tested on ext4, f2fs, and ubifs.

This series can also be retrieved from
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git
tag "fscrypt-provisioning_2020-02-03".

Changed since v1:
  - Fixed incorrect detection of kernel support.

Eric Biggers (3):
  common/rc: handle option with argument in _require_xfs_io_command()
  common/encrypt: move constant test key to common code
  generic: test adding filesystem-level fscrypt key via key_id

 common/encrypt        |  95 ++++++++++++++++++++++----
 common/rc             |   2 +-
 tests/generic/580     |  17 ++---
 tests/generic/806     | 155 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out |  73 ++++++++++++++++++++
 tests/generic/group   |   1 +
 6 files changed, 315 insertions(+), 28 deletions(-)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

-- 
2.25.0.341.g760bfbb309-goog

