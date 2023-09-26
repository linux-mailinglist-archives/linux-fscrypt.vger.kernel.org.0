Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769897AF219
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbjIZSDV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbjIZSDU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:20 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFF120
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:12 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-65af726775eso29760016d6.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751391; x=1696356191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=WHOM6S388KJvwFqokXWA615UUFzLeMQLny+zps3lA8c=;
        b=QpTLormUBChBXCdWKEv8pcjeQoMc13ZyJLBjpI5FBh5KVFUZjFVU5HOqkNiviysXtg
         TDseapZlyb/Z3AQqQ2lOWPj/EBVx8BU0ptrBrLccCjE08osjk+oyGT+/AgKvsI/wjxkh
         6Lj39PkANmAylEdIuahbh9e35uh8X4PcrsgnnAxNGxLsCYE0JLcIccoYwJtjuzBltq7w
         Zi7+0DpJFNv1gkQEb1xJw6y58JxFEhsCuItyOqE92eTNfB0AhbaV+oPGq7bJ5cJmEs1L
         ISerTtv8DuQZjVU2NoGNmQPrwSHUm71WjOgplcq+eDSH4PIs2sN58+/jM42xPp/WrPha
         BX8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751391; x=1696356191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHOM6S388KJvwFqokXWA615UUFzLeMQLny+zps3lA8c=;
        b=lqdak9THagjtrU2OObISdxUL+xgqptGRJHSefO+ex8A3jR4sMdXFMcdJk5NSqN1rmG
         P9zEei+HkTdbB0n8FclGYlbZFKAiaDzwSt9WJhh2YhmwCYQvwEt//q+ynRcng/BPpKfF
         64bNnrswb1oPqPr2c4FrJO1zHG3ut6XIqRxwESQ4Nlb/ha+vcpp3aOPWYDYxi92o+03d
         +1Nyfiz5KsmC7QC7lWB6UC0wkV6FMBn5Z46mkT1rKtfVeYh6Qd3wPkTBrDM6rYUT14U8
         d2Gf8PFuYt6hk2APszi0Cx6uv5nbjirhz38F9Kt2fYYUHiHE98ehfXCtvf8obMjKNKQm
         eglw==
X-Gm-Message-State: AOJu0YzxViiVzElX8Ta9Nz+emD2U7E9rf9bMTJb1myTM/pZq98SkRWqI
        H+sdlDqiY2l4+VBEM1PBVIWZwQ==
X-Google-Smtp-Source: AGHT+IH+6EMpDxABlT0IpUA8lYBqo0sKvwOQOujEXmCAb6T9R6kporWo3WGtNo6GLwyCfE7sVdvAGQ==
X-Received: by 2002:ad4:5e8e:0:b0:65b:4f2:13fa with SMTP id jl14-20020ad45e8e000000b0065b04f213famr4604105qvb.2.1695751391610;
        Tue, 26 Sep 2023 11:03:11 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u18-20020a0cb412000000b0065896b9fb15sm1675930qve.29.2023.09.26.11.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:11 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 00/35] btrfs: add fscrypt support
Date:   Tue, 26 Sep 2023 14:01:26 -0400
Message-ID: <cover.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This is the newly reworked fscrypt support for btrfs.  There have been a few
things changed since Sweet Tea's last post[1], and my RFC[2].  The changes from
Sweet Tea's patchset are mostly related to the fscrypt changes, but I'll detail
them here

- We have a fscrypt_extent_info struct that simply has the blk key in it and a
  nonce.
- We have a stripped down on disk context that just has what we need for
  extents.  At this time we only care about the nonce, everything else is
  supposed to match the owning inode.
- I've disabled everything except bog standard v2 policies to limit the
  complexity.
- Added the necessary hooks we needed for checksumming the encrypted bios.
- Reworked the on-disk stuff to be better described and accessed through
  helpers.
- Plumbed through the fscrypt_extent_info through everything to simplify the
  API calls we need from fscrypt.
- Instead of handling async key free'ing in fscrypt, handle the case where we're
  freeing extent_maps under the lock in a safe way.  This is cleaner than
  pushing this into fscrypt.
- Fixed a few things that fsstress uncovered in testing.

Changes to the fscrypt code since my RFC

- Took Eric's advice and added the policy and key to the extent context, this
  way if we want to in the future we could handle key changing.
- Added a helper to give us the fscrypt extent info context size.  We need the
  size ahead of time to setup the item properly.
- Fixed the blk crypto fallback not actually working with our process_bio
  callback.  Added a policy flag to make sure the checks work properly.
- Added some documentation.

Things left to do

- I still have to update fstests to deal with v2 only policies.  I haven't
  touched fstests at all yet, I've merely done my own rough testing with
  fsstress.
- Update the btrfs-progs patches.  This needs to be done to get the fstests
  stuff to work as well.
- fsverity still isn't encrypted.  I'm going to hit that next, it should be
  straightforward enough.

This is based on for-next from Dave's tree [3], but in case that moves between
now and then you can see my current branch here [4].  Thanks,

Josef

[1] https://lore.kernel.org/linux-fscrypt/cover.1693630890.git.sweettea-kernel@dorminy.me/
[2] https://lore.kernel.org/linux-btrfs/cover.1694738282.git.josef@toxicpanda.com/
[3] https://github.com/kdave/btrfs-devel/tree/for-next
[4] https://github.com/josefbacik/linux/tree/fscrypt

Josef Bacik (20):
  fscrypt: rename fscrypt_info => fscrypt_inode_info
  fscrypt: add per-extent encryption support
  fscrypt: disable all but standard v2 policies for extent encryption
  blk-crypto: add a process bio callback
  fscrypt: add documentation about extent encryption
  btrfs: add infrastructure for safe em freeing
  btrfs: add fscrypt_info and encryption_type to ordered_extent
  btrfs: plumb through setting the fscrypt_info for ordered extents
  btrfs: populate the ordered_extent with the fscrypt context
  btrfs: keep track of fscrypt info and orig_start for dio reads
  btrfs: add an optional encryption context to the end of file extents
  btrfs: pass through fscrypt_extent_info to the file extent helpers
  btrfs: pass the fscrypt_info through the replace extent infrastructure
  btrfs: implement the fscrypt extent encryption hooks
  btrfs: setup fscrypt_extent_info for new extents
  btrfs: populate ordered_extent with the orig offset
  btrfs: set the bio fscrypt context when applicable
  btrfs: add a bio argument to btrfs_csum_one_bio
  btrfs: add orig_logical to btrfs_bio
  btrfs: implement process_bio cb for fscrypt

Omar Sandoval (7):
  fscrypt: expose fscrypt_nokey_name
  btrfs: disable various operations on encrypted inodes
  btrfs: start using fscrypt hooks
  btrfs: add inode encryption contexts
  btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs: adapt readdir for encrypted and nokey names
  btrfs: implement fscrypt ioctls

Sweet Tea Dorminy (8):
  btrfs: disable verity on encrypted inodes
  btrfs: handle nokey names.
  btrfs: add encryption to CONFIG_BTRFS_DEBUG
  btrfs: add get_devices hook for fscrypt
  btrfs: turn on inlinecrypt mount option for encrypt
  btrfs: set file extent encryption excplicitly
  btrfs: add fscrypt_info and encryption_type to extent_map
  btrfs: explicitly track file extent length for replace and drop

 Documentation/filesystems/fscrypt.rst |  36 ++
 block/blk-crypto-fallback.c           |  28 ++
 block/blk-crypto-profile.c            |   2 +
 block/blk-crypto.c                    |   6 +-
 fs/btrfs/Makefile                     |   1 +
 fs/btrfs/accessors.h                  |  50 +++
 fs/btrfs/bio.c                        |  45 ++-
 fs/btrfs/bio.h                        |   6 +
 fs/btrfs/btrfs_inode.h                |   3 +-
 fs/btrfs/compression.c                |   6 +
 fs/btrfs/ctree.h                      |   4 +
 fs/btrfs/defrag.c                     |  10 +-
 fs/btrfs/delayed-inode.c              |  29 +-
 fs/btrfs/delayed-inode.h              |   6 +-
 fs/btrfs/dir-item.c                   | 108 +++++-
 fs/btrfs/dir-item.h                   |  11 +-
 fs/btrfs/extent_io.c                  |  81 ++++-
 fs/btrfs/extent_io.h                  |   3 +
 fs/btrfs/extent_map.c                 | 106 +++++-
 fs/btrfs/extent_map.h                 |  12 +
 fs/btrfs/file-item.c                  |  17 +-
 fs/btrfs/file-item.h                  |   7 +-
 fs/btrfs/file.c                       |  16 +-
 fs/btrfs/fs.h                         |   3 +-
 fs/btrfs/fscrypt.c                    | 326 ++++++++++++++++++
 fs/btrfs/fscrypt.h                    |  95 +++++
 fs/btrfs/inode.c                      | 476 ++++++++++++++++++++------
 fs/btrfs/ioctl.c                      |  41 ++-
 fs/btrfs/ordered-data.c               |  26 +-
 fs/btrfs/ordered-data.h               |  21 +-
 fs/btrfs/reflink.c                    |   8 +
 fs/btrfs/root-tree.c                  |   8 +-
 fs/btrfs/root-tree.h                  |   2 +-
 fs/btrfs/super.c                      |  17 +
 fs/btrfs/sysfs.c                      |   6 +
 fs/btrfs/tree-checker.c               |  66 +++-
 fs/btrfs/tree-log.c                   |  26 +-
 fs/btrfs/verity.c                     |   3 +
 fs/crypto/crypto.c                    |  23 +-
 fs/crypto/fname.c                     |  45 +--
 fs/crypto/fscrypt_private.h           |  87 ++++-
 fs/crypto/hooks.c                     |   2 +-
 fs/crypto/inline_crypt.c              | 100 +++++-
 fs/crypto/keyring.c                   |   4 +-
 fs/crypto/keysetup.c                  | 190 +++++++++-
 fs/crypto/keysetup_v1.c               |  14 +-
 fs/crypto/policy.c                    |  70 +++-
 include/linux/blk-crypto-profile.h    |   7 +
 include/linux/blk-crypto.h            |   9 +-
 include/linux/fs.h                    |   4 +-
 include/linux/fscrypt.h               | 123 ++++++-
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  35 +-
 53 files changed, 2144 insertions(+), 287 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.41.0

