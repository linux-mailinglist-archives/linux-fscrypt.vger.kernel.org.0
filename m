Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4726F2A13B0
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 06:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJaFlc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 01:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgJaFlc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 01:41:32 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C284A20791;
        Sat, 31 Oct 2020 05:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604122891;
        bh=MHn37pxd8izzOsEnhIJaztg9gs11pffqfEmh6L/CvSw=;
        h=From:To:Cc:Subject:Date:From;
        b=hFnCvfyg9IFEifGc+zLDrp0YfS9Oa2qGuOfr2YvGj1gffbUG6pMeXbq6ZdAEPOegr
         5a2UaeW5gCbYPhsbrWfeWb5SmgHlgu0fk1ncLPoGPX1IJEMx7O/xs0qwEqq/nNoCKK
         gsKVL4YwRzkyveG95RkwIB38Ibb1CqHPUBFqSFN8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic/397: remove workarounds for wrong error codes
Date:   Fri, 30 Oct 2020 22:41:29 -0700
Message-Id: <20201031054129.695442-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

generic/397 contains workarounds to allow for kernel bugs where trying
to open or create files in an encrypted directory without the encryption
key failed with ENOENT, EACCES, or EPERM instead of the expected ENOKEY.

However, all these bugs have been fixed.  ext4 and f2fs were fixed years
ago by commit 54475f531bb8 ("fscrypt: use ENOKEY when file cannot be
created w/o key").  ubifs was fixed by commit b01531db6cec ("fscrypt:
fix race where ->lookup() marks plaintext dentry as ciphertext").

It's been long enough, so update the test to expect the correct behavior
only, so we don't accidentally reintroduce the wrong behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/397 | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/tests/generic/397 b/tests/generic/397
index 73b41b38..97111555 100755
--- a/tests/generic/397
+++ b/tests/generic/397
@@ -78,19 +78,6 @@ diff -r $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
 # every time this test is run, even if we were to put a fixed key into the
 # keyring instead of a random one.  The same applies to symlink targets.
 #
-# TODO: there are some inconsistencies in which error codes are returned on
-# different kernel versions and filesystems when trying to create a file or
-# subdirectory without access to the parent directory's encryption key.  It's
-# planned to consistently use ENOKEY, but for now make this test accept multiple
-# error codes...
-#
-
-filter_create_errors()
-{
-	sed -e 's/No such file or directory/Required key not available/' \
-	    -e 's/Permission denied/Required key not available/' \
-	    -e 's/Operation not permitted/Required key not available/'
-}
 
 _unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
@@ -110,12 +97,12 @@ md5sum $(find $SCRATCH_MNT/edir -maxdepth 1 -type f | head -1) |& \
 # Try to create new files, directories, and symlinks in the encrypted directory,
 # both with and without using correctly base-64 encoded filenames.  These should
 # all fail with ENOKEY.
-$XFS_IO_PROG -f $SCRATCH_MNT/edir/newfile |& filter_create_errors | _filter_scratch
-$XFS_IO_PROG -f $SCRATCH_MNT/edir/0123456789abcdef |& filter_create_errors | _filter_scratch
-mkdir $SCRATCH_MNT/edir/newdir |& filter_create_errors | _filter_scratch
-mkdir $SCRATCH_MNT/edir/0123456789abcdef |& filter_create_errors | _filter_scratch
-ln -s foo $SCRATCH_MNT/edir/newlink |& filter_create_errors | _filter_scratch
-ln -s foo $SCRATCH_MNT/edir/0123456789abcdef |& filter_create_errors | _filter_scratch
+$XFS_IO_PROG -f $SCRATCH_MNT/edir/newfile |& _filter_scratch
+$XFS_IO_PROG -f $SCRATCH_MNT/edir/0123456789abcdef |& _filter_scratch
+mkdir $SCRATCH_MNT/edir/newdir |& _filter_scratch
+mkdir $SCRATCH_MNT/edir/0123456789abcdef |& _filter_scratch
+ln -s foo $SCRATCH_MNT/edir/newlink |& _filter_scratch
+ln -s foo $SCRATCH_MNT/edir/0123456789abcdef |& _filter_scratch
 
 # Delete the encrypted directory (should succeed)
 rm -r $SCRATCH_MNT/edir
-- 
2.29.1

