Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE47C4169
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbjJJUlH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjJJUlG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:06 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BF3A4
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:04 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5a7be88e9ccso14560317b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970464; x=1697575264; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=aSLAHv4ovY92dSVytiyYNj1arXZjJNGuUbk0RVfgU/Q=;
        b=v//mmXOU/e3JAkIvtAOtW02PMu6D985voR7Ofdh2kdo1Q/8pSn9wPmZ7WGiYW+wUng
         koWeoKQu34Pr5q0qDPN5R8EZ+UaG+3dIO0l4IVLwhi/G4hmhUhmchWRyvY7JcjiDFJnL
         ywukN05AojwxW2u6TKduWvVFtEgOPNLCcvsNe0t3rpBiZXntyxBmmTzfZr1IWEGXBLp+
         P5GLASqXfGeXS2pFqefYPey4P1Ha095Ooft7qBDZUFys+3UeJNC2/qQch9rtqEZ7NJAD
         b2oClOrjkXnncSrO4NYiGuHlLoaNG+LYKZkjp3VIw4KkQiUWKpsEJJ3u+ap2db+n31wj
         ycrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970464; x=1697575264;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSLAHv4ovY92dSVytiyYNj1arXZjJNGuUbk0RVfgU/Q=;
        b=QRSAyMhwhb+RQZtv8+rX4dLyHI9h4dPv3UtT7VwqpQdGkGZHvaPqIBPQhzLrUTVfrw
         IQWX1vzq66cm0cmY76tcG24sGyTsrXyLPjJQIlV4d99iFR5sgNL1uSf+z0u2jNYBo2ps
         fta1gWALF0D2Pi/po049SyZgaKvOok3+YLCSoQRmgOrSsDQ+4W79lpWdka3PCRxkTYMc
         vkE77Nop9EkIKBV5Y5xyzPpyghI+DIWGTu0FWNuhx8tpDtFpNuxpxid9/tMdYsRqZe0N
         3SJff6b6r+Dg0944egWgfGXQMlCMIdeh8w8l9ui2HRj8Pb3NI91IaOthodQtTtWEA9oM
         SJdg==
X-Gm-Message-State: AOJu0YwNlwDOvjaiGHXaaG0lidXtJre+5bAlRDG5PTRKgdAA27cERQth
        6x4AWbXXO3PNh5bImMFOCReIVryYwjuHsbV+5pn/hw==
X-Google-Smtp-Source: AGHT+IHIW8d1IdN87vrDs5Le/UR/xYniotTN/kKZjEgqzFr1DTyHEyekL4hyeaU39/91tAHyBJZoZA==
X-Received: by 2002:a0d:fdc7:0:b0:58e:a9d3:bf98 with SMTP id n190-20020a0dfdc7000000b0058ea9d3bf98mr19144616ywf.27.1696970463882;
        Tue, 10 Oct 2023 13:41:03 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d139-20020a0ddb91000000b005a2202905casm4675182ywe.43.2023.10.10.13.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:03 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 00/36] btrfs: add fscrypt support
Date:   Tue, 10 Oct 2023 16:40:15 -0400
Message-ID: <cover.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This is the next version of the fscrypt support.  It is based on a combination
of Sterba's for-next branch and the fscrypt for-next branch.  The fscrypt stuff
should apply cleanly to the fscrypt for-next, but it won't apply cleanly to our
btrfs for-next branch.  I did this in case Eric wants to go ahead and merge the
fscrypt side, then we can figure out what to do on the btrfs side.

v1 was posted here

https://lore.kernel.org/linux-btrfs/cover.1695750478.git.josef@toxicpanda.com/

v1->v2:
- Dropped the rename patch as it's in the fscrypt tree.
- Implemented the soft delete master key idea in a different way that's
  hopefully more straightforward and easier to understand.
- A small fixup related to master keys being removed.

This has been tested with the updated fstests, everything appears to be working
well.  Thanks,

Josef

Josef Bacik (21):
  fscrypt: use a flag to indicate that the master key is being evicted
  fscrypt: don't wipe mk secret until the last active user is gone
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
 fs/crypto/crypto.c                    |  10 +-
 fs/crypto/fname.c                     |  39 +--
 fs/crypto/fscrypt_private.h           |  61 +++-
 fs/crypto/hooks.c                     |   2 +-
 fs/crypto/inline_crypt.c              |  87 ++++-
 fs/crypto/keyring.c                   |  23 +-
 fs/crypto/keysetup.c                  | 159 ++++++++-
 fs/crypto/policy.c                    |  59 ++++
 include/linux/blk-crypto-profile.h    |   7 +
 include/linux/blk-crypto.h            |   9 +-
 include/linux/fscrypt.h               | 122 +++++++
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  35 +-
 51 files changed, 2095 insertions(+), 236 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.41.0

