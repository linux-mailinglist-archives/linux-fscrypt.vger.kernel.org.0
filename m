Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50738358CB0
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhDHSeK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:34:10 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:35607 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232768AbhDHSeK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:34:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8AA7E1183;
        Thu,  8 Apr 2021 14:33:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 08 Apr 2021 14:33:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=U+lrLtZ8bTTRcC+2JdHaAugtTK
        TQVY1gdobQBbewT6Y=; b=sKBdeNWZ7yj5rtcEn4b5gLBhJL/Ve1+KrYJ6Bvi/ED
        wkfR1/766FvtIIvbsnSQesd3hGyhMaQ8/5Zx9sQULbKPs63K1ADwxSXrDuPMKX+m
        kqNPuY8pQ0zGpCOvw5suCBgr3sGxLt+2SZR+vA9BxuY2QlKx+dsiTtYASFON9AA1
        sbPdHxYO93T+Pqk3M4PYGW37Hq9cBKd+C0qLvxuGm14pQr296eRIGYYJQKguZS+g
        vj0BGZL0WqplXc4BViFZaNUBwos7MHJ75FJRNbpYqC2CR2KoR26kdHhgCZ01GAYA
        zwIlhDA0dXJFyRfnAG/ZpdvKrfdkFbz+3xfXeg8uaQdQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U+lrLtZ8bTTRcC+2J
        dHaAugtTKTQVY1gdobQBbewT6Y=; b=ehhtrGeAHA4Nc/lwEimhmXHcixgRDyTpe
        oKn0OtIr9Ykp3uB0WBv+Xncv/oubKrRLyh+d5iC+tCviUfW8hpH4CV0sCkB/4apq
        NABZ8sEOMMf1fVP8T/mS7XPophOEn2ziCGCni8c1oTwE5798kMhO1o8YIeYMUKD0
        zPiX56X8imAHghzjddZlHQH5dWa/sakG4YN5tW6VoP7+8PETfElyKRo+0HIY4AEX
        6L7lXpo13XfrqfaacaWuhRIryA+toaHAIiy2XAaS2bqnvp/r93O/IEOc+wbcvM/Y
        mgm6sr1T94veVrqCTHwpev05ElcDzOLq55QuJsZlbGVeILHz3YEjQ==
X-ME-Sender: <xms:lUxvYKZpRZ2u4NP1ATDEOXaNUeRDr3j9YP9hyluh_GtTV3DpHXO4EA>
    <xme:lUxvYHDSFYgNsnC7Rh7tEeXIBDi1eXyfoph1jfyMaZIyB-uGZSMOmU8MkKDW917dn
    QhA1lsqr4oh1KmJvg8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hioh
X-ME-Proxy: <xmx:lUxvYE8xbV2OwZBfQMLWCiqJFRC1854WPO_bX4ww13U7tSxszHxTGQ>
    <xmx:lUxvYP8AHQ1ODuyf-54fTZLG4rf9sj62Gljq8E0QNwZAhP_-eCVMvQ>
    <xmx:lUxvYDcKHZqQcA4vyIT7hGIexmeXC1M0WYe8bsJjc4l31w7tyE_aRg>
    <xmx:lkxvYK9d424Q62wMSyqMUf3HkTcrIhu9ssi2uqwn6fjph1omdulLYw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id B55B6240057;
        Thu,  8 Apr 2021 14:33:57 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 0/5] btrfs: support fsverity
Date:   Thu,  8 Apr 2021 11:33:51 -0700
Message-Id: <cover.1617900170.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides support for fsverity in btrfs.

At a high level, we store the verity descriptor and Merkle tree data
in the file system btree with the file's inode as the objectid, and
direct reads/writes to those items to implement the generic fsverity
interface required by fs/verity/.

The first patch is a preparatory patch which adds a notion of
compat_flags to the btrfs_inode and inode_item in order to allow
enabling verity on a file without making the file system unmountable for
older kernels. (It runs afoul of the leaf corruption check otherwise)

The second patch is the bulk of the fsverity implementation. It
implements the fsverity interface and adds verity checks for the typical
file reading case.

The third patch cleans up the corner cases in readpage, covering inline
extents, preallocated extents, and holes.

The fourth patch handles direct io of a veritied file by falling back to
buffered io.

The fifth patch handles crashes mid-verity enable via orphan items

I have tested this patch set in the following ways:
- xfstests auto group
- with a separate fix for btrfs fiemap and some light touches to the
  tests themselves: xfstests generic/572,573,574,575.
- new xfstest for btrfs specific corruptions (e.g. inline extents).
- new xfstest using dmlogwrites and dmsnapshot to exercise orphans.
- manual test with pwrite script to test merkle cache EFBIG cases near
  the size boundary of my filesystem.
- manual test with sleeps in kernel to force orphan vs. unlink race.
- manual end-to-end test with verity signed rpms.
--
changes for v3:
Patch 2: fix bug in overflow logic, fix interface of
get_verity_descriptor, truncate merkle cache items on failure, fix
various code/style issues.
Patch 5: fix extent data leak if verity races with unlink or O_TMPFILE
and removes a legitimate orphan, then system is interrupted such that
the orphan was needed.

changes for v2:
Patch 1: Unchanged.
Patch 2: Return EFBIG if Merkle data past s_maxbytes. Added special
descriptor item for encryption and to handle ERANGE case for
get_verity_descriptor. Improved function comments. Rebased onto subpage
read patches -- modified end_page_read to do verity check before marking
the page uptodate. Changed from full compat to ro_compat; merged sysfs
feature here.
Patch 3: Rebased onto subpage read patches.
Patch 4: Unchanged.
Patch 5: Used to be sysfs feature, now a new patch that handles orphaned
verity data.

Boris Burkov (4):
  btrfs: add compat_flags to btrfs_inode_item
  btrfs: check verity for reads of inline extents and holes
  btrfs: fallback to buffered io for verity files
  btrfs: verity metadata orphan items

Chris Mason (1):
  btrfs: initial fsverity support

 fs/btrfs/Makefile               |   1 +
 fs/btrfs/btrfs_inode.h          |   2 +
 fs/btrfs/ctree.h                |  25 +-
 fs/btrfs/delayed-inode.c        |   2 +
 fs/btrfs/extent_io.c            |  53 +--
 fs/btrfs/file.c                 |   9 +
 fs/btrfs/inode.c                |  25 +-
 fs/btrfs/ioctl.c                |  21 +-
 fs/btrfs/super.c                |   1 +
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/tree-log.c             |   1 +
 fs/btrfs/verity.c               | 683 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   2 +-
 include/uapi/linux/btrfs_tree.h |  22 +-
 14 files changed, 817 insertions(+), 36 deletions(-)
 create mode 100644 fs/btrfs/verity.c

-- 
2.30.2

