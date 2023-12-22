Return-Path: <linux-fscrypt+bounces-95-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3A5681C6DF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Dec 2023 09:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4313B1F23A48
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Dec 2023 08:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A337D306;
	Fri, 22 Dec 2023 08:51:39 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BEAD2F4
	for <linux-fscrypt@vger.kernel.org>; Fri, 22 Dec 2023 08:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4SxLbT6Scgz29gQV;
	Fri, 22 Dec 2023 16:50:13 +0800 (CST)
Received: from kwepemm000013.china.huawei.com (unknown [7.193.23.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 2FA341A0190;
	Fri, 22 Dec 2023 16:51:29 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemm000013.china.huawei.com
 (7.193.23.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 22 Dec
 2023 16:51:28 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <richard@nod.at>, <terrelln@fb.com>, <ebiggers@google.com>
CC: <linux-fscrypt@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: [PATCH v2 1/2] ubifs: dbg_check_idx_size: Fix kmemleak if loading znode failed
Date: Fri, 22 Dec 2023 16:54:45 +0800
Message-ID: <20231222085446.781838-2-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231222085446.781838-1-chengzhihao1@huawei.com>
References: <20231222085446.781838-1-chengzhihao1@huawei.com>
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

If function dbg_check_idx_size() failed by loading znode in mounting
process, there are two problems:
  1. Allocated znodes won't be freed, which causes kmemleak in kernel:
     ubifs_mount
      dbg_check_idx_size
       dbg_walk_index
        c->zroot.znode = ubifs_load_znode
	child = ubifs_load_znode // failed
	// Loaded znodes won't be freed in error handling path.
  2. Global variable ubifs_clean_zn_cnt is not decreased, because
     ubifs_tnc_close() is not invoked in error handling path, which
     triggers a warning in ubifs_exit():
      WARNING: CPU: 1 PID: 1576 at fs/ubifs/super.c:2486 ubifs_exit
      Modules linked in: zstd ubifs(-) ubi nandsim
      CPU: 1 PID: 1576 Comm: rmmod Not tainted 6.7.0-rc6
      Call Trace:
	ubifs_exit+0xca/0xc70 [ubifs]
	__do_sys_delete_module+0x29a/0x4a0
	do_syscall_64+0x6f/0x140

Fix it by invoking destroy_journal() if dbg_check_idx_size() failed.

Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 fs/ubifs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 09e270d6ed02..eabb0f44ea3e 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1449,7 +1449,7 @@ static int mount_ubifs(struct ubifs_info *c)
 
 	err = dbg_check_idx_size(c, c->bi.old_idx_sz);
 	if (err)
-		goto out_lpt;
+		goto out_journal;
 
 	err = ubifs_replay_journal(c);
 	if (err)
-- 
2.31.1


