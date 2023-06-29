Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A257741D1C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjF2Afx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjF2Afq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:46 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3E91FC2;
        Wed, 28 Jun 2023 17:35:45 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 483058079C;
        Wed, 28 Jun 2023 20:35:45 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998945; bh=16K2VR1hogQ5kSXxv4RPsXnkIImMxPuMMjd09hGZsdc=;
        h=From:To:Cc:Subject:Date:From;
        b=UY4L0tpx9REOAIwVszM9thn1GVdbdZGzGTzz/h31MNt1FtUAdTHGUOofdoaOHNbzr
         kWCe7RjJ0gVWBXQquY3YZS6p7Fcei45HYqt06jFJJTWW7/fm4cc1hibSVFE3eB4cur
         TzCK9waiJPlxmE82YXZVU5w0U6ZTtXdxEZoYsV2oXVqJny5q6u+BDLtvsunonNZcvY
         LHA7IE+owkj07Pou/YA798rkTPNniZy+IVpHoTxo4FhnZUtLbPmiG5VEQVLHE1v1DJ
         7dVdPfZDkupswFQ7lbw+TLNLUwNLBSvBXBt9TWJzF0BSZoZB9RHOb1S+8CJ4oc9Jq9
         MrtY76/cN/B/g==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 00/17] btrfs: add encryption feature
Date:   Wed, 28 Jun 2023 20:35:23 -0400
Message-Id: <cover.1687988380.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a changeset adding encryption to btrfs. It is not complete; it
does not support inline data or verity or authenticated encryption. It
is primarily intended as a proof that the fscrypt extent encryption
changeset it builds on work. 

As per the design doc refined in the fall of last year [1], btrfs
encryption has several steps: first, adding extent encryption to fscrypt
and then btrfs; second, adding authenticated encryption support to the
block layer, fscrypt, and then btrfs; and later adding potentially the
ability to change the key used by a directory (either for all data or
just newly written data) and/or allowing use of inline extents and
verity items in combination with encryption and/or enabling send/receive
of encrypted volumes. As such, this change is only the first step and is
unsafe.

This change does not pass a couple of encryption xfstests, because of
different properties of extent encryption. It hasn't been tested with
direct IO or RAID. Because currently extent encryption always uses inline
encryption (i.e. IO-block-only) for data encryption, it does not support
encryption of inline extents; similarly, since btrfs stores verity items
in the tree instead of in inline encryptable blocks on disk as other
filesystems do, btrfs cannot currently encrypt verity items. Finally,
this is insecure; the checksums are calculated on the unencrypted data
and stored unencrypted, which is a potential information leak. (This
will be addressed by authenticated encryption).

This changeset is built on two prior changesets to fscrypt: [2] and [3]
and should have no effect on unencrypted usage.

[1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
[2]
https://lore.kernel.org/linux-fscrypt/cover.1687988119.git.sweettea-kernel@dorminy.me/
[3]
https://lore.kernel.org/linux-fscrypt/cover.1687988246.git.sweettea-kernel@dorminy.me

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
  btrfs: use correct name hash for nokey names
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
 fs/btrfs/accessors.h            |  31 +++
 fs/btrfs/btrfs_inode.h          |   3 +-
 fs/btrfs/ctree.h                |   2 +
 fs/btrfs/delayed-inode.c        |  30 ++-
 fs/btrfs/delayed-inode.h        |   4 +-
 fs/btrfs/dir-item.c             |  81 ++++++--
 fs/btrfs/dir-item.h             |  13 +-
 fs/btrfs/extent_io.c            |  49 +++++
 fs/btrfs/extent_io.h            |   3 +
 fs/btrfs/extent_map.c           |   9 +
 fs/btrfs/extent_map.h           |   3 +
 fs/btrfs/file-item.c            |  29 +++
 fs/btrfs/file.c                 |  11 +-
 fs/btrfs/fs.h                   |   7 +-
 fs/btrfs/fscrypt.c              | 236 ++++++++++++++++++++++
 fs/btrfs/fscrypt.h              |  61 ++++++
 fs/btrfs/inode.c                | 333 +++++++++++++++++++++++++-------
 fs/btrfs/ioctl.c                |  42 +++-
 fs/btrfs/reflink.c              |   8 +
 fs/btrfs/root-tree.c            |   8 +-
 fs/btrfs/root-tree.h            |   2 +-
 fs/btrfs/super.c                |  17 ++
 fs/btrfs/tree-checker.c         |  37 +++-
 fs/btrfs/tree-log.c             |  28 ++-
 fs/btrfs/verity.c               |   3 +
 fs/crypto/fname.c               |  39 +---
 include/linux/fscrypt.h         |  37 ++++
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  20 ++
 31 files changed, 1004 insertions(+), 146 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h


base-commit: 212cb3d0b8f4abf657671f05dbe0b3d9d858211d
-- 
2.40.1

