Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F583267EB8
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgIMIil (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgIMIiD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:03 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADEDA21897;
        Sun, 13 Sep 2020 08:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986279;
        bh=ZzMv1pUhY0NvnbJHjrS2ra7ESt6vtXPBJHTWIdsGFCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=htn5yvO7LimZHQRe0sNzsC6HWpNV2ozCcjLCoxA2U9dMCvVUhX+F3sLgJGNsNeThm
         Qpm56LCeKLX/y+YPmuNFV3XiL6WWzw4EGH/L7x1ZgQem4c6oYP9lj9QNygbClngGw9
         gIDlHOloDtyrRG1uzwwilmGP9u8I6vN0pvLAbntk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 07/11] fscrypt: require that fscrypt_encrypt_symlink() already has key
Date:   Sun, 13 Sep 2020 01:36:16 -0700
Message-Id: <20200913083620.170627-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200913083620.170627-1-ebiggers@kernel.org>
References: <20200913083620.170627-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all filesystems have been converted to use
fscrypt_prepare_new_inode(), the encryption key for new symlink inodes
is now already set up whenever we try to encrypt the symlink target.
Enforce this rather than try to set up the key again when it may be too
late to do so safely.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/hooks.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 491b252843eb9..7748db5092409 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -217,9 +217,13 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 	struct fscrypt_symlink_data *sd;
 	unsigned int ciphertext_len;
 
-	err = fscrypt_require_key(inode);
-	if (err)
-		return err;
+	/*
+	 * fscrypt_prepare_new_inode() should have already set up the new
+	 * symlink inode's encryption key.  We don't wait until now to do it,
+	 * since we may be in a filesystem transaction now.
+	 */
+	if (WARN_ON_ONCE(!fscrypt_has_encryption_key(inode)))
+		return -ENOKEY;
 
 	if (disk_link->name) {
 		/* filesystem-provided buffer */
-- 
2.28.0

