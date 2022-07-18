Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531EB578E99
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiGRX7X (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiGRX6t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:58:49 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79D833E35;
        Mon, 18 Jul 2022 16:58:37 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 1D4DE5C014E;
        Mon, 18 Jul 2022 19:58:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 18 Jul 2022 19:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1658188715; x=1658275115; bh=gQ/fKJenOIRh8m4xbEpyuBoO/
        mctDhsfDN7unQ4xjL0=; b=I28VFf5SuAveWA+YgFxY3T5y9JhlAugvob87IMnNP
        uCgUSEXQlKJ77JxSLLl3tcQIpcpT/QPB1EAEpUP7TtNnPCalYnuSxo8k6305vda2
        pEfEoIyCfyu9C2xQzo/vfqrU3mmcGk7Nodm9iys2kmj66dzhLFHraFWAHGDbY+Fz
        rPmf54AEy1d82iOXmdnI7hdxCnfCmoPpdTU3inuvuLKpJc2FRG2u2XuXgmMVfw+D
        JgdOy2iNWJKAdV5cRJLgp+Sv+tn0aylY1IFXRPW7YyDtJFMXSp1kx8HVkL6sl6mo
        tbQG8qKBraLYQwik3JDOhV/SdZ/3fUHc+jpKdYtMJn+uA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658188715; x=1658275115; bh=gQ/fKJenOIRh8m4xbEpyuBoO/mctDhsfDN7
        unQ4xjL0=; b=rE8Jblhk4IRnQC11VLnq+yaLN+0FFBa9pOzITeylEVw2qcssw3F
        /35V/vsUSMx4lGjX3XRnItx9S9MKrULSw/vcRFS0AkE/U29bfdtUdu4PFgSj41JU
        sZEtBLcxpCGNfdKpxpYxAtRZnFIRNdo0lhsl1wcYcBKRFjSDXBbVqiu2JUNgIFA3
        dvqJAMTqaGtniubRahIrrt4MgZhcNDClsghg//NkpBt/00iWaqaDjVZvR0qWGV3s
        umY6VrvvANciuPPloeLa9vLbnlMxHFgiNiLmNsV7VdYSg5cuFrCRWrTEjTVwLMi/
        WDtyE2vIwmhxUIpYXeUH4n4Sdc0kvsOE0ew==
X-ME-Sender: <xms:qvPVYmSF64htd98xyLulEouTEb9VgfGtLwWnKmc0Tnhys6GX5hs4oA>
    <xme:qvPVYry_Rd4l6Ac55pJBvaZ99taBYmtkpv33dd_0Oc1ToBHWJf3A4ttOa14lHgSUj
    6XYGxvLZ8T1lOqXoZo>
X-ME-Received: <xmr:qvPVYj3jpQ478BQn9q-0IZIxDTsAMIB8oMukUic_Z16arpbSdTcSWyQgbtfukSCJ_lSGTu_fZsA3NikeVBi3eWaYr-sTug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:qvPVYiD76e2QOLc1AgiCMWf-ARW_kw9-6fkuFocDAhxB4m5NgD2qKA>
    <xmx:qvPVYvhwAgIbOxPx6et4bfokrWW84-dwxbR7ILhyaVCE4wPC9aQI8w>
    <xmx:qvPVYuqFD8K8SqiXQtVLFNf8ONQH8zqKkMQL-IdDdXdvz3ysXWLoRQ>
    <xmx:q_PVYiulHd-0HY6nYkBunX0UMuEpIaBvYhwqfGXFEFkGu2jVVSmNjw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:58:34 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v12 0/5] tests for btrfs fsverity
Date:   Mon, 18 Jul 2022 16:58:28 -0700
Message-Id: <cover.1658188603.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
v12:
- Actually incorporate Sweet Tea's significant improvement to the commit
  message for the log-writes test.
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

