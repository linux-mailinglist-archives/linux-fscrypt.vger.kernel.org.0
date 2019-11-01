Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B43ECBE1
	for <lists+linux-fscrypt@lfdr.de>; Sat,  2 Nov 2019 00:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfKAXYB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 1 Nov 2019 19:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfKAXYB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 1 Nov 2019 19:24:01 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 786B420679;
        Fri,  1 Nov 2019 23:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572650639;
        bh=GDGI/6Aa0EgPMngXFqIu6BxvB2PcFW/7uFo2CMKC3Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=xt/dpPzQ9J+XCs8l6xcWH+56fmEXA+1edPgzKbxfITnYgPiUx0XZpiY5Esn/gEse4
         XTGRuaUzWQEX5Feo2wWu7AThc8nD9K5TYeRfKZYg5NyuIY4KE6+6uwB2fYY8N3BXyz
         k9D/X27QkjMF1mmjHy8eFfwPZ9muoQQj0WMqVKBk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] generic: handle fs.verity.require_signatures being enabled
Date:   Fri,  1 Nov 2019 16:22:19 -0700
Message-Id: <20191101232219.62604-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Most of the fs-verity tests fail if the fs.verity.require_signatures
sysctl has been set to 1.  Update them to set this sysctl to 0 at the
beginning of the test and restore it to its previous value at the end.

generic/577 intentionally sets this sysctl to 1.  Make it restore the
previous value at the end of the test rather than assuming it was 0.

Also simplify _require_fsverity_builtin_signatures() to just check for
the presence of the file /proc/sys/fs/verity/require_signatures rather
than check whether the fs-verity keyring is listed in /proc/keys.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity         | 37 +++++++++++++++++++++++++++++++++----
 tests/generic/572     |  2 ++
 tests/generic/573     |  2 ++
 tests/generic/574     |  2 ++
 tests/generic/575     |  2 ++
 tests/generic/576     |  2 ++
 tests/generic/577     |  8 ++++----
 tests/generic/577.out |  1 -
 tests/generic/579     |  2 ++
 9 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/common/verity b/common/verity
index bcb5670d..b4c0e2dc 100644
--- a/common/verity
+++ b/common/verity
@@ -33,9 +33,12 @@ _require_scratch_verity()
 	# default.  E.g., ext4 only supports verity on extent-based files, so it
 	# doesn't work on ext3-style filesystems.  So, try actually using it.
 	echo foo > $SCRATCH_MNT/tmpfile
+	_disable_fsverity_signatures
 	if ! _fsv_enable $SCRATCH_MNT/tmpfile; then
+		_restore_fsverity_signatures
 		_notrun "$FSTYP verity isn't usable by default with these mkfs options"
 	fi
+	_restore_fsverity_signatures
 	rm -f $SCRATCH_MNT/tmpfile
 
 	_scratch_unmount
@@ -48,14 +51,40 @@ _require_scratch_verity()
 # Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y.
 _require_fsverity_builtin_signatures()
 {
-	if [ ! -e /proc/keys ]; then
-		_notrun "kernel doesn't support keyrings"
-	fi
-	if ! awk '{print $9}' /proc/keys | grep -q '^\.fs-verity:$'; then
+	if [ ! -e /proc/sys/fs/verity/require_signatures ]; then
 		_notrun "kernel doesn't support fs-verity builtin signatures"
 	fi
 }
 
+# Disable mandatory signatures for fs-verity files, if they are supported.
+_disable_fsverity_signatures()
+{
+	if [ -e /proc/sys/fs/verity/require_signatures ]; then
+		if [ -z "$FSVERITY_SIG_CTL_ORIG" ]; then
+			FSVERITY_SIG_CTL_ORIG=$(</proc/sys/fs/verity/require_signatures)
+		fi
+		echo 0 > /proc/sys/fs/verity/require_signatures
+	fi
+}
+
+# Enable mandatory signatures for fs-verity files.
+# This assumes that _require_fsverity_builtin_signatures() was called.
+_enable_fsverity_signatures()
+{
+	if [ -z "$FSVERITY_SIG_CTL_ORIG" ]; then
+		FSVERITY_SIG_CTL_ORIG=$(</proc/sys/fs/verity/require_signatures)
+	fi
+	echo 1 > /proc/sys/fs/verity/require_signatures
+}
+
+# Restore the original signature verification setting.
+_restore_fsverity_signatures()
+{
+        if [ -n "$FSVERITY_SIG_CTL_ORIG" ]; then
+                echo "$FSVERITY_SIG_CTL_ORIG" > /proc/sys/fs/verity/require_signatures
+        fi
+}
+
 _scratch_mkfs_verity()
 {
 	case $FSTYP in
diff --git a/tests/generic/572 b/tests/generic/572
index 382c4947..53423786 100755
--- a/tests/generic/572
+++ b/tests/generic/572
@@ -23,6 +23,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -38,6 +39,7 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch_verity
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/573 b/tests/generic/573
index d7796abc..248a3bfe 100755
--- a/tests/generic/573
+++ b/tests/generic/573
@@ -19,6 +19,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -36,6 +37,7 @@ _supported_os Linux
 _require_scratch_verity
 _require_user
 _require_chattr ia
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/574 b/tests/generic/574
index 8894ebb8..246f0858 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -21,6 +21,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -36,6 +37,7 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch_verity
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/575 b/tests/generic/575
index 5ca8d3fa..2e857dbe 100755
--- a/tests/generic/575
+++ b/tests/generic/575
@@ -20,6 +20,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -38,6 +39,7 @@ _require_scratch_verity
 if [ $FSV_BLOCK_SIZE != 4096 ]; then
 	_notrun "4096-byte verity block size not supported on this platform"
 fi
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/576 b/tests/generic/576
index 58525295..8fa73489 100755
--- a/tests/generic/576
+++ b/tests/generic/576
@@ -19,6 +19,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -37,6 +38,7 @@ _supported_os Linux
 _require_scratch_verity
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
+_disable_fsverity_signatures
 
 _scratch_mkfs_encrypted_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/577 b/tests/generic/577
index 65d55d6b..2b3dbeca 100755
--- a/tests/generic/577
+++ b/tests/generic/577
@@ -17,8 +17,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-	sysctl -w fs.verity.require_signatures=0 &>/dev/null
 	cd /
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -71,7 +71,7 @@ $KEYCTL_PROG padd asymmetric '' %keyring:.fs-verity \
 	< $certfileder >> $seqres.full
 
 echo -e "\n# Enabling fs.verity.require_signatures"
-sysctl -w fs.verity.require_signatures=1
+_enable_fsverity_signatures
 
 echo -e "\n# Generating file and signing it for fs-verity"
 head -c 100000 /dev/zero > $fsv_orig_file
@@ -104,9 +104,9 @@ _fsv_enable $fsv_file |& _filter_scratch
 
 echo -e "\n# Opening verity file without signature (should fail)"
 reset_fsv_file
-sysctl -w fs.verity.require_signatures=0 &>> $seqres.full
+_disable_fsverity_signatures
 _fsv_enable $fsv_file
-sysctl -w fs.verity.require_signatures=1 &>> $seqres.full
+_enable_fsverity_signatures
 _scratch_cycle_mount
 md5sum $fsv_file |& _filter_scratch
 
diff --git a/tests/generic/577.out b/tests/generic/577.out
index e6767e51..0ca417c4 100644
--- a/tests/generic/577.out
+++ b/tests/generic/577.out
@@ -7,7 +7,6 @@ QA output created by 577
 # Loading first certificate into fs-verity keyring
 
 # Enabling fs.verity.require_signatures
-fs.verity.require_signatures = 1
 
 # Generating file and signing it for fs-verity
 Signed file 'SCRATCH_MNT/file' (sha256:ecabbfca4efd69a721be824965da10d27900b109549f96687b35a4d91d810dac)
diff --git a/tests/generic/579 b/tests/generic/579
index 9c48e167..1720eb53 100755
--- a/tests/generic/579
+++ b/tests/generic/579
@@ -25,6 +25,7 @@ _cleanup()
 	touch $tmp.done
 	wait
 
+	_restore_fsverity_signatures
 	rm -f $tmp.*
 }
 
@@ -41,6 +42,7 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch_verity
 _require_command "$KILLALL_PROG" killall
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

