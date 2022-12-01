Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DE563F7FB
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 20:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLATPS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 14:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLATPR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 14:15:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEF6C5E37;
        Thu,  1 Dec 2022 11:15:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 186DF620DC;
        Thu,  1 Dec 2022 19:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656ECC433C1;
        Thu,  1 Dec 2022 19:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669922115;
        bh=StPinCnLO/RMc+OOosSfHSVUv5fPcYvPEdBZnrFvtwU=;
        h=From:To:Cc:Subject:Date:From;
        b=c8ocGdnvvc1QFD0eqWmDsICrXRmLCM16ste/XF5JGMaubFa93RQ4z8IPJBLLo6+zS
         cv1KOHuLL6upzZ6MuW0AoLmej037m59Nzv+cOenPVJJo9cx+IZco+4jIG9HX4L2659
         BIC3XKe0+t/CiDyc7qDdjlr6WNsv6Ie71rlptO5pgLT3QYTY14lGDc6RFg3FreKpLx
         ZAgSHPIi9gw7Y/u2rL8g13MwFSnqyo+L1JMpYAzM6Ek1neiwkw0mau1LK6Z+pTjq+A
         h6rEQBlnBufugZoEYpfc3vaY6CQrbnNNkNDHUq9CSXzwxj+I0YQbqY45IStL0H7gRg
         9pU7OodOoiE3g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-doc@vger.kernel.org,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] fscrypt: add additional documentation for SM4 support
Date:   Thu,  1 Dec 2022 11:14:52 -0800
Message-Id: <20221201191452.6557-1-ebiggers@kernel.org>
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

From: Eric Biggers <ebiggers@google.com>

Add a paragraph about SM4, like there is for the other modes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index c0784ec055530..ef183387da208 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -370,6 +370,12 @@ CONFIG_CRYPTO_HCTR2 must be enabled.  Also, fast implementations of XCTR and
 POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
 CRYPTO_AES_ARM64_CE_BLK for ARM64.
 
+SM4 is a Chinese block cipher that is an alternative to AES.  It has
+not seen as much security review as AES, and it only has a 128-bit key
+size.  It may be useful in cases where its use is mandated.
+Otherwise, it should not be used.  For SM4 support to be available, it
+also needs to be enabled in the kernel crypto API.
+
 New encryption modes can be added relatively easily, without changes
 to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
-- 
2.38.1

