Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B5E1E155E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 May 2020 22:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390791AbgEYUzP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 May 2020 16:55:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388714AbgEYUzP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 May 2020 16:55:15 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 538302065F;
        Mon, 25 May 2020 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440114;
        bh=7k9fwFL0w8qELktX/YxNqwSv16KvnXoJQ6ec8cUhR9w=;
        h=From:To:Cc:Subject:Date:From;
        b=T3uVWXPKMy96+eSvsRUtcKjf7B5icn1LydsE2gNE7Sy56PFJSDkiLhED9y+qlynWd
         zhI1BmLEOS55bydYfM6DQGvnQlrklnFWlZVPXDQ3u/CHPFjiZ/zB111HVnEUTsaB7I
         2jENolMngQN5Php+5qBVUavYFdVgZLkQVXc8Ncsc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
Date:   Mon, 25 May 2020 13:54:29 -0700
Message-Id: <20200525205432.310304-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From the 'fsverity' program, split out a library 'libfsverity'.
Currently it supports computing file measurements ("digests"), and
signing those file measurements for use with the fs-verity builtin
signature verification feature.

Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
I made a lot of improvements; see patch 2 for details.

This patchset can also be found at branch "libfsverity" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/

Changes v1 => v2:
  - Fold in the Makefile fixes from Jes
  - Rename libfsverity_digest_size() and libfsverity_hash_name()
  - Improve the documentation slightly
  - If a memory allocation fails, print the allocation size
  - Use EBADMSG for invalid cert or keyfile, not EINVAL
  - Make libfsverity_find_hash_alg_by_name() handle NULL
  - Avoid introducing compiler warnings with AOSP's default cflags
  - Don't assume that BIO_new_file() sets errno
  - Other small cleanups

Eric Biggers (3):
  Split up cmd_sign.c
  Introduce libfsverity
  Add some basic test programs for libfsverity

 .gitignore                                |  10 +-
 Makefile                                  | 191 ++++++-
 cmd_sign.c                                | 633 ----------------------
 commands.h                                |  24 -
 util.h => common/common_defs.h            |  47 +-
 fsverity_uapi.h => common/fsverity_uapi.h |   0
 common/libfsverity.h                      | 132 +++++
 hash_algs.h                               |  68 ---
 lib/compute_digest.c                      | 240 ++++++++
 hash_algs.c => lib/hash_algs.c            | 129 +++--
 lib/lib_private.h                         |  83 +++
 lib/sign_digest.c                         | 399 ++++++++++++++
 lib/utils.c                               | 109 ++++
 cmd_enable.c => programs/cmd_enable.c     |  32 +-
 cmd_measure.c => programs/cmd_measure.c   |  12 +-
 programs/cmd_sign.c                       | 163 ++++++
 fsverity.c => programs/fsverity.c         |  52 +-
 programs/fsverity.h                       |  43 ++
 programs/test_compute_digest.c            |  61 +++
 programs/test_hash_algs.c                 |  38 ++
 programs/test_sign_digest.c               |  50 ++
 util.c => programs/utils.c                |   7 +-
 programs/utils.h                          |  44 ++
 testdata/cert.pem                         |  31 ++
 testdata/file.sig                         | Bin 0 -> 708 bytes
 testdata/key.pem                          |  52 ++
 26 files changed, 1770 insertions(+), 880 deletions(-)
 delete mode 100644 cmd_sign.c
 delete mode 100644 commands.h
 rename util.h => common/common_defs.h (56%)
 rename fsverity_uapi.h => common/fsverity_uapi.h (100%)
 create mode 100644 common/libfsverity.h
 delete mode 100644 hash_algs.h
 create mode 100644 lib/compute_digest.c
 rename hash_algs.c => lib/hash_algs.c (53%)
 create mode 100644 lib/lib_private.h
 create mode 100644 lib/sign_digest.c
 create mode 100644 lib/utils.c
 rename cmd_enable.c => programs/cmd_enable.c (81%)
 rename cmd_measure.c => programs/cmd_measure.c (83%)
 create mode 100644 programs/cmd_sign.c
 rename fsverity.c => programs/fsverity.c (82%)
 create mode 100644 programs/fsverity.h
 create mode 100644 programs/test_compute_digest.c
 create mode 100644 programs/test_hash_algs.c
 create mode 100644 programs/test_sign_digest.c
 rename util.c => programs/utils.c (96%)
 create mode 100644 programs/utils.h
 create mode 100644 testdata/cert.pem
 create mode 100644 testdata/file.sig
 create mode 100644 testdata/key.pem

-- 
2.26.2

