Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47938239D9C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Aug 2020 05:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHCDHp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 2 Aug 2020 23:07:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45848 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHCDHp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 2 Aug 2020 23:07:45 -0400
Received: from mail-pg1-f200.google.com ([209.85.215.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k2QpD-0006ud-H3
        for linux-fscrypt@vger.kernel.org; Mon, 03 Aug 2020 03:07:43 +0000
Received: by mail-pg1-f200.google.com with SMTP id 37so10971567pgx.17
        for <linux-fscrypt@vger.kernel.org>; Sun, 02 Aug 2020 20:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W1GE6wqqN+rCJI0MhCiEobfxq2p0EynBnBn9vrhNvY8=;
        b=k7XIw79SbwkEad/mNVmJMJVNpmAkbu6Da5Y5YKFjzxq872Fjs31FqcEylRXI6+vkr+
         ZnLEMo9lLRmSwrlGNYCLRlNuiylj3dNc91N0y46YXURiFJUm+HmS0zy+gg8O6fldwI4l
         RZE8da2mgMkGCyL+Afz3ZU55n6tqkp6+hUeJyn/+ODsXtF2yEcACa5hZRCoIzqruKSTI
         Q/TDze1MBzVVtccZGsZFHE7DGf93dZpm8URSpxVb6PVg370zK1+TLo4UM4xo41/IuvL4
         GMYyLx74DANKXeoPSygwQl8FkCPiTwyR/V4H706oKct9Cau1GOig7BjiYuO5gY0uQRxG
         d+5Q==
X-Gm-Message-State: AOAM5301tQjyx068SUkLWeeURreqwt5jihyTtSzDTj4qdGmeC3N5vpbd
        00uRKAgp5Dglyv8mMxSmR0XdbWHt0aqvaHI5CgRB9A7AQubhG7t0CI8dSPt5tsvc9VEFXCc6WrE
        IQ22WUCLOp1e6u0xoriXx5RrXV1+FhLIGDiTaVsLqEA==
X-Received: by 2002:a17:902:64:: with SMTP id 91mr13311051pla.62.1596424061920;
        Sun, 02 Aug 2020 20:07:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOOKYp0mB4myo88eCKcPAb/G8OzqiECgCT1gDxWSxEaVRDqtSi0pRZznzeTyiauT44Dx6kCg==
X-Received: by 2002:a17:902:64:: with SMTP id 91mr13311035pla.62.1596424061618;
        Sun, 02 Aug 2020 20:07:41 -0700 (PDT)
Received: from Leggiero.taipei.internal (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id a5sm17657943pfi.79.2020.08.02.20.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 20:07:40 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     po-hsu.lin@canonical.com
Subject: [fsverity-utils PATCHv2] Makefile: improve the cc-option compatibility
Date:   Mon,  3 Aug 2020 11:07:36 +0800
Message-Id: <20200803030736.6364-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
    cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’

This unsupported flag is not skipped as expected.

It is because of the /bin/sh shell on Ubuntu, DASH, which does not
support this &> redirection. Use 2>&1 to solve this problem.

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e0a3938..ec23ed6 100644
--- a/Makefile
+++ b/Makefile
@@ -32,7 +32,7 @@
 #
 ##############################################################################
 
-cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
+cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
 	      then echo $(1); fi)
 
 CFLAGS ?= -O2 -Wall -Wundef					\
-- 
2.17.1

