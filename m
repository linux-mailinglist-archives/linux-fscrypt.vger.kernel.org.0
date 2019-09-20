Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95981B889B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394415AbfITAiF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393228AbfITAiF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:38:05 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B9021920;
        Fri, 20 Sep 2019 00:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568939883;
        bh=ZZTnO1QjUmpMr1NhBV9YeqFAkHGhL70TScJ52/5jkSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMrV9+fDZOWc9+uNlFTAXz5Auc5Xw3+NJ1+ZZo7NBI5jaUP2qa+k0pnR097Kjm/Mk
         ra5saGmxOJIMhJE53+IA4IjQAK/Lc3KYUqrF+EPcZyhGtqqO7eRo3t3Qw4YuG5m3cz
         Z1PgRG8Q8tgtV2hB6/k4KMivo3bnZofAw1K81IXc=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 1/9] common/encrypt: disambiguate session encryption keys
Date:   Thu, 19 Sep 2019 17:37:45 -0700
Message-Id: <20190920003753.40281-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920003753.40281-1-ebiggers@kernel.org>
References: <20190920003753.40281-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Rename the helper functions that add/remove keys from the session
keyring, in order to distinguish them from the helper functions I'll be
adding to add/remove keys from the new filesystem-level keyring.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt    | 20 ++++++++++----------
 tests/ext4/024    |  2 +-
 tests/generic/397 |  4 ++--
 tests/generic/398 |  8 ++++----
 tests/generic/399 |  4 ++--
 tests/generic/419 |  4 ++--
 tests/generic/421 |  4 ++--
 tests/generic/429 |  8 ++++----
 tests/generic/435 |  4 ++--
 tests/generic/440 |  8 ++++----
 10 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 06a56ed9..7bbe1936 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -89,7 +89,7 @@ _require_encryption_policy_support()
 	mkdir $dir
 	_require_command "$KEYCTL_PROG" keyctl
 	_new_session_keyring
-	local keydesc=$(_generate_encryption_key)
+	local keydesc=$(_generate_session_encryption_key)
 	if _set_encpolicy $dir $keydesc $set_encpolicy_args \
 		2>&1 >>$seqres.full | egrep -q 'Invalid argument'; then
 		_notrun "kernel does not support encryption policy: '$set_encpolicy_args'"
@@ -153,7 +153,7 @@ _generate_key_descriptor()
 	echo $keydesc
 }
 
-# Generate a raw encryption key, but don't add it to the keyring yet.
+# Generate a raw encryption key, but don't add it to any keyring yet.
 _generate_raw_encryption_key()
 {
 	local raw=""
@@ -166,7 +166,7 @@ _generate_raw_encryption_key()
 
 # Add the specified raw encryption key to the session keyring, using the
 # specified key descriptor.
-_add_encryption_key()
+_add_session_encryption_key()
 {
 	local keydesc=$1
 	local raw=$2
@@ -209,26 +209,26 @@ _add_encryption_key()
 # keyctl program.  It's assumed the caller has already set up a test-scoped
 # session keyring using _new_session_keyring.
 #
-_generate_encryption_key()
+_generate_session_encryption_key()
 {
 	local keydesc=$(_generate_key_descriptor)
 	local raw=$(_generate_raw_encryption_key)
 
-	_add_encryption_key $keydesc $raw
+	_add_session_encryption_key $keydesc $raw
 
 	echo $keydesc
 }
 
 # Unlink an encryption key from the session keyring, given its key descriptor.
-_unlink_encryption_key()
+_unlink_session_encryption_key()
 {
 	local keydesc=$1
 	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
 	$KEYCTL_PROG unlink $keyid >>$seqres.full
 }
 
-# Revoke an encryption key from the keyring, given its key descriptor.
-_revoke_encryption_key()
+# Revoke an encryption key from the session keyring, given its key descriptor.
+_revoke_session_encryption_key()
 {
 	local keydesc=$1
 	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
@@ -412,7 +412,7 @@ _require_get_ciphertext_filename_support()
 		_scratch_mount
 		_new_session_keyring
 
-		local keydesc=$(_generate_encryption_key)
+		local keydesc=$(_generate_session_encryption_key)
 		local dir=$SCRATCH_MNT/test.${FUNCNAME[0]}
 		local file=$dir/$(perl -e 'print "A" x 255')
 		mkdir $dir
@@ -634,7 +634,7 @@ _verify_ciphertext_for_encryption_policy()
 	local raw_key=$(_generate_raw_encryption_key)
 	local keydesc=$(_generate_key_descriptor)
 	_new_session_keyring
-	_add_encryption_key $keydesc $raw_key
+	_add_session_encryption_key $keydesc $raw_key
 	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
 
 	echo
diff --git a/tests/ext4/024 b/tests/ext4/024
index a86cc417..95243b70 100755
--- a/tests/ext4/024
+++ b/tests/ext4/024
@@ -53,7 +53,7 @@ _new_session_keyring
 _scratch_mkfs_encrypted &>>$seqres.full
 _scratch_mount
 mkdir $SCRATCH_MNT/edir
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 echo foo > $SCRATCH_MNT/edir/file
 inum=$(stat -c '%i' $SCRATCH_MNT/edir/file)
diff --git a/tests/generic/397 b/tests/generic/397
index a97e866b..f2e22950 100755
--- a/tests/generic/397
+++ b/tests/generic/397
@@ -45,7 +45,7 @@ _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
 mkdir $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 for dir in $SCRATCH_MNT/edir $SCRATCH_MNT/ref_dir; do
 	touch $dir/empty > /dev/null
@@ -92,7 +92,7 @@ filter_create_errors()
 	    -e 's/Operation not permitted/Required key not available/'
 }
 
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
 
 # Check that unencrypted names aren't there
diff --git a/tests/generic/398 b/tests/generic/398
index b1af65e5..8c02bdc4 100755
--- a/tests/generic/398
+++ b/tests/generic/398
@@ -68,8 +68,8 @@ edir1=$SCRATCH_MNT/edir1
 edir2=$SCRATCH_MNT/edir2
 udir=$SCRATCH_MNT/udir
 mkdir $edir1 $edir2 $udir
-keydesc1=$(_generate_encryption_key)
-keydesc2=$(_generate_encryption_key)
+keydesc1=$(_generate_session_encryption_key)
+keydesc2=$(_generate_session_encryption_key)
 _set_encpolicy $edir1 $keydesc1
 _set_encpolicy $edir2 $keydesc2
 touch $edir1/efile1
@@ -141,8 +141,8 @@ rm $edir1/fifo $edir2/fifo $udir/fifo
 # Now test that *without* access to the encrypted key, we cannot use an exchange
 # (cross rename) operation to move a forbidden file into an encrypted directory.
 
-_unlink_encryption_key $keydesc1
-_unlink_encryption_key $keydesc2
+_unlink_session_encryption_key $keydesc1
+_unlink_session_encryption_key $keydesc2
 _scratch_cycle_mount
 efile1=$(find $edir1 -type f)
 efile2=$(find $edir2 -type f)
diff --git a/tests/generic/399 b/tests/generic/399
index dfd8d3c2..b2aaac13 100755
--- a/tests/generic/399
+++ b/tests/generic/399
@@ -61,7 +61,7 @@ dd if=/dev/zero of=$SCRATCH_DEV bs=$((1024 * 1024)) \
 _scratch_mkfs_sized_encrypted $fs_size &>> $seqres.full
 _scratch_mount
 
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 mkdir $SCRATCH_MNT/encrypted_dir
 _set_encpolicy $SCRATCH_MNT/encrypted_dir $keydesc
 
@@ -127,7 +127,7 @@ done
 # memory than the '-9' preset.  The memory needed with our settings will be
 # 64 * 6.5 = 416 MB; see xz(1).
 #
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 _scratch_unmount
 fs_compressed_size=$(head -c $fs_size $SCRATCH_DEV | \
 	xz --lzma2=dict=64M,mf=hc4,mode=fast,nice=16 | \
diff --git a/tests/generic/419 b/tests/generic/419
index 2f1d34c6..5b6636cd 100755
--- a/tests/generic/419
+++ b/tests/generic/419
@@ -47,11 +47,11 @@ _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
 mkdir $SCRATCH_MNT/edir
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 echo a > $SCRATCH_MNT/edir/a
 echo b > $SCRATCH_MNT/edir/b
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
 
 # Note that because encrypted filenames are unpredictable, this needs to be
diff --git a/tests/generic/421 b/tests/generic/421
index c8cc2dcc..f634a431 100755
--- a/tests/generic/421
+++ b/tests/generic/421
@@ -51,7 +51,7 @@ slice=2
 # Create an encrypted file and sync its data to disk.
 rm -rf $dir
 mkdir $dir
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 _set_encpolicy $dir $keydesc
 $XFS_IO_PROG -f $file -c "pwrite 0 $((nproc*slice))M" -c "fsync" > /dev/null
 
@@ -71,7 +71,7 @@ done
 sleep 1
 
 # Revoke the encryption key.
-keyid=$(_revoke_encryption_key $keydesc)
+keyid=$(_revoke_session_encryption_key $keydesc)
 
 # Now try to open the file again.  In buggy kernels this caused concurrent
 # readers to crash with a NULL pointer dereference during decryption.
diff --git a/tests/generic/429 b/tests/generic/429
index 472fdbd9..6c18c543 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -56,7 +56,7 @@ _new_session_keyring
 keydesc=$(_generate_key_descriptor)
 raw_key=$(_generate_raw_encryption_key)
 mkdir $SCRATCH_MNT/edir
-_add_encryption_key $keydesc $raw_key
+_add_session_encryption_key $keydesc $raw_key
 _set_encpolicy $SCRATCH_MNT/edir $keydesc
 
 # Create two files in the directory: one whose name is valid in the base64
@@ -96,7 +96,7 @@ show_directory_with_key()
 # the correct number of them are listed by readdir, and save them for later.
 echo
 echo "***** Without encryption key *****"
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
 echo "--- Directory listing:"
 ciphertext_names=( $(find $SCRATCH_MNT/edir -mindepth 1 | sort) )
@@ -109,7 +109,7 @@ show_file_contents
 # stale dentries.
 echo
 echo "***** With encryption key *****"
-_add_encryption_key $keydesc $raw_key
+_add_session_encryption_key $keydesc $raw_key
 show_directory_with_key
 
 # Test for ->d_revalidate() race conditions.
@@ -127,7 +127,7 @@ echo "***** After key revocation *****"
 	exec 3<$SCRATCH_MNT/edir
 	exec 4<$SCRATCH_MNT/edir/@@@
 	exec 5<$SCRATCH_MNT/edir/abcd
-	_revoke_encryption_key $keydesc
+	_revoke_session_encryption_key $keydesc
 	show_directory_with_key
 )
 
diff --git a/tests/generic/435 b/tests/generic/435
index 073596f3..f12d2be8 100755
--- a/tests/generic/435
+++ b/tests/generic/435
@@ -50,7 +50,7 @@ _new_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 mkdir $SCRATCH_MNT/edir
-keydesc=$(_generate_encryption_key)
+keydesc=$(_generate_session_encryption_key)
 # -f 0x2: zero-pad to 16-byte boundary (i.e. encryption block boundary)
 _set_encpolicy $SCRATCH_MNT/edir $keydesc -f 0x2
 
@@ -66,7 +66,7 @@ _set_encpolicy $SCRATCH_MNT/edir $keydesc -f 0x2
 seq -f "$SCRATCH_MNT/edir/abcdefghijklmnopqrstuvwxyz012345%.0f" 100000 | xargs touch
 find $SCRATCH_MNT/edir/ -type f | xargs stat -c %i | sort | uniq | wc -l
 
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 _scratch_cycle_mount
 
 # Verify that every file has a unique inode number and can be removed without
diff --git a/tests/generic/440 b/tests/generic/440
index 434286f4..1ec1ed48 100755
--- a/tests/generic/440
+++ b/tests/generic/440
@@ -46,7 +46,7 @@ _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 keydesc=$(_generate_key_descriptor)
 raw_key=$(_generate_raw_encryption_key)
-_add_encryption_key $keydesc $raw_key
+_add_session_encryption_key $keydesc $raw_key
 
 # Set up an encrypted directory containing a regular file, a subdirectory, and a
 # symlink.
@@ -65,7 +65,7 @@ echo
 echo "***** Parent has key, but child doesn't *****"
 exec 3< $SCRATCH_MNT/edir # pin inode with cached key in memory
 ls $SCRATCH_MNT/edir | sort
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 cat $SCRATCH_MNT/edir/file |& _filter_scratch
 ls $SCRATCH_MNT/edir/subdir
 cat $SCRATCH_MNT/edir/symlink |& _filter_scratch
@@ -79,14 +79,14 @@ exec 3>&-
 # plaintext contents, even though its filename is shown in ciphertext!
 echo
 echo "***** Child has key, but parent doesn't *****"
-_add_encryption_key $keydesc $raw_key
+_add_session_encryption_key $keydesc $raw_key
 mkdir $SCRATCH_MNT/edir2
 _set_encpolicy $SCRATCH_MNT/edir2 $keydesc
 ln $SCRATCH_MNT/edir/file $SCRATCH_MNT/edir2/link
 _scratch_cycle_mount
 cat $SCRATCH_MNT/edir2/link
 exec 3< $SCRATCH_MNT/edir2/link # pin inode with cached key in memory
-_unlink_encryption_key $keydesc
+_unlink_session_encryption_key $keydesc
 stat $SCRATCH_MNT/edir/file |& _filter_scratch
 cat "$(find $SCRATCH_MNT/edir/ -type f)"
 exec 3>&-
-- 
2.23.0.351.gc4317032e6-goog

