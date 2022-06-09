Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CCF544C26
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245507AbiFIMeD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiFIMeA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:34:00 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E035A22B30
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:49 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 55970EFD;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 52B30D4381; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Arshad Hussain <arshad.hussain@aeoncomputing.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 14/18] lustre: quota: fallocate does not increase projectid usage
Date:   Thu,  9 Jun 2022 08:33:10 -0400
Message-Id: <1654777994-29806-15-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1654777994-29806-1-git-send-email-jsimmons@infradead.org>
References: <1654777994-29806-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Arshad Hussain <arshad.hussain@aeoncomputing.com>

fallocate() was not accounting for projectid quota usage.
This was happening due to two reasons. 1) the projectid
was not properly passed to md_op_data in ll_set_project()
and 2) the OBD_MD_FLPROJID flag was not set receive the
projctid.

This patch addresses the above reasons.

Fixes: d748d2ffa1bc ("lustre: fallocate: Implement fallocate preallocate operation")
WC-bug-id: https://jira.whamcloud.com/browse/LU-15519
Lustre-commit: 5fc934ebbbe665f24 ("LU-15519 quota: fallocate does not increase projectid usage")
Signed-off-by: Arshad Hussain <arshad.hussain@aeoncomputing.com>
Reviewed-on: https://review.whamcloud.com/46676
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Hongchao Zhang <hongchao@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/include/cl_object.h |  1 +
 fs/lustre/llite/file.c        | 18 +++++++++++-------
 fs/lustre/llite/vvp_object.c  |  3 ++-
 fs/lustre/lov/lov_io.c        |  2 ++
 fs/lustre/osc/osc_io.c        |  9 ++++++---
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/lustre/include/cl_object.h b/fs/lustre/include/cl_object.h
index b98109d..06f03b4 100644
--- a/fs/lustre/include/cl_object.h
+++ b/fs/lustre/include/cl_object.h
@@ -1889,6 +1889,7 @@ struct cl_io {
 			loff_t			sa_falloc_end;
 			uid_t			sa_falloc_uid;
 			gid_t			sa_falloc_gid;
+			u32			sa_falloc_projid;
 		} ci_setattr;
 		struct cl_data_version_io {
 			u64			dv_data_version;
diff --git a/fs/lustre/llite/file.c b/fs/lustre/llite/file.c
index 30f522b..5be77e8 100644
--- a/fs/lustre/llite/file.c
+++ b/fs/lustre/llite/file.c
@@ -2629,7 +2629,7 @@ static int ll_do_fiemap(struct inode *inode, struct fiemap *fiemap,
 			goto out;
 	}
 
-	fmkey.lfik_oa.o_valid = OBD_MD_FLID | OBD_MD_FLGROUP;
+	fmkey.lfik_oa.o_valid = OBD_MD_FLID | OBD_MD_FLGROUP | OBD_MD_FLPROJID;
 	obdo_from_inode(&fmkey.lfik_oa, inode, OBD_MD_FLSIZE);
 	obdo_set_parent_fid(&fmkey.lfik_oa, &ll_i2info(inode)->lli_fid);
 
@@ -3412,10 +3412,12 @@ static int ll_set_project(struct inode *inode, u32 xflags, u32 projid)
 	op_data->op_attr_flags = ll_inode_to_ext_flags(inode_flags);
 	if (xflags & FS_XFLAG_PROJINHERIT)
 		op_data->op_attr_flags |= LUSTRE_PROJINHERIT_FL;
+
+	/* pass projid to md_op_data */
 	op_data->op_projid = projid;
-	op_data->op_xvalid |= OP_XVALID_PROJID;
-	rc = md_setattr(ll_i2sbi(inode)->ll_md_exp, op_data, NULL,
-			0, &req);
+
+	op_data->op_xvalid |= OP_XVALID_PROJID | OP_XVALID_FLAGS;
+	rc = md_setattr(ll_i2sbi(inode)->ll_md_exp, op_data, NULL, 0, &req);
 	ptlrpc_req_finished(req);
 	if (rc)
 		goto out_fsxattr;
@@ -5262,11 +5264,11 @@ int ll_getattr(const struct path *path, struct kstat *stat,
 int cl_falloc(struct file *file, struct inode *inode, int mode, loff_t offset,
 	      loff_t len)
 {
+	loff_t size = i_size_read(inode);
 	struct lu_env *env;
 	struct cl_io *io;
 	u16 refcheck;
 	int rc;
-	loff_t size = i_size_read(inode);
 
 	env = cl_env_get(&refcheck);
 	if (IS_ERR(env))
@@ -5283,12 +5285,14 @@ int cl_falloc(struct file *file, struct inode *inode, int mode, loff_t offset,
 	io->u.ci_setattr.sa_falloc_end = offset + len;
 	io->u.ci_setattr.sa_subtype = CL_SETATTR_FALLOCATE;
 
-	CDEBUG(D_INODE, "UID %u GID %u\n",
+	CDEBUG(D_INODE, "UID %u GID %u PRJID %u\n",
 	       from_kuid(&init_user_ns, inode->i_uid),
-	       from_kgid(&init_user_ns, inode->i_gid));
+	       from_kgid(&init_user_ns, inode->i_gid),
+	       ll_i2info(inode)->lli_projid);
 
 	io->u.ci_setattr.sa_falloc_uid = from_kuid(&init_user_ns, inode->i_uid);
 	io->u.ci_setattr.sa_falloc_gid = from_kgid(&init_user_ns, inode->i_gid);
+	io->u.ci_setattr.sa_falloc_projid = ll_i2info(inode)->lli_projid;
 
 	if (io->u.ci_setattr.sa_falloc_end > size) {
 		loff_t newsize = io->u.ci_setattr.sa_falloc_end;
diff --git a/fs/lustre/llite/vvp_object.c b/fs/lustre/llite/vvp_object.c
index 8a53458..64ecdb9 100644
--- a/fs/lustre/llite/vvp_object.c
+++ b/fs/lustre/llite/vvp_object.c
@@ -190,7 +190,8 @@ static int vvp_object_glimpse(const struct lu_env *env,
 static void vvp_req_attr_set(const struct lu_env *env, struct cl_object *obj,
 			     struct cl_req_attr *attr)
 {
-	u64 valid_flags = OBD_MD_FLTYPE | OBD_MD_FLUID | OBD_MD_FLGID;
+	u64 valid_flags = OBD_MD_FLTYPE | OBD_MD_FLUID | OBD_MD_FLGID |
+			  OBD_MD_FLPROJID;
 	struct inode *inode;
 	struct obdo *oa;
 
diff --git a/fs/lustre/lov/lov_io.c b/fs/lustre/lov/lov_io.c
index 38dacd35..b535092 100644
--- a/fs/lustre/lov/lov_io.c
+++ b/fs/lustre/lov/lov_io.c
@@ -685,6 +685,8 @@ static void lov_io_sub_inherit(struct lov_io_sub *sub, struct lov_io *lio,
 				parent->u.ci_setattr.sa_falloc_uid;
 			io->u.ci_setattr.sa_falloc_gid =
 				parent->u.ci_setattr.sa_falloc_gid;
+			io->u.ci_setattr.sa_falloc_projid =
+				parent->u.ci_setattr.sa_falloc_projid;
 		}
 		if (cl_io_is_trunc(io)) {
 			loff_t new_size = parent->u.ci_setattr.sa_attr.lvb_size;
diff --git a/fs/lustre/osc/osc_io.c b/fs/lustre/osc/osc_io.c
index db91bf2..1361d7f 100644
--- a/fs/lustre/osc/osc_io.c
+++ b/fs/lustre/osc/osc_io.c
@@ -671,11 +671,14 @@ static int osc_io_setattr_start(const struct lu_env *env,
 			oa->o_blocks = io->u.ci_setattr.sa_falloc_end;
 			oa->o_uid = io->u.ci_setattr.sa_falloc_uid;
 			oa->o_gid = io->u.ci_setattr.sa_falloc_gid;
+			oa->o_projid = io->u.ci_setattr.sa_falloc_projid;
 			oa->o_valid |= OBD_MD_FLSIZE | OBD_MD_FLBLOCKS |
-				OBD_MD_FLUID | OBD_MD_FLGID;
+				OBD_MD_FLUID | OBD_MD_FLGID | OBD_MD_FLPROJID;
 
-			CDEBUG(D_INODE, "size %llu blocks %llu uid %u gid %u\n",
-			       oa->o_size, oa->o_blocks, oa->o_uid, oa->o_gid);
+			CDEBUG(D_INODE,
+			       "size %llu blocks %llu uid %u gid %u prjid %u\n",
+			       oa->o_size, oa->o_blocks, oa->o_uid, oa->o_gid,
+			       oa->o_projid);
 			result = osc_fallocate_base(osc_export(cl2osc(obj)),
 						    oa, osc_async_upcall,
 						    cbargs, falloc_mode);
-- 
1.8.3.1

