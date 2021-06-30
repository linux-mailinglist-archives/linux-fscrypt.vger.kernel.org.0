Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7FB3B8969
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Jun 2021 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhF3UEW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Jun 2021 16:04:22 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:60055 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233693AbhF3UEW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Jun 2021 16:04:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id E17EB32002B6;
        Wed, 30 Jun 2021 16:01:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 30 Jun 2021 16:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=54MUJBaCNQy6CfUtEBarP383iJ
        WTUomP7q29/4iNmQA=; b=Tm5NTZ+hIyDUtK/jltg97ixR0Uhgsa2A28Imey9YCs
        XQcpMCPLWPXF6zQsW9xgCUAl+2M408BTp8FYOnT18QBHHbmBxIyrbjPWGbOrQ5+E
        Tt/0a50Q6ukL81idLCBZ2SGlMZDTuEgXzGH7y8rdPkmSNbI/e6e1c+NbYcbDh1+S
        BmUky5Z0M7D7y/BN/4L3eCQzNQpOfO16s1ng21zICbWDPAFa5mxOZpViaghxnsJR
        COsg/upGY+8NLZdtcv0vusWlOZxNLGW1rTYtSshXWyCaVyCrSavOA992XslcW7dW
        w1/iDySlO2m6tTqoSP/YS1Pf/OcHxSqDBw1yqViOZZmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=54MUJBaCNQy6CfUtE
        BarP383iJWTUomP7q29/4iNmQA=; b=FOoYjAagF+CH9xlPy7Ao9AIqV1tzmxs3+
        5Bc8/kY0SD2mLPmK49ICXLHnA+s9UXP1YH+O6XwoHgr8JWbkuK7vYOMx5Uz3QPFX
        l2XaL5Gl7YiAxrMCusvPb/38LGofrOp6/G2CDmwqIwOm0o/IHzT0INhMRfODhnzZ
        sZPovawPdXlwIz/T5/0g11CwiTGP5EiFAqIu6kjNaqbFI0GRkGnVGJTXB63F4q+x
        ab/HC25+OSNwnlh3OFAFt3UQ91SyNlv3fDPBgQCFW4pX7lKcDfEVR2oBAUY2igr3
        ChBDGkFaSZc1ER7+iVgUDbDNZ22PoqhPPVV3kl8lRLf97Qa/SwrvQ==
X-ME-Sender: <xms:sM3cYLOknOgIueOAo-slmrM2DGa4iOoi1QowhwzgS-BSihP-_5eGag>
    <xme:sM3cYF8OpR1o42b_e3tSfmEumutMRo0ZU1l-Xol6P5O1MAgsvAv-K0mpz0wbLgCoG
    5_r603yyhRqN6zIgvM>
X-ME-Received: <xmr:sM3cYKTQJIPpKi74cdoMbTmMcc1P6jtGUfu82OSORkSFysN2Loqo-5PYCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:sM3cYPuZM74jWR44BIOfLQXWriQSqI8RFxWjWCakJQvwDccMwyHwIw>
    <xmx:sM3cYDfW9zG1pk97sknEhb40KoI9LwgkXqfGRaDOmuZPjxclaSKxlw>
    <xmx:sM3cYL07lp5o9wJx8uBc44Bs0cD2Rv5umn10pnqj7KnYCcVjM5ONkA>
    <xmx:sM3cYLHJ59L2RVHDUKPxQA4hupCVK9BfwssTssWJO4P-Loi6ArZYWA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Jun 2021 16:01:51 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 0/3] btrfs: support fsverity
Date:   Wed, 30 Jun 2021 13:01:47 -0700
Message-Id: <cover.1625083099.git.boris@bur.io>
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
changes for v6:
Patch 2: fix bugs reported by smatch
- fix unintialized/unused variables (copied, root, trans)
- handle len=0 in write_key_bytes
- 1 << blocksize -> 1ULL << blocksize

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
 fs/btrfs/verity.c               | 831 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   1 +
 include/uapi/linux/btrfs_tree.h |  35 ++
 15 files changed, 1029 insertions(+), 47 deletions(-)
 create mode 100644 fs/btrfs/verity.c

-- 
2.31.1

