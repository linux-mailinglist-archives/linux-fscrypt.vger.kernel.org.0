Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D9E1B8137
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgDXUzW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:21 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86FDC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:21 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b62so11667593qkf.6
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1XWgoTLbbfNyoOgWoNuvi4Hn0k1i+AG+ATc+s7+HBQ=;
        b=VTEbKAsS9SnmHPNWr8EXWceic3yw6fvg39pPP2aR3EP0Jj2wyGC4fPh8xKyj+68RXN
         hOFd3LQFP3UXxnk4guzh8SOaWIS94xbIxFpBfQXZJcAhLhjHfpAYjFRPLWOlxaO7KqcT
         n4dAof22QYtMP5zEw8P4dZF2EAG0QFrNqdqS4eApEkMVJTny959aoxZooALPFjJGulns
         olqmGuS/gLKIEy6UjVwysE+zFFL9AuxeizAru43XCsszPqLl7iLiqBwYsp+sRZKNFQkn
         ij9NeMueESWc0/SGBiQx2HXFZWuULyOBCjUSJ+9rQ/e5Hg0poQ6cbrkuXHey0xJqzVBk
         5YEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1XWgoTLbbfNyoOgWoNuvi4Hn0k1i+AG+ATc+s7+HBQ=;
        b=ex0M6uALTvW1GxUQ1UEgr3/4s+jF3D53Nb3hE1+q03knYEYxHGcbiEH25sc0z0SXCD
         5p9OhItXfaFlts1XqEMf98BEv8l17eSfll2n2aMIUUPL4sgMeEOvHfL5/kYRnQxEVcd3
         21wAl1PlOKZw4okcmYFiwlGPpJRZnyvQNq43iBhdkL80JVVTAxtLmto+7cXLcJOt7YOr
         bqm8HGC0hVdveYYBuqojqt0oqZSm1mC2elb8qCx9pm5vbaRlsqt2xOKwYacRGQKPPph5
         TLDnK6Y7aJpgW6lDcvWzNoEBqk/SlBdYIUcXyA9wYao2mG0YhCd6R4oplRIyZQjSiLl0
         Icfg==
X-Gm-Message-State: AGi0PuaUxiRYqiLONMXxuZaBl5pdaddtpoIfMQXKTdkNsdj3OmUZqOOm
        r2UgT0xT0M5FaHrCaOsVI/nqfcYonQs=
X-Google-Smtp-Source: APiQypK4onCHjZnh9pFVfqQxOpNzZSpIYivoxgiTyy9Tv9q0mRUyxvtMK2j3pkcHw6fhwWr3sx0/ow==
X-Received: by 2002:a37:6ce:: with SMTP id 197mr10543774qkg.495.1587761720621;
        Fri, 24 Apr 2020 13:55:20 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id j2sm4530324qth.57.2020.04.24.13.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:19 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 08/20] Validate input parameters for libfsverity_sign_digest()
Date:   Fri, 24 Apr 2020 16:54:52 -0400
Message-Id: <20200424205504.2586682-9-Jes.Sorensen@gmail.com>
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
2.25.3

