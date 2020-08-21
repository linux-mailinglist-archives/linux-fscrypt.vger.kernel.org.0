Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE2C24DF84
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHUS2u (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbgHUS2U (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:20 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54A6623104;
        Fri, 21 Aug 2020 18:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034500;
        bh=CAfhgqN/6g98bVKb1tCN2jUYbN58/s2E3Mac8EK4Irc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ajCfk2Cx7i1rv6+yULm62zhhwTbQyL128CIl2/KFV6KyohFEZANdFkK9VJ+s0Rm4g
         vzU/7It9uk6NqSRT2qcQ/zYkdjXHgiQgG1gJIpwM6ahkvY0zl083+khgsDOKBFPjww
         67/w6p4Oxqs2zsIfMxAb09cRM2VMK2/EOY90Sm7A=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 11/14] ceph: add encrypted fname handling to ceph_mdsc_build_path
Date:   Fri, 21 Aug 2020 14:28:10 -0400
Message-Id: <20200821182813.52570-12-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Allow ceph_mdsc_build_path to encrypt and base64 encode the filename
when the parent is encrypted and we're sending the path to the MDS.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 51 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c4bfa383e8c4..08e173b821b5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -11,6 +11,7 @@
 #include <linux/ratelimit.h>
 #include <linux/bits.h>
 #include <linux/ktime.h>
+#include <linux/base64.h>
 
 #include "super.h"
 #include "mds_client.h"
@@ -2323,8 +2324,7 @@ static inline  u64 __get_oldest_tid(struct ceph_mds_client *mdsc)
  * Encode hidden .snap dirs as a double /, i.e.
  *   foo/.snap/bar -> foo//bar
  */
-char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
-			   int stop_on_nosnap)
+char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for_wire)
 {
 	struct dentry *cur;
 	struct inode *inode;
@@ -2346,30 +2346,59 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	seq = read_seqbegin(&rename_lock);
 	cur = dget(dentry);
 	for (;;) {
-		struct dentry *temp;
+		struct dentry *parent;
 
 		spin_lock(&cur->d_lock);
 		inode = d_inode(cur);
+		parent = cur->d_parent;
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, cur);
-		} else if (stop_on_nosnap && inode && dentry != cur &&
-			   ceph_snap(inode) == CEPH_NOSNAP) {
+			dget(parent);
+			spin_unlock(&cur->d_lock);
+		} else if (for_wire && inode && dentry != cur && ceph_snap(inode) == CEPH_NOSNAP) {
 			spin_unlock(&cur->d_lock);
 			pos++; /* get rid of any prepended '/' */
 			break;
-		} else {
+		} else if (!for_wire || !IS_ENCRYPTED(d_inode(parent))) {
 			pos -= cur->d_name.len;
 			if (pos < 0) {
 				spin_unlock(&cur->d_lock);
 				break;
 			}
 			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
+			dget(parent);
+			spin_unlock(&cur->d_lock);
+		} else {
+			int err;
+			struct fscrypt_name fname = { };
+			int len;
+			char buf[BASE64_CHARS(NAME_MAX)];
+
+			dget(parent);
+			spin_unlock(&cur->d_lock);
+
+			err = fscrypt_setup_filename(d_inode(parent), &cur->d_name, 1, &fname);
+			if (err) {
+				dput(parent);
+				dput(cur);
+				return ERR_PTR(err);
+			}
+
+			/* base64 encode the encrypted name */
+			len = base64_encode(fname.disk_name.name, fname.disk_name.len, buf);
+			pos -= len;
+			if (pos < 0) {
+				dput(parent);
+				fscrypt_free_filename(&fname);
+				break;
+			}
+			memcpy(path + pos, buf, len);
+			dout("non-ciphertext name = %.*s\n", len, buf);
+			fscrypt_free_filename(&fname);
 		}
-		temp = cur;
-		cur = dget(temp->d_parent);
-		spin_unlock(&temp->d_lock);
-		dput(temp);
+		dput(cur);
+		cur = parent;
 
 		/* Are we at the root? */
 		if (IS_ROOT(cur))
@@ -2414,7 +2443,7 @@ static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 	rcu_read_lock();
 	if (!dir)
 		dir = d_inode_rcu(dentry->d_parent);
-	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP) {
+	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP && !IS_ENCRYPTED(dir)) {
 		*pino = ceph_ino(dir);
 		rcu_read_unlock();
 		*ppath = dentry->d_name.name;
-- 
2.26.2

