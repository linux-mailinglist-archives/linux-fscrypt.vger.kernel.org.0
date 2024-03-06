Return-Path: <linux-fscrypt+bounces-228-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1A2087444E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:37:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70A762878A9
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Mar 2024 23:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB5FA5A4C7;
	Wed,  6 Mar 2024 23:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HdAcU/ur"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAD33D393;
	Wed,  6 Mar 2024 23:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709768100; cv=none; b=KeY2ntxQdclTKlqi8HITuJeGVq0zw8nAYA5vl6xPnkLPQVyKMpN4kQvYitN+M4BuuWe8G8Q8OW7zt1g7+e26QGJc2oIkWnPl3dddtnDFbQmsBc8+U64gwk8vQbgvpb5e6XaJZMJrlBE+/OhItfewHggxCx15sN1/+wn5wzslEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709768100; c=relaxed/simple;
	bh=Q8L9sOYVlN46Lj9VFOiv5l2EcI0rU3M2jcStrsjknuY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=edAJK3f0KbGh+SkYZHJ8JW02zuCPYlMKRnFMTfdk0G3X94uXEVCtyYZQCjpqzHlTogrsukRkik+i6DRBDlP7sYBVX3XziSLivTqqkaWEODAhIakCSodKIZ97Hq9SYF5uzfQjm+1ECRhbT2xfHG6nmpmRS/eq7TAPUXRi8EWXkoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HdAcU/ur; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id CCC3420B74DD; Wed,  6 Mar 2024 15:34:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CCC3420B74DD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709768092;
	bh=y1ziFtjalva6dhMMZTDPLhD8aFj84eDkJtvAjNC+hXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdAcU/urAQW5/cIOLoCOIPrYkxC8NKU4oaUbevNIvFJTy+gMRag9mrLpAo41QxCcy
	 /0k8WykUHRW7IOs0VQncJJRs6Xh2QTSEFbkDJHpXL6MRfURtzsmcdqX67fDgo13Nef
	 0JqpDUGuemVv3Ut3FM+WjYG+8sbPqpQLOffpkCcE=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>,
	Deven Bowers <deven.desai@linux.microsoft.com>
Subject: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM hook
Date: Wed,  6 Mar 2024 15:34:40 -0800
Message-Id: <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

fsverity represents a mechanism to support both integrity and
authenticity protection of a file, supporting both signed and unsigned
digests.

An LSM which controls access to a resource based on authenticity and
integrity of said resource, can then use this data to make an informed
decision on the authorization (provided by the LSM's policy) of said
claim.

This effectively allows the extension of a policy enforcement layer in
LSM for fsverity, allowing for more granular control of how a
particular authenticity claim can be used. For example, "all (built-in)
signed fsverity files should be allowed to execute, but only these
hashes are allowed to be loaded as kernel modules".

This enforcement must be done in kernel space, as a userspace only
solution would fail a simple litmus test: Download a self-contained
malicious binary that never touches the userspace stack. This
binary would still be able to execute.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v6:
  + Not present

v7:
  Introduced

v8:
  + Split fs/verity/ changes and security/ changes into separate patches
  + Change signature of fsverity_create_info to accept non-const inode
  + Change signature of fsverity_verify_signature to accept non-const inode
  + Don't cast-away const from inode.
  + Digest functionality dropped in favor of:
    ("fs-verity: define a function to return the integrity protected
      file digest")
  + Reworded commit description and title to match changes.
  + Fix a bug wherein no LSM implements the particular fsverity @name
    (or LSM is disabled), and returns -EOPNOTSUPP, causing errors.

v9:
  + No changes

v10:
  + Rename the signature blob key
  + Cleanup redundant code
  + Make the hook call depends on CONFIG_FS_VERITY_BUILTIN_SIGNATURES

v11:
  + No changes

v12:
  + Add constification to the hook call

v13:
  + No changes

v14:
  + Add doc/comment to built-in signature verification
---
 Documentation/filesystems/fsverity.rst |  4 +++-
 fs/verity/fsverity_private.h           |  2 +-
 fs/verity/open.c                       | 26 +++++++++++++++++++++++++-
 fs/verity/signature.c                  |  4 +++-
 include/linux/fsverity.h               |  2 ++
 5 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 13e4b18e5dbb..64618a6141ab 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -461,7 +461,9 @@ Enabling this option adds the following:
 
 3. A new sysctl "fs.verity.require_signatures" is made available.
    When set to 1, the kernel requires that all verity files have a
-   correctly signed digest as described in (2).
+   correctly signed digest as described in (2). Note that verification
+   happens as long as the file's signature exists regardless the state of
+   "fs.verity.require_signatures".
 
 The data that the signature as described in (2) must be a signature of
 is the fs-verity file digest in the following format::
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index a6a6b2749241..84a3608f2f9b 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -118,7 +118,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 				     unsigned int log_blocksize,
 				     const u8 *salt, size_t salt_size);
 
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc);
 
 void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 6c31a871b84b..f917023255c8 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -8,6 +8,7 @@
 #include "fsverity_private.h"
 
 #include <linux/mm.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 
 static struct kmem_cache *fsverity_info_cachep;
@@ -172,12 +173,28 @@ static int compute_file_digest(const struct fsverity_hash_alg *hash_alg,
 	return err;
 }
 
+#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
+static int fsverity_inode_setsecurity(struct inode *inode,
+				      const struct fsverity_descriptor *desc)
+{
+	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
+					  desc->signature,
+					  le32_to_cpu(desc->sig_size), 0);
+}
+#else
+static inline int fsverity_inode_setsecurity(struct inode *inode,
+					     const struct fsverity_descriptor *desc)
+{
+	return 0;
+}
+#endif /* CONFIG_IPE_PROP_FS_VERITY*/
+
 /*
  * Create a new fsverity_info from the given fsverity_descriptor (with optional
  * appended builtin signature), and check the signature if present.  The
  * fsverity_descriptor must have already undergone basic validation.
  */
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc)
 {
 	struct fsverity_info *vi;
@@ -242,6 +259,13 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 		spin_lock_init(&vi->hash_page_init_lock);
 	}
 
+	err = fsverity_inode_setsecurity(inode, desc);
+	if (err == -EOPNOTSUPP)
+		err = 0;
+
+	if (err)
+		goto fail;
+
 	return vi;
 
 fail:
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 90c07573dd77..42f58f4e45d0 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -41,7 +41,9 @@ static struct key *fsverity_keyring;
  * @sig_size: size of signature in bytes, or 0 if no signature
  *
  * If the file includes a signature of its fs-verity file digest, verify it
- * against the certificates in the fs-verity keyring.
+ * against the certificates in the fs-verity keyring. Note that verification
+ * happens as long as the file's signature exists regardless the state of
+ * fsverity_require_signatures.
  *
  * Return: 0 on success (signature valid or not required); -errno on failure
  */
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 1eb7eae580be..9666721baf15 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -319,4 +319,6 @@ static inline int fsverity_prepare_setattr(struct dentry *dentry,
 	return 0;
 }
 
+#define FS_VERITY_INODE_SEC_NAME "fsverity.builtin-sig"
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.43.1


