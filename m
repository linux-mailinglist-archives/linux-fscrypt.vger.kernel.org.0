Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D6339C20F
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 23:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhFDVMO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 17:12:14 -0400
Received: from mail-pj1-f73.google.com ([209.85.216.73]:64245 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbhFDVMM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 17:12:12 -0400
Received: by mail-pj1-f73.google.com with SMTP id h32-20020a17090a29a3b0290161dfc5d1bfso6611814pjd.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 04 Jun 2021 14:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FMbuMLj5Rm4HXgTCK4ErZpEUdwqkKvJbjVvRhJRuIoI=;
        b=NL+4ed93frwkVnpKca486IssjHFSLEESSoDOv8HStprQiy6/5mQU9IzMUY5l7uPNKO
         75naARNfSntgeJO6hteLH9GiTkBTeZAd4d/lU/3tdTLXVa2yVm/6xGwJWbNmUHzSJv81
         xazThDs8Lx0PEQVChSlLpe4kaCs0N/HvaEo6PXKTynQ5EboeyW62m9xpj0vGQE84WEZj
         GNv1DWVvrWUTGLz/rvk2HEKwQaSaniLj7tBgdb9DqWmNzMTbn1Ck1ZpqrU8YuXfvBIOy
         s6AYyUrjbVma7xp2AoVjEMbfwn9BndFbXjtgVJtCEO7Z9trhHlVr7oGjO4nELOIIoGtm
         L5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FMbuMLj5Rm4HXgTCK4ErZpEUdwqkKvJbjVvRhJRuIoI=;
        b=Jmuc4qtuRDgGZJb11g3nCyhG1EtMq8tYCy655pe5sWJFKRHWFNzZjcdRYdNZCEb8SN
         Pg5DkmyZuRSCV9Fv80EK81lK9l3iBO46CfIpMPY+4qR7uDXKfTHmy1v6mfeAN6nOb9ul
         0t16uKe+gyemKI/B5wR/l+nbeiiGg2t7ijH8FGjm1D7IZHIX+yArdPVsrUqbK34dORxg
         opfITt/D0qMB9lHSvvFyx4luA/kIwTssjVhFtACvXmKw2opfI4zeriCKqT2Hh8+9Y1pl
         VH6Wegw7N8SDqfsneX7B9LMxe2gcqHA2qO9Js72qm76LE8QfwBaxDnvKCsoL9hivBzHe
         tjgA==
X-Gm-Message-State: AOAM531jjvCULETMU2egPrVg5dChdRXdOUWNxLKqPVho1SGqQBoZf+C6
        lM7pZpcsJwq42b2lWantiI/5PehESyI=
X-Google-Smtp-Source: ABdhPJx3G3SE5JulN7r3qwiqrC8W7sc2+Kh8W2VogbHy+/du+MYm6tDJ+dB2nayc3YpfbzPSr8GamE6X94Y=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:90a:cb07:: with SMTP id
 z7mr1618508pjt.0.1622840950549; Fri, 04 Jun 2021 14:09:10 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:08:59 +0000
Message-Id: <20210604210908.2105870-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 0/9] add support for direct I/O with fscrypt using blk-crypto
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
blk-crypto. Note that this patch relies on another patchset
("ensure bios aren't split in middle of crypto data unit" found at
https://lore.kernel.org/linux-block/20210604195900.2096121-1-satyat@google.com/
)

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

Patches 4 and 6 modify direct-io and iomap respectively to set bio crypt
contexts on bios when appropriate by calling into fscrypt.

Patch 5 makes bio_iov_iter_get_pages() respect
bio_required_sector_alignment() which is now necessary since Patch 6 makes
it possible for iomap (which uses bio_iov_iter_get_pages()) construct bios
that have crypt contexts.

Patches 7 and 8 allow ext4 and f2fs direct I/O to support fscrypt without
falling back to buffered I/O.

Patch 9 updates the fscrypt documentation for direct I/O support.
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

Changes v8 => v9:
 - Introduce patch 5 to fix bug with iomap_dio_bio_actor() which
   constructed bios that had incomplete crypto data units (fixes xfstests
   generic/465 with ext4)

Changes v7 => v8:
 - Patch 1 from v7 (which ensured that bios aren't split in the middle of
   a data unit) has been sent out in a separate patch series, as it's
   required even without this patch series. That patch series can now
   be found at
   https://lore.kernel.org/linux-block/20210604195900.2096121-1-satyat@google.com/
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

Satya Tangirala (4):
  block: blk-crypto-fallback: handle data unit split across multiple
    bvecs
  block: blk-crypto: relax alignment requirements for bvecs in bios
  block: Make bio_iov_iter_get_pages() respect
    bio_required_sector_alignment()
  fscrypt: update documentation for direct I/O support

 Documentation/filesystems/fscrypt.rst |  21 ++-
 block/bio.c                           |  13 +-
 block/blk-crypto-fallback.c           | 203 ++++++++++++++++++++------
 block/blk-crypto.c                    |  19 +--
 fs/crypto/crypto.c                    |   8 +
 fs/crypto/inline_crypt.c              |  75 ++++++++++
 fs/direct-io.c                        |  15 +-
 fs/ext4/file.c                        |  10 +-
 fs/ext4/inode.c                       |   7 +
 fs/f2fs/f2fs.h                        |   6 +-
 fs/iomap/direct-io.c                  |   6 +
 include/linux/fscrypt.h               |  18 +++
 12 files changed, 328 insertions(+), 73 deletions(-)

-- 
2.32.0.rc1.229.g3e70b5a671-goog

