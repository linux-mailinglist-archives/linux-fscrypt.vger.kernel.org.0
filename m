Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9D2DD939
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgLQTRH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQTRG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:17:06 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54688C061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:16:26 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id y23so6656541wmi.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fa9qT/pKkw/u/yVwCkGC3Mjio8P5+Oq6XKmyiCUuGOk=;
        b=Ma7RtNt56rN8HC0nvIawMcb22b5Mc+2cpxYOoqySu0m0RZerIG9gpp9xg6u9O/ZRau
         8vxbLj6Vfrb9da5losUt9VgOtW3plBMMKfRL4yxGpFNimRjH5EZnD17HayZ2a3fCUMte
         46bUrLldb9zGxzXXk0ai78RFohRE/DUNqI0VxeJtBO/w8Pd+uL133sejSSbaoXgLC0h1
         +8aVkDhOk6wxGWEbUvkCMOeqA+Y44bAkYyM+7aR1lTjcJxkrcIRNtRPouzk4dS9jymF/
         vCAHla1r0Q99AuCFRIlM8wTopn5sH3VQe44NBqGAFrmvUnzkgh2HIaNFzoI3aFxCEw4y
         YxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fa9qT/pKkw/u/yVwCkGC3Mjio8P5+Oq6XKmyiCUuGOk=;
        b=tXcHOMU3EDT5+HCoFmxhvFRPrg58349lFxolU4O3a/dCkGTKNLDN21mwqUQlHMqKVv
         /XlWSrQNZF17LNocwv2XKRxwCD9dDBbBSwLUn2SvKpFD63sXIUvyw9F2S8H9DWQShnu7
         QJNwFe/JLDJCTXhU2O2GhgjEhwbZ7+b65k6WPsvnaXVkQd4ZxmKNiHpx02cGjEVp+2hj
         W5+dfiDL6yUwH7yHaGPD1RVSwQSXy4sXPw+xmQXRN1JQp/A7iytjNcFWJSr3fpge9/3g
         J1uBAI1Asre2GV1LfUe8G74qRusln/KM9y+I6MuDx/khHHGH2BCPxlSX/0VUHM11RmHi
         Tiiw==
X-Gm-Message-State: AOAM533P7LjG425JPrCX5UtKEFN0sup4nB8eSDZCJ9kcihVMXDV3Q9D9
        XmiDjhSgXCmcd6YZljqM+7ZucghY2aa7bQ==
X-Google-Smtp-Source: ABdhPJwnPunLkVLlPVxEu/265XHcLS6Odejdbgiro9zGKm6KjnGZTC2gBGCDgT58CcCyEKfDJJuIiA==
X-Received: by 2002:a1c:25c3:: with SMTP id l186mr744928wml.113.1608232584685;
        Thu, 17 Dec 2020 11:16:24 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id x17sm10429939wro.40.2020.12.17.11.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:16:23 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [fsverity-utils PATCH v3 1/2] Remove unneeded includes
Date:   Thu, 17 Dec 2020 19:16:17 +0000
Message-Id: <20201217191618.3681450-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201217144749.647533-1-luca.boccassi@gmail.com>
References: <20201217144749.647533-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Luca Boccassi <luca.boccassi@microsoft.com>

Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
---
v2: do not remove includes from fsverity_uapi.h, actually needed

 programs/cmd_enable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/programs/cmd_enable.c b/programs/cmd_enable.c
index fdf26c7..14c3c17 100644
--- a/programs/cmd_enable.c
+++ b/programs/cmd_enable.c
@@ -14,7 +14,6 @@
 #include <fcntl.h>
 #include <getopt.h>
 #include <limits.h>
-#include <sys/ioctl.h>
 
 static bool read_signature(const char *filename, u8 **sig_ret,
 			   u32 *sig_size_ret)
-- 
2.29.2

