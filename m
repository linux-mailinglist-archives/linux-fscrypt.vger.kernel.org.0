Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA5822E034B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 01:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgLVALV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Dec 2020 19:11:21 -0500
Received: from mail-wm1-f46.google.com ([209.85.128.46]:35839 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgLVALU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Dec 2020 19:11:20 -0500
Received: by mail-wm1-f46.google.com with SMTP id e25so536905wme.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 21 Dec 2020 16:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hA0Cci1G8EREt6KjplqDMKv0tTZuCmxEh8FYxxZT8Cw=;
        b=UBbutpscAJxeJPNXYOmkBf2P+RAGJS9AhTSZu5a+qhFVBr2iJLO+TIq6QJgkeDZMHc
         O2W3ZXp/o4MAS2WaIl3NrFJwyLoBblLp33SciyMvORrR3d0mDRshQoxibFhfWNHtGTL3
         6CpCObhNoSnaOgYS7vsy+0KG2djEXPwGjuM5KyXp43ggLgdfdZVnoIEGTVzoWuClnZGR
         KmH3/DreN3RJS2H4lsejvSnmPbEbfve6jM+uzkC7ajOa6Ie+2VLoPr4Uql3VZYl0xKZc
         ja8k4juLUcS1lE7IScQdyz+LJGQ6j+u3E+leKZFiaJGLIvQ/dM+k3Qazjkq9T+E9NusZ
         7iWA==
X-Gm-Message-State: AOAM530ZbiPlFnVhO6OQixb/uZxogQXHP5K/DTF6fRj1KePiOx3F+R3H
        AbOnnQVmokTHuOGkXmiIQA0YxaYOyghQV8J3
X-Google-Smtp-Source: ABdhPJxWGi2yx4z975f4/4y9uafEkwhWOw1fR3tFqvepp0GiELdu6oUc8YUkKgDm6VYgQ3I52zuK/A==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr19274247wmj.61.1608595838572;
        Mon, 21 Dec 2020 16:10:38 -0800 (PST)
Received: from localhost ([2a01:4b00:f419:6f00:e2db:6a88:4676:d01b])
        by smtp.gmail.com with ESMTPSA id l5sm29127844wrv.44.2020.12.21.16.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 16:10:37 -0800 (PST)
From:   Luca Boccassi <bluca@debian.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [PATCH v7 1/3] Move -D_GNU_SOURCE to CPPFLAGS
Date:   Tue, 22 Dec 2020 00:10:31 +0000
Message-Id: <20201222001033.302274-1-bluca@debian.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201221232428.298710-1-bluca@debian.org>
References: <20201221232428.298710-1-bluca@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Use _GNU_SOURCE consistently in every file rather than just one file.
This is needed for the Windows build in order to consistently get the MinGW
version of printf.

Signed-off-by: Luca Boccassi <bluca@debian.org>
---
v6: split from mingw patch

v7: adjust commit message and add CPPFLAG to run-sparse.sh as well

 Makefile              | 2 +-
 lib/utils.c           | 2 --
 scripts/run-sparse.sh | 2 +-
 3 files changed, 2 insertions(+), 4 deletions(-)

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
diff --git a/scripts/run-sparse.sh b/scripts/run-sparse.sh
index 30730b2..f75b837 100755
--- a/scripts/run-sparse.sh
+++ b/scripts/run-sparse.sh
@@ -10,5 +10,5 @@ set -e -u -o pipefail
 
 find . -name '*.c' | while read -r file; do
 	sparse "$file" -gcc-base-dir "$(gcc --print-file-name=)"	\
-		-Iinclude -D_FILE_OFFSET_BITS=64 -Wbitwise
+		-Iinclude -D_FILE_OFFSET_BITS=64 -Wbitwise -D_GNU_SOURCE
 done
-- 
2.29.2

