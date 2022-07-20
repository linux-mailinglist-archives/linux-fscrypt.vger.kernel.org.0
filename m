Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03FFF57AB28
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 02:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238389AbiGTAt4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 20:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiGTAtz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 20:49:55 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F1B6053E;
        Tue, 19 Jul 2022 17:49:54 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id AD0853200035;
        Tue, 19 Jul 2022 20:49:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 19 Jul 2022 20:49:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1658278193; x=1658364593; bh=IWxJGxAhoY1064YWDHaiNxy+k
        vgKWw76SzZ/r4fMegE=; b=CczP1Uj+X7qtZ47gy51eB5OgJaXobYViNXZ6rCs0X
        ALfHiFt24zzzBpRxNYaHz3lLXOtsktgMddA07mPZjD5/9ZgHnH/+q2HUwg0kXTC+
        5LN4zKU5HOVWjyuXBXuO6zZtkmSrDelOtp+akD1Q2fdf1Ittd+2/b5f0MhsbUo5N
        fFB7ewlZlE+wZZoqcjt1nLyaSo0w6Ji3bt6baQjPiwDplNCY0Bd+6ShKzJ8Z6cbz
        KL6lnWAwW/Oa2+6MJWWVj9anLrMcDXJpq+sdpzflXzw6cJXu18TLFZJFBzKEhbz0
        /MQpDYSN+ii80TXxOeP6OSu9Kz8MWWhpANA5+88rwSEZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658278193; x=1658364593; bh=IWxJGxAhoY1064YWDHaiNxy+kvgKWw76SzZ
        /r4fMegE=; b=Xxb2og5KA/00cWLpAi2Qbe3vPOoDMf7+aQsVNrhzZqo9pa2GlAF
        NfG0MyOzfu2KzkDEpNEXQxod8YKsZSIjmUCRnxbpr1j6jJ6QjwhoXgqfK/OjvOiU
        fVxbt+fbBjpxK4tsSU7cSmz5JbmcSivFdgoh/s30mfvGm/d1KRd/9ZXkgIuCNT26
        5oQhzWVqk1a0qcCsJ3rGE/k8h5o9z071UWDKas7nw4tKFz+PFWeDzb8DBxFA2cy1
        BJr5v4kpx5xTWAQzrWQ+cikhSPLuTCINpRx9XYghhF9FGWRCmuyzUjDAKxp+bSp2
        C7fZnfxWfAvJswPx1/gp0OSGBdGwRRGF2ww==
X-ME-Sender: <xms:MFHXYtoxp2KY57GarnuId5RFghG17udi98IjrIYzbWAfK6jvhXK2lA>
    <xme:MFHXYvox6IBqZcwScaMj8NMXccT4grCVDeCjlJj0XfYFWO1oyPIij9_KKjSAhp0x7
    OUI9swuZzcayskg0G8>
X-ME-Received: <xmr:MFHXYqM7nFWgQo7nfvNwhTnKdrq7zPeesNY0-WlqTUtUXCft5nYUYZy2KZJRg10QJtyYZTTdsBu8jSGA2hPkPP8wU71FzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeluddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeduiedtleeuieejfeelffevleeifefgjeejieegkeduud
    etfeekffeftefhvdejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:MVHXYo5CQWpoWBY2rd0eVZLi_TLY8gj1JdT2Yc6dNcjRG0FjYnxGvQ>
    <xmx:MVHXYs6uwJpBqrVft7gOCrdlYXwitLmAO8PZMuowoPE6aRJqp2gtOA>
    <xmx:MVHXYgge5ktVt6KOFb7VCC9Yh5MHNvcE8WEiDO5nwl1wMSIQeJCDkg>
    <xmx:MVHXYsGH-ZEo9yqW3ttNbPcNzHmAolUTpz6ttRQcFnwGvdVwov52SA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Jul 2022 20:49:52 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v13 0/5] tests for btrfs fsverity
Date:   Tue, 19 Jul 2022 17:49:45 -0700
Message-Id: <cover.1658277755.git.boris@bur.io>
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

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
v13:
- Fix quoting of $MOUNT_OPTION in -z check
- Stash $MOUNT_OPTION export for btrfs in _require_scratch_verity
- Change pointless '<f grep foo' to 'grep foo f' in generic/574
- Refactor logwrites orphan test to use logwrites fua hunting functions.
  It ran in 6 seconds instead of ~30 on my machine, and I was able to
  verify that it still hit all the interesting cases.
- Add recoveryloop group to orphan test
- Get rid of overly pessimistic "UNKNOWN.3[67]" from verity item grep,
  rely on a new version of progs (needed for corruption functions and
  COMPAT_RO flags anyway...)
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
 tests/btrfs/291       | 168 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |  38 +++++++++-
 tests/generic/574.out |  13 +---
 tests/generic/576     |   1 +
 tests/generic/692     |  64 ++++++++++++++++
 tests/generic/692.out |   7 ++
 12 files changed, 532 insertions(+), 12 deletions(-)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100644 tests/generic/692
 create mode 100644 tests/generic/692.out

-- 
2.37.1

