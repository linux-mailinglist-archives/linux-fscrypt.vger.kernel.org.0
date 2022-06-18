Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DCA550550
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiFROAt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiFRNxJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:09 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE29639D
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:09 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 3010513F9;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 2DCA1E4F1D; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Patrick Farrell <pfarrell@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 18/28] lustre: llite: Add COMPLETED iotrace messages
Date:   Sat, 18 Jun 2022 09:52:00 -0400
Message-Id: <1655560330-30743-19-git-send-email-jsimmons@infradead.org>
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

From: Patrick Farrell <pfarrell@whamcloud.com>

It's very useful to see how long an I/O call took.  There
are other ways to do this, but the goal is for iotrace to
provide all necessary information for basic I/O performance
analysis, so we add COMPLETED messages to iotrace.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15317
Lustre-commit: d48b10cef36d74cc6 ("LU-15317 llite: Add COMPLETED iotrace messages")
Signed-off-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/46484
Reviewed-by: Sebastien Buisson <sbuisson@ddn.com>
Reviewed-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 fs/lustre/llite/file.c       | 12 ++++++++++++
 fs/lustre/llite/llite_mmap.c | 12 +++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/fs/lustre/llite/file.c b/fs/lustre/llite/file.c
index 5be77e8..efe117d 100644
--- a/fs/lustre/llite/file.c
+++ b/fs/lustre/llite/file.c
@@ -2013,6 +2013,12 @@ static ssize_t ll_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 				   ktime_us_delta(ktime_get(), kstart));
 	}
 
+	CDEBUG(D_IOTRACE,
+	       "COMPLETED: file %s:"DFID", ppos: %lld, count: %zu\n",
+	       file_dentry(file)->d_name.name,
+	       PFID(ll_inode2fid(file_inode(file))), iocb->ki_pos,
+	       iov_iter_count(to));
+
 	return result;
 }
 
@@ -2158,6 +2164,12 @@ static ssize_t ll_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 				   ktime_us_delta(ktime_get(), kstart));
 	}
 
+	CDEBUG(D_IOTRACE,
+	       "COMPLETED: file %s:"DFID", ppos: %lld, count: %zu\n",
+	       file_dentry(file)->d_name.name,
+	       PFID(ll_inode2fid(file_inode(file))), iocb->ki_pos,
+	       iov_iter_count(from));
+
 	return rc_normal;
 }
 
diff --git a/fs/lustre/llite/llite_mmap.c b/fs/lustre/llite/llite_mmap.c
index 2e762b1..4acc7ee 100644
--- a/fs/lustre/llite/llite_mmap.c
+++ b/fs/lustre/llite/llite_mmap.c
@@ -415,7 +415,7 @@ static vm_fault_t ll_fault(struct vm_fault *vmf)
 			goto restart;
 		}
 
-		result = VM_FAULT_LOCKED;
+		result |= VM_FAULT_LOCKED;
 	}
 	sigprocmask(SIG_SETMASK, &old, NULL);
 
@@ -430,6 +430,11 @@ static vm_fault_t ll_fault(struct vm_fault *vmf)
 				   ktime_us_delta(ktime_get(), kstart));
 	}
 
+	CDEBUG(D_IOTRACE,
+	       "COMPLETED: "DFID": vma=%p start=%#lx end=%#lx vm_flags=%#lx idx=%lu\n",
+	       PFID(&ll_i2info(file_inode(vma->vm_file))->lli_fid),
+	       vma, vma->vm_start, vma->vm_end, vma->vm_flags, vmf->pgoff);
+
 	return result;
 }
 
@@ -498,6 +503,11 @@ static vm_fault_t ll_page_mkwrite(struct vm_fault *vmf)
 				   ktime_us_delta(ktime_get(), kstart));
 	}
 
+	CDEBUG(D_IOTRACE,
+	       "COMPLETED: "DFID": vma=%p start=%#lx end=%#lx vm_flags=%#lx idx=%lu\n",
+	       PFID(&ll_i2info(file_inode(vma->vm_file))->lli_fid),
+	       vma, vma->vm_start, vma->vm_end, vma->vm_flags,
+	       vmf->page->index);
 	return ret;
 }
 
-- 
1.8.3.1

