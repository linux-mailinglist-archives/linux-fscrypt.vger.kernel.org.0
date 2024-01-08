Return-Path: <linux-fscrypt+bounces-107-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAEE82674B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jan 2024 03:44:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 05D571F2176C
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jan 2024 02:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D57979DC;
	Mon,  8 Jan 2024 02:44:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23597F
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jan 2024 02:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4T7dg71tzSzZgdt;
	Mon,  8 Jan 2024 10:44:03 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (unknown [7.193.23.68])
	by mail.maildlp.com (Postfix) with ESMTPS id D53161800BE;
	Mon,  8 Jan 2024 10:44:18 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 8 Jan
 2024 10:44:18 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <richard@nod.at>, <ebiggers@google.com>, <terrelln@fb.com>
CC: <linux-fscrypt@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: [PATCH v3 0/2] ubifs: Fix two kmemleaks in error path
Date: Mon, 8 Jan 2024 10:41:03 +0800
Message-ID: <20240108024105.194516-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)

First memleak is found by mounting corrupted UBIFS image with chk_index
enabled.
Second memleak is found by powercut testing for encryption scenario.

v1->v2:
 ubifs_symlink: Call fscrypt_free_inode() directly in error handling path.
 Add 'Cc: stable@vger.kernel.org' and 'Suggested-by' tags in patch 2.
v2->v3:
 Handle tnc releasing in error handling path in dbg_check_idx_size().


Zhihao Cheng (2):
  ubifs: dbg_check_idx_size: Fix kmemleak if loading znode failed
  ubifs: ubifs_symlink: Fix memleak of inode->i_link in error path

 fs/ubifs/debug.c    |  9 +++++++--
 fs/ubifs/dir.c      |  2 ++
 fs/ubifs/tnc.c      |  9 +--------
 fs/ubifs/tnc_misc.c | 22 ++++++++++++++++++++++
 fs/ubifs/ubifs.h    |  1 +
 5 files changed, 33 insertions(+), 10 deletions(-)

-- 
2.39.2


