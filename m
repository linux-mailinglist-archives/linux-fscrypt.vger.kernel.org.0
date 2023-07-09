Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32CB74C7BD
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGITLS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 15:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGITLR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 15:11:17 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03512106;
        Sun,  9 Jul 2023 12:11:14 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9EF3780380;
        Sun,  9 Jul 2023 15:11:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688929874; bh=fB7FS2bicAzPtOhig8q3nYVJLH7SXzzwI3tUEHwhzvw=;
        h=From:To:Cc:Subject:Date:From;
        b=iLbhz/URnz11WNPlNG/k6udVgAJBXitqQFzub+OGBYzmLiH0tbg8xD1in9GSqxCUd
         V5e+RgOR3DCsioAMIY4js0pztMOsk1nUio1DOweUwLbMxa1lH6iygiYIotquep00dq
         DJyPelewJfRlYLSsX3d9yIE+WtGh8kESHd+1V4GTsEPejVL5ZcImo/Ql62NiM7dDT5
         Ayu2Dhes/CdAxymvVLZ4w91CW3W+dtDzvV51+13YQ0XJLEMM74F5FOHyKqFvncXasU
         YEmLne+sJYtBpcmeLiyS5gV1L46qDqaMZlly7+4BY9ttsMmovyyeFX/LQUR+T4NRL0
         g+paAYqWGENyQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v2 0/8] fstests: add btrfs encryption testing
Date:   Sun,  9 Jul 2023 15:11:03 -0400
Message-Id: <cover.1688929294.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a preliminary fstests side of the btrfs encryption feature;
more tests are needed, but this gets the existing encryption tests
working with btrfs. This requires the latest related progs and kernel
changesets.

Marked as RFC because they're not ready to merge until all its
dependencies finish landing; this is primarily to demonstrate that
extent encryption, between fscrypt and btrfs, does not significantly
change user-visible behavior.

Changelog:

RFC v2:
- Reverted changes to generic/580 and generic/595 to match the new
  'soft-delete' behavior introduced in v2 of kernel patchset
  "fscrypt: add extent encryption". (change 6)
- Removed extraneous syncs/drop_caches and added copyright to new test
  (change 8), as per Filipe's comments.

RFC v1:
- https://lore.kernel.org/linux-btrfs/cover.1688076612.git.sweettea-kernel@dorminy.me/T/#t

Sweet Tea Dorminy (8):
  common/encrypt: separate data and inode nonces
  common/encrypt: add btrfs to get_encryption_*nonce
  common/encrypt: add btrfs to get_ciphertext_filename
  common/encrypt: enable making a encrypted btrfs filesystem
  generic/613: write some actual data for btrfs
  tests: adjust generic/429 for extent encryption
  common/verity: explicitly don't allow btrfs encryption
  btrfs: add simple test of reflink of encrypted data

 common/encrypt      | 86 +++++++++++++++++++++++++++++++++++++++++----
 common/verity       |  4 +++
 tests/btrfs/613     | 59 +++++++++++++++++++++++++++++++
 tests/btrfs/613.out | 13 +++++++
 tests/generic/429   |  6 ++++
 tests/generic/613   | 12 ++++---
 6 files changed, 169 insertions(+), 11 deletions(-)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out


base-commit: 87f90a2dae7a4adb7a0a314e27abae9aa1de78fb
-- 
2.40.1

