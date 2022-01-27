Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02C649EA82
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Jan 2022 19:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiA0Sqe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Jan 2022 13:46:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4534 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236489AbiA0Sqc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Jan 2022 13:46:32 -0500
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jl8bk6DQ8z67N6L;
        Fri, 28 Jan 2022 02:42:58 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:46:30 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <linux-integrity@vger.kernel.org>
CC:     <zohar@linux.ibm.com>, <ebiggers@kernel.org>,
        <stefanb@linux.ibm.com>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [RFC][PATCH v3a 08/11] fsverity: Completely disable signature verification if not requested
Date:   Thu, 27 Jan 2022 19:46:12 +0100
Message-ID: <20220127184614.2837938-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220127184614.2837938-1-roberto.sassu@huawei.com>
References: <20220127184614.2837938-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, fsverity verifies the signature, if supplied, regardless of
whether signature verification is requested or not.

Completely disable signature verification, if not requested, so that other
users of fsverity can do their own verification without relying on the
fsverity-specific verification to work.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 fs/verity/signature.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..b45a2cea6c59 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -45,13 +45,13 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 	struct fsverity_formatted_digest *d;
 	int err;
 
-	if (sig_size == 0) {
-		if (fsverity_require_signatures) {
-			fsverity_err(inode,
-				     "require_signatures=1, rejecting unsigned file!");
-			return -EPERM;
-		}
+	if (!fsverity_require_signatures)
 		return 0;
+
+	if (sig_size == 0) {
+		fsverity_err(inode,
+			     "require_signatures=1, rejecting unsigned file!");
+		return -EPERM;
 	}
 
 	d = kzalloc(sizeof(*d) + hash_alg->digest_size, GFP_KERNEL);
-- 
2.32.0

