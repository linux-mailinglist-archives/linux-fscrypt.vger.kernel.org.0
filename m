Return-Path: <linux-fscrypt+bounces-100-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8207881EC31
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Dec 2023 05:52:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23E4D28350E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Dec 2023 04:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 629B83C29;
	Wed, 27 Dec 2023 04:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jNHF2Kfa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453A03C24;
	Wed, 27 Dec 2023 04:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1C8C433C7;
	Wed, 27 Dec 2023 04:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703652729;
	bh=8F+Q5xY7ENU1tuVu95m/QH9Eg3HBzZHdpbuoDo4Aoas=;
	h=From:To:Cc:Subject:Date:From;
	b=jNHF2KfaQ2Qsj1QbrgaaEqFRB2ZR3rqukSbzooYdkFMzyNaacP/myu8JmNqjTVUrc
	 mcqYp4Eb96m7hzPoFHIP56ydgRNWhAOLe9fJhnqhi5YNbzR/Nfg3EUsGqSifQ0ULYk
	 +NnbEm0lDiwWs67t9ceP4NohDDpW1g1OJ8JO8qP6zVVwMTVXjvbC/Yl73i9N9NSoCG
	 8XYv6EffwyImbgtiKYeW0pC0aqrScnG+TPOgNHVW1wwRljHojTG9Ths02/yoMscE0O
	 uamWRo2ItoeQAAQ5wua5zI4WBdHal+XHAN7zWJEt1TR+iB2CctHdiCXWLfTF++lxus
	 9lPWXn2rq9DTQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
Subject: [PATCH] fscrypt: document that CephFS supports fscrypt now
Date: Tue, 26 Dec 2023 22:51:58 -0600
Message-ID: <20231227045158.87276-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The help text for CONFIG_FS_ENCRYPTION and the fscrypt.rst documentation
file both list the filesystems that support fscrypt.  CephFS added
support for fscrypt in v6.6, so add CephFS to the list.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 18 +++++++++---------
 fs/crypto/Kconfig                     |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 8d38b47b7b83c..e86b886b64d0e 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -24,29 +24,29 @@ completeness this documentation covers the kernel's API anyway.)
 
 Unlike dm-crypt, fscrypt operates at the filesystem level rather than
 at the block device level.  This allows it to encrypt different files
 with different keys and to have unencrypted files on the same
 filesystem.  This is useful for multi-user systems where each user's
 data-at-rest needs to be cryptographically isolated from the others.
 However, except for filenames, fscrypt does not encrypt filesystem
 metadata.
 
 Unlike eCryptfs, which is a stacked filesystem, fscrypt is integrated
-directly into supported filesystems --- currently ext4, F2FS, and
-UBIFS.  This allows encrypted files to be read and written without
-caching both the decrypted and encrypted pages in the pagecache,
-thereby nearly halving the memory used and bringing it in line with
-unencrypted files.  Similarly, half as many dentries and inodes are
-needed.  eCryptfs also limits encrypted filenames to 143 bytes,
-causing application compatibility issues; fscrypt allows the full 255
-bytes (NAME_MAX).  Finally, unlike eCryptfs, the fscrypt API can be
-used by unprivileged users, with no need to mount anything.
+directly into supported filesystems --- currently ext4, F2FS, UBIFS,
+and CephFS.  This allows encrypted files to be read and written
+without caching both the decrypted and encrypted pages in the
+pagecache, thereby nearly halving the memory used and bringing it in
+line with unencrypted files.  Similarly, half as many dentries and
+inodes are needed.  eCryptfs also limits encrypted filenames to 143
+bytes, causing application compatibility issues; fscrypt allows the
+full 255 bytes (NAME_MAX).  Finally, unlike eCryptfs, the fscrypt API
+can be used by unprivileged users, with no need to mount anything.
 
 fscrypt does not support encrypting files in-place.  Instead, it
 supports marking an empty directory as encrypted.  Then, after
 userspace provides the key, all regular files, directories, and
 symbolic links created in that directory tree are transparently
 encrypted.
 
 Threat model
 ============
 
diff --git a/fs/crypto/Kconfig b/fs/crypto/Kconfig
index 2d0c8922f6350..5aff5934baa12 100644
--- a/fs/crypto/Kconfig
+++ b/fs/crypto/Kconfig
@@ -4,21 +4,21 @@ config FS_ENCRYPTION
 	select CRYPTO
 	select CRYPTO_HASH
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_SHA256
 	select KEYS
 	help
 	  Enable encryption of files and directories.  This
 	  feature is similar to ecryptfs, but it is more memory
 	  efficient since it avoids caching the encrypted and
 	  decrypted pages in the page cache.  Currently Ext4,
-	  F2FS and UBIFS make use of this feature.
+	  F2FS, UBIFS, and CephFS make use of this feature.
 
 # Filesystems supporting encryption must select this if FS_ENCRYPTION.  This
 # allows the algorithms to be built as modules when all the filesystems are,
 # whereas selecting them from FS_ENCRYPTION would force them to be built-in.
 #
 # Note: this option only pulls in the algorithms that filesystem encryption
 # needs "by default".  If userspace will use "non-default" encryption modes such
 # as Adiantum encryption, then those other modes need to be explicitly enabled
 # in the crypto API; see Documentation/filesystems/fscrypt.rst for details.
 #

base-commit: 0fc24a6549f9b6efc538b67a098ab577b1f9a00e
-- 
2.43.0


