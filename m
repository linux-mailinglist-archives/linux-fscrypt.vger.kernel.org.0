Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8361C8420
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 10:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgEGICG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 04:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEGICF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 04:02:05 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E55D20753;
        Thu,  7 May 2020 08:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588838525;
        bh=8lxPu1GJKKrJRy1UQ0dnX2QT0LRqToRw9cNPct9sjzk=;
        h=From:To:Cc:Subject:Date:From;
        b=IU4KDFFnoexDsKP4WOWlZEb7iBX27h0ePrYPQ6zhAYK/UEQxP4R5NDjaEMXfrGnrQ
         z13uPdrFA3/0DYgUkfGM6LW/AHQXyC3ooKXZf6WX4N3xNP4PyxjxBuLc99f8b4CGom
         OHSum1KEDBr1tX4L9OJ5SIY65QHyJQM+jIejr3bs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: [PATCH 0/4] f2fs: rework filename handling
Date:   Thu,  7 May 2020 00:59:01 -0700
Message-Id: <20200507075905.953777-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset reworks f2fs's handling of filenames to make it much
easier to correctly implement all combinations of normal, encrypted,
casefolded, and encrypted+casefolded directories.  It also optimizes all
filesystem operations to compute the dirhash and casefolded name only
once, rather than once per directory level or directory block.

Patch 4 is RFC and shows how we can add support for encrypted+casefolded
directories fairly easily after this rework -- including support for
roll-forward recovery.  (It's incomplete as it doesn't include the
needed dentry_ops -- those can be found in Daniel's patchset
https://lkml.kernel.org/r/20200307023611.204708-1-drosen@google.com)

So far this is only lightly tested, e.g. with the xfstests in the
'encrypt' and 'casefold' groups.  I haven't tested patch 4 yet.

Eric Biggers (4):
  f2fs: don't leak filename in f2fs_try_convert_inline_dir()
  f2fs: split f2fs_d_compare() from f2fs_match_name()
  f2fs: rework filename handling
  f2fs: Handle casefolding with Encryption (INCOMPLETE)

 fs/f2fs/dir.c      | 415 +++++++++++++++++++++++++++------------------
 fs/f2fs/f2fs.h     |  85 +++++++---
 fs/f2fs/hash.c     |  87 +++++-----
 fs/f2fs/inline.c   |  49 +++---
 fs/f2fs/namei.c    |   6 +-
 fs/f2fs/recovery.c |  61 +++++--
 6 files changed, 430 insertions(+), 273 deletions(-)

-- 
2.26.2

