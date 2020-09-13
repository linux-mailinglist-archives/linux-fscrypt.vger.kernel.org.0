Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303E4267EAA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Sep 2020 10:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgIMIi2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Sep 2020 04:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgIMIiF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Sep 2020 04:38:05 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47AB12177B;
        Sun, 13 Sep 2020 08:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599986280;
        bh=7wQf9Y1Ge/SR2fWtRDGBHBDQ9VcJIvgAiZJHiDlXVEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwrK+k53ctQTtemSNOcktR68ukUN1sYgfusdrpKvROi2SHYNuhB0Z3cuqHWUGFP+g
         D2zzBdN5bj+hkP9FDiiRMu1yN1xOPI6llElIUCFMZUmWhRfYKVknYCFWCbL+MExBGt
         IiJc+P2KyMx7HAYgKeD5Zic2/IUSD9CeQNNYj2I0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Jeff Layton <jlayton@kernel.org>,
        Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 09/11] fscrypt: make "#define fscrypt_policy" user-only
Date:   Sun, 13 Sep 2020 01:36:18 -0700
Message-Id: <20200913083620.170627-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200913083620.170627-1-ebiggers@kernel.org>
References: <20200913083620.170627-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The fscrypt UAPI header defines fscrypt_policy to fscrypt_policy_v1,
for source compatibility with old userspace programs.

Internally, the kernel doesn't want that compatibility definition.
Instead, fscrypt_private.h #undefs it and re-defines it to a union.

That works for now.  However, in order to add
fscrypt_operations::get_dummy_policy(), we'll need to forward declare
'union fscrypt_policy' in include/linux/fscrypt.h.  That would cause
build errors because "fscrypt_policy" is used in ioctl numbers.

To avoid this, modify the UAPI header to make the fscrypt_policy
compatibility definition conditional on !__KERNEL__, and make the ioctls
use fscrypt_policy_v1 instead of fscrypt_policy.

Note that this doesn't change the actual ioctl numbers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h  | 1 -
 include/uapi/linux/fscrypt.h | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 355f6d9377517..ac3352086ee44 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -97,7 +97,6 @@ static inline const u8 *fscrypt_context_nonce(const union fscrypt_context *ctx)
 	return NULL;
 }
 
-#undef fscrypt_policy
 union fscrypt_policy {
 	u8 version;
 	struct fscrypt_policy_v1 v1;
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 7875709ccfebf..e5de603369381 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -45,7 +45,6 @@ struct fscrypt_policy_v1 {
 	__u8 flags;
 	__u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
 };
-#define fscrypt_policy	fscrypt_policy_v1
 
 /*
  * Process-subscribed "logon" key description prefix and payload format.
@@ -156,9 +155,9 @@ struct fscrypt_get_key_status_arg {
 	__u32 __out_reserved[13];
 };
 
-#define FS_IOC_SET_ENCRYPTION_POLICY		_IOR('f', 19, struct fscrypt_policy)
+#define FS_IOC_SET_ENCRYPTION_POLICY		_IOR('f', 19, struct fscrypt_policy_v1)
 #define FS_IOC_GET_ENCRYPTION_PWSALT		_IOW('f', 20, __u8[16])
-#define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy)
+#define FS_IOC_GET_ENCRYPTION_POLICY		_IOW('f', 21, struct fscrypt_policy_v1)
 #define FS_IOC_GET_ENCRYPTION_POLICY_EX		_IOWR('f', 22, __u8[9]) /* size + version */
 #define FS_IOC_ADD_ENCRYPTION_KEY		_IOWR('f', 23, struct fscrypt_add_key_arg)
 #define FS_IOC_REMOVE_ENCRYPTION_KEY		_IOWR('f', 24, struct fscrypt_remove_key_arg)
@@ -170,6 +169,7 @@ struct fscrypt_get_key_status_arg {
 
 /* old names; don't add anything new here! */
 #ifndef __KERNEL__
+#define fscrypt_policy			fscrypt_policy_v1
 #define FS_KEY_DESCRIPTOR_SIZE		FSCRYPT_KEY_DESCRIPTOR_SIZE
 #define FS_POLICY_FLAGS_PAD_4		FSCRYPT_POLICY_FLAGS_PAD_4
 #define FS_POLICY_FLAGS_PAD_8		FSCRYPT_POLICY_FLAGS_PAD_8
-- 
2.28.0

