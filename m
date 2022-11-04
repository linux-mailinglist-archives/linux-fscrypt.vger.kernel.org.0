Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEF619161
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 07:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiKDGsn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 02:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231635AbiKDGsA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 02:48:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AC32AC67;
        Thu,  3 Nov 2022 23:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 010DCB82B42;
        Fri,  4 Nov 2022 06:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F9BC433B5;
        Fri,  4 Nov 2022 06:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667544475;
        bh=d8JKddS3YWwb0czwRnFxvzIc3E/bxNex5nRAVI6ucGM=;
        h=From:To:Cc:Subject:Date:From;
        b=WvLvYPlxgLJ2QmVR2Km+CjthG/B++VoxJ1kd44YjGr0yM1YOa11RSSnjSvmvTdM8+
         rrMGNHrYvYCAEJhPSdjE2qGZ3W1IJZLxFdsa0I4JvWYP5e/nz/5a7GJO68kzA4qDAr
         n/VZuj2F+TtdlAvLZtft5ZI9w2NxT8ZTWo/sZcZQbsiloWR9IiEYBgIdGAmE9y2XuY
         rKeqXRQlCNo3zg6gWDZwKMZQ//sHwkFcas3pi9H+Khj8XL63d7Zo8HwtQEVk6xFabu
         LmoU+Dui0NChQeWqrGlyt8DKHnQIcPt1lzOrHQrc1uc+poqZZck44bBBjjEar9PLPK
         ttkatWUssoleQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-fscrypt@vger.kernel.org
Subject: [xfstests PATCH 0/3] Fix test bugs related to fs.verity.require_signatures
Date:   Thu,  3 Nov 2022 23:47:39 -0700
Message-Id: <20221104064742.167326-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a replacement for Andrey's patchset
"generic/577: fix hash check and add metadata cleaning".
It handles some other things that were overlooked.

Eric Biggers (3):
  common/verity: fix _fsv_have_hash_algorithm() with required signatures
  generic/577: add missing file removal before empty file test
  tests: fix some tests for systems with fs.verity.require_signatures=1

 common/verity     | 69 +++++++++++++++++++++++++++++++----------------
 tests/btrfs/290   |  9 +++++++
 tests/btrfs/291   |  2 ++
 tests/generic/577 |  1 +
 tests/generic/624 |  8 ++++++
 tests/generic/692 |  8 ++++++
 6 files changed, 74 insertions(+), 23 deletions(-)


base-commit: a75c5f50584e03ca7862ad51f48efd2d524d1dc5
-- 
2.38.1

