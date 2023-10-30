Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC727DB264
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Oct 2023 05:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjJ3EE0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Oct 2023 00:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjJ3EEY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Oct 2023 00:04:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9EDAB;
        Sun, 29 Oct 2023 21:04:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4AAC433C8;
        Mon, 30 Oct 2023 04:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698638661;
        bh=UkCm3OTWARRE3MTGj4hMs3g9sGwjnFjvdJrOft2PCWM=;
        h=Date:From:To:Cc:Subject:From;
        b=RtH8udXQmHNy7sD8UiM8laIiFptr75k6TMDW5G9xwNZO/XRRhqsNvv29IlUG12jJ7
         FWDTxb/On3c0tvaBgpRQUqbSlrbpIRsOO06xVIbl7m0VWoUAs3QUp3kKDQp3rzEpuI
         a3DCf/YWO6mh+iSMitfF8NrvLF+49M6X8ytT7Socn2iewAC6lGOKoT1QZOOqgEsnl6
         TUzvzXejaKIN7/j0DOQ0lmZNJvxJrDTs1E0BWzC3iY4Gu8YOrhiHcasSDoDZN5CKAh
         IQdbK+cLayLqnQDGxYZgFAl9HboHL5tWPC1agPrMnBrG2AIRZA5UQNniYmLR7nvAAv
         rELkLw3Fzf4Sg==
Date:   Sun, 29 Oct 2023 21:04:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [GIT PULL] fscrypt updates for 6.7
Message-ID: <20231030040419.GA43439@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The following changes since commit 6465e260f48790807eef06b583b38ca9789b6072:

  Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

for you to fetch changes up to 15baf55481de700f8c4494cddb80ec4f4575548b:

  fscrypt: track master key presence separately from secret (2023-10-16 21:23:45 -0700)

----------------------------------------------------------------

This update adds support for configuring the crypto data unit size (i.e.
the granularity of file contents encryption) to be less than the
filesystem block size. This can allow users to use inline encryption
hardware in some cases when it wouldn't otherwise be possible.

In addition, there are two commits that are prerequisites for the
extent-based encryption support that the btrfs folks are working on.

----------------------------------------------------------------
Eric Biggers (6):
      fscrypt: make it clearer that key_prefix is deprecated
      fscrypt: make the bounce page pool opt-in instead of opt-out
      fscrypt: compute max_lblk_bits from s_maxbytes and block size
      fscrypt: replace get_ino_and_lblk_bits with just has_32bit_inodes
      fscrypt: support crypto data unit size less than filesystem block size
      fscrypt: track master key presence separately from secret

Josef Bacik (1):
      fscrypt: rename fscrypt_info => fscrypt_inode_info

 Documentation/filesystems/fscrypt.rst | 121 ++++++++++++++++++-------
 fs/ceph/crypto.c                      |   1 +
 fs/crypto/bio.c                       |  39 ++++----
 fs/crypto/crypto.c                    | 163 ++++++++++++++++++---------------
 fs/crypto/fname.c                     |   6 +-
 fs/crypto/fscrypt_private.h           | 164 ++++++++++++++++++++++------------
 fs/crypto/hooks.c                     |   4 +-
 fs/crypto/inline_crypt.c              |  32 +++----
 fs/crypto/keyring.c                   |  82 ++++++++++-------
 fs/crypto/keysetup.c                  |  62 +++++++------
 fs/crypto/keysetup_v1.c               |  20 +++--
 fs/crypto/policy.c                    |  83 +++++++++++------
 fs/ext4/crypto.c                      |  13 +--
 fs/f2fs/super.c                       |  13 +--
 fs/ubifs/crypto.c                     |   3 +-
 include/linux/fs.h                    |   4 +-
 include/linux/fscrypt.h               |  82 ++++++++++-------
 include/uapi/linux/fscrypt.h          |   3 +-
 18 files changed, 546 insertions(+), 349 deletions(-)
