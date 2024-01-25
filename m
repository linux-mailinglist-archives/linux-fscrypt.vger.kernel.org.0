Return-Path: <linux-fscrypt+bounces-136-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E4FDB83B8C7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jan 2024 05:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75936B2117E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jan 2024 04:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8116679F1;
	Thu, 25 Jan 2024 04:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+IdD3WA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C29779C7
	for <linux-fscrypt@vger.kernel.org>; Thu, 25 Jan 2024 04:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706158241; cv=none; b=ijVjzrLcJJm/gs8B7WoDupoPKJN351JkU6+7gCuxnYjxggj9fkrJJU7i2AlPu9YXT9nBHyD0h/5qwHLyRDqNGSuY8g45H21iWMV74pjlnq55r7WGJkiuPXjHcaJcAzUaepokIWgvJgEIU6381Z1LB4qlJJCtGwc1ZkiXadLLy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706158241; c=relaxed/simple;
	bh=2RWN9M36qX+9GZm4Tq3aYzHlPiLa+w1ufmGXtNpU1A8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Txr2wh6OsdozMjmc9MV+rsIgqjbYaVHzp2CqGJx87af7dFgdkvigQ2+tgn6yJ8eApMBGoDkIE+mXc8f3btsehcRwbVnnWSJSM9dX/iWmNS5gCoHZ9IeFV7ZnisQlfvyFBZwK2RSgZbLANgHwllz7LqLBy0S67bfHx7QFZbeZJnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+IdD3WA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706158239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=G6eOL3R6irziHLXuND4grbP4rQI+ngEPSNB6hi5Up78=;
	b=G+IdD3WA1yrcgdJsB03bB2s9bBpjEc2RknbD+FhqNMFQKDz1jDgarHApdG25E96/9w5tcp
	wWL9fZR27K1doTps08offnl9evngyVtPKog7XmsJ+FjDSGwNJwt153HdIWEjJv2Dxlpqee
	E4ad0dyCfpu/ptIf5CbMaFjvg8Folmw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-7r5lIxgdMr2uRCoLCWVw7g-1; Wed, 24 Jan 2024 23:50:34 -0500
X-MC-Unique: 7r5lIxgdMr2uRCoLCWVw7g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 090658828C3;
	Thu, 25 Jan 2024 04:50:34 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (unknown [10.72.112.211])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CAE93C2E;
	Thu, 25 Jan 2024 04:50:29 +0000 (UTC)
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
	Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] fscrypt: to make sure the inode->i_blkbits is correctly set
Date: Thu, 25 Jan 2024 12:48:25 +0800
Message-ID: <20240125044826.1294268-1-xiubli@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Xiubo Li <xiubli@redhat.com>

The inode->i_blkbits should be already set before calling
fscrypt_get_encryption_info() and it will be used this to setup the
ci_data_unit_bits.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/crypto/keysetup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index d71f7c799e79..909187e52bae 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -702,6 +702,9 @@ int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
  * This doesn't persist the new inode's encryption context.  That still needs to
  * be done later by calling fscrypt_set_context().
  *
+ * Please note that the inode->i_blkbits should be already set before calling
+ * this and later it will be used to setup the ci_data_unit_bits.
+ *
  * Return: 0 on success, -ENOKEY if the encryption key is missing, or another
  *	   -errno code
  */
@@ -717,6 +720,9 @@ int fscrypt_prepare_new_inode(struct inode *dir, struct inode *inode,
 	if (IS_ERR(policy))
 		return PTR_ERR(policy);
 
+	if (WARN_ON_ONCE(inode->i_blkbits == 0))
+		return -EINVAL;
+
 	if (WARN_ON_ONCE(inode->i_mode == 0))
 		return -EINVAL;
 
-- 
2.43.0


