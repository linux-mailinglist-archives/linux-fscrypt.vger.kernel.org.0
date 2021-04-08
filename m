Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8817F358D11
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhDHS6F (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:58:05 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:54519 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232950AbhDHS6F (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:58:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 0659510FF;
        Thu,  8 Apr 2021 14:57:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=/kjrdFM5FpWu6xNyLaBfr8uSpj
        fmM0IKFSF81BLK1u4=; b=iNOjNcnN+KUFESEHucmXelY1seTu2Vzb2zA8y6jSSc
        IeSxX3GhUNsJ2uS14q5yfz2VYnU1S1yGHOQnROqAUD5mDx7FQI+Q5ehRRTqiiV+8
        P3OJUbICutjqYiKXXE8gIcH9ROPB8Y1KGlCD5KktS+6Fax0nGgkldjb4MuMPxNL5
        i/fPNNNjhTE7AR2V57IM3EiCJuVHvaeiKg64e2zy64u4cinvJDySGnzxh/OmegnJ
        /mlmeblzCQD9k872YvijMcQA5hKwXlJj7+0w4Ik7P4e0b+6rlH6fLb8x9TWZJlSm
        QmIa/ixkL07h+XOYk1nwfnV/M26cOjOvMUG/eQSZtt7g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/kjrdFM5FpWu6xNyL
        aBfr8uSpjfmM0IKFSF81BLK1u4=; b=QlJnoiq2jNeFc5AAd0rVZh3y9pVrNp2TE
        tlFxhPaR+y5twpTaX6UcWZOczFaadsbI6BkMkxAl4Xg4dbO5TNiHsVQuFBMLLtio
        fvQISzUPn7QlZ/430R3QDdYmKZ3NDLgIFZ8CAxhRxBCuiWEZFhkl9/ziL2TrdOfx
        8ZvCvT1Q3vPZDVOV4C2a2x7ibsUSFYJxKTGGdD7WACphJdvDvoUxBjXi204iXOBb
        bdgcvom2yjjNO8DjrpGbCm44EWL3wpWn4mrITkISaFjn7uGfa8FMXLnzmpWswswu
        uqZIM31J4sfKKVMz+Y3VR1MZPyTvWzK70bPd/fgM9j1lxIiI8F/Lg==
X-ME-Sender: <xms:MFJvYPrVUgF5blLa9xH0cPCdnsrdZjY4NDywSSozeW4BYGobpt5PeA>
    <xme:MFJvYJrT8VIVdlhbi6dm7SJfAzcmEGJ9_84Rrsoyk1HFrLBOpZzwHIMN5cIYeU2tK
    oDEqWPg9X0SHH58xpQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hioh
X-ME-Proxy: <xmx:MFJvYMPMaypihTCNkPwuYrhM_AQKn_mphuv3qIQ-2XxDnCezSWumkg>
    <xmx:MFJvYC7NhAzcaOTmmcQe7Mdtc2-pUTZNqpflVaGufSlfAJbj5Uk2fw>
    <xmx:MFJvYO50jusCHvb2xQCdaOxRJhus2xOQxJiKUT4SCABJc3KeSeAhvQ>
    <xmx:MFJvYEQQi229KqNg3jugMGF6lsL-MpxrusHoKmbXQoN_0_30OXpdgw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D622240057;
        Thu,  8 Apr 2021 14:57:52 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 0/3] tests for btrfs fsverity
Date:   Thu,  8 Apr 2021 11:57:48 -0700
Message-Id: <cover.1617908086.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new btrfs specific tests.

--
v3: rebase onto xfstests master branch
v2: pass generic tests, add logwrites test

Boris Burkov (3):
  btrfs: test btrfs specific fsverity corruption
  generic/574: corrupt btrfs merkle tree data
  btrfs: test verity orphans with dmlogwrites

 common/config       |   1 +
 common/verity       |  22 ++++-
 tests/btrfs/290     | 190 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/290.out |  17 ++++
 tests/btrfs/291     | 156 ++++++++++++++++++++++++++++++++++++
 tests/btrfs/291.out |   2 +
 tests/btrfs/group   |   2 +
 7 files changed, 388 insertions(+), 2 deletions(-)
 create mode 100755 tests/btrfs/290
 create mode 100644 tests/btrfs/290.out
 create mode 100755 tests/btrfs/291
 create mode 100644 tests/btrfs/291.out

-- 
2.30.2

