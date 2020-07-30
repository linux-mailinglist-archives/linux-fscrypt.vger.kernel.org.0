Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A4E232F97
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Jul 2020 11:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgG3Jfb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 30 Jul 2020 05:35:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44506 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgG3Jfa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 30 Jul 2020 05:35:30 -0400
Received: from mail-pl1-f200.google.com ([209.85.214.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k14yG-0000Us-Ds
        for linux-fscrypt@vger.kernel.org; Thu, 30 Jul 2020 09:35:28 +0000
Received: by mail-pl1-f200.google.com with SMTP id p6so16380262plo.8
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Jul 2020 02:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QOmZGC0B89uWD3XE7Hdn5eguiDh0cZOESiTFyFkMc9U=;
        b=EXMrT9Lkp3COuo9uJ+zcEuw9c0lAblAJAL/QxjEAclqnvreMo/ocvRRJc56YF51JhT
         2BdnTFvLqZfc28DUAggeyFu5+f/s3BoGzR/+Mf+wFrDb34yi9/25+ZVK4Ab41OEWATWn
         7SMJrDOjCLuxJaRFpNl1N73IwRGjsKtwPo0fIrU/x/KxzwFKJdY9hFWlNM9IPiiVoj2h
         ocnuEn7obPL1L+BaY/rXSf4NzKACD7+pB6f5b/s74UiMFQEIJRor2m5NW28dmemOl/DA
         IqB6Jq8hnBfWYvnduvu8Lb4PU9CYf0DpXa1KESLf3n2vguX8PtU+lmY7qEgYBq/pBby3
         Rg4Q==
X-Gm-Message-State: AOAM531uWHbLX9FhUHu5oo0BsH9tUTm28DhXeM+GDqG3FnazPJB8cFcS
        dJwWhSE+p5jTx/HFdSTv0W06c/LiGmGQM2UlR2pM5CiISfv5KeZEzrVFSEN3LWNxp+DatWWkIo1
        ovoZazlF0bTIAcnOb87Meue3Iozlr3Z3BwHkwma9IEQ==
X-Received: by 2002:a62:a20d:: with SMTP id m13mr2486284pff.201.1596101726708;
        Thu, 30 Jul 2020 02:35:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3uGTf89kMFP/mqd5O5dDEHMAuSzbN0djF++lXK55YPCzH5arWpjcrC400wmemTZi+QdEGmA==
X-Received: by 2002:a62:a20d:: with SMTP id m13mr2486262pff.201.1596101726368;
        Thu, 30 Jul 2020 02:35:26 -0700 (PDT)
Received: from localhost.localdomain (111-71-29-199.emome-ip.hinet.net. [111.71.29.199])
        by smtp.gmail.com with ESMTPSA id k98sm4772724pjb.42.2020.07.30.02.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 02:35:25 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     po-hsu.lin@canonical.com
Subject: [PATCH] Makefile: improve the cc-option compatibility
Date:   Thu, 30 Jul 2020 17:35:20 +0800
Message-Id: <20200730093520.26905-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
    cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’

This unsupported flag is not skipped as expected.

It is because of the /bin/sh shell on Ubuntu, DASH, which does not
support this &> redirection. Use 2>&1 to solve this problem.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7d7247c..a4ce55a 100644
--- a/Makefile
+++ b/Makefile
@@ -27,7 +27,7 @@
 #
 ##############################################################################
 
-cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
+cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
 CFLAGS ?= -O2 -Wall -Wundef					\
-- 
2.25.1

