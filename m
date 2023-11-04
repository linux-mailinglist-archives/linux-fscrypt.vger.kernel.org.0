Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6786E7E1131
	for <lists+linux-fscrypt@lfdr.de>; Sat,  4 Nov 2023 22:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbjKDVRM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 4 Nov 2023 17:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjKDVRM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 4 Nov 2023 17:17:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A50DE;
        Sat,  4 Nov 2023 14:17:09 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED8AC433C7;
        Sat,  4 Nov 2023 21:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699132627;
        bh=bNs3feLdLchTR60ZWx2xRIgocIhuI3oRhzAlktlTm5E=;
        h=From:To:Cc:Subject:Date:From;
        b=FbDfwXTl1fvcfclbvnXEU7w/sSr9csunAypkyraQ5MFLcAKSwzMDV2ffZTgJBZGdl
         2cO/f6sfyxzNM0ZjIeopxTzoOq7rTvMXQrh01qu07ZXVO7A2fKxJx8fP9WWJ7Zy3CR
         d6Ifuwm0ImgFnvlRKE036mbq4wwMkZE+o3Tt4ZdZBVQ0IYCivPZnrFKKriOmgv9o1I
         U9ElMPIETtU0kjPIe56bzKjTA1uVHDagyb9/s8DSF7fWhhc7WHFxFzJRBp6R0ctJ9F
         prC352OiOZGVdjJ8JWH/LD0IsYceg8l4qW0tDHw+S2pZhtiaAvOiMQOC2WaT2k76CQ
         PC1WMmBYYLHXw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     kernel-team@android.com, Israel Rukshin <israelr@nvidia.com>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Griffin <peter.griffin@linaro.org>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [RFC PATCH v8 0/4] Support for hardware-wrapped inline encryption keys
Date:   Sat,  4 Nov 2023 14:12:55 -0700
Message-ID: <20231104211259.17448-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[ This patchset is based on mainline commit aea6bf908d730b01 ]

This RFC patchset adds the block and fscrypt support for
hardware-wrapped inline encryption keys, a security feature supported by
Qualcomm and Google SoCs that has already been used by Android for
several years (with some slight differences, but same overall design).

I last sent this patchset in December 2022
(https://lore.kernel.org/r/20221216203636.81491-1-ebiggers@kernel.org).
This feature continues to be blocked on the lack of upstream-ready
development platform(s) for this feature.  However, it looks like at
least one of sm8650 and gs101 will get there soon, and *maybe* even is
there already (when I have a chance, I need to try out those SoCs with
the very latest upstream and pending-upstream patches).  So things are
looking more optimistic now.  Several months ago Gaurav Kashyap also
updated his patchset for the sm8650 support for this feature
(https://lore.kernel.org/r/20230719170423.220033-1-quic_gaurkash@quicinc.com).
Therefore, so that people have something fresh to work on, I've rebased
and am resending this block+fscrypt support patchset.  Note that this is
a prerequisite for any platform specific patchsets, e.g. the sm8650 one.

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

Changes in v8:
    - Rebased onto latest mainline (v6.6-14263-gaea6bf908d73).
    - Removed checks for HW-wrapped keys compatibility between block
      devices in multi-block-device filesystems, as these were
      incompatible with device-mapper.  Doing this validation, which is
      not needed for current HW, would require a more comphensive design

Changes in v7:
    - Rebased onto latest mainline.
    - Fixed a bug in fscrypt_prepare_inline_crypt_key().
    - Other cleanups.

Changes in v6:
    - Downgraded the patchset back to RFC status.
    - Exposed the supported key types in sysfs.
    - Shortened some field names, e.g. longterm_wrapped_key => lt_key.
    - Avoided adding a new use of struct request_queue by fs/crypto/.
    - Moved the blk-crypto ioctls to a new blk-crypto UAPI header file
      and fixed their numbering.
    - Other cleanups.

Changes in v5:
    - Dropped the RFC tag, now that these patches are actually testable.
    - Split the BLKCRYPTOCREATEKEY ioctl into BLKCRYPTOIMPORTKEY and
      BLKCRYPTOGENERATEKEY.  (I'm thinking that these operations are
      distinct enough that two separate ioctls would be best.)
    - Added some warning messages in fscrypt_derive_sw_secret().
    - Rebased onto v5.17-rc6.

Changes in v4:
    - Rebased onto v5.16-rc1 and dropped a few bits that were upstreamed.
    - Updated cover letter to link to Gaurav's UFS driver patchset.

Changes in v3:
    - Dropped some fscrypt cleanups that were applied.
    - Rebased on top of the latest linux-block and fscrypt branches.
    - Minor cleanups.

Changes in v2:
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
 block/blk-crypto-profile.c                    | 103 ++++++++
 block/blk-crypto-sysfs.c                      |  35 +++
 block/blk-crypto.c                            | 194 +++++++++++++-
 block/ioctl.c                                 |   5 +
 drivers/md/dm-table.c                         |   1 +
 drivers/mmc/host/cqhci-crypto.c               |   2 +
 drivers/ufs/core/ufshcd-crypto.c              |   1 +
 fs/crypto/fscrypt_private.h                   |  71 ++++-
 fs/crypto/hkdf.c                              |   4 +-
 fs/crypto/inline_crypt.c                      |  44 +++-
 fs/crypto/keyring.c                           | 122 ++++++---
 fs/crypto/keysetup.c                          |  54 +++-
 fs/crypto/keysetup_v1.c                       |   5 +-
 fs/crypto/policy.c                            |  11 +-
 include/linux/blk-crypto-profile.h            |  73 ++++++
 include/linux/blk-crypto.h                    |  75 +++++-
 include/uapi/linux/blk-crypto.h               |  44 ++++
 include/uapi/linux/fs.h                       |   6 +-
 include/uapi/linux/fscrypt.h                  |   7 +-
 25 files changed, 1193 insertions(+), 100 deletions(-)
 create mode 100644 include/uapi/linux/blk-crypto.h


base-commit: aea6bf908d730b01bd264a8821159db9463c111c
-- 
2.42.0

