Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C6652B22B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 08:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiERGOp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 02:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiERGOo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 02:14:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAF44DF47;
        Tue, 17 May 2022 23:14:42 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L32jV6Ysmz1JC7B;
        Wed, 18 May 2022 14:13:18 +0800 (CST)
Received: from huawei.com (10.67.174.96) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 18 May
 2022 14:14:39 +0800
From:   Zhang Jianhua <chris.zjh@huawei.com>
To:     <ebiggers@kernel.org>, <tytso@mit.edu>
CC:     <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] fs-verity: Use struct_size() helper in enable_verity()
Date:   Wed, 18 May 2022 14:13:09 +0800
Message-ID: <20220518061309.2179692-1-chris.zjh@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.96]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows
that, in the worst scenario, could lead to heap overflows.

Also, address the following sparse warnings:
fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure

Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
---
 fs/verity/enable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index f75d2c010f36..075dc0aa5416 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -201,7 +201,7 @@ static int enable_verity(struct file *filp,
 	const struct fsverity_operations *vops = inode->i_sb->s_vop;
 	struct merkle_tree_params params = { };
 	struct fsverity_descriptor *desc;
-	size_t desc_size = sizeof(*desc) + arg->sig_size;
+	size_t desc_size = struct_size(desc, signature, arg->sig_size);
 	struct fsverity_info *vi;
 	int err;
 
-- 
2.31.0

