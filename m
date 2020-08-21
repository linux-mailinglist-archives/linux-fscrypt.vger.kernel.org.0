Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F6D24DF75
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHUS2W (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbgHUS2S (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:18 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCA3922EBF;
        Fri, 21 Aug 2020 18:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034498;
        bh=G5SLYptlAQ4JAFL5GEkqLWRhYSCKv0S/WO0G7hzpNk4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=TqLrG1PM3mfc8mmeFVOq0K/Flqfcz6Jw79sBUbiBXnNJwa8FlUEmQfxiRjpJ2dw6c
         rLyP0ien8I+DtDIp51kOPWmEznjboIH7fa2dI5ZvXrQQUIN7zcZ2fj3JENaeN+Sqz/
         KW91am8/rFgM4lSR3nP0ZMrs1WJ+PS5Bo9SYQc4Y=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 06/14] ceph: add fscrypt ioctls
Date:   Fri, 21 Aug 2020 14:28:05 -0400
Message-Id: <20200821182813.52570-7-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200821182813.52570-1-jlayton@kernel.org>
References: <20200821182813.52570-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Boilerplate ioctls for controlling encryption.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/ioctl.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
index 6e061bf62ad4..4400b170eca9 100644
--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -6,6 +6,7 @@
 #include "mds_client.h"
 #include "ioctl.h"
 #include <linux/ceph/striper.h>
+#include <linux/fscrypt.h>
 
 /*
  * ioctls
@@ -289,6 +290,31 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	case CEPH_IOC_SYNCIO:
 		return ceph_ioctl_syncio(file);
+#ifdef CONFIG_FS_ENCRYPTION
+	case FS_IOC_SET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
+
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
+
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
+#endif /* CONFIG_FS_ENCRYPTION */
 	}
 
 	return -ENOTTY;
-- 
2.26.2

