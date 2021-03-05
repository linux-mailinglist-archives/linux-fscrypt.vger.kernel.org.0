Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869C432F3D1
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Mar 2021 20:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhCET0q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Mar 2021 14:26:46 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53425 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229759AbhCET0h (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Mar 2021 14:26:37 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id D826B2B09;
        Fri,  5 Mar 2021 14:26:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 05 Mar 2021 14:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=R1S9xrpyOKx2bHApG0G8L8MvXZ
        US7zPy8bmQBqK2XEs=; b=k25A56M/ZeGMIL5Vkkpau4AfWHZbIpMoNJ+x1q3AWb
        KkB9USkBByK7W8MheJulEjiWTM4Fhd2cG2LnodCq8nbJD8vs6kbhbjdHSQbPMvNk
        iYLsthpt5nyQE2eJyqxNVd45ZydtzHGO7sCJ+wLIpEzFnosqNzQovAZJjcUcCUOZ
        +LcSoHBBXSFdXHwmksnPv44oYN0U69PZXwHqTCBKjujHrsAViH1BN/xpMasZXy+M
        3qN/2rOE5uOQoclKHIN5OP/TGXag5D0v4y74/En4sftV3sphadGknmkLfTFJ0pia
        uuTswXKgERJtuymqOBr5h5qUbUCj4QRroDqN9g47ZOYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R1S9xrpyOKx2bHApG
        0G8L8MvXZUS7zPy8bmQBqK2XEs=; b=mbL06SbH8opnb9OAB/Z6Z2uUsO2oINKsd
        LnA0ubRd7ccQB8NlPqlJVCASNrzd+4PrZ74RJaTxZudMeh8XDuR+mYW8AMpaP2jO
        eDGeFkv1Y11gmEdtZTrzJpcZIvKwpcyen/UzqlMDP+s5RPe15D/BBki2S3ngmsMS
        YE5BPVma/0w716pK3azVkv7XV3/Rgq28QnI8AFG3QBJrkzwbxejeuHPqFFaB0ysj
        vAUjI+znjwaW3aSMdFtuhpvmSjbgHiB0zn477iLps06EFJ+wlEiGLpoLsRFOnTLB
        M4a9UD7JaGZtOPi5yoxlE8d072f3tGibl1QfxjvQI7LFi/BpN6EJg==
X-ME-Sender: <xms:7IVCYEhxNn2d4fGpBgAauGGFSVo6G4M0RN9q8N17JLh23c0FIr1-HA>
    <xme:7IVCYM9syoBI3wAVwMfL9ciSgeMskpsnGsuR-R0W1s8ve3rLRfpgBTMFk2ThCclbv
    OpXn9g4SgrIZXmPkHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepuehorhhishcu
    uehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpeduie
    dtleeuieejfeelffevleeifefgjeejieegkeduudetfeekffeftefhvdejveenucfkphep
    udeifedruddugedrudefvddrheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:7IVCYI9D6yU9-7s2rSoxwYIEt6KGQZ-aOUWZmgY-EN6WR2Qv5irXAg>
    <xmx:7IVCYNAqXY8TB1_QFwecGdG3km0hNlWYpOycwjlfLea7R32kl-nXXQ>
    <xmx:7IVCYAwk4aX0wrYTAu7yHNV-etpo1XgYx-fBPg8NcBZsBw1OwoLrKw>
    <xmx:7IVCYIvmUUCoyUEfXC4VcbOk0rXxECZPA0urYoW4CbN8-t-j3Y22tg>
Received: from localhost (unknown [163.114.132.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id D34B1108006A;
        Fri,  5 Mar 2021 14:26:35 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org,
        'Eric Biggers ' <ebiggers@kernel.org>
Subject: [PATCH v2 0/5] btrfs: support fsverity
Date:   Fri,  5 Mar 2021 11:26:28 -0800
Message-Id: <cover.1614971203.git.boris@bur.io>
X-Mailer: git-send-email 2.24.1
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
 fs/btrfs/verity.c               | 658 ++++++++++++++++++++++++++++++++
 include/uapi/linux/btrfs.h      |   2 +-
 include/uapi/linux/btrfs_tree.h |  22 +-
 14 files changed, 792 insertions(+), 36 deletions(-)
 create mode 100644 fs/btrfs/verity.c

-- 
2.24.1

