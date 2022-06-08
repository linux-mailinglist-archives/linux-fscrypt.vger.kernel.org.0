Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E173E543C10
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 21:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbiFHTBz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 15:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234341AbiFHTBs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 15:01:48 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5446644C;
        Wed,  8 Jun 2022 12:01:46 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 300DD20BE67B;
        Wed,  8 Jun 2022 12:01:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 300DD20BE67B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1654714905;
        bh=qquP/5U04fx5jdHvG3QdvIEHIN6lVrpH6iQj5il7/BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6kWX/RoZstlrx6ix6Nma3KFO+Ebg4LNx2kDZe13goN0MqgJCCsoj5fu0zVD3hmo0
         9vcuESvVd3EOjfb23cSGIE04dHAF7G8Gd0gxA9gED6KyFKZSWDiEaOiUmN/NlfIb0w
         hO0+6Ak/2gBSp360cpBECfMSI+Izqhlxn8N9SDBU=
From:   Deven Bowers <deven.desai@linux.microsoft.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v8 13/17] fsverity: consume builtin signature via LSM hook
Date:   Wed,  8 Jun 2022 12:01:25 -0700
Message-Id: <1654714889-26728-14-git-send-email-deven.desai@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Fan Wu <wufan@linux.microsoft.com>

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

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
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
---
 fs/verity/fsverity_private.h |  2 +-
 fs/verity/open.c             | 13 ++++++++++++-
 fs/verity/signature.c        |  1 +
 include/linux/fsverity.h     |  2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index 629785c95007..e0d70235bbdc 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -114,7 +114,7 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
 				     unsigned int log_blocksize,
 				     const u8 *salt, size_t salt_size);
 
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc);
 
 void fsverity_set_info(struct inode *inode, struct fsverity_info *vi);
diff --git a/fs/verity/open.c b/fs/verity/open.c
index 81ff94442f7b..7e6fa52c0e9c 100644
--- a/fs/verity/open.c
+++ b/fs/verity/open.c
@@ -7,7 +7,9 @@
 
 #include "fsverity_private.h"
 
+#include <linux/security.h>
 #include <linux/slab.h>
+#include <crypto/public_key.h>
 
 static struct kmem_cache *fsverity_info_cachep;
 
@@ -146,7 +148,7 @@ static int compute_file_digest(struct fsverity_hash_alg *hash_alg,
  * appended signature), and check the signature if present.  The
  * fsverity_descriptor must have already undergone basic validation.
  */
-struct fsverity_info *fsverity_create_info(const struct inode *inode,
+struct fsverity_info *fsverity_create_info(struct inode *inode,
 					   struct fsverity_descriptor *desc)
 {
 	struct fsverity_info *vi;
@@ -182,6 +184,15 @@ struct fsverity_info *fsverity_create_info(const struct inode *inode,
 
 	err = fsverity_verify_signature(vi, desc->signature,
 					le32_to_cpu(desc->sig_size));
+	if (err) {
+		fsverity_err(inode, "Error %d verifying signature", err);
+		goto out;
+	}
+
+	err = security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME, desc->signature,
+					 le32_to_cpu(desc->sig_size), 0);
+	if (err == -EOPNOTSUPP)
+		err = 0;
 out:
 	if (err) {
 		fsverity_free_info(vi);
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 143a530a8008..5d7b9496f9c4 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -9,6 +9,7 @@
 
 #include <linux/cred.h>
 #include <linux/key.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/verification.h>
 
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 7af030fa3c36..f37936b56150 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -251,4 +251,6 @@ static inline bool fsverity_active(const struct inode *inode)
 	return fsverity_get_info(inode) != NULL;
 }
 
+#define FS_VERITY_INODE_SEC_NAME "fsverity.inode-info"
+
 #endif	/* _LINUX_FSVERITY_H */
-- 
2.25.1

