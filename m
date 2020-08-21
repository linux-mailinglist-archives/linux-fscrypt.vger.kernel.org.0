Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89CF24DF96
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgHUS3Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgHUS2Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:16 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378C823101;
        Fri, 21 Aug 2020 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034496;
        bh=ND4FcgD/NUSJ8C4KRjBaer7sEEz7pzhowVhqTtPqG0U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=BbdAviWSwqSwfnEpaHQYLHh/5oyL+NVvNkC/ZgwAFLbVICvQYYCxlb+XkaeU+nlm1
         r6xd9SLq8ssVootlbvvcjZTrOFrydCzTiAuiVcWPFiJF/vy9m1P9/h2piDF828RwJo
         kypdvqDmHp0KVCkKz3h+XDB0/ediGyhDGQzgiPTA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 03/14] fscrypt: don't balk when inode is already marked encrypted
Date:   Fri, 21 Aug 2020 14:28:02 -0400
Message-Id: <20200821182813.52570-4-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Cephfs (currently) sets this flag early and only fetches the context
later. Eventually we may not need this, but for now it prevents this
warning from popping.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/crypto/keysetup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index fea6226afc2b..587335dc7cb9 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -474,7 +474,7 @@ int fscrypt_get_encryption_info(struct inode *inode)
 		const union fscrypt_context *dummy_ctx =
 			fscrypt_get_dummy_context(inode->i_sb);
 
-		if (IS_ENCRYPTED(inode) || !dummy_ctx) {
+		if (!dummy_ctx) {
 			fscrypt_warn(inode,
 				     "Error %d getting encryption context",
 				     res);
-- 
2.26.2

