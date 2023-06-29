Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715D3741CF0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjF2Ae3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjF2Ae2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:34:28 -0400
X-Greylist: delayed 319 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Jun 2023 17:34:26 PDT
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4040D1FC2;
        Wed, 28 Jun 2023 17:34:26 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 09BAA80727;
        Wed, 28 Jun 2023 20:34:24 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998865; bh=YmTVWm+8w1XiK3osBNaPOn2YB+oMMXLIWj3hs2xcluA=;
        h=From:To:Cc:Subject:Date:From;
        b=LD6JDaIInhgJLRYBs4d+OA+f0La3cqoc7Jx4WOXUiIW/7+lAB2yfaYF17T4UEXUXp
         QuFUx/UFxURjFx2wnDOqqW/lIlXo3QTqKXo+p6CGySMo1vmFlqfJy2dvhvG9DmiWCC
         IExUQ75n+EuDPgIm2oGjeSb/Jb8ULkt/JePWIiVViCq2q60wIHDZhhwSMknzGU/iy4
         O9BdUXndSPydOmCo07Jked/nEtVTJH3TjiyUMkRznyU6AyiEq0nn1zIyVf25sFlGhU
         rTBoYoYbgNNYDLQ82hUIN+gQuvIllUpJCUVnjNbVbjUefwh2cMI34TOFJ/sSZM0hc8
         4OMG8hnHUyleQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 00/12] fscrypt: add extent encryption
Date:   Wed, 28 Jun 2023 20:29:30 -0400
Message-Id: <cover.1687988246.git.sweettea-kernel@dorminy.me>
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
passes most encryption fstests with suitable changes to btrfs-progs, but
not generic/580 or generic/595 due to different timing involved in
extent encryption. Tests and btrfs progs updates to follow.


[1] https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
[2] https://lore.kernel.org/linux-fscrypt/80496cfe-161d-fb0d-8230-93818b966b1b@dorminy.me/T/#t
[3]
https://lore.kernel.org/linux-fscrypt/cover.1687988119.git.sweettea-kernel@dorminy.me/

Sweet Tea Dorminy (12):
  fscrypt: factor helper for locking master key
  fscrypt: factor getting info for a specific block
  fscrypt: adjust effective lblks based on extents
  fscrypt: add a super_block pointer to fscrypt_info
  fscrypt: setup leaf inodes for extent encryption
  fscrypt: allow infos to be owned by extents
  fscrypt: notify per-extent infos if master key vanishes
  fscrypt: use an optional ino equivalent for per-extent infos
  fscrypt: add creation/usage/freeing of per-extent infos
  fscrypt: allow load/save of extent contexts
  fscrypt: save session key credentials for extent infos
  fscrypt: update documentation for per-extent keys

 Documentation/filesystems/fscrypt.rst |  38 +++-
 fs/crypto/crypto.c                    |   6 +-
 fs/crypto/fscrypt_private.h           |  91 ++++++++++
 fs/crypto/inline_crypt.c              |  28 ++-
 fs/crypto/keyring.c                   |  32 +++-
 fs/crypto/keysetup.c                  | 244 ++++++++++++++++++++++----
 fs/crypto/keysetup_v1.c               |   7 +-
 fs/crypto/policy.c                    |  20 +++
 include/linux/fscrypt.h               |  74 ++++++++
 9 files changed, 480 insertions(+), 60 deletions(-)


base-commit: accadeb67609a5a5d088ebde8409c3f6db0b84b4
-- 
2.40.1

