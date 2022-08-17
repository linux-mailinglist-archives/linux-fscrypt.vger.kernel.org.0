Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695885971F0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237413AbiHQOuU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbiHQOuT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:19 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 084F71C907;
        Wed, 17 Aug 2022 07:50:18 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D97468042B;
        Wed, 17 Aug 2022 10:50:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747818; bh=URrThOKdnuB6mNHORAhwfYD+VV/qTxKiExG8tMGrELQ=;
        h=From:To:Cc:Subject:Date:From;
        b=i3Qa/hQ4YJuTS80aaKPiB9/Q1R6UNzXH359QhtpIf188wZIXK2bspyKYSfBky9nWr
         UVmuRWW7R/lwx8T3zEIObIRJHBFwzERE1sOUXV6nV9ZdZL6tY/vKDVYbMigMEmfcto
         an2lW2N2MPS5TpCbDLCmnqJ2jD0AVmZSDVnAnMS0aN/JLRQ02wgr/MPq3g2HzXZlKx
         Gggtf4IAvSHQbpV7jxxnhTOaq2W0R/ylLT4XrWH+EH/1FmSVCZV4cKsO50mfmaDLVE
         OSZ3SLtC+BynQHNEM9tHUbn1rU/t8CBNKRtK5kUqFOpuLj6jUcZECPuRomKlWMolTc
         8d/wcgbnX8jeA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 00/21] btrfs: add fscrypt integration
Date:   Wed, 17 Aug 2022 10:49:44 -0400
Message-Id: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a changeset adding encryption to btrfs.

Last October, Omar Sandoval sent out a design document for having fscrypt
integration with btrfs [1]. In summary, it proposes btrfs storing its
own encryption IVs on a per-file-extent basis. fscrypt usually encrypts
files using an IV derived from per-inode information; this would prevent
snapshotting or reflinking or data relocation for btrfs, but by using an
IV associated with each file extent, all the inodes sharing a particular
key and file extent may decrypt successfully.

This series implements this integration for the simple
case, non-compressed data extents. Followup changes will allow
encryption of compressed extents, inline extents, and verity items. 
This series should provide encryption for the simplest cases, but
this series should not be used except for testing yet, as there are
likely bugs particularly around IV retrieval.
 
Preliminary btrfs-progs changes are available at [2]; fstests changes
are available at [3]. Additional tests around subvolume-level encryption
will be added in the next version. 

[1]
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/
[2] https://lore.kernel.org/linux-btrfs/cover.1660729916.git.sweettea-kernel@dorminy.me
[3] https://lore.kernel.org/linux-btrfs/cover.1660729861.git.sweettea-kernel@dorminy.me

Changelog:

v1:
 - Recombined the fscrypt changes back into this patchset.
 - Fixed several races and incorrectly ordered operations.
 - Improved IV retrieval to correctly distinguish between
   filename/symlink encryption and encryption of block 0 of a file.
 - https://lore.kernel.org/linux-btrfs/cover.1660744500.git.sweettea-kernel@dorminy.me
RFC v2: 
 - Fixed all warnings and known incorrectnesses.
 - Split fscrypt changes into their own patchset:
    https://lore.kernel.org/linux-fscrypt/cover.1658623235.git.sweettea-kernel@dorminy.me
 - Combined and reordered changes so that enabling fscrypt is the last change.
 - Removed unnecessary factoring.
 - Split a cleanup change off.
 - https://lore.kernel.org/linux-btrfs/cover.1658623319.git.sweettea-kernel@dorminy.me 

RFC v1:
 - https://lore.kernel.org/linux-btrfs/cover.1657707686.git.sweettea-kernel@dorminy.me


Omar Sandoval (16):
  fscrypt: expose fscrypt_nokey_name
  fscrypt: add flag allowing partially-encrypted directories
  fscrypt: add fscrypt_have_same_policy() to check inode's compatibility
  btrfs: store directorys' encryption state
  btrfs: factor a fscrypt_name matching method
  btrfs: disable various operations on encrypted inodes
  btrfs: add fscrypt operation table to superblock
  btrfs: start using fscrypt hooks.
  btrfs: add fscrypt_context items.
  btrfs: translate btrfs encryption flags and encrypted inode flag.
  btrfs: store an IV per encrypted normal file extent
  btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature flag.
  btrfs: reuse encrypted filename hash when possible.
  btrfs: adapt directory read and lookup to potentially encrypted
    filenames
  btrfs: encrypt normal file extent data if appropriate
  btrfs: implement fscrypt ioctls

Sweet Tea Dorminy (5):
  fscrypt: add a function for a filesystem to generate an IV
  fscrypt: add new encryption policy for btrfs.
  btrfs: use fscrypt_name's instead of name/len everywhere.
  btrfs: setup fscrypt_names from dentrys using helper
  btrfs: add iv generation function for fscrypt

 fs/btrfs/Makefile               |   1 +
 fs/btrfs/btrfs_inode.h          |   3 +
 fs/btrfs/ctree.h                | 113 +++++--
 fs/btrfs/delayed-inode.c        |  48 ++-
 fs/btrfs/delayed-inode.h        |   9 +-
 fs/btrfs/dir-item.c             | 119 ++++---
 fs/btrfs/extent_io.c            |  93 +++++-
 fs/btrfs/extent_io.h            |   2 +
 fs/btrfs/extent_map.h           |   8 +
 fs/btrfs/file-item.c            |  20 +-
 fs/btrfs/file.c                 |  11 +-
 fs/btrfs/fscrypt.c              | 224 +++++++++++++
 fs/btrfs/fscrypt.h              |  49 +++
 fs/btrfs/inode-item.c           |  84 ++---
 fs/btrfs/inode-item.h           |  14 +-
 fs/btrfs/inode.c                | 573 ++++++++++++++++++++++++--------
 fs/btrfs/ioctl.c                |  80 ++++-
 fs/btrfs/ordered-data.c         |  13 +-
 fs/btrfs/ordered-data.h         |   3 +-
 fs/btrfs/print-tree.c           |   4 +-
 fs/btrfs/props.c                |  11 +-
 fs/btrfs/reflink.c              |   8 +
 fs/btrfs/root-tree.c            |  20 +-
 fs/btrfs/send.c                 | 141 +++++---
 fs/btrfs/super.c                |   8 +-
 fs/btrfs/transaction.c          |  43 ++-
 fs/btrfs/tree-checker.c         |  56 +++-
 fs/btrfs/tree-log.c             | 233 +++++++------
 fs/btrfs/tree-log.h             |   4 +-
 fs/btrfs/xattr.c                |  21 +-
 fs/crypto/crypto.c              |  40 ++-
 fs/crypto/fname.c               |  56 +---
 fs/crypto/fscrypt_private.h     |   4 +-
 fs/crypto/inline_crypt.c        |  20 +-
 fs/crypto/keysetup.c            |   5 +
 fs/crypto/policy.c              |  48 ++-
 include/linux/fscrypt.h         |  62 +++-
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  26 ++
 include/uapi/linux/fscrypt.h    |   1 +
 40 files changed, 1719 insertions(+), 560 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.35.1

