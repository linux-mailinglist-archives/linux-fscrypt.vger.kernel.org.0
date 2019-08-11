Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16E8947D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Aug 2019 23:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfHKVhP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Aug 2019 17:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfHKVhO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Aug 2019 17:37:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C5E2173C;
        Sun, 11 Aug 2019 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565559433;
        bh=u8BxT9tQSHf5ZOVsehPoiYiYgC4+Zhfv2J2bExWNYqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2oOqANPN/hXWIFA8+pGhszghBRjkfyAX2dae3QJMC1lP+6wiUBR5fv6sPW5uaCu1
         b4ZkAGpYnIZ0R4diwtbEmI2QGLtphv/ht7O+e9ZEL8DSbWX6+5gBzQFVT+olcR/VYs
         5Me/KYJFmTBNQWy0EYjfQLAEmouY1g4bmkI4wB2A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 6/6] f2fs: use EFSCORRUPTED in f2fs_get_verity_descriptor()
Date:   Sun, 11 Aug 2019 14:35:57 -0700
Message-Id: <20190811213557.1970-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190811213557.1970-1-ebiggers@kernel.org>
References: <20190811213557.1970-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

EFSCORRUPTED is now defined in f2fs.h, so use it instead of EUCLEAN.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/verity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 6bc3470d99d00..a401ef72bc821 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -210,7 +210,7 @@ static int f2fs_get_verity_descriptor(struct inode *inode, void *buf,
 	if (pos + size < pos || pos + size > inode->i_sb->s_maxbytes ||
 	    pos < f2fs_verity_metadata_pos(inode) || size > INT_MAX) {
 		f2fs_warn(F2FS_I_SB(inode), "invalid verity xattr");
-		return -EUCLEAN; /* EFSCORRUPTED */
+		return -EFSCORRUPTED;
 	}
 	if (buf_size) {
 		if (size > buf_size)
-- 
2.22.0

