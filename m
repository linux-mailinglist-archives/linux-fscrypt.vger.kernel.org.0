Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2BB183BA9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCLVsK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:47038 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:10 -0400
Received: by mail-qk1-f193.google.com with SMTP id f28so8977989qkk.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++NjwGE43ioeQ7yOS5Y4eayax4+QsX0svaZ/L5IRgHo=;
        b=k2btOuwtnx5M7qpUBN2Mo6QrfJVrRfK5OMBHzSeqA6M/9C5540t0eT4A2Ns+n6SMld
         C98JppvDF6Uh8/VBhh+DcPjwupPQWwzk21w4tJZJLdGT+fE1CZIc0CsrgsEjR17M42wQ
         uskSFtnQxfvNjFRr4znxQysgebGHxN86H1r4vegvyfwxkiSNOxjhUjPDqiUiGWAQKuGD
         9fqXiI7K7i6zr6+4xcQWNvpymbmnSEupdLRtmJ8qpNQA2UqoBhLvAt2rpo8+Ic/ftFzy
         Agq1v3ShBndhdYqHq9bqnW9xRivwSVpz17bFfBTQ29uz6fnBCnEe97M+bhdHkmQSL3Z/
         QBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++NjwGE43ioeQ7yOS5Y4eayax4+QsX0svaZ/L5IRgHo=;
        b=JppHhgApte7Sguxq2FA6ELWQJwYXfqKfvfjxogx5pGuLc6WJnol1HQKTUm3I5i/uwt
         2aMslH784y2BQmc0Zhe6sY8TEM5Ijg96YoadcqkgAGRWgv6c0i9lkyMTcr+b9cureh0F
         CLPuUerjP3J5eLwaD0rJTW1+CowB82Fc7TW/5XzDyatqYrBxFhvgASVX/2Szw7xThyDR
         wdND/QdrpSfTtDlWXw1zoVaqBrQf/p/WS3uwZ4hZiXYQAPl4W+qaXm1PKN9JoSyaFLin
         /vEUl2uJsm04OS9/C5Z+AdG/xk2SCcaLkX2oVllpPYifnhTIVz7BinEsNgG4WjfOHtwQ
         gMLA==
X-Gm-Message-State: ANhLgQ3VxzGISzWiMeAk1qQJL7AiuRwY1gxgudmvSI4xaKz68vr17JbD
        Nn+HkAFGDf4nqXG0Uo70Jd26jhfz
X-Google-Smtp-Source: ADFU+vstnp5DPx9uHs4nkRTjMdh2ULfQaKksHVGOq9L26Txvdu53dXMSfkQGsikuqEDfEk1qBK9FQA==
X-Received: by 2002:ae9:eb12:: with SMTP id b18mr10218445qkg.168.1584049687721;
        Thu, 12 Mar 2020 14:48:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id 4sm23598524qky.106.2020.03.12.14.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:07 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/9] Build basic shared library framework
Date:   Thu, 12 Mar 2020 17:47:50 -0400
Message-Id: <20200312214758.343212-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This introduces a dummy shared library to start moving things into.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile    | 18 +++++++++++++++---
 libverity.c | 10 ++++++++++
 2 files changed, 25 insertions(+), 3 deletions(-)
 create mode 100644 libverity.c

diff --git a/Makefile b/Makefile
index b9c09b9..bb85896 100644
--- a/Makefile
+++ b/Makefile
@@ -1,20 +1,32 @@
 EXE := fsverity
+LIB := libfsverity.so
 CFLAGS := -O2 -Wall
 CPPFLAGS := -D_FILE_OFFSET_BITS=64
 LDLIBS := -lcrypto
 DESTDIR := /usr/local
+LIBDIR := /usr/lib64
 SRC := $(wildcard *.c)
-OBJ := $(SRC:.c=.o)
+OBJ := fsverity.o hash_algs.o cmd_enable.o cmd_measure.o cmd_sign.o util.o
+SSRC := libverity.c
+SOBJ := libverity.so
 HDRS := $(wildcard *.h)
 
 all:$(EXE)
 
-$(EXE):$(OBJ)
+$(EXE):$(OBJ) $(LIB)
+	$(CC) -o $@ $(OBJ) $(LDLIBS) -L . -l fsverity
 
 $(OBJ): %.o: %.c $(HDRS)
+	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
+
+$(SOBJ): %.so: %.c $(HDRS)
+	$(CC) -c -fPIC $(CFLAGS) $(CPPFLAGS) $< -o $@
+
+libfsverity.so: $(SOBJ)
+	$(CC) $(LDLIBS) -shared -o libfsverity.so $(SOBJ)
 
 clean:
-	rm -f $(EXE) $(OBJ)
+	rm -f $(EXE) $(OBJ) $(SOBJ) $(LIB)
 
 install:all
 	install -Dm755 -t $(DESTDIR)/bin $(EXE)
diff --git a/libverity.c b/libverity.c
new file mode 100644
index 0000000..6821aa2
--- /dev/null
+++ b/libverity.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * The 'fsverity library'
+ *
+ * Copyright (C) 2018 Google LLC
+ * Copyright (C) 2020 Facebook
+ *
+ * Written by Eric Biggers and Jes Sorensen.
+ */
+
-- 
2.24.1

