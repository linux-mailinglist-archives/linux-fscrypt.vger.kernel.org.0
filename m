Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AEC1177AE
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Dec 2019 21:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfLIUpy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 Dec 2019 15:45:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbfLIUpy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Dec 2019 15:45:54 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 857AC20637
        for <linux-fscrypt@vger.kernel.org>; Mon,  9 Dec 2019 20:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575924353;
        bh=opikFf8DAmL1In76qb//oBJ4CvS33zEPba5Tlm1ztck=;
        h=From:To:Subject:Date:From;
        b=QxB4vA69XzJCVySRmc34P6ksVXtSE8M/Qb0zy68Xkh/1Yjimsy+Mz+FDEZR71IFAE
         agtu+akoGZ88BZtuiRTEBYqCw9TDfOXKJGxZRwQ9FJAn4HqhqwJXE90lD0/GgX2SA7
         R2hTKzdZypVrAdqse8UmhXVFwrBC5HK1QRB7Wl2c=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: remove redundant bi_status check
Date:   Mon,  9 Dec 2019 12:45:09 -0800
Message-Id: <20191209204509.228942-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

submit_bio_wait() already returns bi_status translated to an errno.
So the additional check of bi_status is redundant and can be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/bio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 1f4b8a2770606..b88d417e186e5 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -77,8 +77,6 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 			goto errout;
 		}
 		err = submit_bio_wait(bio);
-		if (err == 0 && bio->bi_status)
-			err = -EIO;
 		bio_put(bio);
 		if (err)
 			goto errout;
-- 
2.24.0.393.g34dc348eaf-goog

