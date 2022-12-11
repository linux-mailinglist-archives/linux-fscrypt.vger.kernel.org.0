Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E512E649304
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbiLKHH7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiLKHHy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8EABE30;
        Sat, 10 Dec 2022 23:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 464B1B80954;
        Sun, 11 Dec 2022 07:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9B8C433EF;
        Sun, 11 Dec 2022 07:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742464;
        bh=0PlfufLRdt0TiFkVc3hJh+Gbl/yW5nD7nXQiauHI8Hw=;
        h=From:To:Cc:Subject:Date:From;
        b=OZwYvK9/618gEChCFsudGCykW9DS9tQklTfiJcGAwnNZncdMO5iyoNSv28XNmKQ1w
         mHwYiVy0nkyPqisbOHIi4vGeg7vpsKJtJJsFCu1jPG7Ddc7tbjtADLpZOjuOAyqK2J
         E2OzTp3kOb8DtLSEUW+JVaQfwPkx48Pfem9B48L65YBjWgCZyP11gnLbmFacMwqLWT
         YpdEYbdo6H/2/uyuEtyWOcTcP5Z6RBdGbnM7Oq3fZFW3o0gDfaHwbTB203DqMKalHW
         ekLfMjANgWIvReoVKETBPIHh4TB2kmpL6OcDC0C/OxRaOEegk6r554FC0k7DuuvRzc
         NHJnbe38Qcmfw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 00/10] xfstests: update verity tests for non-4K block and page size
Date:   Sat, 10 Dec 2022 23:06:53 -0800
Message-Id: <20221211070704.341481-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series updates the verity xfstests to eliminate implicit
assumptions that 'merkle_tree_block_size == fs_block_size == page_size
== 4096', and to provide some test coverage for cases where
merkle_tree_block_size differs from fs_block_size and/or page_size.  It
doesn't add any new test scripts, but it does update some of the
existing test scripts to test multiple block sizes.

This goes along with my kernel patch series
"fsverity: support for non-4K pages"
(https://lore.kernel.org/linux-fsdevel/20221028224539.171818-1-ebiggers@kernel.org/T/#u).
However, it's not necessary to wait for that kernel patch series to be
applied before applying this xfstests patch series.

Eric Biggers (10):
  common/verity: add and use _fsv_can_enable()
  common/verity: set FSV_BLOCK_SIZE to an appropriate value
  common/verity: use FSV_BLOCK_SIZE by default
  common/verity: add _filter_fsverity_digest()
  generic/572: support non-4K Merkle tree block size
  generic/573: support non-4K Merkle tree block size
  generic/577: support non-4K Merkle tree block size
  generic/574: test multiple Merkle tree block sizes
  generic/624: test multiple Merkle tree block sizes
  generic/575: test 1K Merkle tree block size

 common/verity         |  84 +++++++++++++++-----
 tests/generic/572     |  21 ++---
 tests/generic/572.out |  10 +--
 tests/generic/573     |   8 +-
 tests/generic/574     | 174 ++++++++++++++++++++++++++----------------
 tests/generic/574.out |  83 ++------------------
 tests/generic/575     |  58 +++++++++-----
 tests/generic/575.out |   8 +-
 tests/generic/577     |  24 +++---
 tests/generic/577.out |  10 +--
 tests/generic/624     | 119 ++++++++++++++++++++---------
 tests/generic/624.out |  15 ++--
 12 files changed, 346 insertions(+), 268 deletions(-)


base-commit: 41f2bbdec5faa5d6522e86e63c1f30473a99dbfe
-- 
2.38.1

