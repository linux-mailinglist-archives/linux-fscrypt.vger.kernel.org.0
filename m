Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501194DA51C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348597AbiCOWRQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350324AbiCOWRQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:17:16 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C518155BD1;
        Tue, 15 Mar 2022 15:16:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3544B5C01D4;
        Tue, 15 Mar 2022 18:16:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Mar 2022 18:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; bh=nGw39lKITVNbJVXF300GrE655o5NtvZipJ3oOHpY38o=; b=iW8dB
        gKH+ibXqMZUxJJgnQx/JfUf/KNDQjd5BHeuL6VnwLL/py06+CmcSOjZYmnEpVpUl
        NARm7B8kLwCBXQXlfiPxw9fVfu+xy6XRygJCvju7AlPW0ImquFGNVDptBd8TZzOf
        0MXUrttNrL33L/ZmZlxz1xGPnLS+ZE2dp+svyxTpWdoyU5QhawDo0fHsYkhJNdcN
        2KJ0iqLstiliQDky3sNU8otOzmWuotKX8LF3anlCYBFr7qowMneo3hk3viFQKr6j
        +0awG8k0XdqlIt47feFViTEU35Cb6V9o8BifpqQgpCTqWyB41W9oEgHJycATOnuw
        UMTJ4pMmvfhvOJGGA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:message-id:mime-version:reply-to:sender
        :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm3; bh=nGw39lKITVNbJVXF300GrE655o5Nt
        vZipJ3oOHpY38o=; b=VVjCeX4HoIOovOzgXx7W9FgziboDDZmqWAM6zOO6AnjA4
        FqzR/eJK9hVu2bZKqDHJq1Vp4sO/brMhXkelFEy8XNn+/v+CPCBbivYmcgeDvkHv
        scflc+oYdUnxgIt44NKgs/2bnkhbHifIAKQfzhMJYHWlFTesHIFQcPnSMMo2+7ey
        cMbNdsnc4SEvoxkrPj1vTQYLGE/qMIr4a+2rRmt57FgrY5ofUHusqS9kkUg5WrYs
        9MMBuM5BzsfGlZ8weCumTBgFMsz0Psqw5JbCia6MS0XzD14GJo4j8UnMU00Dt1RL
        JsgXWpYYdmOAeg7ffoQIqwzD7I1pnR3e/KJGufAzg==
X-ME-Sender: <xms:IxAxYsqGKHbAv7zc8_jSRbfmk6mHiSV2KBS7Dp4XKDhpWrLRNEk1-A>
    <xme:IxAxYir8iG6ZNAJlLZEF9ehkGwXiZK5jwwWz7yLSMnonYXlzGAsS55jqA5MA9IiS8
    hbnuQJw4rxvOU57ZzQ>
X-ME-Received: <xmr:IxAxYhNy-fyymQXlZA38uqROCN8D6paIIen02gI4HM8fGWnFEw_QPb7bVx7w1P2rbd4CLfZC2mxCqfBH5zfafKXF_Scmgw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:IxAxYj4QGrso1iCRtrdvDGzfsMTzQGQn1CY93heh7XE_FC4D4IwpjA>
    <xmx:IxAxYr5iHA5oNfw7yINC8JriWedD37QxbvZAm-78LihVy37yw_mrdA>
    <xmx:IxAxYjhb285GPiQaVJDydesrfmMEcvNWZJBXzoy4vQpCGhPdp4DSpQ>
    <xmx:IxAxYrHJPXcX9-rX425gCamWIeQnridHli9c-EElabnahBTpUhPDdg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:16:02 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 0/5] tests for btrfs fsverity
Date:   Tue, 15 Mar 2022 15:15:56 -0700
Message-Id: <cover.1647382272.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
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
  verity: require corruption functionality
  btrfs: test btrfs specific fsverity corruption
  generic/574: corrupt btrfs merkle tree data
  btrfs: test verity orphans with dmlogwrites
  generic: test fs-verity EFBIG scenarios

 common/btrfs          |   5 ++
 common/config         |   1 +
 common/verity         |  46 ++++++++++++
 tests/btrfs/290       | 168 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 161 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |   2 +
 tests/generic/576     |   1 +
 tests/generic/690     |  64 ++++++++++++++++
 tests/generic/690.out |   7 ++
 11 files changed, 482 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

-- 
2.31.0

