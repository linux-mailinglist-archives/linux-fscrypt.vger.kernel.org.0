Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592725ADC62
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiIFAbp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIFAbp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:31:45 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0AB69F79;
        Mon,  5 Sep 2022 17:31:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id EC89F81050;
        Mon,  5 Sep 2022 20:31:42 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424303; bh=PQ7xVGYp2G0aUuTMXtzKlfYPzMNApowKtpyS/kBSoIk=;
        h=From:To:Cc:Subject:Date:From;
        b=RDJr2NvCXGbwog2ksQTcu7ov8CHpPibU4P2bWzMrhToL3Uu9/1cJT2aoUsUwXercj
         2J2hhz/za8itVZHa90IJRWhzxjvUsdl1S/KOMps5AYQUTomfYZMzx+GGNiC3mq9J/m
         wWRvEJUSg4pdumVlMHf+9T2Vxp7tH2OMix/CxeOTEPP85kzVwJ6WNzsHTxc9IvLDOS
         04lxfA+HBwImqIZVZJv1fFxOqc6sewKN4RRRzXWaJ+Tl9ctbYeD5OVWi2weYGALzXe
         JLWCee5Q0bFRI3jxTHeZ6uGegM8dmoYguMEgxMdys0SDHjC000K2IfHcsC0WzJU2OF
         ehR/rioNSwnRw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 0/2] fstests: add btrfs encryption support
Date:   Mon,  5 Sep 2022 20:31:36 -0400
Message-Id: <cover.1662417905.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs has several differences from other filesystems currently
integrated with fscrypt. It uses a newly proposed extent context object;
only works with direct key policies; and allows partially encrypted
directories. The design document can be found at [1].

As such, this splits a couple of tests and filters encryption policy
printing to account for different filesystems' different default
policies.

Tests for subvolume encryption, a key feature for btrfs, are not yet complete.
 
Necessary btrfs-progs changes are available at [2]; kernel changes
are available at [3]. 

[1]
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/
[2] https://lore.kernel.org/linux-btrfs/cover.1662420176.git.sweettea-kernel@dorminy.me
[3] https://lore.kernel.org/linux-btrfs/cover.1662417859.git.sweettea-kernel@dorminy.me

Changelog:

v2:
 - Mostly rewrote and simplified the changes, as btrfs no longer requires
   a separate new encryption policy.
 - Added a filter function to account for different default encryption
   policies.
 - Split Adiantum tests, as only the direct-key variant works with
   btrfs.
 - https://lore.kernel.org/linux-btrfs/cover.1662417905.git.sweettea-kernel@dorminy.me

v1: 
 - https://lore.kernel.org/linux-btrfs/cover.1660729861.git.sweettea-kernel@dorminy.me

Sweet Tea Dorminy (2):
  fstests: fscrypt: enable btrfs testing.
  fstests: fscrypt: update tests of encryption contents for btrfs

 common/encrypt           | 141 +++++++++++++++++++++++++++++++++++++--
 common/verity            |   2 +-
 src/fscrypt-crypt-util.c |  18 ++++-
 tests/btrfs/298          |  85 +++++++++++++++++++++++
 tests/btrfs/298.out      |  47 +++++++++++++
 tests/generic/395        |  10 ++-
 tests/generic/395.out    |  18 ++---
 tests/generic/435        |  10 ++-
 tests/generic/550        |   2 -
 tests/generic/550.out    |   5 --
 tests/generic/576        |   3 +-
 tests/generic/576.out    |   6 +-
 tests/generic/580        |   5 +-
 tests/generic/580.out    |  18 ++---
 tests/generic/581        |   4 +-
 tests/generic/581.out    |  12 ++--
 tests/generic/584        |   2 -
 tests/generic/584.out    |   5 --
 tests/generic/720        |  26 ++++++++
 tests/generic/720.out    |   6 ++
 tests/generic/721        |  26 ++++++++
 tests/generic/721.out    |   6 ++
 22 files changed, 398 insertions(+), 59 deletions(-)
 create mode 100755 tests/btrfs/298
 create mode 100644 tests/btrfs/298.out
 create mode 100755 tests/generic/720
 create mode 100644 tests/generic/720.out
 create mode 100755 tests/generic/721
 create mode 100644 tests/generic/721.out

-- 
2.35.1

