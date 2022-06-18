Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA5A550552
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbiFROAu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiFRNxP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:15 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1CD6430
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:13 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 39B3313FB;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 35524FD3BF; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 20/28] lnet: libcfs: add "default" keyword for debug mask
Date:   Sat, 18 Jun 2022 09:52:02 -0400
Message-Id: <1655560330-30743-21-git-send-email-jsimmons@infradead.org>
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

From: Andreas Dilger <adilger@whamcloud.com>

Allow "lctl set_param debug=default" to reset the debug mask to
the default value.  This is useful if the debug needs to be set
to a higher value temporarily, but should be easily reset back
to the original value afterward.

WC-bug-id: https://jira.whamcloud.com/browse/LU-9859
Lustre-commit: 4c9a5762413638cc6 ("LU-9859 libcfs: add "default" keyword for debug mask")
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/46251
Reviewed-by: Jian Yu <yujian@whamcloud.com>
Reviewed-by: Arshad Hussain <arshad.hussain@aeoncomputing.com>
Reviewed-by: Neil Brown <neilb@suse.de>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/libcfs/libcfs_string.h   |   3 +-
 include/uapi/linux/lnet/libcfs_debug.h | 129 +++++++++++++++++----------------
 net/lnet/libcfs/debug.c                |  11 ++-
 net/lnet/libcfs/libcfs_string.c        |  11 ++-
 4 files changed, 85 insertions(+), 69 deletions(-)

diff --git a/include/linux/libcfs/libcfs_string.h b/include/linux/libcfs/libcfs_string.h
index e2b6d72..a8bd44d 100644
--- a/include/linux/libcfs/libcfs_string.h
+++ b/include/linux/libcfs/libcfs_string.h
@@ -44,7 +44,8 @@
 /* libcfs_string.c */
 /* Convert a text string to a bitmask */
 int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
-		 int *oldmask, int minmask, int allmask);
+		 int *oldmask, int minmask, int allmask, int defmask);
+
 /* trim leading and trailing space characters */
 char *cfs_firststr(char *str, size_t size);
 
diff --git a/include/uapi/linux/lnet/libcfs_debug.h b/include/uapi/linux/lnet/libcfs_debug.h
index bbd9f25..ba87912 100644
--- a/include/uapi/linux/lnet/libcfs_debug.h
+++ b/include/uapi/linux/lnet/libcfs_debug.h
@@ -62,38 +62,41 @@ struct ptldebug_header {
 #define PH_FLAG_FIRST_RECORD	1
 
 /* Debugging subsystems (32 bits, non-overlapping) */
-#define S_UNDEFINED	0x00000001
-#define S_MDC		0x00000002
-#define S_MDS		0x00000004
-#define S_OSC		0x00000008
-#define S_OST		0x00000010
-#define S_CLASS		0x00000020
-#define S_LOG		0x00000040
-#define S_LLITE		0x00000080
-#define S_RPC		0x00000100
-#define S_MGMT		0x00000200
-#define S_LNET		0x00000400
-#define S_LND		0x00000800 /* ALL LNDs */
-#define S_PINGER	0x00001000
-#define S_FILTER	0x00002000
-#define S_LIBCFS	0x00004000
-#define S_ECHO		0x00008000
-#define S_LDLM		0x00010000
-#define S_LOV		0x00020000
-#define S_LQUOTA	0x00040000
-#define S_OSD		0x00080000
-#define S_LFSCK		0x00100000
-#define S_SNAPSHOT	0x00200000
+enum libcfs_debug_subsys {
+	S_UNDEFINED	= 0x00000001,
+	S_MDC		= 0x00000002,
+	S_MDS		= 0x00000004,
+	S_OSC		= 0x00000008,
+	S_OST		= 0x00000010,
+	S_CLASS		= 0x00000020,
+	S_LOG		= 0x00000040,
+	S_LLITE		= 0x00000080,
+	S_RPC		= 0x00000100,
+	S_MGMT		= 0x00000200,
+	S_LNET		= 0x00000400,
+	S_LND		= 0x00000800, /* ALL LNDs */
+	S_PINGER	= 0x00001000,
+	S_FILTER	= 0x00002000,
+	S_LIBCFS	= 0x00004000,
+	S_ECHO		= 0x00008000,
+	S_LDLM		= 0x00010000,
+	S_LOV		= 0x00020000,
+	S_LQUOTA	= 0x00040000,
+	S_OSD		= 0x00080000,
+	S_LFSCK		= 0x00100000,
+	S_SNAPSHOT	= 0x00200000,
 /* unused */
-#define S_LMV		0x00800000 /* b_new_cmd */
+	S_LMV		= 0x00800000,
 /* unused */
-#define S_SEC		0x02000000 /* upcall cache */
-#define S_GSS		0x04000000 /* b_new_cmd */
+	S_SEC		= 0x02000000, /* upcall cache */
+	S_GSS		= 0x04000000,
 /* unused */
-#define S_MGC		0x10000000
-#define S_MGS		0x20000000
-#define S_FID		0x40000000 /* b_new_cmd */
-#define S_FLD		0x80000000 /* b_new_cmd */
+	S_MGC		= 0x10000000,
+	S_MGS		= 0x20000000,
+	S_FID		= 0x40000000,
+	S_FLD		= 0x80000000,
+};
+#define LIBCFS_S_DEFAULT (~0)
 
 #define LIBCFS_DEBUG_SUBSYS_NAMES {					\
 	"undefined", "mdc", "mds", "osc", "ost", "class", "log",	\
@@ -103,38 +106,42 @@ struct ptldebug_header {
 	"fid", "fld", NULL }
 
 /* Debugging masks (32 bits, non-overlapping) */
-#define D_TRACE		0x00000001 /* ENTRY/EXIT markers */
-#define D_INODE		0x00000002
-#define D_SUPER		0x00000004
-#define D_IOTRACE	0x00000008 /* simple, low overhead io tracing */
-#define D_MALLOC	0x00000010 /* print malloc, free information */
-#define D_CACHE		0x00000020 /* cache-related items */
-#define D_INFO		0x00000040 /* general information */
-#define D_IOCTL		0x00000080 /* ioctl related information */
-#define D_NETERROR	0x00000100 /* network errors */
-#define D_NET		0x00000200 /* network communications */
-#define D_WARNING	0x00000400 /* CWARN(...) == CDEBUG (D_WARNING, ...) */
-#define D_BUFFS		0x00000800
-#define D_OTHER		0x00001000
-#define D_DENTRY	0x00002000
-#define D_NETTRACE	0x00004000
-#define D_PAGE		0x00008000 /* bulk page handling */
-#define D_DLMTRACE	0x00010000
-#define D_ERROR		0x00020000 /* CERROR(...) == CDEBUG (D_ERROR, ...) */
-#define D_EMERG		0x00040000 /* CEMERG(...) == CDEBUG (D_EMERG, ...) */
-#define D_HA		0x00080000 /* recovery and failover */
-#define D_RPCTRACE	0x00100000 /* for distributed debugging */
-#define D_VFSTRACE	0x00200000
-#define D_READA		0x00400000 /* read-ahead */
-#define D_MMAP		0x00800000
-#define D_CONFIG	0x01000000
-#define D_CONSOLE	0x02000000
-#define D_QUOTA		0x04000000
-#define D_SEC		0x08000000
-#define D_LFSCK		0x10000000 /* For both OI scrub and LFSCK */
-#define D_HSM		0x20000000
-#define D_SNAPSHOT	0x40000000 /* snapshot */
-#define D_LAYOUT	0x80000000
+enum libcfs_debug_masks {
+	D_TRACE		= 0x00000001, /* ENTRY/EXIT markers */
+	D_INODE		= 0x00000002,
+	D_SUPER		= 0x00000004,
+	D_IOTRACE	= 0x00000008, /* simple, low overhead io tracing */
+	D_MALLOC	= 0x00000010, /* print malloc, free information */
+	D_CACHE		= 0x00000020, /* cache-related items */
+	D_INFO		= 0x00000040, /* general information */
+	D_IOCTL		= 0x00000080, /* ioctl related information */
+	D_NETERROR	= 0x00000100, /* network errors */
+	D_NET		= 0x00000200, /* network communications */
+	D_WARNING	= 0x00000400, /* CWARN(...) == CDEBUG(D_WARNING, ...) */
+	D_BUFFS		= 0x00000800,
+	D_OTHER		= 0x00001000,
+	D_DENTRY	= 0x00002000,
+	D_NETTRACE	= 0x00004000,
+	D_PAGE		= 0x00008000, /* bulk page handling */
+	D_DLMTRACE	= 0x00010000,
+	D_ERROR		= 0x00020000, /* CERROR(...) == CDEBUG(D_ERROR, ...) */
+	D_EMERG		= 0x00040000, /* CEMERG(...) == CDEBUG(D_EMERG, ...) */
+	D_HA		= 0x00080000, /* recovery and failover */
+	D_RPCTRACE	= 0x00100000, /* for distributed debugging */
+	D_VFSTRACE	= 0x00200000,
+	D_READA		= 0x00400000, /* read-ahead */
+	D_MMAP		= 0x00800000,
+	D_CONFIG	= 0x01000000,
+	D_CONSOLE	= 0x02000000,
+	D_QUOTA		= 0x04000000,
+	D_SEC		= 0x08000000,
+	D_LFSCK		= 0x10000000, /* For both OI scrub and LFSCK */
+	D_HSM		= 0x20000000,
+	D_SNAPSHOT	= 0x40000000,
+	D_LAYOUT	= 0x80000000,
+};
+#define LIBCFS_D_DEFAULT (D_CANTMASK | D_NETERROR | D_HA | D_CONFIG | D_IOCTL |\
+			  D_LFSCK)
 
 #define LIBCFS_DEBUG_MASKS_NAMES {					\
 	"trace", "inode", "super", "iotrace", "malloc", "cache", "info",\
diff --git a/net/lnet/libcfs/debug.c b/net/lnet/libcfs/debug.c
index 1bb382d..f8ff5f7 100644
--- a/net/lnet/libcfs/debug.c
+++ b/net/lnet/libcfs/debug.c
@@ -47,13 +47,12 @@
 
 static char debug_file_name[1024];
 
-unsigned int libcfs_subsystem_debug = ~0;
+unsigned int libcfs_subsystem_debug = LIBCFS_S_DEFAULT;
 EXPORT_SYMBOL(libcfs_subsystem_debug);
 module_param(libcfs_subsystem_debug, int, 0644);
 MODULE_PARM_DESC(libcfs_subsystem_debug, "Lustre kernel debug subsystem mask");
 
-unsigned int libcfs_debug = (D_CANTMASK |
-			     D_NETERROR | D_HA | D_CONFIG | D_IOCTL);
+unsigned int libcfs_debug = LIBCFS_D_DEFAULT;
 EXPORT_SYMBOL(libcfs_debug);
 module_param(libcfs_debug, int, 0644);
 MODULE_PARM_DESC(libcfs_debug, "Lustre kernel debug mask");
@@ -236,7 +235,7 @@ static int param_set_uintpos(const char *val, const struct kernel_param *kp)
 /* libcfs_debug_token2mask() expects the returned string in lower-case */
 static const char *libcfs_debug_subsys2str(int subsys)
 {
-	static const char * const libcfs_debug_subsystems[] =
+	static const char *const libcfs_debug_subsystems[] =
 		LIBCFS_DEBUG_SUBSYS_NAMES;
 
 	if (subsys >= ARRAY_SIZE(libcfs_debug_subsystems))
@@ -328,8 +327,8 @@ static const char *libcfs_debug_dbg2str(int debug)
 		return 0;
 	}
 
-	return cfs_str2mask(str, fn, mask, is_subsys ? 0 : D_CANTMASK,
-			    0xffffffff);
+	return cfs_str2mask(str, fn, mask, is_subsys ? 0 : D_CANTMASK, ~0,
+			    is_subsys ? LIBCFS_S_DEFAULT : LIBCFS_D_DEFAULT);
 }
 
 char lnet_debug_log_upcall[1024] = "/usr/lib/lustre/lnet_debug_log_upcall";
diff --git a/net/lnet/libcfs/libcfs_string.c b/net/lnet/libcfs/libcfs_string.c
index 0563c42..672b859 100644
--- a/net/lnet/libcfs/libcfs_string.c
+++ b/net/lnet/libcfs/libcfs_string.c
@@ -46,7 +46,7 @@
 
 /* Convert a text string to a bitmask */
 int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
-		 int *oldmask, int minmask, int allmask)
+		 int *oldmask, int minmask, int allmask, int defmask)
 {
 	const char *debugstr;
 	char op = '\0';
@@ -102,6 +102,15 @@ int cfs_str2mask(const char *str, const char *(*bit2str)(int bit),
 				newmask = allmask;
 			found = 1;
 		}
+		if (!found && strcasecmp(str, "DEFAULT") == 0) {
+			if (op == '-')
+				newmask = (newmask & ~defmask) | minmask;
+			else if (op == '+')
+				newmask |= defmask;
+			else
+				newmask = defmask;
+			found = 1;
+		}
 		if (!found) {
 			CWARN("unknown mask '%.*s'.\n"
 			      "mask usage: [+|-]<all|type> ...\n", len, str);
-- 
1.8.3.1

