Return-Path: <linux-fscrypt+bounces-31-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BF0E87F56BE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 04:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B760FB20FDF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 03:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31792567C;
	Thu, 23 Nov 2023 03:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF8A4rj3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05224612A;
	Thu, 23 Nov 2023 03:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB53C433C8;
	Thu, 23 Nov 2023 03:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700708972;
	bh=TkK855alf7nqTmEIjo0bAeEYufIA+X8RIV+JdcV2wWQ=;
	h=From:To:Cc:Subject:Date:From;
	b=BF8A4rj3Qsb4FbpSmugMfp+9kXTjfmLb0lOJntQXAlGq3qWrHwknQZ42PYohvxKuc
	 aCELQSiiNeN8nYC5KtgQRUJHpeGC22G65K99R19PNOMv9dq2HJi43kxSrEvUR4wI8I
	 ZNOSc9Ovo54/ycdfnQe+N2fhchOjpcoifmxYYY/OQU4J/OmxTVT0Zr2kEdB+bov2+d
	 dfa9/CagVQNucDcziBrYk1MhtJJJXaRQtVdSLw+Rhv53E5wCMYUASplNNK8YNYYlKJ
	 FF+wAlOsSzrdY41LL1iejyq/2v6Nf8K/HJ6+Y1PEt3BQxsFREcEN9qpt4fASh6kdNQ
	 zbOnhddiONmyA==
From: Eric Biggers <ebiggers@kernel.org>
To: ceph-devel@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
Date: Wed, 22 Nov 2023 19:08:38 -0800
Message-ID: <20231123030838.46158-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The kconfig options for filesystems that support FS_ENCRYPTION are
supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
required crypto algorithms get enabled as loadable modules or builtin as
is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
so that there aren't any missing algorithms if someone happens to have
CEPH_FS as their only enabled filesystem that supports encryption.

Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vxattr")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/ceph/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
index 94df854147d35..7249d70e1a43f 100644
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@ -1,19 +1,20 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config CEPH_FS
 	tristate "Ceph distributed file system"
 	depends on INET
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
 	select CRYPTO
 	select NETFS_SUPPORT
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
 	default n
 	help
 	  Choose Y or M here to include support for mounting the
 	  experimental Ceph distributed file system.  Ceph is an extremely
 	  scalable file system designed to provide high performance,
 	  reliable access to petabytes of storage.
 
 	  More information at https://ceph.io/.
 
 	  If unsure, say N.

base-commit: 9b6de136b5f0158c60844f85286a593cb70fb364
-- 
2.42.1


