Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D256A24DF8E
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgHUS2u (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbgHUS2V (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:21 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25E023108;
        Fri, 21 Aug 2020 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034501;
        bh=cjzcWCBqDYAC8jfa7JWsBDeyu4qvfdbuM7y+EFHiyZ4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=dse5czlsz8bEjgZwlvTylPNHXJaYQP68GJ3RdAwHGUjSBaFGfzEY6wdo/A5EXq6fd
         kp7x3YDPOTwIzhRixPbP8MTKYC9k7KDBOfkgn/BYCNp2euBx5Qc0PAivcgPdYG/aGs
         KnmkcbhfnWCJA4MDDz2ZfuqbxcoFQl6gKtxqUbEg=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 12/14] ceph: make d_revalidate call fscrypt revalidator for encrypted dentries
Date:   Fri, 21 Aug 2020 14:28:11 -0400
Message-Id: <20200821182813.52570-13-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

If we have an encrypted dentry, then we need to test whether a new key
might have been established or removed. Do that before we test anything
else about the dentry.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/dir.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 2e7f2bfa2c12..d2104c115868 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1701,6 +1701,12 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 	dout("d_revalidate %p '%pd' inode %p offset 0x%llx\n", dentry,
 	     dentry, inode, ceph_dentry(dentry)->offset);
 
+	if (IS_ENCRYPTED(dir)) {
+		valid = fscrypt_d_revalidate(dentry, flags);
+		if (valid <= 0)
+			return valid;
+	}
+
 	mdsc = ceph_sb_to_client(dir->i_sb)->mdsc;
 
 	/* always trust cached snapped dentries, snapdir dentry */
-- 
2.26.2

