Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CD727E9BC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Sep 2020 15:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgI3N1Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 09:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729205AbgI3NZW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 09:25:22 -0400
Received: from mail.kernel.org (unknown [95.90.213.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1944B239CF;
        Wed, 30 Sep 2020 13:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601472321;
        bh=VDfOGlsJYZesR9L6Qb+5QlSLDI9X9oF0Ascq4FkKHDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0FBxMn4+P5Z72lHFfZUAHW5hPwAXdPu4svvl8ksUqkp4316yV6bOeK96NtiOgMOA
         YYNME6DxXKrDlsS4kcuvlBoEkFnp7yvXmCLMWW8CcWgi7u08ttESxwRHSWMgTZTiyf
         /xKMEwmUgSDErDNll8Xb0h0QEYLRMa5tAUAbp/MI=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kNc6h-001XKR-77; Wed, 30 Sep 2020 15:25:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 35/52] docs: fs: fscrypt.rst: get rid of :c:type: tags
Date:   Wed, 30 Sep 2020 15:24:58 +0200
Message-Id: <689d790237b64fc7d81fcf97ac303cc1dbdd33d4.1601467849.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601467849.git.mchehab+huawei@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The :c:type: tag has problems with Sphinx 3.x, as structs
there should be declared with c:struct.

So, remove them, relying at automarkup.py extension to
convert them into cross-references.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 51 ++++++++++++---------------
 1 file changed, 23 insertions(+), 28 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 4f858b38a412..46a9d1bd2ab5 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -437,8 +437,7 @@ FS_IOC_SET_ENCRYPTION_POLICY
 The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
 empty directory or verifies that a directory or regular file already
 has the specified encryption policy.  It takes in a pointer to a
-struct fscrypt_policy_v1 or a :c:type:`struct
-fscrypt_policy_v2`, defined as follows::
+struct fscrypt_policy_v1 or a struct fscrypt_policy_v2, defined as follows::
 
     #define FSCRYPT_POLICY_V1               0
     #define FSCRYPT_KEY_DESCRIPTOR_SIZE     8
@@ -464,11 +463,10 @@ fscrypt_policy_v2`, defined as follows::
 
 This structure must be initialized as follows:
 
-- ``version`` must be FSCRYPT_POLICY_V1 (0) if the struct is
-  :c:type:`fscrypt_policy_v1` or FSCRYPT_POLICY_V2 (2) if the struct
-  is :c:type:`fscrypt_policy_v2`.  (Note: we refer to the original
-  policy version as "v1", though its version code is really 0.)  For
-  new encrypted directories, use v2 policies.
+- ``version`` must be FSCRYPT_POLICY_V1 (0) if struct fscrypt_policy_v1
+  is used or FSCRYPT_POLICY_V2 (2) if struct fscrypt_policy_v2 is used.
+  (Note: we refer to the original policy version as "v1", though its
+  version code is really 0.)  For new encrypted directories, use v2 policies.
 
 - ``contents_encryption_mode`` and ``filenames_encryption_mode`` must
   be set to constants from ``<linux/fscrypt.h>`` which identify the
@@ -509,8 +507,7 @@ This structure must be initialized as follows:
   be arbitrarily chosen.  Instead, the key must first be added using
   `FS_IOC_ADD_ENCRYPTION_KEY`_.  Then, the ``key_spec.u.identifier``
   the kernel returned in the struct fscrypt_add_key_arg must
-  be used as the ``master_key_identifier`` in the :c:type:`struct
-  fscrypt_policy_v2`.
+  be used as the ``master_key_identifier`` in struct fscrypt_policy_v2.
 
 If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
 verifies that the file is an empty directory.  If so, the specified
@@ -637,9 +634,8 @@ The FS_IOC_GET_ENCRYPTION_POLICY ioctl can also retrieve the
 encryption policy, if any, for a directory or regular file.  However,
 unlike `FS_IOC_GET_ENCRYPTION_POLICY_EX`_,
 FS_IOC_GET_ENCRYPTION_POLICY only supports the original policy
-version.  It takes in a pointer directly to a :c:type:`struct
-fscrypt_policy_v1` rather than a :c:type:`struct
-fscrypt_get_policy_ex_arg`.
+version.  It takes in a pointer directly to struct fscrypt_policy_v1
+rather than struct fscrypt_get_policy_ex_arg.
 
 The error codes for FS_IOC_GET_ENCRYPTION_POLICY are the same as those
 for FS_IOC_GET_ENCRYPTION_POLICY_EX, except that
@@ -717,10 +713,9 @@ as follows:
   ``key_spec.type`` must contain FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR, and
   ``key_spec.u.descriptor`` must contain the descriptor of the key
   being added, corresponding to the value in the
-  ``master_key_descriptor`` field of :c:type:`struct
-  fscrypt_policy_v1`.  To add this type of key, the calling process
-  must have the CAP_SYS_ADMIN capability in the initial user
-  namespace.
+  ``master_key_descriptor`` field of struct fscrypt_policy_v1.
+  To add this type of key, the calling process must have the
+  CAP_SYS_ADMIN capability in the initial user namespace.
 
   Alternatively, if the key is being added for use by v2 encryption
   policies, then ``key_spec.type`` must contain
@@ -737,8 +732,8 @@ as follows:
 
 - ``key_id`` is 0 if the raw key is given directly in the ``raw``
   field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
-  type "fscrypt-provisioning" whose payload is a :c:type:`struct
-  fscrypt_provisioning_key_payload` whose ``raw`` field contains the
+  type "fscrypt-provisioning" whose payload is
+  struct fscrypt_provisioning_key_payload whose ``raw`` field contains the
   raw key and whose ``type`` field matches ``key_spec.type``.  Since
   ``raw`` is variable-length, the total size of this key's payload
   must be ``sizeof(struct fscrypt_provisioning_key_payload)`` plus the
@@ -956,8 +951,8 @@ FS_IOC_GET_ENCRYPTION_KEY_STATUS
 The FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl retrieves the status of a
 master encryption key.  It can be executed on any file or directory on
 the target filesystem, but using the filesystem's root directory is
-recommended.  It takes in a pointer to a :c:type:`struct
-fscrypt_get_key_status_arg`, defined as follows::
+recommended.  It takes in a pointer to struct fscrypt_get_key_status_arg,
+defined as follows::
 
     struct fscrypt_get_key_status_arg {
             /* input */
@@ -1148,12 +1143,12 @@ Implementation details
 Encryption context
 ------------------
 
-An encryption policy is represented on-disk by a :c:type:`struct
-fscrypt_context_v1` or a struct fscrypt_context_v2.  It is
-up to individual filesystems to decide where to store it, but normally
-it would be stored in a hidden extended attribute.  It should *not* be
-exposed by the xattr-related system calls such as getxattr() and
-setxattr() because of the special semantics of the encryption xattr.
+An encryption policy is represented on-disk by struct fscrypt_context_v1
+or struct fscrypt_context_v2.  It is up to individual filesystems to decide
+where to store it, but normally it would be stored in a hidden extended
+attribute.  It should *not* be exposed by the xattr-related system calls
+such as getxattr() and setxattr() because of the special semantics of the
+encryption xattr.
 (In particular, there would be much confusion if an encryption policy
 were to be added to or removed from anything other than an empty
 directory.)  These structs are defined as follows::
@@ -1249,8 +1244,8 @@ a strong "hash" of the ciphertext filename, along with the optional
 filesystem-specific hash(es) needed for directory lookups.  This
 allows the filesystem to still, with a high degree of confidence, map
 the filename given in ->lookup() back to a particular directory entry
-that was previously listed by readdir().  See :c:type:`struct
-fscrypt_nokey_name` in the source for more details.
+that was previously listed by readdir().  See struct fscrypt_nokey_name
+in the source for more details.
 
 Note that the precise way that filenames are presented to userspace
 without the key is subject to change in the future.  It is only meant
-- 
2.26.2

