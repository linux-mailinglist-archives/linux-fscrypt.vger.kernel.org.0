Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4023E74C78C
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjGISxw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjGISxw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:52 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACEC10C;
        Sun,  9 Jul 2023 11:53:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 416AA80AE0;
        Sun,  9 Jul 2023 14:53:50 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928830; bh=9KF/oLx8zE2P19tLCuolatDXOfUW2RY/yAr5KMS5Lfw=;
        h=From:To:Cc:Subject:Date:From;
        b=dROadWRv7shDDuieAT43cO+vbjA1Rl0nzTIl86m13umn8uwSNK4RDFPvUcX07yX/W
         ampQ7Q+FLoH7V46XLU9IbQVzokvn2xE4+v62mY04SdLP8vyfCkcuIqLt+fPk4hCrql
         6wuYD+KmTN549KUkQcdgPvIWSolpr08SAq1DWlIINmrE9M27SUhU0QZ8POVU5edhht
         jlp/lgnW7YcxfaMPB7t68cGA2DErjGrU6A4iyuyF4Kv7Y1u1lbF650pg9ybQ8c1YlI
         5eoxdN/W++flWFHQEuKQkwm/Uchr5P2JDGNEty4wHWGqpC1MMdpDQgXnf6hFAOdpg6
         rSrGtwSO63TRw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 00/14] fscrypt: add extent encryption
Date:   Sun,  9 Jul 2023 14:53:33 -0400
Message-Id: <cover.1688927487.git.sweettea-kernel@dorminy.me>
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
discussed previously. There are two questionable parts: the
forget_extent_info hook is not yet in use by btrfs, as I haven't yet
written a test exercising a race where it would be relevant; and saving
the session key credentials just to enable v1 session-based policies is
perhaps less good than 

This applies atop [3], which itself is based on kdave/misc-next. It
passes encryption fstests with suitable changes to btrfs-progs and tests.

[1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
[2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
[3]
https://lore.kernel.org/linux-fscrypt/cover.1688927423.git.sweettea-kernel@dorminy.me/

Changelog:
v2:
- Change to soft-delete keys in use by inodes using extent encryption at
  key removal time (new changes 9 and 10), as per feedback.
- Add a missing error check in fscrypt_mergeable_bio (change 3)
v1:
- https://lore.kernel.org/linux-fscrypt/248eac32-96cc-eb2e-85da-422a8d75a376@dorminy.me/T/#t

Sweet Tea Dorminy (14):
  fscrypt: factor helper for locking master key
  fscrypt: factor getting info for a specific block
  fscrypt: adjust effective lblks based on extents
  fscrypt: add a super_block pointer to fscrypt_info
  fscrypt: setup leaf inodes for extent encryption
  fscrypt: allow infos to be owned by extents
  fscrypt: notify per-extent infos if master key vanishes
  fscrypt: use an optional ino equivalent for per-extent infos
  fscrypt: move function call warning of busy inodes
  fscrypt: revamp key removal for extent encryption
  fscrypt: add creation/usage/freeing of per-extent infos
  fscrypt: allow load/save of extent contexts
  fscrypt: save session key credentials for extent infos
  fscrypt: update documentation for per-extent keys

 Documentation/filesystems/fscrypt.rst |  43 +++-
 fs/crypto/crypto.c                    |   6 +-
 fs/crypto/fscrypt_private.h           | 128 +++++++++++-
 fs/crypto/inline_crypt.c              |  28 ++-
 fs/crypto/keyring.c                   |  79 +++++---
 fs/crypto/keysetup.c                  | 274 ++++++++++++++++++++++----
 fs/crypto/keysetup_v1.c               |   7 +-
 fs/crypto/policy.c                    |  20 ++
 include/linux/fscrypt.h               |  65 ++++++
 9 files changed, 562 insertions(+), 88 deletions(-)


base-commit: e0144e6be2ec62c8d874076a6292a8d83b00ee32
prerequisite-patch-id: ab342a72cf967dadfb8bec1320c5906fd3c6800f
prerequisite-patch-id: ced2a9dab36539f55c14cd74a28950087c475ff2
prerequisite-patch-id: d4f1a64c994c2fa0d2d4cab83f9ddff52f0622e9
prerequisite-patch-id: 1af0fc98277159b31c26bc5751663efc0d322d75
prerequisite-patch-id: 3b21b62208587486cf9b31618f7c3bc875362f1a
prerequisite-patch-id: c43d693f5b7c498a876d9ffcfc49c11a8ca93d80
prerequisite-patch-id: f120bde1cf47fbef1d9f8fd09cdcccc1408c3ff4
prerequisite-patch-id: c6a1f087d4a67b928b9c6af04e00310bfa74ace1
-- 
2.40.1

