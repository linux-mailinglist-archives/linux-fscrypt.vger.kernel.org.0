Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C246B2E02E5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 00:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbgLUXZW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 18:25:22 -0500
Received: from mail-wm1-f42.google.com ([209.85.128.42]:54649 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgLUXZV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 18:25:21 -0500
Received: by mail-wm1-f42.google.com with SMTP id c133so399787wme.4
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 15:25:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c6F8Nxi9NAppdTvoid1gWxkFwsaXCdjWsyAsEsUjDJY=;
        b=oDrFN7d9yNKYNFe3tSGCxp1u3BTDWmgyHE0KwWs1eRs9BIg4bPV3whzOCat2PxezqP
         FsM8OMEVYnnGv4RERDRM+O3SOVk809ivKAgX7A60TCT7nuAyJcCV8kprSGTMMrcUxzGM
         Voh9w0hNsZBAgm3QfClh5ZfRn2Nna13wn6ahHzAMsTL4hMqOpr31Z870i30XoLRBeDxU
         44hq8mg+0KmU/83jDZqoYe3KEjoKr801EIcuuevwY0TXdEhB8ErFJX6e3C6wyv/orTxU
         DH80fwSKpi8f5mwsjxY8QSgpQUHMV21bnwoAsFIf2DUAJ5moF5liKhchJSoZK89Hr/xB
         Xy6Q==
X-Gm-Message-State: AOAM531iMV5veJ4VCdAXzhff8ye/1q6TURJ4ybP7u1iw4XHRMtQwlN7M
        BblfDCEF/1xSaB33gUF+bGkN+8akcXfisjXN
X-Google-Smtp-Source: ABdhPJxmoJCfzctHfYKpoNxmDqYR+cvw7Jwk9tKkTbVidvdEtbVxI4s2OMU+uTOKr8mYTDGSVaUQAg==
X-Received: by 2002:a1c:17:: with SMTP id 23mr18498394wma.35.1608593079427;
        Mon, 21 Dec 2020 15:24:39 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id u66sm25078525wmg.30.2020.12.21.15.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 15:24:38 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, Luca Boccassi <bluca@debian.org>
Subject: [PATCH v6 1/3] Move -D_GNU_SOURCE to CPPFLAGS
Date:   Mon, 21 Dec 2020 23:24:26 +0000
Message-Id: <20201221232428.298710-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221221953.256059-1-bluca@debian.org>
References: <20201221221953.256059-1-bluca@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Ensures it is actually defined before any include is preprocessed.

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v6: split from mingw patch

 Makefile    | 2 +-
 lib/utils.c | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index bfe83c4..f1ba956 100644
--- a/Makefile
+++ b/Makefile
@@ -47,7 +47,7 @@ override CFLAGS := -Wall -Wundef				\
 	$(call cc-option,-Wvla)					\
 	$(CFLAGS)
 
-override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+override CPPFLAGS := -Iinclude -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE $(CPPFLAGS)
 
 ifneq ($(V),1)
 QUIET_CC        = @echo '  CC      ' $@;
diff --git a/lib/utils.c b/lib/utils.c
index 8b5d6cb..13e3b35 100644
--- a/lib/utils.c
+++ b/lib/utils.c
@@ -9,8 +9,6 @@
  * https://opensource.org/licenses/MIT.
  */
 
-#define _GNU_SOURCE /* for asprintf() and strerror_r() */
-
 #include "lib_private.h"
 
 #include <stdio.h>
-- 
2.29.2

