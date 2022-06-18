Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62ABD550534
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiFRNwr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiFRNwj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:39 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEFB1DA4C
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:35 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 0C47C13D7;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 0885CE4F1D; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Lai Siyao <lai.siyao@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 09/28] lustre: llite: add option to disable Lustre inode cache
Date:   Sat, 18 Jun 2022 09:51:51 -0400
Message-Id: <1655560330-30743-10-git-send-email-jsimmons@infradead.org>
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

From: Lai Siyao <lai.siyao@whamcloud.com>

A tunable option is added to disable Lustre inode cache:
"llite.*.inode_cache=0" (default =1)

When it's turned off, ll_drop_inode() always returns 1, then
the last iput() will release inode.

WC-bug-id: https://jira.whamcloud.com/browse/LU-13970
Lustre-commit: 4aae212bb2aa980be ("LU-13970 llite: add option to disable Lustre inode cache")
Signed-off-by: Lai Siyao <lai.siyao@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/39973
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Olaf Faaland-LLNL <faaland1@llnl.gov>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/llite/llite_internal.h |  3 ++-
 fs/lustre/llite/llite_lib.c      |  1 +
 fs/lustre/llite/lproc_llite.c    | 31 +++++++++++++++++++++++++++++++
 fs/lustre/llite/super25.c        |  7 ++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/lustre/llite/llite_internal.h b/fs/lustre/llite/llite_internal.h
index b052e82..70a42d4 100644
--- a/fs/lustre/llite/llite_internal.h
+++ b/fs/lustre/llite/llite_internal.h
@@ -676,7 +676,8 @@ struct ll_sb_info {
 	unsigned int		ll_xattr_cache_enabled:1,
 				ll_xattr_cache_set:1, /* already set to 0/1 */
 				ll_client_common_fill_super_succeeded:1,
-				ll_checksum_set:1;
+				ll_checksum_set:1,
+				ll_inode_cache_enabled:1;
 
 	struct lustre_client_ocd ll_lco;
 
diff --git a/fs/lustre/llite/llite_lib.c b/fs/lustre/llite/llite_lib.c
index aaff3fa..6adbf10 100644
--- a/fs/lustre/llite/llite_lib.c
+++ b/fs/lustre/llite/llite_lib.c
@@ -445,6 +445,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt)
 	sb->s_blocksize_bits = log2(osfs->os_bsize);
 	sb->s_magic = LL_SUPER_MAGIC;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
+	sbi->ll_inode_cache_enabled = 1;
 	sbi->ll_namelen = osfs->os_namelen;
 	sbi->ll_mnt.mnt = current->fs->root.mnt;
 	sbi->ll_mnt_ns = current->nsproxy->mnt_ns;
diff --git a/fs/lustre/llite/lproc_llite.c b/fs/lustre/llite/lproc_llite.c
index ce715b4..095b696 100644
--- a/fs/lustre/llite/lproc_llite.c
+++ b/fs/lustre/llite/lproc_llite.c
@@ -1480,6 +1480,36 @@ static ssize_t opencache_max_ms_store(struct kobject *kobj,
 }
 LUSTRE_RW_ATTR(opencache_max_ms);
 
+static ssize_t inode_cache_show(struct kobject *kobj,
+				struct attribute *attr,
+				char *buf)
+{
+	struct ll_sb_info *sbi = container_of(kobj, struct ll_sb_info,
+					      ll_kset.kobj);
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", sbi->ll_inode_cache_enabled);
+}
+
+static ssize_t inode_cache_store(struct kobject *kobj,
+				 struct attribute *attr,
+				 const char *buffer,
+				 size_t count)
+{
+	struct ll_sb_info *sbi = container_of(kobj, struct ll_sb_info,
+					      ll_kset.kobj);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buffer, &val);
+	if (rc)
+		return rc;
+
+	sbi->ll_inode_cache_enabled = val;
+
+	return count;
+}
+LUSTRE_RW_ATTR(inode_cache);
+
 static int ll_unstable_stats_seq_show(struct seq_file *m, void *v)
 {
 	struct super_block *sb = m->private;
@@ -1704,6 +1734,7 @@ struct ldebugfs_vars lprocfs_llite_obd_vars[] = {
 	&lustre_attr_opencache_threshold_count.attr,
 	&lustre_attr_opencache_threshold_ms.attr,
 	&lustre_attr_opencache_max_ms.attr,
+	&lustre_attr_inode_cache.attr,
 	NULL,
 };
 
diff --git a/fs/lustre/llite/super25.c b/fs/lustre/llite/super25.c
index f50c23a..5349a25 100644
--- a/fs/lustre/llite/super25.c
+++ b/fs/lustre/llite/super25.c
@@ -74,8 +74,13 @@ static void ll_destroy_inode(struct inode *inode)
 
 static int ll_drop_inode(struct inode *inode)
 {
-	int drop = generic_drop_inode(inode);
+	struct ll_sb_info *sbi = ll_i2sbi(inode);
+	int drop;
 
+	if (!sbi->ll_inode_cache_enabled)
+		return 1;
+
+	drop = generic_drop_inode(inode);
 	if (!drop)
 		drop = fscrypt_drop_inode(inode);
 
-- 
1.8.3.1

