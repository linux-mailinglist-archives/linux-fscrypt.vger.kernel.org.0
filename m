Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5FEA5C1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Oct 2019 22:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfJ3Vwp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Oct 2019 17:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727166AbfJ3Vwp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Oct 2019 17:52:45 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFEE20862;
        Wed, 30 Oct 2019 21:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572472364;
        bh=y4oLlU0PwG6Gb11lermyYlXjl1OFMyfPqp29PV/aEhQ=;
        h=From:To:Cc:Subject:Date:From;
        b=rypiZv9Shr5dm6CahK4eU9hStA++o2IHHcslyIVVVvy1/WDHdvYn1DgI6wu+cJrqV
         wD3uZ2c/gJIjelb1wiklxvdWOdQX/5m3D418roK6xl/lmcafm+iRKq9BGFYcMkhqJu
         VudIQnmfhQ4RUQclDvLOwz/T8e4vmZLI/2AE0JDA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Douglas Anderson <dianders@chromium.org>,
        Gwendal Grignou <gwendal@chromium.org>,
        Ryo Hashimoto <hashimoto@chromium.org>, groeck@chromium.org,
        apronin@chromium.org, sukhomlinov@google.com,
        Chao Yu <chao@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2] Revert "ext4 crypto: fix to check feature status before get policy"
Date:   Wed, 30 Oct 2019 14:51:38 -0700
Message-Id: <20191030215138.224671-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

This reverts commit 0642ea2409f3 ("ext4 crypto: fix to check feature
status before get policy").

The commit made a clear and documented ABI change that is not backward
compatible.  There exists userspace code [1][2] that relied on the old
behavior and is now broken.

While we could entertain the idea of updating the userspace code to
handle the ABI change, it's my understanding that in general ABI
changes that break userspace are frowned upon (to put it nicely).

[1] https://chromium.googlesource.com/chromiumos/platform2/+/5993e5c2c2439d7a144863e9c7622736d72771d5/chromeos-common-script/share/chromeos-common.sh#375
[2] https://crbug.com/1018265

[EB: Note, this revert restores an inconsistency between ext4 and f2fs
 and restores the partially incorrect documentation.  Later we should
 try fixing the inconsistency the other way, by changing f2fs instead
 -- or if that won't work either, at least fixing the documentation.

 Also fixed link 1 above to point to the code which actually broke.]

Fixes: 0642ea2409f3 ("ext4 crypto: fix to check feature status before get policy")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: improved commit message.

 Documentation/filesystems/fscrypt.rst | 3 +--
 fs/ext4/ioctl.c                       | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 8a0700af9596..4289c29d7c5a 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -562,8 +562,7 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX can fail with the following errors:
   or this kernel is too old to support FS_IOC_GET_ENCRYPTION_POLICY_EX
   (try FS_IOC_GET_ENCRYPTION_POLICY instead)
 - ``EOPNOTSUPP``: the kernel was not configured with encryption
-  support for this filesystem, or the filesystem superblock has not
-  had encryption enabled on it
+  support for this filesystem
 - ``EOVERFLOW``: the file is encrypted and uses a recognized
   encryption policy version, but the policy struct does not fit into
   the provided buffer
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0b7f316fd30f..13d97fb797b4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1181,8 +1181,6 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 #endif
 	}
 	case EXT4_IOC_GET_ENCRYPTION_POLICY:
-		if (!ext4_has_feature_encrypt(sb))
-			return -EOPNOTSUPP;
 		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
 
 	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
-- 
2.23.0

