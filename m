Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5854C11778F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 21:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfLIUlE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 15:41:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:43634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfLIUlE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 15:41:04 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6FC20637
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 Dec 2019 20:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575924063;
        bh=EW1C0ROqxD4FMRWznfFSjk/fG6XDoRvqmw+k1XUxpUA=;
        h=From:To:Subject:Date:From;
        b=k3ywIowaOJ7hLStkd5Fxg0egNobLLFHlPx3mZQOMS0eg6HLO6Tcg9XhPEI0LcE6SE
         GD0DfoMlN5xXqMkYy9YCWh91MZDX3ZIhI2Ir10bkmYmXDdfCtX8bID/RNXD0+4/uSf
         zHy3q0IiIw4GO6ufNEl84d9rTFJzmRDA7hReZzjg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: constify struct fscrypt_hkdf parameter to fscrypt_hkdf_expand()
Date:   Mon,  9 Dec 2019 12:40:54 -0800
Message-Id: <20191209204054.227736-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Constify the struct fscrypt_hkdf parameter to fscrypt_hkdf_expand().
This makes it clearer that struct fscrypt_hkdf contains the key only,
not any per-request state.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 2 +-
 fs/crypto/hkdf.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 130b50e5a0115..23cef4d3793a5 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -287,7 +287,7 @@ extern int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
 #define HKDF_CONTEXT_DIRECT_KEY		3
 #define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 
-extern int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
+extern int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			       const u8 *info, unsigned int infolen,
 			       u8 *okm, unsigned int okmlen);
 
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index f21873e1b4674..efb95bd19a894 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -112,7 +112,7 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
  * adds to its application-specific info strings to guarantee that it doesn't
  * accidentally repeat an info string when using HKDF for different purposes.)
  */
-int fscrypt_hkdf_expand(struct fscrypt_hkdf *hkdf, u8 context,
+int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
 			u8 *okm, unsigned int okmlen)
 {
-- 
2.24.0.393.g34dc348eaf-goog

