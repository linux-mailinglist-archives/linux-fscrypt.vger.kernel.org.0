Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3244C6393
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiB1HGi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbiB1HGg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:06:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854DE673D7;
        Sun, 27 Feb 2022 23:05:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366BEB80E45;
        Mon, 28 Feb 2022 07:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8451C340F1;
        Mon, 28 Feb 2022 07:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646031955;
        bh=J36PJOgeTlo/05NdauMIt29rmiW4FJKTj7+qOHuMfFc=;
        h=From:To:Cc:Subject:Date:From;
        b=IumIuW+vVgoP+3OQ4WH1GFqGIjggezNH4IL7hlwsnnKf3QZVnSQX1TO7a4ProyA91
         d5hKuLGtP7wZaeyqSp+Dxj4Z7IsOz30b/6y0kaYceIm9eZW1A4uGOHuWvErDK0Bh9+
         Xl6wtXMqkI62g1nyjAd25aWIcoF1VogII6Qq9QGe9etGpzR1GEwGZjfaFzC4NDxGqa
         IKMgBqoWGdAhT8gxdNtbgntTikva9p/b/9Yv5PwXipfMMExU+BXQA2g+F9Y/+rEMmk
         T5KezDTKNRn9XOo9TzGXM1jdQoBkhSZFBVz1I3nnJsHAaZp9mKxnbPP6qllOTtJlv1
         5NPu9TNQT4KGA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Israel Rukshin <israelr@nvidia.com>
Subject: [PATCH v5 0/3] Support for hardware-wrapped inline encryption keys
Date:   Sun, 27 Feb 2022 23:05:17 -0800
Message-Id: <20220228070520.74082-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[This patchset is based on v5.17-rc6.  It can also be retrieved from tag
"wrapped-keys-v5" of https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git]

This patchset adds block and fscrypt support for hardware-wrapped keys
when the inline encryption hardware supports them.

Hardware-wrapped keys are inline encryption keys that are wrapped
(encrypted) by a key internal to the hardware.  The wrapping key is an
ephemeral per-boot key, except at initial unlocking time.
Hardware-wrapped keys can only be unwrapped (decrypted) by the hardware,
e.g. when a key is programmed into a keyslot.  They are never visible to
software in raw form, except optionally during key generation.  The
hardware supports importing keys as well as generating keys itself.

This feature protects encryption keys from read-only compromises of
kernel memory, such as that which can occur during a cold boot attack.
It does this without limiting the number of keys that can be used, as
would be the case with solutions that didn't use key wrapping.

Hardware supporting this feature is present on recent Qualcomm SoCs
(SM8350 and later) as well as on the Google Tensor SoC.

This patchset is organized as follows:

- Patch 1 adds the block support and documentation, excluding the ioctls
  needed to get a key ready to be used in the first place.

- Patch 2 adds new block device ioctls for importing, generating, and
  preparing hardware-wrapped keys.

- Patch 3 adds the fscrypt support and documentation.

For full details, see the individual patches, especially the detailed
documentation they add to Documentation/block/inline-encryption.rst and
Documentation/filesystems/fscrypt.rst.

This feature also requires UFS driver changes.  For Qualcomm SoCs, these
are being worked on at
https://lore.kernel.org/linux-scsi/20211206225725.77512-1-quic_gaurkash@quicinc.com/T/#u.
I've verified that this feature works end-to-end on the SM8350 HDK with
the upstream kernel with these two patchsets applied.  (One caveat is
that a custom TrustZone image needs to be flashed to the board too; I
understand that Qualcomm is working on addressing that.)

I've also written xfstests which verify that this feature encrypts files
correctly.  These tests can currently be found at
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=wip-wrapped-keys.
I'll be sending these tests in a separate patchset.

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

Eric Biggers (3):
  block: add basic hardware-wrapped key support
  block: add ioctls to create and prepare hardware-wrapped keys
  fscrypt: add support for hardware-wrapped keys

 Documentation/block/inline-encryption.rst | 241 +++++++++++++++++++++-
 Documentation/filesystems/fscrypt.rst     | 154 ++++++++++++--
 block/blk-crypto-fallback.c               |   5 +-
 block/blk-crypto-internal.h               |  10 +
 block/blk-crypto-profile.c                |  97 +++++++++
 block/blk-crypto.c                        | 190 ++++++++++++++++-
 block/ioctl.c                             |   5 +
 drivers/md/dm-table.c                     |   1 +
 drivers/mmc/host/cqhci-crypto.c           |   2 +
 drivers/scsi/ufs/ufshcd-crypto.c          |   1 +
 fs/crypto/fscrypt_private.h               |  72 ++++++-
 fs/crypto/hkdf.c                          |   4 +-
 fs/crypto/inline_crypt.c                  |  75 ++++++-
 fs/crypto/keyring.c                       | 119 ++++++++---
 fs/crypto/keysetup.c                      |  71 ++++++-
 fs/crypto/keysetup_v1.c                   |   5 +-
 fs/crypto/policy.c                        |  11 +-
 include/linux/blk-crypto-profile.h        |  80 +++++++
 include/linux/blk-crypto.h                |  70 ++++++-
 include/uapi/linux/fs.h                   |  26 +++
 include/uapi/linux/fscrypt.h              |   7 +-
 21 files changed, 1153 insertions(+), 93 deletions(-)


base-commit: 7e57714cd0ad2d5bb90e50b5096a0e671dec1ef3
-- 
2.35.1

