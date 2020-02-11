Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B420315865A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBKABA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:01:00 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35232 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKABA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:01:00 -0500
Received: by mail-pf1-f196.google.com with SMTP id y73so4516472pfg.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySm+v7oQp4kUguIPka/Yy8LzDkudWQuhqEaz1/vGM/Y=;
        b=fwX8J/gcFXjwZ957WFxpTJsz+6O8CsI8BMWE2A6fiDA9Wi9X4HQmDk0ha8rO1ZUgM6
         +PIOVVD3QO1QpodyXmmczQ6KzoohVVa4emOL4NKKyKNFUL/yvp+2FPqU4X65OacUCuhV
         zy+RWYwDscdFdEl8qYTH6s3AWfUfiSB+pq1i94cbvOVBjDZ+hRtza7GIqPcFmcawLb3v
         n/r/GYOA0KiV2wlKh/L8ATGb5B0rgJwMhRDRzWxTOre5QgK3ac/NmSGKvzs8he9WY0vB
         f2q0kAwc7JVdbGmQ3VX3hh2eB7XE0bJKdwJhuGlk1bn4jc/3+ihHwg73D59wa565vmOH
         wo7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySm+v7oQp4kUguIPka/Yy8LzDkudWQuhqEaz1/vGM/Y=;
        b=E2WJPcRgX63xkueKTc3QCl7dbff6mGsc/tjCoD5w0Nk5NAcPGvyjcnJM6n4qkzfGLg
         4AxBglYTWH2kExESuc5zl8INFC8WsFWZwB8V15Ew+9I1BT60j4u/1nVP9RS5fFos8gKe
         e/2ppraMKJiHrYDof+uBeV9FT5jFAofvLpeqLxkMiwhOmInYZ+UkSZK2LqctvMeKikCu
         sWst6eYXGwA4hNE8OVP5BXV81UeqtRf5JJILtOJM6MAxi7MokzqUepEtnW43lcnfhiui
         Abcuu8Ks/lFZ0YQzo0iCO6nhBAQgRUqcfb0YInkWHGbQatK89YzXYtuHY4sXzslz0w2I
         RFAQ==
X-Gm-Message-State: APjAAAUggj5hE1AM9dSOJ9MjppZWAjjGELYek9mnPjb60v1siMmmKps0
        eTDXBKfmWQdE/r76uTsdZGXQMT3fX00=
X-Google-Smtp-Source: APXvYqz2UWIVubqKTNFFhJHcQTmF8fzac3e7YikiwzBJgam5KoHPAG0W7Za3+1ovUTitXAl98e6w3g==
X-Received: by 2002:a63:a1e:: with SMTP id 30mr4353601pgk.238.1581379259215;
        Mon, 10 Feb 2020 16:00:59 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id i190sm1217517pgd.75.2020.02.10.16.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:00:58 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 3/7] Make fsverity_cmd_measure() a library function
Date:   Mon, 10 Feb 2020 19:00:33 -0500
Message-Id: <20200211000037.189180-4-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This splits the cmdline option parsing into wrap_cmd_measure() and
fsverity_cmd_measure() is just the basic call to the ioctl.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_measure.c | 49 +++++++++----------------------------------------
 commands.h    |  3 +--
 fsverity.c    | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 43 deletions(-)

diff --git a/cmd_measure.c b/cmd_measure.c
index 574e3ca..fc3108d 100644
--- a/cmd_measure.c
+++ b/cmd_measure.c
@@ -13,50 +13,24 @@
 
 #include "commands.h"
 #include "fsverity_uapi.h"
-#include "hash_algs.h"
 
 /* Display the measurement of the given verity file(s). */
-int fsverity_cmd_measure(const struct fsverity_command *cmd,
-			 int argc, char *argv[])
+int fsverity_cmd_measure(char *filename, struct fsverity_digest *d)
 {
-	struct fsverity_digest *d = NULL;
 	struct filedes file;
-	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
-	const struct fsverity_hash_alg *hash_alg;
-	char _hash_alg_name[32];
-	const char *hash_alg_name;
 	int status;
-	int i;
 
-	if (argc < 2)
-		goto out_usage;
+	if (!open_file(&file, filename, O_RDONLY, 0))
+		goto out_err;
 
-	d = xzalloc(sizeof(*d) + FS_VERITY_MAX_DIGEST_SIZE);
-
-	for (i = 1; i < argc; i++) {
-		d->digest_size = FS_VERITY_MAX_DIGEST_SIZE;
-
-		if (!open_file(&file, argv[i], O_RDONLY, 0))
-			goto out_err;
-		if (ioctl(file.fd, FS_IOC_MEASURE_VERITY, d) != 0) {
-			error_msg_errno("FS_IOC_MEASURE_VERITY failed on '%s'",
-					file.name);
-			filedes_close(&file);
-			goto out_err;
-		}
+	if (ioctl(file.fd, FS_IOC_MEASURE_VERITY, d) != 0) {
+		error_msg_errno("FS_IOC_MEASURE_VERITY failed on '%s'",
+				file.name);
 		filedes_close(&file);
-
-		ASSERT(d->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
-		bin2hex(d->digest, d->digest_size, digest_hex);
-		hash_alg = find_hash_alg_by_num(d->digest_algorithm);
-		if (hash_alg) {
-			hash_alg_name = hash_alg->name;
-		} else {
-			sprintf(_hash_alg_name, "ALG_%u", d->digest_algorithm);
-			hash_alg_name = _hash_alg_name;
-		}
-		printf("%s:%s %s\n", hash_alg_name, digest_hex, argv[i]);
+		goto out_err;
 	}
+	filedes_close(&file);
+
 	status = 0;
 out:
 	free(d);
@@ -65,9 +39,4 @@ out:
 out_err:
 	status = 1;
 	goto out;
-
-out_usage:
-	usage(cmd, stderr);
-	status = 2;
-	goto out;
 }
diff --git a/commands.h b/commands.h
index c38fcea..3e07f3d 100644
--- a/commands.h
+++ b/commands.h
@@ -28,8 +28,7 @@ void usage(const struct fsverity_command *cmd, FILE *fp);
 
 int fsverity_cmd_enable(const struct fsverity_command *cmd,
 			int argc, char *argv[]);
-int fsverity_cmd_measure(const struct fsverity_command *cmd,
-			 int argc, char *argv[]);
+int fsverity_cmd_measure(char *filename, struct fsverity_digest *d);
 int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 		      u32 block_size, u8 *salt, u32 salt_size,
 		      const char *keyfile, const char *certfile,
diff --git a/fsverity.c b/fsverity.c
index 6246031..49eca14 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -142,6 +142,54 @@ int wrap_cmd_sign(const struct fsverity_command *cmd, int argc, char *argv[])
 	goto out;
 }
 
+int wrap_cmd_measure(const struct fsverity_command *cmd,
+		     int argc, char *argv[])
+{
+	struct fsverity_digest *d = NULL;
+	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
+	const struct fsverity_hash_alg *hash_alg;
+	char _hash_alg_name[32];
+	const char *hash_alg_name;
+	int status;
+	int i;
+
+	if (argc < 2)
+		goto out_usage;
+
+	d = xzalloc(sizeof(*d) + FS_VERITY_MAX_DIGEST_SIZE);
+
+	for (i = 1; i < argc; i++) {
+		d->digest_size = FS_VERITY_MAX_DIGEST_SIZE;
+
+		status = fsverity_cmd_measure(argv[i], d);
+		if (status)
+			goto out_err;
+
+		ASSERT(d->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
+		bin2hex(d->digest, d->digest_size, digest_hex);
+		hash_alg = find_hash_alg_by_num(d->digest_algorithm);
+		if (hash_alg) {
+			hash_alg_name = hash_alg->name;
+		} else {
+			sprintf(_hash_alg_name, "ALG_%u", d->digest_algorithm);
+			hash_alg_name = _hash_alg_name;
+		}
+		printf("%s:%s %s\n", hash_alg_name, digest_hex, argv[i]);
+	}
+out:
+	free(d);
+	return status;
+
+out_err:
+	status = 1;
+	goto out;
+
+out_usage:
+	usage(cmd, stderr);
+	status = 2;
+	goto out;
+}
+
 static const struct fsverity_command {
 	const char *name;
 	int (*func)(const struct fsverity_command *cmd, int argc, char *argv[]);
@@ -158,7 +206,7 @@ static const struct fsverity_command {
 "               [--signature=SIGFILE]\n"
 	}, {
 		.name = "measure",
-		.func = fsverity_cmd_measure,
+		.func = wrap_cmd_measure,
 		.short_desc =
 "Display the measurement of the given verity file(s)",
 		.usage_str =
-- 
2.24.1

