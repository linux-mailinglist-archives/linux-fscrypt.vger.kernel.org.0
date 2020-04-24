Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C977C1B8141
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDXUzj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:39 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144D0C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:39 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z90so9112891qtd.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bSVBOY7Q4cYdjBI96u0u87ijjzYsOABUlnceIIy0zJk=;
        b=Xk7jh/JesGH9WvhBAo4sLdNXLYcaNLYDF0u2Eg92QhFWZLW7rjlRYXHgziFcbSM5uQ
         xPmRw1Rf7hpkTLwSzZ84LA/+5TsKO7wFsAHf32QV4KBbgg7kTk1vA713u6JCQBXzdorX
         l2OLdnG1HWDMG5J5sLJ6pmAc5AQv71nIV164avb+MGR9CnXYb6LhlS3+9CbmGKepl4IY
         gnrZzv6uWbtJ0bCINy3LWHHWMB3tXwg1ZOTwhmRbfiMWUyNkfMdaQ4TFW2YISVL7vh0D
         F4dXmYr4uK6Il523zA/Qg9lYsXO5nRZ4NyvXwVXmLLx4uICM4VEjPc28kgqGz9SEknzn
         sDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bSVBOY7Q4cYdjBI96u0u87ijjzYsOABUlnceIIy0zJk=;
        b=eQwchwEn7nXmY94a+RNt80UWmhZFGxQJ9KpB0NC9FRAmvTwjuKaSwkPle54raASSQm
         C58D7sPnNd30ZMNOwooytgBK21wggdoU/KNedbJGYQ7Rrx44AKqsw/vma3SND70N+R9u
         ckhjT6+iBg+M4CzIFfhmqq9sV3QY2LkChRIGINFlj9mjiN0+tZ+2lSMqdYFPwqR37gam
         vNPRQ4p4PO3sYB8w2KK8NceSGAMPuDU6y+Wnb2YSL9+/Eqcg/xZ6qTKoHc6mxCOB6w+x
         7JwoRc+RRNMECOF3TGqz+AM0puM1N4AkJo4a10J1MADntWUYty+75JC2w+S/Ji+szaR4
         Cz6Q==
X-Gm-Message-State: AGi0PuaEAYJ23yIkBuV2QNUpD1WEMTvbVj9mdLi4aKhpeJsXEHwBJ4KT
        TBgwsxp/DewHXen/V09ouAOdnwlLavE=
X-Google-Smtp-Source: APiQypIO52GjprcMjC+/15PvbaBtGn+Nfa+8os0xKY6K7DOYmTWblbveN6ijPfeNHauiGC3VjXz6ig==
X-Received: by 2002:ac8:73d3:: with SMTP id v19mr11632132qtp.263.1587761737982;
        Fri, 24 Apr 2020 13:55:37 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id g187sm4285858qkf.115.2020.04.24.13.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:37 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 18/20] fsverity_cmd_sign() don't exit on error without closing file descriptor
Date:   Fri, 24 Apr 2020 16:55:02 -0400
Message-Id: <20200424205504.2586682-19-Jes.Sorensen@gmail.com>
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

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index d699d85..7d8ec58 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -73,7 +73,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	u16 alg_nr = 0;
 	int digest_size;
 	size_t sig_size;
-	int status;
+	int status, ret;
 	int c;
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
@@ -154,12 +154,13 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	params.salt_size = salt_size;
 	params.salt = salt;
 
-	if (libfsverity_compute_digest(&file, file_size, read_callback,
-				       &params, &digest))
-		goto out_err;
-
+	ret = libfsverity_compute_digest(&file, file_size, read_callback,
+					 &params, &digest);
 	filedes_close(&file);
 
+	if (ret)
+		goto out_err;
+
 	digest_size = libfsverity_digest_size(alg_nr);
 
 	memset(&sig_params, 0, sizeof(sig_params));
-- 
2.25.3

