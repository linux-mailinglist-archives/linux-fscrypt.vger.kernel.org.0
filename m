Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9573F4F7607
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Apr 2022 08:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiDGG3t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 Apr 2022 02:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbiDGG3n (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 Apr 2022 02:29:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B251F6F1E;
        Wed,  6 Apr 2022 23:27:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 269E7B826BA;
        Thu,  7 Apr 2022 06:27:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0024C385A0;
        Thu,  7 Apr 2022 06:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649312858;
        bh=xcdVpo6ltGZLhmyOE7gv5pmYl+o/OML94L3IQrWg6M0=;
        h=From:To:Cc:Subject:Date:From;
        b=TrqfLsDAi5O/ZKeYHpuE5IKOv1UCFrADMaO6Waj4fhgoVa2r82/NTiwWgDeIlJolf
         FoOJ2rnya0UmwpvF8igZn3zwZxjdHpdomLZ7wQRW3kl975EpTdPog/oq0IfkqvHNXJ
         BonDl1dRITa7BR0nWM3Zvtzs7SKN0BhW6L526aZQqiPEWcuFN1kRrmLAppw4aKgygv
         Sml2Tq6kwnZKSmd4XQ4+2O12uXGk1TElJ4yLnwvvOzpOjC7iBatUxcRUJ96zl6pqKa
         z0hOkBMSlD9agBDwgE4/UwGN2UyeUxHAFZyDqeMoASt1TSG8Ja8lLV6bVNyyqzZ0Ig
         WG+a6iljQ04dQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [xfstests PATCH] common/encrypt: use a sub-keyring within the session keyring
Date:   Wed,  6 Apr 2022 23:26:21 -0700
Message-Id: <20220407062621.346777-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make the encryption tests create and use a named keyring "xfstests" in
the session keyring that the tests happen to be running under, rather
than replace the session keyring using 'keyctl new_session'.
Unfortunately, the latter doesn't work when the session keyring is owned
by a non-root user, which (depending on the Linux distro) can happen if
xfstests is run in a sudo "session" rather than in a real root session.

This isn't a great solution, as the lifetime of the keyring will no
longer be tied to the tests as it should be, but it should work.  The
alternative would be the weird hack of making the 'check' script
re-execute itself using something like 'keyctl session - $0 $@'.

Reported-by: Ritesh Harjani <ritesh.list@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt    | 55 ++++++++++++++++++++++++++++++++++-------------
 tests/ext4/024    |  2 +-
 tests/generic/397 |  2 +-
 tests/generic/398 |  2 +-
 tests/generic/399 |  2 +-
 tests/generic/419 |  2 +-
 tests/generic/421 |  2 +-
 tests/generic/429 |  2 +-
 tests/generic/435 |  2 +-
 tests/generic/440 |  2 +-
 tests/generic/576 |  2 +-
 tests/generic/593 | 13 +++++------
 12 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index f90c4ef0..69faf641 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -121,7 +121,7 @@ _require_encryption_policy_support()
 		local keyspec=$(_add_enckey $mnt "$raw_key" | awk '{print $NF}')
 	else
 		_require_command "$KEYCTL_PROG" keyctl
-		_new_session_keyring
+		_init_session_keyring
 		local keyspec=$(_generate_session_encryption_key)
 	fi
 	if _set_encpolicy $dir $keyspec $set_encpolicy_args \
@@ -138,7 +138,7 @@ _require_encryption_policy_support()
 		_notrun "encryption policy '$set_encpolicy_args' is unusable; probably missing kernel crypto API support"
 	fi
 	if (( policy_version <= 1 )); then
-		$KEYCTL_PROG clear @s
+		$KEYCTL_PROG clear $TEST_KEYRING_ID
 	fi
 	rm -r $dir
 }
@@ -199,11 +199,30 @@ TEST_KEY_DESCRIPTOR="0000111122223333"
 # Key identifier: HKDF-SHA512(key=$TEST_RAW_KEY, salt="", info="fscrypt\0\x01")
 TEST_KEY_IDENTIFIER="69b2f6edeee720cce0577937eb8a6751"
 
-# Give the invoking shell a new session keyring.  This makes any keys we add to
-# the session keyring scoped to the lifetime of the test script.
-_new_session_keyring()
+# This is the ID of the keyring that was created by _init_session_keyring().
+# You must call _init_session_keyring() before using this.
+TEST_KEYRING_ID=
+
+# Create a test keyring within the session keyring.  Keys added to this keyring
+# will be available within the test script and all its subprocesses.  If the
+# test keyring already exists, then it is replaced.
+#
+# This used to use 'keyctl new_session' to replace the session keyring itself.
+# However, that doesn't work if a non-root user owns the session keyring.
+_init_session_keyring()
 {
-	$KEYCTL_PROG new_session >>$seqres.full
+	TEST_KEYRING_ID=$($KEYCTL_PROG newring xfstests @s)
+	if [ -z "$TEST_KEYRING_ID" ]; then
+		_fail "Failed to create test keyring in session keyring"
+	fi
+}
+
+# Check that _init_session_keyring() has been called.
+_check_session_keyring()
+{
+	if [ -z "$TEST_KEYRING_ID" ]; then
+		_fail "_init_session_keyring() must be called before using the test keyring"
+	fi
 }
 
 # Generate a key descriptor (16 character hex string)
@@ -257,6 +276,8 @@ _add_session_encryption_key()
 	local keydesc=$1
 	local raw=$2
 
+	_check_session_keyring
+
 	#
 	# Add the key to the session keyring.  The required structure is:
 	#
@@ -279,14 +300,14 @@ _add_session_encryption_key()
 	local mode=$(_num_to_hex 0 4)
 	local size=$(_num_to_hex 64 4)
 	echo -n -e "${mode}${raw}${size}" |
-		$KEYCTL_PROG padd logon $FSTYP:$keydesc @s >>$seqres.full
+		$KEYCTL_PROG padd logon $FSTYP:$keydesc $TEST_KEYRING_ID \
+			>>$seqres.full
 }
 
 #
 # Generate a random encryption key, add it to the session keyring, and print out
 # the resulting key descriptor (example: "8bf798e1a494e1ec").  Requires the
-# keyctl program.  It's assumed the caller has already set up a test-scoped
-# session keyring using _new_session_keyring.
+# keyctl program and that _init_session_keyring() has been called.
 #
 _generate_session_encryption_key()
 {
@@ -301,16 +322,18 @@ _generate_session_encryption_key()
 # Unlink an encryption key from the session keyring, given its key descriptor.
 _unlink_session_encryption_key()
 {
+	_check_session_keyring
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local keyid=$($KEYCTL_PROG search $TEST_KEYRING_ID logon $FSTYP:$keydesc)
 	$KEYCTL_PROG unlink $keyid >>$seqres.full
 }
 
 # Revoke an encryption key from the session keyring, given its key descriptor.
 _revoke_session_encryption_key()
 {
+	_check_session_keyring
 	local keydesc=$1
-	local keyid=$($KEYCTL_PROG search @s logon $FSTYP:$keydesc)
+	local keyid=$($KEYCTL_PROG search $TEST_KEYRING_ID logon $FSTYP:$keydesc)
 	$KEYCTL_PROG revoke $keyid >>$seqres.full
 }
 
@@ -429,6 +452,8 @@ _add_fscrypt_provisioning_key()
 	local type=$2
 	local raw=$3
 
+	_check_session_keyring
+
 	# The format of the key payload must be:
 	#
 	#	struct fscrypt_provisioning_key_payload {
@@ -440,7 +465,7 @@ _add_fscrypt_provisioning_key()
 	local type_hex=$(_num_to_hex $type 4)
 	local reserved=$(_num_to_hex 0 4)
 	echo -n -e "${type_hex}${reserved}${raw}" |
-		$KEYCTL_PROG padd fscrypt-provisioning "$desc" @s
+		$KEYCTL_PROG padd fscrypt-provisioning "$desc" $TEST_KEYRING_ID
 }
 
 # Retrieve the encryption nonce of the given inode as a hex string.  The nonce
@@ -604,7 +629,7 @@ _require_get_ciphertext_filename_support()
 		_require_command "$DUMP_F2FS_PROG" dump.f2fs
 		_require_command "$KEYCTL_PROG" keyctl
 		_scratch_mount
-		_new_session_keyring
+		_init_session_keyring
 
 		local keydesc=$(_generate_session_encryption_key)
 		local dir=$SCRATCH_MNT/test.${FUNCNAME[0]}
@@ -615,7 +640,7 @@ _require_get_ciphertext_filename_support()
 		local inode=$(stat -c %i $file)
 
 		_scratch_unmount
-		$KEYCTL_PROG clear @s
+		$KEYCTL_PROG clear $TEST_KEYRING_ID
 
 		# 255-character filename should result in 340 base64 characters.
 		if ! $DUMP_F2FS_PROG -i $inode $SCRATCH_DEV \
@@ -899,7 +924,7 @@ _verify_ciphertext_for_encryption_policy()
 				| awk '{print $NF}')
 	else
 		local keyspec=$(_generate_key_descriptor)
-		_new_session_keyring
+		_init_session_keyring
 		_add_session_encryption_key $keyspec $raw_key
 	fi
 	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
diff --git a/tests/ext4/024 b/tests/ext4/024
index 116adca9..11b335f0 100755
--- a/tests/ext4/024
+++ b/tests/ext4/024
@@ -18,7 +18,7 @@ _supported_fs ext4
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 
-_new_session_keyring
+_init_session_keyring
 
 #
 # Create an encrypted file whose size is not a multiple of the filesystem block
diff --git a/tests/generic/397 b/tests/generic/397
index 5ff65cd9..6c03f274 100755
--- a/tests/generic/397
+++ b/tests/generic/397
@@ -23,7 +23,7 @@ _require_symlinks
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 
-_new_session_keyring
+_init_session_keyring
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/398 b/tests/generic/398
index 506513c1..e2cbad54 100755
--- a/tests/generic/398
+++ b/tests/generic/398
@@ -24,7 +24,7 @@ _supported_fs generic
 _require_scratch_encryption
 _require_renameat2 exchange
 
-_new_session_keyring
+_init_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
diff --git a/tests/generic/399 b/tests/generic/399
index 55f07ae5..a5aa7107 100755
--- a/tests/generic/399
+++ b/tests/generic/399
@@ -30,7 +30,7 @@ _require_symlinks
 _require_command "$XZ_PROG" xz
 _require_command "$KEYCTL_PROG" keyctl
 
-_new_session_keyring
+_init_session_keyring
 
 #
 # Set up a small filesystem containing an encrypted directory.  64 MB is enough
diff --git a/tests/generic/419 b/tests/generic/419
index 6be7865c..5d56d64f 100755
--- a/tests/generic/419
+++ b/tests/generic/419
@@ -24,7 +24,7 @@ _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 _require_renameat2 exchange
 
-_new_session_keyring
+_init_session_keyring
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/421 b/tests/generic/421
index 04462d17..0c4fa8e3 100755
--- a/tests/generic/421
+++ b/tests/generic/421
@@ -20,7 +20,7 @@ _supported_fs generic
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
 
-_new_session_keyring
+_init_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
diff --git a/tests/generic/429 b/tests/generic/429
index 558e93ca..2cf12316 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -35,7 +35,7 @@ _require_test_program "t_encrypted_d_revalidate"
 # Set up an encrypted directory
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
-_new_session_keyring
+_init_session_keyring
 keydesc=$(_generate_key_descriptor)
 raw_key=$(_generate_raw_encryption_key)
 mkdir $SCRATCH_MNT/edir
diff --git a/tests/generic/435 b/tests/generic/435
index 031e43cc..bb1cbb62 100755
--- a/tests/generic/435
+++ b/tests/generic/435
@@ -29,7 +29,7 @@ _require_command "$KEYCTL_PROG" keyctl
 
 # set up an encrypted directory
 
-_new_session_keyring
+_init_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 mkdir $SCRATCH_MNT/edir
diff --git a/tests/generic/440 b/tests/generic/440
index f445a386..5850a8fe 100755
--- a/tests/generic/440
+++ b/tests/generic/440
@@ -25,7 +25,7 @@ _require_symlinks
 _require_command "$KEYCTL_PROG" keyctl
 
 # Set up an encryption-capable filesystem and an encryption key.
-_new_session_keyring
+_init_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 keydesc=$(_generate_key_descriptor)
diff --git a/tests/generic/576 b/tests/generic/576
index 82fbdd71..3ef04953 100755
--- a/tests/generic/576
+++ b/tests/generic/576
@@ -38,7 +38,7 @@ edir=$SCRATCH_MNT/edir
 fsv_file=$edir/file.fsv
 
 # Set up an encrypted directory.
-_new_session_keyring
+_init_session_keyring
 keydesc=$(_generate_session_encryption_key)
 mkdir $edir
 _set_encpolicy $edir $keydesc
diff --git a/tests/generic/593 b/tests/generic/593
index f0610c57..2dda5d76 100755
--- a/tests/generic/593
+++ b/tests/generic/593
@@ -20,7 +20,7 @@ _supported_fs generic
 _require_scratch_encryption -v 2
 _require_command "$KEYCTL_PROG" keyctl
 
-_new_session_keyring
+_init_session_keyring
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 _require_add_enckey_by_key_id $SCRATCH_MNT
@@ -113,25 +113,26 @@ echo -e "\n# keyctl_read() doesn't work on fscrypt-provisioning keys"
 keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR \
 	"$TEST_RAW_KEY")
 $KEYCTL_PROG read $keyid
-$KEYCTL_PROG unlink $keyid @s
+$KEYCTL_PROG unlink $keyid $TEST_KEYRING_ID
 
 echo -e "\n# Only keys with the correct fscrypt_provisioning_key_payload::type field can be added"
 echo "# ... keyring key is v1, filesystem wants v2 key"
 keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR \
 	"$TEST_RAW_KEY")
 $XFS_IO_PROG -c "add_enckey -k $keyid" $SCRATCH_MNT
-$KEYCTL_PROG unlink $keyid @s
+$KEYCTL_PROG unlink $keyid $TEST_KEYRING_ID
 
 echo "# ... keyring key is v2, filesystem wants v1 key"
 keyid=$(_add_fscrypt_provisioning_key desc $FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER \
 	"$TEST_RAW_KEY")
 $XFS_IO_PROG -c "add_enckey -k $keyid -d $TEST_KEY_DESCRIPTOR" $SCRATCH_MNT
-$KEYCTL_PROG unlink $keyid @s
+$KEYCTL_PROG unlink $keyid $TEST_KEYRING_ID
 
 echo -e "\n# Only keys of type fscrypt-provisioning can be added"
-keyid=$(head -c 64 /dev/urandom | $KEYCTL_PROG padd logon foo:desc @s)
+keyid=$(head -c 64 /dev/urandom | \
+	$KEYCTL_PROG padd logon foo:desc $TEST_KEYRING_ID)
 $XFS_IO_PROG -c "add_enckey -k $keyid" $SCRATCH_MNT
-$KEYCTL_PROG unlink $keyid @s
+$KEYCTL_PROG unlink $keyid $TEST_KEYRING_ID
 
 # success, all done
 status=0

base-commit: 1ae79d2ecdac6f9ad94a660eca3d7586e34d7d6b
-- 
2.35.1

