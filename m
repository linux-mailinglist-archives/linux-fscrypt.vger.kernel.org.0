Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D13550558
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350572AbiFROAx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236772AbiFRNxc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:32 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A5D13D21
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:27 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 5ADDD1E8B;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 55ABDE9152; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Chris Horn <chris.horn@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 27/28] lnet: libcfs: libcfs_debug_mb set incorrectly on init
Date:   Sat, 18 Jun 2022 09:52:09 -0400
Message-Id: <1655560330-30743-28-git-send-email-jsimmons@infradead.org>
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

From: Chris Horn <chris.horn@hpe.com>

If libcfs_debug_mb parameter is specified to insmod (i.e. set before
module is initialized) then it does not get initialized correctly.

libcfs_param_debug_mb_set() expects cfs_trace_get_debug_mb() to return
zero if the module has not been initialized yet, but
cfs_trace_get_debug_mb() will return 1 in this case. Modify
cfs_trace_get_debug_mb() to return zero as expected. A related issue
is that in this case we need to call cfs_trace_get_debug_mb() after
cfs_tracefile_init() so that libcfs_debug_mb gets the same value it
would get if we had set it after module init.

When libcfs_debug_mb is specified to insmod, libcfs_debug_init()
divides its value by num_possible_cpus(), but this is already done in
libcfs_param_debug_mb_set().

Fixes: 205b154f3b ("lustre: always range-check libcfs_debug_mb setting.")
HPE-bug-id: LUS-10839
WC-bug-id: https://jira.whamcloud.com/browse/LU-15689
Lustre-commit: d38ef181d8250b083 ("LU-15689 libcfs: libcfs_debug_mb set incorrectly on init")
Signed-off-by: Chris Horn <chris.horn@hpe.com>
Reviewed-on: https://review.whamcloud.com/46925
Reviewed-by: Neil Brown <neilb@suse.de>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/libcfs/debug.c     | 9 +++------
 net/lnet/libcfs/tracefile.c | 5 ++++-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/lnet/libcfs/debug.c b/net/lnet/libcfs/debug.c
index f8ff5f7..c00e6da 100644
--- a/net/lnet/libcfs/debug.c
+++ b/net/lnet/libcfs/debug.c
@@ -544,12 +544,10 @@ int libcfs_debug_init(unsigned long bufsize)
 	/* If libcfs_debug_mb is uninitialized then just make the
 	 * total buffers smp_num_cpus * TCD_MAX_PAGES
 	 */
-	if (max < num_possible_cpus()) {
+	if (max < num_possible_cpus())
 		max = TCD_MAX_PAGES;
-	} else {
-		max = max / num_possible_cpus();
+	else
 		max <<= (20 - PAGE_SHIFT);
-	}
 
 	rc = cfs_tracefile_init(max);
 	if (rc)
@@ -557,8 +555,7 @@ int libcfs_debug_init(unsigned long bufsize)
 
 	libcfs_register_panic_notifier();
 	kernel_param_lock(THIS_MODULE);
-	if (libcfs_debug_mb == 0)
-		libcfs_debug_mb = cfs_trace_get_debug_mb();
+	libcfs_debug_mb = cfs_trace_get_debug_mb();
 	kernel_param_unlock(THIS_MODULE);
 	return rc;
 }
diff --git a/net/lnet/libcfs/tracefile.c b/net/lnet/libcfs/tracefile.c
index 948eaaa..f0b7a2e 100644
--- a/net/lnet/libcfs/tracefile.c
+++ b/net/lnet/libcfs/tracefile.c
@@ -1000,7 +1000,10 @@ int cfs_trace_get_debug_mb(void)
 
 	up_read(&cfs_tracefile_sem);
 
-	return (total_pages >> (20 - PAGE_SHIFT)) + 1;
+	if (total_pages)
+		return (total_pages >> (20 - PAGE_SHIFT)) + 1;
+	else
+		return 0;
 }
 
 static int tracefiled(void *arg)
-- 
1.8.3.1

