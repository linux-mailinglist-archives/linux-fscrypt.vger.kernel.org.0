Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8B65971B6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbiHQOp7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbiHQOp4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:45:56 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611379C2E7;
        Wed, 17 Aug 2022 07:45:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id AAEB380F11;
        Wed, 17 Aug 2022 10:45:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747555; bh=OVMZ8Ghp5oBNQxExAAISYyP2wel7pxjvEINJFQYDcNw=;
        h=From:To:Cc:Subject:Date:From;
        b=kr8YJ5TdLPDK9s/ZZB2AhYxl7jlxELoCsgFw1zloj6izU/yb8TQpk1m36mt1XFPsW
         q2Bdj4ZaQLNxFBOz++tbFujQKwsvaEdQcesdxTm68rV03jNy9wcxKj9LTbjPGpkuaK
         mjv+PB4MDCWM9boVux2JLThpZ5Mvyr38nCDGdOviXIUFIc5boWuI8VF7+pPNEMn6e/
         hi8cEoQG9Q1vU5w4KHNycWeSDOexSuDwhVW4HNEIGixTnCSaqISDg403vBwv5Hx48I
         n7FNsXsoNwVZlAWsboeDU8C1dvGKz4n+M2RwnJk7zH4K/IU+eYexqNQVreJYmQJInP
         PY4BPH6GyiYLw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 0/2] fstests: add btrfs encryption support
Date:   Wed, 17 Aug 2022 10:45:44 -0400
Message-Id: <cover.1660729861.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This changeset is in combination with a kernel changeset implementing
btrfs encryption, and a btrfs-progs changeset 

btrfs has several differences from other filesystems currently
integrated with fscrypt. It stores IVs on a per-file-extent basis,
rather than per-inode, using a new v2 policy to do so; and requires the
use of a v2 policy and its IV_FROM_FS policy flag. The design document
can be found at [1].

As such, this adjusts many tests to explicitly require v1 policies if
they require it, and generalizes the key handling for tests which can
work fine with v2. It duplicates two generic tests which can't easily be
generalized to work with btrfs, and adds all necessary function
invocations to implement the ciphertext-checking functions.

There are definitely additional areas which deserve testing. There are
some tests which ought be split into v1-specific and v2-specific tests
so that btrfs can work on the v2 part. A key feature for btrfs is
subvolume encryption, and tests for that should be added.
 
Necessary btrfs-progs changes are available at [2]; kernel changes
are available at [3]. Additional tests around subvolume-level encryption
will be added in the next version. 

[1]
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/
[2] https://lore.kernel.org/linux-btrfs/cover.1660729916.git.sweettea-kernel@dorminy.me
[3] https://lore.kernel.org/linux-btrfs/cover.1660744500.git.sweettea-kernel@dorminy.me

Sweet Tea Dorminy (2):
  fstests: fscrypt: enable btrfs testing.
  fstests: fscrypt: update tests of encryption contents for btrfs

 common/encrypt           | 184 +++++++++++++++++++++++++++++++++++++--
 common/verity            |   2 +-
 src/fscrypt-crypt-util.c |  34 +++++++-
 tests/btrfs/298          |  85 ++++++++++++++++++
 tests/btrfs/298.out      |  34 ++++++++
 tests/btrfs/299          |  68 +++++++++++++++
 tests/btrfs/299.out      |   4 +
 tests/generic/395        |   2 +-
 tests/generic/397        |   8 +-
 tests/generic/398        |  12 +--
 tests/generic/399        |   7 +-
 tests/generic/419        |   7 +-
 tests/generic/421        |   7 +-
 tests/generic/429        |   2 +-
 tests/generic/435        |   2 +-
 tests/generic/440        |   2 +-
 tests/generic/576        |   8 +-
 tests/generic/580        |   1 +
 tests/generic/581        |   1 +
 tests/generic/593        |   1 +
 tests/generic/613        |   1 +
 21 files changed, 439 insertions(+), 33 deletions(-)
 create mode 100755 tests/btrfs/298
 create mode 100644 tests/btrfs/298.out
 create mode 100755 tests/btrfs/299
 create mode 100644 tests/btrfs/299.out

-- 
2.35.1

