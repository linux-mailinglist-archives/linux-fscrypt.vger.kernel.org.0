Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F7E1B8140
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgDXUzh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:37 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078B3C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:37 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z90so9112810qtd.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aDcraxQLqrhLOQ6KlnpE+7DSAzr3emVpGCJLXLOLvhA=;
        b=jxUJz9C6upDJygYT7E7LZcjULxonEKEWTgMvxXEuxVgoVn5u5Jw+H53FilyVk+mRkG
         kLfIh6MSOEMYGAAam0ML44QKTw9Fj31H6bKFvHAB9bYw4pk2r6evAib7xlIAS6/u0UaB
         qbpiaz+LkHMJ6R72HRpM/AnN8SuBScqe8eAm0DeQkpLVdxzJPOkX0edPLmMLGzsINnBq
         dnOWg6F1WRoP6uaSGmnEnFBnsIars8yaYTOfCtbqV/Nad4B6DAqWYKJ5TJfnHjpxWzdb
         3N6U5u6Pa7DXkv7jw6zrf+jWghaK1F+mh0W9vhflpa5/gg7DqOv0zroV8s6v3vdYKimo
         Zdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aDcraxQLqrhLOQ6KlnpE+7DSAzr3emVpGCJLXLOLvhA=;
        b=HLVgeFiOrziQ8KrRERupw8b09CQPQlSHEo5KBC9vmjdXMLfav/VjrTsIraY66UmLeO
         4mjiGPdXVtw11RterPn1mlx0g6ouqpxjokYjOIqBovOSI/gATzzFEG3qiCVAMnEpaCJ6
         Xr2y/W9Hbb1KsLClkLTmqtxpEhA3XzRdGknHOgY/uMW8tGa6ba4hjC7LWWsZFHi1En/w
         aPzNUoWSRPO8yfalAaFevi0K3rri8biuKCDMSeJiB+/cu1ZBIRD9VWnmvgTFTHddMkFu
         7Cs4NUhDRA399SuR1ZJqeyc1EQHpwpadTk67mrixiM09NVw0uPIpQ1Q7MbEUtRqCTZJE
         SvWg==
X-Gm-Message-State: AGi0Pua1QmPlcXtcN/R7tqErzpkO8uh8X37/bm4MOWsqKtfiaCSNzqWC
        bQOaFRf2e2WAUQ34vO2DONbnsKIbyCw=
X-Google-Smtp-Source: APiQypLLfjipfeFbUbvkLSaZg/pquvrfztA55J7V/GQKcksX3z9Ttj4if+6FAwz0+WVyEkXC269zdw==
X-Received: by 2002:ac8:764e:: with SMTP id i14mr11379768qtr.191.1587761735886;
        Fri, 24 Apr 2020 13:55:35 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id o27sm4463944qko.71.2020.04.24.13.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:35 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 17/20] fsverity_cmd_sign() use sizeof() input argument instead of struct
Date:   Fri, 24 Apr 2020 16:55:01 -0400
Message-Id: <20200424205504.2586682-18-Jes.Sorensen@gmail.com>
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
 cmd_sign.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index 57a9250..d699d85 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -147,7 +147,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 		goto out_err;
 	}
 
-	memset(&params, 0, sizeof(struct libfsverity_merkle_tree_params));
+	memset(&params, 0, sizeof(params));
 	params.version = 1;
 	params.hash_algorithm = alg_nr;
 	params.block_size = block_size;
@@ -162,7 +162,7 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	digest_size = libfsverity_digest_size(alg_nr);
 
-	memset(&sig_params, 0, sizeof(struct libfsverity_signature_params));
+	memset(&sig_params, 0, sizeof(sig_params));
 	sig_params.keyfile = keyfile;
 	sig_params.certfile = certfile;
 	if (libfsverity_sign_digest(digest, &sig_params, &sig, &sig_size)) {
-- 
2.25.3

