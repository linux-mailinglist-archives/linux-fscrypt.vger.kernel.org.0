Return-Path: <linux-fscrypt+bounces-52-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF9C80635D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Dec 2023 01:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC432821D6
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Dec 2023 00:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB0D655;
	Wed,  6 Dec 2023 00:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pljFS+nA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A6B652
	for <linux-fscrypt@vger.kernel.org>; Wed,  6 Dec 2023 00:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4216C433C7
	for <linux-fscrypt@vger.kernel.org>; Wed,  6 Dec 2023 00:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701822123;
	bh=eGSP3cNDLK7mJUOMjMdExklLV80MQ7S75oU4JQmNg+s=;
	h=From:To:Subject:Date:From;
	b=pljFS+nAF7xafRbCLzvpikoYMLFswJPzMu9EbGtZZqamIrhmoavC3wjG+KFWM9XBr
	 wVm9I+5DMirm8dtKRIt+6GaK8L8zAe9Ur9DEawGGF+36Ior0V+CfN1qRE4dxFM5Me/
	 wawVB6PhOo5US4o00jSsOwt3dZhsgGLlRW3K7EBR6nrA26H+UtL+fWSek8WFxJiMjw
	 GQkniQqrxHPBKzbaddlgmGju7i8SwMPcd6b1njf2gSYl+a0XI8s6iknX+IPhl74SPP
	 XfUgx11hOV/mvtIYA/thG1hZy0kTnuMYKMz5txdFd70AxEYvN+vrLo52tq9w+UQiE9
	 i0AMQYHxDwGLw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: update comment for do_remove_key()
Date: Tue,  5 Dec 2023 16:21:27 -0800
Message-ID: <20231206002127.14790-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Adjust a comment that was missed during commit 15baf55481de
("fscrypt: track master key presence separately from secret").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/keyring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index f34a9b0b9e922..0edf0b58daa76 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -995,23 +995,23 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
 }
 
 /*
  * Try to remove an fscrypt master encryption key.
  *
  * FS_IOC_REMOVE_ENCRYPTION_KEY (all_users=false) removes the current user's
  * claim to the key, then removes the key itself if no other users have claims.
  * FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS (all_users=true) always removes the
  * key itself.
  *
- * To "remove the key itself", first we wipe the actual master key secret, so
- * that no more inodes can be unlocked with it.  Then we try to evict all cached
- * inodes that had been unlocked with the key.
+ * To "remove the key itself", first we transition the key to the "incompletely
+ * removed" state, so that no more inodes can be unlocked with it.  Then we try
+ * to evict all cached inodes that had been unlocked with the key.
  *
  * If all inodes were evicted, then we unlink the fscrypt_master_key from the
  * keyring.  Otherwise it remains in the keyring in the "incompletely removed"
  * state where it tracks the list of remaining inodes.  Userspace can execute
  * the ioctl again later to retry eviction, or alternatively can re-add the key.
  *
  * For more details, see the "Removing keys" section of
  * Documentation/filesystems/fscrypt.rst.
  */
 static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)

base-commit: bee0e7762ad2c6025b9f5245c040fcc36ef2bde8
-- 
2.43.0


