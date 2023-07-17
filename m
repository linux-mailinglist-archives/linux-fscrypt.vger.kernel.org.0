Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0E3755A38
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 05:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjGQDxO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 23:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjGQDxA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 23:53:00 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AAEE63;
        Sun, 16 Jul 2023 20:52:52 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D202783411;
        Sun, 16 Jul 2023 23:52:51 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689565972; bh=FC9XS0TsfsQndEoMNyn3UvjEEM9HtVYaYOyyZt7eyak=;
        h=From:To:Cc:Subject:Date:From;
        b=rn5rm9U/PVHB4vp3kuYsJXPahRzUrwLsZR9pH5C3AAcRQpQY93bAnwjxHUjYaYDpE
         l+rZVgB5bfDeMb4ZAF9BEvWC/Y4aT/sEi0yq4PRUelT3OhiRuZf9zCZtHCNBm4NSgY
         mDN5eVPjhfSL/CP9X8o9FRGf7g32i9G6060a+f9sf3/2QHyTa4b29YA/pJh9gKp4eW
         vpewwNNdjfHi4piDu+bNHgDaebcaNcbFElqO31GgUlfr8NuYUqjq6e5oifQ1sVZnDt
         BdauqAnU1tBxD+XJnUDLHRZhFSEMk+4WXWCDp/eZUwroskuS5p4tYk9PuXV5NszFe3
         IFJYmYH6CazxQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 00/17] btrfs: add encryption feature
Date:   Sun, 16 Jul 2023 23:52:31 -0400
Message-Id: <cover.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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
support to the block layer, fscrypt, and then btrfs. Later steps will
potentially add the ability to change the key used by a directory
(either for all data or just newly written data), allow use of inline
extents and verity items in combination with encryption, and enable
send/receive of encrypted volumes. This changeset is not suitable for
usage due to the lack of authenticated encryption.
 
In addition to the fscrypt patchsets, [3] [4], this changeset requires
the latest version of the btrfs-progs changeset, which is currently at
[5], and the latest version of the fstests changeset, [6]. It is based
on kdave/misc-next as of approximately now.

This changeset passes all encryption tests in fstests. It passes all of
the auto group for me, but others have reported generic/476 hangs for an
as yet unknown reason.

There are two other issues I know of in the encryption paths, both
observed from running dbench:
1) under unknown circumstances, the write checker reports a corrupt
leaf, reporting a dir item with location key type 105.
2) most easily observed when running dbench on a subvolume that's
encrypted, instead of just a directory, "scheduling while atomic"
warnings occur. This is because free_extent_map() now frees the
fscrypt_info, which frees a block crypto key. My best idea so far is to
offload extent map freeing with fscrypt_infos to a worker thread, but
that updates every callsite, and maybe it's better to move all the
free's outside of locks or something else; I haven't implemented this
yet.
This is certainly still in progress, but its current goal is to
demonstrate that the fscrypt extent encryption interface is sufficient.

I'm really excited about Qu's work to make extent buffers potentially be
either folios or vmalloc'd memory -- this would allow eliminating change 
'fscrypt: expose fscrypt_nokey_name' and the code using it.

[1] https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit
[2] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit
[3] https://lore.kernel.org/linux-fscrypt/cover.1688927423.git.sweettea-kernel@dorminy.me/T/#t
[4] https://lore.kernel.org/linux-fscrypt/cover.1688927487.git.sweettea-kernel@dorminy.me/T/#t
[5] https://lore.kernel.org/linux-btrfs/cover.1688068420.git.sweettea-kernel@dorminy.me/
[6] https://lore.kernel.org/linux-fscrypt/cover.1688929294.git.sweettea-kernel@dorminy.me/T/#t

Changelog:
v2: 
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
 fs/btrfs/extent_map.c           |   8 +
 fs/btrfs/extent_map.h           |   3 +
 fs/btrfs/file-item.c            |  29 +++
 fs/btrfs/file.c                 |   7 +-
 fs/btrfs/fs.h                   |   7 +-
 fs/btrfs/fscrypt.c              | 247 +++++++++++++++++++++++
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
 31 files changed, 1012 insertions(+), 144 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h


base-commit: 3610b041a635597e99095eb293b7008a7e454a06
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
prerequisite-patch-id: 0806e75961fb44ec787082efe4b5dcc0aa4a8187
prerequisite-patch-id: ca3622130a89edf2c8a3bffc3d3ee2e69f6d9fa3
prerequisite-patch-id: ef3a31583124b5b0bc748a5ca13ffb819ebfa90d
prerequisite-patch-id: 658afdf97c3b66740c8ad09f560baff194bb209d
prerequisite-patch-id: 6bfe984d8f9cbbb6c652c8b6707ef6fb313729ff
prerequisite-patch-id: 5e676d9f7f31cdeefc8ea28c4127ebbae91c78c3
prerequisite-patch-id: 9548198a82389442ff202c726b9041929f00401c
prerequisite-patch-id: 3acbb2de86fdd6953eae0db419c7fd7192eacdf7
prerequisite-patch-id: 7905d5c0886f806e164aae618334121d4a28cffa
prerequisite-patch-id: e74297e4986b2b68d716a450ef90b4f2c3dc6cd0
prerequisite-patch-id: 57f49e689ea732ecb2bf761fca90a228a966d71c
prerequisite-patch-id: 94d153796d396cf62c2fec6e6766479d897e2cd3
-- 
2.40.1

