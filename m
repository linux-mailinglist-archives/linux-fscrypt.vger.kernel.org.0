Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF13DF700
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2019 22:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfJUUtR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 16:49:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730052AbfJUUtQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 16:49:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7C72207FC;
        Mon, 21 Oct 2019 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571690956;
        bh=qC8cchkpfcx4MIC8fYmBTExkB3AuQjmcXkE0wh02A/g=;
        h=From:To:Cc:Subject:Date:From;
        b=vckhmIDNmI0N+PRcC5b+qiJwNqfxel2AZI6Eb2vcnaF9EjCU4QMQmsczLggDOaokc
         DxdtPrTrlzOkKyQT0d/0WKGT/Uyyeg6xSeed5Ps3q5IA+i8ax1v+8U5LNwtxMcNcb2
         kxaSLVS+S5+b8G0tK79JupK3B2xJ67Poiycqqiis=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fscrypt: avoid data race on fscrypt_mode::logged_impl_name
Date:   Mon, 21 Oct 2019 13:49:03 -0700
Message-Id: <20191021204903.56528-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
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

This also required switching from bool to int, to avoid a build error on
the RISC-V architecture which doesn't implement xchg on bytes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 2 +-
 fs/crypto/keysetup.c        | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index dacf8fcbac3be..d9a3e8614049f 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -435,7 +435,7 @@ struct fscrypt_mode {
 	const char *cipher_str;
 	int keysize;
 	int ivsize;
-	bool logged_impl_name;
+	int logged_impl_name;
 };
 
 static inline bool
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index b03b33643e4b2..28bc2da9be3c7 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -81,15 +81,13 @@ struct crypto_skcipher *fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
 			    mode->cipher_str, PTR_ERR(tfm));
 		return tfm;
 	}
-	if (unlikely(!mode->logged_impl_name)) {
+	if (!xchg(&mode->logged_impl_name, 1)) {
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
2.23.0.866.gb869b98d4c-goog

