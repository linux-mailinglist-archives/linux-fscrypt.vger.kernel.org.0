Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD364D279
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 23:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiLNWpo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 17:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiLNWpn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 17:45:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 307B8B1CA;
        Wed, 14 Dec 2022 14:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BE261C36;
        Wed, 14 Dec 2022 22:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F9C433D2;
        Wed, 14 Dec 2022 22:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057941;
        bh=7p0zl/jG1hqhXufm5ECGwbi68i+bng+vFDX0eMjfN3M=;
        h=From:To:Cc:Subject:Date:From;
        b=HxY4DkrK0t2KL6AL8sKo0g2/D5iAe7VQX6OgGC3naPJVeEJEV6nNQkqY4gA+y4cG4
         gJGQq9GoJ/u4/1J/gXYwiqWYgnehjQRd9NKijW3cnM2uSb/F6RDuwR1Skv1zS0A6HW
         gkuPB4XmVHPXs8BE/CVtQoj8yF1j+c/cv7x+NFxNuki/F9En1mCKFgcQDZ3CZrT1Nx
         /b7rMYC79Jr3KYvp6jJ/CCn/BgY3vjp7qtKuph7wffB+XuS7en6bA8g+qxgVRdENLQ
         S23YmDznCogG6eONQt+xTuPW6tFpluup/Da3+Ih2MFxxbPsAtWf9AHNlGeWUcpaI35
         FHHlEcITf4ptQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 0/4] fsverity cleanups
Date:   Wed, 14 Dec 2022 14:43:00 -0800
Message-Id: <20221214224304.145712-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series implements a few cleanups that have been suggested 
in the thread "[RFC PATCH 00/11] fs-verity support for XFS"
(https://lore.kernel.org/linux-fsdevel/20221213172935.680971-1-aalbersh@redhat.com/T/#u).

This applies to mainline (commit 93761c93e9da).

Eric Biggers (4):
  fsverity: optimize fsverity_file_open() on non-verity files
  fsverity: optimize fsverity_prepare_setattr() on non-verity files
  fsverity: optimize fsverity_cleanup_inode() on non-verity files
  fsverity: pass pos and size to ->write_merkle_tree_block

 fs/btrfs/verity.c        | 19 ++++-------
 fs/ext4/verity.c         |  6 ++--
 fs/f2fs/verity.c         |  6 ++--
 fs/verity/enable.c       |  4 +--
 fs/verity/open.c         | 46 ++++---------------------
 include/linux/fsverity.h | 74 +++++++++++++++++++++++++++++++++-------
 6 files changed, 84 insertions(+), 71 deletions(-)


base-commit: 93761c93e9da28d8a020777cee2a84133082b477
-- 
2.38.1

