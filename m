Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D030578E1F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiGRXNq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGRXNp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:13:45 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025DA3336C;
        Mon, 18 Jul 2022 16:13:41 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id CF3105C015C;
        Mon, 18 Jul 2022 19:13:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 18 Jul 2022 19:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1658186018; x=1658272418; bh=Ea7uAc437JTsI0WaiMxd88eXO
        icnfwPVEvH8o/Gpapk=; b=hOc3j6iR62HvaOOYs0KwpmHNrlLT5IwEPFmWQLSZj
        NSyG124EqEdwa6ZUtXw99mEqg0sux7IG2pJWGFE+GmzMytr4zFrUfL4y1wtO0EKz
        iaDbQIaBTGlIeAiG56rWL6Z8l99uD9KI2V5qd522wm3WxvUaYVIZJc6u1rS8dHRi
        Pc+W4GIYEBGAya8I0AjAT1I/XhKWiESuvhdObRQMVR0oyPsMI5+BXFCTJ1B2hZS0
        9n/H8VxBU8/tFd2i74Nne2rPNEcYdFl9sopYnXG5i5rIS/RsVaQ2RDooc+sx+OTT
        EwibKTlpYHycV4RwoRqoy11fd1mcS0ESIGunksaoOEyXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658186018; x=1658272418; bh=Ea7uAc437JTsI0WaiMxd88eXOicnfwPVEvH
        8o/Gpapk=; b=LLtBjVS6BW781mvbBGqUtmZTO+QWNBMRzo7dNv4TuFi4PYKdLuy
        GTYYryT8xp1gl9QVJrlq7j4OOZ//0L8ow/D9z2deyQdvCnvz5kD4RPs7f0dgSwkT
        ZoONFEcf7z1YCaEwV4/8Mo2Dv6mG5TqFKMJSoPCiC/NOuxKimYN/v2JNyIIZcaGj
        oNYGiAGB8j2o7ChzT+kwC3bN+nQZrpmlrSXEg8qoovC3ztFSzJoFXyS9EJLtx9HY
        5ug+/aclNxsR9dik4N49gNEyGHzcCo7dLpgnNr9ypWax7SV+TyEyPXST6CLC1mfs
        uLi+AD0Ky7jiOzJIyW/tkLLfGFCJ9N+6F6w==
X-ME-Sender: <xms:IunVYq4k-aMtxLHxWA_e3UzdpTzCJS6ITbbHwsGlgq8VRsBWGvTo2g>
    <xme:IunVYj4OZ6T_dpeF3F5pDXRf17aZBa4gYXrG4et6FWajgX0Sn1YiPLHVOSrKQ9WyI
    R1LIJNkuAY1LCjK7ng>
X-ME-Received: <xmr:IunVYpccNXMTi2yqPGyGHKw0i7f2IukGGPlzgqeFL1QTVNZ4E427lNzkQ7M1FmKXE3Ed9g6-1U2HoXVAIzgU8xsvN8mELQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:IunVYnJCZFcqM0J3M8sjNR-HwpRDsewGdXPVqeAoJEeO8E7fZmuQNA>
    <xmx:IunVYuJ6vqLX_QVJpyD4EoK24Oiih0HsAa8spAyHFa2aewkZOQyE5Q>
    <xmx:IunVYoz6vzJ43LNLH0hVP51C5nlVAiolToN28kMnSrGzclZfqnqmVw>
    <xmx:IunVYlVCVSYj3CNFnFVrtn6F82CGFZrFAXYOPf_yVqu4CRNqnXzgxg>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:13:38 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v11 0/5] tests for btrfs fsverity
Date:   Mon, 18 Jul 2022 16:13:32 -0700
Message-Id: <cover.1658185784.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
v11:
- remove unneeded common/btrfs sourcing from common/verity
- fix btrfs/290 prealloc test in case the disk extent actually
  had zeros.
- make logic a little more consistent in btrfs/291
- make btrfs/291 work regardless of how btrfs-progs prints the Merkle
  items.
v10:
- rebase
- add nodatasum instead of setting it
- rewrite eof block test to read zap_len at eof and to compare with a
  zero file instead of using xxd
- add _require_loop to the log_writes test

v9:
- use nodatasum for btrfs corruption tests.
- modify eof block corruption test to allow all zeroes rather than
  requiring an error.
v8:
- reorganize to have a patch for enabling generic tests followed by the
  patches with new and specific tests.
- fix some rebasing miscues from v7.
- fix a chunk of space characters instead of a tab in the new requires
  function.
v7:
- add a new patch to make the new corruption requires more clear
- require corruption in generic/576
- require only btrfs_corrupt_block in btrfs/290
- add missing xfs_io requirements in btrfs/290
- remove unneeded zero byte check from btrfs corruption function
- fix sloppy extras in generic/690
v6:
- refactor "requires" for verity corruption tests so that other verity
  tests can run on btrfs even without the corruption command available.
  Also, explictly require xfs_io fiemap for all corruption tests.
- simplify and clarify "non-trivial EFBIG" calculation and documentation
  per suggestions by Eric Biggers.
- remove unnecessary adjustment to max file size in the new EFBIG test;
  the bug it worked around has been fixed.
v5:
- more idiomatic requires structure for making efbig test generic
- make efbig test use truncate instead of pwrite for making a big file
- improve documentation for efbig test approximation
- fix underscores vs dashes in btrfs_requires_corrupt_block
- improvements in missing/redundant requires invocations
- move orphan test image file to $TEST_DIR
- make orphan test replay/snapshot device size depend on log device
  instead of hard-coding it.
- rebase (signicant: no more "groups" file; use preamble)
v4:
- mark local variables
- get rid of redundant mounts and syncs
- use '_' in function names correctly
- add a test for the EFBIG case
- reduce usage of requires_btrfs_corrupt_block
- handle variable input when corrupting merkle tree
v3: rebase onto xfstests master branch
v2: pass generic tests, add logwrites test

Boris Burkov (5):
  common/verity: require corruption functionality
  common/verity: support btrfs in generic fsverity tests
  btrfs: test btrfs specific fsverity corruption
  btrfs: test verity orphans with dmlogwrites
  generic: test fs-verity EFBIG scenarios

 common/btrfs          |   5 ++
 common/config         |   1 +
 common/verity         |  48 ++++++++++++
 tests/btrfs/290       | 172 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 ++++++
 tests/btrfs/291       | 167 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |  38 +++++++++-
 tests/generic/574.out |  13 +---
 tests/generic/576     |   1 +
 tests/generic/692     |  64 ++++++++++++++++
 tests/generic/692.out |   7 ++
 12 files changed, 531 insertions(+), 12 deletions(-)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100644 tests/generic/692
 create mode 100644 tests/generic/692.out

-- 
2.37.1

