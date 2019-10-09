Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC92D1CFC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Oct 2019 01:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfJIXpY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Oct 2019 19:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730955AbfJIXpX (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Oct 2019 19:45:23 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4928320659;
        Wed,  9 Oct 2019 23:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570664723;
        bh=y2e5vxGj/vLVzj42btAsyM2YyXmENlcvk2QxCq65hCA=;
        h=From:To:Cc:Subject:Date:From;
        b=mdNxCHaUoa1oA6a+UhrBQOtavoEEx245ZWKiEeOnpvaT31sPSTwaD8p6MgaBx9oSK
         WI3xvwnaOBwlS8gW6PcguMDEOr5FfZvLSaaCdE38GLIS9mIsdh/0QjnrrOoZYi+CDE
         /Ei9FT+O+sbdkAK++iCoQQ4eHzkb0c97EKJ5sSMA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] fscrypt: zeroize fscrypt_info before freeing
Date:   Wed,  9 Oct 2019 16:44:42 -0700
Message-Id: <20191009234442.225847-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

memset the struct fscrypt_info to zero before freeing.  This isn't
really needed currently, since there's no secret key directly in the
fscrypt_info.  But there's a decent chance that someone will add such a
field in the future, e.g. in order to use an API that takes a raw key
such as siphash().  So it's good to do this as a hardening measure.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keysetup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index df3e1c8653884..0ba33e010312f 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -325,6 +325,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
 			key_invalidate(key);
 		key_put(key);
 	}
+	memzero_explicit(ci, sizeof(*ci));
 	kmem_cache_free(fscrypt_info_cachep, ci);
 }
 
-- 
2.23.0.581.g78d2f28ef7-goog

