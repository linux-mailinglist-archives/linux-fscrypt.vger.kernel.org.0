Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CF4117789
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 21:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLIUjM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 15:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbfLIUjM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 15:39:12 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BB120637
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 Dec 2019 20:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575923952;
        bh=U6WXEbZKl+mSOP6Y2A/4wGgK4mVmqZAPahRm88sn8OI=;
        h=From:To:Subject:Date:From;
        b=m3dPETZaLmoSXHRcUxbzCTHrZDEop98Aml25DBBuOkYdcvWcLMzTUEXQkOIxNdexk
         SOQcV9uLxwsh3Lp5VIDhrAkTXBW6PeqTgCAeK5aJ3VoSDsA0nePMy62TOYwUPlSdKp
         koAXMcYTP1Ds2BxAxbkYduwAVEcYi5jij3e3cszU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: use crypto_skcipher_driver_name()
Date:   Mon,  9 Dec 2019 12:38:10 -0800
Message-Id: <20191209203810.225302-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Crypto API users shouldn't really be accessing struct skcipher_alg
directly.  <crypto/skcipher.h> already has a function
crypto_skcipher_driver_name(), so use that instead.

No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keysetup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index f577bb6613f93..c9f4fe955971f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -89,8 +89,7 @@ struct crypto_skcipher *fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
 		 * first time a mode is used.
 		 */
 		pr_info("fscrypt: %s using implementation \"%s\"\n",
-			mode->friendly_name,
-			crypto_skcipher_alg(tfm)->base.cra_driver_name);
+			mode->friendly_name, crypto_skcipher_driver_name(tfm));
 	}
 	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	err = crypto_skcipher_setkey(tfm, raw_key, mode->keysize);
-- 
2.24.0.393.g34dc348eaf-goog

