Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D22B2675
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgKMVUu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:20:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgKMVUt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:20:49 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 648E622252;
        Fri, 13 Nov 2020 21:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302448;
        bh=ScGzaAW6HXdlD6RQGCPEYgiXqyaD/WPHBs8Mx4EkY0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNQjGcA09qmTlCvYBv/OxdPDQISeth/aNijXDe8af96kTcI3tDzz4Sa6hDs+FRC7C
         oXGfQ8r4fq1Mo72bcGANbMafbzbBcrT4NXnGHwU7Y1AIxWd26bZQqlfyHf0fUUS2D1
         y1g6EuoDc4yvuQw+CUg1mIvyhLt/5G4hkfQzhZUw=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>,
        Luca Boccassi <luca.boccassi@microsoft.com>
Subject: [PATCH 2/4] fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest
Date:   Fri, 13 Nov 2020 13:19:16 -0800
Message-Id: <20201113211918.71883-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201113211918.71883-1-ebiggers@kernel.org>
References: <20201113211918.71883-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The name "struct fsverity_signed_digest" is causing confusion because it
isn't actually a signed digest, but rather it's the way that the digest
is formatted in order to be signed.  Rename it to
"struct fsverity_formatted_digest" to prevent this confusion.

Also update the struct's comment to clarify that it's specific to the
built-in signature verification support and isn't a requirement for all
fs-verity users.

I'll be renaming this struct in fsverity-utils too.

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst |  2 +-
 fs/verity/fsverity_private.h           | 17 ++++++++++++-----
 fs/verity/signature.c                  |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 895e9711ed881..421b75498d49b 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -372,7 +372,7 @@ kernel.  Specifically, it adds support for:
 File measurements must be signed in the following format, which is
 similar to the structure used by `FS_IOC_MEASURE_VERITY`_::
 
-    struct fsverity_signed_digest {
+    struct fsverity_formatted_digest {
             char magic[8];                  /* must be "FSVerity" */
             __le16 digest_algorithm;
             __le16 digest_size;
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index e96d99d5145e1..75f8e18b44a5b 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -101,12 +101,19 @@ struct fsverity_descriptor {
 					 sizeof(struct fsverity_descriptor))
 
 /*
- * Format in which verity file measurements are signed.  This is the same as
- * 'struct fsverity_digest', except here some magic bytes are prepended to
- * provide some context about what is being signed in case the same key is used
- * for non-fsverity purposes, and here the fields have fixed endianness.
+ * Format in which verity file measurements are signed in built-in signatures.
+ * This is the same as 'struct fsverity_digest', except here some magic bytes
+ * are prepended to provide some context about what is being signed in case the
+ * same key is used for non-fsverity purposes, and here the fields have fixed
+ * endianness.
+ *
+ * This struct is specific to the built-in signature verification support, which
+ * is optional.  fs-verity users may also verify signatures in userspace, in
+ * which case userspace is responsible for deciding on what bytes are signed.
+ * This struct may still be used, but it doesn't have to be.  For example,
+ * userspace could instead use a string like "sha256:$digest_as_hex_string".
  */
-struct fsverity_signed_digest {
+struct fsverity_formatted_digest {
 	char magic[8];			/* must be "FSVerity" */
 	__le16 digest_algorithm;
 	__le16 digest_size;
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 12794a4dd1585..74ae10f04d215 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -44,7 +44,7 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 	const struct inode *inode = vi->inode;
 	const struct fsverity_hash_alg *hash_alg = vi->tree_params.hash_alg;
 	const u32 sig_size = le32_to_cpu(desc->sig_size);
-	struct fsverity_signed_digest *d;
+	struct fsverity_formatted_digest *d;
 	int err;
 
 	if (sig_size == 0) {
-- 
2.29.2

