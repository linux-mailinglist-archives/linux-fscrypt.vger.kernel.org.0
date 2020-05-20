Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8881DC156
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgETVZz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbgETVZy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:25:54 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53F3C061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:53 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id z5so2127315qvw.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 14:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PqsqAu5lsFhOj/AMiszBjX6fyFnwkUzaKwOQ2nPGeQw=;
        b=C/nwJFQvxbdU86rM8PnQ+3CdlPSKS2SuyMclhkDw3dB/DFVo9TL//+u/jMnfNJxYza
         shmPzmlHGh/GawcdQegurIgoKAi26AYudft3VMf0RRQt+TNdL0YzKqLUWK9LxXHDSwlb
         SNCSFXf0skT5DOjmBu31mBbdrsgeIjzv1lnYjBizDi6c89joyDZoczpveZtdVub/MW3i
         1+PmyjVSP3Omkaen7Xhn4ZVUMHbz9yJMGJq9tXUyfvsLlDjueYsY7W8JohTOpkvUca2K
         bCe8bufOWxzKb9eb6fBKxUNELs2JzZlsqt4abXE3E3wT2JcqgSbEtEJJjiwvrl1bxP2S
         yYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PqsqAu5lsFhOj/AMiszBjX6fyFnwkUzaKwOQ2nPGeQw=;
        b=kcST6UyfHYZ3Za/PFXBl05+24iX6+RpScrlM4o3kwwLHfeog163orvOMfN2pU6kfBI
         Qy8W3XPtElcnhL7rCaVUG1xVLylMHB8Iu49LFM8Dn5q1/ZMow0yYFOAzTDfni5RTN/P/
         hbciBXDm3CKvnfSIvDd1leAfQZ6iXvHFtRcj0Tjh+u58nfAY+0rin/BOCNfeykc7IAVB
         xIHDPWmZP0+iH3z6+dEUyTYKsAcYeaQHrCot7z20krmva/h9gCm/fMKMK1td4Mrd9xke
         cQPTncIR1SgUnyKm2jjFiO2fffUMjI+QkyjB+2tZt9URQXnPluBYnzj8rbFYC/ga1zdx
         YBng==
X-Gm-Message-State: AOAM5336TMZI/AjLRvwn5GNDUjnqSiuGyL6P6XlE/V5WL2hb7VCw2Df3
        Jrwj3dMI3VXuZHy+Ngt+ZRA=
X-Google-Smtp-Source: ABdhPJyM7ptytey9m2FaPikKKWtj0N8gzQIC860H+7QD1a00/DlqzDUDLOw9yqFVCsQd8HjDUZiePg==
X-Received: by 2002:a0c:906e:: with SMTP id o101mr6989028qvo.180.1590009952816;
        Wed, 20 May 2020 14:25:52 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id 5sm3230945qkl.101.2020.05.20.14.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 14:25:52 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 2/2] Let package manager override CFLAGS and CPPFLAGS
Date:   Wed, 20 May 2020 17:25:40 -0400
Message-Id: <20200520212540.263946-3-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520212540.263946-1-Jes.Sorensen@gmail.com>
References: <20200520212540.263946-1-Jes.Sorensen@gmail.com>
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
 Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index e7fb5cf..18f08c3 100644
--- a/Makefile
+++ b/Makefile
@@ -29,16 +29,12 @@
 cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
 	      then echo $(1); fi)
 
-#### Common compiler flags.  You can add additional flags by defining CFLAGS
-#### and/or CPPFLAGS in the environment or on the 'make' command line.
-
-override CFLAGS := -O2 -Wall -Wundef				\
+CFLAGS := -O2 -Wall -Wundef				\
 	$(call cc-option,-Wdeclaration-after-statement)		\
 	$(call cc-option,-Wmissing-prototypes)			\
 	$(call cc-option,-Wstrict-prototypes)			\
 	$(call cc-option,-Wvla)					\
-	$(call cc-option,-Wimplicit-fallthrough)		\
-	$(CFLAGS)
+	$(call cc-option,-Wimplicit-fallthrough)
 
 override CPPFLAGS := -D_FILE_OFFSET_BITS=64 $(CPPFLAGS)
 
-- 
2.26.2

