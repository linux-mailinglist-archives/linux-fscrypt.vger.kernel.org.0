Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFA1298B90
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772018AbgJZLPQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:15:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33874 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770824AbgJZLPN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:15:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id i1so11956930wro.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZTyAMmczLe7CAXzczFdNNsQ77+AolFm/xGWo/sGNFp0=;
        b=uMpPvGT7iWm9aF16lo1I0MiCE9k0XA0wGODionjVirIba88piIim8zyXKeLH+LAL/0
         fLAqF0slmHjDgYXuhaZJHhcmfyIXK4tIlyFxEp96J201iF3BgIvGZvN1GOXSxvFwGR40
         qTh30QpxU0ydbyAy1WbP+6cT4y2gnYTCM0pou2eusrw75UY0cWkqJyoBf+bSoC8Aa+M9
         MEqvpFRTWygkI098XurzUG28gNs0ju6to0z3xZMX6167HYQiJTtQxY0Grt2Sz22x2/S9
         HBuBdLznTSQQBXlk339A2c3tE2mbUP4bC8qu0Oq8sqet4CJj5bCAp5NzGUZ/cefxspEH
         w4Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZTyAMmczLe7CAXzczFdNNsQ77+AolFm/xGWo/sGNFp0=;
        b=kh9PJzOuMyVW++ND8wzNemCMh0hYqSzPle5TU+5bouoXJLYsMkDHo1HsqoGOsexE2C
         Ev4EJBmsma/aF9pc5lTOaw507oGhuE8zc0Zd3vSOxemMrK/f3QJ7Nl09H6fmMcNCWfsI
         mN83am2bC63Kb7zmzqXxnI3hYHg34x/KLwl1CHtHTVvsn7AamlU2hlXpdIr0XfUXcUnG
         FFSJL+QddttNhpcIFWnYIe1WwNx21NiIlVeeyC4/H+w7YjoG1b2cOqbHKevw3InHy5UT
         NNRgRwBPBhr7UfZ9vpIAdm4M9x6vJae2VGagxEqbPZ6o1nm1gTEJD8Xbvdtvf0Al9t3V
         IwnA==
X-Gm-Message-State: AOAM530MRuO3pybcZ/KT10iKJf7Zu2K2pIPhQ8PWdcgC1L96bNUeXweq
        N69TU6kCf3bSh4NLpjUEyo3UbqFv6LLdvf6H
X-Google-Smtp-Source: ABdhPJz8clXq32kcfxWuUjcfB7XMYLaxcogQCwMpavxHaPlQsDJ6qe7T80mBgTQkAg3PvwJO6ngkTQ==
X-Received: by 2002:adf:d849:: with SMTP id k9mr16517054wrl.332.1603710910738;
        Mon, 26 Oct 2020 04:15:10 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id b190sm20729377wmd.35.2020.10.26.04.15.09
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:15:10 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH v2 1/2] Use pkg-config to get libcrypto build flags
Date:   Mon, 26 Oct 2020 11:15:05 +0000
Message-Id: <20201026111506.3215328-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022175934.2999543-1-luca.boccassi@gmail.com>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
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
v2: quote PKGCONF in shell invocation

 Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3fc1bec..d7e6eb2 100644
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
+LDLIBS          := $(shell "$(PKGCONF)" libcrypto --libs 2>/dev/null || echo -lcrypto)
+CFLAGS          += $(shell "$(PKGCONF)" libcrypto --cflags 2>/dev/null || echo)
 
 # If we are dynamically linking, when running tests we need to override
 # LD_LIBRARY_PATH as no RPATH is set
-- 
2.20.1

