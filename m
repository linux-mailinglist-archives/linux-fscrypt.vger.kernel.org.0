Return-Path: <linux-fscrypt+bounces-193-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B5586BD49
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 01:56:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CAA61C23A18
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 00:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FF5339FEC;
	Thu, 29 Feb 2024 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="E1w8OJlb"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90FFF364B1;
	Thu, 29 Feb 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168127; cv=none; b=HziB1jkV14qWym488XvcCbHi4rD7ZMHnPTwE5puOAI8kof4PO2UOfOp/2OTIN0whHm6mNAebLkYMhpWWL68K8eRgC0WRzFs9bcG5gquKlKrYBnhsOAN9QqioqnUBrbVrl70G/4yctX+wjwMWDw5t310durkeoeBWvFCzP12m5do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168127; c=relaxed/simple;
	bh=wGNb4NScXdbzlOlLmcXstovMH8StS711fIbpwNily14=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=OpJOV7R6bNRLeiP922R7VkAY1Ce90lMFZPj8uiyfaf4SVdDHNHN9QovT66Kbs8tvlQrT8crKoTU1WPoV83qcSY5uUidb2Mk9B6l4oGHEbh0e+lDOkXQXXBkFTbULoAxaaYiJundyZGQlzvmIVE9kvZeP6mwekRzXGJsMeX4lYWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=E1w8OJlb; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 32EA420B74DB; Wed, 28 Feb 2024 16:55:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 32EA420B74DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709168119;
	bh=Xn9puIz0MoXXsc0AcfjH8XME4AbGblexZ+o6f5LDNAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E1w8OJlbdlzqPdNsYMaPlOs6FNwxBjFelQVH64mG9r4MqipC0mlO9lnuH+NizcRN1
	 2hyk6FUm7j4s4Dbphv6/LBFOoJEROSQoNm45PW2dEHSwzReOWn417e6exdfV+/fZVo
	 Kg+MbRl/HwMqLDS2rogGuz99twy06d98G1gKkw4Q=
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
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v13 14/20] dm verity: consume root hash digest and signature data via LSM hook
Date: Wed, 28 Feb 2024 16:54:56 -0800
Message-Id: <1709168102-7677-15-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

From: Deven Bowers <deven.desai@linux.microsoft.com>

dm-verity provides a strong guarantee of a block device's integrity. As
a generic way to check the integrity of a block device, it provides
those integrity guarantees to its higher layers, including the filesystem
level.

An LSM that control access to a resource on the system based on the
available integrity claims can use this transitive property of
dm-verity, by querying the underlying block_device of a particular
file.

The digest and signature information need to be stored in the block
device to fulfill the next requirement of authorization via LSM policy.
This will enable the LSM to perform revocation of devices that are still
mounted, prohibiting execution of files that are no longer authorized
by the LSM in question.

This patch added two security hook calls in dm-verity to save the
dm-verity roothash and the roothash signature to the block device's
LSM blobs. The hook calls are depended on CONFIG_IPE_PROP_DM_VERITY,
which will be introduced in the next commit.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + No changes

v4:
  + No changes

v5:
  + No changes

v6:
  + Fix an improper cleanup that can result in
    a leak

v7:
  + Squash patch 08/12, 10/12 to [11/16]
  + Use part0 for block_device, to retrieve the block_device, when
    calling security_bdev_setsecurity

v8:
  + Undo squash of 08/12, 10/12 - separating drivers/md/ from
    security/ & block/
  + Use common-audit function for dmverity_signature.
  + Change implementation for storing the dm-verity digest to use the
    newly introduced dm_verity_digest structure introduced in patch
    14/20.
  + Create new structure, dm_verity_digest, containing digest algorithm,
    size, and digest itself to pass to the LSM layer. V7 was missing the
    algorithm.
  + Create an associated public header containing this new structure and
    the key values for the LSM hook, specific to dm-verity.
  + Additional information added to commit, discussing the layering of
    the changes and how the information passed will be used.

v9:
  + No changes

v10:
  + No changes

v11:
  + Add an optional field to save signature
  + Move the security hook call to the new finalize hook

v12:
  + No changes

v13:
  + No changes
---
 drivers/md/dm-verity-target.c | 71 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-verity.h        |  6 +++
 include/linux/dm-verity.h     | 19 ++++++++++
 3 files changed, 96 insertions(+)
 create mode 100644 include/linux/dm-verity.h

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index a99ef30e45ca..e7bc6afae708 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -13,6 +13,7 @@
  * access behavior.
  */
 
+#include "dm-core.h"
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
@@ -22,6 +23,9 @@
 #include <linux/scatterlist.h>
 #include <linux/string.h>
 #include <linux/jump_label.h>
+#include <linux/security.h>
+#include <linux/dm-verity.h>
+#include <crypto/hash_info.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -990,6 +994,17 @@ static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	blk_limits_io_min(limits, limits->logical_block_size);
 }
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+static void verity_free_sig(struct dm_verity *v)
+{
+	kfree(v->root_digest_sig);
+}
+#else
+static inline void verity_free_sig(struct dm_verity *v)
+{
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 static void verity_dtr(struct dm_target *ti)
 {
 	struct dm_verity *v = ti->private;
@@ -1008,6 +1023,7 @@ static void verity_dtr(struct dm_target *ti)
 	kfree(v->salt);
 	kfree(v->root_digest);
 	kfree(v->zero_digest);
+	verity_free_sig(v);
 
 	if (v->tfm)
 		crypto_free_ahash(v->tfm);
@@ -1199,6 +1215,25 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 	return r;
 }
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+static int verity_init_sig(struct dm_verity *v, const void *sig,
+			   size_t sig_size)
+{
+	v->sig_size = sig_size;
+	v->root_digest_sig = kmalloc(v->sig_size, GFP_KERNEL);
+	if (!v->root_digest)
+		return -ENOMEM;
+
+	return 0;
+}
+#else
+static inline int verity_init_sig(struct dm_verity *v, const void *sig,
+				  size_t sig_size)
+{
+	return 0;
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 /*
  * Target parameters:
  *	<version>	The current format is version 1.
@@ -1407,6 +1442,13 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Root hash verification failed";
 		goto bad;
 	}
+
+	r = verity_init_sig(v, verify_args.sig, verify_args.sig_size);
+	if (r < 0) {
+		ti->error = "Cannot allocate root digest signature";
+		goto bad;
+	}
+
 	v->hash_per_block_bits =
 		__fls((1 << v->hash_dev_block_bits) / v->digest_size);
 
@@ -1557,6 +1599,32 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
 	return 0;
 }
 
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+static int verity_finalize(struct dm_target *ti)
+{
+	struct block_device *bdev;
+	struct dm_verity_digest root_digest;
+	struct dm_verity *v;
+	int r;
+
+	v = ti->private;
+	bdev = dm_table_get_md(ti->table)->disk->part0;
+	root_digest.digest = v->root_digest;
+	root_digest.digest_len = v->digest_size;
+	root_digest.alg = v->alg_name;
+
+	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
+				      sizeof(root_digest));
+	if (r)
+		return r;
+
+	return security_bdev_setsecurity(bdev,
+					 DM_VERITY_SIGNATURE_SEC_NAME,
+					 v->root_digest_sig,
+					 v->sig_size);
+}
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
+
 static struct target_type verity_target = {
 	.name		= "verity",
 	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
@@ -1569,6 +1637,9 @@ static struct target_type verity_target = {
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	.finalize	= verity_finalize,
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 };
 module_dm(verity);
 
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index db93a91169d5..4da3d2811aba 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -43,6 +43,9 @@ struct dm_verity {
 	u8 *root_digest;	/* digest of the root block */
 	u8 *salt;		/* salt: its size is salt_size */
 	u8 *zero_digest;	/* digest for a zero block */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	u8 *root_digest_sig;	/* digest signature of the root block */
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 	unsigned int salt_size;
 	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
@@ -56,6 +59,9 @@ struct dm_verity {
 	bool hash_failed:1;	/* set if hash of any block failed */
 	bool use_tasklet:1;	/* try to verify in tasklet before work-queue */
 	unsigned int digest_size;	/* digest size for the current hash algorithm */
+#ifdef CONFIG_IPE_PROP_DM_VERITY
+	unsigned int sig_size;	/* digest signature size */
+#endif /* CONFIG_IPE_PROP_DM_VERITY */
 	unsigned int ahash_reqsize;/* the size of temporary space for crypto */
 	enum verity_mode mode;	/* mode for handling verification errors */
 	unsigned int corrupted_errs;/* Number of errors for corrupted blocks */
diff --git a/include/linux/dm-verity.h b/include/linux/dm-verity.h
new file mode 100644
index 000000000000..7d9753445534
--- /dev/null
+++ b/include/linux/dm-verity.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_DM_VERITY_H
+#define _LINUX_DM_VERITY_H
+
+#include <linux/types.h>
+#include <crypto/hash_info.h>
+#include <linux/device-mapper.h>
+
+struct dm_verity_digest {
+	const char *alg;
+	const u8 *digest;
+	size_t digest_len;
+};
+
+#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-signature"
+#define DM_VERITY_ROOTHASH_SEC_NAME  DM_NAME	".verity-roothash"
+
+#endif /* _LINUX_DM_VERITY_H */
-- 
2.43.1


