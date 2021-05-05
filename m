Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62C03749D1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 May 2021 23:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhEEVFq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 5 May 2021 17:05:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57169 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230329AbhEEVFp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 5 May 2021 17:05:45 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F2845C019C;
        Wed,  5 May 2021 17:04:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 05 May 2021 17:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=oZwoOYJ6HhhmjoAzzBVmVJn1zc
        uOjbIqKjzEPnYpN28=; b=OqQh+oSXcXPq6xvyqxLWsxLBHxpFKt56+L0fbAu/9A
        D666m8HW1tUx7ya1zluUpSASLCqN51PgInxuAOAeL6cstkzhQ3jVorDizj2h8d42
        xVoa4Ad2xEclBBq9p0TmRqDyWUKTOIOpcMJVyg4n23YAcki0EfQ4z+yvaCNS7iYk
        IbBJDabkJpP/DUK2MStgOhYmd5aUTfBdWSatgtrPw5WWj0MMa6kgbxadephXE+uu
        v2MSQa2dABlhhGM39dC+UQTJSpFxiWwIAJiV0Pgb3ctKByh7MNE+w43BkhDeLAP7
        8X6IJH/ydRWzI4CnZadPtYN0f5v8/76yXHgRPCOCbA4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oZwoOYJ6HhhmjoAzz
        BVmVJn1zcuOjbIqKjzEPnYpN28=; b=YNCdjble6fcsV9iUWjI4S4Fwgd8hpqvMs
        FL/NYP0fLNbIIAi/2/Ui5yDtZn+kDL3u0BqFwjfydWMXm7lTciaBAoL0NKonBEUt
        E062WLaw4XyzupEIBzSoK/ggGLyfyxoU11SQP+VG6PzFsM1DDNMIILXlLnsrn81k
        4EAc0YbQJIjPFVoxGdl1umWHhc2ixxPSvXzh/pepH6zQYwyqZwMXheR2qCah4fuu
        q7TX7+z/1U2WqTxMM5XQUs5r3vhYHNTr1ZpMu22sNjmxQlugHtW7Xg2PCQxoGrmZ
        Rsu45HWvlkyjzTv92V9i/wI0o9fn0LylEDO7uDeJzeSRd0OayX87g==
X-ME-Sender: <xms:bwiTYNa5M8VKEA1dYxVoDXr0YxJsRNV2pxxQIidvpD--_mk7nJ_SRg>
    <xme:bwiTYEaAOp1bin_pcaNGgiALlFMF0zt9i_NvMnpJMUEvloVRpMM1BSqHTe2EfFfyC
    PgNqCf-Td6HiA0Xm84>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefkedgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hioh
X-ME-Proxy: <xmx:bwiTYP_ZD234_DLGZvdDLN6xGSbXuGZLeSlSsPI9vUeqIRzMDvW2Nw>
    <xmx:bwiTYLpXkgvLyUbgInkAwcGNHVD1DsPvAcBojzcqcK1nI0lRqFg0YQ>
    <xmx:bwiTYIo63M-LBqzQ86mVsE0FJHCuN-FLm53PsBK6rzLTuteVkdVGpQ>
    <xmx:cAiTYFDgkrF4m_p3kQ2FCMGp1pgNZ1fi9e0y_1kthqC10o79Rs24EA>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 17:04:47 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 0/4] tests for btrfs fsverity
Date:   Wed,  5 May 2021 14:04:42 -0700
Message-Id: <cover.1620248200.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new tests.

--
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
 common/verity         |  25 ++++++
 tests/btrfs/290       | 180 ++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out   |  25 ++++++
 tests/btrfs/291       | 157 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out   |   2 +
 tests/btrfs/group     |   2 +
 tests/generic/574     |   5 ++
 tests/generic/632     |  86 ++++++++++++++++++++
 tests/generic/632.out |   7 ++
 tests/generic/group   |   1 +
 12 files changed, 496 insertions(+)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out
 create mode 100755 tests/generic/632
 create mode 100644 tests/generic/632.out

-- 
2.30.2

