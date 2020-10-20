Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A571294124
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Oct 2020 19:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390180AbgJTRL1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 20 Oct 2020 13:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390162AbgJTRL1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 20 Oct 2020 13:11:27 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82649C0613CE
        for <linux-fscrypt@vger.kernel.org>; Tue, 20 Oct 2020 10:11:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i1so3104346wro.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 20 Oct 2020 10:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+7E1Cz4x2iXXoeLfNvoD4aO2S6pHI8q6BJDrrVPlk=;
        b=fMdzbonLJ80SHAXB+xZXtoeFYy4VWmLtGsDDjBf9MmQAhIhhoqSl4CM4bKt/3LXbMB
         oevD3QrrcFc7W11K83wd1GJqT6r3VUXZN9DEZmtoxio2M8Un1VqPnD5dLQksRsTCcKcC
         lIFT5mhKnMu6uRVln5dY97mTb/W/mySHTssRNplYfLmQT7eJL50tLYR68jBmohCdr/Wg
         RYNu+dgbli76UXnT9/NtuR7X4VtdvCje/adE83lEcnVS7yHNaI/oHwDkfm0VW1a7Qsvf
         GX7qyjUemHnkNppF+qzRN9bFCCEhL9yTb4g6diwzpTu9l8frW/kN6LhJLW8Vx/WDCo+D
         nQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9X+7E1Cz4x2iXXoeLfNvoD4aO2S6pHI8q6BJDrrVPlk=;
        b=iKbH6pBhZmsxAHfbL26JSsucErBa8osyCIcd6CG6X3mv775xTgwSEZhgZ/m4DKav/E
         uOhqpP8//cey1NCE7UFRMgJ1gU2YnPpYp0O9KUoyKLUNUvqeMLYlX6K92KKskJjB5hJR
         Bauf4+7zgPym5djv598e1ookULgayymhy2MkKkW2F+cA+y5J7cYus+W0N1uHTFNpU1O6
         OznzMxq15d9wVX1J0hOltlfYR1oWjC6KmKsqWap1/U5/fltxZBdNGcx7jLDflMTpxhkw
         3k99P2yr4678up30OxJMgbw8NZ+Isg0QWJr2lIDBiR6VRIcb/9epTmrwI0VfX8bNDZ/C
         QjgQ==
X-Gm-Message-State: AOAM531/wcjpqKlET/HEIEKYHqyDMzs4YM3Uxh2WAdY8SlG3X8MGKqi4
        gRcyeshkJkQjZEVRkRMq7jefOimeiPtrbg==
X-Google-Smtp-Source: ABdhPJy4RkZ+rLuQHxEP34V2F4crgtaQyi7YiyXO4a4yeOV1WBfR/y9aaqMk29i+J3clGHV4ycAVYg==
X-Received: by 2002:adf:fac3:: with SMTP id a3mr4502364wrs.240.1603213884872;
        Tue, 20 Oct 2020 10:11:24 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id u133sm2168023wmb.6.2020.10.20.10.11.24
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 10:11:24 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH] Makefile check: use LD_LIBRARY_PATH with USE_SHARED_LIB
Date:   Tue, 20 Oct 2020 18:11:10 +0100
Message-Id: <20201020171110.2718640-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

When USE_SHARED_LIB is set, the fsverity binary is dynamically linked,
so the check rule fails. Set LD_LIBRARY_PATH to the working directory.

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
 Makefile | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index deffe8b..5edb54b 100644
--- a/Makefile
+++ b/Makefile
@@ -71,6 +71,14 @@ DEFAULT_TARGETS :=
 COMMON_HEADERS  := $(wildcard common/*.h)
 LDLIBS          := -lcrypto
 
+# If we are dynamically linking, when running tests we need to override
+# LD_LIBRARY_PATH as no RPATH is set
+ifdef USE_SHARED_LIB
+RUN_FSVERITY    = LD_LIBRARY_PATH=./ ./fsverity
+else
+RUN_FSVERITY    = ./fsverity
+endif
+
 ##############################################################################
 
 #### Library
@@ -166,11 +174,11 @@ check:fsverity test_programs
 	for prog in $(TEST_PROGRAMS); do \
 		$(TEST_WRAPPER_PROG) ./$$prog || exit 1; \
 	done
-	./fsverity --help > /dev/null
-	./fsverity --version > /dev/null
-	./fsverity sign fsverity fsverity.sig \
+	$(RUN_FSVERITY) --help > /dev/null
+	$(RUN_FSVERITY) --version > /dev/null
+	$(RUN_FSVERITY) sign fsverity fsverity.sig \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
-	./fsverity sign fsverity fsverity.sig --hash=sha512 --block-size=512 \
+	$(RUN_FSVERITY) sign fsverity fsverity.sig --hash=sha512 --block-size=512 \
 		--salt=12345678 \
 		--key=testdata/key.pem --cert=testdata/cert.pem > /dev/null
 	rm -f fsverity.sig
-- 
2.20.1

