Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B81C2E02E6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgLUXZX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:25:23 -0500
Received: from mail-wm1-f49.google.com ([209.85.128.49]:36558 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgLUXZX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:25:23 -0500
Received: by mail-wm1-f49.google.com with SMTP id y23so471658wmi.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9JqkLzVJDHVxtah97HrMNSf6PBUqZHmMm+BE7w2OtR4=;
        b=BhOJUZaL/gJyvv6y6k6T33yIaa5YeRkVOgX408Ld4A3j6wWrRu+R29Y0/nOYzqrMd+
         wXFhZcG3PI2TPQrwazfmFPOoEJ54BA7GtTZ1TkiR2AMS3SeZa37tT3nBjHApmreDPAjF
         I4lAj1EoaVBXww1gWAp37SOAbFpZ+4Vm4vGS2zsTlPHtu3yUqGsaaPgJDWT0KstA0zjf
         tWPH80VyBVdS6SXN3XOr41NQL4A66Qd/AjYTPLcxWjBJ1jL372GI9z/O7lN77NZ6ESH7
         DriZw3qvPHa34Z9HPuP1p5cgiMaco2h83u9L8ZcddqXbEI9oSAsQNCero3QyUN/us/gC
         Do/Q==
X-Gm-Message-State: AOAM533kErfRb6edCgZs9pVEQk0O5X1TQ7uDAQX8i7pVwmU/AzYXG5Iv
        xqZi4K09mO/Qz+I6CrxMYrCOLhAevABZRWYk
X-Google-Smtp-Source: ABdhPJz7sYw6L+yPFz3ReuAjDDzVqNPGRrpUEc+lzwbZPlGoStXwDq/h9CUXvQLdtVIM7eAiic4RIw==
X-Received: by 2002:a1c:b608:: with SMTP id g8mr19028046wmf.110.1608593080650;
        Mon, 21 Dec 2020 15:24:40 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id h184sm24136970wmh.23.2020.12.21.15.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 15:24:39 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, Luca Boccassi <bluca@debian.org>
Subject: [PATCH v6 2/3] Wrap ./fsverity in TEST_WRAPPER_PROG too
Date:   Mon, 21 Dec 2020 23:24:27 +0000
Message-Id: <20201221232428.298710-2-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221232428.298710-1-bluca@debian.org>
References: <20201221221953.256059-1-bluca@debian.org>
 <20201221232428.298710-1-bluca@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Allows make check to run fsverity under the desired tool

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v6: split from mingw patch

 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index f1ba956..583db8e 100644
--- a/Makefile
+++ b/Makefile
@@ -87,9 +87,9 @@ CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
 # If we are dynamically linking, when running tests we need to override
 # LD_LIBRARY_PATH as no RPATH is set
 ifdef USE_SHARED_LIB
-RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
+RUN_FSVERITY    = LD_LIBRARY_PATH=./ $(TEST_WRAPPER_PROG) ./fsverity
 else
-RUN_FSVERITY    = ./fsverity
+RUN_FSVERITY    = $(TEST_WRAPPER_PROG) ./fsverity
 endif
 
 ##############################################################################
-- 
2.29.2

