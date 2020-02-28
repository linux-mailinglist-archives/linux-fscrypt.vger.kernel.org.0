Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3613174172
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 Feb 2020 22:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgB1V2Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 Feb 2020 16:28:25 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41960 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgB1V2Z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 Feb 2020 16:28:25 -0500
Received: by mail-qk1-f196.google.com with SMTP id b5so4444424qkh.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 28 Feb 2020 13:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=++NjwGE43ioeQ7yOS5Y4eayax4+QsX0svaZ/L5IRgHo=;
        b=txVn8XH4LLfGe7ZCyIxDXEavTLyKBLwdlhjMCVqe2Y1pShPuuDH2jdu3xmPOqjPidi
         fVokFOy40K2GOLuzoNj/0xafmN7MW+7qHo+qDvqwm/H8Vex2kmtr4tXnj2u6Vw+ok1uK
         bbDE9F/uDg4QYwYtw9/8KHz5CgnDwcqpKkaVvFLsTKyC7eZ6UC61tunqnMiMFg0Ru4Xh
         FDryqBIx7a+KBLHkQdTPxanNplfO3uocwLGz1UynPC93uFPfDIkon/q3CHuAC/IBulpL
         GHRoGfQLwSgCnc6JBqd8ydsdtk3quQsjerLxK+WWBMOsGzL8DuR+HLknjQ7uQ5un+wZT
         2G+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=++NjwGE43ioeQ7yOS5Y4eayax4+QsX0svaZ/L5IRgHo=;
        b=fJq+QC8loVgswVkMPkkrIOtcdGpR2bZqdGB0AfI1hjbKJw28b9u+sBxi2uDV90H6CE
         hGQZ1JRksHkZTodcnLdbx1J+gYS58BWfK1q0qUmiKWfJtW2S7jhHf8tVChzJQz3JIkJT
         Je9Zblq0yqgjk+FIODRS5pB1a7k67FfpSk2EjYr75Nw/+sqfC+7x3BWugN4Qq9T3RGdH
         8mBItnBkPi7s5UIpyQC36jiOkU82f1+mOM4F6TiiRyVjHJ+VFsMAAI7u684+J9r0OC1o
         xW2Up8RNgjWSl2vjvVSsevMoQLaSfQidjgi9faevXlQThgnPRJjfrJfCFZWubIrRIVWj
         zrRA==
X-Gm-Message-State: APjAAAVjRiEZ1l7p4MLz7AGfNWi/mRLfrOa3puE98OwkKxZLzV6kQozV
        GD8cQq7a4R9Hky61dJ5qqQrk7V6O
X-Google-Smtp-Source: APXvYqwFYBU+JeUjP6uVwKqpqogAm3ZFQvfnn9ULg8g+javspHTI5MGbSDEz5w7au5PdbI3nhQqN+w==
X-Received: by 2002:a05:620a:742:: with SMTP id i2mr6191110qki.226.1582925302329;
        Fri, 28 Feb 2020 13:28:22 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::1:bc9d])
        by smtp.gmail.com with ESMTPSA id j11sm5840583qkl.97.2020.02.28.13.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:28:21 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/6] Build basic shared library framework
Date:   Fri, 28 Feb 2020 16:28:09 -0500
Message-Id: <20200228212814.105897-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
References: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
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

