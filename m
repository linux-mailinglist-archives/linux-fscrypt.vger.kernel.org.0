Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4229F5161E7
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbiEAFQR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240284AbiEAFQP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:16:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F7250E12;
        Sat, 30 Apr 2022 22:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6568B80CB7;
        Sun,  1 May 2022 05:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5C6C385A9;
        Sun,  1 May 2022 05:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651381966;
        bh=lyQVprEqofKA88ZqVyvAxgyulhSJmHuioX9oIOz5/Ho=;
        h=From:To:Cc:Subject:Date:From;
        b=D94sKXm1Ewdq61DUBjxojjZ5SeyesoqsXYzRu4w+7EGm+Q8ardsu/GSFUx/C++uA9
         WnBJXaJwyeH+Yc4Fe4pABwFQIglRcjdSwATubs0u8Hp9f/LYSk3wHA7YFZCoAZzvwO
         Wwv8zBRN1B4FhHvF+poq2FHm4UzyVVzmQp4heMOMbG5iuCmUbIBzo3ShwpF++d3z0D
         UFE/oJXvfivQN5yIEDmgRp++MvKag34kkleDWovEHiTW1hCVBkLXYhKqHAn142SANW
         K0C3O4JIZ5A6GquQnQQP6NphvplYaSvIeNct/0Qrq2LdE6GFGI2SjkjLSIuQ91ZY9M
         yqByXPrFDl6EA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 0/7] test_dummy_encryption fixes and cleanups
Date:   Sat, 30 Apr 2022 22:08:50 -0700
Message-Id: <20220501050857.538984-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series cleans up and fixes the way that ext4 and f2fs handle the
test_dummy_encryption mount option:

- Patches 1-2 make test_dummy_encryption consistently require that the
  'encrypt' feature flag already be enabled and that
  CONFIG_FS_ENCRYPTION be enabled.  Note, this will cause xfstest
  ext4/053 to start failing; my xfstests patch "ext4/053: update the
  test_dummy_encryption tests" will fix that.

- Patches 3-7 replace the fscrypt_set_test_dummy_encryption() helper
  function with new functions that work properly with the new mount API,
  by splitting up the parsing, checking, and applying steps.  These fix
  bugs that were introduced when ext4 started using the new mount API.

We can either take all these patches through the fscrypt tree, or we can
take them in multiple cycles as follows:

    1. patch 1 via ext4, patch 2 via f2fs, patch 3-4 via fscrypt
    2. patch 5 via ext4, patch 6 via f2fs
    3. patch 7 via fscrypt

Ted and Jaegeuk, let me know what you prefer.

Changed v1 => v2:
    - Added patches 2-7
    - Also reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION

Eric Biggers (7):
  ext4: only allow test_dummy_encryption when supported
  f2fs: reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
  fscrypt: factor out fscrypt_policy_to_key_spec()
  fscrypt: add new helper functions for test_dummy_encryption
  ext4: fix up test_dummy_encryption handling for new mount API
  f2fs: use the updated test_dummy_encryption helper functions
  fscrypt: remove fscrypt_set_test_dummy_encryption()

 fs/crypto/fscrypt_private.h |   6 +-
 fs/crypto/keyring.c         |  64 +++++++++++---
 fs/crypto/keysetup.c        |  20 +----
 fs/crypto/policy.c          | 121 +++++++++++++------------
 fs/ext4/ext4.h              |   6 --
 fs/ext4/super.c             | 172 ++++++++++++++++++++----------------
 fs/f2fs/super.c             |  28 ++++--
 include/linux/fscrypt.h     |  41 ++++++++-
 8 files changed, 280 insertions(+), 178 deletions(-)


base-commit: 8013d1d3d2e33236dee13a133fba49ad55045e79
-- 
2.36.0

