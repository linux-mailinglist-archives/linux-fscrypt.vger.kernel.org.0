Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475F64041E4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 01:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbhIHXuJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 19:50:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19206 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233834AbhIHXuI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 19:50:08 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188NinI0021422
        for <linux-fscrypt@vger.kernel.org>; Wed, 8 Sep 2021 16:48:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=E1D1Wbj8nqLEElM53h6GmtEOcZ43a/8tkna2m0/uvjk=;
 b=Va2FwMm6/Jvu7VDZVulYeFs0TUFlVmyWeSQw8t+GrrHKYCK82LkSoM7SVbfWgSsEMpaQ
 togRjIJnHOcm74HC1EDX3xm3PXVWo/hKWUDCAmCrYjnwfd5cl1T61hPfehqHL3ymXJA6
 zLa5ivsOQUxYZL+HUk5wJEwf0l0prj0GB3A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcq53m80-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Sep 2021 16:48:59 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 8 Sep 2021 16:48:57 -0700
Received: by devvm4043.ftw0.facebook.com (Postfix, from userid 11172)
        id D953B3F89D3C; Wed,  8 Sep 2021 16:48:56 -0700 (PDT)
From:   Aleksander Adamowski <olo@fb.com>
To:     <linux-fscrypt@vger.kernel.org>
CC:     Aleksander Adamowski <olo@fb.com>
Subject: [fsverity-utils PATCH v3] Implement PKCS#11 opaque keys support through OpenSSL pkcs11 engine
Date:   Wed, 8 Sep 2021 16:48:51 -0700
Message-ID: <20210908234851.4056025-1-olo@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: qICY_N24uc3ToNnwkAh3mPEbwb0lA4nZ
X-Proofpoint-ORIG-GUID: qICY_N24uc3ToNnwkAh3mPEbwb0lA4nZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_10:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080148
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
(typically libp11 shared object file) and the PKCS#11 module library (a
shared object file specific to the given hardware token).

Additionally, the existing `key` argument can be used to pass an
optional token-specific key identifier (instead of a private key file
name) for tokens that can contain multiple keys.

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
---
 include/libfsverity.h |  6 ++-
 lib/sign_digest.c     | 96 ++++++++++++++++++++++++++++++++++++++++---
 man/fsverity.1.md     | 23 ++++++++++-
 programs/cmd_sign.c   | 28 +++++++++++--
 programs/fsverity.c   |  4 +-
 programs/fsverity.h   |  2 +
 6 files changed, 145 insertions(+), 14 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 6cefa2b..4b34f43 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -82,10 +82,12 @@ struct libfsverity_digest {
 };
=20
 struct libfsverity_signature_params {
-	const char *keyfile;		/* path to key file (PEM format) */
+	const char *keyfile;	/* path to key file (PEM format), optional */
 	const char *certfile;		/* path to certificate (PEM format) */
 	uint64_t reserved1[8];		/* must be 0 */
-	uintptr_t reserved2[8];		/* must be 0 */
+	const char *pkcs11_engine;	/* path to PKCS#11 engine .so, optional */
+	const char *pkcs11_module;	/* path to PKCS#11 module .so, optional */
+	uintptr_t reserved2[6];		/* must be 0 */
 };
=20
 struct libfsverity_metadata_callbacks {
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 9a35256..f0830f3 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -17,6 +17,9 @@
 #include <openssl/err.h>
 #include <openssl/pem.h>
 #include <openssl/pkcs7.h>
+#ifndef OPENSSL_IS_BORINGSSL
+#include <openssl/engine.h>
+#endif
 #include <string.h>
=20
 static int print_openssl_err_cb(const char *str,
@@ -81,6 +84,10 @@ static int read_certificate(const char *certfile, X509=
 **cert_ret)
 	X509 *cert;
 	int err;
=20
+	if (!certfile) {
+		libfsverity_error_msg("certfile must be specified");
+	}
+
 	errno =3D 0;
 	bio =3D BIO_new_file(certfile, "r");
 	if (!bio) {
@@ -214,6 +221,37 @@ out:
=20
 #else /* OPENSSL_IS_BORINGSSL */
=20
+static ENGINE *get_pkcs11_engine(const char *pkcs11_engine,
+				 const char *pkcs11_module)
+{
+	ENGINE *engine;
+
+	ENGINE_load_dynamic();
+	engine =3D ENGINE_by_id("dynamic");
+	if (!engine) {
+		error_msg_openssl(
+		    "failed to initialize OpenSSL PKCS#11 engine");
+		return NULL;
+	}
+	if (!ENGINE_ctrl_cmd_string(engine, "SO_PATH", pkcs11_engine, 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "ID", "pkcs11", 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "LIST_ADD", "1", 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "LOAD", NULL, 0) ||
+	    !ENGINE_ctrl_cmd_string(engine, "MODULE_PATH", pkcs11_module, 0) ||
+	    !ENGINE_init(engine)) {
+		error_msg_openssl(
+		    "failed to initialize OpenSSL PKCS#11 engine");
+		ENGINE_free(engine);
+		return NULL;
+	}
+	/*
+	 * engine now holds a functional reference after ENGINE_init(), free
+	 * the structural reference from ENGINE_by_id()
+	 */
+	ENGINE_free(engine);
+	return engine;
+}
+
 static BIO *new_mem_buf(const void *buf, size_t size)
 {
 	BIO *bio;
@@ -317,6 +355,57 @@ out:
=20
 #endif /* !OPENSSL_IS_BORINGSSL */
=20
+/* Get a private key - either off disk or PKCS#11 token */
+static int
+get_private_key(const struct libfsverity_signature_params *sig_params,
+		EVP_PKEY **pkey_ret)
+{
+	if (sig_params->pkcs11_engine || sig_params->pkcs11_module) {
+#ifdef OPENSSL_IS_BORINGSSL
+		libfsverity_error_msg(
+		    "BoringSSL doesn't support PKCS#11 feature");
+		return -EINVAL;
+#else
+		ENGINE *engine;
+
+		if (!sig_params->pkcs11_engine) {
+			libfsverity_error_msg(
+			    "missing PKCS#11 engine parameter");
+			return -EINVAL;
+		}
+		if (!sig_params->pkcs11_module) {
+			libfsverity_error_msg(
+			    "missing PKCS#11 module parameter");
+			return -EINVAL;
+		}
+		engine =3D get_pkcs11_engine(sig_params->pkcs11_engine,
+					   sig_params->pkcs11_module);
+		if (!engine)
+			return -EINVAL;
+		/*
+		 * We overload the keyfile parameter as an optional PKCS#11 key
+		 * identifier.  NULL will cause the engine to use the default
+		 * key from the token.
+		 */
+		*pkey_ret =3D ENGINE_load_private_key(engine, sig_params->keyfile,
+						    NULL, NULL);
+		ENGINE_finish(engine);
+		if (!*pkey_ret) {
+			error_msg_openssl(
+			    "failed to load private key from PKCS#11 token");
+			return -EINVAL;
+		}
+		return 0;
+#endif
+	}
+	if (!sig_params->keyfile) {
+		error_msg_openssl(
+		    "missing keyfile parameter (or PKCS11 parameters)");
+		return -EINVAL;
+	}
+	return read_private_key(sig_params->keyfile, pkey_ret);
+}
+
 LIBEXPORT int
 libfsverity_sign_digest(const struct libfsverity_digest *digest,
 			const struct libfsverity_signature_params *sig_params,
@@ -334,11 +423,6 @@ libfsverity_sign_digest(const struct libfsverity_dig=
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
@@ -353,7 +437,7 @@ libfsverity_sign_digest(const struct libfsverity_dige=
st *digest,
 		return -EINVAL;
 	}
=20
-	err =3D read_private_key(sig_params->keyfile, &pkey);
+	err =3D get_private_key(sig_params, &pkey);
 	if (err)
 		goto out;
=20
diff --git a/man/fsverity.1.md b/man/fsverity.1.md
index e1007f5..f44aeb0 100644
--- a/man/fsverity.1.md
+++ b/man/fsverity.1.md
@@ -169,8 +169,27 @@ Options accepted by **fsverity sign**:
 :   Same as for **fsverity digest**.
=20
 **\-\-key**=3D*KEYFILE*
-:   Specifies the file that contains the private key, in PEM format.  Th=
is
-    option is required.
+:   Specifies the file that contains the private key, in PEM format.  If=
 any
+    PKCS#11 options are used, it can be used instead to specify the key
+    identifier in the form of PKCS#11 URI.  This option is required when
+    private key is read from disk and optional when using a PKCS#11 toke=
n.
+
+**\-\-pkcs11-engine**=3D*SOFILE*
+:   Specifies the path to the OpenSSL engine library to be used, when a =
PKCS#11
+    cryptographic token is used instead of a private key file. Typically=
 it
+    will be a path to the libp11 .so file.  This option is required when
+    **\-\-pkcs11-module** is used.
+
+    Note that this option is only supported with classical OpenSSL, and =
not
+    BoringSSL.
+
+**\-\-pkcs11-module**=3D*SOFILE*
+:   Specifies the path to the token-specific module library, when a PKCS=
#11
+    cryptographic token is used instead of a private key file.  This opt=
ion is
+    required when **\-\-pkcs11-engine** is used.
+
+    Note that this option is only supported with classical OpenSSL, and =
not
+    BoringSSL.
=20
 **\-\-out-descriptor**=3D*FILE*
 :   Same as for **fsverity digest**.
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 81a4ddc..064a99b 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -34,6 +34,8 @@ static const struct option longopts[] =3D {
 	{"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
 	{"key",		    required_argument, NULL, OPT_KEY},
 	{"cert",	    required_argument, NULL, OPT_CERT},
+	{"pkcs11-engine",	    required_argument, NULL, OPT_PKCS11_ENGINE},
+	{"pkcs11-module",	    required_argument, NULL, OPT_PKCS11_MODULE},
 	{NULL, 0, NULL, 0}
 };
=20
@@ -68,6 +70,12 @@ int fsverity_cmd_sign(const struct fsverity_command *c=
md,
 			}
 			sig_params.keyfile =3D optarg;
 			break;
+		case OPT_PKCS11_ENGINE:
+			sig_params.pkcs11_engine =3D optarg;
+			break;
+		case OPT_PKCS11_MODULE:
+			sig_params.pkcs11_module =3D optarg;
+			break;
 		case OPT_CERT:
 			if (sig_params.certfile !=3D NULL) {
 				error_msg("--cert can only be specified once");
@@ -86,12 +94,26 @@ int fsverity_cmd_sign(const struct fsverity_command *=
cmd,
 	if (argc !=3D 2)
 		goto out_usage;
=20
-	if (sig_params.keyfile =3D=3D NULL) {
-		error_msg("Missing --key argument");
+	if (sig_params.keyfile =3D=3D NULL && sig_params.pkcs11_engine =3D=3D N=
ULL &&
+	    sig_params.pkcs11_module =3D=3D NULL) {
+		error_msg("Missing --key argument or a pair of --pkcs11-engine "
+			  "and --pkcs11-module");
 		goto out_usage;
 	}
-	if (sig_params.certfile =3D=3D NULL)
+	if (sig_params.certfile =3D=3D NULL) {
+		if (sig_params.keyfile =3D=3D NULL) {
+			error_msg(
+			    "--cert must be specified when PKCS#11 is used");
+			goto out_usage;
+		}
 		sig_params.certfile =3D sig_params.keyfile;
+	}
+	if ((sig_params.pkcs11_engine =3D=3D NULL) !=3D
+	    (sig_params.pkcs11_module =3D=3D NULL)) {
+		error_msg("Both --pkcs11-engine and --pkcs11-module must be "
+			  "specified when used");
+		goto out_usage;
+	}
=20
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index f6aff3a..a4e8f5b 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -58,7 +58,9 @@ static const struct fsverity_command {
 		.func =3D fsverity_cmd_sign,
 		.short_desc =3D "Sign a file for fs-verity",
 		.usage_str =3D
-"    fsverity sign FILE OUT_SIGFILE --key=3DKEYFILE\n"
+"    fsverity sign FILE OUT_SIGFILE [--key=3DKEYFILE]\n"
+"               [--pkcs11-engine=3DPATH_TO_OPENSSL_ENGINE]\n"
+"               [--pkcs11-module=3DPATH_TO_OPENSSL_MODULE]\n"
 "               [--hash-alg=3DHASH_ALG] [--block-size=3DBLOCK_SIZE] [--s=
alt=3DSALT]\n"
 "               [--out-merkle-tree=3DFILE] [--out-descriptor=3DFILE]\n"
 "               [--cert=3DCERTFILE]\n"
diff --git a/programs/fsverity.h b/programs/fsverity.h
index fe24087..eb5ba33 100644
--- a/programs/fsverity.h
+++ b/programs/fsverity.h
@@ -33,6 +33,8 @@ enum {
 	OPT_OUT_MERKLE_TREE,
 	OPT_SALT,
 	OPT_SIGNATURE,
+	OPT_PKCS11_ENGINE,
+	OPT_PKCS11_MODULE,
 };
=20
 struct fsverity_command;
--=20
2.30.2

