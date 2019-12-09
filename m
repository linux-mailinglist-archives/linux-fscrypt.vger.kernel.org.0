Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4211784D
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 22:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfLIVTY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbfLIVTY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 16:19:24 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 995622077B;
        Mon,  9 Dec 2019 21:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575926363;
        bh=6FVkRlG5KKy/tpIJ9gSiELJuRX721e3LnTCgXc1GdLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKEId9lsGHiN+vn2h3RzDh15xpn4kSvDmGyu/1pTr2/lJvkb/E8K0ddDF8ZPQ7bke
         pkaEYo4j0GxCKjl5Z48EavOgLnafmZ0q3vZjqG0MDv+kFQKYx3CR39cNSA47C0y7ow
         YDhG2vKi81iS2dkIwBDFAHmUmy2aNnDjbX/QFxCk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Daniel Rosenberg <drosen@google.com>
Subject: [PATCH 4/4] fscrypt: remove fscrypt_is_direct_key_policy()
Date:   Mon,  9 Dec 2019 13:18:29 -0800
Message-Id: <20191209211829.239800-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191209211829.239800-1-ebiggers@kernel.org>
References: <20191209211829.239800-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

fscrypt_is_direct_key_policy() is no longer used, so remove it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 71f496fe71732..b22e8decebedd 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -136,12 +136,6 @@ fscrypt_policy_flags(const union fscrypt_policy *policy)
 	BUG();
 }
 
-static inline bool
-fscrypt_is_direct_key_policy(const union fscrypt_policy *policy)
-{
-	return fscrypt_policy_flags(policy) & FSCRYPT_POLICY_FLAG_DIRECT_KEY;
-}
-
 /**
  * For encrypted symlinks, the ciphertext length is stored at the beginning
  * of the string in little-endian format.
-- 
2.24.0.393.g34dc348eaf-goog

