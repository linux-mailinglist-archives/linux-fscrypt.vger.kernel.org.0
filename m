Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A3D2A13AF
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 06:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgJaFl1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 01:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgJaFl1 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 01:41:27 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31EF020791;
        Sat, 31 Oct 2020 05:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604122886;
        bh=nCGTBX9tDEqmWbzaPbBBKNNXSVAAPdzmhCtdaU5JG3o=;
        h=From:To:Cc:Subject:Date:From;
        b=vbYpcCy1kQQaKf4LqRHnEVba/ssq8svKbX7T+GqeFwFIATHBOmYg0fJN0wubI1xi8
         seCRpkyF1v+Vk0cK5nkD+Hhm0OT87E3IuzXzJirzq3l7ITC/KxbhxLXY4gY7Fb0zTf
         mR9RPAn2bMi1bwsGJ967jUWx2hwlfEdlynTr/j4s=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic/395: remove workarounds for wrong error codes
Date:   Fri, 30 Oct 2020 22:40:18 -0700
Message-Id: <20201031054018.695314-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

generic/395 contains workarounds to allow for some of the fscrypt ioctls
to fail with different error codes.  However, the error codes were all
fixed up and documented years ago:

- FS_IOC_GET_ENCRYPTION_POLICY on ext4 failed with ENOENT instead of
  ENODATA on unencrypted files.  Fixed by commit db717d8e26c2
  ("fscrypto: move ioctl processing more fully into common code").

- FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of EEXIST
  on encrypted files.  Fixed by commit 8488cd96ff88 ("fscrypt: use
  EEXIST when file already uses different policy").

- FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of ENOTDIR
  on nondirectories.  Fixed by commit dffd0cfa06d4 ("fscrypt: use
  ENOTDIR when setting encryption policy on nondirectory").

It's been long enough, so update the test to expect the correct behavior
only, so we don't accidentally reintroduce the wrong behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/395 | 31 ++++++++-----------------------
 1 file changed, 8 insertions(+), 23 deletions(-)

diff --git a/tests/generic/395 b/tests/generic/395
index 3fa2a823..34121dd9 100755
--- a/tests/generic/395
+++ b/tests/generic/395
@@ -38,31 +38,19 @@ _require_user
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
-check_no_policy()
-{
-	# When a file is unencrypted, FS_IOC_GET_ENCRYPTION_POLICY currently
-	# fails with ENOENT on ext4 but with ENODATA on f2fs.  TODO: it's
-	# planned to consistently use ENODATA.  For now this test accepts both.
-	_get_encpolicy $1 |&
-		sed -e 's/No such file or directory/No data available/'
-}
-
 # Should be able to set an encryption policy on an empty directory
 empty_dir=$SCRATCH_MNT/empty_dir
 echo -e "\n*** Setting encryption policy on empty directory ***"
 mkdir $empty_dir
-check_no_policy $empty_dir |& _filter_scratch
+_get_encpolicy $empty_dir |& _filter_scratch
 _set_encpolicy $empty_dir 0000111122223333
 _get_encpolicy $empty_dir | _filter_scratch
 
 # Should be able to set the same policy again, but not a different one.
-# TODO: the error code for "already has a different policy" is planned to switch
-# from EINVAL to EEXIST.  For now this test accepts both.
 echo -e "\n*** Setting encryption policy again ***"
 _set_encpolicy $empty_dir 0000111122223333
 _get_encpolicy $empty_dir | _filter_scratch
-_set_encpolicy $empty_dir 4444555566667777 |& \
-	_filter_scratch | sed -e 's/Invalid argument/File exists/'
+_set_encpolicy $empty_dir 4444555566667777 |& _filter_scratch
 _get_encpolicy $empty_dir | _filter_scratch
 
 # Should *not* be able to set an encryption policy on a nonempty directory
@@ -71,19 +59,16 @@ echo -e "\n*** Setting encryption policy on nonempty directory ***"
 mkdir $nonempty_dir
 touch $nonempty_dir/file
 _set_encpolicy $nonempty_dir |& _filter_scratch
-check_no_policy $nonempty_dir |& _filter_scratch
+_get_encpolicy $nonempty_dir |& _filter_scratch
 
 # Should *not* be able to set an encryption policy on a nondirectory file, even
 # an empty one.  Regression test for 002ced4be642: "fscrypto: only allow setting
 # encryption policy on directories".
-# TODO: the error code for "not a directory" is planned to switch from EINVAL to
-# ENOTDIR.  For now this test accepts both.
 nondirectory=$SCRATCH_MNT/nondirectory
 echo -e "\n*** Setting encryption policy on nondirectory ***"
 touch $nondirectory
-_set_encpolicy $nondirectory |& \
-	_filter_scratch | sed -e 's/Invalid argument/Not a directory/'
-check_no_policy $nondirectory |& _filter_scratch
+_set_encpolicy $nondirectory |& _filter_scratch
+_get_encpolicy $nondirectory |& _filter_scratch
 
 # Should *not* be able to set an encryption policy on another user's directory.
 # Regression test for 163ae1c6ad62: "fscrypto: add authorization check for
@@ -92,7 +77,7 @@ unauthorized_dir=$SCRATCH_MNT/unauthorized_dir
 echo -e "\n*** Setting encryption policy on another user's directory ***"
 mkdir $unauthorized_dir
 _user_do_set_encpolicy $unauthorized_dir |& _filter_scratch
-check_no_policy $unauthorized_dir |& _filter_scratch
+_get_encpolicy $unauthorized_dir |& _filter_scratch
 
 # Should *not* be able to set an encryption policy on a directory on a
 # filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
@@ -102,12 +87,12 @@ echo -e "\n*** Setting encryption policy on readonly filesystem ***"
 mkdir $SCRATCH_MNT/ro_dir $SCRATCH_MNT/ro_bind_mnt
 _scratch_remount ro
 _set_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
-check_no_policy $SCRATCH_MNT/ro_dir |& _filter_scratch
+_get_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
 _scratch_remount rw
 mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
 mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
 _set_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
-check_no_policy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
+_get_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
 umount $SCRATCH_MNT/ro_bind_mnt
 
 # success, all done
-- 
2.29.1

