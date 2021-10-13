Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47BF42C982
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 Oct 2021 21:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239175AbhJMTJJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 15:09:09 -0400
Received: from linux.microsoft.com ([13.77.154.182]:49084 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbhJMTIp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 15:08:45 -0400
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6AFE820B9D08;
        Wed, 13 Oct 2021 12:06:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6AFE820B9D08
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1634152000;
        bh=Ir+wHn78Ha/CpgYRRf54IWj37u4GCDvYeMB66jhtFJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEJ+qzkE8sVGc2k5tN4GNhe6MyvudBw7B0KtqjRClfKxvNtPjUuhLWB0K0kS2KZyY
         xNLYhbhNxhEPFgPcFyths5QATre4gZEdzBg7Fkc3h+jgBLUdEfOwq7q5BngFXI4G7T
         fXWWwYkoq6NQjSz1xTmShT2WgPORVC5QTg64qjeU=
From:   deven.desai@linux.microsoft.com
To:     corbet@lwn.net, axboe@kernel.dk, agk@redhat.com,
        snitzer@redhat.com, ebiggers@kernel.org, tytso@mit.edu,
        paul@paul-moore.com, eparis@redhat.com, jmorris@namei.org,
        serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH v7 12/16] fsverity|security: add security hooks to fsverity digest and signature
Date:   Wed, 13 Oct 2021 12:06:31 -0700
Message-Id: <1634151995-16266-13-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Fan Wu <wufan@linux.microsoft.com>

Add security_inode_setsecurity to fsverity signature verification.
This can let LSMs save the signature data and digest hashes provided
by fsverity.

Also changes the implementaion inside the hook function to let
multiple LSMs can add hooks.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
 fs/verity/open.c         | 12 ++++++++++++
 fs/verity/signature.c    |  5 ++++-
 include/linux/fsverity.h |  3 +++
 security/ipe/hooks.c     |  1 +
 security/security.c      |  6 +++---
 5 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/verity/open.c b/fs/verity/open.c
index 92df87f5fa38..1f36dae01c22 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -7,6 +7,7 @@
 
 #include "fsverity_private.h"
 
+#include <linux/security.h>
 #include <linux/slab.h>
 
 static struct kmem_cache *fsverity_info_cachep;
@@ -177,6 +178,17 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 		fsverity_err(inode, "Error %d computing file digest", err);
 		goto out;
 	}
+
+	err = security_inode_setsecurity((struct inode *)inode,
+					 FS_VERITY_DIGEST_SEC_NAME,
+					 vi->file_digest,
+					 vi->tree_params.hash_alg->digest_size,
+					 0);
+	if (err) {
+		fsverity_err(inode, "Error %d inode setsecurity hook", err);
+		goto out;
+	}
+
 	pr_debug("Computed file digest: %s:%*phN\n",
 		 vi->tree_params.hash_alg->name,
 		 vi->tree_params.digest_size, vi->file_digest);
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..20e585d5fa6d 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -9,6 +9,7 @@
 
 #include <linux/cred.h>
 #include <linux/key.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/verification.h>
 
@@ -84,7 +85,9 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 
 	pr_debug("Valid signature for file digest %s:%*phN\n",
 		 hash_alg->name, hash_alg->digest_size, vi->file_digest);
-	return 0;
+	return security_inode_setsecurity((struct inode *)inode,
+					FS_VERITY_SIGNATURE_SEC_NAME,
+					signature, sig_size, 0);
 }
 
 #ifdef CONFIG_SYSCTL
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index b568b3c7d095..dfd7b5a85c67 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -233,4 +233,7 @@ static inline bool fsverity_active(const struct inode *inode)
 	return fsverity_get_info(inode) != NULL;
 }
 
+#define FS_VERITY_SIGNATURE_SEC_NAME "fsverity.verity-sig"
+#define FS_VERITY_DIGEST_SEC_NAME "fsverity.verity-digest"
+
 #endif	/* _LINUX_FSVERITY_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
index 470fb48e490c..d76e60a3f511 100644
--- a/security/ipe/hooks.c
+++ b/security/ipe/hooks.c
@@ -232,6 +232,7 @@ void ipe_bdev_free_security(struct block_device *bdev)
 	struct ipe_bdev *blob = ipe_bdev(bdev);
 
 	kfree(blob->sigdata);
+	kfree(blob->hash);
 }
 
 /**
diff --git a/security/security.c b/security/security.c
index d7ac9f01500b..81751a91f438 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1462,7 +1462,7 @@ int security_inode_getsecurity(struct user_namespace *mnt_userns,
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags)
 {
 	struct security_hook_list *hp;
-	int rc;
+	int rc = LSM_RET_DEFAULT(inode_setsecurity);
 
 	if (unlikely(IS_PRIVATE(inode)))
 		return LSM_RET_DEFAULT(inode_setsecurity);
@@ -1472,10 +1472,10 @@ int security_inode_setsecurity(struct inode *inode, const char *name, const void
 	hlist_for_each_entry(hp, &security_hook_heads.inode_setsecurity, list) {
 		rc = hp->hook.inode_setsecurity(inode, name, value, size,
 								flags);
-		if (rc != LSM_RET_DEFAULT(inode_setsecurity))
+		if (rc && rc != LSM_RET_DEFAULT(inode_setsecurity))
 			return rc;
 	}
-	return LSM_RET_DEFAULT(inode_setsecurity);
+	return rc;
 }
 
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size)
-- 
2.33.0

