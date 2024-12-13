Return-Path: <linux-fscrypt+bounces-570-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D05F99F043A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 06:29:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A49B8188ABE3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Dec 2024 05:29:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C931818873F;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OuMLih/+"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A057D1684AC;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067736; cv=none; b=ALUWc77fTZip2t7/hQeukkfaMnA5D8XMp8ytorwlEw8sQoVJgrK25LpKXLToqzxjgeG6rzimrwsw8P/y+ieuICC0ontzaNbVX4EvjeJyzu84vXz86i5ZzVPCXLFE4XIbXND23g0Kbfr8OcfWVubV8eYL6LmOpjhX9pZ8vZ7t3jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067736; c=relaxed/simple;
	bh=KhZZX0QH8y/SjG56Xj6WzianHbNyw3Wx43N5KCDD9JI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNIVICCFF8WF6w9FmsIz7aOfED+gGzW9AO9fyxujtKiu9qo9m2sLQLfmiaApFDg9cWgpyqU16JxqWAxC1cbuLRspWuNj6GJaJ2xVu0IQA3InOTMOKZ54kAgqjhrn2XJTL3hqhvQwmNnCuB4Ftz8B+lisYIjiNPcQ5cCSFOY70eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OuMLih/+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3118EC4CED7;
	Fri, 13 Dec 2024 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734067736;
	bh=KhZZX0QH8y/SjG56Xj6WzianHbNyw3Wx43N5KCDD9JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuMLih/+A2gexeeS3Kqq8i6ExUAXxdhiOGmisbrhqiScJOEOeB5CBgCzsPJlHSVVV
	 E+FgLTaBasH3oazKZ5PfhRDRmEgSoHFe2OXftUSpw2pi/L4rPVUFnVrqiG2gMW28Mg
	 tEI6nej5KgC1eJ3lrubYcVQUqUa59jXSs1wla9HfAxREb5iQD3fqhfKzHeM7ZH+4x7
	 8InnMcSo+nXUrBR6Y1hHyO/sJdYYpc8NVEUg/0frWBT7YykmJeqnTi0NFz9u6vfj/+
	 4FTNdk8Glgz90UyyARzMWvglySLt5cOlbQFXXEp0QNyLLXgwvQm15vurkQ0TxreD86
	 +9kHIYC0Ovk2w==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [PATCH v2 2/3] common/encrypt: support hardware-wrapped key testing
Date: Thu, 12 Dec 2024 21:28:38 -0800
Message-ID: <20241213052840.314921-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241213052840.314921-1-ebiggers@kernel.org>
References: <20241213052840.314921-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

To support testing the kernel's support for hardware-wrapped inline
encryption keys, update _verify_ciphertext_for_encryption_policy() to
support a hw_wrapped_key option.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config  |  1 +
 common/encrypt | 80 +++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/common/config b/common/config
index fcff0660..091405b3 100644
--- a/common/config
+++ b/common/config
@@ -233,10 +233,11 @@ export BLKZONE_PROG="$(type -P blkzone)"
 export GZIP_PROG="$(type -P gzip)"
 export BTRFS_IMAGE_PROG="$(type -P btrfs-image)"
 export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
 export PARTED_PROG="$(type -P parted)"
 export XFS_PROPERTY_PROG="$(type -P xfs_property)"
+export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
 # But if neither one is available, just set it to "sleep 1" to wait for lv to
 # be settled
diff --git a/common/encrypt b/common/encrypt
index d90a566a..1caca767 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -150,10 +150,46 @@ _require_encryption_policy_support()
 		$KEYCTL_PROG clear $TEST_KEYRING_ID
 	fi
 	rm -r $dir
 }
 
+# Require that the scratch filesystem accepts the "inlinecrypt" mount option.
+#
+# This does not check whether the scratch block device has any specific inline
+# encryption capabilities.
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
+	echo "Checking for HW-wrapped key support on $dev" >> $seqres.full
+	local sysfs_dir=$(_sysfs_dev $dev)
+	if [ ! -e $sysfs_dir/queue ]; then
+		sysfs_dir=$sysfs_dir/..
+	fi
+	if [ ! -e $sysfs_dir/queue/crypto/hw_wrapped_keys ]; then
+		_notrun "$dev doesn't support hardware-wrapped inline encryption keys"
+	fi
+
+	echo "Checking for fscryptctl support for HW-wrapped keys" >> $seqres.full
+	_require_command "$FSCRYPTCTL_PROG" fscryptctl
+	if ! "$FSCRYPTCTL_PROG" --help | grep -q "import_hw_wrapped_key"; then
+		_notrun "fscryptctl too old; doesn't support hardware-wrapped inline encryption keys"
+	fi
+}
+
 _scratch_mkfs_encrypted()
 {
 	case $FSTYP in
 	ext4|f2fs)
 		_scratch_mkfs -O encrypt
@@ -249,18 +285,21 @@ _generate_key_descriptor()
 }
 
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
 # Serialize an integer into a CPU-endian bytestring of the given length, and
 # print it as a string where each byte is hex-escaped.  For example,
 # `_num_to_hex 1000 4` == "\xe8\x03\x00\x00" if the CPU is little endian.
 _num_to_hex()
 {
@@ -405,10 +444,25 @@ _add_enckey()
 	shift 2
 
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
 	local raw_key=$2
 	shift 2
@@ -851,19 +905,21 @@ _fscrypt_mode_name_to_num()
 #	'v2':			test a v2 encryption policy
 #	'direct':		test the DIRECT_KEY policy flag
 #	'iv_ino_lblk_64':	test the IV_INO_LBLK_64 policy flag
 #	'iv_ino_lblk_32':	test the IV_INO_LBLK_32 policy flag
 #	'log2_dusize=N':        test the log2_data_unit_size field
+#	'hw_wrapped_key':	use a hardware-wrapped inline encryption key
 #
 _verify_ciphertext_for_encryption_policy()
 {
 	local contents_encryption_mode=$1
 	local filenames_encryption_mode=$2
 	local opt
 	local policy_version=1
 	local policy_flags=0
 	local log2_dusize=0
+	local hw_wrapped_key=false
 	local set_encpolicy_args=""
 	local crypt_util_args=""
 	local crypt_util_contents_args=""
 	local crypt_util_filename_args=""
 	local expected_identifier
@@ -888,10 +944,15 @@ _verify_ciphertext_for_encryption_policy()
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 ))
 			;;
 		log2_dusize=*)
 			log2_dusize=$(echo "$opt" | sed 's/^log2_dusize=//')
 			;;
+		hw_wrapped_key)
+			hw_wrapped_key=true
+			crypt_util_args+=" --enable-hw-kdf"
+			crypt_util_contents_args+=" --use-inlinecrypt-key"
+			;;
 		*)
 			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
 			;;
 		esac
 	done
@@ -927,10 +988,13 @@ _verify_ciphertext_for_encryption_policy()
 		fi
 	fi
 	set_encpolicy_args=${set_encpolicy_args# }
 
 	_require_scratch_encryption $set_encpolicy_args -f $policy_flags
+	if $hw_wrapped_key; then
+		_require_hw_wrapped_key_support $SCRATCH_DEV
+	fi
 	_require_test_program "fscrypt-crypt-util"
 	_require_xfs_io_command "fiemap"
 	_require_get_encryption_nonce_support
 	_require_get_ciphertext_filename_support
 	if (( policy_version == 1 )); then
@@ -956,15 +1020,23 @@ _verify_ciphertext_for_encryption_policy()
 
 	crypt_util_contents_args+="$crypt_util_args"
 	crypt_util_filename_args+="$crypt_util_args"
 
 	echo "Generating encryption key" >> $seqres.full
-	local raw_key=$(_generate_raw_encryption_key)
 	if (( policy_version > 1 )); then
-		local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" \
-				| awk '{print $NF}')
+		if $hw_wrapped_key; then
+			local raw_key=$(_generate_raw_encryption_key \
+					$RAW_HW_KEY_SIZE)
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
 		_init_session_keyring
 		_add_session_encryption_key $keyspec $raw_key
 	fi
 	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
-- 
2.47.1


