Return-Path: <linux-fscrypt+bounces-51-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0953480634F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Dec 2023 01:19:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A1B7B2115C
	for <lists+linux-fscrypt@lfdr.de>; Wed,  6 Dec 2023 00:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E50360;
	Wed,  6 Dec 2023 00:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uMhq0sGP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF1C19F
	for <linux-fscrypt@vger.kernel.org>; Wed,  6 Dec 2023 00:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173C0C433C7
	for <linux-fscrypt@vger.kernel.org>; Wed,  6 Dec 2023 00:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701821949;
	bh=kdfKG1P3yhFxIBe6XLql4R1JIlO1jbOXz/LP2IU1E14=;
	h=From:To:Subject:Date:From;
	b=uMhq0sGPXR9bPWVN85qqOZwpOmueQwJyMNHNqHo3m7Dzd5Mu90hCvFo6scNrZUq7d
	 sHB7nasxZvzMnLhQ5pl5C2fCXc9BGeOJdBLeNIJ/deZTI/prPYXzIxaOTeq3TL7ZjB
	 C+9mCDG6YWfBpe0Q20fhfZpykdqmicwBn7/04Cw0NMUMfd0Z610GtXO2+vzDISXtt+
	 VJXx3+ZGIBxBXZ/vZ/7qNgZXqgLVkgCaDx4E8ydPG6CqicocyBfSau4P4p9vOQYtBj
	 +vESc3l3RIn2Mtyzqrmtp1iCTwz56gxJH7mpYCQDwubk+nSrmbcJounWRScLYzPsFa
	 1X92ZCfJlDjOQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt.rst: update definition of struct fscrypt_context_v2
Date: Tue,  5 Dec 2023 16:19:01 -0800
Message-ID: <20231206001901.14371-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Get the copy of the fscrypt_context_v2 definition in the documentation
in sync with the actual definition, which was changed recently by
commit 5b1188847180 ("fscrypt: support crypto data unit size less than
filesystem block size").

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 1b84f818e574e..8d38b47b7b83c 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1375,21 +1375,22 @@ directory.)  These structs are defined as follows::
             u8 master_key_descriptor[FSCRYPT_KEY_DESCRIPTOR_SIZE];
             u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
     };
 
     #define FSCRYPT_KEY_IDENTIFIER_SIZE  16
     struct fscrypt_context_v2 {
             u8 version;
             u8 contents_encryption_mode;
             u8 filenames_encryption_mode;
             u8 flags;
-            u8 __reserved[4];
+            u8 log2_data_unit_size;
+            u8 __reserved[3];
             u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
             u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
     };
 
 The context structs contain the same information as the corresponding
 policy structs (see `Setting an encryption policy`_), except that the
 context structs also contain a nonce.  The nonce is randomly generated
 by the kernel and is used as KDF input or as a tweak to cause
 different files to be encrypted differently; see `Per-file encryption
 keys`_ and `DIRECT_KEY policies`_.

base-commit: bee0e7762ad2c6025b9f5245c040fcc36ef2bde8
-- 
2.43.0


