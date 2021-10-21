Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF84436A66
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Oct 2021 20:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhJUSUW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Oct 2021 14:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232306AbhJUSUW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Oct 2021 14:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7CB361ABA;
        Thu, 21 Oct 2021 18:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634840285;
        bh=8fcdwKbPJ3DAlmVhO7uF1VahsQ5segPEdgzsPkODe4c=;
        h=From:To:Cc:Subject:Date:From;
        b=UWqMewDnQ3RvES5prFE3/POVZY9+5pNDpTdm3AUYLrGuMZKOF5e5VuC862w3KMTq3
         hq76/s8bmCBsLM8tXIBx7CUO5f8zcasr2ZGmI64lIugMCUEZCb1CJwtk+BD3SOkBbi
         hl5aIL0qnBckYbfDt09POuethoZkPWtgktaPBL0dAi8JcC+Opc9kibQzT/4L7uG3un
         +//uQg0Dov95Vbm88HJXTd2IXR6Smx0iVOYq7EMZSDnfoAq9TbiChg+god3tYBNgAS
         4j8xYiAyR7dFEMum0ih81YeXO+3M0s7RRA+H7DnHFMNmK/+K26EyZc7naApmOnAp3G
         FW9h2tMHjCaLQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [RFC PATCH v3 0/3] Support for hardware-wrapped inline encryption keys
Date:   Thu, 21 Oct 2021 11:16:05 -0700
Message-Id: <20211021181608.54127-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[ NOTE: this patchset is an RFC that isn't ready for merging yet because
  it doesn't yet include the vendor-specific UFS or eMMC driver changes
  needed to actually use the feature.  I.e., this patchset isn't
  sufficient to actually use hardware-wrapped keys with upstream yet.

  For context, hardware-wrapped key support has been out-of-tree in the
  Android kernels since January 2020; upstreaming has been blocked on
  hardware availability and support.  However, an SoC that supports this
  feature (SM8350, a.k.a. Qualcomm Snapdragon 888) finally has been
  publicly released and had basic SoC support upstreamed.  Also, some
  other SoCs will support the same feature soon, e.g. the "Tensor" SoC
  which was recently announced.  So, things should be progressing soon.
  So while the driver changes are gotten ready, I wanted to get things
  started and give people a chance to give early feedback on the plan
  for how the kernel will support this type of hardware.]

This patchset adds framework-level support (i.e., block and fscrypt
support) for hardware-wrapped keys when the inline encryption hardware
supports them.  Hardware-wrapped keys are inline encryption keys that
are wrapped (encrypted) by a key internal to the hardware.  Except at
initial unlocking time, the wrapping key is an ephemeral, per-boot key.
Hardware-wrapped keys can only be unwrapped (decrypted) by the hardware,
e.g. when a key is programmed into a keyslot.  They are never visible to
software in raw form, except optionally during key generation (the
hardware supports importing keys as well as generating keys itself).

This feature protects the encryption keys from read-only compromises of
kernel memory, such as that which can occur during a cold boot attack.
It does this without limiting the number of keys that can be used, as
would be the case with solutions that didn't use key wrapping.

The kernel changes to support this feature basically consist of changes
to blk-crypto to allow a blk_crypto_key to be hardware-wrapped and to
allow storage drivers to support hardware-wrapped keys, new block device
ioctls for creating and preparing hardware-wrapped keys, and changes to
fscrypt to allow the fscrypt master keys to be hardware-wrapped.

For full details, see the individual patches, especially the detailed
documentation they add to Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

This patchset is organized as follows:

- Patch 1 adds the block support and documentation, excluding the ioctls
  needed to get a key ready to be used in the first place.

- Patch 2 adds new block device ioctls for creating and preparing
  hardware-wrapped keys.

- Patch 3 adds the fscrypt support and documentation.

This patchset is based on top of linux-block/for-next
(https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git/log/?h=for-next)
and fscrypt/master
(https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=master).
It can also be retrieved from tag "wrapped-keys-v3" of
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git

Changed v2 => v3:
    - Dropped some fscrypt cleanups that were applied.
    - Rebased on top of the latest linux-block and fscrypt branches.
    - Minor cleanups.

Changed v1 => v2:
    - Added new ioctls for creating and preparing hardware-wrapped keys.
    - Rebased onto my patchset which renames blk_keyslot_manager to
      blk_crypto_profile.

Eric Biggers (3):
  block: add basic hardware-wrapped key support
  block: add ioctls to create and prepare hardware-wrapped keys
  fscrypt: add support for hardware-wrapped keys

 Documentation/block/inline-encryption.rst | 238 +++++++++++++++++++++-
 Documentation/filesystems/fscrypt.rst     | 154 ++++++++++++--
 block/blk-crypto-fallback.c               |   5 +-
 block/blk-crypto-internal.h               |  10 +
 block/blk-crypto-profile.c                |  97 +++++++++
 block/blk-crypto.c                        | 158 +++++++++++++-
 block/ioctl.c                             |   4 +
 drivers/md/dm-table.c                     |   1 +
 drivers/mmc/host/cqhci-crypto.c           |   2 +
 drivers/scsi/ufs/ufshcd-crypto.c          |   1 +
 fs/crypto/fscrypt_private.h               |  83 +++++++-
 fs/crypto/hkdf.c                          |   4 +-
 fs/crypto/inline_crypt.c                  |  64 +++++-
 fs/crypto/keyring.c                       | 119 ++++++++---
 fs/crypto/keysetup.c                      |  74 ++++++-
 fs/crypto/keysetup_v1.c                   |   5 +-
 fs/crypto/policy.c                        |  11 +-
 include/linux/blk-crypto-profile.h        |  80 ++++++++
 include/linux/blk-crypto.h                |  70 ++++++-
 include/uapi/linux/fs.h                   |  19 ++
 include/uapi/linux/fscrypt.h              |   7 +-
 21 files changed, 1111 insertions(+), 95 deletions(-)

-- 
2.33.1

