Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E4D2B2678
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgKMVUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbgKMVUt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:20:49 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F225A2224F;
        Fri, 13 Nov 2020 21:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302448;
        bh=w/nTbZglYrBVjolS7Ms76rddc3wMmSAqoGOpGR3b8Dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ry2d6JWCePxGm5upYC1sIfWRITct15ffVig02OjJYP+/F2aZOxuMfg7Hz1rZSkGib
         g5o6qWgG7GxGOJnD3MhmEAaDEJah+mvLStgxAA1O3EvV+D3bfWk30ZPvZ3Ponglf74
         BfoRsBeeLGv1YOjjyPeezPvBlD47BqVTKWTJ4XCE=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: [PATCH 1/4] fs-verity: remove filenames from file comments
Date:   Fri, 13 Nov 2020 13:19:15 -0800
Message-Id: <20201113211918.71883-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113211918.71883-1-ebiggers@kernel.org>
References: <20201113211918.71883-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Embedding the file path inside kernel source code files isn't
particularly useful as often files are moved around and the paths become
incorrect.  checkpatch.pl warns about this since v5.10-rc1.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/verity/enable.c    | 2 +-
 fs/verity/hash_algs.c | 2 +-
 fs/verity/init.c      | 2 +-
 fs/verity/measure.c   | 2 +-
 fs/verity/open.c      | 2 +-
 fs/verity/signature.c | 2 +-
 fs/verity/verify.c    | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 5ab3bbec81087..9c5b28c865226 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/enable.c: ioctl to enable verity on a file
+ * Ioctl to enable verity on a file
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/hash_algs.c b/fs/verity/hash_algs.c
index c37e186ebeb6c..71d0fccb6d4c4 100644
--- a/fs/verity/hash_algs.c
+++ b/fs/verity/hash_algs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/hash_algs.c: fs-verity hash algorithms
+ * fs-verity hash algorithms
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/init.c b/fs/verity/init.c
index 94c104e00861d..c98b7016f446b 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/init.c: fs-verity module initialization and logging
+ * fs-verity module initialization and logging
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/measure.c b/fs/verity/measure.c
index df409a5682edf..5300b8d385376 100644
--- a/fs/verity/measure.c
+++ b/fs/verity/measure.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/measure.c: ioctl to get a verity file's measurement
+ * Ioctl to get a verity file's measurement
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/open.c b/fs/verity/open.c
index bfe0280c14e49..a28d5be78a09c 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/open.c: opening fs-verity files
+ * Opening fs-verity files
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index b14ed96387ece..12794a4dd1585 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/signature.c: verification of builtin signatures
+ * Verification of builtin signatures
  *
  * Copyright 2019 Google LLC
  */
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index a8b68c6f663d1..0adb970f4e736 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * fs/verity/verify.c: data verification functions, i.e. hooks for ->readpages()
+ * Data verification functions, i.e. hooks for ->readpages()
  *
  * Copyright 2019 Google LLC
  */
-- 
2.29.2

