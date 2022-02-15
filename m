Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CF04B5ED6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Feb 2022 01:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbiBOAKP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 19:10:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiBOAKO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 19:10:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BE9AB450;
        Mon, 14 Feb 2022 16:10:04 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A7495C01D6;
        Mon, 14 Feb 2022 19:10:01 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Feb 2022 19:10:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; bh=cHzUZrMqkoXOYn28/jbP8mE5rbfh5W6/uFfsX5hJOwQ=; b=CRxS+
        zjLshFGpn2/TB/Ue+G8SiyFUxBuyTXSUGiwMt1PMgB49FnKEgfl980XBdepqis5M
        oVy+vAiJvaibHABpSwctaMaN6ef9AGkjCef6fxH10PZvEtWXFWVQg1nhPyzJ0YnE
        b5duD9EkDVT2gXAHLtnJz/e73anfYlCnDMylnUx+r4LNxhJ4PzmOeQHkWb/l9zc3
        iz5/sy5yaMUXqGPV1UyHgsLQH2Y6M7rknSBfpsgWKtli99eNaXULWmQ2G2gp94z1
        eLuqdUF+FcWUO7vLeaTL/G+RrLFti9qYV9fEWtoGPgE06aK4KdaZ0LSDQ1cdsxfx
        uddtO7r1289JuxdSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=cHzUZrMqkoXOYn28/jbP8mE5rbfh5
        W6/uFfsX5hJOwQ=; b=lmJQ6Wi77Iq5z1nAi5pIt94Ox1IMKE38H+Cc8bCmsPNRe
        dDCcPzJDc5+BnfvTIspRrH+7ftzg2sk9vSbzXhfPX3PWIhA8FWoyyZsOje5WgtgK
        towlbOR+jfwD3Fc1k288/B6RmE1s92CXn/VBp5kwHC0OGMX/QDra+Z8Kdwo7/tkQ
        bno+FapW0DpESDkW633Vt6O2VN1Bdqx3fmit1yHZZE80+8gIEVArcCWBJ4l0m/Ej
        ip4scJAEyMu7zhm1CJh+Dt33Qnwlyxdy9pL0fXjl8ivdRYfLFAxeEKZWZctmhwhS
        0YtWTUSV4q8erGtVnS7xBfJAuzQYuk1PDfBwyf+qw==
X-ME-Sender: <xms:WO8KYgpE_it44s25fZMHCgq8Eu87lQAFJIGmWM0qB09AMU9gggGfSw>
    <xme:WO8KYmoQktl9dVH9-xEMchcRLbvtvgCvvbf_Zm00yMbLSna0naCRBSuHBXuMcCZZW
    uNHNeWzuFX04SKeFgI>
X-ME-Received: <xmr:WO8KYlORCOPEqyE1QlQD0_3sCiCNqinUf3a3dnSM8vvh5a7UIlJU59X48Of9x-FWzfDiIVtKaJEcorH0WqQa88Q3io1T3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekuddute
    efkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:WO8KYn7enZThA0nz2sn7ILGYPQqwGAAPdwrDPyB_LdeiZHBcFQaaoA>
    <xmx:WO8KYv6ziLk5CvxTdMQ4KZikS_BIognfX9LBLifGM_diYyADV_I5qw>
    <xmx:WO8KYnhz-YOUizoZ0Uo4eO1cPoe88KCTTFFCr7DTGU6NLxhgt0f10w>
    <xmx:We8KYvEC61RHJTJ202Syn4NWs8H7fuBkoP2MWdDrBTfszUElUwjRdw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 19:10:00 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 0/4] tests for btrfs fsverity
Date:   Mon, 14 Feb 2022 16:09:54 -0800
Message-Id: <cover.1644883592.git.boris@bur.io>
X-Mailer: git-send-email 2.34.0
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


Boris Burkov (4):
  btrfs: test btrfs specific fsverity corruption
  generic/574: corrupt btrfs merkle tree data
  btrfs: test verity orphans with dmlogwrites
  generic: test fs-verity EFBIG scenarios

 common/btrfs          |   5 ++
 common/config         |   1 +
 common/verity         |  43 +++++++++++
 tests/btrfs/290       | 166 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 161 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |   1 +
 tests/generic/690     |  66 +++++++++++++++++
 tests/generic/690.out |   7 ++
 10 files changed, 477 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

-- 
2.34.0

