Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3374774655
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjHHSzF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjHHSyn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:54:43 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3936969B;
        Tue,  8 Aug 2023 10:12:26 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 06B0283426;
        Tue,  8 Aug 2023 13:12:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514746; bh=ltJPIKed+rJFz900rWKsrLyKkq6m6RczQifZrm0BR1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=YK1Br0tb0s5mPKXHOUGS5FGFd0XBLuwRbVgROg75Rap/p5iqFtlBD84lz0z5oBPuz
         3pR9H3z1McAd1ztY/sVpDNASvzBhFHBoB4dKCbT95W9wLfNZVdXUPt3Oep9OYWPdLJ
         6gJrNHO8NekiJq3y/470XSV49zbj73Rff5dLzPVF988dwhTnQ8IVsQ748SJdE/+8yV
         TvbTabS2PpnpvPym492EKtsrDIHQr7gqCOR9RX9At80tIjKnUOBnR6hL97rshiEhVC
         ofk7QWdv3FMGW97B3EEfDX8lOSkor4l49qjIF7lDycKDhZv/JtfDP94dg+7iRZDE/P
         45DQ3XJd+AE1Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 00/17] btrfs: add encryption feature
Date:   Tue,  8 Aug 2023 13:12:02 -0400
Message-ID: <cover.1691510179.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Encryption has been desired for btrfs for a long time, in order to
provide some measure of security for data at rest. However, since btrfs
supports snapshots and reflinks, fscrypt encryption has previously been
incompatible since it relies on single inode ownership of data
locations. A design for fscrypt to support btrfs's requirements, and for
btrfs to use encryption, was constructed in October '21 [1] and refined
in November '22 [2]. 

This patch series builds on two fscrypt patch series adding extent-based
encryption to fscrypt, which allows using fscrypt in btrfs. The fscrypt
patchsets have no effect without a user, and this patchset makes btrfs
use the new extent encryption abilities of fscrypt.

These constitute the first of several steps laid out in the design
document [2]: the second step will be adding authenticated encryption
support to the block layer, fscrypt, and then btrfs. Other steps will
potentially add the ability to change the key used by a directory
(either for all data or just newly written data), allow use of inline
extents and verity items in combination with encryption, and enable
send/receive of encrypted volumes. This changeset is not suitable for
usage due to the lack of authenticated encryption.
 
In addition to the fscrypt patchsets, [3] [4], this changeset requires
the latest version of the btrfs-progs changeset, which is currently at
[5], and the latest version of the fstests changeset, [6]. It is based
on kdave/misc-next as of approximately now.

This changeset passes all encryption tests in fstests, and also survives
fsperf runs with lockdep turned on, including the previously failing
dbench test.

This version changes the format of extent contexts on disk as per
Josef's comment on v2: the encryption field in file extents now only
stores the fact of encryption with fscrypt, and the context stored at
the end of the file extent now stores the length of the fscrypt extent
as well as the fscrypt extent itself.

I remain really excited about Qu's work to make extent buffers
potentially be either folios or vmalloc'd memory -- this would allow
eliminating change 'fscrypt: expose fscrypt_nokey_name' and the code
using it.

[1] https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit
[2] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit
[3] https://lore.kernel.org/linux-fscrypt/cover.1691505830.git.sweettea-kernel@dorminy.me/
[4] https://lore.kernel.org/linux-fscrypt/cover.1691505882.git.sweettea-kernel@dorminy.me/
[5] https://lore.kernel.org/linux-btrfs/cover.1691520000.git.sweettea-kernel@dorminy.me/
[6] https://lore.kernel.org/linux-fscrypt/cover.1691530000.git.sweettea-kernel@dorminy.me/T/#t

Changelog:
v3: 
- Fixed an incorrect length in 'explicitly track file extent length and
  encryption' resulting in corrupted trees.
- Added missing handling of extent_map splitting.
- Changed format to store length with the fscrypt context instead of
  packed into the file extent's encryption field, thanks Josef.
- Reworked hunting for encrypted names to not leak nokey names
  hopefully.
- Added missing filename cleanup to btrfs_lookup_dentry(), thanks Luis.
- Hopefully handled all the miscellaneous review comments, thanks to all.

v2: 
- https://lore.kernel.org/linux-fscrypt/cover.1689564024.git.sweettea-kernel@dorminy.me/
- Re-enabled direct IO on encrypted files.
- Renamed inode context item as per Boris' request.
- Fixed a return value in inode context getting, as per Boris' note.
- Fixed an lblk calculation in checking mergeable bios.
- Disabled all extent map merging if either is encrypted, instead of
  comparing them, for now.
- Fixed getting the list of devices under btrfs, thanks to Luis for the
  report and Josef for pointing me at the right way to do it.

v1:
- https://lore.kernel.org/linux-btrfs/cover.1687988380.git.sweettea-kernel@dorminy.me/T/#t


Omar Sandoval (7):
  btrfs: disable various operations on encrypted inodes
  fscrypt: expose fscrypt_nokey_name
  btrfs: start using fscrypt hooks
  btrfs: add inode encryption contexts
  btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs: adapt readdir for encrypted and nokey names
  btrfs: implement fscrypt ioctls

Sweet Tea Dorminy (10):
  btrfs: disable verity on encrypted inodes
  btrfs: handle nokey names.
  btrfs: add encryption to CONFIG_BTRFS_DEBUG
  btrfs: add get_devices hook for fscrypt
  btrfs: turn on inlinecrypt mount option for encrypt
  btrfs: turn on the encryption ioctls
  btrfs: create and free extent fscrypt_infos
  btrfs: start tracking extent encryption context info
  btrfs: explicitly track file extent length and encryption
  btrfs: save and load fscrypt extent contexts

 fs/btrfs/Kconfig                |   2 +-
 fs/btrfs/Makefile               |   1 +
 fs/btrfs/accessors.h            |   3 +-
 fs/btrfs/btrfs_inode.h          |   3 +-
 fs/btrfs/ctree.h                |   2 +
 fs/btrfs/delayed-inode.c        |  29 ++-
 fs/btrfs/delayed-inode.h        |   4 +-
 fs/btrfs/dir-item.c             | 108 +++++++++-
 fs/btrfs/dir-item.h             |  13 +-
 fs/btrfs/extent_io.c            |  49 +++++
 fs/btrfs/extent_io.h            |   3 +
 fs/btrfs/extent_map.c           |  18 ++
 fs/btrfs/extent_map.h           |   1 +
 fs/btrfs/file-item.c            |  12 ++
 fs/btrfs/file.c                 |   7 +-
 fs/btrfs/fs.h                   |   7 +-
 fs/btrfs/fscrypt.c              | 341 ++++++++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h              | 102 ++++++++++
 fs/btrfs/inode.c                | 333 ++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c                |  41 +++-
 fs/btrfs/reflink.c              |   8 +
 fs/btrfs/root-tree.c            |   8 +-
 fs/btrfs/root-tree.h            |   2 +-
 fs/btrfs/super.c                |  17 ++
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/tree-checker.c         |  37 +++-
 fs/btrfs/tree-log.c             |  23 ++-
 fs/btrfs/verity.c               |   3 +
 fs/crypto/fname.c               |  39 +---
 include/linux/fscrypt.h         |  37 ++++
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  22 ++-
 32 files changed, 1131 insertions(+), 151 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h


base-commit: 54d2161835d828a9663f548f61d1d9c3d3482122
prerequisite-patch-id: 2f1424d04bb5a76abf0ecf2c9cd8426d300078ae
prerequisite-patch-id: ab342a72cf967dadfb8bec1320c5906fd3c6800f
prerequisite-patch-id: ced2a9dab36539f55c14cd74a28950087c475ff2
prerequisite-patch-id: d4f1a64c994c2fa0d2d4cab83f9ddff52f0622e9
prerequisite-patch-id: 1af0fc98277159b31c26bc5751663efc0d322d75
prerequisite-patch-id: 3b21b62208587486cf9b31618f7c3bc875362f1a
prerequisite-patch-id: c43d693f5b7c498a876d9ffcfc49c11a8ca93d80
prerequisite-patch-id: f120bde1cf47fbef1d9f8fd09cdcccc1408c3ff4
prerequisite-patch-id: c6a1f087d4a67b928b9c6af04e00310bfa74ace1
prerequisite-patch-id: 55ff7e03d98b9944c91b85974d6437a5ba3c353c
prerequisite-patch-id: adcb847e01bfe31f59b6c1710f3574a8c11c05f6
prerequisite-patch-id: 8ac189b6daaab42a03fdff4604ba49a60ec050da
prerequisite-patch-id: ca3622130a89edf2c8a3bffc3d3ee2e69f6d9fa3
prerequisite-patch-id: fee001b42c3d9d2025613ce76be03d7a94b1e5e2
prerequisite-patch-id: 2090ac664e0ce0b314af240d50ff99c3e8690979
prerequisite-patch-id: 5e676d9f7f31cdeefc8ea28c4127ebbae91c78c3
prerequisite-patch-id: 28f47e16193378c3187472c02f75673592daafd0
prerequisite-patch-id: b388d8c6b09884463cb156f28d48ba75acb73afd
prerequisite-patch-id: 5b7a3363907c503ccc3b650dea9f112e6d7e885e
prerequisite-patch-id: 879f43fe091d8d9c83a37f882a83c91bb9b7894f
prerequisite-patch-id: 21aeb9f14e1041576ae5a26714694e1e8dde0c21
prerequisite-patch-id: d0eeda13cb8063a357185e04557be4f4780bd3dc
prerequisite-patch-id: a10a13f19768707f4e47a3e1fb1b151dac0aa554
prerequisite-patch-id: 25495042ace3f4308bd958243dc3a4abc8ea53f6
prerequisite-patch-id: 94d153796d396cf62c2fec6e6766479d897e2cd3
-- 
2.41.0

