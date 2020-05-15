Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC151D5B16
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 22:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgEOU5D (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 16:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgEOU5C (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 16:57:02 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF097C061A0C
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:57:02 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id p12so3166377qtn.13
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RuNRJWNwA74uNUnzUcv/eXSAijrPS6rK3ng2jdkstk=;
        b=GltVYFncGE9IT7NoqT/J4F3NxYr13hmfF81L36wLW1MGCQea8XqHUylEsd0aRlrZo3
         a1/8/S7fqRFB7oAgZeZhDn7J9NVB7GlSVrEWa4bOVEI5oROzX6Jju5+2dte+fKIwfDfn
         rNMtgwlAq14droKVpX8nv7jMtAiprnwBM6f/YCD4jRQddWnDe4Z/9iCC+U0Zr+VZIxF4
         fVlZe9EeD9TA5pa7n/peF8ZdSth1IOumsZjg0+rgbq43LqSsbozsdjDzFe8OGYRES54y
         zLLPSYe9rDA9oHrPEJ+pJQJ3+sKyRkG97r97h97W4QzZk10vgTHfEhtLCFDK3/+sd0fi
         HNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RuNRJWNwA74uNUnzUcv/eXSAijrPS6rK3ng2jdkstk=;
        b=WWfSfDLCkUk9GRYFi3c6+eWUIyf0uqLrHcFjXynhaROwnhaPQiD6xecJz83JJ4Km0T
         6ujkmjOWEVtQ0oG968WWrkANwi00E+UHu2OjTq+vz7KFqs4Vy5eAwyMJvQsW5cG9/1rh
         0lLanXRqQ/heSIrn21Re6zT8OT8lRyuyCEDtSOL0qnQ1u1TT1R1rOxfE+gEMXOif9p1u
         22Vipj+l6xfzR00LIFQ29TzH/joIiWRYhPilV4CunTJQULxN2uklDE765UcnQUSIg3T5
         7zywWwUB8gt4RW0/u0KTA3THWzb1AOW56xovY4m+N829wzFlbh7Y7jiUiJGuw7NMQ2TO
         z1Yw==
X-Gm-Message-State: AOAM531pfbh6VFntOhFAGRpJnWZ4Ld6TRtRJ1Bb0NZTgEjHHtw2SuLqV
        5Dy3jyiZdlLP7n9+eEnoQp8=
X-Google-Smtp-Source: ABdhPJyoKYkeM72u2Vb8nPIdsfD2IkSrvVhf4YnqBKJgQO7xKUgT8op7AzLi+rhyeIrem0R9AK+nAw==
X-Received: by 2002:ac8:4e44:: with SMTP id e4mr5536433qtw.326.1589576221852;
        Fri, 15 May 2020 13:57:01 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1b31])
        by smtp.gmail.com with ESMTPSA id r18sm2850467qtn.1.2020.05.15.13.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:57:01 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
Date:   Fri, 15 May 2020 16:56:49 -0400
Message-Id: <20200515205649.1670512-3-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
References: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
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
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index c5f46f4..0c2a621 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,7 @@ cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
 #### Common compiler flags.  You can add additional flags by defining CFLAGS
 #### and/or CPPFLAGS in the environment or on the 'make' command line.
 
-override CFLAGS := -O2 -Wall -Wundef				\
+CFLAGS := -O2 -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
@@ -40,7 +40,7 @@ override CFLAGS := -O2 -Wall -Wundef				\
 	$(call cc-option,-Wimplicit-fallthrough)		\
 	$(CFLAGS)
 
-override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
+CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
 #### Other user settings
 
-- 
2.26.2

