Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5E11DBFE3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 22:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgETUIV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 16:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgETUIU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 16:08:20 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98735C061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:20 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b6so4902026qkh.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/VK4OptNVT0gbfB6Dc4FzOCwrLQe3MO+pzGN0m+gww=;
        b=A9SolZxRaP0ae6XvmrXfPQHeZH4KvO8Ywbrg1ojwShwCONCJaTM2Hg5leNey3zDRcx
         3jxitFlb51J15GoGsfPDGwFSdqiuHxl1MGYLbgziJTRfcdb7jfs8pbEvWxk8gM/6AMgx
         gEZbUPctXHyyHJk6akXx2tlkDR+pypQkZl8yswo/npJXAPk3P6o44bfwFG7iSDK4LoXf
         xm3MmJpznHDOSAJGBiXglbuxIM+2nameUOtyQZWJZuM3Zgu1klYRW6enYc7yJSaBBdTL
         cXmo7sZWRzZwkaleL0vyjqKTY+Wt/vyYMyiDKS6CrkEZjMtfNfcNrEpzGPN9GCJvllVh
         aQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/VK4OptNVT0gbfB6Dc4FzOCwrLQe3MO+pzGN0m+gww=;
        b=tbjXC6/5n7eHmEEGitYuM9oy/70wJ2Vo1+5czlXBfp6vUjgC55oV6HkFE7OFNHYqXo
         K3OP/DMqSPzSTntUQMHXP+C8P57Cfknv2rti/0JGyXgq5M1mWYGJFYAp0FnEhcgmn6XG
         H0aKqiGkxkNZ3/3mTUHJik31yvulOkSlcc+AOdFSWokDVvaCZKNseoP9Map4+6XDQmYm
         mPEiBGuNDhwFnww16MpVLLlYmVfmTJttXNbqeNkYQQh7wLKzTDK98pNvAe5+wuJx1Umf
         qGks7sXtUJ5Ih927KhGeqzyBHdxaFG5n5Y5J4rfPqL8lWTqUeiTmNh7BJbWGbbWs/29x
         JmJw==
X-Gm-Message-State: AOAM531M0TbImKmXZZn6KGWwb902rKuxyKeIkKRB3TnR7rj3t9BwEEDo
        ZQhWVgtotawZWgSdqYDvxIM39sb1
X-Google-Smtp-Source: ABdhPJxeKZ2v2vyFICweXkbGQXH3WxKurJQJrWPTCUhRi30EJeiDGizrR+RYTaVQpvuchC2eWsoGXg==
X-Received: by 2002:a37:a4d8:: with SMTP id n207mr6708772qke.354.1590005299823;
        Wed, 20 May 2020 13:08:19 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id i5sm3087822qtp.66.2020.05.20.13.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 13:08:19 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/2] Fix Makefile to delete objects from the library on make clean
Date:   Wed, 20 May 2020 16:08:10 -0400
Message-Id: <20200520200811.257542-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 1a7be53..e7fb5cf 100644
--- a/Makefile
+++ b/Makefile
@@ -180,8 +180,8 @@ help:
 	done
 
 clean:
-	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) $(LIB_OBJS) $(ALL_PROG_OBJ) \
-		.build-config
+	rm -f $(DEFAULT_TARGETS) $(TEST_PROGRAMS) \
+		lib/*.o programs/*.o .build-config
 
 FORCE:
 
-- 
2.26.2

