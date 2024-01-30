Return-Path: <linux-fscrypt+bounces-151-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22103843019
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 427F71C25297
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE97A80BFB;
	Tue, 30 Jan 2024 22:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="iy7FvRaf"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1C1754276;
	Tue, 30 Jan 2024 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654252; cv=none; b=Trt4P+GqXJ5e5jSp+IG3+nZkuGEiBSlbgVrfEcwI6N0km06fJ27k/p4V4o0b56X4iXBb57SJy0AD2zbOJ6mH6tnp4r/lzeE5zi0zy7YWU8XbOBbjqJTjfm6tmuCXndw/b+p+6QClhHr2wRdMtWuz1kLKuEzGQcjKFubs1SKc5Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654252; c=relaxed/simple;
	bh=Kcfy9Qwv8C4L75RA5qvC2WHH3goDIHw/rg7r56Zd5x8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=tW8/uo22vf02/lgC0GX1fwndQSGMRZORayWVqoZIPIt+FKQqFOR3P8Oj0dGSDeMySl+yB5vlT11F3kMqw9hm5VveBl+RsuhZn8kltBhCfSkmP77x6OrnkBTjVX6CEkUWXmTmMJe2kQbcAQ443Rg9G7hHes0Ex5iuUDQJAws6dQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=iy7FvRaf; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id D415F20B201C; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D415F20B201C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=tz4qfp1c6YSioITNH1+lWqu+wc3n3uiMlxKLW6y7ajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iy7FvRafzFJ9bWkyJuugy+1SC0N9Tpmo1lx2fetxGSqHy2dhKtwfO/XBvrdhsuR5J
	 lFo3bEOEATOpJ4qEZ0l0+myit/rwox5By6dtVDiTgSbS/w2oqi4nQ0N1t2V0aom1hB
	 M0gFGUUqN6Y2AGSoSkYvw5Zar+Oi+bni8mybrRoA=
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
Subject: [RFC PATCH v12 16/20] fsverity: consume builtin signature via LSM hook
Date: Tue, 30 Jan 2024 14:37:04 -0800
Message-Id: <1706654228-17180-17-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
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
---
 fs/verity/fsverity_private.h |  2 +-
 fs/verity/open.c             | 26 +++++++++++++++++++++++++-
 include/linux/fsverity.h     |  2 ++
 3 files changed, 28 insertions(+), 2 deletions(-)

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
2.43.0


