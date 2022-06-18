Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 648AA55052D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiFRNwk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiFRNwY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:24 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205691D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:22 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id EF59813C5;
        Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id DFAF7E9152; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 02/28] lustre: llite: switch from ->mmap_sem to mmap_lock()
Date:   Sat, 18 Jun 2022 09:51:44 -0400
Message-Id: <1655560330-30743-3-git-send-email-jsimmons@infradead.org>
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

From: Mr NeilBrown <neilb@suse.de>

In Linux 5.8, ->mmap_sem is gone and the preferred interface
for locking the mmap is to suite of mmap*lock() functions.

WC-bug-id: https://jira.whamcloud.com/browse/LU-13783
Lustre-commit: 5309e108582c692f ("LU-13783 libcfs: switch from ->mmap_sem to mmap_lock()")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/40288
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/llite/llite_internal.h | 12 ++++++------
 fs/lustre/llite/llite_mmap.c     |  8 ++++----
 fs/lustre/llite/pcc.c            |  6 +++---
 fs/lustre/llite/vvp_io.c         |  4 ++--
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/lustre/llite/llite_internal.h b/fs/lustre/llite/llite_internal.h
index bc50169..426c797 100644
--- a/fs/lustre/llite/llite_internal.h
+++ b/fs/lustre/llite/llite_internal.h
@@ -299,11 +299,11 @@ static inline void ll_trunc_sem_init(struct ll_trunc_sem *sem)
  *
  * We must take lli_trunc_sem in read mode on entry in to various i/o paths
  * in Lustre, in order to exclude truncates.  Some of these paths then need to
- * take the mmap_sem, while still holding the trunc_sem.  The problem is that
- * page faults hold the mmap_sem when calling in to Lustre, and then must also
+ * take the mmap_lock, while still holding the trunc_sem.  The problem is that
+ * page faults hold the mmap_lock when calling in to Lustre, and then must also
  * take the trunc_sem to exclude truncate.
  *
- * This means the locking order for trunc_sem and mmap_sem is sometimes AB,
+ * This means the locking order for trunc_sem and mmap_lock is sometimes AB,
  * sometimes BA.  This is almost OK because in both cases, we take the trunc
  * sem for read, so it doesn't block.
  *
@@ -313,9 +313,9 @@ static inline void ll_trunc_sem_init(struct ll_trunc_sem *sem)
  *
  * So we have, on our truncate sem, in order (where 'reader' and 'writer' refer
  * to the mode in which they take the semaphore):
- * reader (holding mmap_sem, needs truncate_sem)
+ * reader (holding mmap_lock, needs truncate_sem)
  * writer
- * reader (holding truncate sem, waiting for mmap_sem)
+ * reader (holding truncate sem, waiting for mmap_lock)
  *
  * And so the readers deadlock.
  *
@@ -325,7 +325,7 @@ static inline void ll_trunc_sem_init(struct ll_trunc_sem *sem)
  * of the order they arrived in.
  *
  * down_read_nowait is only used in the page fault case, where we already hold
- * the mmap_sem.  This is because otherwise repeated read and write operations
+ * the mmap_lock.  This is because otherwise repeated read and write operations
  * (which take the truncate sem) could prevent a truncate from ever starting.
  * This could still happen with page faults, but without an even more complex
  * mechanism, this is unavoidable.
diff --git a/fs/lustre/llite/llite_mmap.c b/fs/lustre/llite/llite_mmap.c
index d87a68d..2e762b1 100644
--- a/fs/lustre/llite/llite_mmap.c
+++ b/fs/lustre/llite/llite_mmap.c
@@ -63,8 +63,8 @@ struct vm_area_struct *our_vma(struct mm_struct *mm, unsigned long addr,
 {
 	struct vm_area_struct *vma, *ret = NULL;
 
-	/* mmap_sem must have been held by caller. */
-	LASSERT(!down_write_trylock(&mm->mmap_sem));
+	/* mmap_lock must have been held by caller. */
+	LASSERT(!mmap_write_trylock(mm));
 
 	for (vma = find_vma(mm, addr);
 	    vma && vma->vm_start < (addr + count); vma = vma->vm_next) {
@@ -288,11 +288,11 @@ static vm_fault_t __ll_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		bool allow_retry = vmf->flags & FAULT_FLAG_ALLOW_RETRY;
 		bool has_retry = vmf->flags & FAULT_FLAG_RETRY_NOWAIT;
 
-		/* To avoid loops, instruct downstream to not drop mmap_sem */
+		/* To avoid loops, instruct downstream to not drop mmap_lock */
 		/**
 		 * only need FAULT_FLAG_ALLOW_RETRY prior to Linux 5.1
 		 * (6b4c9f4469819), where FAULT_FLAG_RETRY_NOWAIT is enough
-		 * to not drop mmap_sem when failed to lock the page.
+		 * to not drop mmap_lock when failed to lock the page.
 		 */
 		vmf->flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT;
 		ll_cl_add(inode, env, NULL, LCC_MMAP);
diff --git a/fs/lustre/llite/pcc.c b/fs/lustre/llite/pcc.c
index 8bdf681e..ec35061 100644
--- a/fs/lustre/llite/pcc.c
+++ b/fs/lustre/llite/pcc.c
@@ -1906,7 +1906,7 @@ vm_fault_t pcc_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		       "%s: PCC backend fs not support ->page_mkwrite()\n",
 		       ll_i2sbi(inode)->ll_fsname);
 		pcc_ioctl_detach(inode, PCC_DETACH_OPT_UNCACHE);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		*cached = true;
 		return VM_FAULT_RETRY | VM_FAULT_NOPAGE;
 	}
@@ -1933,7 +1933,7 @@ vm_fault_t pcc_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 		 */
 		if (page->mapping == pcc_file->f_mapping) {
 			*cached = true;
-			up_read(&mm->mmap_sem);
+			mmap_read_unlock(mm);
 			return VM_FAULT_RETRY | VM_FAULT_NOPAGE;
 		}
 
@@ -1947,7 +1947,7 @@ vm_fault_t pcc_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (OBD_FAIL_CHECK(OBD_FAIL_LLITE_PCC_DETACH_MKWRITE)) {
 		pcc_io_fini(inode);
 		pcc_ioctl_detach(inode, PCC_DETACH_OPT_UNCACHE);
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		return VM_FAULT_RETRY | VM_FAULT_NOPAGE;
 	}
 
diff --git a/fs/lustre/llite/vvp_io.c b/fs/lustre/llite/vvp_io.c
index 77e54ce..75c5224 100644
--- a/fs/lustre/llite/vvp_io.c
+++ b/fs/lustre/llite/vvp_io.c
@@ -462,7 +462,7 @@ static int vvp_mmap_locks(const struct lu_env *env,
 		count += addr & (~PAGE_MASK);
 		addr &= PAGE_MASK;
 
-		down_read(&mm->mmap_sem);
+		mmap_read_lock(mm);
 		while ((vma = our_vma(mm, addr, count)) != NULL) {
 			struct inode *inode = file_inode(vma->vm_file);
 			int flags = CEF_MUST;
@@ -503,7 +503,7 @@ static int vvp_mmap_locks(const struct lu_env *env,
 			count -= vma->vm_end - addr;
 			addr = vma->vm_end;
 		}
-		up_read(&mm->mmap_sem);
+		mmap_read_unlock(mm);
 		if (result < 0)
 			break;
 	}
-- 
1.8.3.1

