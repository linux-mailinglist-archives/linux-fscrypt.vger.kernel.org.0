Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C1228DA18
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Oct 2020 08:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgJNG7P (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Oct 2020 02:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgJNG7P (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Oct 2020 02:59:15 -0400
Received: from coco.lan (ip5f5ad5dc.dynamic.kabel-deutschland.de [95.90.213.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D5CC2222C;
        Wed, 14 Oct 2020 06:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602658753;
        bh=a3WONSqVGwbQqUy13HpeIY9S6WrPgW7N27TAJhhPBm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=svv290rYuQVkbnDl5iTYYDCN80sufZf/El/44Yc7166QR7leDtDBiAmhwlnw73EbC
         iSrH7BV9kUZEzbUgHRJ3mJrEtQgMgsQVPAN+Fcd7yp10EJx/SquofwYnnVHLZTLoqf
         Vve+bc6uUyDWFXI7o5cCiCZlgDk8rJ0j/t4jkk9c=
Date:   Wed, 14 Oct 2020 08:59:07 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type:
 tags
Message-ID: <20201014085907.7da5bed3@coco.lan>
In-Reply-To: <20201013172512.GA1306858@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
        <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
        <20201013172512.GA1306858@gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Em Tue, 13 Oct 2020 10:25:12 -0700
Eric Biggers <ebiggers@kernel.org> escreveu:

> On Tue, Oct 13, 2020 at 01:53:50PM +0200, Mauro Carvalho Chehab wrote:
> > The :c:type: tag has problems with Sphinx 3.x, as structs
> > there should be declared with c:struct.
> > 
> > So, remove them, relying at automarkup.py extension to
> > convert them into cross-references.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> 
> I left some comments on v5 which weren't addressed.
> 
> - Eric

Sorry, I missed your reply. I'm dropping fscrypt.rst changes
that were on this patch:

	[PATCH v6 23/80] docs: get rid of :c:type explicit declarations for structs

and replacing with the enclosed one that should be addressing
your issues.

Thanks,
Mauro

[PATCH v6.1 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags

The :c:type: tag has problems with Sphinx 3.x, as structs
there should be declared with c:struct.

So, remove them, relying at automarkup.py extension to
convert them into cross-references.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 423c5a0daf45..44b67ebd6e40 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -436,9 +436,9 @@ FS_IOC_SET_ENCRYPTION_POLICY
 
 The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
 empty directory or verifies that a directory or regular file already
-has the specified encryption policy.  It takes in a pointer to a
-:c:type:`struct fscrypt_policy_v1` or a :c:type:`struct
-fscrypt_policy_v2`, defined as follows::
+has the specified encryption policy.  It takes in a pointer to
+struct fscrypt_policy_v1 or struct fscrypt_policy_v2, defined as
+follows::
 
     #define FSCRYPT_POLICY_V1               0
     #define FSCRYPT_KEY_DESCRIPTOR_SIZE     8
@@ -464,11 +464,11 @@ fscrypt_policy_v2`, defined as follows::
 
 This structure must be initialized as follows:
 
-- ``version`` must be FSCRYPT_POLICY_V1 (0) if the struct is
-  :c:type:`fscrypt_policy_v1` or FSCRYPT_POLICY_V2 (2) if the struct
-  is :c:type:`fscrypt_policy_v2`.  (Note: we refer to the original
-  policy version as "v1", though its version code is really 0.)  For
-  new encrypted directories, use v2 policies.
+- ``version`` must be FSCRYPT_POLICY_V1 (0) if
+  struct fscrypt_policy_v1 is used or FSCRYPT_POLICY_V2 (2) if
+  struct fscrypt_policy_v2 is used. (Note: we refer to the original
+  policy version as "v1", though its version code is really 0.)
+  For new encrypted directories, use v2 policies.
 
 - ``contents_encryption_mode`` and ``filenames_encryption_mode`` must
   be set to constants from ``<linux/fscrypt.h>`` which identify the
@@ -508,9 +508,9 @@ This structure must be initialized as follows:
   replaced with ``master_key_identifier``, which is longer and cannot
   be arbitrarily chosen.  Instead, the key must first be added using
   `FS_IOC_ADD_ENCRYPTION_KEY`_.  Then, the ``key_spec.u.identifier``
-  the kernel returned in the :c:type:`struct fscrypt_add_key_arg` must
-  be used as the ``master_key_identifier`` in the :c:type:`struct
-  fscrypt_policy_v2`.
+  the kernel returned in the struct fscrypt_add_key_arg must
+  be used as the ``master_key_identifier`` in
+  struct fscrypt_policy_v2.
 
 If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
 verifies that the file is an empty directory.  If so, the specified
@@ -590,7 +590,7 @@ FS_IOC_GET_ENCRYPTION_POLICY_EX
 The FS_IOC_GET_ENCRYPTION_POLICY_EX ioctl retrieves the encryption
 policy, if any, for a directory or regular file.  No additional
 permissions are required beyond the ability to open the file.  It
-takes in a pointer to a :c:type:`struct fscrypt_get_policy_ex_arg`,
+takes in a pointer to struct fscrypt_get_policy_ex_arg,
 defined as follows::
 
     struct fscrypt_get_policy_ex_arg {
@@ -637,9 +637,8 @@ The FS_IOC_GET_ENCRYPTION_POLICY ioctl can also retrieve the
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
@@ -680,8 +679,7 @@ the filesystem, making all files on the filesystem which were
 encrypted using that key appear "unlocked", i.e. in plaintext form.
 It can be executed on any file or directory on the target filesystem,
 but using the filesystem's root directory is recommended.  It takes in
-a pointer to a :c:type:`struct fscrypt_add_key_arg`, defined as
-follows::
+a pointer to struct fscrypt_add_key_arg, defined as follows::
 
     struct fscrypt_add_key_arg {
             struct fscrypt_key_specifier key_spec;
@@ -710,17 +708,16 @@ follows::
             __u8 raw[];
     };
 
-:c:type:`struct fscrypt_add_key_arg` must be zeroed, then initialized
+struct fscrypt_add_key_arg must be zeroed, then initialized
 as follows:
 
 - If the key is being added for use by v1 encryption policies, then
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
@@ -737,12 +734,13 @@ as follows:
 
 - ``key_id`` is 0 if the raw key is given directly in the ``raw``
   field.  Otherwise ``key_id`` is the ID of a Linux keyring key of
-  type "fscrypt-provisioning" whose payload is a :c:type:`struct
-  fscrypt_provisioning_key_payload` whose ``raw`` field contains the
-  raw key and whose ``type`` field matches ``key_spec.type``.  Since
-  ``raw`` is variable-length, the total size of this key's payload
-  must be ``sizeof(struct fscrypt_provisioning_key_payload)`` plus the
-  raw key size.  The process must have Search permission on this key.
+  type "fscrypt-provisioning" whose payload is
+  struct fscrypt_provisioning_key_payload whose ``raw`` field contains
+  the raw key and whose ``type`` field matches ``key_spec.type``.
+  Since ``raw`` is variable-length, the total size of this key's
+  payload must be ``sizeof(struct fscrypt_provisioning_key_payload)``
+  plus the raw key size.  The process must have Search permission on
+  this key.
 
   Most users should leave this 0 and specify the raw key directly.
   The support for specifying a Linux keyring key is intended mainly to
@@ -860,8 +858,8 @@ The FS_IOC_REMOVE_ENCRYPTION_KEY ioctl removes a claim to a master
 encryption key from the filesystem, and possibly removes the key
 itself.  It can be executed on any file or directory on the target
 filesystem, but using the filesystem's root directory is recommended.
-It takes in a pointer to a :c:type:`struct fscrypt_remove_key_arg`,
-defined as follows::
+It takes in a pointer to struct fscrypt_remove_key_arg, defined
+as follows::
 
     struct fscrypt_remove_key_arg {
             struct fscrypt_key_specifier key_spec;
@@ -956,8 +954,8 @@ FS_IOC_GET_ENCRYPTION_KEY_STATUS
 The FS_IOC_GET_ENCRYPTION_KEY_STATUS ioctl retrieves the status of a
 master encryption key.  It can be executed on any file or directory on
 the target filesystem, but using the filesystem's root directory is
-recommended.  It takes in a pointer to a :c:type:`struct
-fscrypt_get_key_status_arg`, defined as follows::
+recommended.  It takes in a pointer to
+struct fscrypt_get_key_status_arg, defined as follows::
 
     struct fscrypt_get_key_status_arg {
             /* input */
@@ -1148,10 +1146,10 @@ Implementation details
 Encryption context
 ------------------
 
-An encryption policy is represented on-disk by a :c:type:`struct
-fscrypt_context_v1` or a :c:type:`struct fscrypt_context_v2`.  It is
-up to individual filesystems to decide where to store it, but normally
-it would be stored in a hidden extended attribute.  It should *not* be
+An encryption policy is represented on-disk by
+struct fscrypt_context_v1 or struct fscrypt_context_v2.  It is up to
+individual filesystems to decide where to store it, but normally it
+would be stored in a hidden extended attribute.  It should *not* be
 exposed by the xattr-related system calls such as getxattr() and
 setxattr() because of the special semantics of the encryption xattr.
 (In particular, there would be much confusion if an encryption policy
@@ -1249,8 +1247,8 @@ a strong "hash" of the ciphertext filename, along with the optional
 filesystem-specific hash(es) needed for directory lookups.  This
 allows the filesystem to still, with a high degree of confidence, map
 the filename given in ->lookup() back to a particular directory entry
-that was previously listed by readdir().  See :c:type:`struct
-fscrypt_nokey_name` in the source for more details.
+that was previously listed by readdir().  See
+struct fscrypt_nokey_name in the source for more details.
 
 Note that the precise way that filenames are presented to userspace
 without the key is subject to change in the future.  It is only meant
