Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6674654A60
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiLWBLK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235762AbiLWBKc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFC513F88;
        Thu, 22 Dec 2022 17:07:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5B5E61DE4;
        Fri, 23 Dec 2022 01:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203E3C433EF;
        Fri, 23 Dec 2022 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757622;
        bh=mp3Ywc3hFlsa10jDAZztnFnG/LxmUuk54TK4Fi6BRQE=;
        h=From:To:Cc:Subject:Date:From;
        b=GigQKr6OQBLRgpIXX+E2QDFv6lIPVkU/oNg8c1DBdiZDmEquojjNYzXjRAr3Xa9Jy
         1tED8IGEeCX/9usYeWSm0yxE6HtgGzxxLCVq/Jo5vMgoL2awMgvNCQMmjdGviVL1S3
         lqzzy1mj4y+VFfrK8x8CXPSsHDbqq13gXNNSO9/4isol2tQDS80H1RRpTahawEZ/hr
         b/EeGK5XYqxBpthXDEnuyGyIkYxm73/EA7Twkm1TfSYlEjbYuaOHcu407YseHfZmJO
         HRl56b5jzL2zgiooUPSnFVQVgOWosTjgPl6Bs5GmSpf3SMvrNlKjFT0V1iH+vRp3FO
         knqqNHncbDCgQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 00/10] xfstests: update verity tests for non-4K block and page size
Date:   Thu, 22 Dec 2022 17:05:44 -0800
Message-Id: <20221223010554.281679-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
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

Changed since v1:
  - Adjusted the output of generic/574, generic/575, and generic/624
    slightly to avoid confusion.

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
 tests/generic/574     | 177 ++++++++++++++++++++++++++----------------
 tests/generic/574.out |  83 ++------------------
 tests/generic/575     |  57 ++++++++++----
 tests/generic/575.out |   8 +-
 tests/generic/577     |  24 +++---
 tests/generic/577.out |  10 +--
 tests/generic/624     | 119 ++++++++++++++++++++--------
 tests/generic/624.out |  15 ++--
 12 files changed, 348 insertions(+), 268 deletions(-)


base-commit: e263104046712af5fb5dcc7d289ac3fa5f14b764
-- 
2.39.0

