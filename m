Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B058972BF4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jul 2019 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfGXKCN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jul 2019 06:02:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33734 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfGXKCM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jul 2019 06:02:12 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so20698444pfq.0;
        Wed, 24 Jul 2019 03:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2Q3f3xydka7q3ymH0VxHJXXLNdtWTBhTzvay6ryonzE=;
        b=gwYzjHg8wMJUW0gU6PSlyM/gtX6tHNT93Avn0ySZQkTj2uKOHqd0+eTJbDvJNkgQKR
         sz4lR15xN1XC3gA8NXCghnts7CY677fukDapKHw+5E2eoZ55k/U0zmtJ4by6fogMqrsg
         lsDF3kya2tKsNzavMe3sgbNQgp9zHp4KBKVxswIU/BM0d3SvjT1mj4aWpXlvHXfPbgp8
         VJYjZpH6bJoo6yhxEHuq3pj8CysXP3FJHFl/B4K/NL23JRQRhWhWZqXnULjOPNOgOPPG
         ycGpOCMTwYGQN1fYsvfR2Q9bSg/jueJvm8bjM/7KrBXtyickJZnrlskdJp3y9365J1xq
         O1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2Q3f3xydka7q3ymH0VxHJXXLNdtWTBhTzvay6ryonzE=;
        b=tMcPDKlgkVhA49UEcoB3snldbttvCWyRBitNMA+Us5Oqxr8ajI+dsSdw/OPu3UvP6C
         kTj5c/IkQW/mZQolsZIaA0XSwlm6rlDLjmf9gPwXsILY45lXmpYLXOmjjRQYmSyoo9wa
         U0gD1kzjC0POzNR0CPokDaTo3TkyVuZk/6CNrswWJm+4xF0fKAw0aOu4DB9u/+aIeNOi
         t06adze10uTiM2pKY08Xd5h+/GuZBjbFV68f/ZwgnIlvqGspKAQdxbCckbpMCro5U1Yv
         PDCZyfwJfEoIYhbbgTi4ArxCjGQqLm9yiTaJnaT9hW3Ppto0/f8ZNIAzWnV9MPKm2KEW
         QdVA==
X-Gm-Message-State: APjAAAVzG1IX+s70flKd+0hGYT1gXWKiTTo1lmztJVY41wOu8zUszDBW
        xChLebdkZGyOoIMiA5g/cARMmBPaw3M=
X-Google-Smtp-Source: APXvYqy9h9/h7AcvlkRbZ+l2a5DNDLfouT8ZdbDL1piYeGZBNiVBUwhJfBxxoS03lyvL1Gy4wTxgNg==
X-Received: by 2002:a17:90a:214e:: with SMTP id a72mr45532046pje.0.1563962531944;
        Wed, 24 Jul 2019 03:02:11 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id q69sm64083603pjb.0.2019.07.24.03.02.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:02:11 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] fs: crypto: keyinfo: Fix a possible null-pointer dereference in derive_key_aes()
Date:   Wed, 24 Jul 2019 18:02:04 +0800
Message-Id: <20190724100204.2009-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

In derive_key_aes(), tfm is assigned to NULL on line 46, and then
crypto_free_skcipher(tfm) is executed.

crypto_free_skcipher(tfm)
    crypto_skcipher_tfm(tfm)
        return &tfm->base;

Thus, a possible null-pointer dereference may occur.

To fix this bug, tfm is checked before calling crypto_free_skcipher().

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 fs/crypto/keyinfo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index 207ebed918c1..b419720cac54 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -66,7 +66,8 @@ static int derive_key_aes(const u8 *master_key,
 	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
 out:
 	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
+	if (tfm)
+		crypto_free_skcipher(tfm);
 	return res;
 }
 
-- 
2.17.0

