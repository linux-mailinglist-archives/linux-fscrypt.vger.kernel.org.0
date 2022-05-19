Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B333E52C9C8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 04:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbiESC3X (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 22:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiESC3X (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 22:29:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4F4C6E74;
        Wed, 18 May 2022 19:29:21 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L3Yg13b1RzgYCM;
        Thu, 19 May 2022 10:27:57 +0800 (CST)
Received: from huawei.com (10.67.174.96) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 10:29:19 +0800
From:   Zhang Jianhua <chris.zjh@huawei.com>
To:     <ebiggers@kernel.org>, <tytso@mit.edu>
CC:     <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next v2] fs-verity: Use struct_size() helper in fsverity_ioctl_measure()
Date:   Thu, 19 May 2022 10:27:49 +0800
Message-ID: <20220519022749.2435114-1-chris.zjh@huawei.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.96]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Make use of the struct_size() to calculate the size of struct
fsverity_digest instead of an open-coded version, in order to
get rid of the sparse warnings about flexible structure.

As reported by sparse:
fs/verity/measure.c:48:9: warning: using sizeof on a flexible structure
fs/verity/measure.c:52:38: warning: using sizeof on a flexible structure

Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
---
v2:
- change the commit message from bugfix to cleanup
 fs/verity/measure.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index e99c00350c28..4a388116d0de 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -27,6 +27,7 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	const struct fsverity_info *vi;
 	const struct fsverity_hash_alg *hash_alg;
 	struct fsverity_digest arg;
+	size_t arg_size = struct_size(&arg, digest, 0);
 
 	vi = fsverity_get_info(inode);
 	if (!vi)
@@ -44,11 +45,11 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
 	if (arg.digest_size < hash_alg->digest_size)
 		return -EOVERFLOW;
 
-	memset(&arg, 0, sizeof(arg));
+	memset(&arg, 0, arg_size);
 	arg.digest_algorithm = hash_alg - fsverity_hash_algs;
 	arg.digest_size = hash_alg->digest_size;
 
-	if (copy_to_user(uarg, &arg, sizeof(arg)))
+	if (copy_to_user(uarg, &arg, arg_size))
 		return -EFAULT;
 
 	if (copy_to_user(uarg->digest, vi->file_digest, hash_alg->digest_size))
-- 
2.31.0

