Return-Path: <linux-fscrypt+bounces-96-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A59881C6E0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Dec 2023 09:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18866285FB3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Dec 2023 08:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A51FD30A;
	Fri, 22 Dec 2023 08:51:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF3D2E7
	for <linux-fscrypt@vger.kernel.org>; Fri, 22 Dec 2023 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4SxLcV0jXWzWkBS;
	Fri, 22 Dec 2023 16:51:06 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 9AAD5140336;
	Fri, 22 Dec 2023 16:51:28 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 22 Dec
 2023 16:51:27 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <richard@nod.at>, <terrelln@fb.com>, <ebiggers@google.com>
CC: <linux-fscrypt@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: [PATCH v2 0/2] ubifs: Fix two kmemleaks in error path
Date: Fri, 22 Dec 2023 16:54:44 +0800
Message-ID: <20231222085446.781838-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000013.china.huawei.com (7.193.23.81)

First memleak is found by mounting corrupted UBIFS image with chk_index
enabled.
Second memleak is found by powercut testing for encryption scenario.

v1->v2:
  ubifs_symlink: Call fscrypt_free_inode() directly in error handling
  path.
  Add 'Cc: stable@vger.kernel.org' and 'Suggested-by' tags in patch 2.

Zhihao Cheng (2):
  ubifs: dbg_check_idx_size: Fix kmemleak if loading znode failed
  ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path

 fs/ubifs/dir.c   | 2 ++
 fs/ubifs/super.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

-- 
2.31.1


