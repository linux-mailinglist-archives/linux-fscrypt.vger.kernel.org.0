Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2AC29E715
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Oct 2020 10:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgJ2JSe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Oct 2020 05:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2JSe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Oct 2020 05:18:34 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C452C0613D2
        for <linux-fscrypt@vger.kernel.org>; Thu, 29 Oct 2020 02:18:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id d3so1705994wma.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 29 Oct 2020 02:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bkf0x3SdMsV2YAUzBpqK0tSl48sC0rxnzLzMb5QwVA=;
        b=XgCW1BRZV4F555otPkrY3YazkQk+uZ+74VQLIQplJZVvk+2FvUeTPK6zCWlflbZRFM
         kq/9tEdBnLf+uAnvBdQy1uYwm6n/s4EftE4oTm3QeB7Mm+4iTwnnMG/ZGTsdoA6VPLIM
         0feI/qvXRRADHMRnk0l5wOVbNY5lD6ukDotBxrOKIM2b7CK9hgO5/9Uzby/ZuQNqlUZE
         tGUP+SvkILnQCerhnIuLOnGk7998LLiNf7OmYKUihKu8DQziRsNZNpbKUvVIaLQm6nId
         RRmIHTbLcBVL7a/x49g0Qm4P4xnZvTpfzRSEbeu/3UdHAIiAGnyu767qYsr+xJZ+Gd8T
         rdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bkf0x3SdMsV2YAUzBpqK0tSl48sC0rxnzLzMb5QwVA=;
        b=ofRMpvvk9JBvwzVIC5/LiXWNXDxO0td5FKEE9XdTzlscSYrC9vLw+cYnDCMssP3cPR
         xixvVnyE8q1pHwhYP6bECJoZv+0IPJUQtE3gkNMLz7yOaZFApcbsW9P+iE2vdAPgNkdL
         ebNNNOAjwy49vxnGRqNXo0xhQz/Mwni0mHGRwuVPtKL4tVCmNBMONa7RQgjw/fHzin0D
         TDDO1l7VjTvNw66AAb8grhtCoi6/RmfaltDLx8B4zpoCe2Wi0q/D/AzNPfppKfvTyEwt
         MFDkKgmYjiQWdzR4dbiFz5x3n60yhk7SFdQSIIvkN77acXza0+pFzs0mDYKNINLiZVt/
         +YUQ==
X-Gm-Message-State: AOAM5315CuMl16JY4Etcoxw0/us364U0aKzDqKjPGAw6K2O0AwinQzrb
        sZITvMv8Ss/uAPro23yovFB9C1gSIAK0rfu8
X-Google-Smtp-Source: ABdhPJyiwwet1dxxrghGekBMq++XlnIsRL8M2jhr4cT09qP3PGk//H0vceiKiw2qwqBMcWJKinySPQ==
X-Received: by 2002:a1c:f417:: with SMTP id z23mr3092133wma.57.1603963110773;
        Thu, 29 Oct 2020 02:18:30 -0700 (PDT)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id v67sm1901353wma.17.2020.10.29.02.18.29
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 02:18:30 -0700 (PDT)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Subject: [fsverity-utils PATCH] Restore installation of public header via make install
Date:   Thu, 29 Oct 2020 09:18:27 +0000
Message-Id: <20201029091828.3680106-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Fixes: 5ca4c55e3382 ("Makefile: generate libfsverity.pc during 'make install'")

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
I think this was removed by mistake? After the linked commit make install
does not install the header anymore

 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index a898ed4..bfe83c4 100644
--- a/Makefile
+++ b/Makefile
@@ -206,6 +206,7 @@ install:all
 	install -m644 libfsverity.a $(DESTDIR)$(LIBDIR)
 	install -m755 libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)
 	ln -sf libfsverity.so.$(SOVERSION) $(DESTDIR)$(LIBDIR)/libfsverity.so
+	install -m644 include/libfsverity.h $(DESTDIR)$(INCDIR)
 	sed -e "s|@PREFIX@|$(PREFIX)|" \
 		-e "s|@LIBDIR@|$(LIBDIR)|" \
 		-e "s|@INCDIR@|$(INCDIR)|" \
-- 
2.20.1

