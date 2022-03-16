Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDE14DB94D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 21:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357515AbiCPU0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 16:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239396AbiCPU0f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 16:26:35 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E78D49901;
        Wed, 16 Mar 2022 13:25:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id A6D66320206E;
        Wed, 16 Mar 2022 16:25:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 16 Mar 2022 16:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=QDot+6UjOxbQyyLJnalWB0idftOb7lHn6p2ARWoQz2I=; b=kq4N2
        4miAZROuVmcwnWqU+2xAR00f17/+cKSvhhi0w6cE69t50SuPIA6LV8qOda3M0PFB
        uyDmbuYR7xwzlB/5yi00RBS2AX38BJKyRkfrKnqqcCPqw9jfyRdwY9AoA2n8c6U+
        YygsFa1u/mzyqlhbKUzZkT50FB5ZpP78pu3IL6tShErBdFzDdnn25a/s625zeEfU
        3nh9cvlC5oRUPCo+utJRai5OiwauQXe6ANFa6xgue7XtKLikWqjwg8DC1bKQHlQB
        cFTKHHPVjEjg7dIQ8umGYe2wy/Ll7gWAzMBVZokfLJmNLXjMsO8Oh5LbMTcJbn1X
        4nLm5LD60hWw3EfpA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=QDot+6UjOxbQyyLJnalWB0idftOb7
        lHn6p2ARWoQz2I=; b=QxhLthIB6PXpMEg/LlMEowjJATaojxkRnZpkM+yBlmtmL
        MxTOrE2rRnlxu4UAf76W1FylRlGGg80o9Mnyy8ZmA1+PWC5BBwGbzHWa0rdFn1Co
        rGxnHg0MxbpxYRVToSNOKj1g6Bjn/PS3WkmAaOLIvXAB0PdokAOzraOCRiZVRJ/D
        E8RbNPiwcXa/QR4Vh86yfCQ3ft4YblVg/euLCxmsayaj5wPOG7mk2peMiMh3L/QI
        EdUp52itQSlhOZYvPa9scsM+zx5DKuh1YO+us5/oOJitDJehrhcIt2KgVzl3pqC9
        lXwW4Ee6396t11ZK/sLWn5Qmw+LmJbxRTEz48fRTw==
X-ME-Sender: <xms:rUcyYrqA2DMkcOeJPOODFrw23mLAREGuzKhiMIKg3HiE13JsarfOCw>
    <xme:rUcyYloHRNa2zDWDQHRAFABFLq3Brfa-MaBcSwOysq9p7ZGnDzzOooxYvIaAaOs7e
    ch6dxkM-zzNXLdLX2g>
X-ME-Received: <xmr:rUcyYoNV6iNFPsAql1qxnGrUWCET2f-jt2V-jwT84Nj7QMkS9u4Xa3tk6pwc4pyWW4QKgFIjudiJYCR5ugcwvvH76Qra_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:rUcyYu6GQYfpqlq-tzev7n3rz2OCQZeyduVTEmRN2mZFTZ40DyFpdw>
    <xmx:rUcyYq4LzHm1jZhLV6Vs00CH1jLTCajJRX9q-VAQOiTVa3WsP_zDow>
    <xmx:rUcyYmjprVcPL-mYdrUu3HjSrfZFKO6fgGZ_rS5GQOsofyuaB26XIg>
    <xmx:rUcyYqGgf-3FrtysdhsYbczVDWlK94VeNjPIXsa8g75gVQaWCt7vJA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Mar 2022 16:25:16 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v8 0/5] tests for btrfs fsverity
Date:   Wed, 16 Mar 2022 13:25:10 -0700
Message-Id: <cover.1647461985.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
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
 common/verity         |  40 ++++++++++
 tests/btrfs/290       | 168 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 161 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |   1 +
 tests/generic/576     |   1 +
 tests/generic/690     |  64 ++++++++++++++++
 tests/generic/690.out |   7 ++
 11 files changed, 475 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

-- 
2.31.0

