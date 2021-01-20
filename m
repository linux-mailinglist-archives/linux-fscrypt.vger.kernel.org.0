Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146172FD859
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jan 2021 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404355AbhATSdx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 Jan 2021 13:33:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404575AbhATSan (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 Jan 2021 13:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E8EA2343E;
        Wed, 20 Jan 2021 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611167336;
        bh=lpye0VhJGkigj36g8jWP1QU3aINd657/umQesevgrZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doD8AlNck/wbYnHSmF1UzMkVRfM1c7U/XXokgOw7n/Sffye/sd51TGTv9nxmqEDx+
         INW+KqDSnynK7lmGTWG2M2E3VGrKWRYL0sZIDLVHNgynKUQZAuJMcAsB44pyPTbDKJ
         No7mlyAhxjUfbCyawTc29Uw1T07JJANt646tZzKmjuT31VJAi+XYEtpvU6Qwzy7lE2
         DJnOAof7APqVXk1SBby00RZIIevtmp4TIhp9fU62swVR3w5xy0VZZJTtJ4u0jwS91O
         gTv9e9FixVneXqyMzSGl6Rq8hp7VP8FuiUzteHmn7Ot6DVm8AhNRuk9dVfgylP4CBF
         eusz8aN6k8cWA==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH v4 10/17] ceph: add encrypted fname handling to ceph_mdsc_build_path
Date:   Wed, 20 Jan 2021 13:28:40 -0500
Message-Id: <20210120182847.644850-11-jlayton@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120182847.644850-1-jlayton@kernel.org>
References: <20210120182847.644850-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Allow ceph_mdsc_build_path to encrypt and base64 encode the filename
when the parent is encrypted and we're sending the path to the MDS.

In most cases, we just encrypt the filenames and base64 encode them,
but when the name is longer than CEPH_NOHASH_NAME_MAX, we use a similar
scheme to fscrypt proper, and hash the remaning bits with sha256.

When doing this, we then send along the full crypttext of the name in
the new alternate_name field of the MClientRequest. The MDS can then
send that along in readdir responses and traces.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/crypto.h     |  16 ++++++
 fs/ceph/mds_client.c | 133 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 131 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
index cc4e481bf13a..331b9c8da7fb 100644
--- a/fs/ceph/crypto.h
+++ b/fs/ceph/crypto.h
@@ -6,11 +6,27 @@
 #ifndef _CEPH_CRYPTO_H
 #define _CEPH_CRYPTO_H
 
+#include <crypto/sha2.h>
 #include <linux/fscrypt.h>
 
 #define	CEPH_XATTR_NAME_ENCRYPTION_CONTEXT	"encryption.ctx"
 
 #ifdef CONFIG_FS_ENCRYPTION
+
+/*
+ * We want to encrypt filenames when creating them, but the encrypted
+ * versions of those names may have illegal characters in them. To mitigate
+ * that, we base64 encode them, but that gives us a result that can exceed
+ * NAME_MAX.
+ *
+ * Follow a similar scheme to fscrypt itself, and cap the filename to a
+ * smaller size. If the cleartext name is longer than the value below, then
+ * sha256 hash the remaining bytes.
+ *
+ * 189 bytes => 252 bytes base64-encoded, which is <= NAME_MAX (255)
+ */
+#define CEPH_NOHASH_NAME_MAX (189 - SHA256_DIGEST_SIZE)
+
 void ceph_fscrypt_set_ops(struct super_block *sb);
 
 static inline void ceph_fscrypt_free_dummy_policy(struct ceph_fs_client *fsc)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 77cee8a0de3f..a8b67b988c51 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -13,6 +13,7 @@
 #include <linux/ktime.h>
 
 #include "super.h"
+#include "crypto.h"
 #include "mds_client.h"
 
 #include <linux/ceph/ceph_features.h>
@@ -2310,18 +2311,80 @@ static inline  u64 __get_oldest_tid(struct ceph_mds_client *mdsc)
 	return mdsc->oldest_tid;
 }
 
-/*
- * Build a dentry's path.  Allocate on heap; caller must kfree.  Based
- * on build_path_from_dentry in fs/cifs/dir.c.
+#if IS_ENABLED(CONFIG_FS_ENCRYPTION)
+static int encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+{
+	u32 len;
+	int elen;
+	int ret;
+	u8 *cryptbuf;
+
+	WARN_ON_ONCE(!fscrypt_has_encryption_key(parent));
+
+	/*
+	 * convert cleartext dentry name to ciphertext
+	 * if result is longer than CEPH_NOKEY_NAME_MAX,
+	 * sha256 the remaining bytes
+	 *
+	 * See: fscrypt_setup_filename
+	 */
+	if (!fscrypt_fname_encrypted_size(parent, dentry->d_name.len, NAME_MAX, &len))
+		return -ENAMETOOLONG;
+
+	cryptbuf = kmalloc(len, GFP_KERNEL);
+	if (!cryptbuf)
+		return -ENOMEM;
+
+	ret = fscrypt_fname_encrypt(parent, &dentry->d_name, cryptbuf, len);
+	if (ret) {
+		kfree(cryptbuf);
+		return ret;
+	}
+
+	if (len > CEPH_NOHASH_NAME_MAX) {
+		u8 hash[SHA256_DIGEST_SIZE];
+		u8 *extra = cryptbuf + CEPH_NOHASH_NAME_MAX;
+
+		/* hash the extra bytes and overwrite crypttext beyond that point with it */
+		sha256(extra, len - CEPH_NOHASH_NAME_MAX, hash);
+		memcpy(extra, hash, SHA256_DIGEST_SIZE);
+		len = CEPH_NOHASH_NAME_MAX + SHA256_DIGEST_SIZE;
+	}
+
+	/* base64 encode the encrypted name */
+	elen = fscrypt_base64_encode(cryptbuf, len, buf);
+	kfree(cryptbuf);
+	dout("base64-encoded ciphertext name = %.*s\n", len, buf);
+	return elen;
+}
+#else
+static int encode_encrypted_fname(const struct inode *parent, struct dentry *dentry, char *buf)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+/**
+ * ceph_mdsc_build_path - build a path string to a given dentry
+ * @dentry: dentry to which path should be built
+ * @plen: returned length of string
+ * @pbase: returned base inode number
+ * @for_wire: is this path going to be sent to the MDS?
+ *
+ * Build a string that represents the path to the dentry. This is mostly called
+ * for two different purposes:
  *
- * If @stop_on_nosnap, generate path relative to the first non-snapped
- * inode.
+ * 1) we need to build a path string to send to the MDS (for_wire == true)
+ * 2) we need a path string for local presentation (e.g. debugfs) (for_wire == false)
+ *
+ * The path is built in reverse, starting with the dentry. Walk back up toward
+ * the root, building the path until the first non-snapped inode is reached (for_wire)
+ * or the root inode is reached (!for_wire).
  *
  * Encode hidden .snap dirs as a double /, i.e.
  *   foo/.snap/bar -> foo//bar
  */
-char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
-			   int stop_on_nosnap)
+char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase, int for_wire)
 {
 	struct dentry *cur;
 	struct inode *inode;
@@ -2343,30 +2406,65 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 	seq = read_seqbegin(&rename_lock);
 	cur = dget(dentry);
 	for (;;) {
-		struct dentry *temp;
+		struct dentry *parent;
 
 		spin_lock(&cur->d_lock);
 		inode = d_inode(cur);
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
 			     pos, cur);
-		} else if (stop_on_nosnap && inode && dentry != cur &&
-			   ceph_snap(inode) == CEPH_NOSNAP) {
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+		} else if (for_wire && inode && dentry != cur && ceph_snap(inode) == CEPH_NOSNAP) {
 			spin_unlock(&cur->d_lock);
 			pos++; /* get rid of any prepended '/' */
 			break;
-		} else {
+		} else if (!for_wire || !IS_ENCRYPTED(d_inode(cur->d_parent))) {
 			pos -= cur->d_name.len;
 			if (pos < 0) {
 				spin_unlock(&cur->d_lock);
 				break;
 			}
 			memcpy(path + pos, cur->d_name.name, cur->d_name.len);
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+		} else {
+			int len, ret;
+			char buf[FSCRYPT_BASE64_CHARS(NAME_MAX)];
+
+			/*
+			 * Proactively copy name into buf, in case we need to present
+			 * it as-is.
+			 */
+			memcpy(buf, cur->d_name.name, cur->d_name.len);
+			len = cur->d_name.len;
+			spin_unlock(&cur->d_lock);
+			parent = dget_parent(cur);
+
+			ret = __fscrypt_prepare_readdir(d_inode(parent));
+			if (ret < 0) {
+				dput(parent);
+				dput(cur);
+				return ERR_PTR(ret);
+			}
+
+			if (fscrypt_has_encryption_key(d_inode(parent))) {
+				len = encode_encrypted_fname(d_inode(parent), cur, buf);
+				if (len < 0) {
+					dput(parent);
+					dput(cur);
+					return ERR_PTR(len);
+				}
+			}
+			pos -= len;
+			if (pos < 0) {
+				dput(parent);
+				break;
+			}
+			memcpy(path + pos, buf, len);
 		}
-		temp = cur;
-		spin_unlock(&temp->d_lock);
-		cur = dget_parent(temp);
-		dput(temp);
+		dput(cur);
+		cur = parent;
 
 		/* Are we at the root? */
 		if (IS_ROOT(cur))
@@ -2390,8 +2488,7 @@ char *ceph_mdsc_build_path(struct dentry *dentry, int *plen, u64 *pbase,
 		 * A rename didn't occur, but somehow we didn't end up where
 		 * we thought we would. Throw a warning and try again.
 		 */
-		pr_warn("build_path did not end path lookup where "
-			"expected, pos is %d\n", pos);
+		pr_warn("build_path did not end path lookup where expected (pos = %d)\n", pos);
 		goto retry;
 	}
 
@@ -2411,7 +2508,7 @@ static int build_dentry_path(struct dentry *dentry, struct inode *dir,
 	rcu_read_lock();
 	if (!dir)
 		dir = d_inode_rcu(dentry->d_parent);
-	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP) {
+	if (dir && parent_locked && ceph_snap(dir) == CEPH_NOSNAP && !IS_ENCRYPTED(dir)) {
 		*pino = ceph_ino(dir);
 		rcu_read_unlock();
 		*ppath = dentry->d_name.name;
-- 
2.29.2

