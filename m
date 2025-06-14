Return-Path: <linux-fscrypt+bounces-671-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D9AADA02D
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Jun 2025 00:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 169E57A3D96
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Jun 2025 22:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D12200B9F;
	Sat, 14 Jun 2025 22:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVxZjtbr"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2513B1FFC5E
	for <linux-fscrypt@vger.kernel.org>; Sat, 14 Jun 2025 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749939220; cv=none; b=AqodDZoyXfsitu1LbpTjitamTzriqzJXFLzKUu1KvgKxfunWn1DVQwZLtNGg9g4jaAVsmyCf/BIsEzyG+aIepVfSjHl13m6Tb79ehVu6Xr348Wwcqr9bklEfYilU9+47Z5mdhLdyWUZMOaXYkFIxgDuis/z1y0VpQCdCm4zNo8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749939220; c=relaxed/simple;
	bh=seUdFKqyM7+CWJNhmFM8iE/TotIbPF7dgo9ebkgMxGs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mqz77Jh/pvSzvMW/0fZuYq0RvrdCYd02weEVTsqDSApRDntexkS+3saX+Y0J5Hx/quk2YC/qO/Ah3jCWmMf49LP0aoYagbO1FhI6rj4G9eS3g/wUtCErX5dQRfXzQe60P+O9FzmqCyXMwTte41hPHaAq9Xdenl9Dm3zLnfUV+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVxZjtbr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CAFC4CEEB
	for <linux-fscrypt@vger.kernel.org>; Sat, 14 Jun 2025 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749939217;
	bh=seUdFKqyM7+CWJNhmFM8iE/TotIbPF7dgo9ebkgMxGs=;
	h=From:To:Subject:Date:From;
	b=hVxZjtbr0lk7uYW6G7GQTBdWo2rl6jCRmafnZIJtrbh3/jNSZ9PCcC4upUYIo741C
	 n98fnaDFq6zqRsgEw+2njOwRHipzWPfwoKsHWAb9Uc8mB2f8r9XWGMH/Up0rYGMrWL
	 OY1dU3p4jL/VhQqzhn978ZsiPRUHjhC9IQMxaxRvWX+3lh/l5q8lnQiLz85ZAzBD2o
	 XHwcFuvyFO1+mQLXjbACbgFi1oQq6Vefg4mHCMC3uzvT0RSkk1ZzARTVilahERxepV
	 +P7u9aOqxadf5fj2fD0DcnwEob3O55EolCXx8TxkWo2+LUZg7vnX+twS4K2FTOzk9G
	 rnXUQ9FuMNk5A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: explicitly include <linux/export.h>
Date: Sat, 14 Jun 2025 15:13:01 -0700
Message-ID: <20250614221301.100803-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Fix build warnings with W=1 that started appearing after
commit a934a57a42f6 ("scripts/misc-check: check missing #include
<linux/export.h> when W=1").

While at it, also sort the include lists alphabetically.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch applies to v6.16-rc1 and is targeting fscrypt/for-next.

 fs/crypto/bio.c          | 6 ++++--
 fs/crypto/crypto.c       | 8 +++++---
 fs/crypto/fname.c        | 6 ++++--
 fs/crypto/hkdf.c         | 2 +-
 fs/crypto/hooks.c        | 2 ++
 fs/crypto/inline_crypt.c | 1 +
 fs/crypto/keyring.c      | 5 +++--
 fs/crypto/keysetup.c     | 1 +
 fs/crypto/policy.c       | 4 +++-
 9 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 0ad8c30b8fa50..13ad2dd771b64 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -5,14 +5,16 @@
  *
  * Copyright (C) 2015, Google, Inc.
  * Copyright (C) 2015, Motorola Mobility
  */
 
-#include <linux/pagemap.h>
-#include <linux/module.h>
 #include <linux/bio.h>
+#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/namei.h>
+#include <linux/pagemap.h>
+
 #include "fscrypt_private.h"
 
 /**
  * fscrypt_decrypt_bio() - decrypt the contents of a bio
  * @bio: the bio to decrypt
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index b74b5937e695c..ddf6991d46da2 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -18,16 +18,18 @@
  *
  * The usage of AES-XTS should conform to recommendations in NIST
  * Special Publication 800-38E and IEEE P1619/D16.
  */
 
-#include <linux/pagemap.h>
+#include <crypto/skcipher.h>
+#include <linux/export.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
+#include <linux/pagemap.h>
 #include <linux/ratelimit.h>
-#include <crypto/skcipher.h>
+#include <linux/scatterlist.h>
+
 #include "fscrypt_private.h"
 
 static unsigned int num_prealloc_crypto_pages = 32;
 
 module_param(num_prealloc_crypto_pages, uint, 0444);
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 010f9c0a4c2f1..fb01dde0f2e55 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -9,15 +9,17 @@
  * Modified by Jaegeuk Kim, 2015.
  *
  * This has not yet undergone a rigorous security audit.
  */
 
-#include <linux/namei.h>
-#include <linux/scatterlist.h>
 #include <crypto/hash.h>
 #include <crypto/sha2.h>
 #include <crypto/skcipher.h>
+#include <linux/export.h>
+#include <linux/namei.h>
+#include <linux/scatterlist.h>
+
 #include "fscrypt_private.h"
 
 /*
  * The minimum message length (input and output length), in bytes, for all
  * filenames encryption modes.  Filenames shorter than this will be zero-padded
diff --git a/fs/crypto/hkdf.c b/fs/crypto/hkdf.c
index 0f3028adc9c72..5c095c8aa3b5a 100644
--- a/fs/crypto/hkdf.c
+++ b/fs/crypto/hkdf.c
@@ -6,12 +6,12 @@
  *
  * Copyright 2019 Google LLC
  */
 
 #include <crypto/hash.h>
-#include <crypto/sha2.h>
 #include <crypto/hkdf.h>
+#include <crypto/sha2.h>
 
 #include "fscrypt_private.h"
 
 /*
  * HKDF supports any unkeyed cryptographic hash algorithm, but fscrypt uses
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index d8d5049b8fe1f..e0b32ac841f76 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -3,10 +3,12 @@
  * fs/crypto/hooks.c
  *
  * Encryption hooks for higher-level filesystem operations.
  */
 
+#include <linux/export.h>
+
 #include "fscrypt_private.h"
 
 /**
  * fscrypt_file_open() - prepare to open a possibly-encrypted regular file
  * @inode: the inode being opened
diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
index 1d008c440cb69..caaff809765b2 100644
--- a/fs/crypto/inline_crypt.c
+++ b/fs/crypto/inline_crypt.c
@@ -13,10 +13,11 @@
  */
 
 #include <linux/blk-crypto.h>
 #include <linux/blkdev.h>
 #include <linux/buffer_head.h>
+#include <linux/export.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
 
 #include "fscrypt_private.h"
diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index ace369f130683..7557f6a88b8f3 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -16,16 +16,17 @@
  *
  * See the "User API" section of Documentation/filesystems/fscrypt.rst for more
  * information about these ioctls.
  */
 
-#include <linux/unaligned.h>
 #include <crypto/skcipher.h>
+#include <linux/export.h>
 #include <linux/key-type.h>
-#include <linux/random.h>
 #include <linux/once.h>
+#include <linux/random.h>
 #include <linux/seq_file.h>
+#include <linux/unaligned.h>
 
 #include "fscrypt_private.h"
 
 /* The master encryption keys for a filesystem (->s_master_keys) */
 struct fscrypt_keyring {
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 0d71843af9469..a67e20d126c9b 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -7,10 +7,11 @@
  * Originally written by Michael Halcrow, Ildar Muslukhov, and Uday Savagaonkar.
  * Heavily modified since then.
  */
 
 #include <crypto/skcipher.h>
+#include <linux/export.h>
 #include <linux/random.h>
 
 #include "fscrypt_private.h"
 
 struct fscrypt_mode fscrypt_modes[] = {
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 701259991277e..6ad30ae07c065 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -8,15 +8,17 @@
  * Originally written by Michael Halcrow, 2015.
  * Modified by Jaegeuk Kim, 2015.
  * Modified by Eric Biggers, 2019 for v2 policy support.
  */
 
+#include <linux/export.h>
 #include <linux/fs_context.h>
+#include <linux/mount.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
-#include <linux/mount.h>
+
 #include "fscrypt_private.h"
 
 /**
  * fscrypt_policies_equal() - check whether two encryption policies are the same
  * @policy1: the first policy

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.49.0


