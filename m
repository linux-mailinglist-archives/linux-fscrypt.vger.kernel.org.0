Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67584C6405
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiB1Htf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbiB1Hte (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924263D1EE;
        Sun, 27 Feb 2022 23:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EC12610A1;
        Mon, 28 Feb 2022 07:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D994CC340F5;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034535;
        bh=rqA/l3I5m4OBXf1eHf/RwStmBflVY6DtAmuwtrEw/5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prgicrLAfOZTl8nCZnaRWFpJseTYxq/jQdII8MIynAeCRB5TVtnWM5AKvWUgBPrvI
         JzMuprzehMwDDeHvtdi0JU/l5Mdxc5vFHnIs9rv0LCnNYZ4uylvqamFB8lYZe59uCX
         4URD5bfAqxlOHC2ENciizA2ly1tZh3GETTS/AAaYKakvTftM4Zf9MLwZFu6lR79JG4
         TpC1OMEObBUdAWIeQEkVeIpDM+9X6ommJBGHrV5kb92icjGgEQhkUJItthOieBloXF
         HIMgFRDATFF+IrbKcYn2AtLOk7gwl3qxS/96B/cSHlaMM4w4K+vcI9yArLLu9Kw9Wk
         05TOcjQ1C4fXg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 7/8] common/encrypt: support hardware-wrapped key testing
Date:   Sun, 27 Feb 2022 23:47:21 -0800
Message-Id: <20220228074722.77008-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228074722.77008-1-ebiggers@kernel.org>
References: <20220228074722.77008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

To support testing the kernel's support for hardware-wrapped inline
encryption keys, add some new functions to common/encrypt:

  - _require_hw_wrapped_key_support(): Checks that a block device
    supports hardware-wrapped keys and that some related fscryptctl
    commands are present.

  - _require_scratch_inlinecrypt(): Checks that the filesystem accepts
    the inlinecrypt mount option.

  - _generate_raw_hw_key(): Generates a raw key of an appropriate size
    for importing as a hardware-wrapped key.

  - _add_hw_wrapped_key(): Imports and prepares a hardware-wrapped key,
    then adds it to a filesystem.

In addition, update _require_encryption_policy_support() and
_verify_ciphertext_for_encryption_policy() to support
FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY.

Note: some of this relies on being able to call new block device ioctls.
For now these are accessed through the fscryptctl program.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config  |   1 +
 common/encrypt | 116 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 106 insertions(+), 11 deletions(-)

diff --git a/common/config b/common/config
index 479e50d1..85a7919c 100644
--- a/common/config
+++ b/common/config
@@ -228,6 +228,7 @@ export E2IMAGE_PROG="$(type -P e2image)"
 export BLKZONE_PROG="$(type -P blkzone)"
 export GZIP_PROG="$(type -P gzip)"
 export BTRFS_IMAGE_PROG="$(type -P btrfs-image)"
+export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/encrypt b/common/encrypt
index d8e2dba9..e91e05c4 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -58,22 +58,21 @@ _require_scratch_encryption()
 	# If required, check for support for the specific type of encryption
 	# policy required by the test.
 	if [ $# -ne 0 ]; then
-		_require_encryption_policy_support $SCRATCH_MNT "$@"
+		_require_scratch_encryption_policy_support "$@"
 	fi
 
 	_scratch_unmount
 }
 
-_require_encryption_policy_support()
+_require_scratch_encryption_policy_support()
 {
-	local mnt=$1
-	local dir=$mnt/tmpdir
+	local dir=$SCRATCH_MNT/tmpdir
 	local set_encpolicy_args=""
 	local policy_flags=0
 	local policy_version=1
 	local c
 
-	OPTIND=2
+	OPTIND=1
 	while getopts "c:n:f:v:" c; do
 		case $c in
 		c|n)
@@ -94,6 +93,12 @@ _require_encryption_policy_support()
 	done
 	set_encpolicy_args=${set_encpolicy_args# }
 
+	if (( policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY )); then
+		echo "Checking whether $SCRATCH_DEV supports hardware-wrapped keys" \
+			>> $seqres.full
+		_require_hw_wrapped_key_support $SCRATCH_DEV
+	fi
+
 	echo "Checking whether kernel supports encryption policy: $set_encpolicy_args" \
 		>> $seqres.full
 
@@ -117,8 +122,15 @@ _require_encryption_policy_support()
 		# Both the kernel and xfs_io support v2 encryption policies, and
 		# therefore also filesystem-level keys -- since that's the only
 		# way to provide keys for v2 policies.
-		local raw_key=$(_generate_raw_encryption_key)
-		local keyspec=$(_add_enckey $mnt "$raw_key" | awk '{print $NF}')
+		if (( policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY )); then
+			local raw_key=$(_generate_raw_hw_key)
+			local keyspec=$(_add_hw_wrapped_key $SCRATCH_DEV \
+					$SCRATCH_MNT "$raw_key")
+		else
+			local raw_key=$(_generate_raw_encryption_key)
+			local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | \
+					awk '{print $NF}')
+		fi
 	else
 		_require_command "$KEYCTL_PROG" keyctl
 		_new_session_keyring
@@ -143,6 +155,47 @@ _require_encryption_policy_support()
 	rm -r $dir
 }
 
+# Require that the filesystem accepts the "inlinecrypt" mount option.
+#
+# Note: this doesn't check whether $SCRATCH_DEV has any specific inline
+# encryption capabilities.  For encryption policies that require specific
+# capabilities, support is detected later by
+# _require_scratch_encryption_policy_support() (provided that inlinecrypt has
+# been added to $MOUNT_OPTIONS by that point).
+_require_scratch_inlinecrypt()
+{
+	_require_scratch
+	_scratch_mkfs &>> $seqres.full
+	if ! _try_scratch_mount -o inlinecrypt &>> $seqres.full; then
+		_notrun "filesystem doesn't support -o inlinecrypt"
+	fi
+}
+
+# Require that the given block device supports hardware-wrapped inline
+# encryption keys, and require that a command-line tool that supports
+# importing/generating/preparing them is available.
+_require_hw_wrapped_key_support()
+{
+	local dev=$1
+
+	_require_command "$FSCRYPTCTL_PROG" fscryptctl
+	if ! "$FSCRYPTCTL_PROG" --help | grep -q "import_hw_wrapped_key"; then
+		_notrun "fscryptctl too old; doesn't support hardware-wrapped inline encryption keys"
+	fi
+
+	if ! head -c $RAW_HW_KEY_SIZE /dev/urandom | \
+		"$FSCRYPTCTL_PROG" import_hw_wrapped_key "$dev" \
+		>/dev/null 2>$tmp.err
+	then
+		if grep -E -q \
+			"(Operation not supported)|(Inappropriate ioctl for device)" $tmp.err
+		then
+			_notrun "$dev doesn't support hardware-wrapped inline encryption keys"
+		fi
+		_fail "Unexpected error from fscryptctl import_hw_wrapped_key: $(< $tmp.err)"
+	fi
+}
+
 _scratch_mkfs_encrypted()
 {
 	case $FSTYP in
@@ -220,14 +273,24 @@ _generate_key_descriptor()
 # Generate a raw encryption key, but don't add it to any keyring yet.
 _generate_raw_encryption_key()
 {
+	local size=${1:-64}
 	local raw=""
 	local i
-	for ((i = 0; i < 64; i++)); do
+	for ((i = 0; i < $size; i++)); do
 		raw="${raw}\\x$(printf "%02x" $(( $RANDOM % 256 )))"
 	done
 	echo $raw
 }
 
+RAW_HW_KEY_SIZE=32
+
+# Generate a raw key of the proper size to be imported as a hardware-wrapped
+# key.
+_generate_raw_hw_key()
+{
+	_generate_raw_encryption_key $RAW_HW_KEY_SIZE
+}
+
 # Serialize an integer into a CPU-endian bytestring of the given length, and
 # print it as a string where each byte is hex-escaped.  For example,
 # `_num_to_hex 1000 4` == "\xe8\x03\x00\x00" if the CPU is little endian.
@@ -358,6 +421,21 @@ _add_enckey()
 	echo -ne "$raw_key" | $XFS_IO_PROG -c "add_enckey $*" "$mnt"
 }
 
+# Create a hardware-wrapped key from the given raw key using the given block
+# device, add it to the given filesystem, and print the resulting key
+# identifier.
+_add_hw_wrapped_key()
+{
+	local dev=$1
+	local mnt=$2
+	local raw_key=$3
+
+	echo -ne "$raw_key" | \
+		$FSCRYPTCTL_PROG import_hw_wrapped_key "$dev" | \
+		$FSCRYPTCTL_PROG prepare_hw_wrapped_key "$dev" | \
+		$FSCRYPTCTL_PROG add_key --hw-wrapped-key "$mnt"
+}
+
 _user_do_add_enckey()
 {
 	local mnt=$1
@@ -771,6 +849,7 @@ FSCRYPT_MODE_ADIANTUM=9
 FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64=0x08
 FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32=0x10
+FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY=0x20
 
 FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR=1
 FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER=2
@@ -800,6 +879,7 @@ _fscrypt_mode_name_to_num()
 #	'direct':		test the DIRECT_KEY policy flag
 #	'iv_ino_lblk_64':	test the IV_INO_LBLK_64 policy flag
 #	'iv_ino_lblk_32':	test the IV_INO_LBLK_32 policy flag
+#	'hw_wrapped_key':	test the HW_WRAPPED_KEY policy flag
 #
 _verify_ciphertext_for_encryption_policy()
 {
@@ -832,6 +912,9 @@ _verify_ciphertext_for_encryption_policy()
 		iv_ino_lblk_32)
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 ))
 			;;
+		hw_wrapped_key)
+			(( policy_flags |= FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY ))
+			;;
 		*)
 			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
 			;;
@@ -855,6 +938,10 @@ _verify_ciphertext_for_encryption_policy()
 		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 )); then
 			crypt_util_args+=" --iv-ino-lblk-32"
 		fi
+		if (( policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY )); then
+			crypt_util_args+=" --enable-hw-kdf"
+			crypt_util_contents_args+=" --use-inlinecrypt-key"
+		fi
 	else
 		if (( policy_flags & ~FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			_fail "unsupported flags for v1 policy: $policy_flags"
@@ -891,11 +978,18 @@ _verify_ciphertext_for_encryption_policy()
 	crypt_util_filename_args+="$crypt_util_args"
 
 	echo "Generating encryption key" >> $seqres.full
-	local raw_key=$(_generate_raw_encryption_key)
 	if (( policy_version > 1 )); then
-		local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" \
-				| awk '{print $NF}')
+		if (( policy_flags & FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY )); then
+			local raw_key=$(_generate_raw_hw_key)
+			local keyspec=$(_add_hw_wrapped_key $SCRATCH_DEV \
+					$SCRATCH_MNT "$raw_key")
+		else
+			local raw_key=$(_generate_raw_encryption_key)
+			local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" | \
+					awk '{print $NF}')
+		fi
 	else
+		local raw_key=$(_generate_raw_encryption_key)
 		local keyspec=$(_generate_key_descriptor)
 		_new_session_keyring
 		_add_session_encryption_key $keyspec $raw_key
-- 
2.35.1

