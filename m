Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940512FF86C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Jan 2021 00:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbhAUXE7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jan 2021 18:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAUXE1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jan 2021 18:04:27 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AA2C0613ED
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 15:03:40 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id m21so2479116qtp.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 Jan 2021 15:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=a86C6J2KAGK7N8gUuXwqncIpGvzm+wukETDy7ToYVa4=;
        b=KEMt5GTLgB0F309NJ/ui9d0wbtXY4Ffss7tcitx4GSvL1eI92Um9URMa1KANG05fa0
         dGOGUizaeQuZP45yQNN1mwXHpoQ2ga4p6mQ2OSu+G6FP10NkEVjxX0v3pkY07cEpYbo1
         1jS28VTJSRoOgzn9XCUORVbCqccHajlNmMdwm3zIloJEx8q03KemuwG+iQvN17z1ciag
         2TsJ6dVRI3QxFldm74zyost/zy86a8f84h+wVu0DKP8jeu9CbX0JZDhktdWNYxxOrsLE
         IL0hye+W51IPiYxGrtf4yrCRqjq03ACkItiXwBfTiVrVb7XRmsDRhYYLvQ/Pq4WHXolm
         K/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=a86C6J2KAGK7N8gUuXwqncIpGvzm+wukETDy7ToYVa4=;
        b=fk147ki2OB/fSRjzYAAYKouAmrMbBZjU/TYa/oGmIxMENt3fUnyncdMsN6LK+SjPBa
         Q55mqPhVVrdRfW6RWV1f/iVjY947VtLyBDbmbFnaeuKxEEq9YIGEC1s0Dl5UUKsC7peK
         WXXk1VF9vBE8McOWRLWKwIuuI2T1JVDRX1Ousjp2OETpa7l7qH8XA1wWeQPYLTigZg50
         DjMdhEqJlh9xl8dZMAl249S9KuB80cm7w7BB8lQ0psBJVs3e6ZsN0dLSH1bzFzk+J/dy
         zN4bszu9uNxYV5taz6eXxP7idRzikw+s+T+ksaSFRMZ8YXsMiH3bU0NgDxwmDLEni8y8
         Vf7A==
X-Gm-Message-State: AOAM531ZJFdhqnDZ0UpGUb8AtKpdDEG248hcffGn8diEwMkFLRDDhqeM
        enJg2kUihSXJVecWzYSwOqApe0abt4M=
X-Google-Smtp-Source: ABdhPJxWxaz7w6s2m6FBn5/tpe7d7n0Ntq7IDWS5vtwLqnUB2fZpoE5VgKC3P+2iYBpAUdhnybwb2HfbgUE=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a05:6214:4e2:: with SMTP id
 cl2mr1744643qvb.27.1611270219738; Thu, 21 Jan 2021 15:03:39 -0800 (PST)
Date:   Thu, 21 Jan 2021 23:03:28 +0000
Message-Id: <20210121230336.1373726-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH v8 0/8] add support for direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch series adds support for direct I/O with fscrypt using
blk-crypto.

Till now, the blk-crypto-fallback expected the offset and length of each
bvec in a bio to be aligned to the crypto data unit size. This in turn
would mean that any user buffer used to read/write encrypted data using the
blk-crypto framework would need to be aligned to the crypto data unit size.
Patch 1 enables blk-crypto-fallback to work without this requirement. It
also relaxes the alignment requirement that blk-crypto checks for - now,
blk-crypto only requires that the length of the I/O is aligned to the
crypto data unit size. This allows direct I/O support introduced in the
later patches in this series to require extra alignment restrictions on
user buffers.

Patch 2 relaxes the alignment check that blk-crypto performs on bios.
blk-crypto would check that the offset and length of each bvec in a bio is
aligned to the data unit size, since the blk-crypto-fallback required it.
As this is no longer the case, blk-crypto now only checks that the total
length of the bio is data unit size aligned.

Patch 3 adds two functions to fscrypt that need to be called to determine
if direct I/O is supported for a request.

Patches 4 and 5 modify direct-io and iomap respectively to set bio crypt
contexts on bios when appropriate by calling into fscrypt.

Patches 6 and 7 allow ext4 and f2fs direct I/O to support fscrypt without
falling back to buffered I/O.

Patch 8 updates the fscrypt documentation for direct I/O support.
The documentation now notes the required conditions for inline encryption
and direct I/O on encrypted files.

This patch series was tested by running xfstests with test_dummy_encryption
with and without the 'inlinecrypt' mount option, and there were no
meaningful regressions. Without any modification, xfstests skip any
direct I/O test when using ext4/encrypt and f2fs/encrypt, so I modified
xfstests not to skip those tests.

Among those tests, generic/465 fails with ext4/encrypt because a bio ends
up being split in the middle of a crypto data unit.  Patch 1 from v7 (which
has been sent out as a separate patch series) fixes this.

Note that the blk-crypto-fallback changes (Patch 1 in v8 in this series)
were also tested through xfstests by using this series along with the patch
series that ensures bios aren't split in the middle of a data unit (Patch 1
from v7) - Some tests (such as generic/465 again) result in bvecs that
don't contain a complete data unit (so a data unit is split across multiple
bvecs), and only pass with this patch.

Changes v7 => v8:
 - Patch 1 from v7 (which ensured that bios aren't split in the middle of
   a data unit) has been sent out in a separate patch series, as it's
   required even without this patch series. That patch series can now
   be found at
   https://lore.kernel.org/linux-block/20210114154723.2495814-1-satyat@google.com/
 - Patch 2 from v7 has been split into 2 patches (Patch 1 and 2 in v8).
 - Update docs

Changes v6 => v7:
 - add patches 1 and 2 to allow blk-crypto to work with user buffers not
   aligned to crypto data unit size, so that direct I/O doesn't require
   that alignment either.
 - some cleanups

Changes v5 => v6:
 - fix bug with fscrypt_limit_io_blocks() and make it ready for 64 bit
   block numbers.
 - remove Reviewed-by for Patch 1 due to significant changes from when
   the Reviewed-by was given.

Changes v4 => v5:
 - replace fscrypt_limit_io_pages() with fscrypt_limit_io_block(), which
   is now called by individual filesystems (currently only ext4) instead
   of the iomap code. This new function serves the same end purpose as
   the one it replaces (ensuring that DUNs within a bio are contiguous)
   but operates purely with blocks instead of with pages.
 - make iomap_dio_zero() set bio_crypt_ctx's again, instead of just a
   WARN_ON() since some folks prefer that instead.
 - add Reviewed-by's

Changes v3 => v4:
 - Fix bug in iomap_dio_bio_actor() where fscrypt_limit_io_pages() was
   being called too early (thanks Eric!)
 - Improve comments and fix formatting in documentation
 - iomap_dio_zero() is only called to zero out partial blocks, but
   direct I/O is only supported on encrypted files when I/O is
   blocksize aligned, so it doesn't need to set encryption contexts on
   bios. Replace setting the encryption context with a WARN_ON(). (Eric)

Changes v2 => v3:
 - add changelog to coverletter

Changes v1 => v2:
 - Fix bug in f2fs caused by replacing f2fs_post_read_required() with
   !fscrypt_dio_supported() since the latter doesn't check for
   compressed inodes unlike the former.
 - Add patches 6 and 7 for fscrypt documentation
 - cleanups and comments

Eric Biggers (5):
  fscrypt: add functions for direct I/O support
  direct-io: add support for fscrypt using blk-crypto
  iomap: support direct I/O with fscrypt using blk-crypto
  ext4: support direct I/O with fscrypt using blk-crypto
  f2fs: support direct I/O with fscrypt using blk-crypto

Satya Tangirala (3):
  block: blk-crypto-fallback: handle data unit split across multiple
    bvecs
  block: blk-crypto: relax alignment requirements for bvecs in bios
  fscrypt: update documentation for direct I/O support

 Documentation/filesystems/fscrypt.rst |  21 ++-
 block/blk-crypto-fallback.c           | 203 ++++++++++++++++++++------
 block/blk-crypto.c                    |  19 +--
 fs/crypto/crypto.c                    |   8 +
 fs/crypto/inline_crypt.c              |  74 ++++++++++
 fs/direct-io.c                        |  15 +-
 fs/ext4/file.c                        |  10 +-
 fs/ext4/inode.c                       |   7 +
 fs/f2fs/f2fs.h                        |   6 +-
 fs/iomap/direct-io.c                  |   6 +
 include/linux/fscrypt.h               |  18 +++
 11 files changed, 315 insertions(+), 72 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

