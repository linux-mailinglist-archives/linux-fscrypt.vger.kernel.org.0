Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C399C1B813A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgDXUz1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUz1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:27 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA261C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:26 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id o10so9140275qtr.6
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ehd7i3b6TRXl3v1Uwu/y1/w+QTwDrwBpkxzr6hgr8Fc=;
        b=dFYnwBq8rtr5e0BflqdeKWKWEwktVoBx0MssR95x6AO+ql+yotL1fRwoiCuL7PWrsg
         oJ0gvxUL953/xzfo8GFjZCSSU7Mtrv2EIKaY8PEdXvaltm/BXy2DCk2v2WxgdKqdJdWI
         EWdXTAmV8C4UygFjmv+36LTCf3GJeDFNejgw1GcKFMOLmDM1DNGn6z4+V5hI0RvXuYUK
         ifjsztIVrbngg8REO6kRaFpKO/74phU6I3YYF9g3UAlLgg0NYdPPQiQiBr+T8fp5LBm5
         RJ2RuPj7OE43Us+NgOhW06geEwWbQUj1TB6xF4ZW8tRF1275CdU6U34Ir+tEPT+JKjda
         Tfmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ehd7i3b6TRXl3v1Uwu/y1/w+QTwDrwBpkxzr6hgr8Fc=;
        b=NguJbOG0oFAGOQidYMWQtFOgatGsRU6/GJOGwN8xZUvURIXJWUAxu1q4zRLuqh/m+z
         UPwIUf0X7+AGRBW9T9HtZG3sdY64gUlS6NmxF5anmQ9Lk4DHTxyH4OLuprePrbKiwuBN
         NchEqnXHhR99JBTkVyNGZLsbciaONztreXd+M8PcZ7PFE3oLb/HHoqfkdNYQR/qzxB0T
         L/Zs1rrhcvVDCphV+s0hacAr0E6hyEcdCMSmge+RZD6xDrVC9xwDVmDLhJ81z8mA7CfW
         0W4gkabYzxa4Nqoat/Q2vDg4o3lLhf1szVezvTLk4+fz2qHUE1lA06tZp/evTX1cFZQQ
         ps4A==
X-Gm-Message-State: AGi0PuZf0zcfjeUOLwaLgWYyWwfQ2hPpzCKZOp5y960bYa/0DmK1x/1m
        6SQ3Wd6f6g57DQSimyRyALFXp1x4pHk=
X-Google-Smtp-Source: APiQypJwfC89NOrTHtSZFjq7QLDFqNeVpzTMRwUjVyIrPvppDxMlmIePAoW1VRAyKxCtkXqt2L/L3w==
X-Received: by 2002:ac8:bca:: with SMTP id p10mr11539698qti.243.1587761725634;
        Fri, 24 Apr 2020 13:55:25 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id g25sm4385111qkl.50.2020.04.24.13.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:24 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 11/20] Make full_{read,write}() return proper error codes instead of bool
Date:   Fri, 24 Apr 2020 16:54:55 -0400
Message-Id: <20200424205504.2586682-12-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This allows for better error reporting, and simplifies the read callback
handler.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_enable.c |  4 +++-
 cmd_sign.c   | 13 +++++--------
 util.c       | 14 +++++++-------
 util.h       |  4 ++--
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/cmd_enable.c b/cmd_enable.c
index 1bed3ef..9612778 100644
--- a/cmd_enable.c
+++ b/cmd_enable.c
@@ -56,6 +56,7 @@ static bool read_signature(const char *filename, u8 **sig_ret,
 	u64 file_size;
 	u8 *sig = NULL;
 	bool ok = false;
+	int status;
 
 	if (!open_file(&file, filename, O_RDONLY, 0))
 		goto out;
@@ -70,7 +71,8 @@ static bool read_signature(const char *filename, u8 **sig_ret,
 		goto out;
 	}
 	sig = xmalloc(file_size);
-	if (!full_read(&file, sig, file_size))
+	status = full_read(&file, sig, file_size);
+	if (status < 0)
 		goto out;
 	*sig_ret = sig;
 	*sig_size_ret = file_size;
diff --git a/cmd_sign.c b/cmd_sign.c
index 15d0937..959e6d9 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -13,6 +13,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <errno.h>
+#include <unistd.h>
 
 #include "commands.h"
 #include "libfsverity.h"
@@ -20,12 +21,13 @@
 static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 {
 	struct filedes file;
+	int status;
 	bool ok;
 
 	if (!open_file(&file, filename, O_WRONLY|O_CREAT|O_TRUNC, 0644))
 		return false;
-	ok = full_write(&file, sig, sig_size);
-	ok &= filedes_close(&file);
+	status = full_write(&file, sig, sig_size);
+	ok = (!status && filedes_close(&file));
 	return ok;
 }
 
@@ -48,12 +50,7 @@ static const struct option longopts[] = {
 
 static int read_callback(void *opague, void *buf, size_t count)
 {
-	int retval = -EBADF;
-
-	if (full_read(opague, buf, count))
-		retval = 0;
-
-	return retval;
+	return full_read(opague, buf, count);
 }
 
 /* Sign a file for fs-verity by computing its measurement, then signing it. */
diff --git a/util.c b/util.c
index 2218f2e..586d2b0 100644
--- a/util.c
+++ b/util.c
@@ -117,38 +117,38 @@ bool get_file_size(struct filedes *file, u64 *size_ret)
 	return true;
 }
 
-bool full_read(struct filedes *file, void *buf, size_t count)
+int full_read(struct filedes *file, void *buf, size_t count)
 {
 	while (count) {
 		int n = read(file->fd, buf, min(count, INT_MAX));
 
 		if (n < 0) {
 			error_msg_errno("reading from '%s'", file->name);
-			return false;
+			return n;
 		}
 		if (n == 0) {
 			error_msg("unexpected end-of-file on '%s'", file->name);
-			return false;
+			return -EBADFD;
 		}
 		buf += n;
 		count -= n;
 	}
-	return true;
+	return 0;
 }
 
-bool full_write(struct filedes *file, const void *buf, size_t count)
+int full_write(struct filedes *file, const void *buf, size_t count)
 {
 	while (count) {
 		int n = write(file->fd, buf, min(count, INT_MAX));
 
 		if (n < 0) {
 			error_msg_errno("writing to '%s'", file->name);
-			return false;
+			return n;
 		}
 		buf += n;
 		count -= n;
 	}
-	return true;
+	return 0;
 }
 
 bool filedes_close(struct filedes *file)
diff --git a/util.h b/util.h
index dd9b803..c4dc066 100644
--- a/util.h
+++ b/util.h
@@ -113,8 +113,8 @@ struct filedes {
 
 bool open_file(struct filedes *file, const char *filename, int flags, int mode);
 bool get_file_size(struct filedes *file, u64 *size_ret);
-bool full_read(struct filedes *file, void *buf, size_t count);
-bool full_write(struct filedes *file, const void *buf, size_t count);
+int full_read(struct filedes *file, void *buf, size_t count);
+int full_write(struct filedes *file, const void *buf, size_t count);
 bool filedes_close(struct filedes *file);
 
 /* ========== String utilities ========== */
-- 
2.25.3

