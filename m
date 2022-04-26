Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB885510C20
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 00:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355897AbiDZWnb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Apr 2022 18:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345860AbiDZWna (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Apr 2022 18:43:30 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEAE13EB2;
        Tue, 26 Apr 2022 15:40:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 92EE05C016C;
        Tue, 26 Apr 2022 18:40:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Apr 2022 18:40:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1651012818; x=1651099218; bh=GVOxxF6CxDAlP5EYgy6Xe7pqM
        H8D9OEw6NHfUbYlWWs=; b=I0oHZmcDseCahMm1HT/Y5PsPjprLi8ZOo68s5EGkL
        pgpgXrwai0KVQ/E0FfMdqTkpVvRGCaMHPi6pE1MqZkrPLdx8z01o+Ha/wOaR+V6S
        +YsVB5BUJuanH5OxsX2E1ZMUWi5mFtNpfiVXbjRwblfBF9gag/2S+dd4LX9dCz/i
        fIRyYdGCKE7/UMU4MZS/bLandDDOG+uciELxUdzP2KTkGj/QULYHPgyewinhxy37
        LU4grM4gV9wmzKvM8E6V+kf5254I2s8tS4UUxXbxYFtF1FgEijis3w17YNYEs9B2
        W+1eWR2h552CXJJkfj8tkfwSJOhDR670hhsy7TP/R4BCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; t=1651012818; x=1651099218; bh=G
        VOxxF6CxDAlP5EYgy6Xe7pqMH8D9OEw6NHfUbYlWWs=; b=XB1CMYF3ozQV0+zNp
        5YLeQmDkGwAANhWmnw7Q+oHDVX45SmdwcbtfOASuukehsHvUJcAUtlW2Dic2eiXZ
        9DteTzjNUWe9WKbxw50zxgrELTJ2GE23nqfQ+pTD9/GN08nzAy4+0IXX0mu1dDN8
        5QPjm8o5M94U5kQ6ZJFXNvoVr8CKeMdgY9b3jHvxtgdgy+6wnJ+N5g6Lh3YCb04k
        5AmyXIlx/zMxyd/KkKwpsEPiOrwj0wItA/Upzn3MVnBGxtrYjW6USAq8yPp9w7uJ
        aJtKcotvOq7pmNzAhbohdPHUiqwHM+4pF5eWqb1bfoyfHsAz9ZK7APgPLUzNc9Id
        J52Wg==
X-ME-Sender: <xms:0nRoYvNIYTAv11gcqyJ1XETzUxwBrLriDyEATGozkC5lE5Uv07qxow>
    <xme:0nRoYp998EIU8C9_JOwQ51KUYk4SXgVRgpWDfv3JUjYbpDpWR6I_txcz-tobaLGgQ
    LmA1M1fbq7VYEwaA9k>
X-ME-Received: <xmr:0nRoYuSuNjlJRkUSm17N2V61jPce7ivKkhYt7kHQS6bm3i9vRAr_XieATV7x3gxlgRMblOg6INWJMveHMmwEVqoPn6p7og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekuddute
    efkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:0nRoYju7fLTfSnoSstKIS8Bm1CPnp_jzEdikZijWMgH0CHIQ1Gs_tA>
    <xmx:0nRoYnd--ukJ63JkKTyw6UxZ87o-64kMnr_G49c9x_ara7rhXywOBw>
    <xmx:0nRoYv1e4fXOwDYidG3fwzFxrVbtstBLp0uhoZUuGGXSo1w38YLdxg>
    <xmx:0nRoYopD1KomiSi4JQu5619P9Rhhliw_PFVT_t_3qhJpQdqqLiVMyQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 18:40:18 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v9 0/5] tests for btrfs fsverity
Date:   Tue, 26 Apr 2022 15:40:11 -0700
Message-Id: <cover.1651012461.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
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
 common/verity         |  45 +++++++++++
 tests/btrfs/290       | 168 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 161 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |  40 +++++++++-
 tests/generic/574.out |  12 +--
 tests/generic/576     |   1 +
 tests/generic/690     |  64 ++++++++++++++++
 tests/generic/690.out |   7 ++
 12 files changed, 520 insertions(+), 11 deletions(-)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

-- 
2.35.1

