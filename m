Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9135ADC6A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbiIFAfl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIFAfk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:35:40 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7860D696D5;
        Mon,  5 Sep 2022 17:35:39 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C79A1803C8;
        Mon,  5 Sep 2022 20:35:38 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424539; bh=Epfovn1mynjXjzj56E3I1c5tDr9vlNsDHfjnuTcQ2cI=;
        h=From:To:Cc:Subject:Date:From;
        b=WigjglVPs36qjHY+z5+YmLXixKq+zspVWSlHcx3k+jAMXkmKYJPfhXAuMBhjTSV6N
         WMneGWkaMPSFrnBbtlNGY+SLsC1wpFOKHlMV7tWqsiBAxLIjUCd4bxxehOYFsv9TV7
         rxupOlId3X/TimGkxvaUP/6VYzLpJBY1nvgSVPqvTvvzwoH764c5aSnq1TW+r86pNQ
         lyGPjIKkH6saId3y/T8nKXB4xxldgQVi8Rjq8jnlAHFAvcgO97wvF/xWm0crFxbeYT
         T9HFsrP8VskzWz1ejo4pXXqxC4qd1M9oAMob3N7JVFLMbK+yfYV24qQmNitAuQBSfY
         XKOymXHiJTBkA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 00/20] btrfs: add fscrypt integration
Date:   Mon,  5 Sep 2022 20:35:15 -0400
Message-Id: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
snapshotting or reflinking or data relocation for btrfs. We have
refined this into a fscrypt extent context object, opaque to the
filesystem, which fscrypt uses to generate an IV associated with each
block in an extent. Thus, all the inodes sharing a particular
key and file extent may decrypt the extent.

This series implements this integration for the simple
case, non-compressed data extents. Followup changes will allow
encryption of compressed extents, inline extents, and verity items, and
will add tests around subvolume encryption. This series should provide
encryption for the simplest cases, but this series should not be used in
production, as there are likely bugs.
 
Preliminary btrfs-progs changes are available at [2]; fstests changes
are available at [3].

[1]
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/

Changelog:

v2:
 - Amended the fscrypt side to generically add extent contexts,
   hopefully as per Eric Biggers' past comments. IVs are now entirely
   abstracted within an extent context, and there is no longer a new
   encryption policy, as DIRECT_KEY sufficiently encapsulates the
   needs of extent-based encryption. Documented its usage in btrfs
   briefly in the documentation. 
 - Adjusted the btrfs side to deal in opaque extent contexts. Improved
   optimization to skip storing inode contexts if they are the same as
   the inode's root item's inode context.
 - Combined 'add fscrypt operation table to superblock' into 'start
   using fscrypt hooks'.
 - https://lore.kernel.org/linux-btrfs/cover.1662420176.git.sweettea-kernel@dorminy.me
 - progs: https://lore.kernel.org/linux-btrfs/cover.1662417859.git.sweettea-kernel@dorminy.me
 - tests: https://lore.kernel.org/linux-btrfs/cover.1662417905.git.sweettea-kernel@dorminy.me

v1:
 - Recombined the fscrypt changes back into this patchset.
 - Fixed several races and incorrectly ordered operations.
 - Improved IV retrieval to correctly distinguish between
   filename/symlink encryption and encryption of block 0 of a file.
 - https://lore.kernel.org/linux-btrfs/cover.1660744500.git.sweettea-kernel@dorminy.me
 - progs: https://lore.kernel.org/linux-btrfs/cover.1660729916.git.sweettea-kernel@dorminy.me
 - tests: https://lore.kernel.org/linux-btrfs/cover.1660729861.git.sweettea-kernel@dorminy.me

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

Omar Sandoval (14):
  fscrypt: expose fscrypt_nokey_name
  fscrypt: add flag allowing partially-encrypted directories
  fscrypt: add fscrypt_have_same_policy() to check inode compatibility
  btrfs: store directory's encryption state
  btrfs: factor a fscrypt_name matching method
  btrfs: disable various operations on encrypted inodes
  btrfs: start using fscrypt hooks.
  btrfs: add fscrypt_context items.
  btrfs: translate btrfs encryption flags and encrypted inode flag.
  btrfs: Add new FEATURE_INCOMPAT_FSCRYPT feature flag.
  btrfs: reuse encrypted filename hash when possible.
  btrfs: adapt directory read and lookup to potentially encrypted
    filenames
  btrfs: encrypt normal file extent data if appropriate
  btrfs: implement fscrypt ioctls

Sweet Tea Dorminy (6):
  fscrypt: allow fscrypt_generate_iv() to distinguish filenames
  fscrypt: add extent-based encryption
  fscrypt: document btrfs' fscrypt quirks.
  btrfs: use fscrypt_names instead of name/len everywhere.
  btrfs: setup fscrypt_names from dentrys using helper
  btrfs: store a fscrypt extent context per normal file extent

 Documentation/filesystems/fscrypt.rst |  62 ++-
 fs/btrfs/Makefile                     |   1 +
 fs/btrfs/btrfs_inode.h                |   3 +
 fs/btrfs/ctree.h                      | 119 ++++--
 fs/btrfs/delayed-inode.c              |  48 ++-
 fs/btrfs/delayed-inode.h              |   9 +-
 fs/btrfs/dir-item.c                   | 119 +++---
 fs/btrfs/extent_io.c                  |  93 ++++-
 fs/btrfs/extent_io.h                  |   2 +
 fs/btrfs/extent_map.h                 |   4 +
 fs/btrfs/file-item.c                  |  22 +-
 fs/btrfs/file.c                       |  11 +-
 fs/btrfs/fscrypt.c                    | 244 +++++++++++
 fs/btrfs/fscrypt.h                    |  49 +++
 fs/btrfs/inode-item.c                 |  84 ++--
 fs/btrfs/inode-item.h                 |  14 +-
 fs/btrfs/inode.c                      | 581 +++++++++++++++++++-------
 fs/btrfs/ioctl.c                      |  80 +++-
 fs/btrfs/ordered-data.c               |   9 +-
 fs/btrfs/ordered-data.h               |   4 +-
 fs/btrfs/print-tree.c                 |   4 +-
 fs/btrfs/props.c                      |  11 +-
 fs/btrfs/reflink.c                    |   8 +
 fs/btrfs/root-tree.c                  |  20 +-
 fs/btrfs/send.c                       | 141 ++++---
 fs/btrfs/super.c                      |   8 +-
 fs/btrfs/transaction.c                |  43 +-
 fs/btrfs/tree-checker.c               |  56 ++-
 fs/btrfs/tree-log.c                   | 237 ++++++-----
 fs/btrfs/tree-log.h                   |   4 +-
 fs/btrfs/xattr.c                      |  21 +-
 fs/crypto/crypto.c                    |  24 +-
 fs/crypto/fname.c                     |  60 +--
 fs/crypto/fscrypt_private.h           |  26 +-
 fs/crypto/inline_crypt.c              |  29 +-
 fs/crypto/policy.c                    | 103 +++++
 include/linux/fscrypt.h               |  81 ++++
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  26 ++
 39 files changed, 1881 insertions(+), 580 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.35.1

