Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8C64F274
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Dec 2022 21:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiLPUjL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Dec 2022 15:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLPUjJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Dec 2022 15:39:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DA163993;
        Fri, 16 Dec 2022 12:39:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E8B62220;
        Fri, 16 Dec 2022 20:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A688EC433D2;
        Fri, 16 Dec 2022 20:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671223147;
        bh=kHkwFBg9JHGbKCdnp8I340LigCd2k5hpwDzV52hwrnU=;
        h=From:To:Cc:Subject:Date:From;
        b=N/KQFftefTxw2L+2RR18Ogwofx6KS03IRxjHkblXxeLmNPU5f8JFzSZRV7aTkNZ2C
         5qSUspKlAfUs430f/qi7x7WQujrTDPzb/TyBbM+o9qRFBwBNlaZMwgHNivok7fC0Ra
         YScSvGCjHtr9YKyNLfau3gKH2x4XQ5Ls/gB748Qqg6lI2Bfe+WsOeB5KFvhc/l1xY7
         b5ns748t/RiWPQ/FOtBzZvEd/5XLnXHA7AXc+OfnW3P+6tvPLEDhsGTSodi4HdH0Ip
         sCsbbPz13zVVqGZEYeUTSRg7B1DDu88AHvBL8ZIywhyZbyMNU8mk9CDA3n9uotf0j/
         ZBifjrca/tNOw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>
Subject: [RFC PATCH v7 0/4] Support for hardware-wrapped inline encryption keys
Date:   Fri, 16 Dec 2022 12:36:32 -0800
Message-Id: <20221216203636.81491-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[ This patchset is based on mainline commit 77856d911a8c.
  It can also be retrieved from the tag "wrapped-keys-v7"
  https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git ]

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

Changed v6 => v7:
    - Rebased onto latest mainline.
    - Fixed a bug in fscrypt_prepare_inline_crypt_key().
    - Other cleanups.

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
 block/blk-crypto.c                            | 194 +++++++++++++-
 block/ioctl.c                                 |   5 +
 drivers/md/dm-table.c                         |   1 +
 drivers/mmc/host/cqhci-crypto.c               |   2 +
 drivers/ufs/core/ufshcd-crypto.c              |   1 +
 fs/crypto/fscrypt_private.h                   |  71 ++++-
 fs/crypto/hkdf.c                              |   4 +-
 fs/crypto/inline_crypt.c                      |  67 ++++-
 fs/crypto/keyring.c                           | 122 ++++++---
 fs/crypto/keysetup.c                          |  54 +++-
 fs/crypto/keysetup_v1.c                       |   5 +-
 fs/crypto/policy.c                            |  11 +-
 include/linux/blk-crypto-profile.h            |  73 ++++++
 include/linux/blk-crypto.h                    |  78 +++++-
 include/uapi/linux/blk-crypto.h               |  44 ++++
 include/uapi/linux/fs.h                       |   6 +-
 include/uapi/linux/fscrypt.h                  |   7 +-
 25 files changed, 1235 insertions(+), 100 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: 77856d911a8c8724ee8e2b09d55979fc1de8f1c0
-- 
2.38.1

