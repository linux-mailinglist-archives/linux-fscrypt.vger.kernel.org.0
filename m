Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5604929644F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 22 Oct 2020 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369475AbgJVR7x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Oct 2020 13:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368666AbgJVR7x (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Oct 2020 13:59:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD5C0613CE
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:59:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id l15so3397493wmi.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 22 Oct 2020 10:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5yfHbieTQRmUltQv9ufETZDmgk21Lswzw+/9hf6In+Q=;
        b=lSaY1v7Hc0gKXcibQS6YllbbsOHl6yEAV42TnT+wvaFHvInWQ7iAaJ2ur4zLn2Mp/J
         HYqDSqb20Fg584Trt4HqtSRWGylQSFsFGdxL6h9rj/dmFJ7EcXwYd3X///trSimiPrr2
         PL5BQTame7iIQhpHHqa5IPb84FUTQZINKNE5n9WY19lMlvCXouheFAOVYXLMekeOSXx+
         k1SM7UbBp8U+Iy/sXeEWRzSVOFupUNlkVy2Rkrh6pHigLuHUFwVkDRmyOmH2SwT9YwxO
         qAe4UBz+MgzGak0U8zvrxEc5ej/XZ3tdI+2eCydtkau15JPWTbujya9tvFtvW+HinlSr
         ZA1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5yfHbieTQRmUltQv9ufETZDmgk21Lswzw+/9hf6In+Q=;
        b=rkM3uRTsBBwm780YnYEuOomHTjlRs+6K4Cc/SEd4G+6uy5lmC6WCvKiYxG1zj7ws5g
         RCu24hsOLpL2XfJUA3poIeGg221dayNYl7kp0CGP1ixv10p6hpfceKa8Lb2BHnigVadK
         cDTLJpQPwsw3ad2seXrswepTUhcu1sNkJsJtC6pg9GMldhBjIRBQcSPvKg8mgBKK+hRL
         nEzOBNv0tUCd9KfwcKu2XszaMLgGiL7sIw8IDlj4B+LFF1eFNH/GRK0CE4v6l+QJUo+Z
         FC5T25MwEoiAC5JESSnZ0kxYRizsZ9FKf43i2S0j3Ep2tEU4U74440xLPxgWyRXOxAMZ
         cqSg==
X-Gm-Message-State: AOAM530GLYTF6yEBuwUKz0+D3XmhD7qCo2ILrA9n76PrkgmxssYffIFi
        MDxnWRvUvaUG6Xp2Lw6OFvQPDovVaYj0Ow==
X-Google-Smtp-Source: ABdhPJzg9XfOyeBAXwC77KZltUy/NmbUg1jsh449N7K3p1kk6lpsJY70RFBhJfSkNcIBSUwmey49VA==
X-Received: by 2002:a1c:a90e:: with SMTP id s14mr3779754wme.46.1603389590332;
        Thu, 22 Oct 2020 10:59:50 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id j13sm5252070wru.86.2020.10.22.10.59.48
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 10:59:49 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH 1/2] Use pkg-config to get libcrypto build flags
Date:   Thu, 22 Oct 2020 18:59:33 +0100
Message-Id: <20201022175934.2999543-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Especially when cross-compiling or other such cases, it might be necessary
to pass additional compiler flags. This is commonly done via pkg-config,
so use it if available, and fall back to the hardcoded -lcrypto if not.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3fc1bec..122c0a2 100644
--- a/Makefile
+++ b/Makefile
@@ -58,6 +58,7 @@ BINDIR          ?= $(PREFIX)/bin
 INCDIR          ?= $(PREFIX)/include
 LIBDIR          ?= $(PREFIX)/lib
 DESTDIR         ?=
+PKGCONF         ?= pkg-config
 
 # Rebuild if a user-specified setting that affects the build changed.
 .build-config: FORCE
@@ -69,7 +70,8 @@ DESTDIR         ?=
 
 DEFAULT_TARGETS :=
 COMMON_HEADERS  := $(wildcard common/*.h)
-LDLIBS          := -lcrypto
+LDLIBS          := $(shell $(PKGCONF) libcrypto --libs 2>/dev/null || echo -lcrypto)
+CFLAGS          += $(shell $(PKGCONF) libcrypto --cflags 2>/dev/null || echo)
 
 # If we are dynamically linking, when running tests we need to override
 # LD_LIBRARY_PATH as no RPATH is set
-- 
2.20.1

