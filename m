Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D319D2A13B1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 06:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgJaFls (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 01:41:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgJaFls (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 01:41:48 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29C6020791;
        Sat, 31 Oct 2020 05:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604122907;
        bh=bD+mNlVaazd6vFqNnyaLDi+qr4bJzxHBX8gExIjlrBg=;
        h=From:To:Cc:Subject:Date:From;
        b=0k+j9KQtPm8vclRSD67V2uVcHbXlbtUCaIGt20FTo5lxIdp96BWHuv0I0zGyOodIN
         sNbcFQvjOGnZUCujJuA5Bo7TDFgz88mL+IjxwrNrXvJQHypd1d6DOdiqHCjyKwiGu9
         +Ch0ncVqgIPOd5BFyzlMeJBMV4Q8WbGsOjUkL0B0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic/398: remove workarounds for wrong error codes
Date:   Fri, 30 Oct 2020 22:41:41 -0700
Message-Id: <20201031054141.695517-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

generic/398 contains workarounds to allow for renames of encrypted files
to fail with different error codes.  However, these error codes were
fixed up by kernel commits f5e55e777cc9 ("fscrypt: return -EXDEV for
incompatible rename or link into encrypted dir") and 0c1ad5242d4f
("ubifs: switch to fscrypt_prepare_rename()").

It's been long enough, so update the test to expect the correct behavior
only, so we don't accidentally reintroduce the wrong behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/398 | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/tests/generic/398 b/tests/generic/398
index fcc6e704..3046c398 100755
--- a/tests/generic/398
+++ b/tests/generic/398
@@ -26,23 +26,6 @@ _cleanup()
 	rm -f $tmp.*
 }
 
-# The error code for incompatible rename or link into an encrypted directory was
-# changed from EPERM to EXDEV in Linux v5.1, to allow tools like 'mv' to work.
-# See kernel commit f5e55e777cc9 ("fscrypt: return -EXDEV for incompatible
-# rename or link into encrypted dir").  Accept both errors for now.
-filter_eperm_to_exdev()
-{
-	sed -e 's/Operation not permitted/Invalid cross-device link/'
-}
-
-# The error code for incompatible cross-rename without the key has been ENOKEY
-# on all filesystems since Linux v4.16.  Previously it was EPERM on some
-# filesystems.  Accept both errors for now.
-filter_eperm_to_enokey()
-{
-	sed -e 's/Operation not permitted/Required key not available/'
-}
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -80,20 +63,20 @@ touch $udir/ufile
 # different encryption policy.  Should fail with EXDEV.
 
 echo -e "\n*** Link encrypted <= encrypted ***"
-ln $edir1/efile1 $edir2/efile1 |& _filter_scratch | filter_eperm_to_exdev
+ln $edir1/efile1 $edir2/efile1 |& _filter_scratch
 
 echo -e "\n*** Rename encrypted => encrypted ***"
-$here/src/renameat2 $edir1/efile1 $edir2/efile1 |& filter_eperm_to_exdev
+$here/src/renameat2 $edir1/efile1 $edir2/efile1
 
 
 # Test linking and renaming an unencrypted file into an encrypted directory.
 # Should fail with EXDEV.
 
 echo -e "\n\n*** Link unencrypted <= encrypted ***"
-ln $udir/ufile $edir1/ufile |& _filter_scratch | filter_eperm_to_exdev
+ln $udir/ufile $edir1/ufile |& _filter_scratch
 
 echo -e "\n*** Rename unencrypted => encrypted ***"
-$here/src/renameat2 $udir/ufile $edir1/ufile |& filter_eperm_to_exdev
+$here/src/renameat2 $udir/ufile $edir1/ufile
 
 
 # Test linking and renaming an encrypted file into an unencrypted directory.
@@ -113,13 +96,13 @@ $here/src/renameat2 $udir/efile1 $edir1/efile1 # undo
 # rename) operation.  Should fail with EXDEV.
 
 echo -e "\n\n*** Exchange encrypted <=> encrypted ***"
-$here/src/renameat2 -x $edir1/efile1 $edir2/efile2 |& filter_eperm_to_exdev
+$here/src/renameat2 -x $edir1/efile1 $edir2/efile2
 
 echo -e "\n*** Exchange unencrypted <=> encrypted ***"
-$here/src/renameat2 -x $udir/ufile $edir1/efile1 |& filter_eperm_to_exdev
+$here/src/renameat2 -x $udir/ufile $edir1/efile1
 
 echo -e "\n*** Exchange encrypted <=> unencrypted ***"
-$here/src/renameat2 -x $edir1/efile1 $udir/ufile |& filter_eperm_to_exdev
+$here/src/renameat2 -x $edir1/efile1 $udir/ufile
 
 
 # Test a file with a special type, i.e. not regular, directory, or symlink.
@@ -147,9 +130,9 @@ efile1=$(find $edir1 -type f)
 efile2=$(find $edir2 -type f)
 
 echo -e "\n\n*** Exchange encrypted <=> encrypted without key ***"
-$here/src/renameat2 -x $efile1 $efile2 |& filter_eperm_to_enokey
+$here/src/renameat2 -x $efile1 $efile2
 echo -e "\n*** Exchange encrypted <=> unencrypted without key ***"
-$here/src/renameat2 -x $efile1 $udir/ufile |& filter_eperm_to_enokey
+$here/src/renameat2 -x $efile1 $udir/ufile
 
 # success, all done
 status=0
-- 
2.29.1

