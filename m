Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E20F2AE60D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 02:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731713AbgKKBwv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Nov 2020 20:52:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731610AbgKKBwu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Nov 2020 20:52:50 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71F5C216C4;
        Wed, 11 Nov 2020 01:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605059569;
        bh=TJ6ir93AFmz8PfLOms2XdxoiadqyHjUx+rfVbMNTzUg=;
        h=From:To:Cc:Subject:Date:From;
        b=U5Fjvl1qn+Nyza7ZGY4YG9S3NiLz86CYAekL3oJLA/+AcX9S0hMtr6khHYNtvAmyk
         x8L1xNfrOXDdvfQ+DccFHc8oppV3MsudwyKw8sTO198OFmKHpnm+kQZrMmR4F3UYXQ
         1zzRTIcpp1B6bdwhUGdyzSpcJ2bBVqRwgqulc5To=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] fscrypt: fix inline encryption not used on new files
Date:   Tue, 10 Nov 2020 17:52:24 -0800
Message-Id: <20201111015224.303073-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The new helper function fscrypt_prepare_new_inode() runs before
S_ENCRYPTED has been set on the new inode.  This accidentally made
fscrypt_select_encryption_impl() never enable inline encryption on newly
created files, due to its use of fscrypt_needs_contents_encryption()
which only returns true when S_ENCRYPTED is set.

Fix this by using S_ISREG() directly instead of
fscrypt_needs_contents_encryption(), analogous to what
select_encryption_mode() does.

I didn't notice this earlier because by design, the user-visible
behavior is the same (other than performance, potentially) regardless of
whether inline encryption is used or not.

Fixes: a992b20cd4ee ("fscrypt: add fscrypt_prepare_new_inode() and fscrypt_set_context()")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/inline_crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 89bffa82ed74a..c57bebfa48fea 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -74,7 +74,7 @@ int fscrypt_select_encryption_impl(struct fscrypt_info *ci)
 	int i;
 
 	/* The file must need contents encryption, not filenames encryption */
-	if (!fscrypt_needs_contents_encryption(inode))
+	if (!S_ISREG(inode->i_mode))
 		return 0;
 
 	/* The crypto mode must have a blk-crypto counterpart */

base-commit: 92cfcd030e4b1de11a6b1edb0840e55c26332d31
-- 
2.29.2

