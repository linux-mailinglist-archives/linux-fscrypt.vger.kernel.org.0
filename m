Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22032D27DE
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Dec 2020 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgLHJjZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 04:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgLHJjY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 04:39:24 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A2EC0617B0
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 01:38:43 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id m9so11705198pgb.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 01:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u6Ih/DaQwjNwmpSGKSjPdUX3bQk29I1ylU1kAlfOWJQ=;
        b=UNiwpB5+Mg3wrWFKD/yovjbAcNSxKXCG6U6AeezVcMl6TEJmz/wPWF7zOLeQQkxM2B
         M0FIkMtsngyJJ+OOgJT1pITrlEGUX9I9XXhoP9MhkgaCeWWliuKAfSs1C0F7KYSVvhWd
         T+tl+yqQR7+FiqLAHOJuDQsO3ejdJ+OkoOPNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u6Ih/DaQwjNwmpSGKSjPdUX3bQk29I1ylU1kAlfOWJQ=;
        b=RrvCpcns4Vrft2FDwPgY1o6ZU8g4tjdSB33a/fSTlGqmNIhY8TURo7km3reV1r8q9K
         0XI6IiVz+uYCCIAjtbQ1igEYB+zMiolPNWSEFeG96J+TsfCjnVRlOAcOwsu3fWmJGcyC
         E9Ma065dV+avGb+ATEeN/WBzFKWdlkQeCdpXe0sVzZWmhSObkexYLpjOpvzwf7laKjLC
         PFvGYEA2hnclPBn1wdDGhF4aJcvPY8yzkc9q44mwL9Fk7HhG37ouF8nCXT834xdoBfUb
         XMQSG5u5l1bb6tVYLKFbJsig9/FyOUWtGs1YAvz6XbtmireZ+0DWFMecSS5Dz0xOxvCb
         7E6A==
X-Gm-Message-State: AOAM533az1dz7vPvojSNqPEIY/kVxC8ajGP4kUKcBn4rjNR/dmGPjEOX
        8uEX1oAHMYPBQRpllgzTz0pglA==
X-Google-Smtp-Source: ABdhPJzN6ACj7t0UbiR649h/V65nRGCL7gVgf8Gu+qpYSpoAnyKO0rqDWMCrSRBTdQb83UOGy3G14g==
X-Received: by 2002:a17:90a:4f03:: with SMTP id p3mr3561418pjh.69.1607420322687;
        Tue, 08 Dec 2020 01:38:42 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f693:9fff:fef4:2537])
        by smtp.gmail.com with ESMTPSA id s5sm2445374pju.9.2020.12.08.01.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:38:42 -0800 (PST)
From:   Chirantan Ekbote <chirantan@chromium.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Suleiman Souhlal <suleiman@chromium.org>,
        fuse-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: [PATCH v2 2/2] fuse: Support FS_IOC_GET_ENCRYPTION_POLICY_EX
Date:   Tue,  8 Dec 2020 18:38:08 +0900
Message-Id: <20201208093808.1572227-3-chirantan@chromium.org>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201208093808.1572227-1-chirantan@chromium.org>
References: <20201207040303.906100-1-chirantan@chromium.org>
 <20201208093808.1572227-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Chrome OS would like to support this ioctl when passed through the fuse
driver. However since it is dynamically sized, we can't rely on the
length encoded in the command.  Instead check the `policy_size` field of
the user provided parameter to get the max length of the data returned
by the server.

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
---
 fs/fuse/file.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 69cffb77a0b25..b64ff7f2fe4dd 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -19,6 +19,7 @@
 #include <linux/falloc.h>
 #include <linux/uio.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 
 static struct page **fuse_pages_alloc(unsigned int npages, gfp_t flags,
 				      struct fuse_page_desc **desc)
@@ -2710,6 +2711,21 @@ static int fuse_get_ioctl_len(unsigned int cmd, unsigned long arg, size_t *len)
 	case FS_IOC_SETFLAGS:
 		*len = sizeof(int);
 		break;
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX: {
+		__u64 policy_size;
+		struct fscrypt_get_policy_ex_arg __user *uarg =
+			(struct fscrypt_get_policy_ex_arg __user *)arg;
+
+		if (copy_from_user(&policy_size, &uarg->policy_size,
+				   sizeof(policy_size)))
+			return -EFAULT;
+
+		if (policy_size > SIZE_MAX - sizeof(policy_size))
+			return -EINVAL;
+
+		*len = sizeof(policy_size) + policy_size;
+		break;
+	}
 	default:
 		*len = _IOC_SIZE(cmd);
 		break;
-- 
2.29.2.576.ga3fc446d84-goog

