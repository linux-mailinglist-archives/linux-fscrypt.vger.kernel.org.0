Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24961299831
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 21:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgJZUsi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 16:48:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33771 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgJZUsi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 16:48:38 -0400
Received: by mail-wm1-f68.google.com with SMTP id l20so5993576wme.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 13:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFyME1deOv824ukog0edYolw0aSNXXmoJhahn8rEYEk=;
        b=driSq2l7A0Q96mGzA5AYQ8fzY1/eQ6xU6AkR6/GC3OMEs43LPmzDucEOOavPeyXuTn
         l/d57gOT7LHyRB014rKtPbJ+O+1EosAvsLuXoDPfdq9CQ+76Sk4cEUxegaGL9UxOxfnj
         kF2bP/t0IJFhnDFZda4mRkgjVGRzuMZnH65qTbFuE1Tq59CWnAnCoEQaduz0x2jouMt8
         08XnRmw8SUthyi1nqpunIJaCwUKJsWc+CUXoAjRxuOJkiAzQLKstteAocOffti+N/t4F
         m8KForLafaFaJqmV7sUBWLgFTcVqmHe8zV1KdXot5OIFVxTcyy9azNmDB1i2Yq5S9M2j
         e68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lFyME1deOv824ukog0edYolw0aSNXXmoJhahn8rEYEk=;
        b=UrLtJ+5FOXBFOzIe3e3fnnDGDa8cBIFHcRr2JT2K+tytdwD2xpfAhxYMVthN8mlQJF
         pg2VSZlj/Cr4UDv4KHeM6iqvCdqto09dBhoxrE1x/brNYWAfTX6Od0bShcqEcYIMMK64
         kXm7DKnf89ur+Be6oBMEEqZPFtDn1JzDoZoD4tvq5uvVUW2htkSCQ0EVSdxoBEBCeDv6
         GQZFZeVgx7WBUmiHo1Um/R1a2+ccZQtn+NERTgMw3lpfUvtPIqsqNLNk4omkVEIF4Cle
         gsQim0J91dIx5u4LHHifQY+zb3XbLhqKUgYdF6J2/SLMiO44q+G5kXnhEl2fGHDHNA6B
         mCVg==
X-Gm-Message-State: AOAM532pwazU4i39QzrqjrY+9rk6NYI6yqJQMeCU/W0tjlacd83J+4Ph
        tNtDVKtJfmt+XfxHrc5DKXsAZ+mQb3Osag==
X-Google-Smtp-Source: ABdhPJwbH9Vihd13RfAWRhAUm27YtDo7JTjsBDXvqyoMP2RWq2MCMJBUULSkx7gD96hbLhpnkhfdnw==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr9477425wmb.51.1603745314542;
        Mon, 26 Oct 2020 13:48:34 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id x65sm23573854wmg.1.2020.10.26.13.48.33
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:48:33 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH] override CFLAGS too
Date:   Mon, 26 Oct 2020 20:48:31 +0000
Message-Id: <20201026204831.3337360-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Romain Perier <romain.perier@gmail.com>

Currently, CFLAGS are defined by default. It has to effect to define its
c-compiler options only when the variable is not defined on the cmdline
by the user, it is not possible to merge or mix both, while it could
be interesting for using the app warning cflags or the pkg-config
cflags, while using the distributor flags. Most distributions packages
use their own compilation flags, typically for hardening purpose but not
only. This fixes the issue by using the override keyword.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
Currently used in Debian, were we want to append context-specific
compiler flags (eg: for compiler hardening options) without
removing the default flags

 Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 6c6c8c9..5020cac 100644
--- a/Makefile
+++ b/Makefile
@@ -35,14 +35,15 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
-CFLAGS ?= -O2 -Wall -Wundef					\
+override CFLAGS := -O2 -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wimplicit-fallthrough)		\
 	$(call cc-option,-Wmissing-field-initializers)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
 	$(call cc-option,-Wunused-parameter)			\
-	$(call cc-option,-Wvla)
+	$(call cc-option,-Wvla)					\
+	$(CFLAGS)
 
 override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
-- 
2.20.1

