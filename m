Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C605183BAE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgCLVsa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43018 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVs3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id l13so5748718qtv.10
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=124bUjJbZbXn/P1mXZFZfkNVP043w3RC/02D+Wz9ovs=;
        b=Bgqa16yD187KPiqgC3XHnVE2iKEF9cFc7nwcyUcFGnli/F2tBhJ9XqrRj/RifcCvdk
         GveiHc1snTAhh/VEIa715Zg4KNWEMp3ZF57KcpTphAIikNv5Rr7ahwywFU6eh0M7cX+S
         60TBZqX0mzknBGQZCgGN1CvAts75ljpcwqWWlScMYYEvUckuXoDAR1w11EAOtKNpsu1k
         3gYihNhvjS16EvW6KhOl9hXcwNgk82KOlgfbWjShHkJhmVqYBtdkIwI3JPCcurepGjQY
         jS951F4oCI951Kz3fE3nQGbeQt7H8Fpy4I0z4m8ErOSKCqadK1CPizWzz/pE5sCfOx1K
         qJrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=124bUjJbZbXn/P1mXZFZfkNVP043w3RC/02D+Wz9ovs=;
        b=Y5x+qS/cDJ7oW+mwN3xgSIt3BdRKeym0yAd4VJfzF5rOUVYjZ7SA2zo/CmfU4BJkLo
         tDpXI+vp5Amdhx7Ey4IXJPkHd2qOnW/Mo2JVcOnO1rowmnCA26rWKke1Sc9e1RenkZuL
         //f4d5BZ6UWYIysM5JRDnxMCTxUWD8MbY3nyLRnccZjJW+LWhOWMPQPcDNKcTyDmHBTS
         +a/VlYTvTGaT8WtflFlXIGZr0Ze7Yia0/z/M8oZyX3MIgaiuJPkVUl4bdHLi7JdtmZR7
         /dlcBYdN7I8DDeYgE18d2HoSeUGrlupDhQuQCWEpSwY4esOuXWbgk5Ov7NmplngvyEf8
         2v5g==
X-Gm-Message-State: ANhLgQ0s9yPF/cxLh+c6Z1e4Ib21u/NtQpJvZ3GdCzOOGs0XF3s/Wq5z
        QXB0nGDfbf+2jca4qC/ub5OxJ7G2
X-Google-Smtp-Source: ADFU+vsRp//+B+JPsVbAAVoNcqLHFUNCRpKIoxCspfr9jjS3heVs3VIXtcbxsKJvlsJfZNvc8tsDGg==
X-Received: by 2002:ac8:340d:: with SMTP id u13mr8276061qtb.235.1584049706775;
        Thu, 12 Mar 2020 14:48:26 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id r15sm10542866qtr.40.2020.03.12.14.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:26 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 6/9] Introduce libfsverity_sign_digest()
Date:   Thu, 12 Mar 2020 17:47:55 -0400
Message-Id: <20200312214758.343212-7-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

This moves the signing code into libfsverity and switches cmd_sign to use it.

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 cmd_sign.c    | 317 ++------------------------------------------------
 libfsverity.h |  12 ++
 libverity.c   | 309 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 329 insertions(+), 309 deletions(-)

diff --git a/cmd_sign.c b/cmd_sign.c
index 6a5d185..e48e0aa 100644
--- a/cmd_sign.c
+++ b/cmd_sign.c
@@ -10,318 +10,12 @@
 #include <fcntl.h>
 #include <getopt.h>
 #include <limits.h>
-#include <openssl/bio.h>
-#include <openssl/err.h>
-#include <openssl/pem.h>
-#include <openssl/pkcs7.h>
 #include <stdlib.h>
 #include <string.h>
 
 #include "commands.h"
 #include "libfsverity.h"
 
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
@@ -364,9 +58,10 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	const char *certfile = NULL;
 	struct libfsverity_digest *digest = NULL;
 	struct libfsverity_merkle_tree_params params;
+	struct libfsverity_signature_params sig_params;
 	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + 1];
 	u8 *sig = NULL;
-	u32 sig_size;
+	size_t sig_size;
 	int status;
 	int c;
 
@@ -448,9 +143,13 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	filedes_close(&file);
 
-	if (!sign_data(digest, sizeof(*digest) + hash_alg->digest_size,
-		       keyfile, certfile, hash_alg, &sig, &sig_size))
+	memset(&sig_params, 0, sizeof(struct libfsverity_signature_params));
+	sig_params.keyfile = keyfile;
+	sig_params.certfile = certfile;
+	if (libfsverity_sign_digest(digest, &sig_params, &sig, &sig_size)) {
+		error_msg("Failed to sign digest");
 		goto out_err;
+	}
 
 	if (!write_signature(argv[1], sig, sig_size))
 		goto out_err;
diff --git a/libfsverity.h b/libfsverity.h
index cb5f5b6..a2abdb3 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -36,6 +36,13 @@ struct libfsverity_merkle_tree_params {
  */
 #define FS_VERITY_MAX_DIGEST_SIZE	64
 
+/*
+ * Format in which verity file measurements are signed.  This is the same as
+ * 'struct fsverity_digest', except here some magic bytes are prepended to
+ * provide some context about what is being signed in case the same key is used
+ * for non-fsverity purposes, and here the fields have fixed endianness.
+ */
+
 struct libfsverity_digest {
 	char magic[8];			/* must be "FSVerity" */
 	uint16_t digest_algorithm;
@@ -62,6 +69,11 @@ libfsverity_compute_digest(int fd,
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret);
 
+int
+libfsverity_sign_digest(const struct libfsverity_digest *digest,
+			const struct libfsverity_signature_params *sig_params,
+			uint8_t **sig_ret, size_t *sig_size_ret);
+
 const struct fsverity_hash_alg *
 libfsverity_find_hash_alg_by_name(const char *name);
 const struct fsverity_hash_alg *
diff --git a/libverity.c b/libverity.c
index 19272f7..183259e 100644
--- a/libverity.c
+++ b/libverity.c
@@ -215,3 +215,312 @@ libfsverity_compute_digest(int fd,
 	free(digest);
 	return retval;
 }
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
+		       u8 **sig_ret, size_t *sig_size_ret)
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
+		       u8 **sig_ret, size_t *sig_size_ret)
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
+ * Sign the digest using the private key in @keyfile, the certificate in
+ * @certfile, and the hash algorithm specified in the digest.
+ * Return 0 on success, the DER-formatted PKCS#7 signature in @sig_ret and
+ * it's size in @sig_size_ret.
+ */
+int
+libfsverity_sign_digest(const struct libfsverity_digest *digest,
+			const struct libfsverity_signature_params *sig_params,
+			uint8_t **sig_ret, size_t *sig_size_ret)
+{
+	const struct fsverity_hash_alg *hash_alg;
+	EVP_PKEY *pkey = NULL;
+	X509 *cert = NULL;
+	const EVP_MD *md;
+	size_t data_size;
+	uint16_t alg_nr;
+	int retval = -EAGAIN;
+
+	data_size = sizeof(struct libfsverity_digest) +
+		le16_to_cpu(digest->digest_size);
+	alg_nr = le16_to_cpu(digest->digest_algorithm);
+	hash_alg = libfsverity_find_hash_alg_by_num(alg_nr);
+
+	if (!hash_alg) {
+		retval = -EINVAL;
+		goto out;
+	}
+
+	pkey = read_private_key(sig_params->keyfile);
+	if (!pkey) {
+		retval = -EAGAIN;
+		goto out;
+	}
+
+	cert = read_certificate(sig_params->certfile);
+	if (!cert) {
+		retval = -EAGAIN;
+		goto out;
+	}
+
+	OpenSSL_add_all_digests();
+
+	md = EVP_get_digestbyname(hash_alg->name);
+	if (!md) {
+		fprintf(stderr,
+			"Warning: '%s' algorithm not found in OpenSSL library.\n"
+			"         Falling back to SHA-256 signature.\n",
+			hash_alg->name);
+		md = EVP_sha256();
+	}
+
+	if (sign_pkcs7(digest, data_size, pkey, cert, md,
+		       sig_ret, sig_size_ret))
+		retval = 0;
+
+ out:
+	EVP_PKEY_free(pkey);
+	X509_free(cert);
+	return retval;
+}
-- 
2.24.1

