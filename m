Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08708790560
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Sep 2023 07:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351004AbjIBFzu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 2 Sep 2023 01:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbjIBFzu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 2 Sep 2023 01:55:50 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BF110F4;
        Fri,  1 Sep 2023 22:55:44 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7AE0C803B3;
        Sat,  2 Sep 2023 01:55:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1693634144; bh=jmk3hEB6MciszwJ2eSIqgFJ53fIIrcClxaz3AiLEGAg=;
        h=From:To:Cc:Subject:Date:From;
        b=oST7Z+KXRR43V9HV/CItyT+dNBdW16TBvu+Jty0kPEBwReKOpXLRbXm7jqt+Img7l
         Vs3wtr01cyx94Il6pMoNRCs/JmIMiIccTI7LsH1OOHqwdzZQI3BwNLFV/rmfEQmmM2
         Rjh68mPM4Obm591ELSxiTPps9XOGsVIy/K0k9oAtPOn4hBKM8SfGcrG/TT5SSlQDfK
         2nbzLMLivAko26JY0kKEznL15op4sU3Vyv0MSggcc6cRS1YYs679QeS/8NPi/XuqKd
         WGPomxNog6GnXL83u5i9Oz8+plJcI9mQh3nbegjeF3fkw+M1nqYTI9yQPX00YMynwZ
         6EPwRhyPz06IQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        ebiggers@kernel.org, ngompa13@gmail.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 00/13] fscrypt: add extent encryption
Date:   Sat,  2 Sep 2023 01:54:18 -0400
Message-ID: <cover.1693630890.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a replacement for the former changeset (previously v3). This
doesn't reflect all the smaller feedback on v3: it's an attempt to address
the major points of giving extents and inodes different objects, and to
clearly define lightweight and heavyweight extent contexts. Currently,
with minor changes to the btrfs patchset building on it, it passes
tests.

Hopefully I understood the proposed alternate design and this is indeed
more elegant, reviewable, and maintainable. 

This applies atop [3], which itself is based on kdave/misc-next.

Changelog:
RFC:
 - Split fscrypt_info into a general fscrypt_common_info, an
   inode-specific fscrypt_info, and an extent-specific
   fscrypt_extent_info. All external interfaces use either an inode or
   extent specific structure; most internal functions handle the common
   structure.
 - Tried to fix up more places to refer to infos instead of inodes and
   files.
 - Changed to use lightweight extent contexts containing just a nonce,
   and then a following change to do heavyweight extent contexts
   identical to inode contexts, so they're easily comparable.
 - Dropped factoring lock_master_key() and adding super block pointer to
   fscrypt_info changes, as they didn't seem necessary.
 - Temporarily dropped optimization where leaf inodes with extents don't
   have on-disk fscrypt_contexts. It's a convenient optimization and
   affects btrfs disk format, but it's not very big and not strictly
   needed to check whether the new structural arrangement is better.

v3:
 - Added four additional changes:
   - soft-deleting keys that extent infos might later need to use, so
     the behavior of an open file after key removal matches inode-based
     fscrypt.
   - a set of changes to allow asynchronous info freeing for extents,
     necessary due to locking constraints in btrfs.
 - https://lore.kernel.org/linux-fscrypt/cover.1691505882.git.sweettea-kernel@dorminy.me/

v2: 
 - https://lore.kernel.org/linux-fscrypt/cover.1688927487.git.sweettea-kernel@dorminy.me/T/#t


[3] https://lore.kernel.org/linux-fscrypt/cover.1691505830.git.sweettea-kernel@dorminy.me/

Sweet Tea Dorminy (13):
  fscrypt: factor getting info for a specific block
  fscrypt: adjust effective lblks based on extents
  fscrypt: move function call warning of busy inodes
  fscrypt: split fscrypt_info into general and inode specific parts
  fscrypt: add creation/usage/freeing of per-extent infos
  fscrypt: allow load/save of extent contexts
  fscrypt: store full fscrypt_contexts for each extent
  fscrypt: save session key credentials for extent infos
  fscrypt: revamp key removal for extent encryption
  fscrypt: allow multiple extents to reference one info
  fscrypt: cache list of inlinecrypt devices
  fscrypt: allow asynchronous info freeing
  fscrypt: update documentation for per-extent keys

 Documentation/filesystems/fscrypt.rst |  43 ++-
 fs/crypto/crypto.c                    |  48 ++-
 fs/crypto/fname.c                     |  13 +-
 fs/crypto/fscrypt_private.h           | 245 +++++++++---
 fs/crypto/hooks.c                     |   6 +-
 fs/crypto/inline_crypt.c              |  93 +++--
 fs/crypto/keyring.c                   | 110 +++---
 fs/crypto/keysetup.c                  | 530 ++++++++++++++++++++------
 fs/crypto/keysetup_v1.c               |  77 ++--
 fs/crypto/policy.c                    |  34 +-
 include/linux/fscrypt.h               |  60 +++
 11 files changed, 919 insertions(+), 340 deletions(-)


base-commit: 764e1420e0806a3536b53b4c52c1b08ae8425f7e
-- 
2.41.0

