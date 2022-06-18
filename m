Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B885550533
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbiFRNwk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiFRNw1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:27 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F921D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:25 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 07BFA13C7;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id EFB1E1002DD; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>,
        Sebastien Buisson <sbuisson@ddn.com>
Subject: [PATCH 06/28] lustre: sec: support test_dummy_encryption=v2
Date:   Sat, 18 Jun 2022 09:51:48 -0400
Message-Id: <1655560330-30743-7-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
References: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

A new version, v2, for test_dummy_encryption was added to the
fscrypt API. Add support for this new test encryption to Lustre.

WC-bug-id: https://jira.whamcloud.com/browse/LU-13783
Lustre-commit: ed318a6cc0b620440 ("LU-13783 sec: support of native Ubuntu 20.04 HWE 5.8 kernel")
Signed-off-by: James Simmons <jsimmons@infradead.org>
Signed-off-by: Sebastien Buisson <sbuisson@ddn.com>
Reviewed-on: https://review.whamcloud.com/46238
Reviewed-by: Jian Yu <yujian@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
---
 fs/lustre/include/lustre_crypto.h | 15 +++++++--------
 fs/lustre/include/lustre_disk.h   |  3 +++
 fs/lustre/llite/crypto.c          | 30 +++++++++++++-----------------
 fs/lustre/llite/dir.c             |  2 +-
 fs/lustre/llite/llite_internal.h  |  2 +-
 fs/lustre/llite/llite_lib.c       | 33 +++++++++++++++++++++++++++------
 fs/lustre/llite/namei.c           |  3 ++-
 7 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/fs/lustre/include/lustre_crypto.h b/fs/lustre/include/lustre_crypto.h
index 6cc946d..c31cc1e 100644
--- a/fs/lustre/include/lustre_crypto.h
+++ b/fs/lustre/include/lustre_crypto.h
@@ -32,11 +32,16 @@
 
 #include <linux/fscrypt.h>
 
+/* Macro to extract digest from Lustre specific structures */
+#define LLCRYPT_EXTRACT_DIGEST(name, len)			\
+	((name) + round_down((len) - FS_CRYPTO_BLOCK_SIZE - 1,	\
+			     FS_CRYPTO_BLOCK_SIZE))
+
 struct ll_sb_info;
 #ifdef CONFIG_FS_ENCRYPTION
 int ll_set_encflags(struct inode *inode, void *encctx, u32 encctxlen,
 		    bool preload);
-bool ll_sbi_has_test_dummy_encryption(struct ll_sb_info *sbi);
+bool ll_sb_has_test_dummy_encryption(struct super_block *sb);
 bool ll_sbi_has_encrypt(struct ll_sb_info *sbi);
 void ll_sbi_set_encrypt(struct ll_sb_info *sbi, bool set);
 #else
@@ -46,7 +51,7 @@ static inline int ll_set_encflags(struct inode *inode, void *encctx,
 	return 0;
 }
 
-static inline bool ll_sbi_has_test_dummy_encryption(struct ll_sb_info *sbi)
+static inline bool ll_sb_has_test_dummy_encryption(struct super_block *sb)
 {
 	return false;
 }
@@ -123,10 +128,4 @@ static inline int critical_decode(const u8 *src, int len, char *dst)
 	return (char *)q - dst;
 }
 
-/* Extracts the second-to-last ciphertext block */
-#define LLCRYPT_FNAME_DIGEST(name, len)					\
-	((name) + round_down((len) - FS_CRYPTO_BLOCK_SIZE - 1,		\
-			     FS_CRYPTO_BLOCK_SIZE))
-#define LLCRYPT_FNAME_DIGEST_SIZE	FS_CRYPTO_BLOCK_SIZE
-
 #endif /* _LUSTRE_CRYPTO_H_ */
diff --git a/fs/lustre/include/lustre_disk.h b/fs/lustre/include/lustre_disk.h
index d8686fc..15f94ad8 100644
--- a/fs/lustre/include/lustre_disk.h
+++ b/fs/lustre/include/lustre_disk.h
@@ -47,6 +47,7 @@
 #include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/backing-dev.h>
+#include <lustre_crypto.h>
 
 /****************** persistent mount data *********************/
 
@@ -131,6 +132,8 @@ struct lustre_sb_info {
 	struct obd_export	 *lsi_osd_exp;
 	char			  lsi_osd_type[16];
 	char			  lsi_fstype[16];
+	/* Encryption context for '-o test_dummy_encryption' */
+	struct fscrypt_dummy_context lsi_dummy_enc_ctx;
 };
 
 #define LSI_UMOUNT_FAILOVER	0x00200000
diff --git a/fs/lustre/llite/crypto.c b/fs/lustre/llite/crypto.c
index b0e4f76..f075b9a 100644
--- a/fs/lustre/llite/crypto.c
+++ b/fs/lustre/llite/crypto.c
@@ -145,16 +145,17 @@ int ll_file_open_encrypt(struct inode *inode, struct file *filp)
 	return rc;
 }
 
-bool ll_sbi_has_test_dummy_encryption(struct ll_sb_info *sbi)
+static const union fscrypt_context *
+ll_get_dummy_context(struct super_block *sb)
 {
-	return unlikely(test_bit(LL_SBI_TEST_DUMMY_ENCRYPTION, sbi->ll_flags));
+	struct lustre_sb_info *lsi = s2lsi(sb);
+
+	return lsi ? lsi->lsi_dummy_enc_ctx.ctx : NULL;
 }
 
-static bool ll_dummy_context(struct inode *inode)
+bool ll_sb_has_test_dummy_encryption(struct super_block *sb)
 {
-	struct ll_sb_info *sbi = ll_i2sbi(inode);
-
-	return sbi ? ll_sbi_has_test_dummy_encryption(sbi) : false;
+	return ll_get_dummy_context(sb) != NULL;
 }
 
 bool ll_sbi_has_encrypt(struct ll_sb_info *sbi)
@@ -263,14 +264,14 @@ int ll_setup_filename(struct inode *dir, const struct qstr *iname,
 			rc = -EINVAL;
 			goto out_free;
 		}
-		digest = (struct ll_digest_filename *)fname->crypto_buf.name;
+		digest = (struct ll_digest_filename *)fname->disk_name.name;
 		*fid = digest->ldf_fid;
 		if (!fid_is_sane(fid)) {
 			rc = -EINVAL;
 			goto out_free;
 		}
 		fname->disk_name.name = digest->ldf_excerpt;
-		fname->disk_name.len = LLCRYPT_FNAME_DIGEST_SIZE;
+		fname->disk_name.len = sizeof(digest->ldf_excerpt);
 	}
 	if (IS_ENCRYPTED(dir) &&
 	    !name_is_dot_or_dotdot(fname->disk_name.name,
@@ -305,11 +306,6 @@ int ll_setup_filename(struct inode *dir, const struct qstr *iname,
 	return rc;
 }
 
-#define LLCRYPT_FNAME_DIGEST(name, len) \
-	((name) + round_down((len) - FS_CRYPTO_BLOCK_SIZE - 1, \
-			     FS_CRYPTO_BLOCK_SIZE))
-#define LLCRYPT_FNAME_MAX_UNDIGESTED_SIZE	32
-
 /**
  * ll_fname_disk_to_usr() - overlay to fscrypt_fname_disk_to_usr
  * @inode: the inode to convert name
@@ -359,7 +355,7 @@ int ll_fname_disk_to_usr(struct inode *inode,
 			lltr.name = buf;
 			lltr.len = len;
 		}
-		if (lltr.len > LLCRYPT_FNAME_MAX_UNDIGESTED_SIZE &&
+		if (lltr.len > FS_CRYPTO_BLOCK_SIZE * 2 &&
 		    !fscrypt_has_encryption_key(inode)) {
 			digested = 1;
 			/* Without the key for long names, set the dentry name
@@ -371,8 +367,8 @@ int ll_fname_disk_to_usr(struct inode *inode,
 				return -EINVAL;
 			digest.ldf_fid = *fid;
 			memcpy(digest.ldf_excerpt,
-			       LLCRYPT_FNAME_DIGEST(lltr.name, lltr.len),
-			       LLCRYPT_FNAME_DIGEST_SIZE);
+			       LLCRYPT_EXTRACT_DIGEST(lltr.name, lltr.len),
+			       sizeof(digest.ldf_excerpt));
 
 			lltr.name = (char *)&digest;
 			lltr.len = sizeof(digest);
@@ -440,7 +436,7 @@ int ll_revalidate_d_crypto(struct dentry *dentry, unsigned int flags)
 	.key_prefix		= "lustre:",
 	.get_context		= ll_get_context,
 	.set_context		= ll_set_context,
-	.dummy_context		= ll_dummy_context,
+	.get_dummy_context	= ll_get_dummy_context,
 	.empty_dir		= ll_empty_dir,
 	.max_namelen		= NAME_MAX,
 };
diff --git a/fs/lustre/llite/dir.c b/fs/lustre/llite/dir.c
index 29d7e44..6eaac9a 100644
--- a/fs/lustre/llite/dir.c
+++ b/fs/lustre/llite/dir.c
@@ -495,7 +495,7 @@ static int ll_dir_setdirstripe(struct dentry *dparent, struct lmv_user_md *lump,
 
 	if (ll_sbi_has_encrypt(sbi) &&
 	    (IS_ENCRYPTED(parent) ||
-	     unlikely(fscrypt_dummy_context_enabled(parent)))) {
+	     unlikely(ll_sb_has_test_dummy_encryption(parent->i_sb)))) {
 		err = fscrypt_get_encryption_info(parent);
 		if (err)
 			goto out_op_data;
diff --git a/fs/lustre/llite/llite_internal.h b/fs/lustre/llite/llite_internal.h
index 426c797..b052e82 100644
--- a/fs/lustre/llite/llite_internal.h
+++ b/fs/lustre/llite/llite_internal.h
@@ -1726,7 +1726,7 @@ static inline struct pcc_super *ll_info2pccs(struct ll_inode_info *lli)
  */
 struct ll_digest_filename {
 	struct lu_fid ldf_fid;
-	char ldf_excerpt[LLCRYPT_FNAME_DIGEST_SIZE];
+	char ldf_excerpt[FS_CRYPTO_BLOCK_SIZE];
 };
 
 int ll_setup_filename(struct inode *dir, const struct qstr *iname,
diff --git a/fs/lustre/llite/llite_lib.c b/fs/lustre/llite/llite_lib.c
index 99ab9ac..aaff3fa 100644
--- a/fs/lustre/llite/llite_lib.c
+++ b/fs/lustre/llite/llite_lib.c
@@ -474,7 +474,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt)
 		set_bit(LL_SBI_FILE_SECCTX, sbi->ll_flags);
 
 	if (ll_sbi_has_encrypt(sbi) && !obd_connect_has_enc(data)) {
-		if (ll_sbi_has_test_dummy_encryption(sbi))
+		if (ll_sb_has_test_dummy_encryption(sb))
 			LCONSOLE_WARN("%s: server %s does not support encryption feature, encryption deactivated.\n",
 				      sbi->ll_fsname,
 				      sbi->ll_md_exp->exp_obd->obd_name);
@@ -571,11 +571,11 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt)
 
 	if (ll_sbi_has_encrypt(sbi) &&
 	    !obd_connect_has_enc(&sbi->ll_dt_obd->u.lov.lov_ocd)) {
-		if (ll_sbi_has_test_dummy_encryption(sbi))
+		if (ll_sb_has_test_dummy_encryption(sb))
 			LCONSOLE_WARN("%s: server %s does not support encryption feature, encryption deactivated.\n",
 				      sbi->ll_fsname, dt);
 		ll_sbi_set_encrypt(sbi, false);
-	} else if (ll_sbi_has_test_dummy_encryption(sbi)) {
+	} else if (ll_sb_has_test_dummy_encryption(sb)) {
 		LCONSOLE_WARN("Test dummy encryption mode enabled\n");
 	}
 
@@ -909,6 +909,7 @@ void ll_kill_super(struct super_block *sb)
 	{LL_SBI_VERBOSE,		"verbose"},
 	{LL_SBI_VERBOSE,		"noverbose"},
 	{LL_SBI_ALWAYS_PING,		"always_ping"},
+	{LL_SBI_TEST_DUMMY_ENCRYPTION,	"test_dummy_encryption=%s"},
 	{LL_SBI_TEST_DUMMY_ENCRYPTION,	"test_dummy_encryption"},
 	{LL_SBI_ENCRYPT,		"encrypt"},
 	{LL_SBI_ENCRYPT,		"noencrypt"},
@@ -957,6 +958,7 @@ static int ll_options(char *options, struct super_block *sb)
 {
 	struct ll_sb_info *sbi = ll_s2sbi(sb);
 	char *s2, *s1, *opts;
+	int err = 0;
 
 	if (!options)
 		return 0;
@@ -1038,7 +1040,22 @@ static int ll_options(char *options, struct super_block *sb)
 			break;
 		case LL_SBI_TEST_DUMMY_ENCRYPTION: {
 #ifdef CONFIG_FS_ENCRYPTION
-			set_bit(token, sbi->ll_flags);
+			struct lustre_sb_info *lsi = s2lsi(sb);
+
+			err = fscrypt_set_test_dummy_encryption(sb, &args[0],
+								&lsi->lsi_dummy_enc_ctx);
+			if (!err)
+				break;
+
+			if (err == -EEXIST)
+				LCONSOLE_WARN("Can't change test_dummy_encryption");
+			else if (err == -EINVAL)
+				LCONSOLE_WARN("Value of option \"%s\" unrecognized",
+					      options);
+			else
+				LCONSOLE_WARN("Error processing option \"%s\" [%d]",
+					      options, err);
+			err = -1;
 #else
 			LCONSOLE_WARN("Test dummy encryption mount option ignored: encryption not supported\n");
 #endif
@@ -1094,7 +1111,7 @@ static int ll_options(char *options, struct super_block *sb)
 		}
 	}
 	kfree(opts);
-	return 0;
+	return err;
 }
 
 void ll_lli_init(struct ll_inode_info *lli)
@@ -1369,6 +1386,7 @@ void ll_put_super(struct super_block *sb)
 	if (profilenm)
 		class_del_profile(profilenm);
 
+	fscrypt_free_dummy_context(&lsi->lsi_dummy_enc_ctx);
 	ll_free_sbi(sb);
 	lsi->lsi_llsbi = NULL;
 
@@ -3236,9 +3254,10 @@ struct md_op_data *ll_prep_md_op_data(struct md_op_data *op_data,
 			op_data->op_bias = MDS_FID_OP;
 		}
 		if (fname.disk_name.name &&
-		    fname.disk_name.name != (unsigned char *)name)
+		    fname.disk_name.name != (unsigned char *)name) {
 			/* op_data->op_name must be freed after use */
 			op_data->op_flags |= MF_OPNAME_KMALLOCED;
+		}
 	}
 
 	/* In fact LUSTRE_OPC_LOOKUP, LUSTRE_OPC_OPEN
@@ -3317,6 +3336,8 @@ int ll_show_options(struct seq_file *seq, struct dentry *dentry)
 		}
 	}
 
+	fscrypt_show_test_dummy_encryption(seq, ',', dentry->d_sb);
+
 	return 0;
 }
 
diff --git a/fs/lustre/llite/namei.c b/fs/lustre/llite/namei.c
index f7e900d..cc7b243 100644
--- a/fs/lustre/llite/namei.c
+++ b/fs/lustre/llite/namei.c
@@ -1581,7 +1581,8 @@ static int ll_new_node(struct inode *dir, struct dentry *dchild,
 	if (ll_sbi_has_encrypt(sbi) &&
 	    ((IS_ENCRYPTED(dir) &&
 	    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))) ||
-	    (unlikely(fscrypt_dummy_context_enabled(dir)) && S_ISDIR(mode)))) {
+	    (unlikely(ll_sb_has_test_dummy_encryption(dir->i_sb)) &&
+	     S_ISDIR(mode)))) {
 		err = fscrypt_get_encryption_info(dir);
 		if (err)
 			goto err_exit;
-- 
1.8.3.1

