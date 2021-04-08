Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4677F358C91
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhDHSa7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:30:59 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:46583 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233015AbhDHSaa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:30:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id C47E810F3;
        Thu,  8 Apr 2021 14:30:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=/AGxmyijSMKMc3ZC0YGPRqUjTA
        bRczItbVqbeNOa+Z0=; b=ST9bxUNnDqlV/RGpdNsyh6vWedAVDo75aFEUzxs5Oc
        HJG2WIk5K2NBk9QNwczLkQS6czzpYof3jY0NYvwzLeYLHmMG4zKqqjv0KrPPrpp/
        BINPQYnoSlBruV7raHDEE62gkThl6rCs42e1oI7O3lRemZmP3dXqo+yurS+xpN2K
        UIR51TONdqsM/1xJofDG4rzwDNos+HBwxmalpi0MB2OiZkWnuxd/rwJmXb0CNh/P
        rd1n8Vpd00IDVOiBL1lkV6+5e7fnSzutzAUOBxNCZ8Ln2WieXkFTAdoRmaSQt26K
        Pgkw8mNY4AfMdG29VfCXjFL8TLM8Bkta+Tim1B9RPqtw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/AGxmyijSMKMc3ZC0
        YGPRqUjTAbRczItbVqbeNOa+Z0=; b=o7FAPhAh6uiXdXWMXVXy+bWOT6K/yHda+
        FPKDOY6DYJBoCKXvZVBfN3hj3088nCFviE0eAGEOYT9kTuTROLBxn6BWj/CeWIC3
        W3zuugYm3akzWpvwtwpBUNMD8G+2aZdtCLDOHdgOIXfwZOlDjOseGGDDo+rqeVmd
        xej2smNjIVLYCCy1Hnfc/6bzzL1/Tw9gvJmuRA/1H8i0xaeVJwwc0q9VAy74zWQa
        jjJwJfoKz9gHWZqo9lVjufEUf4L3HotYRtTkCL8DQ6zrLcOYWCx1+gFRKa/jBktl
        zSqnTW437HK36Hj6MUiFiQhsnFgobPIYZjNkkhfX3b8x+RAGGOdQA==
X-ME-Sender: <xms:t0tvYIKcIOtN4nbyTnwVh1jYgl9VdqdIKZVK-RqjQA3pq1uWBv19Tg>
    <xme:t0tvYIHwzNXNTdfhy1-cP1nd9gWIm7qG9yKb_MTqNbnzzQWcd8YDIYtrF1ZzeDjna
    yLsQ6OAA4cHQuGx6zU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepudeitdelueeijeefleffveelieefgfejjeeigeekud
    duteefkefffeethfdvjeevnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrd
    hioh
X-ME-Proxy: <xmx:t0tvYFlCZ15BRd8O7r02Ck1tUhDpj_WdamLiBU7U2Xt7yep0QztTnQ>
    <xmx:t0tvYNIiShHmHubduSyN_2oE8OZehmY8y29sXjvxPTX_SWcdotpAsw>
    <xmx:t0tvYOaIcDybbslVMin-dqp-vB9mkPy74clrpfpdpqkGpe2y9ZFRcg>
    <xmx:t0tvYM0cMUQWfpZemzB3-DHSVFOSiTMSpgAZGM3mMxqjc3K0xUKheQ>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 12B6D1080054;
        Thu,  8 Apr 2021 14:30:15 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v2 0/3] tests for btrfs fsverity
Date:   Thu,  8 Apr 2021 11:30:10 -0700
Message-Id: <cover.1617906318.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset provides tests for fsverity support in btrfs.

It includes modifications for generic tests to pass with btrfs as well
as new btrfs specific tests.

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

