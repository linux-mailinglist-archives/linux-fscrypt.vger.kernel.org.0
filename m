Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AF8659330
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbiL2XfF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiL2XfF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1AC167CE;
        Thu, 29 Dec 2022 15:35:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96FE76198E;
        Thu, 29 Dec 2022 23:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DDCC433EF;
        Thu, 29 Dec 2022 23:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356903;
        bh=THjtJ8q6i0Z5+bcbU0FCCq+HLhNtYnnJ43O6xBuqoD4=;
        h=From:To:Cc:Subject:Date:From;
        b=OalXhWmAZLKcybYW0xj8hMsfrz+eQmG8gBRtl6CAC033K0AW7YH5QbEzYP+kTbyST
         P5WFHZn1wQLoVjXg5yZ8cVHH4lvzrIxnVV2YrNeipgfYyt8s53QC9y7ifXgiliKnJw
         AiIyhZMUv1oS+/JfWk4DJ2gVOxtQ/IFp9KQxlLfmKYQ4KAm0L2eOeNkJzAajBbRV4e
         j/LttB8SlUQaFj0IQuyj/9Q2oHN05C/aPuwsXwgpfddeZjCsenulXK5iRbTadNfNi3
         SvXQx0R75ZSVDbnoOgDC0yKp8KR5u6dmTs03W4jQFhFCfyhlZ1YZXnextC32gPJIta
         2oH6nMUKjLUnw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 00/10] xfstests: update verity tests for non-4K block and page size
Date:   Thu, 29 Dec 2022 15:32:12 -0800
Message-Id: <20221229233222.119630-1-ebiggers@kernel.org>
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
(https://lore.kernel.org/linux-fsdevel/20221223203638.41293-1-ebiggers@kernel.org/T/#u).
However, it's not necessary to wait for that kernel patch series to be
applied before applying this xfstests patch series.

Changed in v3:
  - Fixed generic/574 failure with some bash versions.

Changed in v2:
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

 common/verity         |  84 ++++++++++++----
 tests/generic/572     |  21 ++--
 tests/generic/572.out |  10 +-
 tests/generic/573     |   8 +-
 tests/generic/574     | 219 +++++++++++++++++++++++++-----------------
 tests/generic/574.out |  83 +---------------
 tests/generic/575     |  57 ++++++++---
 tests/generic/575.out |   8 +-
 tests/generic/577     |  24 ++---
 tests/generic/577.out |  10 +-
 tests/generic/624     | 119 ++++++++++++++++-------
 tests/generic/624.out |  15 +--
 12 files changed, 370 insertions(+), 288 deletions(-)


base-commit: 3dc46f477b39d732e1841e6f5a180759cee3e8ce
-- 
2.39.0

