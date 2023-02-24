Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D811B6A2502
	for <lists+linux-fscrypt@lfdr.de>; Sat, 25 Feb 2023 00:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBXXZa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Feb 2023 18:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBXXZ3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Feb 2023 18:25:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D0D60131;
        Fri, 24 Feb 2023 15:25:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 860EDB81D4F;
        Fri, 24 Feb 2023 23:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C22CC433D2;
        Fri, 24 Feb 2023 23:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677281124;
        bh=drqct7NTRbGBzinQt7YUftXFzfZue0EPo/09in97zP4=;
        h=From:To:Cc:Subject:Date:From;
        b=DgRHwvPLsxlsEmHlRvHUgCPXJ1J6Azz8mg4s0WxMvdd7OMw+GooliWN3894U9aWlW
         2hnuFpwENmde+0T/gu2fu+YpUFeQDDRR9C1v5FhvtS29onNHM81g1K5cjwTmMLWGNK
         r3YfDJtGKM4URIUB0AjrGWcc/dDfA76sq/Qj3WS2aTAaX6Z/BlymRc2US2FAlwkLW0
         fiQguZq0iDhUZ21vCaJyz7V+kNnP3193vhW94qgkFDV9w6hiFyZRGnid5BliEU62No
         pChTAmm4NK1RgggCvgIzD3xFjyQ97fYhAdxP5IL/WEUCFv6t1eR9zGTOGfMXN5c6HN
         XdSu8uIXY3q2A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] fs/buffer.c: use b_folio for fscrypt work
Date:   Fri, 24 Feb 2023 15:25:03 -0800
Message-Id: <20230224232503.98372-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use b_folio now that it exists.  This removes an unnecessary call to
compound_head().  No actual change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 034bece27163..d759b105c1e7 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -330,8 +330,8 @@ static void decrypt_bh(struct work_struct *work)
 	struct buffer_head *bh = ctx->bh;
 	int err;
 
-	err = fscrypt_decrypt_pagecache_blocks(page_folio(bh->b_page),
-					       bh->b_size, bh_offset(bh));
+	err = fscrypt_decrypt_pagecache_blocks(bh->b_folio, bh->b_size,
+					       bh_offset(bh));
 	if (err == 0 && need_fsverity(bh)) {
 		/*
 		 * We use different work queues for decryption and for verity
-- 
2.39.2

