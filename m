Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F7D405EC0
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 23:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346721AbhIIV3A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Sep 2021 17:29:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61940 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239163AbhIIV3A (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Sep 2021 17:29:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 189LLs5O022940
        for <linux-fscrypt@vger.kernel.org>; Thu, 9 Sep 2021 14:27:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=8pAdUNY/qpKkcMutzn2dIlzvVXeErzYEtuJAPSHUP5E=;
 b=JaqvU8D/UTpaqyQba//Ls5rJ9iG55a0OeThGxb56e8P5EB3KNE0ZE8ik57s0/m718HVD
 kW+4GZo5L6udiLwQ2CjCaUUoo6Pl5BHjfLtg6gTvL/fOzHyPUzGKJu/m158ajE+7QB06
 LDoS5HgW6HS3GwaZ0/bi+q4kXcxNf9tEvIo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ay5brhjx5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Sep 2021 14:27:49 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 9 Sep 2021 14:27:46 -0700
Received: by devvm4043.ftw0.facebook.com (Postfix, from userid 11172)
        id 20A784043703; Thu,  9 Sep 2021 14:27:43 -0700 (PDT)
From:   Aleksander Adamowski <olo@fb.com>
To:     <linux-fscrypt@vger.kernel.org>
CC:     Aleksander Adamowski <olo@fb.com>,
        Eric Biggers <ebiggers@google.com>
Subject: [fsverity-utils PATCH v5] Implement PKCS#11 opaque keys support through OpenSSL pkcs11 engine
Date:   Thu, 9 Sep 2021 14:27:31 -0700
Message-ID: <20210909212731.1151190-1-olo@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: kIFmf2PwQy5wXkKU_2gsIehkHOBWNRMn
X-Proofpoint-ORIG-GUID: kIFmf2PwQy5wXkKU_2gsIehkHOBWNRMn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_08:2021-09-09,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

PKCS#11 API allows us to use opaque keys confined in hardware security
modules (HSMs) and similar hardware tokens without direct access to the
key material, providing logical separation of the keys from the
cryptographic operations performed using them.

This commit allows using the popular libp11 pkcs11 module for the
OpenSSL library with `fsverity` so that direct access to a private key
file isn't necessary to sign files.

The user needs to supply the path to the engine shared library
(typically the libp11 shared object file) and the PKCS#11 module library
(a shared object file specific to the given hardware token).  The user
may also supply a token-specific key identifier.

Test evidence with a hardware PKCS#11 token:

  $ echo test > dummy
  $ ./fsverity sign dummy dummy.sig \
    --pkcs11-engine=3D/usr/lib64/engines-1.1/libpkcs11.so \
    --pkcs11-module=3D/usr/local/lib64/pkcs11_module.so \
    --cert=3Dtest-pkcs11-cert.pem && echo OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb6=
5)
  OK

Test evidence for regression check (checking that regular file-based key
signing still works):

  $ ./fsverity sign dummy dummy.sig --key=3Dkey.pem --cert=3Dcert.pem && =
\
    echo  OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb6=
5)
  OK

Signed-off-by: Aleksander Adamowski <olo@fb.com>
[EB: Avoided overloading the --key option and keyfile field, clarified
 the documentation, removed logic from cmd_sign.c that libfsverity
 already handles, and many other improvements.]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/libfsverity.h | 44 ++++++++++++++++++---
 lib/sign_digest.c     | 92 ++++++++++++++++++++++++++++++++++++++-----
 man/fsverity.1.md     | 28 +++++++++++--
 programs/cmd_sign.c   | 48 +++++++++++++++-------
 programs/fsverity.c   |  5 ++-
 programs/fsverity.h   |  3 ++
 6 files changed, 185 insertions(+), 35 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 6cefa2b..fe89371 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -81,11 +81,44 @@ struct libfsverity_digest {
 	uint8_t digest[];		/* the actual digest */
 };
=20
+/**
+ * struct libfsverity_signature_params - certificate and private key inf=
ormation
+ *
+ * Zero this, then set @certfile.  Then, to specify the private key by k=
ey file,
+ * set @keyfile.  Alternatively, to specify the private key by PKCS#11 t=
oken,
+ * set @pkcs11_engine, @pkcs11_module, and optionally @pkcs11_keyid.
+ *
+ * Support for PKCS#11 tokens is unavailable when libfsverity was linked=
 to
+ * BoringSSL rather than OpenSSL.
+ */
 struct libfsverity_signature_params {
-	const char *keyfile;		/* path to key file (PEM format) */
-	const char *certfile;		/* path to certificate (PEM format) */
-	uint64_t reserved1[8];		/* must be 0 */
-	uintptr_t reserved2[8];		/* must be 0 */
+
+	/** @keyfile: the path to the key file in PEM format, when applicable *=
/
+	const char *keyfile;
+
+	/** @certfile: the path to the certificate file in PEM format */
+	const char *certfile;
+
+	/** @reserved1: must be 0 */
+	uint64_t reserved1[8];
+
+	/**
+	 * @pkcs11_engine: the path to the PKCS#11 engine .so file, when
+	 * applicable
+	 */
+	const char *pkcs11_engine;
+
+	/**
+	 * @pkcs11_module: the path to the PKCS#11 module .so file, when
+	 * applicable
+	 */
+	const char *pkcs11_module;
+
+	/** @pkcs11_keyid: the PKCS#11 key identifier, when applicable */
+	const char *pkcs11_keyid;
+
+	/** @reserved2: must be 0 */
+	uintptr_t reserved2[5];
 };
=20
 struct libfsverity_metadata_callbacks {
@@ -161,8 +194,7 @@ libfsverity_compute_digest(void *fd, libfsverity_read=
_fn_t read_fn,
  *          Documentation/filesystems/fsverity.rst in the kernel source =
tree for
  *          further details.
  * @digest: pointer to previously computed digest
- * @sig_params: struct libfsverity_signature_params providing filenames =
of
- *          the keyfile and certificate file. Reserved fields must be ze=
ro.
+ * @sig_params: pointer to the certificate and private key information
  * @sig_ret: Pointer to pointer for signed digest
  * @sig_size_ret: Pointer to size of signed return digest
  *
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 9a35256..da23d04 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -81,6 +81,11 @@ static int read_certificate(const char *certfile, X509=
 **cert_ret)
 	X509 *cert;
 	int err;
=20
+	if (!certfile) {
+		libfsverity_error_msg("no certificate specified");
+		return -EINVAL;
+	}
+
 	errno =3D 0;
 	bio =3D BIO_new_file(certfile, "r");
 	if (!bio) {
@@ -212,8 +217,62 @@ out:
 	return err;
 }
=20
+static int
+load_pkcs11_private_key(const struct libfsverity_signature_params *sig_p=
arams
+			__attribute__((unused)),
+			EVP_PKEY **pkey_ret __attribute__((unused)))
+{
+	libfsverity_error_msg("BoringSSL doesn't support PKCS#11 tokens");
+	return -EINVAL;
+}
+
 #else /* OPENSSL_IS_BORINGSSL */
=20
+#include <openssl/engine.h>
+
+static int
+load_pkcs11_private_key(const struct libfsverity_signature_params *sig_p=
arams,
+			EVP_PKEY **pkey_ret)
+{
+	ENGINE *engine;
+
+	if (!sig_params->pkcs11_engine) {
+		libfsverity_error_msg("PKCS#11 engine not specified");
+		return -EINVAL;
+	}
+	if (!sig_params->pkcs11_module) {
+		libfsverity_error_msg("PKCS#11 module not specified");
+		return -EINVAL;
+	}
+	ENGINE_load_dynamic();
+	engine =3D ENGINE_by_id("dynamic");
+	if (!engine) {
+		error_msg_openssl("failed to initialize OpenSSL PKCS#11 engine");
+		return -EINVAL;
+	}
+	if (!ENGINE_ctrl_cmd_string(engine, "SO_PATH",
+				    sig_params->pkcs11_engine, 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "ID", "pkcs11", 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "LIST_ADD", "1", 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "LOAD", NULL, 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "MODULE_PATH",
+				    sig_params->pkcs11_module, 0) ||
+	    !ENGINE_init(engine)) {
+		error_msg_openssl("failed to initialize OpenSSL PKCS#11 engine");
+		ENGINE_free(engine);
+		return -EINVAL;
+	}
+	*pkey_ret =3D ENGINE_load_private_key(engine, sig_params->pkcs11_keyid,
+					    NULL, NULL);
+	ENGINE_finish(engine);
+	ENGINE_free(engine);
+	if (!*pkey_ret) {
+		error_msg_openssl("failed to load private key from PKCS#11 token");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static BIO *new_mem_buf(const void *buf, size_t size)
 {
 	BIO *bio;
@@ -317,14 +376,34 @@ out:
=20
 #endif /* !OPENSSL_IS_BORINGSSL */
=20
+/* Get a private key, either from disk or from a PKCS#11 token. */
+static int
+get_private_key(const struct libfsverity_signature_params *sig_params,
+		EVP_PKEY **pkey_ret)
+{
+	if (sig_params->pkcs11_engine || sig_params->pkcs11_module ||
+	    sig_params->pkcs11_keyid) {
+		if (sig_params->keyfile) {
+			libfsverity_error_msg("private key must be specified either by file o=
r by PKCS#11 token, not both");
+			return -EINVAL;
+		}
+		return load_pkcs11_private_key(sig_params, pkey_ret);
+	}
+	if (!sig_params->keyfile) {
+		libfsverity_error_msg("no private key specified");
+		return -EINVAL;
+	}
+	return read_private_key(sig_params->keyfile, pkey_ret);
+}
+
 LIBEXPORT int
 libfsverity_sign_digest(const struct libfsverity_digest *digest,
 			const struct libfsverity_signature_params *sig_params,
 			u8 **sig_ret, size_t *sig_size_ret)
 {
 	const struct fsverity_hash_alg *hash_alg;
-	EVP_PKEY *pkey =3D NULL;
 	X509 *cert =3D NULL;
+	EVP_PKEY *pkey =3D NULL;
 	const EVP_MD *md;
 	struct fsverity_formatted_digest *d =3D NULL;
 	int err;
@@ -334,11 +413,6 @@ libfsverity_sign_digest(const struct libfsverity_dig=
est *digest,
 		return -EINVAL;
 	}
=20
-	if (!sig_params->keyfile || !sig_params->certfile) {
-		libfsverity_error_msg("keyfile and certfile must be specified");
-		return -EINVAL;
-	}
-
 	if (!libfsverity_mem_is_zeroed(sig_params->reserved1,
 				       sizeof(sig_params->reserved1)) ||
 	    !libfsverity_mem_is_zeroed(sig_params->reserved2,
@@ -353,11 +427,11 @@ libfsverity_sign_digest(const struct libfsverity_di=
gest *digest,
 		return -EINVAL;
 	}
=20
-	err =3D read_private_key(sig_params->keyfile, &pkey);
+	err =3D read_certificate(sig_params->certfile, &cert);
 	if (err)
 		goto out;
=20
-	err =3D read_certificate(sig_params->certfile, &cert);
+	err =3D get_private_key(sig_params, &pkey);
 	if (err)
 		goto out;
=20
@@ -383,8 +457,8 @@ libfsverity_sign_digest(const struct libfsverity_dige=
st *digest,
 	err =3D sign_pkcs7(d, sizeof(*d) + digest->digest_size,
 			 pkey, cert, md, sig_ret, sig_size_ret);
  out:
-	EVP_PKEY_free(pkey);
 	X509_free(cert);
+	EVP_PKEY_free(pkey);
 	free(d);
 	return err;
 }
diff --git a/man/fsverity.1.md b/man/fsverity.1.md
index e1007f5..a983912 100644
--- a/man/fsverity.1.md
+++ b/man/fsverity.1.md
@@ -11,7 +11,7 @@ fsverity - userspace utility for fs-verity
 **fsverity dump_metadata** [*OPTION*...] *TYPE* *FILE* \
 **fsverity enable** [*OPTION*...] *FILE* \
 **fsverity measure** *FILE*... \
-**fsverity sign \-\-key**=3D*KEYFILE* [*OPTION*...] *FILE* *OUT_SIGFILE*
+**fsverity sign** [*OPTION*...] *FILE* *OUT_SIGFILE*
=20
 # DESCRIPTION
=20
@@ -149,12 +149,18 @@ for each file regardless of the size of the file.
=20
 **fsverity measure** does not accept any options.
=20
-## **fsverity sign** **\-\-key**=3D*KEYFILE* [*OPTION*...] *FILE* *OUT_S=
IGFILE*
+## **fsverity sign** [*OPTION*...] *FILE* *OUT_SIGFILE*
=20
 Sign the given file for fs-verity, in a way that is compatible with the =
Linux
 kernel's fs-verity built-in signature verification support.  The signatu=
re will
 be written to *OUT_SIGFILE* in PKCS#7 DER format.
=20
+The private key can be specified either by key file or by PKCS#11 token.=
  To use
+a key file, provide **\-\-key** and optionally **\-\-cert**.  To use a P=
KCS#11
+token, provide **\-\-pkcs11-engine**, **\-\-pkcs11-module**, **\-\-cert*=
*, and
+optionally **\-\-pkcs11-keyid**.  PKCS#11 token support is unavailable w=
hen
+fsverity-utils was built with BoringSSL rather than OpenSSL.
+
 Options accepted by **fsverity sign**:
=20
 **\-\-block-size**=3D*BLOCK_SIZE*
@@ -163,14 +169,14 @@ Options accepted by **fsverity sign**:
 **\-\-cert**=3D*CERTFILE*
 :   Specifies the file that contains the certificate, in PEM format.  Th=
is
     option is required if *KEYFILE* contains only the private key and no=
t also
-    the certificate.
+    the certificate, or if a PKCS#11 token is used.
=20
 **\-\-hash-alg**=3D*HASH_ALG*
 :   Same as for **fsverity digest**.
=20
 **\-\-key**=3D*KEYFILE*
 :   Specifies the file that contains the private key, in PEM format.  Th=
is
-    option is required.
+    option is required when not using a PKCS#11 token.
=20
 **\-\-out-descriptor**=3D*FILE*
 :   Same as for **fsverity digest**.
@@ -178,6 +184,20 @@ Options accepted by **fsverity sign**:
 **\-\-out-merkle-tree**=3D*FILE*
 :   Same as for **fsverity digest**.
=20
+**\-\-pkcs11-engine**=3D*SOFILE*
+:   Specifies the path to the OpenSSL PKCS#11 engine file.  This typical=
ly will
+    be a path to the libp11 .so file.  This option is required when usin=
g a
+    PKCS#11 token.
+
+**\-\-pkcs11-keyid**=3D*KEYID*
+:   Specifies the key identifier in the form of a PKCS#11 URI.  If not p=
rovided,
+    the default key associated with the token is used.  This option is o=
nly
+    applicable when using a PKCS#11 token.
+
+**\-\-pkcs11-module**=3D*SOFILE*
+:   Specifies the path to the PKCS#11 token-specific module library.  Th=
is
+    option is required when using a PKCS#11 token.
+
 **\-\-salt**=3D*SALT*
 :   Same as for **fsverity digest**.
=20
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 81a4ddc..aab8f00 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -27,13 +27,16 @@ static bool write_signature(const char *filename, con=
st u8 *sig, u32 sig_size)
 }
=20
 static const struct option longopts[] =3D {
+	{"key",		    required_argument, NULL, OPT_KEY},
+	{"cert",	    required_argument, NULL, OPT_CERT},
+	{"pkcs11-engine",   required_argument, NULL, OPT_PKCS11_ENGINE},
+	{"pkcs11-module",   required_argument, NULL, OPT_PKCS11_MODULE},
+	{"pkcs11-keyid",    required_argument, NULL, OPT_PKCS11_KEYID},
 	{"hash-alg",	    required_argument, NULL, OPT_HASH_ALG},
 	{"block-size",	    required_argument, NULL, OPT_BLOCK_SIZE},
 	{"salt",	    required_argument, NULL, OPT_SALT},
 	{"out-merkle-tree", required_argument, NULL, OPT_OUT_MERKLE_TREE},
 	{"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
-	{"key",		    required_argument, NULL, OPT_KEY},
-	{"cert",	    required_argument, NULL, OPT_CERT},
 	{NULL, 0, NULL, 0}
 };
=20
@@ -53,14 +56,6 @@ int fsverity_cmd_sign(const struct fsverity_command *c=
md,
=20
 	while ((c =3D getopt_long(argc, argv, "", longopts, NULL)) !=3D -1) {
 		switch (c) {
-		case OPT_HASH_ALG:
-		case OPT_BLOCK_SIZE:
-		case OPT_SALT:
-		case OPT_OUT_MERKLE_TREE:
-		case OPT_OUT_DESCRIPTOR:
-			if (!parse_tree_param(c, optarg, &tree_params))
-				goto out_usage;
-			break;
 		case OPT_KEY:
 			if (sig_params.keyfile !=3D NULL) {
 				error_msg("--key can only be specified once");
@@ -75,6 +70,35 @@ int fsverity_cmd_sign(const struct fsverity_command *c=
md,
 			}
 			sig_params.certfile =3D optarg;
 			break;
+		case OPT_PKCS11_ENGINE:
+			if (sig_params.pkcs11_engine !=3D NULL) {
+				error_msg("--pkcs11-engine can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_engine =3D optarg;
+			break;
+		case OPT_PKCS11_MODULE:
+			if (sig_params.pkcs11_module !=3D NULL) {
+				error_msg("--pkcs11-module can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_module =3D optarg;
+			break;
+		case OPT_PKCS11_KEYID:
+			if (sig_params.pkcs11_keyid !=3D NULL) {
+				error_msg("--pkcs11-keyid can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_keyid =3D optarg;
+			break;
+		case OPT_HASH_ALG:
+		case OPT_BLOCK_SIZE:
+		case OPT_SALT:
+		case OPT_OUT_MERKLE_TREE:
+		case OPT_OUT_DESCRIPTOR:
+			if (!parse_tree_param(c, optarg, &tree_params))
+				goto out_usage;
+			break;
 		default:
 			goto out_usage;
 		}
@@ -86,10 +110,6 @@ int fsverity_cmd_sign(const struct fsverity_command *=
cmd,
 	if (argc !=3D 2)
 		goto out_usage;
=20
-	if (sig_params.keyfile =3D=3D NULL) {
-		error_msg("Missing --key argument");
-		goto out_usage;
-	}
 	if (sig_params.certfile =3D=3D NULL)
 		sig_params.certfile =3D sig_params.keyfile;
=20
diff --git a/programs/fsverity.c b/programs/fsverity.c
index f6aff3a..813ea2a 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -58,10 +58,11 @@ static const struct fsverity_command {
 		.func =3D fsverity_cmd_sign,
 		.short_desc =3D "Sign a file for fs-verity",
 		.usage_str =3D
-"    fsverity sign FILE OUT_SIGFILE --key=3DKEYFILE\n"
+"    fsverity sign FILE OUT_SIGFILE\n"
+"               [--key=3DKEYFILE] [--cert=3DCERTFILE] [--pkcs11-engine=3D=
SOFILE]\n"
+"               [--pkcs11-module=3DSOFILE] [--pkcs11-keyid=3DKEYID]\n"
 "               [--hash-alg=3DHASH_ALG] [--block-size=3DBLOCK_SIZE] [--s=
alt=3DSALT]\n"
 "               [--out-merkle-tree=3DFILE] [--out-descriptor=3DFILE]\n"
-"               [--cert=3DCERTFILE]\n"
 	}
 };
=20
diff --git a/programs/fsverity.h b/programs/fsverity.h
index fe24087..ad54cc2 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -31,6 +31,9 @@ enum {
 	OPT_OFFSET,
 	OPT_OUT_DESCRIPTOR,
 	OPT_OUT_MERKLE_TREE,
+	OPT_PKCS11_ENGINE,
+	OPT_PKCS11_KEYID,
+	OPT_PKCS11_MODULE,
 	OPT_SALT,
 	OPT_SIGNATURE,
 };
--=20
2.30.2

