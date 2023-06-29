Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3821C74303C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 00:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjF2WRg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 18:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjF2WRe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 18:17:34 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43912707;
        Thu, 29 Jun 2023 15:17:32 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id AE32980702;
        Thu, 29 Jun 2023 18:17:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688077052; bh=tSjVvle2uSxcOZ/ckvaZRLq6Jdqi0bIN8G3EChW8wBU=;
        h=From:To:Cc:Subject:Date:From;
        b=sEJkDDgR2OCWn0nd0/afpZx/xb8Yo/cGdaIZHU7qg19lsZ+eiFuTpwZwo4rBH1m2h
         SCabloxgV2GaU6L23WzFX4/qcXSMsthivJGxwH1/aliL+1cNwLoEwcCFulbDegJYCF
         RLqWLWUTHcQFOYMPl03VTGkFxurdIGIRWW5/7uPej8iDzbcmj1s82n835TPnhrOokW
         Tfvzas9n11HjFapO3d8/NMPhCa5vUAakCeZ6hTeVlR/Tch1nIUWExIzsNYOYhqRo3m
         GWCudfjkEZBgtaTxXsRe8j0si5tn5UFrs36fpK6AzxzwH2e7aJXJJxJoD10hET4K5C
         p0Y2ifVObxE/Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 0/8] fstests: add btrfs encryption testing
Date:   Thu, 29 Jun 2023 18:17:15 -0400
Message-Id: <cover.1688076612.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a preliminary fstests side of the btrfs encryption feature;
more tests are needed, but this gets the existing encryption tests
working with btrfs. This requires the progs and the kernel changes: [1]
[2].

Marked as RFC because they're not ready to merge until all its
dependencies finish landing.

[1] https://lore.kernel.org/linux-btrfs/cover.1688068420.git.sweettea-kernel@dorminy.me/T/#t
[2] https://lore.kernel.org/linux-btrfs/cover.1687988380.git.sweettea-kernel@dorminy.me/T/#t

Sweet Tea Dorminy (8):
  common/encrypt: separate data and inode nonces
  common/encrypt: add btrfs to get_encryption_*nonce
  common/encrypt: add btrfs to get_ciphertext_filename
  common/encrypt: enable making a encrypted btrfs filesystem
  generic/613: write some actual data for btrfs
  tests: adjust encryption tests for extent encryption
  common/verity: explicitly don't allow btrfs encryption
  btrfs: add simple test of reflink of encrypted data

 common/encrypt      | 86 +++++++++++++++++++++++++++++++++++++++++----
 common/verity       |  4 +++
 tests/btrfs/613     | 62 ++++++++++++++++++++++++++++++++
 tests/btrfs/613.out | 13 +++++++
 tests/generic/429   |  6 ++++
 tests/generic/580   |  4 +++
 tests/generic/595   |  4 +++
 tests/generic/613   | 12 ++++---
 8 files changed, 180 insertions(+), 11 deletions(-)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out


base-commit: 87f90a2dae7a4adb7a0a314e27abae9aa1de78fb
-- 
2.40.1

