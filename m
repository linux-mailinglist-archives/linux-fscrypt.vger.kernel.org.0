Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2C24DF8D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgHUS2v (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbgHUS2U (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:20 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D1EC23101;
        Fri, 21 Aug 2020 18:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034499;
        bh=lMoBvQXizTQltZVaCAm6DjLIb4CnzsyzLlAI6w7Tdtk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=AIikmfjfq5tNKSUBihrKP14bMzumWqd4MYPm14tfU1tgt7kDrwyF3pgkBzF+7I0jz
         8Cr3LBMSWzvDy4D2eIN6G/TCfFkK2drIF/4L64lgfJLd8QDKecxY8CLtAT7sgrpC0G
         A/6FQZ5pyc8tYYKFiHy8nm2f11n3dZE1pC+lfwhA=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 09/14] ceph: set S_ENCRYPTED bit if new inode has encryption.ctx xattr
Date:   Fri, 21 Aug 2020 14:28:08 -0400
Message-Id: <20200821182813.52570-10-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This hack fixes a chicken-and-egg problem when fetching inodes from the
server. Once we move to a dedicated field in the inode, then this should
be able to go away.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/inode.c |  5 +++++
 fs/ceph/super.h |  1 +
 fs/ceph/xattr.c | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 877bdda40db8..fe231d7bd892 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -18,6 +18,7 @@
 #include "super.h"
 #include "mds_client.h"
 #include "cache.h"
+#include "crypto.h"
 #include <linux/ceph/decode.h>
 
 /*
@@ -908,6 +909,10 @@ int ceph_fill_inode(struct inode *inode, struct page *locked_page,
 		ceph_forget_all_cached_acls(inode);
 		ceph_security_invalidate_secctx(inode);
 		xattr_blob = NULL;
+		if ((inode->i_state & I_NEW) &&
+		    (DUMMY_ENCRYPTION_ENABLED(mdsc->fsc) ||
+		     ceph_inode_has_xattr(ci, CEPH_XATTR_NAME_ENCRYPTION_CONTEXT)))
+			inode_set_flags(inode, S_ENCRYPTED, S_ENCRYPTED);
 	}
 
 	/* finally update i_version */
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index a481cacf775a..ea111c0eadba 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -983,6 +983,7 @@ extern ssize_t ceph_listxattr(struct dentry *, char *, size_t);
 extern struct ceph_buffer *__ceph_build_xattrs_blob(struct ceph_inode_info *ci);
 extern void __ceph_destroy_xattrs(struct ceph_inode_info *ci);
 extern const struct xattr_handler *ceph_xattr_handlers[];
+bool ceph_inode_has_xattr(struct ceph_inode_info *ci, char *name);
 
 struct ceph_acl_sec_ctx {
 #ifdef CONFIG_CEPH_FS_POSIX_ACL
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index 3a733ac33d9b..9dcb060cba9a 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -1283,6 +1283,38 @@ void ceph_release_acl_sec_ctx(struct ceph_acl_sec_ctx *as_ctx)
 		ceph_pagelist_release(as_ctx->pagelist);
 }
 
+/* Return true if inode's xattr blob has an xattr named "name" */
+bool ceph_inode_has_xattr(struct ceph_inode_info *ci, char *name)
+{
+	void *p, *end;
+	u32 numattr;
+	size_t namelen;
+
+	lockdep_assert_held(&ci->i_ceph_lock);
+
+	if (!ci->i_xattrs.blob || ci->i_xattrs.blob->vec.iov_len <= 4)
+		return false;
+
+	namelen = strlen(name);
+	p = ci->i_xattrs.blob->vec.iov_base;
+	end = p + ci->i_xattrs.blob->vec.iov_len;
+	ceph_decode_32_safe(&p, end, numattr, bad);
+
+	while (numattr--) {
+		u32 len;
+
+		ceph_decode_32_safe(&p, end, len, bad);
+		ceph_decode_need(&p, end, len, bad);
+		if (len == namelen && !memcmp(p, name, len))
+			return true;
+		p += len;
+		ceph_decode_32_safe(&p, end, len, bad);
+		ceph_decode_skip_n(&p, end, len, bad);
+	}
+bad:
+	return false;
+}
+
 /*
  * List of handlers for synthetic system.* attributes. Other
  * attributes are handled directly.
-- 
2.26.2

