Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D915915865C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBKABJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:01:09 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33883 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKABJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:01:09 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so4521286pfc.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=54BSlm+xY77Fsoq/IY3AfoejUu+eGYmqNFBZz8JILFE=;
        b=sgeuALDWDoE5eglUOlZqWoc6Jy3ZTz95pVumxMPXX5eZhBoEfRdZF27COvsu/o4rMA
         kf5I4UKVPJPslW/WadsJMqFMzxbV2ZKSw/KbiSrN0sS96EEy6sLf0myzhPY4mOJUNz+f
         tbpe1f/trTllY/sjaIe+9YklAQKK5JS4qGErLoKSMVqNT1zIg+HMn11GmGamMz761h8u
         4XFPStLNHtTPdhL7ICUT7A3Bi97QNQpe/hQL2dWaiTR1ifiYCsW+gfVuhh8L/OYk68Gn
         rjrd0sgpjH10HfWqky0HhIcHRCygcENIhd77A8FXraghqxXi3YLzFJw5d1kQTcmc/Dmm
         i6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=54BSlm+xY77Fsoq/IY3AfoejUu+eGYmqNFBZz8JILFE=;
        b=JkhjiK6uo7+S+PrqtpJpZUrcF1uSlvErMGrF8MHuhXNRI9AKKH48V1rt8umJ3BxSi2
         KdLPVKA0vUt19dCwDW0EH5h3b2wcGsyR7pqD1BEegKsGjoFj5Lm3TdQJKJzU8YDPGyBk
         Ew/xqCDI81aiMKp6+QSNVVXmQ9KB08KLdFzB7swn3f1rFQh4pHdNsGuFbP/ftrfst002
         gZCLpJ6XRRXVVVyzhtK5zJCLrhbM1E8FWUFbS3lqaByRtE2s0KC/uqMufrWLBPQLCWRG
         I7EWJw+psOS4ThMtuXkwOQk+Ak2XPgJVVRjLrbZOABvuZlpbA7NBJv8QpiADafqszvQT
         JuIA==
X-Gm-Message-State: APjAAAVgWEOyR5U9YK9TGw6MjFRwC8cNEQs8FXWX+JTm/Vw0cctOUBdC
        aIISaCKtxhWELJtYtPizrSSp+mDx+Lw=
X-Google-Smtp-Source: APXvYqwhucg7xQdxsKwl03ma/hgwdju6QB62sxWcB1ZxeAVnHwXZkNlTnvDg781sNVEP0Ex+dWvhWg==
X-Received: by 2002:a65:5ccc:: with SMTP id b12mr4078625pgt.124.1581379268478;
        Mon, 10 Feb 2020 16:01:08 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id a9sm1541482pfo.35.2020.02.10.16.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:01:07 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 5/7] Rename commands.h to fsverity.h
Date:   Mon, 10 Feb 2020 19:00:35 -0500
Message-Id: <20200211000037.189180-6-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This is a more appropriate name to provide the API for the shared library

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_enable.c             | 2 +-
 cmd_measure.c            | 2 +-
 cmd_sign.c               | 2 +-
 fsverity.c               | 2 +-
 commands.h => fsverity.h | 0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename commands.h => fsverity.h (100%)

diff --git a/cmd_enable.c b/cmd_enable.c
index 8c55722..732f3f6 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -14,7 +14,7 @@
 #include <string.h>
 #include <sys/ioctl.h>
 
-#include "commands.h"
+#include "fsverity.h"
 #include "fsverity_uapi.h"
 #include "hash_algs.h"
 
diff --git a/cmd_measure.c b/cmd_measure.c
index fc3108d..3cd313e 100644
--- a/cmd_measure.c
+++ b/cmd_measure.c
@@ -11,7 +11,7 @@
 #include <stdlib.h>
 #include <sys/ioctl.h>
 
-#include "commands.h"
+#include "fsverity.h"
 #include "fsverity_uapi.h"
 
 /* Display the measurement of the given verity file(s). */
diff --git a/cmd_sign.c b/cmd_sign.c
index 2d3fa54..42779f2 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -16,7 +16,7 @@
 #include <stdlib.h>
 #include <string.h>
 
-#include "commands.h"
+#include "fsverity.h"
 #include "fsverity_uapi.h"
 #include "hash_algs.h"
 
diff --git a/fsverity.c b/fsverity.c
index b4e67a2..f0e94bf 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -15,7 +15,7 @@
 #include <getopt.h>
 #include <errno.h>
 
-#include "commands.h"
+#include "fsverity.h"
 #include "hash_algs.h"
 
 enum {
diff --git a/commands.h b/fsverity.h
similarity index 100%
rename from commands.h
rename to fsverity.h
-- 
2.24.1

