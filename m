Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFA77442E
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235525AbjHHSQK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbjHHSPs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:48 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794D31F401;
        Tue,  8 Aug 2023 10:22:08 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C48E280281;
        Tue,  8 Aug 2023 13:22:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515328; bh=olh/IabzO6GOzB5svMvsvjY1MrZsZZeekcwwHyDB70k=;
        h=From:To:Cc:Subject:Date:From;
        b=BSltcF9jF2SvLKHRet0WJH2GHukmTiqhy5mEkq151kEgjxjwxFo2phn4M6IVKGsul
         npniGxv1PfIN9OXOMmLOtsdk2k3Pr09z3qA/y286BtOzOBGym9WYVFbaWuDmFV7K4d
         wkbjsoaFjUtLxqsLs9xk6NSJ3lPpT5AFLCPRx5HpwhpNridgxUa2MANZ5oXmfABnAg
         sooT5v4nzQ8Z654XeLkqoAIK7YxpjEF5hIlfT/V1iNJb4LXNjfuVs9GeLLW1NWWyQL
         QWK2PKriTrI2/DsmuWlsmvII7Axe15JvsMuV1tgQ0LhhJbf4nwI6OtWQs7K7XCobMm
         tBnh+V7ySvKfg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 0/9] fstests: add btrfs encryption testing
Date:   Tue,  8 Aug 2023 13:21:19 -0400
Message-ID: <cover.1691530000.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a preliminary fstests side of the btrfs encryption feature. This
requires the latest related progs and kernel changesets.

Marked as RFC because they're not ready to merge until all its
dependencies finish landing; this is primarily to demonstrate that
extent encryption, between fscrypt and btrfs, does not significantly
change user-visible behavior.

Changelog:

RFC v3:
- add test of snapshotting encrypted subvol
- updated f2fs/002 to match edits to common/encrypt, thanks Anand.

RFC v2:
- https://lore.kernel.org/linux-btrfs/cover.1688929294.git.sweettea-kernel@dorminy.me/
- Reverted changes to generic/580 and generic/595 to match the new
  'soft-delete' behavior introduced in v2 of kernel patchset
  "fscrypt: add extent encryption". (change 6)
- Removed extraneous syncs/drop_caches and added copyright to new test
  (change 8), as per Filipe's comments.

RFC v1:
- https://lore.kernel.org/linux-btrfs/cover.1688076612.git.sweettea-kernel@dorminy.me/T/#t

Sweet Tea Dorminy (9):
  common/encrypt: separate data and inode nonces
  common/encrypt: add btrfs to get_encryption_*nonce
  common/encrypt: add btrfs to get_ciphertext_filename
  common/encrypt: enable making a encrypted btrfs filesystem
  generic/613: write some actual data for btrfs
  tests: adjust generic/429 for extent encryption
  common/verity: explicitly don't allow btrfs encryption
  btrfs: add simple test of reflink of encrypted data
  btrfs: test snapshotting encrypted subvol

 common/encrypt      |  86 +++++++++++++++++++++++++++++++---
 common/verity       |   4 ++
 tests/btrfs/613     |  59 +++++++++++++++++++++++
 tests/btrfs/613.out |  13 ++++++
 tests/btrfs/614     |  76 ++++++++++++++++++++++++++++++
 tests/btrfs/614.out | 111 ++++++++++++++++++++++++++++++++++++++++++++
 tests/f2fs/002      |   2 +-
 tests/generic/429   |   6 +++
 tests/generic/613   |  12 +++--
 9 files changed, 357 insertions(+), 12 deletions(-)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out
 create mode 100755 tests/btrfs/614
 create mode 100644 tests/btrfs/614.out


base-commit: 8de535c53887bb49adae74a1b2e83e77d7e8457d
-- 
2.41.0

