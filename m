Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF81D4448
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 06:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgEOENm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 00:13:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbgEOENm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 00:13:42 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFBCA206DA;
        Fri, 15 May 2020 04:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589516021;
        bh=GJem1BmKarVXUhYcekk5dg6hFBKngL/v1lCST9F1WSc=;
        h=From:To:Cc:Subject:Date:From;
        b=D+seP9q7XkbhjM4q2+NTvuk82tDSQTL7PfjoG8wnK0J10o4R7FLlpGvbr05r6cAA9
         D/XYcKk7kLK3ZSdrly/1rrFP03A646YqZ062fkurNG7hBZ97PvxWTtiOHErmq6m3ja
         zWv8hAvyY7zhbvjeMxAw2vD4VpBb4VXoTzfCRAG0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: [PATCH 0/3] fsverity-utils: introduce libfsverity
Date:   Thu, 14 May 2020 21:10:39 -0700
Message-Id: <20200515041042.267966-1-ebiggers@kernel.org>
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

Jes, can you let me know whether this works for you?  Especially take a
close look at the API in libfsverity.h.

This patchset can also be found at branch "libfsverity" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/

Eric Biggers (3):
  Split up cmd_sign.c
  Introduce libfsverity
  Add some basic test programs for libfsverity

 .gitignore                                |   9 +-
 Makefile                                  | 198 ++++++-
 cmd_sign.c                                | 635 ----------------------
 commands.h                                |  24 -
 util.h => common/common_defs.h            |  47 +-
 fsverity_uapi.h => common/fsverity_uapi.h |   0
 common/libfsverity.h                      | 132 +++++
 hash_algs.h                               |  68 ---
 lib/compute_digest.c                      | 243 +++++++++
 hash_algs.c => lib/hash_algs.c            | 126 +++--
 lib/lib_private.h                         |  83 +++
 lib/sign_digest.c                         | 395 ++++++++++++++
 lib/utils.c                               | 107 ++++
 cmd_enable.c => programs/cmd_enable.c     |  32 +-
 cmd_measure.c => programs/cmd_measure.c   |  12 +-
 programs/cmd_sign.c                       | 163 ++++++
 fsverity.c => programs/fsverity.c         |  52 +-
 programs/fsverity.h                       |  41 ++
 programs/test_compute_digest.c            |  54 ++
 programs/test_hash_algs.c                 |  27 +
 programs/test_sign_digest.c               |  44 ++
 util.c => programs/utils.c                |   7 +-
 programs/utils.h                          |  42 ++
 testdata/cert.pem                         |  31 ++
 testdata/file.sig                         | Bin 0 -> 708 bytes
 testdata/key.pem                          |  52 ++
 26 files changed, 1742 insertions(+), 882 deletions(-)
 delete mode 100644 cmd_sign.c
 delete mode 100644 commands.h
 rename util.h => common/common_defs.h (58%)
 rename fsverity_uapi.h => common/fsverity_uapi.h (100%)
 create mode 100644 common/libfsverity.h
 delete mode 100644 hash_algs.h
 create mode 100644 lib/compute_digest.c
 rename hash_algs.c => lib/hash_algs.c (54%)
 create mode 100644 lib/lib_private.h
 create mode 100644 lib/sign_digest.c
 create mode 100644 lib/utils.c
 rename cmd_enable.c => programs/cmd_enable.c (82%)
 rename cmd_measure.c => programs/cmd_measure.c (84%)
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

