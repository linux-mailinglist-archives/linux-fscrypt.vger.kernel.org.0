Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86FE1B813C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDXUza (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUza (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:30 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C73C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:30 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id c23so8595527qtp.11
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vCJTIc8oPmMK3Dc93E89ACICAHMFSfRiodHF41XPX6c=;
        b=VfXBHyha9QtG5FMboV3rtbieUzVuyXszJsqtZD5TwmA4ahtpIV/rTrwpgzRXrwHc37
         es+GG+7Hi9m133lYszfwozIzo8lrI9eslkEuxrFWkM9DqS2ds8hrbOW/+9fbNQHcJQfl
         zzj/Ogs0BbEeSaJySTrkIfFqVfaMWcRS8ozLiiDCn6n9Lh7uO5UIuB/CxuilMcYAqiHF
         KIUog2tofga4m3HYCfDK6jPdybQKin3h7I+EBuAzXyJtyB9gnG1w2SkeUJonGnD5UkNk
         Ih6gBcen4axcm2DkHx1viNpgBWScz6UK19zUqXC1oUgh5r/KH2dA4xlqMUyJmbVqS/yJ
         Xpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vCJTIc8oPmMK3Dc93E89ACICAHMFSfRiodHF41XPX6c=;
        b=gA2EhpXN6EOJjaWBGjT+7AG6Ct07laS94uRZRnT3i/Lqq/dhtM3d19fkxWGhebr+bj
         9ZY0ICwN0jLPFWzwLhq/7zuG/Uxpgz8P4FPNNoC7huH07fkbZNTKq1iTlLGz8OAnVmiB
         H7etoaM9GhcaFO2VpORcK6IWSC6KVpHV+7N+Gp5unGKh2pbw9RQFMdkdFVGIOd0Ia22z
         CGINcgZhLYYRQjBklIZqFQ0FwDWTQnpTTx/Yz+Vl7z4ykBbLDditkfpeDmxY5AkJuk42
         MNEDciy/lg8bxdfbW5WZTMljz0C0I/4btDwk/Wr/A//P1Hss8n5xMYPKC5W4fQGGo5Eo
         96rg==
X-Gm-Message-State: AGi0PuaMOJ5VTv/+vbNf2HBK5kdsoj8n5zlZW5+yITLPr/7BIQP6cTPA
        UEyjYmSFZYXFBMId2UxqwwCisGINq64=
X-Google-Smtp-Source: APiQypJayRlFgBhaOHzKpzqKJxiQ8XG4qE5kigldH4wi5ayaZb4zPNBFD6Ub78c7PpUux6GJKtRriA==
X-Received: by 2002:ac8:32f4:: with SMTP id a49mr9973685qtb.293.1587761728931;
        Fri, 24 Apr 2020 13:55:28 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id m187sm4463700qkc.30.2020.04.24.13.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:28 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 13/20] Update Makefile to install libfsverity and fsverity.h
Date:   Fri, 24 Apr 2020 16:54:57 -0400
Message-Id: <20200424205504.2586682-14-Jes.Sorensen@gmail.com>
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

In addition this adds a 'static' build target, which links in libfsverity
statically rather than relying on the shared library.

This also honors PREFIX for installation location.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 966afa0..5bbcd87 100644
--- a/Makefile
+++ b/Makefile
@@ -1,34 +1,52 @@
 EXE := fsverity
+STATIC := fsverity-static
 LIB := libfsverity.so
+INC := libfsverity.h
 CFLAGS := -O2 -Wall
 CPPFLAGS := -D_FILE_OFFSET_BITS=64
 LDLIBS := -lcrypto
-DESTDIR := /usr/local
-LIBDIR := /usr/lib64
+PREFIX = /usr
+BINDIR := $(PREFIX)/bin
+LIBDIR := $(PREFIX)/lib64
+INCDIR := $(PREFIX)/include
 SRC := $(wildcard *.c)
 OBJ := fsverity.o cmd_enable.o cmd_measure.o cmd_sign.o util.o
 SSRC := libverity.c hash_algs.c
-SOBJ := libverity.so hash_algs.so
+SHOBJ := libverity.so hash_algs.so
+STOBJ := libverity.o hash_algs.o
 HDRS := $(wildcard *.h)
 
 all:$(EXE)
 
+static:$(STATIC)
+
 $(EXE):$(OBJ) $(LIB)
 	$(CC) -o $@ $(OBJ) $(LDLIBS) -L . -l fsverity
 
+$(STATIC):$(OBJ) $(STOBJ)
+	$(CC) -o $@ $(OBJ) $(STOBJ) $(LDLIBS)
+
 $(OBJ): %.o: %.c $(HDRS)
 	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
 
-$(SOBJ): %.so: %.c $(HDRS)
+$(STOBJ): %.o: %.c $(HDRS)
+	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@
+
+$(SHOBJ): %.so: %.c $(HDRS)
 	$(CC) -c -fPIC $(CFLAGS) $(CPPFLAGS) $< -o $@
 
-libfsverity.so: $(SOBJ)
-	$(CC) $(LDLIBS) -shared -o libfsverity.so $(SOBJ)
+libfsverity.so: $(SHOBJ)
+	$(CC) $(LDLIBS) -shared -o $@ $(SHOBJ)
 
 clean:
-	rm -f $(EXE) $(OBJ) $(SOBJ) $(LIB)
+	rm -f $(EXE) $(OBJ) $(SHOBJ) $(LIB) $(STOBJ) $(STATIC)
 
 install:all
-	install -Dm755 -t $(DESTDIR)/bin $(EXE)
+	install -Dm755 -t $(BINDIR) $(EXE)
+	install -Dm755 -t $(LIBDIR) $(LIB)
+	install -Dm644 -t $(INCDIR) $(INC)
+
+install-static:static
+	install -Dm755 -t $(BINDIR) $(STATIC)
 
 .PHONY: all clean install
-- 
2.25.3

