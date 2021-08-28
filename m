Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588153FA277
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Aug 2021 02:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhH1AkN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Aug 2021 20:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhH1AkJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Aug 2021 20:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6EE560ED5;
        Sat, 28 Aug 2021 00:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630111159;
        bh=x8xm7Zu1FSSKdY8WmtQ+VGn86yR2UwhQHXTTFsESEJc=;
        h=From:To:Cc:Subject:Date:From;
        b=gz5LtA7lJ/qFiUQmXe7XKmH6+A3ERshpWUN3sU8Vaf8/kpaO18cF39ziXFFribGGd
         6hfVlT+ol1nYECDeOYzfjmspZL0HbVSIkT/qclNq02FTSzugC3R6hxEbTXm7eiyPJQ
         dfl7isFdJZJd4bLH0mOuuAHXjWi+JW5BHifgUaMAcKzGkjruL+SN4Zivo7IyHC+gGL
         c5GSfSgHmJAYlnMIAP0cbAn3T7z9Fq0u58ctj01VuA5/aTpNvLAZ3S2mK5EMLZldAZ
         ytJsutkZa2S7G3R1YvbjeXZPXafzHx2xD85GXlj0IFj6rrOi030/h/VxeJAlkej7yf
         eNtVsbmlbAAag==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: [RFC PATCH 0/4] Support for hardware-wrapped inline encryption keys
Date:   Fri, 27 Aug 2021 17:32:20 -0700
Message-Id: <20210828003224.33346-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.32.0
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
  Android kernels since early last year; upstreaming has been blocked on
  hardware availability and support.  However, an SoC that supports this
  feature (SM8350, a.k.a. Qualcomm Snapdragon 888) finally has been
  publicly released and had basic SoC support upstreamed.  Also, some
  other hardware will support the same feature soon.  So, things should
  be progressing soon.  So while the driver changes are gotten into an
  upstream-ready form, I wanted to get things started and give people a
  chance to give early feedback on the plan for how the kernel will
  support this type of hardware.  Also, anyone please let me know if
  you're interested in helping with the Qualcomm driver changes.]

This patchset adds framework-level support (i.e., block and fscrypt
support) for hardware-wrapped keys when the inline encryption hardware
supports them.  Hardware-wrapped keys are keys that are wrapped
(encrypted) by a key internal to the hardware.  Except at initial
unlocking time, the wrapping key is an ephemeral, per-boot key.
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
allow storage drivers to support hardware-wrapped keys, and changes to
fscrypt to allow the fscrypt master keys to be hardware-wrapped.

Key generation and import, as well as the conversion of keys from
long-term wrapped form to ephemerally-wrapped form, are currently
considered out-of-scope.  An open question is if/how the kernel can
provide a generic UAPI for these parts (new block ioctls that call
through to new methods in blk_ksm_ll_ops, maybe)?

For full details, see the individual patches, especially the detailed
documentation they add to Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

This patchset is organized as follows:

- Patch 1 adds the block support and documentation.

- Patches 2-3 are cleanups to fscrypt documentation and key validation.
  These aren't specific to hardware-wrapped keys per se, so these don't
  need to wait for the rest of the patches.

- Patch 4 adds the fscrypt support and documentation.

This patchset applies to v5.14-rc7.  It can also be retrieved from tag
"wrapped-keys-v1" of
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git.

Eric Biggers (4):
  block: add hardware-wrapped key support
  fscrypt: improve documentation for inline encryption
  fscrypt: allow 256-bit master keys with AES-256-XTS
  fscrypt: add support for hardware-wrapped keys

 Documentation/block/inline-encryption.rst | 222 ++++++++++++++++++++-
 Documentation/filesystems/fscrypt.rst     | 223 ++++++++++++++++++----
 block/blk-crypto-fallback.c               |   5 +-
 block/blk-crypto-internal.h               |   1 +
 block/blk-crypto.c                        |  45 ++++-
 block/keyslot-manager.c                   |  67 +++++--
 drivers/md/dm-table.c                     |   1 +
 drivers/mmc/host/cqhci-crypto.c           |   2 +
 drivers/scsi/ufs/ufshcd-crypto.c          |   1 +
 fs/crypto/fscrypt_private.h               |  88 ++++++++-
 fs/crypto/hkdf.c                          |  15 +-
 fs/crypto/inline_crypt.c                  |  64 ++++++-
 fs/crypto/keyring.c                       | 119 ++++++++----
 fs/crypto/keysetup.c                      | 131 +++++++++++--
 fs/crypto/keysetup_v1.c                   |   5 +-
 fs/crypto/policy.c                        |  11 +-
 include/linux/blk-crypto.h                |  70 ++++++-
 include/linux/keyslot-manager.h           |  20 ++
 include/uapi/linux/fscrypt.h              |   7 +-
 19 files changed, 959 insertions(+), 138 deletions(-)

base-commit: e22ce8eb631bdc47a4a4ea7ecf4e4ba499db4f93
-- 
2.32.0

