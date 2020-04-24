Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CF91B8130
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgDXUzL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:09 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CFC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b188so10078817qkd.9
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ESNLw7Aisq7nZWdDJ/jbGXmNWu/CrgyvhqtdbYd6E40=;
        b=NiMsO95wozJGML/fjeceBmlYX2Z7SN19LoNkrMVkBGOmfkpzakyzx/fM8oyAeJ6zpK
         EJVjYgQMMhD7lwWtoIbbthrc7Oj2PT4yerBbxAIFGsrMzrFQ4DCzSQ0us+ELDwnWpwUs
         NnKuVYFConlVm5hIUbm1Qiu89HPr5LsrLFpPSwwLXZm8DUN2sPS3mhhBalqb1vCzVBIu
         62psvU7AgxhQ842wSNtBi8y7elsNZNH25ztjDH5B37fa/fRr1oi2zM0O4Ep+XsZpD4Aa
         6U8LiDM1rgt5gB0NqZnbeH/jx9hQr1BxmFUhC+x+wTZzj47jY350wR7P0Wty1DuSKZ1z
         /KIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESNLw7Aisq7nZWdDJ/jbGXmNWu/CrgyvhqtdbYd6E40=;
        b=iY9ydmJ3bHQttB1PyRNd55g0K9WvEDI36HuFNY8NSmJamXnH6aCcDCHfOTa0tAZEJ1
         QlgdNYK7XxuMtKErQP3C+Bj8AeQKBgobqfTjfJ9stReAH3WEh0polAySco4meke/Plei
         NQ8EwgO2kUBLRZuU0v8pGyduWRzxW+BHdQjoV0jaZl+U7FnafMB7x4Bv1Ie0YXZyWLQE
         ZpwJnG7480+UFNJ5fL7ERPiBK40n1qLt1N9wsHH9cLdz4PXQ6zQ7pcJJbaBwhBzLB7Rv
         DEhE7S5sIelrr51mDukB2eJ0WhgvITqMYZIHmxLbb+oUW6inVP1Ww9LrI19pJCxwlyEi
         Ll4A==
X-Gm-Message-State: AGi0PubVFA3jpyy0y2HZqIoUJVV0Z2LQuNBu3xtSfZ/RKsOnUvnJ1HwD
        okf1qRcLUfs1n+OJKKzCAhKPYsvY0m8=
X-Google-Smtp-Source: APiQypJ7n2UamY7YSPlnVL6BpTq6AfUhtm1gdLt0dGYQdtD1ogevMUEj5dL0Xe3YflPN0t0INUKLIg==
X-Received: by 2002:ae9:ebca:: with SMTP id b193mr10754147qkg.236.1587761707993;
        Fri, 24 Apr 2020 13:55:07 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id p80sm4506643qka.134.2020.04.24.13.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:07 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 01/20] Build basic shared library framework
Date:   Fri, 24 Apr 2020 16:54:45 -0400
Message-Id: <20200424205504.2586682-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
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
2.25.3

