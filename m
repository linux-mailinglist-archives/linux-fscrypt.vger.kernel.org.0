Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3457C7D9A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjJMGRg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJMGRf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:17:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41424BE;
        Thu, 12 Oct 2023 23:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1FBC433CA;
        Fri, 13 Oct 2023 06:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697177851;
        bh=rcgUik+zlUAo8DAdhC6ZivfgGSEeA8EG8rAoKMEfK74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GST7ve5RWYVs76Mj56KLnPr0y2rlEYba3B4mMfPsUk/lhEkQKAK7123FtD/Bd1UNs
         232kMSKVl8Ua7erFXXocvWIOU0iquT7VcGT+gz0o49Yz3qf4yEl1XIWD2/aVLQx7H9
         71WLRhw8lfSaU4nzH3mvSWSP/vxjaKletL4lDOwaGk+cak9dzoWECrHZ9TcWqC/Xn/
         9QGaUJ+MZ15wAqqkKZWrM2aqmA0dqH/qUyRx4gQ/aRQa2HzpEuecApEZYX5Eh4Worb
         j6fctxtHyPxe0CSQdfFhoilPJkziompDPeYKlVUBuutZnSU5KXNvlIL9mrygQ0NE85
         u50GOfZOyXBeg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 3/4] common/encrypt: support custom data unit size
Date:   Thu, 12 Oct 2023 23:14:02 -0700
Message-ID: <20231013061403.138425-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231013061403.138425-1-ebiggers@kernel.org>
References: <20231013061403.138425-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
2.42.0

