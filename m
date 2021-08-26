Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF50A3F7F3F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Aug 2021 02:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhHZAOv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Aug 2021 20:14:51 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhHZAOv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Aug 2021 20:14:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17Q0Bbtw013888
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Aug 2021 17:14:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Kesb8FQfXRIocMjc03qbrtaUJ4LeJmKBVpOmhx1G97o=;
 b=Z18fTYfPHP1e5SrQbE2FA5AhDImSH58cgJJj52JIZvUehUjTnREXjWFrrU46j1m8LInp
 f/0/2pbEtPVvvODV3UgEKg6q9OaD8TDcElGwntq3xwVFPErb5S+t0Ovi4UA62K40dPue
 EzYHJOYJzJ/qYl2zLHeTAod6VjlYa4JLdk4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3an9dur6k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 Aug 2021 17:14:04 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 25 Aug 2021 17:14:03 -0700
Received: by devvm4043.ftw0.facebook.com (Postfix, from userid 11172)
        id 6E06D3332C60; Wed, 25 Aug 2021 17:13:56 -0700 (PDT)
From:   Aleksander Adamowski <olo@fb.com>
To:     <linux-fscrypt@vger.kernel.org>
CC:     Aleksander Adamowski <olo@fb.com>
Subject: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL pkcs11 engine
Date:   Wed, 25 Aug 2021 17:13:46 -0700
Message-ID: <20210826001346.1899149-1-olo@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: O-gkdvQx--KHS_eKV0wotdrOwER5tpgD
X-Proofpoint-ORIG-GUID: O-gkdvQx--KHS_eKV0wotdrOwER5tpgD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_09:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 clxscore=1011 lowpriorityscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108260000
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
 include/libfsverity.h |  9 ++++-
 lib/sign_digest.c     | 94 +++++++++++++++++++++++++++++++++++++++++++
 programs/cmd_sign.c   | 57 ++++++++++++++++++++++++++
 programs/fsverity.c   |  6 ++-
 programs/fsverity.h   |  2 +
 5 files changed, 166 insertions(+), 2 deletions(-)

diff --git a/include/libfsverity.h b/include/libfsverity.h
index 6cefa2b..4b27b3a 100644
--- a/include/libfsverity.h
+++ b/include/libfsverity.h
@@ -82,8 +82,15 @@ struct libfsverity_digest {
 };
=20
 struct libfsverity_signature_params {
-	const char *keyfile;		/* path to key file (PEM format) */
+	const char *keyfile; /* path to key file (PEM format), optional,
+				conflicts with pkcs11 */
 	const char *certfile;		/* path to certificate (PEM format) */
+#ifndef OPENSSL_IS_BORINGSSL
+	const char *pkcs11_engine;	/* path to PKCS#11 engine .so, optional,
+					   conflicts with *keyfile */
+	const char *pkcs11_module;	/* path to PKCS#11 module .so, optional,
+					   conflicts with *keyfile */
+#endif
 	uint64_t reserved1[8];		/* must be 0 */
 	uintptr_t reserved2[8];		/* must be 0 */
 };
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 9a35256..1874541 100644
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
@@ -214,6 +217,58 @@ out:
=20
 #else /* OPENSSL_IS_BORINGSSL */
=20
+static ENGINE *get_engine(const char *pkcs11_engine, const char *pkcs11_=
module)
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
+static int read_pkcs11_token(ENGINE *engine, const char *key_id,
+			     EVP_PKEY **pkey_ret)
+{
+	EVP_PKEY *pkey;
+	int err;
+
+	pkey =3D ENGINE_load_private_key(engine, key_id, NULL, NULL);
+	if (!pkey) {
+		error_msg_openssl(
+		    "failed to load private key from PKCS#11 token");
+		err =3D -EINVAL;
+		goto out;
+	} else {
+		*pkey_ret =3D pkey;
+		err =3D 0;
+	}
+out:
+	// Free the functional reference obtained from ENGINE_init()
+	ENGINE_finish(engine);
+	return err;
+}
+
 static BIO *new_mem_buf(const void *buf, size_t size)
 {
 	BIO *bio;
@@ -334,10 +389,20 @@ libfsverity_sign_digest(const struct libfsverity_di=
gest *digest,
 		return -EINVAL;
 	}
=20
+#ifdef OPENSSL_IS_BORINGSSL
 	if (!sig_params->keyfile || !sig_params->certfile) {
 		libfsverity_error_msg("keyfile and certfile must be specified");
+	}
+#else
+	if ((!sig_params->keyfile &&
+	     (!sig_params->pkcs11_engine || !sig_params->pkcs11_module)) ||
+	    !sig_params->certfile) {
+		libfsverity_error_msg(
+		    "(keyfile or pkcs11_engine and pkcs11_module) and certfile "
+		    "must be specified");
 		return -EINVAL;
 	}
+#endif
=20
 	if (!libfsverity_mem_is_zeroed(sig_params->reserved1,
 				       sizeof(sig_params->reserved1)) ||
@@ -353,9 +418,38 @@ libfsverity_sign_digest(const struct libfsverity_dig=
est *digest,
 		return -EINVAL;
 	}
=20
+#ifdef OPENSSL_IS_BORINGSSL
 	err =3D read_private_key(sig_params->keyfile, &pkey);
 	if (err)
 		goto out;
+#else
+	if (sig_params->pkcs11_engine && sig_params->pkcs11_module) {
+		ENGINE *engine;
+		engine =3D get_engine(sig_params->pkcs11_engine,
+				    sig_params->pkcs11_module);
+		if (!engine) {
+			err =3D -EINVAL;
+			goto out;
+		}
+		/*
+		 * We overload the keyfile arg as an optional PKCS#11 key
+		 * identifier (NULL will cause engine to use the default key
+		 * from the token)
+		 */
+		err =3D read_pkcs11_token(engine, sig_params->keyfile, &pkey);
+		if (err)
+			goto out;
+	} else if (sig_params->keyfile) {
+		err =3D read_private_key(sig_params->keyfile, &pkey);
+		if (err)
+			goto out;
+
+	} else {
+		libfsverity_error_msg("Either private key or both pkcs11 "
+				      "params need to be provided");
+		return -EINVAL;
+	}
+#endif
=20
 	err =3D read_certificate(sig_params->certfile, &cert);
 	if (err)
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 81a4ddc..81de18c 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -32,8 +32,16 @@ static const struct option longopts[] =3D {
 	{"salt",	    required_argument, NULL, OPT_SALT},
 	{"out-merkle-tree", required_argument, NULL, OPT_OUT_MERKLE_TREE},
 	{"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
+#ifdef OPENSSL_IS_BORINGSSL
 	{"key",		    required_argument, NULL, OPT_KEY},
+#else
+	{"key",		    optional_argument, NULL, OPT_KEY},
+#endif
 	{"cert",	    required_argument, NULL, OPT_CERT},
+#ifndef OPENSSL_IS_BORINGSSL
+	{"pkcs11-engine",	    optional_argument, NULL, OPT_PKCS11_ENGINE},
+	{"pkcs11-module",	    optional_argument, NULL, OPT_PKCS11_MODULE},
+#endif
 	{NULL, 0, NULL, 0}
 };
=20
@@ -66,8 +74,34 @@ int fsverity_cmd_sign(const struct fsverity_command *c=
md,
 				error_msg("--key can only be specified once");
 				goto out_usage;
 			}
+#ifndef OPENSSL_IS_BORINGSSL
+			if (sig_params.pkcs11_engine !=3D NULL ||
+			    sig_params.pkcs11_module !=3D NULL) {
+				error_msg("--key cannot be specified when "
+					  "PKCS#11 is in use");
+				goto out_usage;
+			}
+#endif
 			sig_params.keyfile =3D optarg;
 			break;
+#ifndef OPENSSL_IS_BORINGSSL
+		case OPT_PKCS11_ENGINE:
+			if (sig_params.keyfile !=3D NULL) {
+				error_msg("--pkcs11-engine cannot be specified "
+					  "when on-disk --key is in use");
+				goto out_usage;
+			}
+			sig_params.pkcs11_engine =3D optarg;
+			break;
+		case OPT_PKCS11_MODULE:
+			if (sig_params.keyfile !=3D NULL) {
+				error_msg("--pkcs11-module cannot be specified "
+					  "when on-disk --key is in use");
+				goto out_usage;
+			}
+			sig_params.pkcs11_module =3D optarg;
+			break;
+#endif
 		case OPT_CERT:
 			if (sig_params.certfile !=3D NULL) {
 				error_msg("--cert can only be specified once");
@@ -86,12 +120,35 @@ int fsverity_cmd_sign(const struct fsverity_command =
*cmd,
 	if (argc !=3D 2)
 		goto out_usage;
=20
+#ifdef OPENSSL_IS_BORINGSSL
 	if (sig_params.keyfile =3D=3D NULL) {
 		error_msg("Missing --key argument");
 		goto out_usage;
 	}
 	if (sig_params.certfile =3D=3D NULL)
 		sig_params.certfile =3D sig_params.keyfile;
+#else
+	if (sig_params.keyfile =3D=3D NULL && sig_params.pkcs11_engine =3D=3D N=
ULL &&
+	    sig_params.pkcs11_module =3D=3D NULL) {
+		error_msg("Missing --key argument or a pair of --pkcs11-engine "
+			  "and --pkcs11-module");
+		goto out_usage;
+	}
+	if (sig_params.certfile =3D=3D NULL) {
+		if (sig_params.keyfile =3D=3D NULL) {
+			error_msg(
+			    "--cert must be specified when PKCS#11 is used");
+			goto out_usage;
+		}
+		sig_params.certfile =3D sig_params.keyfile;
+	}
+	if ((sig_params.pkcs11_engine =3D=3D NULL) !=3D
+	    (sig_params.pkcs11_module =3D=3D NULL)) {
+		error_msg("Both --pkcs11-engine and --pkcs11-module must be "
+			  "specified when used");
+		goto out_usage;
+	}
+#endif
=20
 	if (!open_file(&file, argv[0], O_RDONLY, 0))
 		goto out_err;
diff --git a/programs/fsverity.c b/programs/fsverity.c
index f6aff3a..485aade 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -58,7 +58,11 @@ static const struct fsverity_command {
 		.func =3D fsverity_cmd_sign,
 		.short_desc =3D "Sign a file for fs-verity",
 		.usage_str =3D
-"    fsverity sign FILE OUT_SIGFILE --key=3DKEYFILE\n"
+"    fsverity sign FILE OUT_SIGFILE [--key=3DKEYFILE]\n"
+#ifndef OPENSSL_IS_BORINGSSL
+"               [--pkcs11-engine=3DPATH_TO_OPENSSL_ENGINE]\n"
+"               [--pkcs11-module=3DPATH_TO_OPENSSL_MODULE]\n"
+#endif
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

