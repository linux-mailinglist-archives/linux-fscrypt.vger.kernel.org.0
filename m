Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A224929C877
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Oct 2020 20:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829499AbgJ0TNu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 27 Oct 2020 15:13:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1829497AbgJ0TNQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 27 Oct 2020 15:13:16 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2321920756;
        Tue, 27 Oct 2020 19:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603825995;
        bh=3ohipzYM9J3LbDvKE17BmidIKnNoGL0lcOpZoqC3A2w=;
        h=From:To:Cc:Subject:Date:From;
        b=xz0OvzCgs2KWIGTc8wbZNCsa5vWbanmUSHYMqLzVdEl7s7bP2cg/qpXW9la4iBYvX
         WlASsLY+M5OT55ryy0T69clp0gFWbF+lU04wR0VuuAVIeC5vsuXshI5p5IsbYsZGpU
         B84SjaqLErrSi7jz1+OvVnHOzajdZC2XBP4RuHzs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: [PATCH] fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest
Date:   Tue, 27 Oct 2020 12:11:06 -0700
Message-Id: <20201027191106.2447401-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst |  2 +-
 fs/verity/fsverity_private.h           | 17 ++++++++++++-----
 fs/verity/signature.c                  |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 895e9711ed88..421b75498d49 100644
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
index e96d99d5145e..75f8e18b44a5 100644
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
index b14ed96387ec..26c76fedd78b 100644
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

base-commit: 4d09c1d952679411da2772f199643e08c46c31cd
-- 
2.29.0.rc2.309.g374f81d7ae-goog

