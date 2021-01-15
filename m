Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C1E2F8448
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 19:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388132AbhAOSZQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 13:25:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387927AbhAOSZQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 13:25:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41C723A58;
        Fri, 15 Jan 2021 18:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610735076;
        bh=74tyf/NRyjp7aV16DxHd1CVRi/GRx0Qd46mVqvrlGkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bmnt1spENj8MmoMybeWfmF4QggXk38vl8jZ1YhVw3SJ/x99Xf3dwVGsWJAHU2VdyO
         1VH06vEUULKmh5JtOfqGcK3ztJqKQfqOq9RopUBwd6G/sbjtbpnsrXRDgOgJ6EUDC1
         gnL3wVcqUOk0rTjokAspYz9VXzJGtLSJ0lc86AmckDLgvwtR5AJS02ECmXtoWKXtmz
         OjlWlsUFureSpe4wHWNHJf62sJXMo6XnWDiN52Vo6lX5vj0TBjwFfkbguN2tos4WlO
         ZYJQMR8/Gt8JW/M71D9irOzVEc6OkskjU3nGpN45KH8QZm1G4/OWN6Odh3t1So6IMA
         eMtBJJwePdPjg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [fsverity-utils RFC PATCH 1/2] Upgrade to latest fsverity_uapi.h
Date:   Fri, 15 Jan 2021 10:24:01 -0800
Message-Id: <20210115182402.35691-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115182402.35691-1-ebiggers@kernel.org>
References: <20210115182402.35691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add the FS_IOC_READ_VERITY_METADATA ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/fsverity_uapi.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/common/fsverity_uapi.h b/common/fsverity_uapi.h
index a739c9a..c59a897 100644
--- a/common/fsverity_uapi.h
+++ b/common/fsverity_uapi.h
@@ -85,7 +85,21 @@ struct fsverity_formatted_digest {
 	__u8 digest[];
 };
 
+#define FS_VERITY_METADATA_TYPE_MERKLE_TREE	1
+#define FS_VERITY_METADATA_TYPE_DESCRIPTOR	2
+#define FS_VERITY_METADATA_TYPE_SIGNATURE	3
+
+struct fsverity_read_metadata_arg {
+	__u64 metadata_type;
+	__u64 offset;
+	__u64 length;
+	__u64 buf_ptr;
+	__u64 __reserved;
+};
+
 #define FS_IOC_ENABLE_VERITY	_IOW('f', 133, struct fsverity_enable_arg)
 #define FS_IOC_MEASURE_VERITY	_IOWR('f', 134, struct fsverity_digest)
+#define FS_IOC_READ_VERITY_METADATA \
+	_IOWR('f', 135, struct fsverity_read_metadata_arg)
 
 #endif /* _UAPI_LINUX_FSVERITY_H */
-- 
2.30.0

