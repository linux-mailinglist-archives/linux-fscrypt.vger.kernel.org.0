Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086FD1D5B14
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 22:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgEOU5A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 16:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgEOU47 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 16:56:59 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF415C061A0C
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:56:58 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id t25so3236041qtc.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 May 2020 13:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyvZCSIw599hXY8qIGmPYEHcNcvhnGGazdKX2Yc9fkM=;
        b=Z6NDmgSv6GhiuCyqKA/7JEqr6llP5Mt5PUj56x2im2NT6/ORuzHfpzAXLNjgCSUpvf
         AryqXBASXfE5VNN0sj+30wXQX6YtFe9F3FhN2H5bgGDGLLhEbmMSznidJfSKxziiUd9K
         /zL/ZI6XJfXZM6bE0s4wsv9teBFChTe6wa7mACLUaM6bqwJGfsaG10xln0Qoj2xCDyxt
         mKeyzs9vo7iAFjBihmMwnId+KTySZxFRx+hlc9d2RLVyUCm6/Z85D1E79hVX5qD4vXVV
         FQXWkgTQ6w0QTjbI1S2NP+kjFobew89dcD+jFVpWnyofaV7k/9qlpaFaOcvpOADvJ7/z
         q4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyvZCSIw599hXY8qIGmPYEHcNcvhnGGazdKX2Yc9fkM=;
        b=uJmwTnlAg+FcK612Lzl+zQ/L9qwyRTuNHoCjI01F/3/IgIPPfoanKR2ulM2sYtxIZG
         hNclopNgnGr61ubvZL46D9az+/08/LmwKsYHb0VNs5ASVB57CvvFx43aO3Igk+770ckQ
         vQmBBh9gatN6a6Xittf480Z3MPzciecnf/73+buyn3lVz+zCVs64A/S5UryPolUorF9D
         5D5Eu2R/kKqXgPqU56trLLylpm2mhGwJWAO9Pm3bhyqTbRPOUTpND93jywLZmTzZvUhn
         InkUnir/91cmRwzE4Xk/Snm3mObhE11A30GXxTrQeI95ULMAlHPHEackscY1ZLcn3O15
         6d9Q==
X-Gm-Message-State: AOAM533xypCd8DOFT2cP8U++J6T46EMEMWB24A5q4GsyvtwZmMMUR/8F
        QV8PPLWm7ZRWXP+drJ5nua4=
X-Google-Smtp-Source: ABdhPJzqMQ3zIegLoAz1rOoBfMETiwGjU6Qii/B45D7q04+rUxmSegl8tdeL5tBqLAzkWEtWdVz7Kg==
X-Received: by 2002:ac8:2f64:: with SMTP id k33mr5501574qta.105.1589576218062;
        Fri, 15 May 2020 13:56:58 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:1b31])
        by smtp.gmail.com with ESMTPSA id k3sm2466784qkb.112.2020.05.15.13.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:56:57 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 1/2] Fix Makefile to delete objects from the library on make clean
Date:   Fri, 15 May 2020 16:56:48 -0400
Message-Id: <20200515205649.1670512-2-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
References: <20200515205649.1670512-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 1a7be53..c5f46f4 100644
--- a/Makefile
+++ b/Makefile
@@ -81,6 +81,7 @@ LIB_SRC         := $(wildcard lib/*.c)
 LIB_HEADERS     := $(wildcard lib/*.h) $(COMMON_HEADERS)
 STATIC_LIB_OBJ  := $(LIB_SRC:.c=.o)
 SHARED_LIB_OBJ  := $(LIB_SRC:.c=.shlib.o)
+LIB_OBJS        := $(SHARED_LIB_OBJ) $(STATIC_LIB_OBJ)
 
 # Compile static library object files
 $(STATIC_LIB_OBJ): %.o: %.c $(LIB_HEADERS) .build-config
-- 
2.26.2

