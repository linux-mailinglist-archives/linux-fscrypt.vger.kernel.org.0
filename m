Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4C85161ED
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240510AbiEAFQR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbiEAFQP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:16:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471CE50E10;
        Sat, 30 Apr 2022 22:12:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D70A961166;
        Sun,  1 May 2022 05:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BEAC385B3;
        Sun,  1 May 2022 05:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651381967;
        bh=2vUKQMXpAm2mOWKYBso+HywZABvVuLBsPwnw/l6/ShI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJuiD/wueqRCERhHCB1m6wXX0fQSB7LjRmThg8bHSTVsSrIx9CH7W+F3Zwv2uYTVa
         VPF0+BzbwQg6Fuh63LPmXls424TG77CY0wBrOycaE4j+ciD+IBdADnW56BPsn3Y6Oa
         57LSX7rxv2NqneuXuHnayHQP+yKpuJFJJ9943IYa2PF03l5t8+mPIg6ojwScSDx7Pf
         L/Skqj5+XH926lU72L56chNcJztbgpCcR53OjQhmv74fDq/BNqkU/WIPfpzVzaWrov
         zJu1nigTgMFfvlKE1a1YjjzhDCiGfNL58gcq9oi0CfxKoGuTK3WJfBbQbKR3A9dkKI
         mC5E+jSrXuTtg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 2/7] f2fs: reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
Date:   Sat, 30 Apr 2022 22:08:52 -0700
Message-Id: <20220501050857.538984-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220501050857.538984-1-ebiggers@kernel.org>
References: <20220501050857.538984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

There is no good reason to allow this mount option when the kernel isn't
configured with encryption support.  Since this option is only for
testing, we can just fix this; we don't really need to worry about
breaking anyone who might be counting on this option being ignored.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/super.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 4368f90571bd6..6f69491aa5731 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -525,10 +525,11 @@ static int f2fs_set_test_dummy_encryption(struct super_block *sb,
 		return -EINVAL;
 	}
 	f2fs_warn(sbi, "Test dummy encryption mode enabled");
+	return 0;
 #else
-	f2fs_warn(sbi, "Test dummy encryption mount option ignored");
+	f2fs_warn(sbi, "test_dummy_encryption option not supported");
+	return -EINVAL;
 #endif
-	return 0;
 }
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-- 
2.36.0

