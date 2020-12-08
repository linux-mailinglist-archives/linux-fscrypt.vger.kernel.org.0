Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800A12D27D9
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Dec 2020 10:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgLHJjX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 04:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgLHJjX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 04:39:23 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155C5C06179C
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 01:38:37 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id d2so9506403pfq.5
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 01:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MZzXHu8124CoPiJwaurWwTo/J3aWzxR8zutkn5kYXE4=;
        b=cLSjKMY+5M/Wxu+yh2O7NZxyglmEDWM0aLwhQiTeEexH/lgiEwIrvRPR04rgfIgg57
         qob3Y5TLlSVeYmwaleNTLmRYOkmpYranm/yr3xNC4QCz2LD5w/LdS7Sz2LWQJLZLhLlL
         agxWngKVcRmg/0NgXFpV0OzfrKBvsDiCpdc3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MZzXHu8124CoPiJwaurWwTo/J3aWzxR8zutkn5kYXE4=;
        b=SGt9KoFvYG+xDHyN8a3560e/ONwJc7NQ60xLNPLPFshqQIMi5AW/vlrb3dLgBMrSvR
         Le0tm8zm0mbxxDqlfCrlmfNVRpNXjgu0e393xFYSC0NgGP6k+p82CldiI3/EPiaUv+lh
         4mWRrUoo+2J3XzU7W14Ktq5GDPn9hkZ6xdscRSrp6iCqzxCPQvxdGhqqzoItfwyYIzEP
         bQE9brUxFVVO8IqfHG/28HhC4eLjyBTfet59GxZP49py49dHPnUNA9xz/ustw6yIweTi
         8I9o282tab6QiP4NYZ11qiYikfUhMItatXf4Kf7iBIifmcaHs/kCi+yB/SubkYdVl6Bd
         XxhA==
X-Gm-Message-State: AOAM530Q3HGi5m4iPbrUYbZOOZvKb8bO1PvSHt++2/wDFMu6NJB9UdiW
        PMeNqxPNHcPWYSMwDahzvdqdUg==
X-Google-Smtp-Source: ABdhPJwBR9nzBYoQZVpt5jYIr1+9fnAlay9LUen4gZ5/oJDzx7ZaWriMZuKnoe0Oj9m7nE81FdrvTg==
X-Received: by 2002:a63:5466:: with SMTP id e38mr21888757pgm.242.1607420316694;
        Tue, 08 Dec 2020 01:38:36 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:f693:9fff:fef4:2537])
        by smtp.gmail.com with ESMTPSA id c3sm15175754pgm.41.2020.12.08.01.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 01:38:36 -0800 (PST)
From:   Chirantan Ekbote <chirantan@chromium.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Suleiman Souhlal <suleiman@chromium.org>,
        fuse-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Chirantan Ekbote <chirantan@chromium.org>
Subject: [PATCH v2 1/2] fuse: Move ioctl length calculation to a separate function
Date:   Tue,  8 Dec 2020 18:38:07 +0900
Message-Id: <20201208093808.1572227-2-chirantan@chromium.org>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201208093808.1572227-1-chirantan@chromium.org>
References: <20201207040303.906100-1-chirantan@chromium.org>
 <20201208093808.1572227-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This will make it more readable when we add support for more ioctls.

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
---
 fs/fuse/file.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c03034e8c1529..69cffb77a0b25 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2703,6 +2703,20 @@ static int fuse_copy_ioctl_iovec(struct fuse_conn *fc, struct iovec *dst,
 	return 0;
 }
 
+static int fuse_get_ioctl_len(unsigned int cmd, unsigned long arg, size_t *len)
+{
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+	case FS_IOC_SETFLAGS:
+		*len = sizeof(int);
+		break;
+	default:
+		*len = _IOC_SIZE(cmd);
+		break;
+	}
+
+	return 0;
+}
 
 /*
  * For ioctls, there is no generic way to determine how much memory
@@ -2802,16 +2816,9 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		struct iovec *iov = iov_page;
 
 		iov->iov_base = (void __user *)arg;
-
-		switch (cmd) {
-		case FS_IOC_GETFLAGS:
-		case FS_IOC_SETFLAGS:
-			iov->iov_len = sizeof(int);
-			break;
-		default:
-			iov->iov_len = _IOC_SIZE(cmd);
-			break;
-		}
+		err = fuse_get_ioctl_len(cmd, arg, &iov->iov_len);
+		if (err)
+			goto out;
 
 		if (_IOC_DIR(cmd) & _IOC_WRITE) {
 			in_iov = iov;
-- 
2.29.2.576.ga3fc446d84-goog

