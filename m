Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DB54528A1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Nov 2021 04:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhKPDi4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Nov 2021 22:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243413AbhKPDgi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Nov 2021 22:36:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FDF061B96;
        Tue, 16 Nov 2021 03:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637033621;
        bh=a63BQ+UbbewYa7etCzcJu01H6LWMaaONj8uLDMFqxww=;
        h=From:To:Cc:Subject:Date:From;
        b=sg9kGJ1mDg8Mwq4LdD6gLu7ZRJeiORLwaVZXoc+PhVNlzIyDqIInGkmo1cWFoRCu6
         9RkFmO1/4c4wdUOZqNbzEd/jmSxnESwF2KXxIy39TctSbepxs42rUoFdX+vY2Y/5//
         vivQS+nxYpkANpuDo+uoh+MryW4CidK30Ir6TdJy70bP/Y11MMmySgcn+3JyA1ptJy
         CziNQMK9zDq3HsC7lA/G2aSJ9ypejd6nRhA9IY2K2aWsUul/MoLOOy3T2sxj+wSzFL
         Av+EH/1VrNDQ72BW2+2kg6rP8Iec9OwNcDpXS+Z0xBMVUx2VNhP7SFK4isE2JezdRt
         qhlhwwXDDoJLw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [RFC PATCH v4 0/3] Support for hardware-wrapped inline encryption keys
Date:   Mon, 15 Nov 2021 19:32:37 -0800
Message-Id: <20211116033240.39001-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[ NOTE: this patchset isn't ready for merging yet because the UFS or
  eMMC driver changes needed for this feature to work end-to-end aren't
  yet complete.  Currently, SM8350 (Snapdragon 888) is the only
  upstream-supported platform with hardware that supports this feature.
  The corresponding driver support for SM8350 is being worked on at
  https://lore.kernel.org/linux-scsi/20211103231840.115521-1-quic_gaurkash@quicinc.com/T/#u ]

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

This patchset is based on v5.16-rc1.  It can also be retrieved from tag
"wrapped-keys-v4" of https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git

Changed v3 => v4:
    - Rebased onto v5.16-rc1 and dropped a few bits that were upstreamed.
    - Updated cover letter to link to Gaurav's UFS driver patchset.

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
 fs/crypto/fscrypt_private.h               |  72 ++++++-
 fs/crypto/hkdf.c                          |   4 +-
 fs/crypto/inline_crypt.c                  |  64 +++++-
 fs/crypto/keyring.c                       | 119 ++++++++---
 fs/crypto/keysetup.c                      |  71 ++++++-
 fs/crypto/keysetup_v1.c                   |   5 +-
 fs/crypto/policy.c                        |  11 +-
 include/linux/blk-crypto-profile.h        |  80 ++++++++
 include/linux/blk-crypto.h                |  70 ++++++-
 include/uapi/linux/fs.h                   |  19 ++
 include/uapi/linux/fscrypt.h              |   7 +-
 21 files changed, 1099 insertions(+), 93 deletions(-)

base-commit: fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf
-- 
2.33.1

