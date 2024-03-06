Return-Path: <linux-fscrypt+bounces-215-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E315C872C04
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Mar 2024 02:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9195B1F24D7A
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Mar 2024 01:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A204D26B;
	Wed,  6 Mar 2024 01:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NSqhIh5m"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7350463DF
	for <linux-fscrypt@vger.kernel.org>; Wed,  6 Mar 2024 01:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709687868; cv=none; b=YXp/lz8Ht26ZZBCadjZ/58FsoOTy9bbu2M0pS8iIbr5ZKs2nAm/pX1YwxhBHSxweftf67NawzFi0o8Mi9rkdj26cpBjPag+1V8Z+PeB1ToQkAa1bpZ63zBqQ5+SCa/UUL/k4dPCKCd72gGQFX48n2CoxPSkDxUHaNqsyrvUwaHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709687868; c=relaxed/simple;
	bh=y65RKsbmlzXJf/JzYfgyoDk48h1PddbLHcQTH86O6+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qtGYsnX6NUzEWBpIzzDLvuuuZwiAD1DAI+4PtoWv0jVv8Ug9i5FpA8JZ8DTEnM7uRA9Hg0ti/mbV1qjOwEkBy8n7Y9Yg+W56e2n1ZZU/zGCz3Jw+/IFwP2pd3pn8TceqNeW0N8KC8ObDqKxMy/QK3PhymIHv9T/vjKYd0qzWRkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NSqhIh5m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709687865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KSopfOJkAuYOw6M3itXYUuSKT5SC9i3M+OvcTTde/l4=;
	b=NSqhIh5mNUN46VDvCfr84nUr/nNQkuAPY3j/UJuD6MdD8nV6aDR/ktZvedDKc8YTPyt2Cv
	wAtWr+y0CDWG9960mYMdoguKcl5XhFs+1qXAEo8ZsRMTIWoKT25a29z1Gofvyib8P2s34x
	OhzgaPAAQNYDH2SvgcYZUzxkU+X2p/o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-amOpKSPGOZGuX2z2dQNEjA-1; Tue, 05 Mar 2024 20:17:42 -0500
X-MC-Unique: amOpKSPGOZGuX2z2dQNEjA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6B4800265;
	Wed,  6 Mar 2024 01:17:41 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.9])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5AB1F1C060D6;
	Wed,  6 Mar 2024 01:17:35 +0000 (UTC)
From: xiubli@redhat.com
To: linux-fscrypt@vger.kernel.org
Cc: ebiggers@kernel.org,
	tytso@mit.edu,
	jaegeuk@kernel.org,
	linux-kernel@vger.kernel.org,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	jlayton@kernel.org,
	vshankar@redhat.com,
	mchangir@redhat.com,
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: return -ENODATA when xattr doesn't exist for removexattr
Date: Wed,  6 Mar 2024 09:15:02 +0800
Message-ID: <20240306011502.183332-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Xiubo Li <xiubli@redhat.com>

The POSIX says we should return -ENODATA when the corresponding
attribute doesn't exist when removing it. While there is one
exception for the acl ones in the local filesystems, for exmaple
for xfs, which will treat it as success.

While in the MDS side there have two ways to remove the xattr:
sending a CEPH_MDS_OP_SETXATTR request by setting the 'flags' with
CEPH_XATTR_REMOVE and just issued a CEPH_MDS_OP_RMXATTR request
directly.

For the first one it will always return 0 when the corresponding
xattr doesn't exist, while for the later one it will return
-ENODATA instead, this should be fixed in MDS to make them to be
consistent.

URL: https://tracker.ceph.com/issues/64679
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/acl.c   | 9 ++++++++-
 fs/ceph/xattr.c | 5 ++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
index 1564eacc253d..836b92526fa2 100644
--- a/fs/ceph/acl.c
+++ b/fs/ceph/acl.c
@@ -158,7 +158,14 @@ int ceph_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
 		goto out_free;
 	}
 
-	ceph_set_cached_acl(inode, type, acl);
+	/*
+	 * If the attribute didn't exist to start with that's fine.
+	 */
+	if (!acl && ret == -ENODATA)
+		ret = 0;
+
+	if (!ret)
+		ceph_set_cached_acl(inode, type, acl);
 
 out_free:
 	kfree(value);
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index e066a556eccb..08b14eea66e9 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -613,11 +613,10 @@ static int __set_xattr(struct ceph_inode_info *ci,
 			return err;
 		}
 		if (update_xattr < 0) {
-			if (xattr)
-				__remove_xattr(ci, xattr);
+			err = __remove_xattr(ci, xattr);
 			kfree(name);
 			kfree(*newxattr);
-			return 0;
+			return err;
 		}
 	}
 
-- 
2.43.0


