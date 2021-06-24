Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53A73B3950
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Jun 2021 00:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232875AbhFXWne (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Jun 2021 18:43:34 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:43075 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhFXWne (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Jun 2021 18:43:34 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 2FBB73200915;
        Thu, 24 Jun 2021 18:41:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 24 Jun 2021 18:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=ZzbCx04jtNFOGuklkVjUanZ6+T
        Lt2OeTVFaiWEBjksU=; b=oIrkU61lUNChHacIBEHzLS9Gn+on7XRrvART8UuKsU
        3DKDXg/itkr+EZGRMZMJ8DlhvRG/G+tqu+FujqMvtfyFNaC5ttUuAINapKmbDv9p
        htHAjxj+EVq6tYkgM2gP1xyzEs7wuXE+x7p+O+3qR7Jm5/GtHTiTEpf0pBAwef41
        M7GG1oEBQGyF6YIqdjkuXsPpI3oEgRrSds+m+eeF/1oNceiJBRHl1lMBm9TCX4Ex
        /MYSCMHblVQj/jAVLfAnxIL3s0bquRX3cmW6qtvQBCZPLUIL7Rs/PJ1HHomTcnlR
        qWlxDkcZ/IiUdW3o2NsJNwWRLirArwMygVtM86xAob6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZzbCx04jtNFOGuklk
        VjUanZ6+TLt2OeTVFaiWEBjksU=; b=ND42MbgUAbQ6oDxFrj+gr3GLigxZYcLle
        4Fe6PBliQAeihCoIY5KcnC7NNxnJ21p8oggPWGDD5vpb78DHxvBHZxNoXM2mboD7
        V1A2n0l3fIA72+YWBfSXru3eRiUStd5+izpp9eUEFVjnACRNDBoCtKg7crVLfu+y
        vcZWf6wQFjNzYYTiwMm0NqOPGbP+jnkmTLQyK7REP/EfVwADE2irupfP50l448hY
        FP2PM0Tc+F/RsR6XyEsmchvXRkvCzkxGuOY2Mc649biNjSrU3F26zWcVoRodk63d
        oYIeWn0p7HLje4hylijb19nz83dZx/yh+TZm1gWY9qDi4tJMGA5kg==
X-ME-Sender: <xms:CQrVYFkhGJpK9qR5gg-yloCsmEWz5Rd3tB4xSzL1C4F_fVtce34Sjg>
    <xme:CQrVYA1FPn5VpgdipOGdAb1uCs3xcar3bc4KAYOl-RMvqpmEDwdZ7n8xmkTNOZAZy
    G1OwcM1HSBx6YBIbG4>
X-ME-Received: <xmr:CQrVYLps6ZetFJ3BU9OHoTIFJxMb-TZM5umOwxgV-AP6nh184zHj-3ZebA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegiedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:CQrVYFnTbTJeIYw2YRSiUOW-NsMli--VBihJFJ5lummc0tPFDkou_Q>
    <xmx:CQrVYD239GQ3Dg-7JngDjqLBC7u0Ec56D4IsbuGd8OalxA4j62zJWA>
    <xmx:CQrVYEtv9SsaVDf8D1hFhDgjWvZ81gdjM3Zbcn6_lhsH1LrwUyrszw>
    <xmx:CQrVYM-QoKQxd9MRa5NjhLsJh0Z4XjxxhloQcftt7vAnffgXBlWJzQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Jun 2021 18:41:13 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 0/3] btrfs: support fsverity
Date:   Thu, 24 Jun 2021 15:41:08 -0700
Message-Id: <cover.1624573983.git.boris@bur.io>
X-Mailer: git-send-email 2.31.1
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
enabling verity on a file without making the file system unusable for
older kernels.

The second patch is the bulk of the fsverity implementation. It
implements the fsverity interface, storage, caching, etc...

The third patch handles crashes mid-verity enable via orphan items.

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
changes for v5:
Significant rewrite/re-organization. Most changes in patch 1 and 2:
- rewrote ro_compat flags to use top 32 bits of flags, discovered tree
  checker/flags definitions were broken (see patch 1 for details)
- merged dio and inline/prealloc/hole patches into main verity patch, as
they were basically empty.
- rewrote rollback to abort much less aggressively
- put orphan/enable verity on inode in one btrfs transaction
- tweaks to returned types to prefer u64 where reasonable
- use kmap_local, memzero_page properly
- use GFP_NOFS for allocating merkle tree cache pages
- many documentation fixes/improvements
- many style fixes
- rebase onto kdave/misc-next as of 6/24

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

Boris Burkov (3):
  btrfs: add ro compat flags to inodes
  btrfs: initial fsverity support
  btrfs: verity metadata orphan items

 fs/btrfs/Makefile               |   1 +
 fs/btrfs/btrfs_inode.h          |  27 +-
 fs/btrfs/ctree.h                |  53 +-
 fs/btrfs/delayed-inode.c        |   9 +-
 fs/btrfs/extent_io.c            |  25 +-
 fs/btrfs/file.c                 |  10 +
 fs/btrfs/inode.c                |  31 +-
 fs/btrfs/ioctl.c                |  21 +-
 fs/btrfs/super.c                |   3 +
 fs/btrfs/sysfs.c                |   6 +
 fs/btrfs/tree-checker.c         |  18 +-
 fs/btrfs/tree-log.c             |   5 +-
 fs/btrfs/verity.c               | 833 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  35 ++
 15 files changed, 1031 insertions(+), 47 deletions(-)
 create mode 100644 fs/btrfs/verity.c

-- 
2.31.1

