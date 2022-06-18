Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65FFB55055C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbiFROBN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiFRNxS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:18 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C63E6B
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:16 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 3DB9213FC;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 3A3C6DC803; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>,
        Jian Yu <yujian@whamcloud.com>
Subject: [PATCH 21/28] lustre: uapi: avoid gcc-11 -Werror=stringop-overread warning
Date:   Sat, 18 Jun 2022 09:52:03 -0400
Message-Id: <1655560330-30743-22-git-send-email-jsimmons@infradead.org>
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

GCC 11 warns about string and memory operations on fixed address:

In function 'memcpy', inlined from 'obd_uuid2str' at
lustre/include/uapi/linux/lustre/lustre_user.h:1222:3,
include/linux/fortify-string.h:20:33: error: '__builtin_memcpy'
reading 39 bytes from a region of size 0 [-Werror=stringop-overread]
  20 | #define __underlying_memcpy     __builtin_memcpy
     |                                 ^
include/linux/fortify-string.h:191:16: note:
in expansion of macro '__underlying_memcpy'
  191 |         return __underlying_memcpy(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~

The patch avoids the above warning by not using a fixed address.

WC-bug-id: https://jira.whamcloud.com/browse/LU-15220
Lustre-commit: c5fb44f5ecf8494cd ("LU-15220 tests: avoid gcc-11 -Werror=stringop-overread warning")
Signed-off-by: Jian Yu <yujian@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/45777
WC-bug-id: https://jira.whamcloud.com/browse/LU-15420
Lustre-commit: 6331eadbd60a8c58c ("LU-15420 uapi: avoid gcc-11 -Werror=stringop-overread")
Signed-off-by: James Simmons <jsimmons@infradead.org>
Reviewed-on: https://review.whamcloud.com/46319
Reviewed-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-by: Arshad Hussain <arshad.hussain@aeoncomputing.com>
Reviewed-by: Patrick Farrell <pfarrell@whamcloud.com>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
---
 include/uapi/linux/lustre/lustre_user.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/lustre/lustre_user.h b/include/uapi/linux/lustre/lustre_user.h
index ee789f2..c57929b 100644
--- a/include/uapi/linux/lustre/lustre_user.h
+++ b/include/uapi/linux/lustre/lustre_user.h
@@ -40,26 +40,27 @@
  *
  * @{
  */
+#include <linux/string.h>
+#ifndef __KERNEL__
+# define __USE_ISOC99  1
+# include <stdbool.h>
+# include <stdio.h> /* snprintf() */
+# include <sys/stat.h>
+
+# define __USE_GNU	1
+# define FILEID_LUSTRE 0x97 /* for name_to_handle_at() (and llapi_fd2fid()) */
+#endif /* !__KERNEL__ */
 
 #include <linux/fs.h>
 #include <linux/limits.h>
 #include <linux/kernel.h>
 #include <linux/stat.h>
-#include <linux/string.h>
 #include <linux/quota.h>
 #include <linux/types.h>
 #include <linux/unistd.h>
 #include <linux/lustre/lustre_fiemap.h>
 #include <linux/lustre/lustre_ver.h>
 
-#ifndef __KERNEL__
-# define __USE_ISOC99  1
-# include <stdbool.h>
-# include <stdio.h> /* snprintf() */
-# include <sys/stat.h>
-# define FILEID_LUSTRE 0x97 /* for name_to_handle_at() (and llapi_fd2fid()) */
-#endif /* __KERNEL__ */
-
 #if defined(__cplusplus)
 extern "C" {
 #endif
@@ -937,10 +938,11 @@ static inline char *obd_uuid2str(const struct obd_uuid *uuid)
 		/* Obviously not safe, but for printfs, no real harm done...
 		 * we're always null-terminated, even in a race.
 		 */
-		static char temp[sizeof(*uuid)];
+		static char temp[sizeof(*uuid->uuid)];
+
+		memcpy(temp, uuid->uuid, sizeof(*uuid->uuid) - 1);
+		temp[sizeof(*uuid->uuid) - 1] = '\0';
 
-		memcpy(temp, uuid->uuid, sizeof(*uuid) - 1);
-		temp[sizeof(*uuid) - 1] = '\0';
 		return temp;
 	}
 	return (char *)(uuid->uuid);
-- 
1.8.3.1

