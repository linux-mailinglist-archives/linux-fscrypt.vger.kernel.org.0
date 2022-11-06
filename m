Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA1061E70B
	for <lists+linux-fscrypt@lfdr.de>; Sun,  6 Nov 2022 23:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiKFWwi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 6 Nov 2022 17:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiKFWwh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 6 Nov 2022 17:52:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772F81005E;
        Sun,  6 Nov 2022 14:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29BCAB80D42;
        Sun,  6 Nov 2022 22:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AEAC433D6;
        Sun,  6 Nov 2022 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667775153;
        bh=5co5XEYnUIjBEHcTDXg4FnklrEFDaO2M2XUSJYBofYk=;
        h=From:To:Cc:Subject:Date:From;
        b=N97gUcaXbS9QGKdoJhW+xzcO3TJWPSUkyfRaa59RYe0aH85R9I0Dfg3hZCVxWSCRO
         rl8Ylr+TbnkeetPpe4kY2oTdHGUPJE2dp3LkldFvmJ7oGi6vRIaXMzR0HeAHTxICMV
         q1ajk7w5bRF+bs1igHHaeWkFHSAHfaDMv2wWBNszcEtKOOhCpOV7CU/3jXWPfpzDTX
         LRhEvCnyNKIrKyrHV4voecIrdxWkPAVku1SExg3/Ulx9nJ7Q8lt5+tV4OrpsFu1Ptl
         pZqwIEphTRc9U8Kgb5bPJloaVv5ITwB7quzTixlCQoT8dhApKAM2DLhyt83aoL3ts8
         x1tUIzna1kCzA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Subject: [PATCH 0/7] ext4 fast-commit fixes
Date:   Sun,  6 Nov 2022 14:48:34 -0800
Message-Id: <20221106224841.279231-1-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@kernel.org

This series fixes several bugs in the fast-commit feature.

Patch 6 may be the most controversial patch of this series, since it
would make old kernels unable to replay fast-commit journals created by
new kernels.  I'd appreciate any thoughts on whether that's okay.  I can
drop that patch if needed.

I've tested that this series doesn't introduce any regressions with
'gce-xfstests -c ext4/fast_commit -g auto'.  Note that ext4/039,
ext4/053, and generic/475 fail both before and after.

Eric Biggers (7):
  ext4: disable fast-commit of encrypted dir operations
  ext4: don't set up encryption key during jbd2 transaction
  ext4: fix leaking uninitialized memory in fast-commit journal
  ext4: add missing validation of fast-commit record lengths
  ext4: fix unaligned memory access in ext4_fc_reserve_space()
  ext4: fix off-by-one errors in fast-commit block filling
  ext4: simplify fast-commit CRC calculation

 fs/ext4/ext4.h              |   4 +-
 fs/ext4/fast_commit.c       | 203 ++++++++++++++++++------------------
 fs/ext4/fast_commit.h       |   3 +-
 fs/ext4/namei.c             |  44 ++++----
 include/trace/events/ext4.h |   7 +-
 5 files changed, 132 insertions(+), 129 deletions(-)


base-commit: 089d1c31224e6b266ece3ee555a3ea2c9acbe5c2
-- 
2.38.1

