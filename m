Return-Path: <linux-fscrypt+bounces-145-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 355E1842FF1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:38:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E71AF28821C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:38:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DF5D146909;
	Tue, 30 Jan 2024 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eKRU4ybE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06D1128369;
	Tue, 30 Jan 2024 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654248; cv=none; b=YHziBxP1rupKe9pBWvZCS1x3nJOo+vIYfkFAw8tRklJaRQUHb1Y2vB3abikyfeJZL+T+TvmhGx8MHCtQtT+RhfSSzfHcM2pXQ5N0UN/qbL2lLAIku6ath/bjne6E0jwXvBzEjgwxsHnNnJrCXJJzwmY7DbvMLpbg1/iZ5bzsL9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654248; c=relaxed/simple;
	bh=q2N90IkYiMhawf/EMMMNOfHILynY5K1y2kARX2muhOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=ZuBHJ9BpImyK2uvwiPWrle+jVZwnnmCFDlJ1EtcPk7ZIX91nP4OH3kKapoN+iTZwbGrga5UlrSOvAgePabzDD/4+FvwpWILFbaIS7Pl5wkhaao6kXruD4tAkr1TZeocO5CgUZN2zTK9s36B0iGT0/cnbL+pbW6rfuhalPquHM74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eKRU4ybE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 4F5A820B200B; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4F5A820B200B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=MZIUTiZ4IP2Ll7W/ScSzaJN4C5rYzK2zFEdobpZtunU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKRU4ybEEAYVTcJ+3CYfX0iOCDUSsbZcW3FFJC+xe1rwPE9+Smgh+Gr0aUgZg/sc9
	 hb6VrsDZyQTIM9lmiRP0Mbr1Jcxaf9g6H4Wc/37pmxHnBLwtj5vUz3czZT46sESPQR
	 4A/MnsVD/6mdpkqr2P01SZpSgi6iQC4Mtj2mkdCc=
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
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v12 07/20] security: add new securityfs delete function
Date: Tue, 30 Jan 2024 14:36:55 -0800
Message-Id: <1706654228-17180-8-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

When deleting a directory in the security file system, the existing
securityfs_remove requires the directory to be empty, otherwise
it will do nothing. This leads to a potential risk that the security
file system might be in an unclean state when the intended deletion
did not happen.

This commit introduces a new function securityfs_recursive_remove
to recursively delete a directory without leaving an unclean state.

Co-developed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v8:
  + Not present

v9:
  + Introduced

v10:
  + No changes

v11:
  + Fix code style issues

v12:
  + No changes
---
 include/linux/security.h |  1 +
 security/inode.c         | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 1545c69edc1b..e994ac9cda91 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -2029,6 +2029,7 @@ struct dentry *securityfs_create_symlink(const char *name,
 					 const char *target,
 					 const struct inode_operations *iops);
 extern void securityfs_remove(struct dentry *dentry);
+extern void securityfs_recursive_remove(struct dentry *dentry);
 
 #else /* CONFIG_SECURITYFS */
 
diff --git a/security/inode.c b/security/inode.c
index 9e7cde913667..f21847badb7d 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -313,6 +313,31 @@ void securityfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(securityfs_remove);
 
+static void remove_one(struct dentry *victim)
+{
+	simple_release_fs(&mount, &mount_count);
+}
+
+/**
+ * securityfs_recursive_remove - recursively removes a file or directory
+ *
+ * @dentry: a pointer to a the dentry of the file or directory to be removed.
+ *
+ * This function recursively removes a file or directory in securityfs that was
+ * previously created with a call to another securityfs function (like
+ * securityfs_create_file() or variants thereof.)
+ */
+void securityfs_recursive_remove(struct dentry *dentry)
+{
+	if (IS_ERR_OR_NULL(dentry))
+		return;
+
+	simple_pin_fs(&fs_type, &mount, &mount_count);
+	simple_recursive_removal(dentry, remove_one);
+	simple_release_fs(&mount, &mount_count);
+}
+EXPORT_SYMBOL_GPL(securityfs_recursive_remove);
+
 #ifdef CONFIG_SECURITY
 static struct dentry *lsm_dentry;
 static ssize_t lsm_read(struct file *filp, char __user *buf, size_t count,
-- 
2.43.0


