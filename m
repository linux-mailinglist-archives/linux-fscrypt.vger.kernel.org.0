Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BEA57681A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jul 2022 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiGOUcD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jul 2022 16:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiGOUcC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jul 2022 16:32:02 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6115B04F;
        Fri, 15 Jul 2022 13:31:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7681C5C00CC;
        Fri, 15 Jul 2022 16:31:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 15 Jul 2022 16:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1657917114; x=1658003514; bh=TM2gJiO+BOwaovUnwnzH0G1Z7
        YMxp0m2bwFNikC8+Xc=; b=YUMMtaXjzWu5Jf584HvKsN7l35QHrn5fWuobi3AtW
        7WwNoRCxEOub8vM6/nrnqYVjkskAkuUyNMrtWBW64RNFXfGDerKeK3LwYTNHrQjU
        DPU8EAJCDZ+n+RVXByz5COP8/ZdCEOySx/W77vdsA/kJumKSW6IfdoCyKqe1rtl2
        U5sRpxvL1y9VLpngNHOqnI5mOM+jfm8cvWIXOAxwy4zNQNDtdfzvjFum6JmGOf8r
        bz16ZaIdS0uj/MBGvi0xrRfhgvXaHURO6t+wweJRyLD3DFG/vzFhXPmhmKnwkSHF
        5Uh0JWdaejV4W3TylJNyu69NeitXyxRwkximhILJXxMAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1657917114; x=1658003514; bh=TM2gJiO+BOwaovUnwnzH0G1Z7YMxp0m2bwF
        NikC8+Xc=; b=KukZ7wGuBi3hkN1u4sVVr0IbKfqVBmBG0tzEdZMsMaYdCDVSgkQ
        OregSIJgEszeL5aRIAhQBrO35dRaLcD55y9sd2/7ZJElx42SCYnhFcWSQQG4K3Oy
        sGGjUzQRT7yqJkw99agdwae4iuWM7q3WqXtxsQzDlO9FNFKihjvJPRRSVCIIvvKI
        3cE2nzHDolWhEXJUfe+kv9aO5hMCjT3+XFQPvhAyXRo8IpqfVvcvCJn9w1PDMcc/
        +2+AGSHU1FsKPfRQ4qlMalvWHDz7SGa6yckW9duggYWa6qM2nvuQL3+//uXxa6gg
        7KhlMCojZARks4aOhWnEwJfqtBanc4/wehg==
X-ME-Sender: <xms:us7RYiv177ou7E62uGJ4JgRlrZgZ5GIYNEVJLwXVgcaV5Ty3386mZA>
    <xme:us7RYnchCsTh2hWUpyy5CDnpsIOlic63vH6VP1zD0OMuqanEp8xpLCNUiGRIGSKP2
    6qSO6apYpbeM1JKLwM>
X-ME-Received: <xmr:us7RYtyBdZU3yRXoHj2x2EeXPAd5ezXQ9DP_JD3j3DZM5BOvpvGhDxRnIOVDjHQe5xBvaerSVgaFQdOWwrNEGgINhGHonw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekuddgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepud
    duhfevvddugffggefgkeeggfdvieejgfegkedvudetkeehhfdvffeugeevfedunecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:us7RYtNeZ_kR6C3pgzIKtWtzp8EUckWqds8qzRS7Vxe5E0akWedRZQ>
    <xmx:us7RYi-2_LAkzQvB2HL012_XjRZ7sYwdqvNeV680LXHq_20Mvrtgjw>
    <xmx:us7RYlVogp3-MLYjliyUjN8S_RTYaifUMoo7FNRagJBsBygV1e4OvA>
    <xmx:us7RYmYKI3W8KKMHkY74ZSWJBwlQsYRtwVbS_CYBYbOdCpxFSIZsXQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Jul 2022 16:31:53 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: [PATCH v10 0/5] tests for btrfs fsverity
Date:   Fri, 15 Jul 2022 13:31:47 -0700
Message-Id: <cover.1657916662.git.boris@bur.io>
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
  Also, explicitly require xfs_io fiemap for all corruption tests.
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
 common/verity         |  49 ++++++++++++
 tests/btrfs/290       | 168 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 162 ++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/574     |  38 +++++++++-
 tests/generic/574.out |  13 +---
 tests/generic/576     |   1 +
 tests/generic/692     |  64 ++++++++++++++++
 tests/generic/692.out |   7 ++
 12 files changed, 523 insertions(+), 12 deletions(-)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100644 tests/generic/692
 create mode 100644 tests/generic/692.out

-- 
2.35.1

