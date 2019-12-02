Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03410F318
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Dec 2019 00:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLBXCe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Dec 2019 18:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:59512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbfLBXCe (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Dec 2019 18:02:34 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A90FF207DD;
        Mon,  2 Dec 2019 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575327752;
        bh=wNdoKVgoQv7bgfb5cPcZUhuM99zL7NWhekH6Fv6wKDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sA/XVrjBISF+N2VfFw6dYO84s2MH2D4l1kwZuZSIFpbNHCF/NcnNz/bTBRlZD7MGQ
         vHxHlnSdVuAepipkF3ZKmixFNqkaNipNHrUWJGyGxVZWDS1lVAuVZz09610XwuIRAo
         vpGDJlgMGs7vRmkeEtwoD0sEipSIQYm2TQbNmpug=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH v2 4/5] common/encrypt: support verifying ciphertext of IV_INO_LBLK_64 policies
Date:   Mon,  2 Dec 2019 15:01:54 -0800
Message-Id: <20191202230155.99071-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191202230155.99071-1-ebiggers@kernel.org>
References: <20191202230155.99071-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update _verify_ciphertext_for_encryption_policy() to support encryption
policies with the IV_INO_LBLK_64 flag set.

This flag modifies the encryption to include the inode number in the IVs
and to use a key derived from the tuple [master_key, fs_uuid, mode_num].
Since the file nonce is *not* included in this key derivation, multiple
files can use the same key.

This flag is supported by v2 encryption policies only -- not by v1.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt           | 100 +++++++++++++++++++++++++++++++--------
 src/fscrypt-crypt-util.c |  67 ++++++++++++++++++++++++--
 2 files changed, 144 insertions(+), 23 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index b967c65a..2e9908ad 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -6,7 +6,7 @@
 
 #
 # _require_scratch_encryption [-c CONTENTS_MODE] [-n FILENAMES_MODE]
-#			      [-v POLICY_VERSION]
+#			      [-f POLICY_FLAGS] [-v POLICY_VERSION]
 #
 # Require encryption support on the scratch device.
 #
@@ -69,15 +69,20 @@ _require_encryption_policy_support()
 	local mnt=$1
 	local dir=$mnt/tmpdir
 	local set_encpolicy_args=""
+	local policy_flags=0
 	local policy_version=1
 	local c
 
 	OPTIND=2
-	while getopts "c:n:v:" c; do
+	while getopts "c:n:f:v:" c; do
 		case $c in
 		c|n)
 			set_encpolicy_args+=" -$c $OPTARG"
 			;;
+		f)
+			set_encpolicy_args+=" -$c $OPTARG"
+			policy_flags=$OPTARG
+			;;
 		v)
 			set_encpolicy_args+=" -$c $OPTARG"
 			policy_version=$OPTARG
@@ -92,6 +97,12 @@ _require_encryption_policy_support()
 	echo "Checking whether kernel supports encryption policy: $set_encpolicy_args" \
 		>> $seqres.full
 
+	if (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
+		_scratch_unmount
+		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
+		_scratch_mount
+	fi
+
 	mkdir $dir
 	if (( policy_version > 1 )); then
 		_require_xfs_io_command "get_encpolicy" "-t"
@@ -159,6 +170,23 @@ _scratch_mkfs_sized_encrypted()
 	esac
 }
 
+# Like _scratch_mkfs_encrypted(), but add -O stable_inodes if applicable for the
+# filesystem type.  This is necessary for using encryption policies that include
+# the inode number in the IVs, e.g. policies with the IV_INO_LBLK_64 flag set.
+_scratch_mkfs_stable_inodes_encrypted()
+{
+	case $FSTYP in
+	ext4)
+		if ! _scratch_mkfs -O encrypt -O stable_inodes; then
+			_notrun "-O stable_inodes is not supported"
+		fi
+		;;
+	*)
+		_scratch_mkfs_encrypted
+		;;
+	esac
+}
+
 # Give the invoking shell a new session keyring.  This makes any keys we add to
 # the session keyring scoped to the lifetime of the test script.
 _new_session_keyring()
@@ -568,7 +596,8 @@ _do_verify_ciphertext_for_encryption_policy()
 	local set_encpolicy_args=$4
 	local keyspec=$5
 	local raw_key_hex=$6
-	local crypt_cmd="$here/src/fscrypt-crypt-util $7"
+	local crypt_contents_cmd="$here/src/fscrypt-crypt-util $7"
+	local crypt_filename_cmd="$here/src/fscrypt-crypt-util $8"
 
 	local blocksize=$(_get_block_size $SCRATCH_MNT)
 	local test_contents_files=()
@@ -626,14 +655,15 @@ _do_verify_ciphertext_for_encryption_policy()
 		read -r src inode blocklist <<< "$f"
 		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
 		_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
-		$crypt_cmd $contents_encryption_mode $raw_key_hex \
+		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
 			--file-nonce=$nonce --block-size=$blocksize \
-			< $src > $tmp.expected_contents
+			--inode-number=$inode < $src > $tmp.expected_contents
 		if ! cmp $tmp.expected_contents $tmp.actual_contents; then
 			_fail "Expected encrypted contents != actual encrypted contents.  File: $f"
 		fi
-		$crypt_cmd $contents_encryption_mode $raw_key_hex --decrypt \
-			--file-nonce=$nonce --block-size=$blocksize \
+		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
+			--decrypt --file-nonce=$nonce --block-size=$blocksize \
+			--inode-number=$inode \
 			< $tmp.actual_contents > $tmp.decrypted_contents
 		if ! cmp $src $tmp.decrypted_contents; then
 			_fail "Contents decryption sanity check failed.  File: $f"
@@ -647,16 +677,17 @@ _do_verify_ciphertext_for_encryption_policy()
 		_get_ciphertext_filename $SCRATCH_DEV $inode $dir_inode \
 			> $tmp.actual_name
 		echo -n "$name" | \
-			$crypt_cmd $filenames_encryption_mode $raw_key_hex \
-			--file-nonce=$nonce --padding=$padding \
-			--block-size=255 > $tmp.expected_name
+			$crypt_filename_cmd $filenames_encryption_mode \
+			$raw_key_hex --file-nonce=$nonce --padding=$padding \
+			--block-size=255 --inode-number=$dir_inode \
+			> $tmp.expected_name
 		if ! cmp $tmp.expected_name $tmp.actual_name; then
 			_fail "Expected encrypted filename != actual encrypted filename.  File: $f"
 		fi
-		$crypt_cmd $filenames_encryption_mode $raw_key_hex --decrypt \
-			--file-nonce=$nonce --padding=$padding \
-			--block-size=255 < $tmp.actual_name \
-			> $tmp.decrypted_name
+		$crypt_filename_cmd $filenames_encryption_mode $raw_key_hex \
+			--decrypt --file-nonce=$nonce --padding=$padding \
+			--block-size=255 --inode-number=$dir_inode \
+			< $tmp.actual_name > $tmp.decrypted_name
 		decrypted_name=$(tr -d '\0' < $tmp.decrypted_name)
 		if [ "$name" != "$decrypted_name" ]; then
 			_fail "Filename decryption sanity check failed ($name != $decrypted_name).  File: $f"
@@ -673,6 +704,7 @@ FSCRYPT_MODE_AES_128_CTS=6
 FSCRYPT_MODE_ADIANTUM=9
 
 FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
+FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64=0x08
 
 _fscrypt_mode_name_to_num()
 {
@@ -692,8 +724,13 @@ _fscrypt_mode_name_to_num()
 # policy of the specified type is used.
 #
 # The first two parameters are the contents and filenames encryption modes to
-# test.  Optionally, also specify 'direct' to test the DIRECT_KEY flag, and/or
-# 'v2' to test v2 policies.
+# test.  The following optional parameters are also accepted to further modify
+# the type of encryption policy that is tested:
+#
+#	'v2':			test a v2 encryption policy
+#	'direct':		test the DIRECT_KEY policy flag
+#	'iv_ino_lblk_64':	test the IV_INO_LBLK_64 policy flag
+#
 _verify_ciphertext_for_encryption_policy()
 {
 	local contents_encryption_mode=$1
@@ -703,6 +740,8 @@ _verify_ciphertext_for_encryption_policy()
 	local policy_flags=0
 	local set_encpolicy_args=""
 	local crypt_util_args=""
+	local crypt_util_contents_args=""
+	local crypt_util_filename_args=""
 
 	shift 2
 	for opt; do
@@ -717,6 +756,9 @@ _verify_ciphertext_for_encryption_policy()
 			fi
 			(( policy_flags |= FSCRYPT_POLICY_FLAG_DIRECT_KEY ))
 			;;
+		iv_ino_lblk_64)
+			(( policy_flags |= FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 ))
+			;;
 		*)
 			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
 			;;
@@ -732,9 +774,19 @@ _verify_ciphertext_for_encryption_policy()
 		set_encpolicy_args+=" -v 2"
 		crypt_util_args+=" --kdf=HKDF-SHA512"
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
+			if (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
+				_fail "'direct' and 'iv_ino_lblk_64' options are mutually exclusive"
+			fi
 			crypt_util_args+=" --mode-num=$contents_mode_num"
+		elif (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
+			crypt_util_args+=" --iv-ino-lblk-64"
+			crypt_util_contents_args+=" --mode-num=$contents_mode_num"
+			crypt_util_filename_args+=" --mode-num=$filenames_mode_num"
 		fi
 	else
+		if (( policy_flags & ~FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
+			_fail "unsupported flags for v1 policy: $policy_flags"
+		fi
 		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			crypt_util_args+=" --kdf=none"
 		else
@@ -743,7 +795,7 @@ _verify_ciphertext_for_encryption_policy()
 	fi
 	set_encpolicy_args=${set_encpolicy_args# }
 
-	_require_scratch_encryption $set_encpolicy_args
+	_require_scratch_encryption $set_encpolicy_args -f $policy_flags
 	_require_test_program "fscrypt-crypt-util"
 	_require_xfs_io_command "fiemap"
 	_require_get_encryption_nonce_support
@@ -753,9 +805,18 @@ _verify_ciphertext_for_encryption_policy()
 	fi
 
 	echo "Creating encryption-capable filesystem" >> $seqres.full
-	_scratch_mkfs_encrypted &>> $seqres.full
+	if (( policy_flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 )); then
+		_scratch_mkfs_stable_inodes_encrypted &>> $seqres.full
+	else
+		_scratch_mkfs_encrypted &>> $seqres.full
+	fi
 	_scratch_mount
 
+	crypt_util_args+=" --fs-uuid=$(blkid -s UUID -o value $SCRATCH_DEV | tr -d -)"
+
+	crypt_util_contents_args+="$crypt_util_args"
+	crypt_util_filename_args+="$crypt_util_args"
+
 	echo "Generating encryption key" >> $seqres.full
 	local raw_key=$(_generate_raw_encryption_key)
 	if (( policy_version > 1 )); then
@@ -781,5 +842,6 @@ _verify_ciphertext_for_encryption_policy()
 		"$set_encpolicy_args" \
 		"$keyspec" \
 		"$raw_key_hex" \
-		"$crypt_util_args"
+		"$crypt_util_contents_args" \
+		"$crypt_util_filename_args"
 }
diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 30f5e585..1bf8f95c 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -62,7 +62,15 @@ static void usage(FILE *fp)
 "                                Default: 4096 bytes\n"
 "  --decrypt                   Decrypt instead of encrypt\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
+"  --fs-uuid=UUID              The filesystem UUID as a 32-character hex string.\n"
+"                                Only required for --iv-ino-lblk-64.\n"
 "  --help                      Show this help\n"
+"  --inode-number=INUM         The file's inode number.  Only required for\n"
+"                                --iv-ino-lblk-64.\n"
+"  --iv-ino-lblk-64            Use the format where the IVs include the inode\n"
+"                                number and the same key is shared across files.\n"
+"                                Requires --kdf=HKDF-SHA512, --fs-uuid,\n"
+"                                --inode-number, and --mode-num.\n"
 "  --kdf=KDF                   Key derivation function to use: AES-128-ECB,\n"
 "                                HKDF-SHA512, or none.  Default: none\n"
 "  --mode-num=NUM              Derive per-mode key using mode number NUM\n"
@@ -1576,6 +1584,7 @@ static void test_adiantum(void)
  *----------------------------------------------------------------------------*/
 
 #define FILE_NONCE_SIZE		16
+#define UUID_SIZE		16
 #define MAX_KEY_SIZE		64
 
 static const struct fscrypt_cipher {
@@ -1694,6 +1703,18 @@ static u8 parse_mode_number(const char *arg)
 	return num;
 }
 
+static u32 parse_inode_number(const char *arg)
+{
+	char *tmp;
+	unsigned long long num = strtoull(arg, &tmp, 10);
+
+	if (num <= 0 || *tmp)
+		die("Invalid inode number: %s", arg);
+	if ((u32)num != num)
+		die("Inode number %s is too large; must be 32-bit", arg);
+	return num;
+}
+
 struct key_and_iv_params {
 	u8 master_key[MAX_KEY_SIZE];
 	int master_key_size;
@@ -1701,11 +1722,16 @@ struct key_and_iv_params {
 	u8 mode_num;
 	u8 file_nonce[FILE_NONCE_SIZE];
 	bool file_nonce_specified;
+	bool iv_ino_lblk_64;
+	u32 inode_number;
+	u8 fs_uuid[UUID_SIZE];
+	bool fs_uuid_specified;
 };
 
 #define HKDF_CONTEXT_KEY_IDENTIFIER	1
 #define HKDF_CONTEXT_PER_FILE_KEY	2
-#define HKDF_CONTEXT_PER_MODE_KEY	3
+#define HKDF_CONTEXT_DIRECT_KEY		3
+#define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
 
 /*
  * Get the key and starting IV with which the encryption will actually be done.
@@ -1718,7 +1744,7 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 {
 	bool file_nonce_in_iv = false;
 	struct aes_key aes_key;
-	u8 info[8 + 1 + FILE_NONCE_SIZE] = "fscrypt";
+	u8 info[8 + 1 + 1 + UUID_SIZE] = "fscrypt";
 	size_t infolen = 8;
 	size_t i;
 
@@ -1726,6 +1752,9 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 
 	memset(iv, 0, sizeof(*iv));
 
+	if (params->iv_ino_lblk_64 && params->kdf != KDF_HKDF_SHA512)
+		die("--iv-ino-lblk-64 requires --kdf=HKDF-SHA512");
+
 	switch (params->kdf) {
 	case KDF_NONE:
 		if (params->mode_num != 0)
@@ -1746,8 +1775,20 @@ static void get_key_and_iv(const struct key_and_iv_params *params,
 				    &real_key[i]);
 		break;
 	case KDF_HKDF_SHA512:
-		if (params->mode_num != 0) {
-			info[infolen++] = HKDF_CONTEXT_PER_MODE_KEY;
+		if (params->iv_ino_lblk_64) {
+			if (!params->fs_uuid_specified)
+				die("--iv-ino-lblk-64 requires --fs-uuid");
+			if (params->inode_number == 0)
+				die("--iv-ino-lblk-64 requires --inode-number");
+			if (params->mode_num == 0)
+				die("--iv-ino-lblk-64 requires --mode-num");
+			info[infolen++] = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
+			info[infolen++] = params->mode_num;
+			memcpy(&info[infolen], params->fs_uuid, UUID_SIZE);
+			infolen += UUID_SIZE;
+			put_unaligned_le32(params->inode_number, &iv->bytes[4]);
+		} else if (params->mode_num != 0) {
+			info[infolen++] = HKDF_CONTEXT_DIRECT_KEY;
 			info[infolen++] = params->mode_num;
 			file_nonce_in_iv = true;
 		} else if (params->file_nonce_specified) {
@@ -1773,7 +1814,10 @@ enum {
 	OPT_BLOCK_SIZE,
 	OPT_DECRYPT,
 	OPT_FILE_NONCE,
+	OPT_FS_UUID,
 	OPT_HELP,
+	OPT_INODE_NUMBER,
+	OPT_IV_INO_LBLK_64,
 	OPT_KDF,
 	OPT_MODE_NUM,
 	OPT_PADDING,
@@ -1783,7 +1827,10 @@ static const struct option longopts[] = {
 	{ "block-size",      required_argument, NULL, OPT_BLOCK_SIZE },
 	{ "decrypt",         no_argument,       NULL, OPT_DECRYPT },
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
+	{ "fs-uuid",         required_argument, NULL, OPT_FS_UUID },
 	{ "help",            no_argument,       NULL, OPT_HELP },
+	{ "inode-number",    required_argument, NULL, OPT_INODE_NUMBER },
+	{ "iv-ino-lblk-64",  no_argument,       NULL, OPT_IV_INO_LBLK_64 },
 	{ "kdf",             required_argument, NULL, OPT_KDF },
 	{ "mode-num",        required_argument, NULL, OPT_MODE_NUM },
 	{ "padding",         required_argument, NULL, OPT_PADDING },
@@ -1831,9 +1878,21 @@ int main(int argc, char *argv[])
 				die("Invalid file nonce: %s", optarg);
 			params.file_nonce_specified = true;
 			break;
+		case OPT_FS_UUID:
+			if (hex2bin(optarg, params.fs_uuid, UUID_SIZE)
+			    != UUID_SIZE)
+				die("Invalid filesystem UUID: %s", optarg);
+			params.fs_uuid_specified = true;
+			break;
 		case OPT_HELP:
 			usage(stdout);
 			return 0;
+		case OPT_INODE_NUMBER:
+			params.inode_number = parse_inode_number(optarg);
+			break;
+		case OPT_IV_INO_LBLK_64:
+			params.iv_ino_lblk_64 = true;
+			break;
 		case OPT_KDF:
 			params.kdf = parse_kdf_algorithm(optarg);
 			break;
-- 
2.24.0.393.g34dc348eaf-goog

