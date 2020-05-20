Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE3C1DBFE4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 22:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgETUI0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 16:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgETUIZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 16:08:25 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66588C061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:24 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id l3so1985581qvo.7
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ej7IfQ9U14w8+MU2Zh5Ht3olzt3sfcIyqeVkaMN4yhI=;
        b=c0ZBGcEb/2j+mXFhAKDOO+U9CzerE6VpWgfmWm/NEvmEWO/Q1s3xH73n7cHapPhfLB
         JAIGZZtWMdiOww2gAgJWJYHBXRSEuPXalwXIRNH5Avr2dQZsh4mtA6MQqOV2XmwUS6+X
         yjTMNVutkq/0d/HWS1a3NufFgq1PUIjYvu3ez/MuqI2wktEy+5p3ndj+5pn5q5qHXDMi
         kAq+ypU/EvQkRRBEj1AiF9kyK/J2HzSe3RmSeLXzctNLUN4r9Obz/Wkhq2D4LxpAybSX
         5XM0NzPuQK5CHuLrbckBIvZNpHqe7RR2XDbaPCc3ac9lmnuvYB7E6G+SljImKe2aj7Sw
         jO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ej7IfQ9U14w8+MU2Zh5Ht3olzt3sfcIyqeVkaMN4yhI=;
        b=oLeAmsmORxLv5BLqmdlg1laEsg2yGsbuyvYzT3CjdRNgK3sPBbjeuYutKvU9CqWuPZ
         VHurgm8YPTpgg37FRpq/OlY1UFvB4vDeMW/ksKhEk1W6LwYEHrI2GpAOJIQZm5C+ATQK
         Z9SmmN1iaXtcpKw7kiN7M5lh4oJSjCSuyJcn30IXg3gLqYC+8Gl/G/6RxTI8o5zF0a9A
         K5RxOgAHZCTJtYAA6Zahr3TD8qs1/9yTdrwU0CW8pJ495WKiZU3f6JeO2YV6AaLYVDHl
         ozqOHDcEawQnCYBNs+MCoO/4Ij4JWV7UDnjMnuVWrkPXEkOqKEWcISIykO4uEt7kvCtS
         Fu2g==
X-Gm-Message-State: AOAM530CeGLISIsdoqjbfG46KtJyuGDpnZo4mQ5AVFCNKL6rCqgrdl2W
        D5Vz35SQXmWK5GJs4zOqJIFneY79
X-Google-Smtp-Source: ABdhPJx+eMXhkJuUQNxM/wMY03PP9oBrLNX+lJEVMFLVcU6vLxFfjsrg2YjpjAlSN7UOeSHVdqwQkQ==
X-Received: by 2002:a05:6214:506:: with SMTP id v6mr6816112qvw.70.1590005303577;
        Wed, 20 May 2020 13:08:23 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id m7sm3147891qti.6.2020.05.20.13.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 13:08:22 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
Date:   Wed, 20 May 2020 16:08:11 -0400
Message-Id: <20200520200811.257542-3-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Package managers such as RPM wants to build everything with their
preferred flags, and we shouldn't hard override flags.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index e7fb5cf..7bcd5e4 100644
--- a/Makefile
+++ b/Makefile
@@ -32,15 +32,14 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
 #### Common compiler flags.  You can add additional flags by defining CFLAGS
 #### and/or CPPFLAGS in the environment or on the 'make' command line.
 
-override CFLAGS := -O2 -Wall -Wundef				\
+CFLAGS := -O2 -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
 	$(call cc-option,-Wvla)					\
-	$(call cc-option,-Wimplicit-fallthrough)		\
-	$(CFLAGS)
+	$(call cc-option,-Wimplicit-fallthrough)
 
-override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
 #### Other user settings
 
-- 
2.26.2

