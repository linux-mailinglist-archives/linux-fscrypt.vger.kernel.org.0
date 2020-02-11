Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8E815865E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2020 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgBKABU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Feb 2020 19:01:20 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44294 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBKABT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Feb 2020 19:01:19 -0500
Received: by mail-pf1-f194.google.com with SMTP id y5so4493347pfb.11
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2020 16:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=giQvuKX7jiy8E1/i0YN5clCiLU0NvaHWkduEDD6DQx4=;
        b=ddjhdR70VN8J7D/JrTWIb4Bfpg5ZXAmb/f/u3qcOw15XvzoW6E2rEinw/ScgT67lQ+
         V6ZOcOmlAGL/IyLPx7Kw7UBQCOTL6L12r4yJQ5uAycN+Twhm3Y0CkcffTMDPoXGx8Gct
         BTn8ZlnF9Z6vkSgzJl7A4a7jxdobEr3C8DneNFMkDZ1cPzmgx1kNKAJSA1ANpFFFgb6j
         zcA5u63r7xbT8lUVYh2DMEA+ZxqHApsS0u5OOdLksqq+oP78TpIEL52AyjiK+ifgBd29
         CBNER99+WFxAOIilkTA3439aBOs5nCLslEzMg/L1jQqlxKo9Fj1/zTgu8CnWiVXvpGdT
         T6og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=giQvuKX7jiy8E1/i0YN5clCiLU0NvaHWkduEDD6DQx4=;
        b=AzhWwZbE/03vWNuot8fi/6uPw5H/PfN3aGV7TUMnzcu8YSz5qa9ZQIlefMqMaJAPlk
         j5AjngE7hVcuMw4oSJu/l/ol1LYnn66xcDww/aDDdXTvSlJczX5DexexXcUUtv9Z9Bct
         Ca8sjQ8cotvGer4dlKPCy9KXWxsR+HJ6+upllRaYFRz2AxtaHYDcTxuR0HrMLwSgp32R
         TpMWxVCJ9II8Jth1KE9DbsiUg+2Yv6GeoVOTjVwTnq2xnRm7mbBdQq5iKPJ0z53/tuJm
         dKre7a5DBk4SZZ7PymXQFPqEQ7EzsnwVllSmU1j/sBf6eDkTDm6Sib6xLcjIXqCbXfQn
         +YiA==
X-Gm-Message-State: APjAAAWuGLO7TKcB9f7bpMHeobe8cE+bQ//jqma97uUyjyI2VHH7ZRB+
        Gi4QNLgIPz+ecypJpLUHOWQ6qyVhBTQ=
X-Google-Smtp-Source: APXvYqxmOQUdcMMU+2O2/SeVGu6Kj14tr7s6By6yTJPlrOgetsF8CbZw7eRkz3J2hE7qOXE6Bq2d1w==
X-Received: by 2002:a62:1c95:: with SMTP id c143mr326924pfc.219.1581379278564;
        Mon, 10 Feb 2020 16:01:18 -0800 (PST)
Received: from localhost ([2620:10d:c090:200::6168])
        by smtp.gmail.com with ESMTPSA id b18sm1527618pfd.63.2020.02.10.16.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 16:01:18 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 7/7] cmd_sign: fsverity_cmd_sign() into two functions
Date:   Mon, 10 Feb 2020 19:00:37 -0500
Message-Id: <20200211000037.189180-8-Jes.Sorensen@gmail.com>
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

This splits cmd_sign() into a gen_digest() and a sign_digest()
function, and fixes fsverity.c to use them appropriately.
---
 cmd_sign.c | 50 +++++++++++++++++++++++++++++++++-----------------
 fsverity.c |  8 ++++++--
 fsverity.h | 13 ++++++++-----
 3 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index a0bd168..ba68243 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -481,12 +481,11 @@ out:
 	return ok;
 }
 
-/* Sign a file for fs-verity by computing its measurement, then signing it. */
-int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
-		      u32 block_size, u8 *salt, u32 salt_size,
-		      const char *keyfile, const char *certfile,
-		      struct fsverity_signed_digest **retdigest,
-		      u8 **sig, u32 *sig_size)
+/* Generate the fsverity digest computing its measurement. */
+int fsverity_cmd_gen_digest(char *filename,
+			    const struct fsverity_hash_alg *hash_alg,
+			    u32 block_size, u8 *salt, u32 salt_size,
+			    struct fsverity_signed_digest **retdigest)
 {
 	struct fsverity_signed_digest *digest = NULL;
 	int status;
@@ -499,13 +498,6 @@ int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 	if (block_size == 0)
 		block_size = fsverity_get_default_block_size();
 
-	if (keyfile == NULL) {
-		status = -EINVAL;
-		goto out;
-	}
-	if (certfile == NULL)
-		certfile = keyfile;
-
 	digest = xzalloc(sizeof(*digest) + hash_alg->digest_size);
 	memcpy(digest->magic, "FSVerity", 8);
 	digest->digest_algorithm = cpu_to_le16(hash_alg - fsverity_hash_algs);
@@ -515,10 +507,6 @@ int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
 				      salt, salt_size, digest->digest))
 		goto out_err;
 
-	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
-		       keyfile, certfile, hash_alg, sig, sig_size))
-		goto out_err;
-
 	*retdigest = digest;
 	status = 0;
 out:
@@ -529,3 +517,31 @@ out_err:
 	goto out;
 
 }
+
+/* Sign a pre-generated fsverity_signed_digest structure */
+int fsverity_cmd_sign_digest(struct fsverity_signed_digest *digest,
+			     const struct fsverity_hash_alg *hash_alg,
+			     const char *keyfile, const char *certfile,
+			     u8 **sig, u32 *sig_size)
+{
+	int status;
+
+	if (keyfile == NULL) {
+		status = -EINVAL;
+		goto out;
+	}
+	if (certfile == NULL)
+		certfile = keyfile;
+
+	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
+		       keyfile, certfile, hash_alg, sig, sig_size))
+		goto out_err;
+
+	status = 0;
+ out:
+	return status;
+
+ out_err:
+	status = 1;
+	goto out;
+}
diff --git a/fsverity.c b/fsverity.c
index 45bf0cc..3fcafcb 100644
--- a/fsverity.c
+++ b/fsverity.c
@@ -188,8 +188,12 @@ int wrap_cmd_sign(const struct fsverity_command *cmd, int argc, char *argv[])
 	if (argc != 2)
 		goto out_usage;
 
-	status = fsverity_cmd_sign(argv[0], hash_alg, block_size, salt, salt_size,
-				   keyfile, certfile, &digest, &sig, &sig_size);
+	status = fsverity_cmd_gen_digest(argv[0], hash_alg, block_size,
+					 salt, salt_size, &digest);
+	if (status)
+		goto out_usage;
+	status = fsverity_cmd_sign_digest(digest, hash_alg, keyfile, certfile,
+					  &sig, &sig_size);
 	if (status == -EINVAL)
 		goto out_usage;
 	if (status != 0)
diff --git a/fsverity.h b/fsverity.h
index bb2f337..695bdac 100644
--- a/fsverity.h
+++ b/fsverity.h
@@ -26,10 +26,13 @@ u32 fsverity_get_default_block_size(void);
 
 int fsverity_cmd_enable(char *filename, struct fsverity_enable_arg *arg);
 int fsverity_cmd_measure(char *filename, struct fsverity_digest *d);
-int fsverity_cmd_sign(char *filename, const struct fsverity_hash_alg *hash_alg,
-		      u32 block_size, u8 *salt, u32 salt_size,
-		      const char *keyfile, const char *certfile,
-		      struct fsverity_signed_digest **retdigest,
-		      u8 **sig, u32 *sig_size);
+int fsverity_cmd_gen_digest(char *filename,
+			    const struct fsverity_hash_alg *hash_alg,
+			    u32 block_size, u8 *salt, u32 salt_size,
+			    struct fsverity_signed_digest **retdigest);
+int fsverity_cmd_sign_digest(struct fsverity_signed_digest *digest,
+			     const struct fsverity_hash_alg *hash_alg,
+			     const char *keyfile, const char *certfile,
+			     u8 **sig, u32 *sig_size);
 
 #endif /* COMMANDS_H */
-- 
2.24.1

