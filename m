Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C191B8144
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDXUzo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:43 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71263C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:42 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x12so8606832qts.9
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tetmpQ4ePo2sOvByDjpkXQDJmQ/mYec0kUqQ4ORD5xs=;
        b=X3JwNUX35D4je79hsdxO8vUhyhHhqp9KaBmwcgpagTd4CKYZi591O9v6ZIZst17KIH
         8Om7L8r1+sqwEf4t5H6C3IG3lQ84qn3PHuTQoAQLlFIdFtdWU/CPPB8gkHPC4KZql2de
         bvlBCRwnIJt+KCsYG43bseI2czaSvkUtKoC2H0bHBy8Z4JWTleFtkmDSJxRH3rifL9qf
         s7E+EmEpR/eGVfCiEtA6DBjn4hizTbqvuHS6VFoFho7yRPOL5jgGkbNWl6+z50UHkx0T
         ZktooGKJzYThOZOTqzl9uq85uiM724QU9Rf99MniWzJ0dK3nofDrb3YCP8y09hilH+TX
         sYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tetmpQ4ePo2sOvByDjpkXQDJmQ/mYec0kUqQ4ORD5xs=;
        b=anEunSpquGZeL/i6Z5MJ011O0ThAxTZ/UIUWxr+Wmp9jlvazg3J9B6QCadfWWk+SCU
         GtIr2PWgqdf7/2KhGLEMO+TozVa1sb5uHnvKIvl9oZ0LIjwjlKaCqfGxZDlDnrsc1nYH
         9GGP4janLPOT3mhobmPSkEdrLCUPut+EQQDwaz7ctZMdf4hv6hC6CHobW2/lmiTV52Cj
         EmR67f0K2Pbd5fTfwuH1p6uoVCUsXvzk3zDFHAvVNQy83ltrw+mjPGdB3lk/3hKWgWIr
         9MAu9CqHEhiR8QWN1utyXRmG08bz7Sw9cFKF+wHvr7+7I1mVt2QvDH+CHGDUJYp37cdO
         71Hg==
X-Gm-Message-State: AGi0PubW/tiqQRLgCqKLnCphEMQ0pEC4GRDN9w1AU/IHUzqxfccjnQpt
        j6DxavnFm02j8K06PuC3yMvi1B6wZcs=
X-Google-Smtp-Source: APiQypKBvEjpoH1XnDWjMsNOXHgdIOEsgucqBfyP7uFMcbA1nH2anG2qDuarOoyjBf5v6p7mPQrU7w==
X-Received: by 2002:aed:3aa3:: with SMTP id o32mr11798127qte.364.1587761741298;
        Fri, 24 Apr 2020 13:55:41 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id o201sm4533728qke.31.2020.04.24.13.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:40 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 20/20] Fixup Makefile
Date:   Fri, 24 Apr 2020 16:55:04 -0400
Message-Id: <20200424205504.2586682-21-Jes.Sorensen@gmail.com>
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

Set soname for libfsverity, install shared library and header file,
and make clean handle shared library too.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 5bbcd87..0b82c82 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,5 @@
 EXE := fsverity
 STATIC := fsverity-static
-LIB := libfsverity.so
 INC := libfsverity.h
 CFLAGS := -O2 -Wall
 CPPFLAGS := -D_FILE_OFFSET_BITS=64
@@ -15,12 +14,17 @@ SSRC := libverity.c hash_algs.c
 SHOBJ := libverity.so hash_algs.so
 STOBJ := libverity.o hash_algs.o
 HDRS := $(wildcard *.h)
+LIB_MAJOR := 1
+LIB_MINOR := 0.0
+LIB_SO := libfsverity.so
+LIB_SONAME := $(LIB_SO).$(LIB_MAJOR)
+LIB_FULL := $(LIB_SONAME).$(LIB_MINOR)
 
 all:$(EXE)
 
 static:$(STATIC)
 
-$(EXE):$(OBJ) $(LIB)
+$(EXE):$(OBJ) $(LIB_FULL)
 	$(CC) -o $@ $(OBJ) $(LDLIBS) -L . -l fsverity
 
 $(STATIC):$(OBJ) $(STOBJ)
@@ -35,16 +39,21 @@ $(STOBJ): %.o: %.c $(HDRS)
 $(SHOBJ): %.so: %.c $(HDRS)
 	$(CC) -c -fPIC $(CFLAGS) $(CPPFLAGS) $< -o $@
 
-libfsverity.so: $(SHOBJ)
-	$(CC) $(LDLIBS) -shared -o $@ $(SHOBJ)
+$(LIB_FULL): $(SHOBJ)
+	$(CC) $(LDLIBS) -shared -Wl,-soname,$(LIB_SONAME) -o $@ $(SHOBJ)
+	rm -f $(LIB_SONAME) $(LIB_SO)
+	ln -s $(LIB_FULL) $(LIB_SONAME)
+	ln -s $(LIB_SONAME) $(LIB_SO)
 
 clean:
-	rm -f $(EXE) $(OBJ) $(SHOBJ) $(LIB) $(STOBJ) $(STATIC)
+	rm -f $(EXE) $(OBJ) $(SHOBJ) $(LIB_SONAME) $(LIB_SO) $(LIB_FULL) $(STOBJ) $(STATIC)
 
 install:all
-	install -Dm755 -t $(BINDIR) $(EXE)
-	install -Dm755 -t $(LIBDIR) $(LIB)
-	install -Dm644 -t $(INCDIR) $(INC)
+	install -Dm755 -t $(DESTDIR)$(BINDIR) $(EXE)
+	install -Dm755 -t $(DESTDIR)$(LIBDIR) $(LIB_FULL)
+	ln -s $(LIB_FULL) $(DESTDIR)$(LIBDIR)/$(LIB_SONAME)
+	ln -s $(LIB_SONAME) $(DESTDIR)$(LIBDIR)/$(LIB_SO)
+	install -Dm644 -t $(DESTDIR)$(INCDIR) $(INC)
 
 install-static:static
 	install -Dm755 -t $(BINDIR) $(STATIC)
-- 
2.25.3

