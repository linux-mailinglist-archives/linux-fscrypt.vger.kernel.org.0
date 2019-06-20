Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A32354DC1E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbfFTUxo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 16:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbfFTUxo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 16:53:44 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 968282089C;
        Thu, 20 Jun 2019 20:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561064023;
        bh=5T65MwH08DPCQR6AObb40wwVpBHDVj+BLg+tgX4K7ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VF2JxW+yrfzNIJ9WQum6NE7V2kVI3P9PKRHrhzmP43p8kkhwFKNPM7MZixWk2R0cm
         sjMMr5WQHxJ84SDZ7ya86snh+CgGbfvxc5wYpGldJ44IIocdbrtIG3+uWZ65G9ZCRA
         xArxpSPxlphQbgJifhhk8HIlAv+Jn9G5T1xvyop4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-integrity@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v5 03/16] fs-verity: add UAPI header
Date:   Thu, 20 Jun 2019 13:50:30 -0700
Message-Id: <20190620205043.64350-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620205043.64350-1-ebiggers@kernel.org>
References: <20190620205043.64350-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add the UAPI header for fs-verity, including two ioctls:

- FS_IOC_ENABLE_VERITY
- FS_IOC_MEASURE_VERITY

These ioctls are documented in the "User API" section of
Documentation/filesystems/fsverity.rst.

Examples of using these ioctls can be found in fsverity-utils
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git).

I've also written xfstests that test these ioctls
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfstests-dev.git/log/?h=fsverity).

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/ioctl/ioctl-number.txt |  1 +
 include/uapi/linux/fsverity.h        | 39 ++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)
 create mode 100644 include/uapi/linux/fsverity.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index c9558146ac5896..21767c81e86d58 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -225,6 +225,7 @@ Code  Seq#(hex)	Include File		Comments
 'f'	00-0F	fs/ext4/ext4.h		conflict!
 'f'	00-0F	linux/fs.h		conflict!
 'f'	00-0F	fs/ocfs2/ocfs2_fs.h	conflict!
+'f'	81-8F	linux/fsverity.h
 'g'	00-0F	linux/usb/gadgetfs.h
 'g'	20-2F	linux/usb/g_printer.h
 'h'	00-7F				conflict! Charon filesystem
diff --git a/include/uapi/linux/fsverity.h b/include/uapi/linux/fsverity.h
new file mode 100644
index 00000000000000..57d1d7fc0c345a
--- /dev/null
+++ b/include/uapi/linux/fsverity.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * fs-verity user API
+ *
+ * These ioctls can be used on filesystems that support fs-verity.  See the
+ * "User API" section of Documentation/filesystems/fsverity.rst.
+ *
+ * Copyright 2019 Google LLC
+ */
+#ifndef _UAPI_LINUX_FSVERITY_H
+#define _UAPI_LINUX_FSVERITY_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define FS_VERITY_HASH_ALG_SHA256	1
+
+struct fsverity_enable_arg {
+	__u32 version;
+	__u32 hash_algorithm;
+	__u32 block_size;
+	__u32 salt_size;
+	__u64 salt_ptr;
+	__u32 sig_size;
+	__u32 __reserved1;
+	__u64 sig_ptr;
+	__u64 __reserved2[11];
+};
+
+struct fsverity_digest {
+	__u16 digest_algorithm;
+	__u16 digest_size; /* input/output */
+	__u8 digest[];
+};
+
+#define FS_IOC_ENABLE_VERITY	_IOW('f', 133, struct fsverity_enable_arg)
+#define FS_IOC_MEASURE_VERITY	_IOWR('f', 134, struct fsverity_digest)
+
+#endif /* _UAPI_LINUX_FSVERITY_H */
-- 
2.22.0.410.gd8fdbe21b5-goog

