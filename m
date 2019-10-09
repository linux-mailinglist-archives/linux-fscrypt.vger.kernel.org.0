Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC542D1CFA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Oct 2019 01:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732353AbfJIXoO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Oct 2019 19:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbfJIXoO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Oct 2019 19:44:14 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 653C120659;
        Wed,  9 Oct 2019 23:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570664653;
        bh=ttUVmrIzuf0w22zjSvNcVAQBL4zgFKEq3DaArSdKV2Y=;
        h=From:To:Cc:Subject:Date:From;
        b=v/OYP3CyOlLnK2h3sAFmFUGU3iqw5O5dngP0EVdfJjPUZ/ArystkmFd08w34mNqSz
         pjiomgybOGYsjelIiBb3dYzL6k9NlbeQIHJ7JfQdKraMPjd1qngnEmM3MMI0nz26Mc
         4YdJTHcNq5ANvLpldLMsgV9LJAN6GWGIfFbZnkLc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fscrypt: avoid data race on fscrypt_mode::logged_impl_name
Date:   Wed,  9 Oct 2019 16:43:37 -0700
Message-Id: <20191009234337.225469-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The access to logged_impl_name is technically a data race, which tools
like KCSAN could complain about in the future.  See:
https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE

Fix by using xchg(), which also ensures that only one thread does the
logging.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keysetup.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 8eb5a0e762ec6..df3e1c8653884 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -81,15 +81,13 @@ struct crypto_skcipher *fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
 			    mode->cipher_str, PTR_ERR(tfm));
 		return tfm;
 	}
-	if (unlikely(!mode->logged_impl_name)) {
+	if (!xchg(&mode->logged_impl_name, true)) {
 		/*
 		 * fscrypt performance can vary greatly depending on which
 		 * crypto algorithm implementation is used.  Help people debug
 		 * performance problems by logging the ->cra_driver_name the
-		 * first time a mode is used.  Note that multiple threads can
-		 * race here, but it doesn't really matter.
+		 * first time a mode is used.
 		 */
-		mode->logged_impl_name = true;
 		pr_info("fscrypt: %s using implementation \"%s\"\n",
 			mode->friendly_name,
 			crypto_skcipher_alg(tfm)->base.cra_driver_name);
-- 
2.23.0.581.g78d2f28ef7-goog

