Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4300D2E034C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgLVALW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:11:22 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36259 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgLVALW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:11:22 -0500
Received: by mail-wr1-f45.google.com with SMTP id t16so12842196wra.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:11:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9JqkLzVJDHVxtah97HrMNSf6PBUqZHmMm+BE7w2OtR4=;
        b=kGUmErj4Dc8pzz10VfzX7npVYqu0yGcaZtMfKxffJhhHS3WL8CRT6K6Ea3YpOXarb6
         fEvNRLWHA4g7IpRsN6qrKlBeVhY5igVFmoueMxrWEG/GP/p09P70eqRjMhRiCNcRFF9R
         L/AQA/RlDETOkqz0CMbdywLmfZwyc602eSJVNoSdgRIKqs7t6Tv2PqMaipcxTzo8GoK9
         QeAAQhMosUTYaSSgqndV9VMFtJanxzfzPvvclZH62jUzF4ClReR4Es5Qq5yzVviiuege
         VH0xRIvMz1P+9wnhxHcl85wF5BSZPcwzGtznhImXTfKBKGWMyIElzkUWLXJIuC/lg3t3
         +b8A==
X-Gm-Message-State: AOAM530uIEdN1E2VIztjA3F0snvDeo/egftRxMNrl1qilwBFISK7l+Sj
        N1F5Y2mm3YG1iVdbZPv5YFrjFbSI1x80SaEI
X-Google-Smtp-Source: ABdhPJzafNHZtw7bKsndB4Y0LCsA4g2Nhb15j6nBHbrFde9I/T8MgNsDcV/SQJ9XqX8EPfLWSOKeSQ==
X-Received: by 2002:adf:9b98:: with SMTP id d24mr21451174wrc.240.1608595839958;
        Mon, 21 Dec 2020 16:10:39 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id y7sm25344367wmb.37.2020.12.21.16.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 16:10:39 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [PATCH v7 2/3] Wrap ./fsverity in TEST_WRAPPER_PROG too
Date:   Tue, 22 Dec 2020 00:10:32 +0000
Message-Id: <20201222001033.302274-2-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201222001033.302274-1-bluca@debian.org>
References: <20201221232428.298710-1-bluca@debian.org>
 <20201222001033.302274-1-bluca@debian.org>
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

