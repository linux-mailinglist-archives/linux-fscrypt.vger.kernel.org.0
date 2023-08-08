Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD06577439A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbjHHSIH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235139AbjHHSH3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:29 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF509634BF;
        Tue,  8 Aug 2023 10:08:41 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 4B3DE83541;
        Tue,  8 Aug 2023 13:08:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514521; bh=g0eXmZcoXvxtrVNAt/UKWZ1mLGPNmRYMaDnrl33ag0o=;
        h=From:To:Cc:Subject:Date:From;
        b=RxoklI+gUJ9F0/XMjT53dwRnaIVPriV+naexFdDujX7kZwhnCofZJYtEw2M7jrd7d
         kshvhJYUgO7ucWmRXfCW/qFOYL0jzumsVLyZyCfy2awOmalhfWe1Y4r8e9hYKAK3RQ
         qipRnhdQG4MzMohKWXl/Rl3UspJT89omJtCyVcFjuOhT7F5tJIAThZCsiTKNMTbCey
         4bOMRsVkbIthcjuey5yeV0Xu7HQzmgJIa4YXA2RjYYhhaRpOJZsLJJSG67IwrPu8Hv
         PMBxhdlwWVYzPcarIQ8/Yes/u4F+AkyYQG9s9rZTe6Vq0u/ZT/jJ9ttqZB3KLx6hzf
         rPdFY0ra5aXNw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 00/16] fscrypt: add extent encryption
Date:   Tue,  8 Aug 2023 13:08:17 -0400
Message-ID: <cover.1691505882.git.sweettea-kernel@dorminy.me>
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

This changeset adds extent-based data encryption to fscrypt.
Some filesystems need to encrypt data based on extents, rather than on
inodes, due to features incompatible with inode-based encryption. For
instance, btrfs can have multiple inodes referencing a single block of
data, and moves logical data blocks to different physical locations on
disk in the background. 

As per discussion last year in [1] and later in [2], we would like to
allow the use of fscrypt with btrfs, with authenticated encryption. This
is the first step of that work, adding extent-based encryption to
fscrypt; authenticated encryption is the next step. Extent-based
encryption should be usable by other filesystems which wish to support
snapshotting or background data rearrangement also, but btrfs is the
first user. 

This changeset requires extent encryption to use inlinecrypt, as
discussed previously. 

This applies atop [3], which itself is based on kdave/misc-next. It
passes encryption fstests with suitable changes to btrfs-progs.

Changelog:
v3:
 - Added four additional changes:
   - soft-deleting keys that extent infos might later need to use, so
     the behavior of an open file after key removal matches inode-based
     fscrypt.
   - a set of changes to allow asynchronous info freeing for extents,
     necessary due to locking constraints in btrfs.

v2: 
 - https://lore.kernel.org/linux-fscrypt/cover.1688927487.git.sweettea-kernel@dorminy.me/T/#t


[1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
[2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
[3] https://lore.kernel.org/linux-fscrypt/cover.1691505830.git.sweettea-kernel@dorminy.me/

Sweet Tea Dorminy (16):
  fscrypt: factor helper for locking master key
  fscrypt: factor getting info for a specific block
  fscrypt: adjust effective lblks based on extents
  fscrypt: add a super_block pointer to fscrypt_info
  fscrypt: setup leaf inodes for extent encryption
  fscrypt: allow infos to be owned by extents
  fscrypt: use an optional ino equivalent for per-extent infos
  fscrypt: move function call warning of busy inodes
  fscrypt: revamp key removal for extent encryption
  fscrypt: add creation/usage/freeing of per-extent infos
  fscrypt: allow load/save of extent contexts
  fscrypt: save session key credentials for extent infos
  fscrypt: allow multiple extents to reference one info
  fscrypt: cache list of inlinecrypt devices
  fscrypt: allow asynchronous info freeing
  fscrypt: update documentation for per-extent keys

 Documentation/filesystems/fscrypt.rst |  43 +++-
 fs/crypto/crypto.c                    |   6 +-
 fs/crypto/fscrypt_private.h           | 158 +++++++++++-
 fs/crypto/inline_crypt.c              |  49 ++--
 fs/crypto/keyring.c                   |  78 +++---
 fs/crypto/keysetup.c                  | 336 ++++++++++++++++++++++----
 fs/crypto/keysetup_v1.c               |  10 +-
 fs/crypto/policy.c                    |  20 ++
 include/linux/fscrypt.h               |  67 +++++
 9 files changed, 654 insertions(+), 113 deletions(-)


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
-- 
2.41.0

