Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9351D15865D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbgBKABP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:01:15 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44255 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727549AbgBKABP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:01:15 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so3467916plo.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9u2/hYYLGoO8El+py7ZmKj3n0T2jkISIzfeNreQh7Jg=;
        b=YNN8LD5bWbrsZh0CvgSzUsWM3sQsPSPpPW+jIxETDNcGAehbWznLtNP8LigrZiO0Cs
         xqCCew+E051S7lua1AjMItMrYfr9EAdldB3RLdVE+9YIhPbqzkhzxCVAIuYNADggDOBH
         h4O2vpM3oTp+f+VwZbqIghg1JvAG0ULybFtNIJWp7oVtZegki0fbOz2gN3YtYVO7kOLr
         2i/G+N4AmF6OqUVoebyvVIQe2tg+bG0Us8eda8hNJjzzjXQ5UaTfo86pah2dTB1WAZlO
         zvdecd8CSPNRK+hLKZIoWXw2tOzh0V7uyV1WFetOxMtxYjNdmbySPXK6/+Mss77cteuc
         3mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9u2/hYYLGoO8El+py7ZmKj3n0T2jkISIzfeNreQh7Jg=;
        b=aLliO2Lawwc4lOFg8s2v4uLZWoae+B0Qt+ZQyLpr9usQYrTTY+x3t04VHZlWLLn36R
         Xr/9MAgqHx9QJwr1zfOlsRMN2WPgRJCSEWXphMEbuw22Xuyv5SossaTDzEA/uZty+l0P
         CiTPMDmdl0yi02QfgjjaxXI0Y/bqf+sjLeVnBvJJxGi3J+G7bcihDMRz6AJww7FgAKIY
         RTqsVsYpJbT5w9q56HzxLig62yMNfVIxsJYgbRRxw5U1FwWSfdkS7dQmWI5ItBLROvuF
         mCzozwo65udOKkOGpK3eQJwt645fOkBffWakaCjN+GZEqjL2jLyEDdpEGgUJaomN7NE+
         A6Ug==
X-Gm-Message-State: APjAAAU2g/n7Nl0Ifo2EPmmyXQglO5Zuc5sdwZWlV0Ve0XyY4tbwk6Yx
        U9epo/xGZBeaP1C7Kgor/uQv08ze5T0=
X-Google-Smtp-Source: APXvYqzf8X2g4iAZ1GR6M/H5NMkqvmGuH11TF68qb1xF3LaXEsnJxFRREyRT3nD1VVfQtFZR9umhJA==
X-Received: by 2002:a17:90a:8806:: with SMTP id s6mr359191pjn.141.1581379273949;
        Mon, 10 Feb 2020 16:01:13 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id r11sm1280782pgi.9.2020.02.10.16.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:01:13 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 6/7] Move cmdline helper functions to fsverity.c
Date:   Mon, 10 Feb 2020 19:00:36 -0500
Message-Id: <20200211000037.189180-7-Jes.Sorensen@gmail.com>
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

There is no need for these to live in the shared library. In addition
move get_default_block_size() to the library and rename it appropriately.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c |  2 +-
 fsverity.c | 25 +++++++++----------------
 fsverity.h |  8 +-------
 util.c     | 13 +++++++++++++
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index 42779f2..a0bd168 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -497,7 +497,7 @@ int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 	}
 
 	if (block_size == 0)
-		block_size = get_default_block_size();
+		block_size = fsverity_get_default_block_size();
 
 	if (keyfile == NULL) {
 		status = -EINVAL;
diff --git a/fsverity.c b/fsverity.c
index f0e94bf..45bf0cc 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -18,6 +18,12 @@
 #include "fsverity.h"
 #include "hash_algs.h"
 
+struct fsverity_command;
+
+static bool parse_block_size_option(const char *arg, u32 *size_ptr);
+static bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
+static void usage(const struct fsverity_command *cmd, FILE *fp);
+
 enum {
 	OPT_HASH_ALG,
 	OPT_BLOCK_SIZE,
@@ -310,7 +316,7 @@ int wrap_cmd_enable(const struct fsverity_command *cmd,
 		arg.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
 
 	if (arg.block_size == 0)
-		arg.block_size = get_default_block_size();
+		arg.block_size = fsverity_get_default_block_size();
 
 	status = fsverity_cmd_enable(argv[0], &arg);
 
@@ -437,7 +443,7 @@ static const struct fsverity_command *find_command(const char *name)
 	return NULL;
 }
 
-bool parse_block_size_option(const char *arg, u32 *size_ptr)
+static bool parse_block_size_option(const char *arg, u32 *size_ptr)
 {
 	char *end;
 	unsigned long n = strtoul(arg, &end, 10);
@@ -455,7 +461,7 @@ bool parse_block_size_option(const char *arg, u32 *size_ptr)
 	return true;
 }
 
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
+static bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
 {
 	if (*salt_ptr != NULL) {
 		error_msg("--salt can only be specified once");
@@ -470,19 +476,6 @@ bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr)
 	return true;
 }
 
-u32 get_default_block_size(void)
-{
-	long n = sysconf(_SC_PAGESIZE);
-
-	if (n <= 0 || n >= INT_MAX || !is_power_of_2(n)) {
-		fprintf(stderr,
-			"Warning: invalid _SC_PAGESIZE (%ld).  Assuming 4K blocks.\n",
-			n);
-		return 4096;
-	}
-	return n;
-}
-
 int main(int argc, char *argv[])
 {
 	const struct fsverity_command *cmd;
diff --git a/fsverity.h b/fsverity.h
index e490c25..bb2f337 100644
--- a/fsverity.h
+++ b/fsverity.h
@@ -8,8 +8,6 @@
 #include "hash_algs.h"
 #include "fsverity_uapi.h"
 
-struct fsverity_command;
-
 /*
  * Format in which verity file measurements are signed.  This is the same as
  * 'struct fsverity_digest', except here some magic bytes are prepended to
@@ -24,7 +22,7 @@ struct fsverity_signed_digest {
 };
 
 
-void usage(const struct fsverity_command *cmd, FILE *fp);
+u32 fsverity_get_default_block_size(void);
 
 int fsverity_cmd_enable(char *filename, struct fsverity_enable_arg *arg);
 int fsverity_cmd_measure(char *filename, struct fsverity_digest *d);
@@ -34,8 +32,4 @@ int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 		      struct fsverity_signed_digest **retdigest,
 		      u8 **sig, u32 *sig_size);
 
-bool parse_block_size_option(const char *arg, u32 *size_ptr);
-u32 get_default_block_size(void);
-bool parse_salt_option(const char *arg, u8 **salt_ptr, u32 *salt_size_ptr);
-
 #endif /* COMMANDS_H */
diff --git a/util.c b/util.c
index 2218f2e..e4ccd2a 100644
--- a/util.c
+++ b/util.c
@@ -213,3 +213,16 @@ void bin2hex(const u8 *bin, size_t bin_len, char *hex)
 	}
 	*hex = '\0';
 }
+
+u32 fsverity_get_default_block_size(void)
+{
+	long n = sysconf(_SC_PAGESIZE);
+
+	if (n <= 0 || n >= INT_MAX || !is_power_of_2(n)) {
+		fprintf(stderr,
+			"Warning: invalid _SC_PAGESIZE (%ld).  Assuming 4K blocks.\n",
+			n);
+		return 4096;
+	}
+	return n;
+}
-- 
2.24.1

