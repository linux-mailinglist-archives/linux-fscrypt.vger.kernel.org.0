Return-Path: <linux-fscrypt+bounces-160-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B9E7844DF1
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 01:38:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCEAE1F28C2B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 00:38:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D6D2114;
	Thu,  1 Feb 2024 00:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKIezesj"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AAB20F1
	for <linux-fscrypt@vger.kernel.org>; Thu,  1 Feb 2024 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706747876; cv=none; b=me2eg4ZAc6ldw1khOkXmCtNUN+MnrL2c44/tfGzfnpWNlKCD5qVQzSaa6Q+gE7xhw/t3w+cTmM86hNeUcMLgd9In9MJ+hCwfZWWAiIsbQoslemJAMljBHnOAIVg4izTLvIiUF+klFzkgV6qJGE340RsXKP225ZPmrLnc9edZzU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706747876; c=relaxed/simple;
	bh=qr8rACMNs5RIY8f9kv6asHpnLhXEAXtdGkLGoE0MlO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XwNsdWTqd/RJYbpclepdyK+/4OzFFLqpbnFGxnOcmH5LoowHCaEQ7fHFLInreqQlsbRujsKoYOVtXa/SOvPAxxSKf3Zw6t2LPARKc9p8NBd8gK+yDFWDeSq6HQrRBi9l2Q+LUxnjQ6z73v4KL05VU5unNXs3GB/AxAaUCNInk1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKIezesj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706747873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ah1RKuhRRRnaXJKeyFjE6ASX3Aql4IiSaABAAELIE4M=;
	b=XKIezesjK6sCZiYnO/JOKOFXeWr8ysH+tHFss5GnlFLFMl5vyPY6IODyfoELDpDC41H6Z4
	BFlFKNA6MV2rFkdXsI6UUjlmcPikVBw9vQRM86mZ/gaOmBPoC9my8NCabQtJ18LxIH4XkG
	IqRNzPU2Ee+CTDwGNEZc3I/Xe8bhKZA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-Yrwu-v3rPWCE82p2J6UpYg-1; Wed,
 31 Jan 2024 19:37:47 -0500
X-MC-Unique: Yrwu-v3rPWCE82p2J6UpYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FED138005CC;
	Thu,  1 Feb 2024 00:37:47 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1874C1C060AF;
	Thu,  1 Feb 2024 00:37:41 +0000 (UTC)
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
Subject: [PATCH v2] fscrypt: to make sure the inode->i_blkbits is correctly set
Date: Thu,  1 Feb 2024 08:35:25 +0800
Message-ID: <20240201003525.1788594-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

From: Xiubo Li <xiubli@redhat.com>

The inode->i_blkbits should be already set before calling
fscrypt_get_encryption_info() and it will use this to setup the
ci_data_unit_bits later.

URL: https://tracker.ceph.com/issues/64035
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Fixed the comments suggested by Eric, thanks.



 fs/crypto/keysetup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d71f7c799e79..9a0a40c81bf2 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -687,7 +687,7 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
 /**
  * fscrypt_prepare_new_inode() - prepare to create a new inode in a directory
  * @dir: a possibly-encrypted directory
- * @inode: the new inode.  ->i_mode must be set already.
+ * @inode: the new inode.  ->i_mode and ->i_blkbits must be set already.
  *	   ->i_ino doesn't need to be set yet.
  * @encrypt_ret: (output) set to %true if the new inode will be encrypted
  *
@@ -717,6 +717,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 	if (IS_ERR(policy))
 		return PTR_ERR(policy);
 
+	if (WARN_ON_ONCE(inode->i_blkbits == 0))
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(inode->i_mode == 0))
 		return -EINVAL;
 
-- 
2.43.0


