Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E39EA183BAF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCLVsb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:31 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40245 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:31 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so9000373qka.7
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TbwQ8Nkh9ryZ62Z61Q+wwi0GmxpOzNF5ROiOILlzUo8=;
        b=YHKyny6j6lJGx4otKkM4evYgGnamgtqbHEzummHb2s2k7mCLloq5ZqvpXZ59BHe8J3
         gEOFvAYRFiRuXI4o12X345owXdTjXfoeK+igM8maTnfCJXEEDIhKQU3ercj1cdY1h0yK
         /0uGEPoL08PxIIEt1NQ6cuCnJC4qnWeAejnm5dwiNA4aYOrMrzUwbrFcVuseL7OXVlRx
         z/UecToukr/T5jIO1Yz8I5TYl/1zg2bRXziPrFY6DmZzHdo5rADlkJvb3tbXPjEQc28j
         fX4bJkbkj8EgfZgh1I1prgcRE36kPY7i0Sy8k+jqQ59i8rbv6Kxr9jG+Xga56+qkgQwK
         miow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TbwQ8Nkh9ryZ62Z61Q+wwi0GmxpOzNF5ROiOILlzUo8=;
        b=FxCTaEXngUk5bKoY7hlZtoJ1lDz4tTu3sN1CZwcvQUISjKo/8RqOwePgqduCSS4BKc
         wlf6DNgVyypb6bJS9RZZ1v6nIm7fjRJOx27Vp3STA+BQvDVhsuiTjeBxHNcOqlG9zHyj
         1DAtneqxf6Q8mIgcDU/+FgFqvPLC7hoZHJANVdxQyNTNIsYruSrJRjimyMKE0NPV5ba6
         I/iJbnhEBdBDhturaimbTglOA+gz/SmBYryQ4Jtx3toEIm7iDyc2HSelA6mBPcGgm2GD
         8x/g6uALeFqbM+mNtHwSxJ/mjezW3S/Kf5TeNTE8VhouPjXbfODsRI+qq/ylGlUiUk8u
         Ytlg==
X-Gm-Message-State: ANhLgQ1GDFAWxuLlVYYVUIY+NuEhDDGyE6WREdEA9GuBhE1BJ/uUaEK7
        JrurkiYFnGur6IXtTES8J2pjFZ9L
X-Google-Smtp-Source: ADFU+vt+m/A5RadJSYzoUS4oaiyiJ3oh2e1u6EC8FqCyDLS0QnFFlLsA3mNCPtG+vKB6jv0rtZ4/1g==
X-Received: by 2002:a37:bb03:: with SMTP id l3mr10005731qkf.458.1584049710222;
        Thu, 12 Mar 2020 14:48:30 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id n50sm3162990qtc.5.2020.03.12.14.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:29 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 7/9] Validate input arguments to libfsverity_compute_digest()
Date:   Thu, 12 Mar 2020 17:47:56 -0400
Message-Id: <20200312214758.343212-8-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
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
2.24.1

