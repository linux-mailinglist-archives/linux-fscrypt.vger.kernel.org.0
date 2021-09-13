Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6DF409C74
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 20:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239677AbhIMSp5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:45:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43195 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236631AbhIMSp4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:45:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2906C5C011C;
        Mon, 13 Sep 2021 14:44:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 Sep 2021 14:44:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=qt1xY/gUXmKuBr01z7pM8I1adc
        Ed2o5wUKfVco5Dm/g=; b=r3Emd3gvqZ4ncvD88IjusdrPzMc1GXBqqc5hvsyXa4
        cSHQvHF25DUdckhZMIp+rqULnN+qW3iwMx7A2E0wUTDEyYBR13Z9ObOeBm3y1CUk
        gR7ylzpYaw+8TvCdcbsKkqpBfxnM7xY3jlG3CE5Bm2k4PspEpvsiwPxBuxkOJQHl
        TKNdhx9Xszh75xm4YqfZ5oziol1ts/QGVy6R8/NxSPC/1j4APY2j05Ye8UDzfbn6
        QDI9mGl6CTHa+gP7ffbRbArLvkChY1BqZVW0GzS2MITxrJ174lOuKxbJRFyCQjKv
        MMYQPWM9Ssx0aXpWwpor+bgIj0esZ1SD8e/tbryS92ng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=qt1xY/gUXmKuBr01z
        7pM8I1adcEd2o5wUKfVco5Dm/g=; b=aX35WSxz1RU5eYcoqrIJJ0Mt5Ifr85wmQ
        Lw3RWcO5hsLDfWL5HOcZr7Jw1FUBtH/J14rN/cN3KpsENbgwlu3dsPi7SMggFgT8
        HCRsEs7TDsjhzDBZy6zKq8M0Z5FOp4dfuZ75jASFd6gjMXCS3RGp6ypnfq2263Lx
        nw0bwaISMHO7KcgLwvO3skceOzHlT11gN0balrq0qhmqNuixFpK2Hx5SvoQuY1Sl
        d6ZTSJuEU2WMXkTy7AVZnQtruU1cqmto7Fgtjjn4Q1hXpI1EAyrBZz77RuJ+JUdL
        nuHoQnRqZKGkxMpJIwMfvWSmFR0A3Ui7LRdDLbrInbAE3NjYn5kjQ==
X-ME-Sender: <xms:F5w_YTlMT0S5kX_uHC9aqaJIchZ8cEMM1zLFyN6x132EH7xlOVhK5Q>
    <xme:F5w_YW3GwE5hOY7imhf5oeYmhuS2MmwPEt4u5OJHEYiGzRtsiZvJIv-hb1bBxGgPL
    b9LT2acovqKTRkqiZA>
X-ME-Received: <xmr:F5w_YZrCNiTT-UxwgP8oMuiPJCvWnBic-yL9R_RGAlRWSNt3XvUYyXSMMdLuGNNOSP-I2SyLz8C9oRwB4pcKWqCVstLlKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:F5w_YbmjAtXtSM058EoRfFUw9ghAQmccCZhB9eciypAiTTS9YuXbVA>
    <xmx:F5w_YR2wB6r2FZTqV66Rx9e0UhDpBCz-yHz7JAJ6wNXmFzIkNXPgqQ>
    <xmx:F5w_YaumIk9yFdLuHbdIXJ394UGZ1DDVX75oBVh1c63kzQsh8DUqjA>
    <xmx:GJw_YfDDW-V1CNoW0VWBNvABgFeYK-yvAhEyetYkxgft0iURJaTrdA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 14:44:39 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 0/4] tests for btrfs fsverity
Date:   Mon, 13 Sep 2021 11:44:33 -0700
Message-Id: <cover.1631558495.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
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
 common/verity         |  38 ++++++++++
 tests/btrfs/290       | 165 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 +++++++
 tests/btrfs/291       | 161 +++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/generic/690     |  86 ++++++++++++++++++++++
 tests/generic/690.out |   7 ++
 9 files changed, 490 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/690
 create mode 100644 tests/generic/690.out

-- 
2.33.0

