Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AAE8A523
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfHLR6t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbfHLR6s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85BD62085A;
        Mon, 12 Aug 2019 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632726;
        bh=ZtOhaUBYXvvtmMzVnlK6O6qS06iTFn61WOOqPmKMN/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ztSKqUBon588t/mpvYFlLJ1vzZWbxc7Q3L0gqz+obF8DUV2S1lqPSw0JnwtwZTRJ/
         vffIfW1WEOyoyiq1gtBYYBJegVajYYoWRHZscv+gkQOIjDiDFZaCp8dyfsYWxW4cXh
         Jhjq3IUFCKyBP+VvmcYEkATH0WM/stDFtmTrPylI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 4/9] common/encrypt: support verifying ciphertext of v2 encryption policies
Date:   Mon, 12 Aug 2019 10:58:04 -0700
Message-Id: <20190812175809.34810-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175809.34810-1-ebiggers@kernel.org>
References: <20190812175809.34810-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update _verify_ciphertext_for_encryption_policy() to support v2
encryption policies.

This also required adding HKDF-SHA512 support to fscrypt-crypt-util.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt           |  58 ++++++--
 src/fscrypt-crypt-util.c | 304 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 316 insertions(+), 46 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index fa6e2672..6a3c469d 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -379,9 +379,16 @@ _get_encryption_nonce()
 		#	flags: 0x2
 		#	master_key_descriptor: 0000000000000000
 		#	nonce: EFBD18765DF6414EC0A2CD5F91297E12
+		#
+		# Also support the case where the whole xattr is printed as hex,
+		# as is the case for fscrypt_context_v2.
+		#
+		#	xattr: e_name_index:9 e_name:c e_name_len:1 e_value_size:40 e_value:
+		#	020104020000000033809BFEBE68A4AD264079B30861DD5E6B9E72D07523C58794ACF52534BAA756
+		#
 		$DUMP_F2FS_PROG -i $inode $device | awk '
 			/\<e_name:c\>/ { found = 1 }
-			/^nonce:/ && found {
+			(/^nonce:/ || /^[[:xdigit:]]+$/) && found {
 				print substr($0, length($0) - 31, 32);
 				found = 0;
 			}'
@@ -402,6 +409,11 @@ _require_get_encryption_nonce_support()
 		;;
 	f2fs)
 		_require_command "$DUMP_F2FS_PROG" dump.f2fs
+		# For fscrypt_context_v2, we actually need a f2fs-tools version
+		# that has the patch "f2fs-tools: improve xattr value printing"
+		# (https://sourceforge.net/p/linux-f2fs/mailman/message/36648640/).
+		# Otherwise the xattr is incorrectly parsed as v1.  But just let
+		# the test fail in that case, as it was an f2fs-tools bug...
 		;;
 	*)
 		_notrun "_get_encryption_nonce() isn't implemented on $FSTYP"
@@ -551,7 +563,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	local filenames_encryption_mode=$2
 	local policy_flags=$3
 	local set_encpolicy_args=$4
-	local keydesc=$5
+	local keyspec=$5
 	local raw_key_hex=$6
 	local crypt_cmd="src/fscrypt-crypt-util $7"
 
@@ -573,7 +585,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	done
 	dir=$SCRATCH_MNT/encdir
 	mkdir $dir
-	_set_encpolicy $dir $keydesc $set_encpolicy_args -f $policy_flags
+	_set_encpolicy $dir $keyspec $set_encpolicy_args -f $policy_flags
 	for src in $tmp.testfile_*; do
 		dst=$dir/${src##*.}
 		cp $src $dst
@@ -593,7 +605,7 @@ _do_verify_ciphertext_for_encryption_policy()
 		dir=$SCRATCH_MNT/encdir.pad$padding
 		mkdir $dir
 		dir_inode=$(stat -c %i $dir)
-		_set_encpolicy $dir $keydesc $set_encpolicy_args \
+		_set_encpolicy $dir $keyspec $set_encpolicy_args \
 			-f $((policy_flags | padding_flag))
 		for len in 1 3 15 16 17 32 100 254 255; do
 			name=$(tr -d -C a-zA-Z0-9 < /dev/urandom | head -c $len)
@@ -667,12 +679,14 @@ _fscrypt_mode_name_to_num()
 # policy of the specified type is used.
 #
 # The first two parameters are the contents and filenames encryption modes to
-# test.  Optionally, also specify 'direct' to test the DIRECT_KEY flag.
+# test.  Optionally, also specify 'direct' to test the DIRECT_KEY flag, and/or
+# 'v2' to test v2 policies.
 _verify_ciphertext_for_encryption_policy()
 {
 	local contents_encryption_mode=$1
 	local filenames_encryption_mode=$2
 	local opt
+	local policy_version=1
 	local policy_flags=0
 	local set_encpolicy_args=""
 	local crypt_util_args=""
@@ -680,6 +694,9 @@ _verify_ciphertext_for_encryption_policy()
 	shift 2
 	for opt; do
 		case "$opt" in
+		v2)
+			policy_version=2
+			;;
 		direct)
 			if [ $contents_encryption_mode != \
 			     $filenames_encryption_mode ]; then
@@ -698,10 +715,18 @@ _verify_ciphertext_for_encryption_policy()
 	set_encpolicy_args+=" -c $contents_mode_num"
 	set_encpolicy_args+=" -n $filenames_mode_num"
 
-	if (( policy_flags & 0x04 )); then
-		crypt_util_args+=" --kdf=none"
+	if (( policy_version > 1 )); then
+		set_encpolicy_args+=" -v 2"
+		crypt_util_args+=" --kdf=HKDF-SHA512"
+		if (( policy_flags & 0x04 )); then
+			crypt_util_args+=" --mode-num=$contents_mode_num"
+		fi
 	else
-		crypt_util_args+=" --kdf=AES-128-ECB"
+		if (( policy_flags & 0x04 )); then
+			crypt_util_args+=" --kdf=none"
+		else
+			crypt_util_args+=" --kdf=AES-128-ECB"
+		fi
 	fi
 	set_encpolicy_args=${set_encpolicy_args# }
 
@@ -710,7 +735,9 @@ _verify_ciphertext_for_encryption_policy()
 	_require_xfs_io_command "fiemap"
 	_require_get_encryption_nonce_support
 	_require_get_ciphertext_filename_support
-	_require_command "$KEYCTL_PROG" keyctl
+	if (( policy_version == 1 )); then
+		_require_command "$KEYCTL_PROG" keyctl
+	fi
 
 	echo "Creating encryption-capable filesystem" >> $seqres.full
 	_scratch_mkfs_encrypted &>> $seqres.full
@@ -718,9 +745,14 @@ _verify_ciphertext_for_encryption_policy()
 
 	echo "Generating encryption key" >> $seqres.full
 	local raw_key=$(_generate_raw_encryption_key)
-	local keydesc=$(_generate_key_descriptor)
-	_new_session_keyring
-	_add_session_encryption_key $keydesc $raw_key
+	if (( policy_version > 1 )); then
+		local keyspec=$(_add_enckey $SCRATCH_MNT "$raw_key" \
+				| awk '{print $NF}')
+	else
+		local keyspec=$(_generate_key_descriptor)
+		_new_session_keyring
+		_add_session_encryption_key $keyspec $raw_key
+	fi
 	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
 
 	echo
@@ -734,7 +766,7 @@ _verify_ciphertext_for_encryption_policy()
 		"$filenames_encryption_mode" \
 		"$policy_flags" \
 		"$set_encpolicy_args" \
-		"$keydesc" \
+		"$keyspec" \
 		"$raw_key_hex" \
 		"$crypt_util_args"
 }
diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 81574a55..f5fd8386 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -12,11 +12,11 @@
  *
  * All algorithms are implemented in portable C code to avoid depending on
  * libcrypto (OpenSSL), and because some fscrypt-supported algorithms aren't
- * available in libcrypto anyway (e.g. Adiantum).  For simplicity, all crypto
- * code here tries to follow the mathematical definitions directly, without
- * optimizing for performance or worrying about following security best
- * practices such as mitigating side-channel attacks.  So, only use this program
- * for testing!
+ * available in libcrypto anyway (e.g. Adiantum), or are only supported in
+ * recent versions (e.g. HKDF-SHA512).  For simplicity, all crypto code here
+ * tries to follow the mathematical definitions directly, without optimizing for
+ * performance or worrying about following security best practices such as
+ * mitigating side-channel attacks.  So, only use this program for testing!
  */
 
 #include <asm/byteorder.h>
@@ -63,8 +63,9 @@ static void usage(FILE *fp)
 "  --decrypt                   Decrypt instead of encrypt\n"
 "  --file-nonce=NONCE          File's nonce as a 32-character hex string\n"
 "  --help                      Show this help\n"
-"  --kdf=KDF                   Key derivation function to use: AES-128-ECB\n"
-"                                or none.  Default: none\n"
+"  --kdf=KDF                   Key derivation function to use: AES-128-ECB,\n"
+"                                HKDF-SHA512, or none.  Default: none\n"
+"  --mode-num=NUM              Derive per-mode key using mode number NUM\n"
 "  --padding=PADDING           If last block is partial, zero-pad it to next\n"
 "                                PADDING-byte boundary.  Default: BLOCK_SIZE\n"
 	, fp);
@@ -134,6 +135,11 @@ static inline u32 ror32(u32 v, int n)
 	return (v >> n) | (v << (32 - n));
 }
 
+static inline u64 ror64(u64 v, int n)
+{
+	return (v >> n) | (v << (64 - n));
+}
+
 static inline void xor(u8 *res, const u8 *a, const u8 *b, size_t count)
 {
 	while (count--)
@@ -586,7 +592,7 @@ static void test_aes(void)
 #endif /* ENABLE_ALG_TESTS */
 
 /*----------------------------------------------------------------------------*
- *                                  SHA-256                                   *
+ *                            SHA-512 and SHA-256                             *
  *----------------------------------------------------------------------------*/
 
 /*
@@ -594,35 +600,104 @@ static void test_aes(void)
  *	https://csrc.nist.gov/csrc/media/publications/fips/180/2/archive/2002-08-01/documents/fips180-2withchangenotice.pdf
  */
 
+#define SHA512_DIGEST_SIZE	64
+#define SHA512_BLOCK_SIZE	128
+
 #define SHA256_DIGEST_SIZE	32
 #define SHA256_BLOCK_SIZE	64
 
 #define Ch(x, y, z)	(((x) & (y)) ^ (~(x) & (z)))
 #define Maj(x, y, z)	(((x) & (y)) ^ ((x) & (z)) ^ ((y) & (z)))
+
+#define Sigma512_0(x)	(ror64((x), 28) ^ ror64((x), 34) ^ ror64((x), 39))
+#define Sigma512_1(x)	(ror64((x), 14) ^ ror64((x), 18) ^ ror64((x), 41))
+#define sigma512_0(x)	(ror64((x),  1) ^ ror64((x),  8) ^ ((x) >> 7))
+#define sigma512_1(x)	(ror64((x), 19) ^ ror64((x), 61) ^ ((x) >> 6))
+
 #define Sigma256_0(x)	(ror32((x),  2) ^ ror32((x), 13) ^ ror32((x), 22))
 #define Sigma256_1(x)	(ror32((x),  6) ^ ror32((x), 11) ^ ror32((x), 25))
 #define sigma256_0(x)	(ror32((x),  7) ^ ror32((x), 18) ^ ((x) >>  3))
 #define sigma256_1(x)	(ror32((x), 17) ^ ror32((x), 19) ^ ((x) >> 10))
 
-static const u32 sha256_iv[8] = {
-	0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c,
-	0x1f83d9ab, 0x5be0cd19,
+static const u64 sha512_iv[8] = {
+	0x6a09e667f3bcc908, 0xbb67ae8584caa73b, 0x3c6ef372fe94f82b,
+	0xa54ff53a5f1d36f1, 0x510e527fade682d1, 0x9b05688c2b3e6c1f,
+	0x1f83d9abfb41bd6b, 0x5be0cd19137e2179,
 };
 
-static const u32 sha256_round_constants[64] = {
-	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1,
-	0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
-	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786,
-	0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
-	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147,
-	0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
-	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
-	0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
-	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a,
-	0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
-	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
+static const u64 sha512_round_constants[80] = {
+	0x428a2f98d728ae22, 0x7137449123ef65cd, 0xb5c0fbcfec4d3b2f,
+	0xe9b5dba58189dbbc, 0x3956c25bf348b538, 0x59f111f1b605d019,
+	0x923f82a4af194f9b, 0xab1c5ed5da6d8118, 0xd807aa98a3030242,
+	0x12835b0145706fbe, 0x243185be4ee4b28c, 0x550c7dc3d5ffb4e2,
+	0x72be5d74f27b896f, 0x80deb1fe3b1696b1, 0x9bdc06a725c71235,
+	0xc19bf174cf692694, 0xe49b69c19ef14ad2, 0xefbe4786384f25e3,
+	0x0fc19dc68b8cd5b5, 0x240ca1cc77ac9c65, 0x2de92c6f592b0275,
+	0x4a7484aa6ea6e483, 0x5cb0a9dcbd41fbd4, 0x76f988da831153b5,
+	0x983e5152ee66dfab, 0xa831c66d2db43210, 0xb00327c898fb213f,
+	0xbf597fc7beef0ee4, 0xc6e00bf33da88fc2, 0xd5a79147930aa725,
+	0x06ca6351e003826f, 0x142929670a0e6e70, 0x27b70a8546d22ffc,
+	0x2e1b21385c26c926, 0x4d2c6dfc5ac42aed, 0x53380d139d95b3df,
+	0x650a73548baf63de, 0x766a0abb3c77b2a8, 0x81c2c92e47edaee6,
+	0x92722c851482353b, 0xa2bfe8a14cf10364, 0xa81a664bbc423001,
+	0xc24b8b70d0f89791, 0xc76c51a30654be30, 0xd192e819d6ef5218,
+	0xd69906245565a910, 0xf40e35855771202a, 0x106aa07032bbd1b8,
+	0x19a4c116b8d2d0c8, 0x1e376c085141ab53, 0x2748774cdf8eeb99,
+	0x34b0bcb5e19b48a8, 0x391c0cb3c5c95a63, 0x4ed8aa4ae3418acb,
+	0x5b9cca4f7763e373, 0x682e6ff3d6b2b8a3, 0x748f82ee5defb2fc,
+	0x78a5636f43172f60, 0x84c87814a1f0ab72, 0x8cc702081a6439ec,
+	0x90befffa23631e28, 0xa4506cebde82bde9, 0xbef9a3f7b2c67915,
+	0xc67178f2e372532b, 0xca273eceea26619c, 0xd186b8c721c0c207,
+	0xeada7dd6cde0eb1e, 0xf57d4f7fee6ed178, 0x06f067aa72176fba,
+	0x0a637dc5a2c898a6, 0x113f9804bef90dae, 0x1b710b35131c471b,
+	0x28db77f523047d84, 0x32caab7b40c72493, 0x3c9ebe0a15c9bebc,
+	0x431d67c49c100d4c, 0x4cc5d4becb3e42b6, 0x597f299cfc657e2a,
+	0x5fcb6fab3ad6faec, 0x6c44198c4a475817,
 };
 
+/* Compute the SHA-512 digest of the given buffer */
+static void sha512(const u8 *in, size_t inlen, u8 out[SHA512_DIGEST_SIZE])
+{
+	const size_t msglen = ROUND_UP(inlen + 17, SHA512_BLOCK_SIZE);
+	u8 * const msg = xmalloc(msglen);
+	u64 H[8];
+	int i;
+
+	/* super naive way of handling the padding */
+	memcpy(msg, in, inlen);
+	memset(&msg[inlen], 0, msglen - inlen);
+	msg[inlen] = 0x80;
+	put_unaligned_be64((u64)inlen * 8, &msg[msglen - sizeof(__be64)]);
+	in = msg;
+
+	memcpy(H, sha512_iv, sizeof(H));
+	do {
+		u64 a = H[0], b = H[1], c = H[2], d = H[3],
+		    e = H[4], f = H[5], g = H[6], h = H[7];
+		u64 W[80];
+
+		for (i = 0; i < 16; i++)
+			W[i] = get_unaligned_be64(&in[i * sizeof(__be64)]);
+		for (; i < ARRAY_SIZE(W); i++)
+			W[i] = sigma512_1(W[i - 2]) + W[i - 7] +
+			       sigma512_0(W[i - 15]) + W[i - 16];
+		for (i = 0; i < ARRAY_SIZE(W); i++) {
+			u64 T1 = h + Sigma512_1(e) + Ch(e, f, g) +
+				 sha512_round_constants[i] + W[i];
+			u64 T2 = Sigma512_0(a) + Maj(a, b, c);
+
+			h = g; g = f; f = e; e = d + T1;
+			d = c; c = b; b = a; a = T1 + T2;
+		}
+		H[0] += a; H[1] += b; H[2] += c; H[3] += d;
+		H[4] += e; H[5] += f; H[6] += g; H[7] += h;
+	} while ((in += SHA512_BLOCK_SIZE) != &msg[msglen]);
+
+	for (i = 0; i < ARRAY_SIZE(H); i++)
+		put_unaligned_be64(H[i], &out[i * sizeof(__be64)]);
+	free(msg);
+}
+
 /* Compute the SHA-256 digest of the given buffer */
 static void sha256(const u8 *in, size_t inlen, u8 out[SHA256_DIGEST_SIZE])
 {
@@ -638,7 +713,8 @@ static void sha256(const u8 *in, size_t inlen, u8 out[SHA256_DIGEST_SIZE])
 	put_unaligned_be64((u64)inlen * 8, &msg[msglen - sizeof(__be64)]);
 	in = msg;
 
-	memcpy(H, sha256_iv, sizeof(H));
+	for (i = 0; i < ARRAY_SIZE(H); i++)
+		H[i] = (u32)(sha512_iv[i] >> 32);
 	do {
 		u32 a = H[0], b = H[1], c = H[2], d = H[3],
 		    e = H[4], f = H[5], g = H[6], h = H[7];
@@ -651,7 +727,7 @@ static void sha256(const u8 *in, size_t inlen, u8 out[SHA256_DIGEST_SIZE])
 			       sigma256_0(W[i - 15]) + W[i - 16];
 		for (i = 0; i < ARRAY_SIZE(W); i++) {
 			u32 T1 = h + Sigma256_1(e) + Ch(e, f, g) +
-				 sha256_round_constants[i] + W[i];
+				 (u32)(sha512_round_constants[i] >> 32) + W[i];
 			u32 T2 = Sigma256_0(a) + Maj(a, b, c);
 
 			h = g; g = f; f = e; e = d + T1;
@@ -674,8 +750,8 @@ static void test_sha2(void)
 
 	while (num_tests--) {
 		u8 in[4096];
-		u8 digest[SHA256_DIGEST_SIZE];
-		u8 ref_digest[SHA256_DIGEST_SIZE];
+		u8 digest[SHA512_DIGEST_SIZE];
+		u8 ref_digest[SHA512_DIGEST_SIZE];
 		const size_t inlen = rand() % (1 + sizeof(in));
 
 		rand_bytes(in, inlen);
@@ -683,6 +759,124 @@ static void test_sha2(void)
 		sha256(in, inlen, digest);
 		SHA256(in, inlen, ref_digest);
 		ASSERT(memcmp(digest, ref_digest, SHA256_DIGEST_SIZE) == 0);
+
+		sha512(in, inlen, digest);
+		SHA512(in, inlen, ref_digest);
+		ASSERT(memcmp(digest, ref_digest, SHA512_DIGEST_SIZE) == 0);
+	}
+}
+#endif /* ENABLE_ALG_TESTS */
+
+/*----------------------------------------------------------------------------*
+ *                            HKDF implementation                             *
+ *----------------------------------------------------------------------------*/
+
+static void hmac_sha512(const u8 *key, size_t keylen, const u8 *msg,
+			size_t msglen, u8 mac[SHA512_DIGEST_SIZE])
+{
+	u8 *ibuf = xmalloc(SHA512_BLOCK_SIZE + msglen);
+	u8 obuf[SHA512_BLOCK_SIZE + SHA512_DIGEST_SIZE];
+
+	ASSERT(keylen <= SHA512_BLOCK_SIZE); /* keylen > bs not implemented */
+
+	memset(ibuf, 0x36, SHA512_BLOCK_SIZE);
+	xor(ibuf, ibuf, key, keylen);
+	memcpy(&ibuf[SHA512_BLOCK_SIZE], msg, msglen);
+
+	memset(obuf, 0x5c, SHA512_BLOCK_SIZE);
+	xor(obuf, obuf, key, keylen);
+	sha512(ibuf, SHA512_BLOCK_SIZE + msglen, &obuf[SHA512_BLOCK_SIZE]);
+	sha512(obuf, sizeof(obuf), mac);
+
+	free(ibuf);
+}
+
+static void hkdf_sha512(const u8 *ikm, size_t ikmlen,
+			const u8 *salt, size_t saltlen,
+			const u8 *info, size_t infolen,
+			u8 *output, size_t outlen)
+{
+	static const u8 default_salt[SHA512_DIGEST_SIZE];
+	u8 prk[SHA512_DIGEST_SIZE]; /* pseudorandom key */
+	u8 *buf = xmalloc(1 + infolen + SHA512_DIGEST_SIZE);
+	u8 counter = 1;
+	size_t i;
+
+	if (saltlen == 0) {
+		salt = default_salt;
+		saltlen = sizeof(default_salt);
+	}
+
+	/* HKDF-Extract */
+	ASSERT(ikmlen > 0);
+	hmac_sha512(salt, saltlen, ikm, ikmlen, prk);
+
+	/* HKDF-Expand */
+	for (i = 0; i < outlen; i += SHA512_DIGEST_SIZE) {
+		u8 *p = buf;
+		u8 tmp[SHA512_DIGEST_SIZE];
+
+		ASSERT(counter != 0);
+		if (i > 0) {
+			memcpy(p, &output[i - SHA512_DIGEST_SIZE],
+			       SHA512_DIGEST_SIZE);
+			p += SHA512_DIGEST_SIZE;
+		}
+		memcpy(p, info, infolen);
+		p += infolen;
+		*p++ = counter++;
+		hmac_sha512(prk, sizeof(prk), buf, p - buf, tmp);
+		memcpy(&output[i], tmp, MIN(sizeof(tmp), outlen - i));
+	}
+	free(buf);
+}
+
+#ifdef ENABLE_ALG_TESTS
+#include <openssl/evp.h>
+#include <openssl/kdf.h>
+static void openssl_hkdf_sha512(const u8 *ikm, size_t ikmlen,
+				const u8 *salt, size_t saltlen,
+				const u8 *info, size_t infolen,
+				u8 *output, size_t outlen)
+{
+	EVP_PKEY_CTX *pctx = EVP_PKEY_CTX_new_id(EVP_PKEY_HKDF, NULL);
+	size_t actual_outlen = outlen;
+
+	ASSERT(pctx != NULL);
+	ASSERT(EVP_PKEY_derive_init(pctx) > 0);
+	ASSERT(EVP_PKEY_CTX_set_hkdf_md(pctx, EVP_sha512()) > 0);
+	ASSERT(EVP_PKEY_CTX_set1_hkdf_key(pctx, ikm, ikmlen) > 0);
+	ASSERT(EVP_PKEY_CTX_set1_hkdf_salt(pctx, salt, saltlen) > 0);
+	ASSERT(EVP_PKEY_CTX_add1_hkdf_info(pctx, info, infolen) > 0);
+	ASSERT(EVP_PKEY_derive(pctx, output, &actual_outlen) > 0);
+	ASSERT(actual_outlen == outlen);
+	EVP_PKEY_CTX_free(pctx);
+}
+
+static void test_hkdf_sha512(void)
+{
+	unsigned long num_tests = NUM_ALG_TEST_ITERATIONS;
+
+	while (num_tests--) {
+		u8 ikm[SHA512_DIGEST_SIZE];
+		u8 salt[SHA512_DIGEST_SIZE];
+		u8 info[128];
+		u8 actual_output[512];
+		u8 expected_output[sizeof(actual_output)];
+		size_t ikmlen = 1 + (rand() % sizeof(ikm));
+		size_t saltlen = rand() % (1 + sizeof(salt));
+		size_t infolen = rand() % (1 + sizeof(info));
+		size_t outlen = rand() % (1 + sizeof(actual_output));
+
+		rand_bytes(ikm, ikmlen);
+		rand_bytes(salt, saltlen);
+		rand_bytes(info, infolen);
+
+		hkdf_sha512(ikm, ikmlen, salt, saltlen, info, infolen,
+			    actual_output, outlen);
+		openssl_hkdf_sha512(ikm, ikmlen, salt, saltlen, info, infolen,
+				    expected_output, outlen);
+		ASSERT(memcmp(actual_output, expected_output, outlen) == 0);
 	}
 }
 #endif /* ENABLE_ALG_TESTS */
@@ -1476,6 +1670,7 @@ static void crypt_loop(const struct fscrypt_cipher *cipher, const u8 *key,
 enum kdf_algorithm {
 	KDF_NONE,
 	KDF_AES_128_ECB,
+	KDF_HKDF_SHA512,
 };
 
 static enum kdf_algorithm parse_kdf_algorithm(const char *arg)
@@ -1484,21 +1679,36 @@ static enum kdf_algorithm parse_kdf_algorithm(const char *arg)
 		return KDF_NONE;
 	if (strcmp(arg, "AES-128-ECB") == 0)
 		return KDF_AES_128_ECB;
+	if (strcmp(arg, "HKDF-SHA512") == 0)
+		return KDF_HKDF_SHA512;
 	die("Unknown KDF: %s", arg);
 }
 
+static u8 parse_mode_number(const char *arg)
+{
+	char *tmp;
+	long num = strtol(arg, &tmp, 10);
+
+	if (num <= 0 || *tmp || (u8)num != num)
+		die("Invalid mode number: %s", arg);
+	return num;
+}
+
 /*
  * Get the key and starting IV with which the encryption will actually be done.
- * If a KDF was specified, a subkey is derived from the master key and file
- * nonce.  Otherwise, the master key is used directly.
+ * If a KDF was specified, a subkey is derived from the master key and the mode
+ * number or file nonce.  Otherwise, the master key is used directly.
  */
 static void get_key_and_iv(const u8 *master_key, size_t master_key_size,
 			   enum kdf_algorithm kdf,
-			   const u8 nonce[FILE_NONCE_SIZE],
+			   u8 mode_num, const u8 nonce[FILE_NONCE_SIZE],
 			   u8 *real_key, size_t real_key_size,
 			   struct fscrypt_iv *iv)
 {
+	bool nonce_in_iv = false;
 	struct aes_key aes_key;
+	u8 info[8 + 1 + FILE_NONCE_SIZE] = "fscrypt";
+	size_t infolen = 8;
 	size_t i;
 
 	ASSERT(real_key_size <= master_key_size);
@@ -1507,22 +1717,43 @@ static void get_key_and_iv(const u8 *master_key, size_t master_key_size,
 
 	switch (kdf) {
 	case KDF_NONE:
+		if (mode_num != 0)
+			die("--mode-num isn't supported with --kdf=none");
 		memcpy(real_key, master_key, real_key_size);
-		if (nonce != NULL)
-			memcpy(&iv->bytes[8], nonce, FILE_NONCE_SIZE);
+		nonce_in_iv = true;
 		break;
 	case KDF_AES_128_ECB:
 		if (nonce == NULL)
 			die("--file-nonce is required with --kdf=AES-128-ECB");
+		if (mode_num != 0)
+			die("--mode-num isn't supported with --kdf=AES-128-ECB");
 		STATIC_ASSERT(FILE_NONCE_SIZE == AES_128_KEY_SIZE);
 		ASSERT(real_key_size % AES_BLOCK_SIZE == 0);
 		aes_setkey(&aes_key, nonce, AES_128_KEY_SIZE);
 		for (i = 0; i < real_key_size; i += AES_BLOCK_SIZE)
 			aes_encrypt(&aes_key, &master_key[i], &real_key[i]);
 		break;
+	case KDF_HKDF_SHA512:
+		if (mode_num != 0) {
+			info[infolen++] = 3; /* HKDF_CONTEXT_PER_MODE_KEY */
+			info[infolen++] = mode_num;
+			nonce_in_iv = true;
+		} else if (nonce != NULL) {
+			info[infolen++] = 2; /* HKDF_CONTEXT_PER_FILE_KEY */
+			memcpy(&info[infolen], nonce, FILE_NONCE_SIZE);
+			infolen += FILE_NONCE_SIZE;
+		} else {
+			die("With --kdf=HKDF-SHA512, at least one of --file-nonce and --mode-num must be specified");
+		}
+		hkdf_sha512(master_key, master_key_size, NULL, 0,
+			    info, infolen, real_key, real_key_size);
+		break;
 	default:
 		ASSERT(0);
 	}
+
+	if (nonce_in_iv && nonce != NULL)
+		memcpy(&iv->bytes[8], nonce, FILE_NONCE_SIZE);
 }
 
 enum {
@@ -1531,6 +1762,7 @@ enum {
 	OPT_FILE_NONCE,
 	OPT_HELP,
 	OPT_KDF,
+	OPT_MODE_NUM,
 	OPT_PADDING,
 };
 
@@ -1540,6 +1772,7 @@ static const struct option longopts[] = {
 	{ "file-nonce",      required_argument, NULL, OPT_FILE_NONCE },
 	{ "help",            no_argument,       NULL, OPT_HELP },
 	{ "kdf",             required_argument, NULL, OPT_KDF },
+	{ "mode-num",        required_argument, NULL, OPT_MODE_NUM },
 	{ "padding",         required_argument, NULL, OPT_PADDING },
 	{ NULL, 0, NULL, 0 },
 };
@@ -1551,6 +1784,7 @@ int main(int argc, char *argv[])
 	u8 _file_nonce[FILE_NONCE_SIZE];
 	u8 *file_nonce = NULL;
 	enum kdf_algorithm kdf = KDF_NONE;
+	u8 mode_num = 0;
 	size_t padding = 0;
 	const struct fscrypt_cipher *cipher;
 	u8 master_key[MAX_KEY_SIZE];
@@ -1565,6 +1799,7 @@ int main(int argc, char *argv[])
 #ifdef ENABLE_ALG_TESTS
 	test_aes();
 	test_sha2();
+	test_hkdf_sha512();
 	test_aes_256_xts();
 	test_aes_256_cts_cbc();
 	test_adiantum();
@@ -1592,6 +1827,9 @@ int main(int argc, char *argv[])
 		case OPT_KDF:
 			kdf = parse_kdf_algorithm(optarg);
 			break;
+		case OPT_MODE_NUM:
+			mode_num = parse_mode_number(optarg);
+			break;
 		case OPT_PADDING:
 			padding = strtoul(optarg, &tmp, 10);
 			if (padding <= 0 || *tmp || !is_power_of_2(padding) ||
@@ -1625,7 +1863,7 @@ int main(int argc, char *argv[])
 	if (master_key_size < cipher->keysize)
 		die("Master key is too short for cipher %s", cipher->name);
 
-	get_key_and_iv(master_key, master_key_size, kdf, file_nonce,
+	get_key_and_iv(master_key, master_key_size, kdf, mode_num, file_nonce,
 		       real_key, cipher->keysize, &iv);
 
 	crypt_loop(cipher, real_key, &iv, decrypting, block_size, padding);
-- 
2.23.0.rc1.153.gdeed80330f-goog

