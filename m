Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9734365A8F7
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjAAFNs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjAAFNq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:46 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A6D63E9
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:45 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BC9CB82670;
        Sun,  1 Jan 2023 00:06:59 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549620; bh=59kU/7xIENmIwXKjj5p7OjDGbHH5fEFReYyZ3dopUqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKu3rfANw9d3ck1QUxwCt5VWEpKOp6MJ13occV7vo2JT5aLnAzw2zlu88dr/356EB
         /yX0kEpIVifjl4vTKM0aMq7jm+7BYaOVGWxwI3RT75dGMbL+h4nwDQby7fKqm5/OW2
         xCv7L+0ZVgq/TV0iwtwYECmi2esta7sW2pn4eRJH+XMjsG/rfDYCm4MuBrozlGgNze
         7RC3YOxUAtf9j65JU02NK36NGrf7oMKjvvWClySTK8eVpKX41C2Mm9Ttz/wRH1k7cP
         1iup3H9Aj9XyoyvXhnIVQVjDGQQMbXen0iELH11nHfxZHWxg3RQ3o/LjQ7x+VSg42s
         GftTueelwJ4Nw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 16/17] fscrypt: disable inline encryption for extent-based encryption
Date:   Sun,  1 Jan 2023 00:06:20 -0500
Message-Id: <1dce5730bff1479ef9fe6a52c9dd0dfc31576b91.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

I haven't worked out how to do inline-suitable fscrypt_infos for
extent-based encryption, so disable the combo for now.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/inline_crypt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 808c8712ebe7..43fb0d933ff4 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -113,6 +113,10 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	if (!(sb->s_flags & SB_INLINECRYPT))
 		return 0;
 
+	/* The filesystem must not use per-extent infos */
+	if (fscrypt_uses_extent_encryption(inode))
+		return 0;
+
 	/*
 	 * When a page contains multiple logically contiguous filesystem blocks,
 	 * some filesystem code only calls fscrypt_mergeable_bio() for the first
-- 
2.38.1

