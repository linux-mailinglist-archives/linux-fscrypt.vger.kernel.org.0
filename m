Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63EB7150F3E
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Feb 2020 19:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgBCSTO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Feb 2020 13:19:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729598AbgBCSTO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Feb 2020 13:19:14 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 156B820838;
        Mon,  3 Feb 2020 18:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580753953;
        bh=FqrRRVyx7LSxJfJWASo3prdQ0NyO97BG0PExREbQIfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QabenrNb5d05UYifaaE/9TfIOuSMIoKzLnruxmKJv++JxjQvDstUMI8yhvq7DigRT
         v80QtlVpDSt7XMOzFup1MlO5ZslimW3uzkGW4mouNiCo8/oPMNajpHCk4MKLtrQwwt
         EnMQv0zE84YOzZ+D5pZ/t+8tT+aBmFpS329eOeAM=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org
Subject: [PATCH v2 3/3] generic: test adding filesystem-level fscrypt key via key_id
Date:   Mon,  3 Feb 2020 10:18:55 -0800
Message-Id: <20200203181855.42987-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
In-Reply-To: <20200203181855.42987-1-ebiggers@kernel.org>
References: <20200203181855.42987-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a test which tests adding a key to a filesystem's fscrypt keyring
via an "fscrypt-provisioning" keyring key.  This is an alternative to
the normal method where the raw key is given directly.

For more details, see kernel commit 93edd392cad7 ("fscrypt: support
passing a keyring key to FS_IOC_ADD_ENCRYPTION_KEY").

This test depends on an xfs_io patch which adds the '-k' option to the
'add_enckey' command, e.g.:

	xfs_io -c "add_enckey -k KEY_ID" MOUNTPOINT

This test is skipped if the needed kernel or xfs_io support is absent.

This has been tested on ext4, f2fs, and ubifs.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt        |  84 +++++++++++++++++++----
 tests/generic/806     | 155 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/806.out |  73 ++++++++++++++++++++
 tests/generic/group   |   1 +
 4 files changed, 299 insertions(+), 14 deletions(-)
 create mode 100644 tests/generic/806
 create mode 100644 tests/generic/806.out

diff --git a/common/encrypt b/common/encrypt
index 98a407ce..5695a123 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -227,6 +227,28 @@ _generate_raw_encryption_key()
 	echo $raw
 }
 
+# Serialize an integer into a CPU-endian bytestring of the given length, and
+# print it as a string where each byte is hex-escaped.  For example,
+# `_num_to_hex 1000 4` == "\xe8\x03\x00\x00" if the CPU is little endian.
+_num_to_hex()
+{
+	local value=$1
+	local nbytes=$2
+	local i
+	local big_endian=$(echo -ne '\x11' | od -tx2 | head -1 | \
+			   cut -f2 -d' ' | cut -c1)
+
+	if (( big_endian )); then
+		for (( i = 0; i < nbytes; i++ )); do
+			printf '\\x%02x' $(((value >> (8*(nbytes-1-i))) & 0xff))
+		done
+	else
+		for (( i = 0; i < nbytes; i++ )); do
+			printf '\\x%02x' $(((value >> (8*i)) & 0xff))
+		done
+	fi
+}
+
 # Add the specified raw encryption key to the session keyring, using the
 # specified key descriptor.
 _add_session_encryption_key()
@@ -237,12 +259,12 @@ _add_session_encryption_key()
 	#
 	# Add the key to the session keyring.  The required structure is:
 	#
-	#	#define FS_MAX_KEY_SIZE 64
+	#	#define FSCRYPT_MAX_KEY_SIZE 64
 	#	struct fscrypt_key {
-	#		u32 mode;
-	#		u8 raw[FS_MAX_KEY_SIZE];
-	#		u32 size;
-	#	} __packed;
+	#		__u32 mode;
+	#		__u8 raw[FSCRYPT_MAX_KEY_SIZE];
+	#		__u32 size;
+	#	};
 	#
 	# The kernel ignores 'mode' but requires that 'size' be 64.
 	#
@@ -253,15 +275,8 @@ _add_session_encryption_key()
 	# nice to use the common key prefix, but for now use the filesystem-
 	# specific prefix to make it possible to test older kernels...
 	#
-	local big_endian=$(echo -ne '\x11' | od -tx2 | head -1 | \
-			   cut -f2 -d' ' | cut -c1 )
-	if (( big_endian )); then
-		local mode='\x00\x00\x00\x00'
-		local size='\x00\x00\x00\x40'
-	else
-		local mode='\x00\x00\x00\x00'
-		local size='\x40\x00\x00\x00'
-	fi
+	local mode=$(_num_to_hex 0 4)
+	local size=$(_num_to_hex 64 4)
 	echo -n -e "${mode}${raw}${size}" |
 		$KEYCTL_PROG padd logon $FSTYP:$keydesc @s >>$seqres.full
 }
@@ -389,6 +404,44 @@ _user_do_enckey_status()
 	_user_do "$XFS_IO_PROG -c \"enckey_status $* $keyspec\" \"$mnt\""
 }
 
+# Require support for adding a key to a filesystem's fscrypt keyring via an
+# "fscrypt-provisioning" keyring key.
+_require_add_enckey_by_key_id()
+{
+	local mnt=$1
+
+	# Userspace support
+	_require_xfs_io_command "add_enckey" "-k"
+
+	# Kernel support
+	if $XFS_IO_PROG -c "add_enckey -k 12345" "$mnt" \
+		|& grep -q 'Invalid argument'; then
+		_notrun "Kernel doesn't support key_id parameter to FS_IOC_ADD_ENCRYPTION_KEY"
+	fi
+}
+
+# Add a key of type "fscrypt-provisioning" to the session keyring and print the
+# resulting key ID.
+_add_fscrypt_provisioning_key()
+{
+	local desc=$1
+	local type=$2
+	local raw=$3
+
+	# The format of the key payload must be:
+	#
+	#	struct fscrypt_provisioning_key_payload {
+	#		__u32 type;
+	#		__u32 __reserved;
+	#		__u8 raw[];
+	#	};
+	#
+	local type_hex=$(_num_to_hex $type 4)
+	local reserved=$(_num_to_hex 0 4)
+	echo -n -e "${type_hex}${reserved}${raw}" |
+		$KEYCTL_PROG padd fscrypt-provisioning "$desc" @s
+}
+
 # Retrieve the encryption nonce of the given inode as a hex string.  The nonce
 # was randomly generated by the filesystem and isn't exposed directly to
 # userspace.  But it can be read using the filesystem's debugging tools.
@@ -717,6 +770,9 @@ FSCRYPT_MODE_ADIANTUM=9
 FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64=0x08
 
+FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR=1
+FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER=2
+
 _fscrypt_mode_name_to_num()
 {
 	local name=$1
diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100644
index 00000000..260bad89
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,155 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/806
+#
+# Test adding a key to a filesystem's fscrypt keyring via an
+# "fscrypt-provisioning" keyring key.  This is an alternative to the normal
+# method where the raw key is given directly.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_encryption -v 2
+_require_command "$KEYCTL_PROG" keyctl
+
+_new_session_keyring
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+_require_add_enckey_by_key_id $SCRATCH_MNT
+
+test_with_policy_version()
+{
+	local vers=$1
+	local dir=$SCRATCH_MNT/dir
+	local keyid
+
+	echo
+	echo "# =========================="
+	echo "# Test with policy version $vers"
+	echo "# =========================="
+
+	case $vers in
+	1)
+		local keytype=$FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR
+		local keyspec=$TEST_KEY_DESCRIPTOR
+		local add_enckey_args="-d $TEST_KEY_DESCRIPTOR"
+		;;
+	2)
+		local keytype=$FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER
+		local keyspec=$TEST_KEY_IDENTIFIER
+		local add_enckey_args=""
+		;;
+	*)
+		_fail "Unknown policy version: $vers"
+		;;
+	esac
+
+	# First add the key in the regular way (raw key given directly), create
+	# an encrypted file with some contents, and remove the key.  After this,
+	# the encrypted file should no longer be readable.
+
+	echo -e "\n# Adding key to filesystem"
+	_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" $add_enckey_args
+
+	echo -e "\n# Creating encrypted file"
+	mkdir $dir
+	_set_encpolicy $dir $keyspec
+	echo "contents" > $dir/file
+
+	echo -e "\n# Removing key from filesystem"
+	_rm_enckey $SCRATCH_MNT $keyspec
+	cat $dir/file |& _filter_scratch
+
+	# Now we should be able to add the key back via an fscrypt-provisioning
+	# key which contains the raw key, instead of providing the raw key
+	# directly.  After this, the encrypted file should be readable again.
+
+	echo -e "\n# Adding fscrypt-provisioning key"
+	keyid=$(_add_fscrypt_provisioning_key $keyspec $keytype "$TEST_RAW_KEY")
+
+	echo -e "\n# Adding key to filesystem via fscrypt-provisioning key"
+	$XFS_IO_PROG -c "add_enckey -k $keyid $add_enckey_args" $SCRATCH_MNT
+
+	echo -e "\n# Reading encrypted file"
+	cat $dir/file
+
+	echo -e "\n# Cleaning up"
+	rm -rf $dir
+	_scratch_cycle_mount	# Clear all keys
+}
+
+# Test with both v1 and v2 encryption policies.
+test_with_policy_version 1
+test_with_policy_version 2
+
+# Now test that invalid fscrypt-provisioning keys can't be created, that
+# fscrypt-provisioning keys can't be read back by userspace, and that the
+# filesystem only accepts properly matching fscrypt-provisioning keys.
+echo
+echo "# ================"
+echo "# Validation tests"
+echo "# ================"
+
+echo -e "\n# Adding an invalid fscrypt-provisioning key fails"
+echo "# ... bad type"
+_add_fscrypt_provisioning_key desc 0 "$TEST_RAW_KEY"
+echo "# ... bad type"
+_add_fscrypt_provisioning_key desc 10000 "$TEST_RAW_KEY"
+echo "# ... raw key too small"
+_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR ""
+echo "# ... raw key too large"
+_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR \
+	"$TEST_RAW_KEY$TEST_RAW_KEY"
+
+echo -e "\n# keyctl_read() doesn't work on fscrypt-provisioning keys"
+keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR \
+	"$TEST_RAW_KEY")
+$KEYCTL_PROG read $keyid
+$KEYCTL_PROG unlink $keyid @s
+
+echo -e "\n# Only keys with the correct fscrypt_provisioning_key_payload::type field can be added"
+echo "# ... keyring key is v1, filesystem wants v2 key"
+keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR \
+	"$TEST_RAW_KEY")
+$XFS_IO_PROG -c "add_enckey -k $keyid" $SCRATCH_MNT
+$KEYCTL_PROG unlink $keyid @s
+
+echo "# ... keyring key is v2, filesystem wants v1 key"
+keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER \
+	"$TEST_RAW_KEY")
+$XFS_IO_PROG -c "add_enckey -k $keyid -d $TEST_KEY_DESCRIPTOR" $SCRATCH_MNT
+$KEYCTL_PROG unlink $keyid @s
+
+echo -e "\n# Only keys of type fscrypt-provisioning can be added"
+keyid=$(head -c 64 /dev/urandom | $KEYCTL_PROG padd logon foo:desc @s)
+$XFS_IO_PROG -c "add_enckey -k $keyid" $SCRATCH_MNT
+$KEYCTL_PROG unlink $keyid @s
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 00000000..b7795f9a
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,73 @@
+QA output created by 806
+
+# ==========================
+# Test with policy version 1
+# ==========================
+
+# Adding key to filesystem
+Added encryption key with descriptor 0000111122223333
+
+# Creating encrypted file
+
+# Removing key from filesystem
+Removed encryption key with descriptor 0000111122223333
+cat: SCRATCH_MNT/dir/file: No such file or directory
+
+# Adding fscrypt-provisioning key
+
+# Adding key to filesystem via fscrypt-provisioning key
+Added encryption key with descriptor 0000111122223333
+
+# Reading encrypted file
+contents
+
+# Cleaning up
+
+# ==========================
+# Test with policy version 2
+# ==========================
+
+# Adding key to filesystem
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Creating encrypted file
+
+# Removing key from filesystem
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+cat: SCRATCH_MNT/dir/file: No such file or directory
+
+# Adding fscrypt-provisioning key
+
+# Adding key to filesystem via fscrypt-provisioning key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Reading encrypted file
+contents
+
+# Cleaning up
+
+# ================
+# Validation tests
+# ================
+
+# Adding an invalid fscrypt-provisioning key fails
+# ... bad type
+add_key: Invalid argument
+# ... bad type
+add_key: Invalid argument
+# ... raw key too small
+add_key: Invalid argument
+# ... raw key too large
+add_key: Invalid argument
+
+# keyctl_read() doesn't work on fscrypt-provisioning keys
+keyctl_read_alloc: Operation not supported
+
+# Only keys with the correct fscrypt_provisioning_key_payload::type field can be added
+# ... keyring key is v1, filesystem wants v2 key
+Error adding encryption key: Key was rejected by service
+# ... keyring key is v2, filesystem wants v1 key
+Error adding encryption key: Key was rejected by service
+
+# Only keys of type fscrypt-provisioning can be added
+Error adding encryption key: Key was rejected by service
diff --git a/tests/generic/group b/tests/generic/group
index 6fe62505..4706a2b4 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -595,3 +595,4 @@
 590 auto prealloc preallocrw
 591 auto quick rw pipe splice
 592 auto quick encrypt
+806 auto quick encrypt
-- 
2.25.0.341.g760bfbb309-goog

