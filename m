Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555EA5EB729
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Sep 2022 03:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiI0Btf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Sep 2022 21:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiI0Btd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Sep 2022 21:49:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE518E53;
        Mon, 26 Sep 2022 18:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24544614FF;
        Tue, 27 Sep 2022 01:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613B0C433C1;
        Tue, 27 Sep 2022 01:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664243369;
        bh=Eu518v0ArlfpWppRcP6ZW1XVeJHR+VUkRhfqa+dnkXA=;
        h=From:To:Cc:Subject:Date:From;
        b=M8HCKNykvp9YsAQKV1cuG1myxFBLt1rxltjZFONqxpWhIYCUseEAwC9xcrUwtVuds
         6wgiD78w/Ls3DQNqfW/v/jhaHpXWcJASEZ/7reXHACFjR+ufs2/2G0qamKbXVdNWQX
         VmOdnTn0qWIzeG1k/AXEAAUbX2sqBebiP8p8he9Wt8LAatB5BLsDItCI3+3U/j3KFp
         yQ/62esHsdp5KFuodHSFobI2oNRsSCpQzKmSrxUEMOWyWyNzVf51ayKZHIlVwcJFsv
         I1kPs6IpGGoRr6XlC2g7ayNJxMbu0++tfB9sknZLvYiyPa1vRa1F6/FiysybaLoZxE
         uIa2XLEEBHVqg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>
Subject: [RFC PATCH v6 0/4] Support for hardware-wrapped inline encryption keys
Date:   Mon, 26 Sep 2022 18:47:14 -0700
Message-Id: <20220927014718.125308-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[This patchset is based on the master branch of
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git.  It can also be
retrieved from the tag "wrapped-keys-v6" of the same repo.]

This patchset adds the block and fscrypt support for hardware-wrapped
inline encryption keys, a security feature supported by recent Qualcomm
and Google SoCs.  Unfortunately, although this feature has already been
working in Android for several years (with some slight differences in
the software design), the SoC-specific software support needed to
actually test and use this feature end-to-end with the upstream kernel
continues to not be ready, mostly for reasons outside my control.
Therefore, I've downgraded this patchset back to a RFC.  Nevertheless,
I'd greatly appreciate feedback on it.

This feature is described in full detail in the included Documentation
changes.  But to summarize, hardware-wrapped keys are inline encryption
keys that are wrapped (encrypted) by a key internal to the hardware so
that they can only be unwrapped (decrypted) by the hardware.  Initially
keys are wrapped with a permanent hardware key, but during actual use
they are re-wrapped with a per-boot ephemeral key for improved security.
The hardware supports importing keys as well as generating keys itself.

This feature protects encryption keys from read-only compromises of
kernel memory, such as that which can occur during a cold boot attack.
It does this without limiting the number of keys that can be used, as
would be the case with solutions that didn't use key wrapping.

This differs from the existing support for hardware-wrapped keys in the
kernel crypto API (which also goes by names such as "hardware-bound
keys", depending on the driver) in the same way that the crypto API
differs from blk-crypto: the crypto API is for general crypto
operations, whereas blk-crypto is for inline storage encryption.

I've written xfstests which test that this feature encrypts files
correctly.  I've sent these separately, and the latest version is at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=wip-wrapped-keys.

Changed v5 => v6:
    - Downgraded the patchset back to RFC status.
    - Exposed the supported key types in sysfs.
    - Shortened some field names, e.g. longterm_wrapped_key => lt_key.
    - Avoided adding a new use of struct request_queue by fs/crypto/.
    - Moved the blk-crypto ioctls to a new blk-crypto UAPI header file
      and fixed their numbering.
    - Other cleanups.

Changed v4 => v5:
    - Dropped the RFC tag, now that these patches are actually testable.
    - Split the BLKCRYPTOCREATEKEY ioctl into BLKCRYPTOIMPORTKEY and
      BLKCRYPTOGENERATEKEY.  (I'm thinking that these operations are
      distinct enough that two separate ioctls would be best.)
    - Added some warning messages in fscrypt_derive_sw_secret().
    - Rebased onto v5.17-rc6.

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

Eric Biggers (4):
  blk-crypto: add basic hardware-wrapped key support
  blk-crypto: show supported key types in sysfs
  blk-crypto: add ioctls to create and prepare hardware-wrapped keys
  fscrypt: add support for hardware-wrapped keys

 Documentation/ABI/stable/sysfs-block          |  18 ++
 Documentation/block/inline-encryption.rst     | 245 +++++++++++++++++-
 Documentation/filesystems/fscrypt.rst         | 154 +++++++++--
 .../userspace-api/ioctl/ioctl-number.rst      |   4 +-
 block/blk-crypto-fallback.c                   |   5 +-
 block/blk-crypto-internal.h                   |  10 +
 block/blk-crypto-profile.c                    | 119 +++++++++
 block/blk-crypto-sysfs.c                      |  35 +++
 block/blk-crypto.c                            | 193 +++++++++++++-
 block/ioctl.c                                 |   5 +
 drivers/md/dm-table.c                         |   1 +
 drivers/mmc/host/cqhci-crypto.c               |   2 +
 drivers/ufs/core/ufshcd-crypto.c              |   1 +
 fs/crypto/fscrypt_private.h                   |  70 ++++-
 fs/crypto/hkdf.c                              |   4 +-
 fs/crypto/inline_crypt.c                      |  64 ++++-
 fs/crypto/keyring.c                           | 122 ++++++---
 fs/crypto/keysetup.c                          |  54 +++-
 fs/crypto/keysetup_v1.c                       |   5 +-
 fs/crypto/policy.c                            |  11 +-
 include/linux/blk-crypto-profile.h            |  73 ++++++
 include/linux/blk-crypto.h                    |  78 +++++-
 include/uapi/linux/blk-crypto.h               |  44 ++++
 include/uapi/linux/fs.h                       |   6 +-
 include/uapi/linux/fscrypt.h                  |   7 +-
 25 files changed, 1233 insertions(+), 97 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: 0e91fc1e0f5c70ce575451103ec66c2ec21f1a6e
-- 
2.37.3

