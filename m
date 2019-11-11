Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6DF81DB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Nov 2019 22:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKVFm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 Nov 2019 16:05:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbfKKVFm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 Nov 2019 16:05:42 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAB42214E0;
        Mon, 11 Nov 2019 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573506341;
        bh=uHsK7UuOsKShxsIA2IFPJosQ74sx59uTyVzrH9KsT08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpQGq/f9OdLjDUiyB7kuks1kuLsS9NDkd91ygnSTejG5yXVqM9PI6Xk/r2Ua6a3H9
         cs8AI+VJupaSPtHmkHt+JdrXNCT1vCSF2CvEDsmyHMfOlzyXigj0KjC0YbpLieKD6d
         GAq9K2+/d81rWT51EhJ3Us1lvwESU6oCa6FbF6Qw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [RFC PATCH 2/5] fscrypt-crypt-util: add HKDF context constants
Date:   Mon, 11 Nov 2019 13:04:24 -0800
Message-Id: <20191111210427.137256-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
In-Reply-To: <20191111210427.137256-1-ebiggers@kernel.org>
References: <20191111210427.137256-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use #defines rather than hard-coded numbers + comments.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index bafc15e0..30f5e585 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -1703,6 +1703,10 @@ struct key_and_iv_params {
 	bool file_nonce_specified;
 };
 
+#define HKDF_CONTEXT_KEY_IDENTIFIER	1
+#define HKDF_CONTEXT_PER_FILE_KEY	2
+#define HKDF_CONTEXT_PER_MODE_KEY	3
+
 /*
  * Get the key and starting IV with which the encryption will actually be done.
  * If a KDF was specified, a subkey is derived from the master key and the mode
@@ -1743,11 +1747,11 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 		break;
 	case KDF_HKDF_SHA512:
 		if (params->mode_num != 0) {
-			info[infolen++] = 3; /* HKDF_CONTEXT_PER_MODE_KEY */
+			info[infolen++] = HKDF_CONTEXT_PER_MODE_KEY;
 			info[infolen++] = params->mode_num;
 			file_nonce_in_iv = true;
 		} else if (params->file_nonce_specified) {
-			info[infolen++] = 2; /* HKDF_CONTEXT_PER_FILE_KEY */
+			info[infolen++] = HKDF_CONTEXT_PER_FILE_KEY;
 			memcpy(&info[infolen], params->file_nonce,
 			       FILE_NONCE_SIZE);
 			infolen += FILE_NONCE_SIZE;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

