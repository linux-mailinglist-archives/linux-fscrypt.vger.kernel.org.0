Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5447B183BB0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCLVsh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:37 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33121 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id d22so5796554qtn.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mboe5DkI6RRf3Q66k+PqyztyiTAhipJjuCV9W1VjrMw=;
        b=uOo3ZX39HGcaRDhv+vyer2HyZrTfHp1qwV0XZELLjJQ8BXZXv/piDLYwhFPrtP+O0F
         GLYOWBDaXMIOHidYnBBsxfQQUFcWtVxl7xubFW4cFGqrrqhh0TvvzS3ZkdV3Xjg8aUIh
         ApXY1ujfWVYBEDo5/n66z+9jSzOK5F820NkV6Eft4VCNdkr1Nx7tF7nyYId4lTQKDtzK
         0H+QTyMjHpqQXe32apslr7JphPyCnAHlvQPMl6/dlr2syOID6eqjFVTtgro3L7CR3uM3
         bnD/u79d58NPX7DUSrG5VUqcQkevTiOkpkeeF7LnTxU8KtWNYM29mY8lOL+d2VZ+wwnU
         KUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mboe5DkI6RRf3Q66k+PqyztyiTAhipJjuCV9W1VjrMw=;
        b=JMCFBOm7QLVoI+TwarShu3iYeesEqnS25j99RMMxqNvDrdcscU+DYiUHFOwsgmcGUF
         0ZXlcO5WlBEAwzBx38BIcZva2ogg+L6oVpnuiSxFiCAs+KSE/Eq36k1c2jntqbFxUqQ0
         OabHgH+XbC9Y9tXSWaP6DHqOSZas8jExBXof54Kbn0g/Q3jy6PbK3Lf3Y/FSrW7CTgOx
         pLnXKB7aGbUv6bvkIiKSqZ21bbJJfovqkSNVhKrf5Vp7pBYP2wnkvVkQFCZD1EmXWUfN
         wkyx1SFLhYfmZa5JLsHpXM9RX961XI0yYH/yVRPQdZ5F9mXdInHzGfERmBINiDJrYMWH
         UddQ==
X-Gm-Message-State: ANhLgQ3Bn7vnRYogvrpuGyxhOBAqkYxlweTCsIEadlSOYJj3L5IsHl8O
        0jFEJ2IAeK5YezrVJUd0sYU+0/bY
X-Google-Smtp-Source: ADFU+vvupx1KkgC3R/uwHWhGJOHcIYGK++rUXemUvTu5dfuYdyQcOV0GPPgtiHPlntw3bBEtm5l+ZA==
X-Received: by 2002:ac8:7210:: with SMTP id a16mr2084252qtp.167.1584049713658;
        Thu, 12 Mar 2020 14:48:33 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id a141sm28620587qkb.50.2020.03.12.14.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:33 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 8/9] Validate input parameters for libfsverity_sign_digest()
Date:   Thu, 12 Mar 2020 17:47:57 -0400
Message-Id: <20200312214758.343212-9-Jes.Sorensen@gmail.com>
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

Return -EINVAL on any invalid input argument, as well
as if any of the reserved fields are set in
struct libfsverity_signature_digest

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 libverity.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/libverity.c b/libverity.c
index 1cef544..e16306d 100644
--- a/libverity.c
+++ b/libverity.c
@@ -494,18 +494,36 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 	X509 *cert = NULL;
 	const EVP_MD *md;
 	size_t data_size;
-	uint16_t alg_nr;
-	int retval = -EAGAIN;
+	uint16_t alg_nr, digest_size;
+	int i, retval = -EAGAIN;
+	const char magic[8] = "FSVerity";
+
+	if (!digest || !sig_params || !sig_ret || !sig_size_ret)
+		return -EINVAL;
+
+	if (strncmp(digest->magic, magic, sizeof(magic)))
+		return -EINVAL;
+
+	if (!sig_params->keyfile || !sig_params->certfile)
+		return -EINVAL;
+
+	for (i = 0; i < sizeof(sig_params->reserved) /
+		     sizeof(sig_params->reserved[0]); i++) {
+		if (sig_params->reserved[i])
+			return -EINVAL;
+	}
+
+	digest_size = le16_to_cpu(digest->digest_size);
+	data_size = sizeof(struct libfsverity_digest) + digest_size;
 
-	data_size = sizeof(struct libfsverity_digest) +
-		le16_to_cpu(digest->digest_size);
 	alg_nr = le16_to_cpu(digest->digest_algorithm);
 	hash_alg = libfsverity_find_hash_alg_by_num(alg_nr);
 
-	if (!hash_alg) {
-		retval = -EINVAL;
-		goto out;
-	}
+	if (!hash_alg)
+		return -EINVAL;
+
+	if (digest_size != hash_alg->digest_size)
+		return -EINVAL;
 
 	pkey = read_private_key(sig_params->keyfile);
 	if (!pkey) {
-- 
2.24.1

