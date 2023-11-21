Return-Path: <linux-fscrypt+bounces-9-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA38C7F3952
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 23:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F11B282ACE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Nov 2023 22:39:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD4556750;
	Tue, 21 Nov 2023 22:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sXQXyzKN"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB375647C;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E8EC433CB;
	Tue, 21 Nov 2023 22:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700606376;
	bh=pYU1tkf6u49fJVxTT4ymRr/9lbthF9F7CMVLaQ7bmkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXQXyzKN/IKhj0bNCiLffs10PRdL5IBsBSvWjTZaROYxXH6+53/GRWwr6DlBoxnp6
	 9gnXEEMCa44tM8L3fOD45ttlQCwT6KrWuE4gQGYr2FXJKEUhwdL4ldlr6LlZajoEuF
	 biTsbwMhRRclRvDhT8F1TLlMcbBnbRMdL6Dlk/b32pUz8zEAyD5uelUNofxbFgUrss
	 /PRHZpW9Bfb9b6JzmxaKbV9+pp+Do4/HT+l4QLrcVvdEy80ruQ8EqcJvFvcUlefHeg
	 pN49Cyn7om+mP87fMDM0IpFVRISv1RAcEwUUw6iqdCsgZanmLuJE7QbIfvhJlEkuXF
	 OSUSmOHyBuFGQ==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	Daniel Rosenberg <drosen@google.com>
Subject: [PATCH v2 3/4] common/encrypt: support custom data unit size
Date: Tue, 21 Nov 2023 14:39:08 -0800
Message-ID: <20231121223909.4617-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231121223909.4617-1-ebiggers@kernel.org>
References: <20231121223909.4617-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Make _require_scratch_encryption() and
_require_encryption_policy_support() support the new '-s' option to
set_encpolicy to specify a custom value of log2_data_unit_size.

Likewise, make _verify_ciphertext_for_encryption_policy() accept an
argument "log2_dusize=*" to cause it to use the specified data unit size
for the test and verify that the file contents are encrypted as expected
for that data unit size.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 5688745c..d90a566a 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -1,32 +1,41 @@
 ##/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2016 Google, Inc.  All Rights Reserved.
 #
 # Functions for setting up and testing file encryption
 
 #
 # _require_scratch_encryption [-c CONTENTS_MODE] [-n FILENAMES_MODE]
 #			      [-f POLICY_FLAGS] [-v POLICY_VERSION]
+#			      [-s LOG2_DUSIZE]
 #
 # Require encryption support on the scratch device.
 #
 # This checks for support for the default type of encryption policy (v1 with
 # AES-256-XTS and AES-256-CTS).  Options can be specified to also require
 # support for a different type of encryption policy.
 #
 _require_scratch_encryption()
 {
-	_require_scratch
+	local arg
 
+	_require_scratch
 	_require_xfs_io_command "set_encpolicy"
 
+	for arg; do
+		if [ "$arg" = "-s" ]; then
+			# -s option was added later.  Make sure it's available.
+			_require_xfs_io_command "set_encpolicy" "-s"
+		fi
+	done
+
 	# The 'test_dummy_encryption' mount option interferes with trying to use
 	# encryption for real, even if we are just trying to get/set policies
 	# and never put any keys in the keyring.  So skip the real encryption
 	# tests if the 'test_dummy_encryption' mount option was specified.
 	_exclude_scratch_mount_option "test_dummy_encryption"
 
 	# Make a filesystem on the scratch device with the encryption feature
 	# enabled.  If this fails then probably the userspace tools (e.g.
 	# e2fsprogs or f2fs-tools) are too old to understand encryption.
 	if ! _scratch_mkfs_encrypted &>>$seqres.full; then
@@ -67,35 +76,35 @@ _require_scratch_encryption()
 _require_encryption_policy_support()
 {
 	local mnt=$1
 	local dir=$mnt/tmpdir
 	local set_encpolicy_args=""
 	local policy_flags=0
 	local policy_version=1
 	local c
 
 	OPTIND=2
-	while getopts "c:n:f:v:" c; do
+	while getopts "c:n:f:s:v:" c; do
 		case $c in
-		c|n)
+		c|n|s)
 			set_encpolicy_args+=" -$c $OPTARG"
 			;;
 		f)
 			set_encpolicy_args+=" -$c $OPTARG"
 			policy_flags=$OPTARG
 			;;
 		v)
 			set_encpolicy_args+=" -$c $OPTARG"
 			policy_version=$OPTARG
 			;;
 		*)
-			_fail "Unrecognized option '$c'"
+			_fail "${FUNCNAME[0]}: unrecognized option '$c'"
 			;;
 		esac
 	done
 	set_encpolicy_args=${set_encpolicy_args# }
 
 	echo "Checking whether kernel supports encryption policy: $set_encpolicy_args" \
 		>> $seqres.full
 
 	if (( policy_flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) )); then
@@ -756,28 +765,27 @@ _do_verify_ciphertext_for_encryption_policy()
 
 	# Now unmount the filesystem and verify the ciphertext we just wrote.
 	_scratch_unmount
 
 	echo "Verifying encrypted file contents" >> $seqres.full
 	for f in "${test_contents_files[@]}"; do
 		read -r src inode blocklist <<< "$f"
 		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
 		_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
-			--file-nonce=$nonce --data-unit-size=$blocksize \
-			--inode-number=$inode < $src > $tmp.expected_contents
+			--file-nonce=$nonce --inode-number=$inode \
+                        < $src > $tmp.expected_contents
 		if ! cmp $tmp.expected_contents $tmp.actual_contents; then
 			_fail "Expected encrypted contents != actual encrypted contents.  File: $f"
 		fi
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
-			--decrypt --file-nonce=$nonce \
-                        --data-unit-size=$blocksize --inode-number=$inode \
+			--decrypt --file-nonce=$nonce --inode-number=$inode \
 			< $tmp.actual_contents > $tmp.decrypted_contents
 		if ! cmp $src $tmp.decrypted_contents; then
 			_fail "Contents decryption sanity check failed.  File: $f"
 		fi
 	done
 
 	echo "Verifying encrypted file names" >> $seqres.full
 	for f in "${test_filenames_files[@]}"; do
 		read -r name inode dir_inode padding <<< "$f"
 		nonce=$(_get_encryption_nonce $SCRATCH_DEV $dir_inode)
@@ -837,28 +845,30 @@ _fscrypt_mode_name_to_num()
 # policy of the specified type is used.
 #
 # The first two parameters are the contents and filenames encryption modes to
 # test.  The following optional parameters are also accepted to further modify
 # the type of encryption policy that is tested:
 #
 #	'v2':			test a v2 encryption policy
 #	'direct':		test the DIRECT_KEY policy flag
 #	'iv_ino_lblk_64':	test the IV_INO_LBLK_64 policy flag
 #	'iv_ino_lblk_32':	test the IV_INO_LBLK_32 policy flag
+#	'log2_dusize=N':        test the log2_data_unit_size field
 #
 _verify_ciphertext_for_encryption_policy()
 {
 	local contents_encryption_mode=$1
 	local filenames_encryption_mode=$2
 	local opt
 	local policy_version=1
 	local policy_flags=0
+	local log2_dusize=0
 	local set_encpolicy_args=""
 	local crypt_util_args=""
 	local crypt_util_contents_args=""
 	local crypt_util_filename_args=""
 	local expected_identifier
 
 	shift 2
 	for opt; do
 		case "$opt" in
 		v2)
@@ -870,30 +880,36 @@ _verify_ciphertext_for_encryption_policy()
 				_fail "For direct key mode, contents and filenames modes must match"
 			fi
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_DIRECT_KEY ))
 			;;
 		iv_ino_lblk_64)
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 ))
 			;;
 		iv_ino_lblk_32)
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 ))
 			;;
+		log2_dusize=*)
+			log2_dusize=$(echo "$opt" | sed 's/^log2_dusize=//')
+			;;
 		*)
 			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
 			;;
 		esac
 	done
 	local contents_mode_num=$(_fscrypt_mode_name_to_num $contents_encryption_mode)
 	local filenames_mode_num=$(_fscrypt_mode_name_to_num $filenames_encryption_mode)
 
 	set_encpolicy_args+=" -c $contents_mode_num"
 	set_encpolicy_args+=" -n $filenames_mode_num"
+	if (( log2_dusize != 0 )); then
+		set_encpolicy_args+=" -s $log2_dusize"
+	fi
 	crypt_util_contents_args+=" --mode-num=$contents_mode_num"
 	crypt_util_filename_args+=" --mode-num=$filenames_mode_num"
 
 	if (( policy_version > 1 )); then
 		set_encpolicy_args+=" -v 2"
 		crypt_util_args+=" --kdf=HKDF-SHA512"
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			crypt_util_args+=" --direct-key"
 		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
 			crypt_util_args+=" --iv-ino-lblk-64"
@@ -923,20 +939,26 @@ _verify_ciphertext_for_encryption_policy()
 
 	echo "Creating encryption-capable filesystem" >> $seqres.full
 	if (( policy_flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
 			      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) )); then
 		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
 	else
 		_scratch_mkfs_encrypted &>> $seqres.full
 	fi
 	_scratch_mount
 
+	if (( log2_dusize != 0 )); then
+		crypt_util_contents_args+=" --data-unit-size=$((1 << log2_dusize))"
+	else
+		crypt_util_contents_args+=" --data-unit-size=$(_get_block_size $SCRATCH_MNT)"
+	fi
+
 	crypt_util_args+=" --fs-uuid=$(blkid -s UUID -o value $SCRATCH_DEV | tr -d -)"
 
 	crypt_util_contents_args+="$crypt_util_args"
 	crypt_util_filename_args+="$crypt_util_args"
 
 	echo "Generating encryption key" >> $seqres.full
 	local raw_key=$(_generate_raw_encryption_key)
 	if (( policy_version > 1 )); then
 		local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" \
 				| awk '{print $NF}')
-- 
2.42.1


