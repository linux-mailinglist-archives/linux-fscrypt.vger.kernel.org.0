Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5708414C35C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 Jan 2020 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgA1XE4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 28 Jan 2020 18:04:56 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:40271 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgA1XEX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 28 Jan 2020 18:04:23 -0500
Received: by mail-pj1-f74.google.com with SMTP id ev1so2511260pjb.5
        for <linux-fscrypt@vger.kernel.org>; Tue, 28 Jan 2020 15:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=4wthl79HWP0T/o9zvBpWHIzpNLIBPxOPJx5PymHVG6Q=;
        b=GDX/C/OSuHuMeBJ1ahgPZL1VVGEdTJy/yP3LL9+inyqMwkRHK7dFp/+xG9iD5I3Wye
         R8FtJLFJ0eV70EjeSjg0U5qKk8bSzCa1QbG+lL0sub2v+jXGlXmnUJiDQTieWdmoJRZV
         aEnhZYhnDWVpjcVBM8BKswB2TVHRR/Zw2QhMO3zPPcBHrLgbdTdvsKjAa5dI1XUBjCHL
         spmbAHxV0hBMSAK/CaKKdUNumnezHwIPqNO1a9JQZ9rUo5YhVBh1WYO9WyquZ7bULg08
         P/qSWjuqXIzcKanpjDIRuMerEfswNe+d9wkqs/hJKIaTCfLoyJCRVC1TZ7x8bQnI9TV9
         rJQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=4wthl79HWP0T/o9zvBpWHIzpNLIBPxOPJx5PymHVG6Q=;
        b=EdBpNWh8VycJBPRr3bsax14RRJGLBKw4u4CB1zVgbtOSZwyjIY35/PS6gQcJ6wln/x
         PZGrcSs0ckjtFi+WtUd5fz8raouKpZdK+QJRdNb226Es5b3HakZkjdfKlNxMjOreVQiG
         JGIoxOP3n6OQdZFTCaW4jov9HjFwJmLqT7BoXh0jQynQsTvepi4OWOHkilvNagN0IDjq
         rm1NWuemu+cdYrFulO5iPeL/bE4QNg+IEHMnaNmweGueFlo/rAS4EpjI+fR5+Ln8n5My
         V1k0cernMa0WNETb9ReGjsa2Iy+jOUfa/f0dBxg0y0p5z1VwLaKSB8w6XdMsCqPpqzNR
         cOsg==
X-Gm-Message-State: APjAAAXstI2ydTbZ9Di4QOjlkdSGxwa2CIJgNqspMdrCJe3PuJ37PIzN
        8HBRfJ1Z5j+5KvjpGLQuh1mNgRbI44U=
X-Google-Smtp-Source: APXvYqw5NZo8NAG4OMkcKqlZwD1DRl7BGD/ZEL4QespRsfp8h2gjJpR5FGRTvo86dDcfrVlQ5mEeoeJD/MY=
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr27636876pgc.14.1580252662083;
 Tue, 28 Jan 2020 15:04:22 -0800 (PST)
Date:   Tue, 28 Jan 2020 15:03:23 -0800
Message-Id: <20200128230328.183524-1-drosen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v6 0/5] Support fof Casefolding and Encryption
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

These patches are all on top of fscrypt's development branch

Ext4 and F2FS currently both support casefolding and encryption, but not at
the same time. These patches aim to rectify that.

I moved the identical casefolding dcache operations for ext4 and f2fs into
fs/unicode, as all filesystems using casefolded names will want them.

I've also adjust fscrypt to not set it's d_revalidate operation during it's
prepare lookup, instead having the calling filesystem set it up. This is
done to that the filesystem may have it's own dentry_operations.

For Ext4, since the hash for encrypted casefolded directory names cannot be
computed without the key, we need to store the hash on disk. We only do so
for encrypted and casefolded directories to avoid on disk format changes.
Previously encryption and casefolding could not be on the same filesystem,
and we're relaxing that requirement. F2fs is a bit more straightforward
since it already stores hashes on disk.

I've updated the related tools with just enough to enable the feature. I
still need to adjust ext4's fsck's, although without access to the keys,
neither fsck will be able to verify the hashes of casefolded and encrypted
names.

v6 changes:
Went back to using dentry_operations for casefolding. Provided standard
implementations in fs/unicode, avoiding extra allocation in d_hash op.
Moved fscrypt d_ops setting to be filesystem's responsibility to maintain
compatibility with casefolding and overlayfs if casefolding is not used
fixes some f2fs error handling

v4-5: patches submitted on fscrypt

v3 changes:
fscrypt patch only creates hash key if it will be needed.
Rebased on top of fscrypt branch, reconstified match functions in ext4/f2fs

v2 changes:
fscrypt moved to separate thread to rebase on fscrypt dev branch
addressed feedback, plus some minor fixes


Daniel Rosenberg (5):
  unicode: Add standard casefolded d_ops
  fscrypt: Have filesystems handle their d_ops
  f2fs: Handle casefolding with Encryption
  ext4: Hande casefolding with encryption
  ext4: Optimize match for casefolded encrypted dirs

 Documentation/filesystems/ext4/directory.rst |  27 ++
 fs/crypto/fname.c                            |   7 +-
 fs/crypto/fscrypt_private.h                  |   1 -
 fs/crypto/hooks.c                            |   1 -
 fs/ext4/dir.c                                | 102 +++---
 fs/ext4/ext4.h                               |  86 +++--
 fs/ext4/hash.c                               |  26 +-
 fs/ext4/ialloc.c                             |   5 +-
 fs/ext4/inline.c                             |  41 ++-
 fs/ext4/namei.c                              | 325 ++++++++++++-------
 fs/ext4/super.c                              |  21 +-
 fs/f2fs/dir.c                                | 151 +++++----
 fs/f2fs/f2fs.h                               |  16 +-
 fs/f2fs/hash.c                               |  25 +-
 fs/f2fs/inline.c                             |   9 +-
 fs/f2fs/namei.c                              |   1 +
 fs/f2fs/super.c                              |  17 +-
 fs/f2fs/sysfs.c                              |   8 +-
 fs/ubifs/dir.c                               |  18 +
 fs/unicode/utf8-core.c                       |  61 ++++
 include/linux/fs.h                           |  10 +
 include/linux/fscrypt.h                      |   6 +-
 include/linux/unicode.h                      |  17 +
 23 files changed, 644 insertions(+), 337 deletions(-)

-- 
2.25.0.341.g760bfbb309-goog

