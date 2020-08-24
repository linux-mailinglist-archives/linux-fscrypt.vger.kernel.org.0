Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B0B250A25
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 22:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgHXUj4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 16:39:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUj4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 16:39:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78602204EA;
        Mon, 24 Aug 2020 20:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598301595;
        bh=zHQu1QiHr7iVn0rq76g38CunRcQjlkL2Kf014Bwuc7s=;
        h=From:To:Cc:Subject:Date:From;
        b=cPQ7lTxBHONc8YbjaD0+ygL3GyeWYgL4xN3Pp5d46W7ddtHaJwQBbxIxXNMlq18wo
         7Y5dr0f+5vc/rf/nITn+ry5bzZdlzZfxYI7H/QTZBT99XOu7vC8nGOZ3GNi70aE98k
         YkExiMvQUVnEAkYTJd96mcugbme25lKWhnsOkxCM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jeff Layton <jlayton@kernel.org>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH] fscrypt: restrict IV_INO_LBLK_32 to ino_bits <= 32
Date:   Mon, 24 Aug 2020 13:38:41 -0700
Message-Id: <20200824203841.1707847-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

When an encryption policy has the IV_INO_LBLK_32 flag set, the IV
generation method involves hashing the inode number.  This is different
from fscrypt's other IV generation methods, where the inode number is
either not used at all or is included directly in the IVs.

Therefore, in principle IV_INO_LBLK_32 can work with any length inode
number.  However, currently fscrypt gets the inode number from
inode::i_ino, which is 'unsigned long'.  So currently the implementation
limit is actually 32 bits (like IV_INO_LBLK_64), since longer inode
numbers will have been truncated by the VFS on 32-bit platforms.

Fix fscrypt_supported_v2_policy() to enforce the correct limit.

This doesn't actually matter currently, since only ext4 and f2fs support
IV_INO_LBLK_32, and they both only support 32-bit inode numbers.  But we
might as well fix it in case it matters in the future.

Ideally inode::i_ino would instead be made 64-bit, but for now it's not
needed.  (Note, this limit does *not* prevent filesystems with 64-bit
inode numbers from adding fscrypt support, since IV_INO_LBLK_* support
is optional and is useful only on certain hardware.)

Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
Reported-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 2d73fd39ad96..b92f34523178 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -192,10 +192,15 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 					  32, 32))
 		return false;
 
+	/*
+	 * IV_INO_LBLK_32 hashes the inode number, so in principle it can
+	 * support any ino_bits.  However, currently the inode number is gotten
+	 * from inode::i_ino which is 'unsigned long'.  So for now the
+	 * implementation limit is 32 bits.
+	 */
 	if ((policy->flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) &&
-	    /* This uses hashed inode numbers, so ino_bits doesn't matter. */
 	    !supported_iv_ino_lblk_policy(policy, inode, "IV_INO_LBLK_32",
-					  INT_MAX, 32))
+					  32, 32))
 		return false;
 
 	if (memchr_inv(policy->__reserved, 0, sizeof(policy->__reserved))) {
-- 
2.28.0.297.g1956fa8f8d-goog

