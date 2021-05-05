Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA137489B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 21:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhEETVn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 15:21:43 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:32993 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234160AbhEETVm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 15:21:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1EEF35C019E;
        Wed,  5 May 2021 15:20:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 05 May 2021 15:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=NOChAs8YuRL0969kmwU+cZHrcj
        Q8yt0O99NvdycoeGw=; b=aWPPbDX5EbBFnoeqXM/yifmdRYh/gXUQPYdXh/z+0y
        0FX8DPxDwSdD97SvWhKNKvmpSXGkjHq5SvpHN/ntWJbP4XoGuo6HP5wNvFoiDecU
        0j2L4t86sk87Q8tTHGs6Rg66GmblXY3OkkJDp9Ss0z8AcVDdSIMSv/B1lt4xlJYc
        /OO8L+n4gdx6wmKwaF/Y693o3DTAm3JdQlR/Aq1uDUfsMQTK0siAaQGr5UsxDRWk
        zhaLjJbjxNw2uB5T3cYTPAvL8G8FQxipmngcq9gCdpfYxXiklUjjQFKtsbNt2gaq
        vBBkN2nG4s9MNahy8hQvl3edvTOsRLjcc+Egnawimyug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NOChAs8YuRL0969km
        wU+cZHrcjQ8yt0O99NvdycoeGw=; b=KYcXfto+MxuxMJWivaWhUtPYTc8fATYE1
        MNHSMRMBUtRbkCNdXyIExj1rJwguU9kdKKqcOGWpRsjppEw+kP1NwlYHQswFl7BQ
        +ss10GSws6ILanBC3I1MlShaRJGY6o4N7gVuHUd/2KbmN8jqpAOjaIVqmyIy25FN
        GahnQn2ueV1UAQtwIk7mUeTxqQ00XaFAqWl4uPE8yvqscEAeb9A4Pn0vwtz2ExXA
        uiWO9p2HbOBpYMnj/EVO5tZqOcuRr2rdxkJlpwWRzWKJ5ftEb1fWHjtJ8EgvYHjo
        xoPQYgvJGinRd75aK2e1OcaAMpBDpX0i9rHemj3QBADB2qjPKCELg==
X-ME-Sender: <xms:DPCSYI5IGYlLs7e6R0fkP5AXHyJxoHDUV0uSst1lABcZIKuB3cXsbA>
    <xme:DPCSYJ6U0WUgFXzqTOrw27ufT7gQJ0W0iejIw-KE6oXojlX9_M0V2e7gda-dgd7nj
    qa8rxL7ntuiW_CxPXo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudefvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hioh
X-ME-Proxy: <xmx:DPCSYHeTyqLRGlRnSybS5VJuptvdqzVwP7wiwIr3WKyLSMKMyRplBA>
    <xmx:DPCSYNIfVbkauzDe_RQIa_duhTBQw58N8E0ToUMANFP5kN6KudPo9g>
    <xmx:DPCSYML8sBHVBBpBJYKf_A1sCEL3pT7zHpRCXcXGE0Y-PHnO_qSD0A>
    <xmx:DfCSYGwINC8qzIsGO9z5LtEAFXvZVW9nUn6uGnjp8aHvIxcKhmn9MA>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 15:20:44 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v4 0/5] btrfs: support fsverity
Date:   Wed,  5 May 2021 12:20:38 -0700
Message-Id: <cover.1620240133.git.boris@bur.io>
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
- new xfstest using pwrite to exercise merkle cache EFBIG cases
- manual test with sleeps in kernel to force orphan vs. unlink race.
- manual end-to-end test with verity signed rpms.
--
changes for v4:
Patch 2:
- fix build without CONFIG_VERITY
- fix assumption of short writes
- make true_size match the item contents in get_verity_descriptor
- rewrite overflow logic in terms of file position instead of cache index
- round up position by 64k instead of adding 2048 pages
- fix conflation of block index and page index in write_merkle_block
- ensure reserved fields are 0 in the new descriptor item.

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
 fs/btrfs/ctree.h                |  32 +-
 fs/btrfs/delayed-inode.c        |   2 +
 fs/btrfs/extent_io.c            |  53 +--
 fs/btrfs/file.c                 |   9 +
 fs/btrfs/inode.c                |  25 +-
 fs/btrfs/ioctl.c                |  21 +-
 fs/btrfs/super.c                |   3 +
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/tree-log.c             |   1 +
 fs/btrfs/verity.c               | 686 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   2 +-
 include/uapi/linux/btrfs_tree.h |  22 +-
 14 files changed, 829 insertions(+), 36 deletions(-)
 create mode 100644 fs/btrfs/verity.c

-- 
2.30.2

