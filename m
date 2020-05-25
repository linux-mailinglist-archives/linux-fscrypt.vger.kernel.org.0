Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3BF31E155F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 May 2020 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390793AbgEYUzS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 May 2020 16:55:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390741AbgEYUzQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 May 2020 16:55:16 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D0B82071A;
        Mon, 25 May 2020 20:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590440114;
        bh=vL7gJ8WGUeTVx+MhoNhnoP5jL2YbsaP3/ppXIzXgMcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cgOWR4hTBAzIBosf79xOPguc1U9sZXUi9gB39Zlspaw1f4gq6yUsIFr9CQ974OKWG
         z3fJuV2q3AFfTsRgV/aGtYUit5F1k1xT6ggHwIoBVEc/MLE4VRid246e+GTD3Qg+Af
         N+/23EaaYQU0wt0dO7Z82J1cL9A3Wx/qv6a/+c1Q=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: [PATCH v2 1/3] Split up cmd_sign.c
Date:   Mon, 25 May 2020 13:54:30 -0700
Message-Id: <20200525205432.310304-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525205432.310304-1-ebiggers@kernel.org>
References: <20200525205432.310304-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for moving most of the functionality of 'fsverity sign'
into a shared library, split up cmd_sign.c into three files:

- cmd_sign.c: the actual command
- compute_digest.c: compute the file measurement
- sign_digest.c: sign the file measurement

No "real" changes; this is just moving code around.

Reviewed-by: Jes Sorensen <jsorensen@fb.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Makefile             |   4 +-
 cmd_sign.c           | 481 +------------------------------------------
 lib/compute_digest.c | 184 +++++++++++++++++
 lib/sign_digest.c    | 304 +++++++++++++++++++++++++++
 sign.h               |  32 +++
 5 files changed, 523 insertions(+), 482 deletions(-)
 create mode 100644 lib/compute_digest.c
 create mode 100644 lib/sign_digest.c
 create mode 100644 sign.h

diff --git a/Makefile b/Makefile
index b9c09b9..c3b14a3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,9 +1,9 @@
 EXE := fsverity
 CFLAGS := -O2 -Wall
-CPPFLAGS := -D_FILE_OFFSET_BITS=64
+CPPFLAGS := -D_FILE_OFFSET_BITS=64 -I.
 LDLIBS := -lcrypto
 DESTDIR := /usr/local
-SRC := $(wildcard *.c)
+SRC := $(wildcard *.c) $(wildcard lib/*.c)
 OBJ := $(SRC:.c=.o)
 HDRS := $(wildcard *.h)
 
diff --git a/cmd_sign.c b/cmd_sign.c
index 0300b34..0e69378 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -7,337 +7,13 @@
 
 #include "commands.h"
 #include "fsverity_uapi.h"
-#include "hash_algs.h"
+#include "sign.h"
 
 #include <fcntl.h>
 #include <getopt.h>
-#include <limits.h>
-#include <openssl/bio.h>
-#include <openssl/err.h>
-#include <openssl/pem.h>
-#include <openssl/pkcs7.h>
 #include <stdlib.h>
 #include <string.h>
 
-/*
- * Merkle tree properties.  The file measurement is the hash of this structure
- * excluding the signature and with the sig_size field set to 0.
- */
-struct fsverity_descriptor {
-	__u8 version;		/* must be 1 */
-	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
-	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
-	__u8 salt_size;		/* size of salt in bytes; 0 if none */
-	__le32 sig_size;	/* size of signature in bytes; 0 if none */
-	__le64 data_size;	/* size of file the Merkle tree is built over */
-	__u8 root_hash[64];	/* Merkle tree root hash */
-	__u8 salt[32];		/* salt prepended to each hashed block */
-	__u8 __reserved[144];	/* must be 0's */
-	__u8 signature[];	/* optional PKCS#7 signature */
-};
-
-/*
- * Format in which verity file measurements are signed.  This is the same as
- * 'struct fsverity_digest', except here some magic bytes are prepended to
- * provide some context about what is being signed in case the same key is used
- * for non-fsverity purposes, and here the fields have fixed endianness.
- */
-struct fsverity_signed_digest {
-	char magic[8];			/* must be "FSVerity" */
-	__le16 digest_algorithm;
-	__le16 digest_size;
-	__u8 digest[];
-};
-
-static void __printf(1, 2) __cold
-error_msg_openssl(const char *format, ...)
-{
-	va_list va;
-
-	va_start(va, format);
-	do_error_msg(format, va, 0);
-	va_end(va);
-
-	if (ERR_peek_error() == 0)
-		return;
-
-	fprintf(stderr, "OpenSSL library errors:\n");
-	ERR_print_errors_fp(stderr);
-}
-
-/* Read a PEM PKCS#8 formatted private key */
-static EVP_PKEY *read_private_key(const char *keyfile)
-{
-	BIO *bio;
-	EVP_PKEY *pkey;
-
-	bio = BIO_new_file(keyfile, "r");
-	if (!bio) {
-		error_msg_openssl("can't open '%s' for reading", keyfile);
-		return NULL;
-	}
-
-	pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
-	if (!pkey) {
-		error_msg_openssl("Failed to parse private key file '%s'.\n"
-				  "       Note: it must be in PEM PKCS#8 format.",
-				  keyfile);
-	}
-	BIO_free(bio);
-	return pkey;
-}
-
-/* Read a PEM X.509 formatted certificate */
-static X509 *read_certificate(const char *certfile)
-{
-	BIO *bio;
-	X509 *cert;
-
-	bio = BIO_new_file(certfile, "r");
-	if (!bio) {
-		error_msg_openssl("can't open '%s' for reading", certfile);
-		return NULL;
-	}
-	cert = PEM_read_bio_X509(bio, NULL, NULL, NULL);
-	if (!cert) {
-		error_msg_openssl("Failed to parse X.509 certificate file '%s'.\n"
-				  "       Note: it must be in PEM format.",
-				  certfile);
-	}
-	BIO_free(bio);
-	return cert;
-}
-
-#ifdef OPENSSL_IS_BORINGSSL
-
-static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
-		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, u32 *sig_size_ret)
-{
-	CBB out, outer_seq, wrapped_seq, seq, digest_algos_set, digest_algo,
-		null, content_info, issuer_and_serial, signer_infos,
-		signer_info, sign_algo, signature;
-	EVP_MD_CTX md_ctx;
-	u8 *name_der = NULL, *sig = NULL, *pkcs7_data = NULL;
-	size_t pkcs7_data_len, sig_len;
-	int name_der_len, sig_nid;
-	bool ok = false;
-
-	EVP_MD_CTX_init(&md_ctx);
-	BIGNUM *serial = ASN1_INTEGER_to_BN(X509_get_serialNumber(cert), NULL);
-
-	if (!CBB_init(&out, 1024)) {
-		error_msg("out of memory");
-		goto out;
-	}
-
-	name_der_len = i2d_X509_NAME(X509_get_subject_name(cert), &name_der);
-	if (name_der_len < 0) {
-		error_msg_openssl("i2d_X509_NAME failed");
-		goto out;
-	}
-
-	if (!EVP_DigestSignInit(&md_ctx, NULL, md, NULL, pkey)) {
-		error_msg_openssl("EVP_DigestSignInit failed");
-		goto out;
-	}
-
-	sig_len = EVP_PKEY_size(pkey);
-	sig = xmalloc(sig_len);
-	if (!EVP_DigestSign(&md_ctx, sig, &sig_len, data_to_sign, data_size)) {
-		error_msg_openssl("EVP_DigestSign failed");
-		goto out;
-	}
-
-	sig_nid = EVP_PKEY_id(pkey);
-	/* To mirror OpenSSL behaviour, always use |NID_rsaEncryption| with RSA
-	 * rather than the combined hash+pkey NID. */
-	if (sig_nid != NID_rsaEncryption) {
-		OBJ_find_sigid_by_algs(&sig_nid, EVP_MD_type(md),
-				       EVP_PKEY_id(pkey));
-	}
-
-	// See https://tools.ietf.org/html/rfc2315#section-7
-	if (!CBB_add_asn1(&out, &outer_seq, CBS_ASN1_SEQUENCE) ||
-	    !OBJ_nid2cbb(&outer_seq, NID_pkcs7_signed) ||
-	    !CBB_add_asn1(&outer_seq, &wrapped_seq, CBS_ASN1_CONTEXT_SPECIFIC |
-			  CBS_ASN1_CONSTRUCTED | 0) ||
-	    // See https://tools.ietf.org/html/rfc2315#section-9.1
-	    !CBB_add_asn1(&wrapped_seq, &seq, CBS_ASN1_SEQUENCE) ||
-	    !CBB_add_asn1_uint64(&seq, 1 /* version */) ||
-	    !CBB_add_asn1(&seq, &digest_algos_set, CBS_ASN1_SET) ||
-	    !CBB_add_asn1(&digest_algos_set, &digest_algo, CBS_ASN1_SEQUENCE) ||
-	    !OBJ_nid2cbb(&digest_algo, EVP_MD_type(md)) ||
-	    !CBB_add_asn1(&digest_algo, &null, CBS_ASN1_NULL) ||
-	    !CBB_add_asn1(&seq, &content_info, CBS_ASN1_SEQUENCE) ||
-	    !OBJ_nid2cbb(&content_info, NID_pkcs7_data) ||
-	    !CBB_add_asn1(&seq, &signer_infos, CBS_ASN1_SET) ||
-	    !CBB_add_asn1(&signer_infos, &signer_info, CBS_ASN1_SEQUENCE) ||
-	    !CBB_add_asn1_uint64(&signer_info, 1 /* version */) ||
-	    !CBB_add_asn1(&signer_info, &issuer_and_serial,
-			  CBS_ASN1_SEQUENCE) ||
-	    !CBB_add_bytes(&issuer_and_serial, name_der, name_der_len) ||
-	    !BN_marshal_asn1(&issuer_and_serial, serial) ||
-	    !CBB_add_asn1(&signer_info, &digest_algo, CBS_ASN1_SEQUENCE) ||
-	    !OBJ_nid2cbb(&digest_algo, EVP_MD_type(md)) ||
-	    !CBB_add_asn1(&digest_algo, &null, CBS_ASN1_NULL) ||
-	    !CBB_add_asn1(&signer_info, &sign_algo, CBS_ASN1_SEQUENCE) ||
-	    !OBJ_nid2cbb(&sign_algo, sig_nid) ||
-	    !CBB_add_asn1(&sign_algo, &null, CBS_ASN1_NULL) ||
-	    !CBB_add_asn1(&signer_info, &signature, CBS_ASN1_OCTETSTRING) ||
-	    !CBB_add_bytes(&signature, sig, sig_len) ||
-	    !CBB_finish(&out, &pkcs7_data, &pkcs7_data_len)) {
-		error_msg_openssl("failed to construct PKCS#7 data");
-		goto out;
-	}
-
-	*sig_ret = xmemdup(pkcs7_data, pkcs7_data_len);
-	*sig_size_ret = pkcs7_data_len;
-	ok = true;
-out:
-	BN_free(serial);
-	EVP_MD_CTX_cleanup(&md_ctx);
-	CBB_cleanup(&out);
-	free(sig);
-	OPENSSL_free(name_der);
-	OPENSSL_free(pkcs7_data);
-	return ok;
-}
-
-#else /* OPENSSL_IS_BORINGSSL */
-
-static BIO *new_mem_buf(const void *buf, size_t size)
-{
-	BIO *bio;
-
-	ASSERT(size <= INT_MAX);
-	/*
-	 * Prior to OpenSSL 1.1.0, BIO_new_mem_buf() took a non-const pointer,
-	 * despite still marking the resulting bio as read-only.  So cast away
-	 * the const to avoid a compiler warning with older OpenSSL versions.
-	 */
-	bio = BIO_new_mem_buf((void *)buf, size);
-	if (!bio)
-		error_msg_openssl("out of memory");
-	return bio;
-}
-
-static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
-		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
-		       u8 **sig_ret, u32 *sig_size_ret)
-{
-	/*
-	 * PKCS#7 signing flags:
-	 *
-	 * - PKCS7_BINARY	signing binary data, so skip MIME translation
-	 *
-	 * - PKCS7_DETACHED	omit the signed data (include signature only)
-	 *
-	 * - PKCS7_NOATTR	omit extra authenticated attributes, such as
-	 *			SMIMECapabilities
-	 *
-	 * - PKCS7_NOCERTS	omit the signer's certificate
-	 *
-	 * - PKCS7_PARTIAL	PKCS7_sign() creates a handle only, then
-	 *			PKCS7_sign_add_signer() can add a signer later.
-	 *			This is necessary to change the message digest
-	 *			algorithm from the default of SHA-1.  Requires
-	 *			OpenSSL 1.0.0 or later.
-	 */
-	int pkcs7_flags = PKCS7_BINARY | PKCS7_DETACHED | PKCS7_NOATTR |
-			  PKCS7_NOCERTS | PKCS7_PARTIAL;
-	u8 *sig;
-	u32 sig_size;
-	BIO *bio = NULL;
-	PKCS7 *p7 = NULL;
-	bool ok = false;
-
-	bio = new_mem_buf(data_to_sign, data_size);
-	if (!bio)
-		goto out;
-
-	p7 = PKCS7_sign(NULL, NULL, NULL, bio, pkcs7_flags);
-	if (!p7) {
-		error_msg_openssl("failed to initialize PKCS#7 signature object");
-		goto out;
-	}
-
-	if (!PKCS7_sign_add_signer(p7, cert, pkey, md, pkcs7_flags)) {
-		error_msg_openssl("failed to add signer to PKCS#7 signature object");
-		goto out;
-	}
-
-	if (PKCS7_final(p7, bio, pkcs7_flags) != 1) {
-		error_msg_openssl("failed to finalize PKCS#7 signature");
-		goto out;
-	}
-
-	BIO_free(bio);
-	bio = BIO_new(BIO_s_mem());
-	if (!bio) {
-		error_msg_openssl("out of memory");
-		goto out;
-	}
-
-	if (i2d_PKCS7_bio(bio, p7) != 1) {
-		error_msg_openssl("failed to DER-encode PKCS#7 signature object");
-		goto out;
-	}
-
-	sig_size = BIO_get_mem_data(bio, &sig);
-	*sig_ret = xmemdup(sig, sig_size);
-	*sig_size_ret = sig_size;
-	ok = true;
-out:
-	PKCS7_free(p7);
-	BIO_free(bio);
-	return ok;
-}
-
-#endif /* !OPENSSL_IS_BORINGSSL */
-
-/*
- * Sign the specified @data_to_sign of length @data_size bytes using the private
- * key in @keyfile, the certificate in @certfile, and the hash algorithm
- * @hash_alg.  Returns the DER-formatted PKCS#7 signature in @sig_ret and
- * @sig_size_ret.
- */
-static bool sign_data(const void *data_to_sign, size_t data_size,
-		      const char *keyfile, const char *certfile,
-		      const struct fsverity_hash_alg *hash_alg,
-		      u8 **sig_ret, u32 *sig_size_ret)
-{
-	EVP_PKEY *pkey = NULL;
-	X509 *cert = NULL;
-	const EVP_MD *md;
-	bool ok = false;
-
-	pkey = read_private_key(keyfile);
-	if (!pkey)
-		goto out;
-
-	cert = read_certificate(certfile);
-	if (!cert)
-		goto out;
-
-	OpenSSL_add_all_digests();
-	md = EVP_get_digestbyname(hash_alg->name);
-	if (!md) {
-		fprintf(stderr,
-			"Warning: '%s' algorithm not found in OpenSSL library.\n"
-			"         Falling back to SHA-256 signature.\n",
-			hash_alg->name);
-		md = EVP_sha256();
-	}
-
-	ok = sign_pkcs7(data_to_sign, data_size, pkey, cert, md,
-			sig_ret, sig_size_ret);
-out:
-	EVP_PKEY_free(pkey);
-	X509_free(cert);
-	return ok;
-}
-
 static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 {
 	struct filedes file;
@@ -350,161 +26,6 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 	return ok;
 }
 
-#define FS_VERITY_MAX_LEVELS	64
-
-struct block_buffer {
-	u32 filled;
-	u8 *data;
-};
-
-/*
- * Hash a block, writing the result to the next level's pending block buffer.
- * Returns true if the next level's block became full, else false.
- */
-static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
-			   u32 block_size, const u8 *salt, u32 salt_size)
-{
-	struct block_buffer *next = cur + 1;
-
-	/* Zero-pad the block if it's shorter than block_size. */
-	memset(&cur->data[cur->filled], 0, block_size - cur->filled);
-
-	hash_init(hash);
-	hash_update(hash, salt, salt_size);
-	hash_update(hash, cur->data, block_size);
-	hash_final(hash, &next->data[next->filled]);
-
-	next->filled += hash->alg->digest_size;
-	cur->filled = 0;
-
-	return next->filled + hash->alg->digest_size > block_size;
-}
-
-/*
- * Compute the file's Merkle tree root hash using the given hash algorithm,
- * block size, and salt.
- */
-static bool compute_root_hash(struct filedes *file, u64 file_size,
-			      struct hash_ctx *hash, u32 block_size,
-			      const u8 *salt, u32 salt_size, u8 *root_hash)
-{
-	const u32 hashes_per_block = block_size / hash->alg->digest_size;
-	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
-	u8 *padded_salt = xzalloc(padded_salt_size);
-	u64 blocks;
-	int num_levels = 0;
-	int level;
-	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
-	struct block_buffer *buffers = &_buffers[1];
-	u64 offset;
-	bool ok = false;
-
-	if (salt_size != 0)
-		memcpy(padded_salt, salt, salt_size);
-
-	/* Compute number of levels */
-	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
-	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
-		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
-		num_levels++;
-	}
-
-	/*
-	 * Allocate the block buffers.  Buffer "-1" is for data blocks.
-	 * Buffers 0 <= level < num_levels are for the actual tree levels.
-	 * Buffer 'num_levels' is for the root hash.
-	 */
-	for (level = -1; level < num_levels; level++)
-		buffers[level].data = xmalloc(block_size);
-	buffers[num_levels].data = root_hash;
-
-	/* Hash each data block, also hashing the tree blocks as they fill up */
-	for (offset = 0; offset < file_size; offset += block_size) {
-		buffers[-1].filled = min(block_size, file_size - offset);
-
-		if (!full_read(file, buffers[-1].data, buffers[-1].filled))
-			goto out;
-
-		level = -1;
-		while (hash_one_block(hash, &buffers[level], block_size,
-				      padded_salt, padded_salt_size)) {
-			level++;
-			ASSERT(level < num_levels);
-		}
-	}
-	/* Finish all nonempty pending tree blocks */
-	for (level = 0; level < num_levels; level++) {
-		if (buffers[level].filled != 0)
-			hash_one_block(hash, &buffers[level], block_size,
-				       padded_salt, padded_salt_size);
-	}
-
-	/* Root hash was filled by the last call to hash_one_block() */
-	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
-	ok = true;
-out:
-	for (level = -1; level < num_levels; level++)
-		free(buffers[level].data);
-	free(padded_salt);
-	return ok;
-}
-
-/*
- * Compute the fs-verity measurement of the given file.
- *
- * The fs-verity measurement is the hash of the fsverity_descriptor, which
- * contains the Merkle tree properties including the root hash.
- */
-static bool compute_file_measurement(const char *filename,
-				     const struct fsverity_hash_alg *hash_alg,
-				     u32 block_size, const u8 *salt,
-				     u32 salt_size, u8 *measurement)
-{
-	struct filedes file = { .fd = -1 };
-	struct hash_ctx *hash = hash_create(hash_alg);
-	u64 file_size;
-	struct fsverity_descriptor desc;
-	bool ok = false;
-
-	if (!open_file(&file, filename, O_RDONLY, 0))
-		goto out;
-
-	if (!get_file_size(&file, &file_size))
-		goto out;
-
-	memset(&desc, 0, sizeof(desc));
-	desc.version = 1;
-	desc.hash_algorithm = hash_alg - fsverity_hash_algs;
-
-	ASSERT(is_power_of_2(block_size));
-	desc.log_blocksize = ilog2(block_size);
-
-	if (salt_size != 0) {
-		if (salt_size > sizeof(desc.salt)) {
-			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
-				  salt_size, sizeof(desc.salt));
-			goto out;
-		}
-		memcpy(desc.salt, salt, salt_size);
-		desc.salt_size = salt_size;
-	}
-
-	desc.data_size = cpu_to_le64(file_size);
-
-	/* Root hash of empty file is all 0's */
-	if (file_size != 0 &&
-	    !compute_root_hash(&file, file_size, hash, block_size, salt,
-			       salt_size, desc.root_hash))
-		goto out;
-
-	hash_full(hash, &desc, sizeof(desc), measurement);
-	ok = true;
-out:
-	filedes_close(&file);
-	hash_free(hash);
-	return ok;
-}
-
 enum {
 	OPT_HASH_ALG,
 	OPT_BLOCK_SIZE,
diff --git a/lib/compute_digest.c b/lib/compute_digest.c
new file mode 100644
index 0000000..dbc291e
--- /dev/null
+++ b/lib/compute_digest.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * compute_digest.c
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include "sign.h"
+
+#include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
+
+#define FS_VERITY_MAX_LEVELS	64
+
+/*
+ * Merkle tree properties.  The file measurement is the hash of this structure
+ * excluding the signature and with the sig_size field set to 0.
+ */
+struct fsverity_descriptor {
+	__u8 version;		/* must be 1 */
+	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
+	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
+	__u8 salt_size;		/* size of salt in bytes; 0 if none */
+	__le32 sig_size;	/* size of signature in bytes; 0 if none */
+	__le64 data_size;	/* size of file the Merkle tree is built over */
+	__u8 root_hash[64];	/* Merkle tree root hash */
+	__u8 salt[32];		/* salt prepended to each hashed block */
+	__u8 __reserved[144];	/* must be 0's */
+	__u8 signature[];	/* optional PKCS#7 signature */
+};
+
+struct block_buffer {
+	u32 filled;
+	u8 *data;
+};
+
+/*
+ * Hash a block, writing the result to the next level's pending block buffer.
+ * Returns true if the next level's block became full, else false.
+ */
+static bool hash_one_block(struct hash_ctx *hash, struct block_buffer *cur,
+			   u32 block_size, const u8 *salt, u32 salt_size)
+{
+	struct block_buffer *next = cur + 1;
+
+	/* Zero-pad the block if it's shorter than block_size. */
+	memset(&cur->data[cur->filled], 0, block_size - cur->filled);
+
+	hash_init(hash);
+	hash_update(hash, salt, salt_size);
+	hash_update(hash, cur->data, block_size);
+	hash_final(hash, &next->data[next->filled]);
+
+	next->filled += hash->alg->digest_size;
+	cur->filled = 0;
+
+	return next->filled + hash->alg->digest_size > block_size;
+}
+
+/*
+ * Compute the file's Merkle tree root hash using the given hash algorithm,
+ * block size, and salt.
+ */
+static bool compute_root_hash(struct filedes *file, u64 file_size,
+			      struct hash_ctx *hash, u32 block_size,
+			      const u8 *salt, u32 salt_size, u8 *root_hash)
+{
+	const u32 hashes_per_block = block_size / hash->alg->digest_size;
+	const u32 padded_salt_size = roundup(salt_size, hash->alg->block_size);
+	u8 *padded_salt = xzalloc(padded_salt_size);
+	u64 blocks;
+	int num_levels = 0;
+	int level;
+	struct block_buffer _buffers[1 + FS_VERITY_MAX_LEVELS + 1] = {};
+	struct block_buffer *buffers = &_buffers[1];
+	u64 offset;
+	bool ok = false;
+
+	if (salt_size != 0)
+		memcpy(padded_salt, salt, salt_size);
+
+	/* Compute number of levels */
+	for (blocks = DIV_ROUND_UP(file_size, block_size); blocks > 1;
+	     blocks = DIV_ROUND_UP(blocks, hashes_per_block)) {
+		ASSERT(num_levels < FS_VERITY_MAX_LEVELS);
+		num_levels++;
+	}
+
+	/*
+	 * Allocate the block buffers.  Buffer "-1" is for data blocks.
+	 * Buffers 0 <= level < num_levels are for the actual tree levels.
+	 * Buffer 'num_levels' is for the root hash.
+	 */
+	for (level = -1; level < num_levels; level++)
+		buffers[level].data = xmalloc(block_size);
+	buffers[num_levels].data = root_hash;
+
+	/* Hash each data block, also hashing the tree blocks as they fill up */
+	for (offset = 0; offset < file_size; offset += block_size) {
+		buffers[-1].filled = min(block_size, file_size - offset);
+
+		if (!full_read(file, buffers[-1].data, buffers[-1].filled))
+			goto out;
+
+		level = -1;
+		while (hash_one_block(hash, &buffers[level], block_size,
+				      padded_salt, padded_salt_size)) {
+			level++;
+			ASSERT(level < num_levels);
+		}
+	}
+	/* Finish all nonempty pending tree blocks */
+	for (level = 0; level < num_levels; level++) {
+		if (buffers[level].filled != 0)
+			hash_one_block(hash, &buffers[level], block_size,
+				       padded_salt, padded_salt_size);
+	}
+
+	/* Root hash was filled by the last call to hash_one_block() */
+	ASSERT(buffers[num_levels].filled == hash->alg->digest_size);
+	ok = true;
+out:
+	for (level = -1; level < num_levels; level++)
+		free(buffers[level].data);
+	free(padded_salt);
+	return ok;
+}
+
+/*
+ * Compute the fs-verity measurement of the given file.
+ *
+ * The fs-verity measurement is the hash of the fsverity_descriptor, which
+ * contains the Merkle tree properties including the root hash.
+ */
+bool compute_file_measurement(const char *filename,
+			      const struct fsverity_hash_alg *hash_alg,
+			      u32 block_size, const u8 *salt,
+			      u32 salt_size, u8 *measurement)
+{
+	struct filedes file = { .fd = -1 };
+	struct hash_ctx *hash = hash_create(hash_alg);
+	u64 file_size;
+	struct fsverity_descriptor desc;
+	bool ok = false;
+
+	if (!open_file(&file, filename, O_RDONLY, 0))
+		goto out;
+
+	if (!get_file_size(&file, &file_size))
+		goto out;
+
+	memset(&desc, 0, sizeof(desc));
+	desc.version = 1;
+	desc.hash_algorithm = hash_alg - fsverity_hash_algs;
+
+	ASSERT(is_power_of_2(block_size));
+	desc.log_blocksize = ilog2(block_size);
+
+	if (salt_size != 0) {
+		if (salt_size > sizeof(desc.salt)) {
+			error_msg("Salt too long (got %u bytes; max is %zu bytes)",
+				  salt_size, sizeof(desc.salt));
+			goto out;
+		}
+		memcpy(desc.salt, salt, salt_size);
+		desc.salt_size = salt_size;
+	}
+
+	desc.data_size = cpu_to_le64(file_size);
+
+	/* Root hash of empty file is all 0's */
+	if (file_size != 0 &&
+	    !compute_root_hash(&file, file_size, hash, block_size, salt,
+			       salt_size, desc.root_hash))
+		goto out;
+
+	hash_full(hash, &desc, sizeof(desc), measurement);
+	ok = true;
+out:
+	filedes_close(&file);
+	hash_free(hash);
+	return ok;
+}
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
new file mode 100644
index 0000000..c98428f
--- /dev/null
+++ b/lib/sign_digest.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * sign_digest.c
+ *
+ * Copyright 2018 Google LLC
+ */
+
+#include "hash_algs.h"
+#include "sign.h"
+
+#include <limits.h>
+#include <openssl/bio.h>
+#include <openssl/err.h>
+#include <openssl/pem.h>
+#include <openssl/pkcs7.h>
+
+static void __printf(1, 2) __cold
+error_msg_openssl(const char *format, ...)
+{
+	va_list va;
+
+	va_start(va, format);
+	do_error_msg(format, va, 0);
+	va_end(va);
+
+	if (ERR_peek_error() == 0)
+		return;
+
+	fprintf(stderr, "OpenSSL library errors:\n");
+	ERR_print_errors_fp(stderr);
+}
+
+/* Read a PEM PKCS#8 formatted private key */
+static EVP_PKEY *read_private_key(const char *keyfile)
+{
+	BIO *bio;
+	EVP_PKEY *pkey;
+
+	bio = BIO_new_file(keyfile, "r");
+	if (!bio) {
+		error_msg_openssl("can't open '%s' for reading", keyfile);
+		return NULL;
+	}
+
+	pkey = PEM_read_bio_PrivateKey(bio, NULL, NULL, NULL);
+	if (!pkey) {
+		error_msg_openssl("Failed to parse private key file '%s'.\n"
+				  "       Note: it must be in PEM PKCS#8 format.",
+				  keyfile);
+	}
+	BIO_free(bio);
+	return pkey;
+}
+
+/* Read a PEM X.509 formatted certificate */
+static X509 *read_certificate(const char *certfile)
+{
+	BIO *bio;
+	X509 *cert;
+
+	bio = BIO_new_file(certfile, "r");
+	if (!bio) {
+		error_msg_openssl("can't open '%s' for reading", certfile);
+		return NULL;
+	}
+	cert = PEM_read_bio_X509(bio, NULL, NULL, NULL);
+	if (!cert) {
+		error_msg_openssl("Failed to parse X.509 certificate file '%s'.\n"
+				  "       Note: it must be in PEM format.",
+				  certfile);
+	}
+	BIO_free(bio);
+	return cert;
+}
+
+#ifdef OPENSSL_IS_BORINGSSL
+
+static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
+		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
+		       u8 **sig_ret, u32 *sig_size_ret)
+{
+	CBB out, outer_seq, wrapped_seq, seq, digest_algos_set, digest_algo,
+		null, content_info, issuer_and_serial, signer_infos,
+		signer_info, sign_algo, signature;
+	EVP_MD_CTX md_ctx;
+	u8 *name_der = NULL, *sig = NULL, *pkcs7_data = NULL;
+	size_t pkcs7_data_len, sig_len;
+	int name_der_len, sig_nid;
+	bool ok = false;
+
+	EVP_MD_CTX_init(&md_ctx);
+	BIGNUM *serial = ASN1_INTEGER_to_BN(X509_get_serialNumber(cert), NULL);
+
+	if (!CBB_init(&out, 1024)) {
+		error_msg("out of memory");
+		goto out;
+	}
+
+	name_der_len = i2d_X509_NAME(X509_get_subject_name(cert), &name_der);
+	if (name_der_len < 0) {
+		error_msg_openssl("i2d_X509_NAME failed");
+		goto out;
+	}
+
+	if (!EVP_DigestSignInit(&md_ctx, NULL, md, NULL, pkey)) {
+		error_msg_openssl("EVP_DigestSignInit failed");
+		goto out;
+	}
+
+	sig_len = EVP_PKEY_size(pkey);
+	sig = xmalloc(sig_len);
+	if (!EVP_DigestSign(&md_ctx, sig, &sig_len, data_to_sign, data_size)) {
+		error_msg_openssl("EVP_DigestSign failed");
+		goto out;
+	}
+
+	sig_nid = EVP_PKEY_id(pkey);
+	/* To mirror OpenSSL behaviour, always use |NID_rsaEncryption| with RSA
+	 * rather than the combined hash+pkey NID. */
+	if (sig_nid != NID_rsaEncryption) {
+		OBJ_find_sigid_by_algs(&sig_nid, EVP_MD_type(md),
+				       EVP_PKEY_id(pkey));
+	}
+
+	// See https://tools.ietf.org/html/rfc2315#section-7
+	if (!CBB_add_asn1(&out, &outer_seq, CBS_ASN1_SEQUENCE) ||
+	    !OBJ_nid2cbb(&outer_seq, NID_pkcs7_signed) ||
+	    !CBB_add_asn1(&outer_seq, &wrapped_seq, CBS_ASN1_CONTEXT_SPECIFIC |
+			  CBS_ASN1_CONSTRUCTED | 0) ||
+	    // See https://tools.ietf.org/html/rfc2315#section-9.1
+	    !CBB_add_asn1(&wrapped_seq, &seq, CBS_ASN1_SEQUENCE) ||
+	    !CBB_add_asn1_uint64(&seq, 1 /* version */) ||
+	    !CBB_add_asn1(&seq, &digest_algos_set, CBS_ASN1_SET) ||
+	    !CBB_add_asn1(&digest_algos_set, &digest_algo, CBS_ASN1_SEQUENCE) ||
+	    !OBJ_nid2cbb(&digest_algo, EVP_MD_type(md)) ||
+	    !CBB_add_asn1(&digest_algo, &null, CBS_ASN1_NULL) ||
+	    !CBB_add_asn1(&seq, &content_info, CBS_ASN1_SEQUENCE) ||
+	    !OBJ_nid2cbb(&content_info, NID_pkcs7_data) ||
+	    !CBB_add_asn1(&seq, &signer_infos, CBS_ASN1_SET) ||
+	    !CBB_add_asn1(&signer_infos, &signer_info, CBS_ASN1_SEQUENCE) ||
+	    !CBB_add_asn1_uint64(&signer_info, 1 /* version */) ||
+	    !CBB_add_asn1(&signer_info, &issuer_and_serial,
+			  CBS_ASN1_SEQUENCE) ||
+	    !CBB_add_bytes(&issuer_and_serial, name_der, name_der_len) ||
+	    !BN_marshal_asn1(&issuer_and_serial, serial) ||
+	    !CBB_add_asn1(&signer_info, &digest_algo, CBS_ASN1_SEQUENCE) ||
+	    !OBJ_nid2cbb(&digest_algo, EVP_MD_type(md)) ||
+	    !CBB_add_asn1(&digest_algo, &null, CBS_ASN1_NULL) ||
+	    !CBB_add_asn1(&signer_info, &sign_algo, CBS_ASN1_SEQUENCE) ||
+	    !OBJ_nid2cbb(&sign_algo, sig_nid) ||
+	    !CBB_add_asn1(&sign_algo, &null, CBS_ASN1_NULL) ||
+	    !CBB_add_asn1(&signer_info, &signature, CBS_ASN1_OCTETSTRING) ||
+	    !CBB_add_bytes(&signature, sig, sig_len) ||
+	    !CBB_finish(&out, &pkcs7_data, &pkcs7_data_len)) {
+		error_msg_openssl("failed to construct PKCS#7 data");
+		goto out;
+	}
+
+	*sig_ret = xmemdup(pkcs7_data, pkcs7_data_len);
+	*sig_size_ret = pkcs7_data_len;
+	ok = true;
+out:
+	BN_free(serial);
+	EVP_MD_CTX_cleanup(&md_ctx);
+	CBB_cleanup(&out);
+	free(sig);
+	OPENSSL_free(name_der);
+	OPENSSL_free(pkcs7_data);
+	return ok;
+}
+
+#else /* OPENSSL_IS_BORINGSSL */
+
+static BIO *new_mem_buf(const void *buf, size_t size)
+{
+	BIO *bio;
+
+	ASSERT(size <= INT_MAX);
+	/*
+	 * Prior to OpenSSL 1.1.0, BIO_new_mem_buf() took a non-const pointer,
+	 * despite still marking the resulting bio as read-only.  So cast away
+	 * the const to avoid a compiler warning with older OpenSSL versions.
+	 */
+	bio = BIO_new_mem_buf((void *)buf, size);
+	if (!bio)
+		error_msg_openssl("out of memory");
+	return bio;
+}
+
+static bool sign_pkcs7(const void *data_to_sign, size_t data_size,
+		       EVP_PKEY *pkey, X509 *cert, const EVP_MD *md,
+		       u8 **sig_ret, u32 *sig_size_ret)
+{
+	/*
+	 * PKCS#7 signing flags:
+	 *
+	 * - PKCS7_BINARY	signing binary data, so skip MIME translation
+	 *
+	 * - PKCS7_DETACHED	omit the signed data (include signature only)
+	 *
+	 * - PKCS7_NOATTR	omit extra authenticated attributes, such as
+	 *			SMIMECapabilities
+	 *
+	 * - PKCS7_NOCERTS	omit the signer's certificate
+	 *
+	 * - PKCS7_PARTIAL	PKCS7_sign() creates a handle only, then
+	 *			PKCS7_sign_add_signer() can add a signer later.
+	 *			This is necessary to change the message digest
+	 *			algorithm from the default of SHA-1.  Requires
+	 *			OpenSSL 1.0.0 or later.
+	 */
+	int pkcs7_flags = PKCS7_BINARY | PKCS7_DETACHED | PKCS7_NOATTR |
+			  PKCS7_NOCERTS | PKCS7_PARTIAL;
+	u8 *sig;
+	u32 sig_size;
+	BIO *bio = NULL;
+	PKCS7 *p7 = NULL;
+	bool ok = false;
+
+	bio = new_mem_buf(data_to_sign, data_size);
+	if (!bio)
+		goto out;
+
+	p7 = PKCS7_sign(NULL, NULL, NULL, bio, pkcs7_flags);
+	if (!p7) {
+		error_msg_openssl("failed to initialize PKCS#7 signature object");
+		goto out;
+	}
+
+	if (!PKCS7_sign_add_signer(p7, cert, pkey, md, pkcs7_flags)) {
+		error_msg_openssl("failed to add signer to PKCS#7 signature object");
+		goto out;
+	}
+
+	if (PKCS7_final(p7, bio, pkcs7_flags) != 1) {
+		error_msg_openssl("failed to finalize PKCS#7 signature");
+		goto out;
+	}
+
+	BIO_free(bio);
+	bio = BIO_new(BIO_s_mem());
+	if (!bio) {
+		error_msg_openssl("out of memory");
+		goto out;
+	}
+
+	if (i2d_PKCS7_bio(bio, p7) != 1) {
+		error_msg_openssl("failed to DER-encode PKCS#7 signature object");
+		goto out;
+	}
+
+	sig_size = BIO_get_mem_data(bio, &sig);
+	*sig_ret = xmemdup(sig, sig_size);
+	*sig_size_ret = sig_size;
+	ok = true;
+out:
+	PKCS7_free(p7);
+	BIO_free(bio);
+	return ok;
+}
+
+#endif /* !OPENSSL_IS_BORINGSSL */
+
+/*
+ * Sign the specified @data_to_sign of length @data_size bytes using the private
+ * key in @keyfile, the certificate in @certfile, and the hash algorithm
+ * @hash_alg.  Returns the DER-formatted PKCS#7 signature in @sig_ret and
+ * @sig_size_ret.
+ */
+bool sign_data(const void *data_to_sign, size_t data_size,
+	       const char *keyfile, const char *certfile,
+	       const struct fsverity_hash_alg *hash_alg,
+	       u8 **sig_ret, u32 *sig_size_ret)
+{
+	EVP_PKEY *pkey = NULL;
+	X509 *cert = NULL;
+	const EVP_MD *md;
+	bool ok = false;
+
+	pkey = read_private_key(keyfile);
+	if (!pkey)
+		goto out;
+
+	cert = read_certificate(certfile);
+	if (!cert)
+		goto out;
+
+	OpenSSL_add_all_digests();
+	md = EVP_get_digestbyname(hash_alg->name);
+	if (!md) {
+		fprintf(stderr,
+			"Warning: '%s' algorithm not found in OpenSSL library.\n"
+			"         Falling back to SHA-256 signature.\n",
+			hash_alg->name);
+		md = EVP_sha256();
+	}
+
+	ok = sign_pkcs7(data_to_sign, data_size, pkey, cert, md,
+			sig_ret, sig_size_ret);
+out:
+	EVP_PKEY_free(pkey);
+	X509_free(cert);
+	return ok;
+}
diff --git a/sign.h b/sign.h
new file mode 100644
index 0000000..55c8be8
--- /dev/null
+++ b/sign.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef SIGN_H
+#define SIGN_H
+
+#include "hash_algs.h"
+
+#include <linux/types.h>
+
+/*
+ * Format in which verity file measurements are signed.  This is the same as
+ * 'struct fsverity_digest', except here some magic bytes are prepended to
+ * provide some context about what is being signed in case the same key is used
+ * for non-fsverity purposes, and here the fields have fixed endianness.
+ */
+struct fsverity_signed_digest {
+	char magic[8];			/* must be "FSVerity" */
+	__le16 digest_algorithm;
+	__le16 digest_size;
+	__u8 digest[];
+};
+
+bool compute_file_measurement(const char *filename,
+			      const struct fsverity_hash_alg *hash_alg,
+			      u32 block_size, const u8 *salt,
+			      u32 salt_size, u8 *measurement);
+
+bool sign_data(const void *data_to_sign, size_t data_size,
+	       const char *keyfile, const char *certfile,
+	       const struct fsverity_hash_alg *hash_alg,
+	       u8 **sig_ret, u32 *sig_size_ret);
+
+#endif /* SIGN_H */
-- 
2.26.2

