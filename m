Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B98CD2DD94E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 20:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgLQT0B (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 14:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgLQT0B (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 14:26:01 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC75C061282
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:25:20 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id c5so24068746wrp.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 11:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fa9qT/pKkw/u/yVwCkGC3Mjio8P5+Oq6XKmyiCUuGOk=;
        b=LDSdAmae0xlWOuYFPdnZF9Asf4f744c4hNxI/ZzYLFqtzsQljsp8sAWh1b5t8ZVXqA
         xbFf5eqOcyFYIrAHuRMGaqslJB97oZZcUrw/n7I7HZJ38JrVxHtTUwrAzbTS6dG2HeEV
         iu2oeOODN/51gjJwpPbmI7seRh625QA+CmW9GdYG77HUZLcAn6C5sJoq+T6UI7J7W+9t
         fSD1oj7SNmdln/XErlLBKiMo4MfBPrCpkp9/zw0TTftbMRdRXoTWjjVl8JzsAbt8E2px
         RI8IWrc0wVaZH2+q+np8u/5r35jNGeEq3z+iiI5yAa+9O2cmVCWUR7YqiQz3cbOf8k7e
         vBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fa9qT/pKkw/u/yVwCkGC3Mjio8P5+Oq6XKmyiCUuGOk=;
        b=IKaaLWbEfmFkHQ7Pg5nDRHuvk5WoOyNFHe2qhFTh7DK6l04VsRxMc073YK0gUVavTJ
         zwXwDcsU6tISnV94eNDMurVG8a+TMCzpHFu6dc+ijZlb0+G4gh1vHD2h0KSAhNHofTOZ
         HE7PUsHZM7OefWDgEZDz5IKVNPUnDRVK/psmomtVGfbnxQcRRKNPCrvkaj/FkC8dd2fK
         a7mMHSeFML3IDidiwjHymqSndohNDnEs3Mw0RWWfSRUqnn3u1hvDLkI6g6bLQk48aKzZ
         gtMTg2+QM1NfYw2cwfoTb64vlyLtQMkGCEw6YWk2qRGQ8QJf3BBMXXRCdRDj1xprGa69
         zQVA==
X-Gm-Message-State: AOAM5323flMgKPncZONEEEhHuPECT4+SqdFGiXbKZmyViWNCJcunTej/
        wV4Q7lrgPRaJVpjkRp1SlAZ7fLkTfkJqUw==
X-Google-Smtp-Source: ABdhPJy8CYoTCSAWGVXfLg/BRAwFq44144TM/oLa7xvVVOcFRYAHEzkzjE4uZQDpnL2dv+HCVAsmEw==
X-Received: by 2002:adf:d843:: with SMTP id k3mr356535wrl.346.1608233119459;
        Thu, 17 Dec 2020 11:25:19 -0800 (PST)
Received: from localhost ([88.98.246.218])
        by smtp.gmail.com with ESMTPSA id k1sm10484884wrn.46.2020.12.17.11.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 11:25:18 -0800 (PST)
From:   luca.boccassi@gmail.com
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com
Subject: [fsverity-utils PATCH v4 1/2] Remove unneeded includes
Date:   Thu, 17 Dec 2020 19:25:15 +0000
Message-Id: <20201217192516.3683371-1-luca.boccassi@gmail.com>
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

