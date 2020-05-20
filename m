Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249C51DC155
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgETVZv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgETVZv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:25:51 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF40CC061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:49 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id f83so5121377qke.13
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/VK4OptNVT0gbfB6Dc4FzOCwrLQe3MO+pzGN0m+gww=;
        b=HEsOQBuYem3x5K0jP7Y1Fgo1K9gPxSuc9c/J0Wr/x1y+Im3y7u/I8sUbEHxXiyOigw
         wfS6LhRlS2ycOSPaSuk0zQktuv+xJcUzoL8ZeijqEAQVZ5dLoSSTzWRC1Jg2yi4U7SXW
         FiX6+noFyvws2bbDLgt7EA8uZMrWvHKcbhRsccNMZWdxWGNu+Sh1Z+1c/ifkWdtiJTCv
         GICBdkhB8LJdNQ1jCQ+FYghS0htRkBkcXj0ETPgpeffqXUyjt9Xfy15wR00JOE7SGhTO
         US95IzDlUvHmXB7tfzuMsyGv9j1WR+Uqm820gJvIFcr0XmgZ7gItReW7gEdmFN2sGTSz
         aIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/VK4OptNVT0gbfB6Dc4FzOCwrLQe3MO+pzGN0m+gww=;
        b=q1mt0zyXIjPUESGLbvizgBaMjldXtQBm2lx/Yx6Pec50YelrXDulOiSIJSY+jOBM/P
         +uCd3m/nAlSsKO5a96V1nO+kRnN5jUUTEZ4eUsY7ocs10xEcaCiIusLmGgVMi9aA7vW8
         ulhHoQU4tmbMUmGGQG+hQaYHp1tDnytQ/RhrFtlMhgVoN8/suBsltOpMNFMaqN4km+IL
         CUngfLT1NGAsStg5KNOVaJ76/UjYiy9Wo+0YQV9nZ52Oiy9SAzhpLtKIsVgOZF3MHmUC
         PHLcAv3WKN/3jtth8AnidmzQB5MV8apS6RXPHe7mzpFUnHB/O5PhOeFKcHDmjXutFesZ
         ayEg==
X-Gm-Message-State: AOAM532M4Vb1Mn+6cKZYqfONgWKCcWOTRovpLPrFHg35G6Vqp/FM6JBt
        u+65hvkzDxquN0xMAoNPut8=
X-Google-Smtp-Source: ABdhPJwEK/L+T4OXi+XTvqQegTjFcv/ID4GhB14RNKF5xG+YzjmtIvtK1+yko1fyW2NLl8kquZuq+g==
X-Received: by 2002:a37:6490:: with SMTP id y138mr7121969qkb.32.1590009948971;
        Wed, 20 May 2020 14:25:48 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id i5sm3241983qtp.66.2020.05.20.14.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 14:25:48 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/2] Fix Makefile to delete objects from the library on make clean
Date:   Wed, 20 May 2020 17:25:39 -0400
Message-Id: <20200520212540.263946-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520212540.263946-1-Jes.Sorensen@gmail.com>
References: <20200520212540.263946-1-Jes.Sorensen@gmail.com>
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

