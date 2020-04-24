Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFFB1B8136
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgDXUzU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:20 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E858C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:20 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id t3so11726835qkg.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E96jDFgmrTPMEPk8PEAd+nFy7mta2D7nDsQ8W6eMzBw=;
        b=H3autukElpXqA6Ab3P0gkc6pvi7ZRKXFo9PfQKRpWzKMu1Nd+2h9K1Ia2kK7NanAFP
         RSIIJ9nMMC8XAxoXqDwh8JDJ/csef02aqh0QRYvQDlNt5Gq+3gewvaM3PMqvq3sfB7qa
         BucW3NoKrXmbLdIZqHff2sWJ3Ybg/eD5GBz1CJjkOjoTSysnTK3P9Am+E476VT92mnr5
         k8tpRlWtUx083eXrQRP1kQYxdy/rrasmM3y1qWn5QUpxopmakT+i7UnjMYBX/fep/oN7
         t4Yc8eVB3avOng5RrGDFzUMY7Jlue57SRMGogi7bNbhVwdYFKvvgEdgDfs9iLveCgD67
         pwJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E96jDFgmrTPMEPk8PEAd+nFy7mta2D7nDsQ8W6eMzBw=;
        b=EZ8Jz7eQnULeO50biKdQqvbssqdoRSlYm3o3zeLZyPV/tbfpLosi1AKgtVOTkhzszr
         XbNPSwMy43cGYjU2D4FtHUnc0rk71Qi+23nIGgeGFsar0N+lAjV6fUmTCPjNvX8lToge
         Gvi9UXSl32Ogq+jnYdsF0wcSGi8SOm8yrB/7pNBpkQxRwsb1a702LBSaLRKSoZm0Q8tn
         7T8462AemsjRfbY1zBLbDHT6/wnmpqiKX7LGlKp5fKmsauyO08SrYokMNZOTK1/Wwy4Q
         X6ILnUGevOahITgpyn7VsEl6g/pZpys4CIFHvjTFqex5xTjbactVmEe6OvZq2/ECJ27f
         mV2A==
X-Gm-Message-State: AGi0PuaF/GLH8xxP3AIQHWVBw4Q06BH9E3Ir/JQZ4ef64exDhQaO8u0S
        UM4D6qEO7aokcLKfUHt0CHNY76M7bSc=
X-Google-Smtp-Source: APiQypIoCdPifJYRuH04mNatGjCRvkKzWQYMEfauQBmHVxBw8pSopgWqmW+XMFFIyJWG02GHJhEbOA==
X-Received: by 2002:a37:9105:: with SMTP id t5mr11482029qkd.202.1587761718999;
        Fri, 24 Apr 2020 13:55:18 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id 11sm4529928qkg.122.2020.04.24.13.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:18 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 07/20] Validate input arguments to libfsverity_compute_digest()
Date:   Fri, 24 Apr 2020 16:54:51 -0400
Message-Id: <20200424205504.2586682-8-Jes.Sorensen@gmail.com>
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

If any argument is invalid, return -EINVAL. Similarly
if any of the reserved fields in the params struct
are set, return -EINVAL;

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 libverity.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/libverity.c b/libverity.c
index 183259e..1cef544 100644
--- a/libverity.c
+++ b/libverity.c
@@ -155,9 +155,31 @@ libfsverity_compute_digest(int fd,
 	struct fsverity_descriptor desc;
 	struct stat stbuf;
 	u64 file_size;
-	int retval = -EINVAL;
+	int i, retval = -EINVAL;
+
+	if (!digest_ret)
+		return -EINVAL;
+	if (params->version != 1)
+		return -EINVAL;
+	if (!is_power_of_2(params->block_size))
+		return -EINVAL;
+	if (params->salt_size > sizeof(desc.salt)) {
+		error_msg("Salt too long (got %u bytes; max is %zu bytes)",
+			  params->salt_size, sizeof(desc.salt));
+		return -EINVAL;
+	}
+	if (params->salt_size && !params->salt)
+		return -EINVAL;
+	for (i = 0;
+	     i < sizeof(params->reserved) / sizeof(params->reserved[0]); i++) {
+		if (params->reserved[i])
+			return -EINVAL;
+	}
 
 	hash_alg = libfsverity_find_hash_alg_by_num(params->hash_algorithm);
+	if (!hash_alg)
+		return -EINVAL;
+
 	hash = hash_alg->create_ctx(hash_alg);
 
 	digest = malloc(sizeof(struct libfsverity_digest) +
@@ -180,16 +202,9 @@ libfsverity_compute_digest(int fd,
 	desc.version = 1;
 	desc.hash_algorithm = params->hash_algorithm;
 
-	ASSERT(is_power_of_2(params->block_size));
 	desc.log_blocksize = ilog2(params->block_size);
 
 	if (params->salt_size != 0) {
-		if (params->salt_size > sizeof(desc.salt)) {
-			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
-				  params->salt_size, sizeof(desc.salt));
-			retval = EINVAL;
-			goto error_out;
-		}
 		memcpy(desc.salt, params->salt, params->salt_size);
 		desc.salt_size = params->salt_size;
 	}
-- 
2.25.3

