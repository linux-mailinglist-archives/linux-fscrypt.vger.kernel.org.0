Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1E2CFE0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 28 May 2019 22:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfE1UAH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 28 May 2019 16:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfE1UAH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 28 May 2019 16:00:07 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC9BF20B1F
        for <linux-fscrypt@vger.kernel.org>; Tue, 28 May 2019 20:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559073606;
        bh=sVc/R+PNWgS/ThzbZ7+i23TFvXq/+8pmX3wpeX1ObSc=;
        h=From:To:Subject:Date:From;
        b=VAGIY90YeEhySO7uB4RzCqflcweqr/irnVbeYqrYkC6m0wlU1w3yVTSZGtQK/MRx+
         ohZVrgHcPsye2Y/Ys3tKDdSlr/d7P6NNkD66Ra0+H8dNjgTjTdMQPSOEcpUzDUUNqK
         wUyIGE6KXJcUfeJjfPrzxo0MToJPUpnQoJoinbKo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: remove unnecessary includes of ratelimit.h
Date:   Tue, 28 May 2019 12:59:08 -0700
Message-Id: <20190528195908.77031-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

These should have been removed during commit 544d08fde258 ("fscrypt: use
a common logging function"), but I missed them.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c   | 1 -
 fs/crypto/hooks.c   | 1 -
 fs/crypto/keyinfo.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index eccea3d8f9234..00d150ff30332 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/scatterlist.h>
-#include <linux/ratelimit.h>
 #include <crypto/skcipher.h>
 #include "fscrypt_private.h"
 
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index bd525f7573a49..c1d6715d88e93 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -5,7 +5,6 @@
  * Encryption hooks for higher-level filesystem operations.
  */
 
-#include <linux/ratelimit.h>
 #include "fscrypt_private.h"
 
 /**
diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
index dcd91a3fbe49a..207ebed918c15 100644
--- a/fs/crypto/keyinfo.c
+++ b/fs/crypto/keyinfo.c
@@ -12,7 +12,6 @@
 #include <keys/user-type.h>
 #include <linux/hashtable.h>
 #include <linux/scatterlist.h>
-#include <linux/ratelimit.h>
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/sha.h>
-- 
2.22.0.rc1.257.g3120a18244-goog

