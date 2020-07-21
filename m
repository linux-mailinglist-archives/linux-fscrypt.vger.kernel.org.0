Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD23F228802
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Jul 2020 20:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGUSLg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Jul 2020 14:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:46760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUSLg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Jul 2020 14:11:36 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91CAF20720;
        Tue, 21 Jul 2020 18:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595355095;
        bh=8PmokV2OOLmhOJcGzxltydoC6SNc4ybchJ4kJJykcWM=;
        h=From:To:Cc:Subject:Date:From;
        b=kO4W9ZhKEjO67C15PxdhGd0mkQ4ex6CD4DjfWXWPsgSgIbHe4fJG7yGUMOTdvC5lF
         XsRirzo70YHXKkubXVARHQf+brNyq9xgFikJwXiEGCVZ4/C0mB1EIZl9kk4HqOYB9/
         3SVtABIpfYg/BronmpYSvNUciJR0vU/pTxWHv9eM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: [PATCH] fscrypt: restrict IV_INO_LBLK_* to AES-256-XTS
Date:   Tue, 21 Jul 2020 11:10:12 -0700
Message-Id: <20200721181012.39308-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

IV_INO_LBLK_* exist only because of hardware limitations, and currently
the only known use case for them involves AES-256-XTS.  Therefore, for
now only allow them in combination with AES-256-XTS.  This way we don't
have to worry about them being combined with other encryption modes.

(To be clear, combining IV_INO_LBLK_* with other encryption modes
*should* work just fine.  It's just not being tested, so we can't be
100% sure it works.  So with no known use case, it's best to disallow it
for now, just like we don't allow other weird combinations like
AES-256-XTS contents encryption with Adiantum filenames encryption.)

This can be relaxed later if a use case for other combinations arises.

Fixes: b103fb7653ff ("fscrypt: add support for IV_INO_LBLK_64 policies")
Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 8a8ad0e44bb8..8e667aadf271 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -77,6 +77,20 @@ static bool supported_iv_ino_lblk_policy(const struct fscrypt_policy_v2 *policy,
 	struct super_block *sb = inode->i_sb;
 	int ino_bits = 64, lblk_bits = 64;
 
+	/*
+	 * IV_INO_LBLK_* exist only because of hardware limitations, and
+	 * currently the only known use case for them involves AES-256-XTS.
+	 * That's also all we test currently.  For these reasons, for now only
+	 * allow AES-256-XTS here.  This can be relaxed later if a use case for
+	 * IV_INO_LBLK_* with other encryption modes arises.
+	 */
+	if (policy->contents_encryption_mode != FSCRYPT_MODE_AES_256_XTS) {
+		fscrypt_warn(inode,
+			     "Can't use %s policy with contents mode other than AES-256-XTS",
+			     type);
+		return false;
+	}
+
 	/*
 	 * It's unsafe to include inode numbers in the IVs if the filesystem can
 	 * potentially renumber inodes, e.g. via filesystem shrinking.
-- 
2.27.0

