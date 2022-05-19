Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2E1C52C9C4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 04:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiESC0Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 22:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiESC0X (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 22:26:23 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C4E66699;
        Wed, 18 May 2022 19:26:22 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4L3YWT0V61zCsh5;
        Thu, 19 May 2022 10:21:25 +0800 (CST)
Received: from huawei.com (10.67.174.96) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 10:26:20 +0800
From:   Zhang Jianhua <chris.zjh@huawei.com>
To:     <ebiggers@kernel.org>, <tytso@mit.edu>
CC:     <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next v2] fs-verity: Use struct_size() helper in enable_verity()
Date:   Thu, 19 May 2022 10:24:50 +0800
Message-ID: <20220519022450.2434483-1-chris.zjh@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.96]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

Make use of the struct_size() helper to calculate the size of struct
fsverity_digest instead of an open-coded version, in order to get rid
of the warning by sparse.

Also, address the following sparse warning:
fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure

Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
---
v2:
- change the commit message from bugfix to cleanup

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

