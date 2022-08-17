Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7BF5971B8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240399AbiHQOqC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbiHQOqB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:46:01 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E6A9C2DB;
        Wed, 17 Aug 2022 07:45:57 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id BA67980F14;
        Wed, 17 Aug 2022 10:45:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747557; bh=XY+NXPwvgQ85NkV9SDrCiEWUbqHpOLE9kmmtITaEU+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vMLqYxadaxK5RGJRPcWEq/wK9zG5mY2BhLiFR+dph18t9D1jSa66g/jCKJz4CHWC/
         I+xprFYXqUaW9sBPJtzXWlNSedp7+lXhKNhHzoTZKld1d+aVLTJsuv+0MrRh7SQE+X
         GdISXBEYIN0GqvlaDlRDPIFNaxoE+hWQA6OEJR3WYSjbbmYl8x7I1qxoH0r0KUEbPY
         cGv2Snbz7GyEnGuw4ZP1UtxTJNfFT3Ufa0/aEPi+wVety10xOewlq9ouwHxNwB40l/
         jXQhkEb4R6nZLOdvAw6khIyfX1zuPhSnKs76a5PDK3HtUH3AECQ/+m4X43SwTT+R3G
         Kr7NYyDj22btw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 1/2] fstests: fscrypt: enable btrfs testing.
Date:   Wed, 17 Aug 2022 10:45:45 -0400
Message-Id: <fa6513cef32a922e92f2a58efaf495529a0c3d75.1660729861.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660729861.git.sweettea-kernel@dorminy.me>
References: <cover.1660729861.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

btrfs' fscrypt integration has more stringent requirements than other
filesystems using fscrypt: only v2 policies are permitted, and v2
policies must use the FSCRYPT_FLAG_IV_FROM_FS flag. This makes most
existing fscrypt tests fail, as they use v1 policies.

To make at least a few pass, this adds several common pieces:
- _set_encpolicy tries to automatically add -v 2 and -f 32 for btrfs,
  if no explicit -v and -f (respectively) option is set
- _require_scratch_encryption updates default policy version for btrfs,
  and checks that only the relevant flag is set
- _scratch_mkfs_sized_encrypted can deal with btrfs

These pieces are used in tests to make most generic tests work with
btrfs, although some tests of both v1 and v2 policies still need to be
split.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt      | 117 +++++++++++++++++++++++++++++++++++++++++++-
 common/verity       |   2 +-
 tests/btrfs/298     |  85 ++++++++++++++++++++++++++++++++
 tests/btrfs/298.out |  34 +++++++++++++
 tests/btrfs/299     |  68 +++++++++++++++++++++++++
 tests/btrfs/299.out |   4 ++
 tests/generic/395   |   2 +-
 tests/generic/397   |   8 +--
 tests/generic/398   |  12 +++--
 tests/generic/399   |   7 +--
 tests/generic/419   |   7 +--
 tests/generic/421   |   7 +--
 tests/generic/429   |   2 +-
 tests/generic/435   |   2 +-
 tests/generic/440   |   2 +-
 tests/generic/576   |   7 +--
 tests/generic/580   |   1 +
 tests/generic/581   |   1 +
 tests/generic/593   |   1 +
 tests/generic/613   |   1 +
 20 files changed, 344 insertions(+), 26 deletions(-)
 create mode 100755 tests/btrfs/298
 create mode 100644 tests/btrfs/298.out
 create mode 100755 tests/btrfs/299
 create mode 100644 tests/btrfs/299.out

diff --git a/common/encrypt b/common/encrypt
index 8f3c46f6..b011c3e8 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -73,6 +73,10 @@ _require_encryption_policy_support()
 	local policy_version=1
 	local c
 
+	if [ "$FSTYP" = "btrfs" ]; then
+		policy_version=2
+	fi
+
 	OPTIND=2
 	while getopts "c:n:f:v:" c; do
 		case $c in
@@ -102,6 +106,12 @@ _require_encryption_policy_support()
 		_scratch_unmount
 		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
 		_scratch_mount
+	fi;
+
+	if [ "$FSTYP" = "btrfs" ]; then
+		if (( policy_flags & ~FSCRYPT_POLICY_FLAG_IV_FROM_FS )); then
+			_fail "Btrfs accepts policy flags of IV_FROM_FS only"
+		fi
 	fi
 
 	mkdir $dir
@@ -146,7 +156,7 @@ _require_encryption_policy_support()
 _scratch_mkfs_encrypted()
 {
 	case $FSTYP in
-	ext4|f2fs)
+	btrfs|ext4|f2fs)
 		_scratch_mkfs -O encrypt
 		;;
 	ubifs)
@@ -165,6 +175,9 @@ _scratch_mkfs_sized_encrypted()
 	ext4|f2fs)
 		MKFS_OPTIONS="$MKFS_OPTIONS -O encrypt" _scratch_mkfs_sized $*
 		;;
+	btrfs)
+		_scratch_mkfs_sized $*
+		;;
 	*)
 		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized_encrypted"
 		;;
@@ -225,6 +238,57 @@ _check_session_keyring()
 	fi
 }
 
+# Set up to use default-policy keys.
+_initialize_default_policy()
+{
+	if ! [ "$FSTYP" = "btrfs" ]; then
+		_init_session_keyring
+	fi
+}
+
+# Add a key with the default-policy.
+_add_default_policy_key()
+{
+	if [ "$FSTYP" = "btrfs" ]; then
+		_add_enckey $SCRATCH_MNT "$*" | awk '{print $NF}'
+	else
+		local keydesc=$(_generate_key_descriptor)
+		_add_session_encryption_key $keydesc $*
+		echo $keydesc
+	fi
+}
+
+# Unlink a default-type key
+_unlink_default_policy_key()
+{
+	if [ "$FSTYP" = "btrfs" ]; then
+		_rm_enckey $SCRATCH_MNT $*
+	else
+		_unlink_session_encryption_key $*
+	fi
+}
+
+# Revoke a default-type key
+_revoke_default_policy_key()
+{
+	if [ "$FSTYP" = "btrfs" ]; then
+		_rm_enckey $SCRATCH_MNT $*
+	else
+		_revoke_session_encryption_key $*
+	fi
+}
+
+# Give the invoking shell a new session keyring.  This makes any keys we add to
+# the session keyring scoped to the lifetime of the test script.
+_new_session_keyring()
+{
+	if [ "$FSTYP" = "btrfs" ]; then
+		_notrun "not suitable for this filesystem type: btrfs"
+	fi
+
+	$KEYCTL_PROG new_session >>$seqres.full
+}
+
 # Generate a key descriptor (16 character hex string)
 _generate_key_descriptor()
 {
@@ -357,6 +421,19 @@ _set_encpolicy()
 	local dir=$1
 	shift
 
+	if [ "$FSTYP" = "btrfs" ]; then
+		# Append -v 2 and the necessary IV_FROM_FS flag if -v or -f
+		# isn't set.
+		if ! [[ "$*" =~ -v ]]; then
+			set -- "$* -v 2"
+		fi
+
+		versionmatcher="-v 2"
+		if [[ "$*" =~ $versionmatcher ]] && ! [[ "$*" =~ -f ]]; then
+			set -- "$* -f 32"
+		fi
+	fi
+
 	$XFS_IO_PROG -c "set_encpolicy $*" "$dir"
 }
 
@@ -364,6 +441,18 @@ _user_do_set_encpolicy()
 {
 	local dir=$1
 	shift
+	if [ "$FSTYP" = "btrfs" ]; then
+		# Append -v 2 and the necessary IV_FROM_FS flag if -v or -f
+		# isn't set.
+		if ! [[ "$*" =~ -v ]]; then
+			set -- "$* -v 2"
+		fi
+
+		versionmatcher="-v 2"
+		if [[ "$*" =~ $versionmatcher ]] && ! [[ "$*" =~ -f ]]; then
+			set -- "$* -f 32"
+		fi
+	fi
 
 	_user_do "$XFS_IO_PROG -c \"set_encpolicy $*\" \"$dir\""
 }
@@ -491,6 +580,18 @@ _get_encryption_nonce()
 	local inode=$2
 
 	case $FSTYP in
+	btrfs)
+		# btrfs prints the fscrypt_context like:
+		#
+		# item 18 key (258 FSCRYPT_CTXT_ITEM 0) itemoff 15218 itemsize 40
+		#	value: 0201042000000000000000000000000000000000000000007907c9718128b82caebfa42e881b0163
+		#
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 1 "key ($inode FSCRYPT_CTXT_ITEM 0)" | \
+			awk '/value: [[:xdigit:]]+$/ {
+				print substr($0, length($0) - 31, 32);
+			}'
+		;;
 	ext4)
 		# Use debugfs to dump the special xattr named "c", which is the
 		# file's fscrypt_context.  This produces a line like:
@@ -539,6 +640,9 @@ _require_get_encryption_nonce_support()
 {
 	echo "Checking for _get_encryption_nonce() support for $FSTYP" >> $seqres.full
 	case $FSTYP in
+	btrfs)
+		_require_command "$BTRFS_UTIL_PROG" btrfs
+		;;
 	ext4)
 		_require_command "$DEBUGFS_PROG" debugfs
 		;;
@@ -810,6 +914,7 @@ FSCRYPT_MODE_ADIANTUM=9
 FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64=0x08
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32=0x10
+FSCRYPT_POLICY_FLAG_IV_FROM_FS=0x20
 
 FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR=1
 FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER=2
@@ -853,6 +958,10 @@ _verify_ciphertext_for_encryption_policy()
 	local crypt_util_filename_args=""
 	local expected_identifier
 
+	if [ "$FSTYP" = "btrfs" ]; then
+		policy_version = 2
+	fi
+	
 	shift 2
 	for opt; do
 		case "$opt" in
@@ -888,6 +997,12 @@ _verify_ciphertext_for_encryption_policy()
 	if (( policy_version > 1 )); then
 		set_encpolicy_args+=" -v 2"
 		crypt_util_args+=" --kdf=HKDF-SHA512"
+		if [ "$FSTYP" = "btrfs" ]; then
+			if (( policy_flags & ~FSCRYPT_POLICY_FLAG_IV_FROM_FS )); then
+				_fail "Btrfs accepts policy flags of IV_FROM_FS only"
+			fi	
+			policy_flags |= FSCRYPT_POLICY_FLAG_IV_FROM_FS
+		fi
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			crypt_util_args+=" --direct-key"
 		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
diff --git a/common/verity b/common/verity
index cb7fa333..82a4ff90 100644
--- a/common/verity
+++ b/common/verity
@@ -178,7 +178,7 @@ _scratch_mkfs_verity()
 _scratch_mkfs_encrypted_verity()
 {
 	case $FSTYP in
-	ext4)
+	ext4|btrfs)
 		_scratch_mkfs -O encrypt,verity
 		;;
 	f2fs)
diff --git a/tests/btrfs/298 b/tests/btrfs/298
new file mode 100755
index 00000000..2b03148e
--- /dev/null
+++ b/tests/btrfs/298
@@ -0,0 +1,85 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2016 Google, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 298
+#
+# Test setting and getting encryption policies. Like generic/395, but allows
+# setting encryption policy on a nonempty directory.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_encryption
+_require_xfs_io_command "get_encpolicy"
+_require_user
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+# Should be able to set an encryption policy on an empty directory
+empty_dir=$SCRATCH_MNT/empty_dir
+echo -e "\n*** Setting encryption policy on empty directory ***"
+mkdir $empty_dir
+_get_encpolicy $empty_dir |& _filter_scratch
+_set_encpolicy $empty_dir 0000111122223333
+_get_encpolicy $empty_dir | _filter_scratch
+
+# Should be able to set the same policy again, but not a different one.
+echo -e "\n*** Setting encryption policy again ***"
+_set_encpolicy $empty_dir 0000111122223333
+_get_encpolicy $empty_dir | _filter_scratch
+_set_encpolicy $empty_dir 4444555566667777 |& _filter_scratch
+_get_encpolicy $empty_dir | _filter_scratch
+
+# Should be able to set an encryption policy on a nonempty directory
+nonempty_dir=$SCRATCH_MNT/nonempty_dir
+echo -e "\n*** Setting encryption policy on nonempty directory ***"
+mkdir $nonempty_dir
+touch $nonempty_dir/file
+_set_encpolicy $nonempty_dir |& _filter_scratch
+_get_encpolicy $nonempty_dir |& _filter_scratch
+
+# Should *not* be able to set an encryption policy on a nondirectory file, even
+# an empty one.  Regression test for 002ced4be642: "fscrypto: only allow setting
+# encryption policy on directories".
+nondirectory=$SCRATCH_MNT/nondirectory
+echo -e "\n*** Setting encryption policy on nondirectory ***"
+touch $nondirectory
+_set_encpolicy $nondirectory |& _filter_scratch
+_get_encpolicy $nondirectory |& _filter_scratch
+
+# Should *not* be able to set an encryption policy on another user's directory.
+# Regression test for 163ae1c6ad62: "fscrypto: add authorization check for
+# setting encryption policy".
+unauthorized_dir=$SCRATCH_MNT/unauthorized_dir
+echo -e "\n*** Setting encryption policy on another user's directory ***"
+mkdir $unauthorized_dir
+_user_do_set_encpolicy $unauthorized_dir |& _filter_scratch
+_get_encpolicy $unauthorized_dir |& _filter_scratch
+
+# Should *not* be able to set an encryption policy on a directory on a
+# filesystem mounted readonly.  Regression test for ba63f23d69a3: "fscrypto:
+# require write access to mount to set encryption policy".  Test both a regular
+# readonly filesystem and a readonly bind mount of a read-write filesystem.
+echo -e "\n*** Setting encryption policy on readonly filesystem ***"
+mkdir $SCRATCH_MNT/ro_dir $SCRATCH_MNT/ro_bind_mnt
+_scratch_remount ro
+_set_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
+_get_encpolicy $SCRATCH_MNT/ro_dir |& _filter_scratch
+_scratch_remount rw
+mount --bind $SCRATCH_MNT $SCRATCH_MNT/ro_bind_mnt
+mount -o remount,ro,bind $SCRATCH_MNT/ro_bind_mnt
+_set_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
+_get_encpolicy $SCRATCH_MNT/ro_bind_mnt/ro_dir |& _filter_scratch
+umount $SCRATCH_MNT/ro_bind_mnt
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/298.out b/tests/btrfs/298.out
new file mode 100644
index 00000000..15069749
--- /dev/null
+++ b/tests/btrfs/298.out
@@ -0,0 +1,34 @@
+QA output created by 298
+
+*** Setting encryption policy on empty directory ***
+SCRATCH_MNT/empty_dir: failed to get encryption policy: No data available
+invalid key identifier: 0000111122223333
+/mnt/scratch/empty_dir: failed to get encryption policy: No data available
+
+*** Setting encryption policy again ***
+invalid key identifier: 0000111122223333
+/mnt/scratch/empty_dir: failed to get encryption policy: No data available
+invalid key identifier: 4444555566667777
+/mnt/scratch/empty_dir: failed to get encryption policy: No data available
+
+*** Setting encryption policy on nonempty directory ***
+Encryption policy for SCRATCH_MNT/nonempty_dir:
+	Policy version: 2
+	Master key identifier: 00000000000000000000000000000000
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x20
+
+*** Setting encryption policy on nondirectory ***
+SCRATCH_MNT/nondirectory: failed to set encryption policy: Not a directory
+SCRATCH_MNT/nondirectory: failed to get encryption policy: No data available
+
+*** Setting encryption policy on another user's directory ***
+Permission denied
+SCRATCH_MNT/unauthorized_dir: failed to get encryption policy: No data available
+
+*** Setting encryption policy on readonly filesystem ***
+SCRATCH_MNT/ro_dir: failed to set encryption policy: Read-only file system
+SCRATCH_MNT/ro_dir: failed to get encryption policy: No data available
+SCRATCH_MNT/ro_bind_mnt/ro_dir: failed to set encryption policy: Read-only file system
+SCRATCH_MNT/ro_bind_mnt/ro_dir: failed to get encryption policy: No data available
diff --git a/tests/btrfs/299 b/tests/btrfs/299
new file mode 100755
index 00000000..d9fde898
--- /dev/null
+++ b/tests/btrfs/299
@@ -0,0 +1,68 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2017 Google, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 299
+#
+# Test that without the encryption key for a directory, long filenames are
+# presented in a way which avoids collisions, even though they are abbreviated
+# in order to support names up to NAME_MAX bytes.
+#
+# Regression test for:
+#	6332cd32c829 ("f2fs: check entire encrypted bigname when finding a dentry")
+#	6b06cdee81d6 ("fscrypt: avoid collisions when presenting long encrypted filenames")
+#
+# Even with these two fixes it's still possible to create intentional
+# collisions.  For now this test covers "accidental" collisions only.
+#
+# Based on generic/435.
+#
+. ./common/preamble
+_begin_fstest auto encrypt
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_encryption
+_require_command "$KEYCTL_PROG" keyctl
+
+# set up an encrypted directory
+
+_initialize_default_policy
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+mkdir $SCRATCH_MNT/edir
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
+# -f 0x2: zero-pad to 16-byte boundary (i.e. encryption block boundary)
+# -f 0x20: necessary flag for btrfs
+_set_encpolicy $SCRATCH_MNT/edir $keydesc -f 0x22
+
+# Create files with long names (> 32 bytes, long enough to trigger the use of
+# "digested" names) in the encrypted directory.
+#
+# Use 100,000 files so that we have a good chance of detecting buggy filesystems
+# that solely use a 32-bit hash to distinguish files, which f2fs was doing.
+#
+# Furthermore, make the filenames differ only in the last 16-byte encryption
+# block.  This reproduces the bug where it was not accounted for that ciphertext
+# stealing (CTS) causes the last two blocks to appear "flipped".
+seq -f "$SCRATCH_MNT/edir/abcdefghijklmnopqrstuvwxyz012345%.0f" 100000 | xargs touch
+find $SCRATCH_MNT/edir/ -type f | xargs stat -c %i | sort | uniq | wc -l
+
+_unlink_default_policy_key $keydesc &>> $seqres.full
+_scratch_cycle_mount
+
+# Verify that every file has a unique inode number and can be removed without
+# error.  With the bug(s), some filenames incorrectly pointed to the same inode,
+# and ext4 reported a "Structure needs cleaning" error when removing files.
+find $SCRATCH_MNT/edir/ -type f | xargs stat -c %i | sort | uniq | wc -l
+rm -rf $SCRATCH_MNT/edir |& head -n 10
+stat $SCRATCH_MNT/edir |& _filter_stat |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/299.out b/tests/btrfs/299.out
new file mode 100644
index 00000000..41d3d94a
--- /dev/null
+++ b/tests/btrfs/299.out
@@ -0,0 +1,4 @@
+QA output created by 299
+100000
+100000
+stat: cannot statx 'SCRATCH_MNT/edir': No such file or directory
diff --git a/tests/generic/395 b/tests/generic/395
index ab2ad612..f111329b 100755
--- a/tests/generic/395
+++ b/tests/generic/395
@@ -15,7 +15,7 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption
+_require_scratch_encryption -v 1
 _require_xfs_io_command "get_encpolicy"
 _require_user
 
diff --git a/tests/generic/397 b/tests/generic/397
index 6c03f274..e3c5e401 100755
--- a/tests/generic/397
+++ b/tests/generic/397
@@ -23,13 +23,14 @@ _require_symlinks
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 
-_init_session_keyring
+_initialize_default_policy
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
 mkdir $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
-keydesc=$(_generate_session_encryption_key)
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 for dir in $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir; do
 	touch $dir/empty > /dev/null
@@ -47,6 +48,7 @@ done
 diff -r $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
 # Cycle mount and diff again
 _scratch_cycle_mount
+_add_default_policy_key $raw_key &>> $seqres.full
 diff -r $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
 
 #
@@ -63,7 +65,7 @@ diff -r $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
 # instead of a random one.  The same applies to symlink targets.
 #
 
-_unlink_session_encryption_key $keydesc
+_unlink_default_policy_key $keydesc &>> $seqres.full
 _scratch_cycle_mount
 
 # Check that unencrypted names aren't there
diff --git a/tests/generic/398 b/tests/generic/398
index e2cbad54..b3108b15 100755
--- a/tests/generic/398
+++ b/tests/generic/398
@@ -24,7 +24,7 @@ _supported_fs generic
 _require_scratch_encryption
 _require_renameat2 exchange
 
-_init_session_keyring
+_initialize_default_policy
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
@@ -34,8 +34,10 @@ edir1=$SCRATCH_MNT/edir1
 edir2=$SCRATCH_MNT/edir2
 udir=$SCRATCH_MNT/udir
 mkdir $edir1 $edir2 $udir
-keydesc1=$(_generate_session_encryption_key)
-keydesc2=$(_generate_session_encryption_key)
+raw_key1=$(_generate_raw_encryption_key)
+raw_key2=$(_generate_raw_encryption_key)
+keydesc1=$(_add_default_policy_key $raw_key1)
+keydesc2=$(_add_default_policy_key $raw_key2)
 _set_encpolicy $edir1 $keydesc1
 _set_encpolicy $edir2 $keydesc2
 touch $edir1/efile1
@@ -101,8 +103,8 @@ rm $edir1/fifo $edir2/fifo $udir/fifo
 # Now test that *without* access to the encrypted key, we cannot use an exchange
 # (cross rename) operation to move a forbidden file into an encrypted directory.
 
-_unlink_session_encryption_key $keydesc1
-_unlink_session_encryption_key $keydesc2
+_unlink_default_policy_key $keydesc1 &>> $seqres.full
+_unlink_default_policy_key $keydesc2 &>> $seqres.full
 _scratch_cycle_mount
 efile1=$(find $edir1 -type f)
 efile2=$(find $edir2 -type f)
diff --git a/tests/generic/399 b/tests/generic/399
index a5aa7107..e3c77872 100755
--- a/tests/generic/399
+++ b/tests/generic/399
@@ -30,7 +30,7 @@ _require_symlinks
 _require_command "$XZ_PROG" xz
 _require_command "$KEYCTL_PROG" keyctl
 
-_init_session_keyring
+_initialize_default_policy
 
 #
 # Set up a small filesystem containing an encrypted directory.  64 MB is enough
@@ -45,7 +45,8 @@ dd if=/dev/zero of=$SCRATCH_DEV bs=$((1024 * 1024)) \
 _scratch_mkfs_sized_encrypted $fs_size &>> $seqres.full
 _scratch_mount
 
-keydesc=$(_generate_session_encryption_key)
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
 mkdir $SCRATCH_MNT/encrypted_dir
 _set_encpolicy $SCRATCH_MNT/encrypted_dir $keydesc
 
@@ -111,7 +112,7 @@ done
 # memory than the '-9' preset.  The memory needed with our settings will be
 # 64 * 6.5 = 416 MB; see xz(1).
 #
-_unlink_session_encryption_key $keydesc
+_unlink_default_policy_key $keydesc &>> $seqres.full
 _scratch_unmount
 fs_compressed_size=$(head -c $fs_size $SCRATCH_DEV | \
 	xz --lzma2=dict=64M,mf=hc4,mode=fast,nice=16 | \
diff --git a/tests/generic/419 b/tests/generic/419
index 5d56d64f..f5fd9ea9 100755
--- a/tests/generic/419
+++ b/tests/generic/419
@@ -24,17 +24,18 @@ _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 _require_renameat2 exchange
 
-_init_session_keyring
+_initialize_default_policy
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
 mkdir $SCRATCH_MNT/edir
-keydesc=$(_generate_session_encryption_key)
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 echo a > $SCRATCH_MNT/edir/a
 echo b > $SCRATCH_MNT/edir/b
-_unlink_session_encryption_key $keydesc
+_unlink_default_policy_key $keydesc &>> $seqres.full
 _scratch_cycle_mount
 
 # Note that because no-key filenames are unpredictable, this needs to be written
diff --git a/tests/generic/421 b/tests/generic/421
index 0c4fa8e3..de8594fa 100755
--- a/tests/generic/421
+++ b/tests/generic/421
@@ -20,7 +20,7 @@ _supported_fs generic
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 
-_init_session_keyring
+_initialize_default_policy
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
@@ -34,7 +34,8 @@ slice=2
 # Create an encrypted file and sync its data to disk.
 rm -rf $dir
 mkdir $dir
-keydesc=$(_generate_session_encryption_key)
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
 _set_encpolicy $dir $keydesc
 $XFS_IO_PROG -f $file -c "pwrite 0 $((nproc*slice))M" -c "fsync" > /dev/null
 
@@ -54,7 +55,7 @@ done
 sleep 1
 
 # Revoke the encryption key.
-keyid=$(_revoke_session_encryption_key $keydesc)
+keyid=$(_revoke_default_policy_key $keydesc)
 
 # Now try to open the file again.  In buggy kernels this caused concurrent
 # readers to crash with a NULL pointer dereference during decryption.
diff --git a/tests/generic/429 b/tests/generic/429
index 2cf12316..776eee71 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -28,7 +28,7 @@ _begin_fstest auto encrypt
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption
+_require_scratch_encryption -v 1
 _require_command "$KEYCTL_PROG" keyctl
 _require_test_program "t_encrypted_d_revalidate"
 
diff --git a/tests/generic/435 b/tests/generic/435
index bb1cbb62..b0b9cd83 100755
--- a/tests/generic/435
+++ b/tests/generic/435
@@ -24,7 +24,7 @@ _begin_fstest auto encrypt
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption
+_require_scratch_encryption -v 1
 _require_command "$KEYCTL_PROG" keyctl
 
 # set up an encrypted directory
diff --git a/tests/generic/440 b/tests/generic/440
index 5850a8fe..ca7c55b1 100755
--- a/tests/generic/440
+++ b/tests/generic/440
@@ -20,7 +20,7 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption
+_require_scratch_encryption -v 1
 _require_symlinks
 _require_command "$KEYCTL_PROG" keyctl
 
diff --git a/tests/generic/576 b/tests/generic/576
index c8862de2..7a368a8d 100755
--- a/tests/generic/576
+++ b/tests/generic/576
@@ -26,7 +26,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_scratch_verity
-_require_scratch_encryption
+_require_scratch_encryption -v 1
 _require_command "$KEYCTL_PROG" keyctl
 _require_fsverity_corruption
 _disable_fsverity_signatures
@@ -39,8 +39,9 @@ edir=$SCRATCH_MNT/edir
 fsv_file=$edir/file.fsv
 
 # Set up an encrypted directory.
-_init_session_keyring
-keydesc=$(_generate_session_encryption_key)
+_initialize_default_policy
+raw_key=$(_generate_raw_encryption_key)
+keydesc=$(_add_default_policy_key $raw_key)
 mkdir $edir
 _set_encpolicy $edir $keydesc
 
diff --git a/tests/generic/580 b/tests/generic/580
index 73f32ff9..f9928d33 100755
--- a/tests/generic/580
+++ b/tests/generic/580
@@ -18,6 +18,7 @@ echo
 
 # real QA test starts here
 _supported_fs generic
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 
 _scratch_mkfs_encrypted &>> $seqres.full
diff --git a/tests/generic/581 b/tests/generic/581
index cabc7e1c..78cc0fa8 100755
--- a/tests/generic/581
+++ b/tests/generic/581
@@ -31,6 +31,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_user
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 
 _scratch_mkfs_encrypted &>> $seqres.full
diff --git a/tests/generic/593 b/tests/generic/593
index 2dda5d76..7907236c 100755
--- a/tests/generic/593
+++ b/tests/generic/593
@@ -17,6 +17,7 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 _require_command "$KEYCTL_PROG" keyctl
 
diff --git a/tests/generic/613 b/tests/generic/613
index 4cf5ccc6..ffd5f8a9 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -22,6 +22,7 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
+_require_scratch_encryption -v 1
 _require_scratch_encryption -v 2
 _require_get_encryption_nonce_support
 _require_command "$XZ_PROG" xz
-- 
2.35.1

