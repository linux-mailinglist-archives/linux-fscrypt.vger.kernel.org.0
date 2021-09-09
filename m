Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80281404615
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 09:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350147AbhIIHZj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Sep 2021 03:25:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhIIHZi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Sep 2021 03:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC41A6109F;
        Thu,  9 Sep 2021 07:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631172269;
        bh=xZjA71B2R5/aWsrDB1Le+0NGiugZnl4EDZmSgnjiGbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E0VNzgb2EI7/UyyW4OiIdnu3ygCcvTfV2coKhF2L/MvN4zVLzbcyJG6PnLtkyDHrH
         DvtaDyGGykJqVIpDUKU60gWdWzTdxXjlEv2yzLyvlsQS/usHYCpgcogRE0flBJ8Drm
         DsAEOTWMcOJliCmrFdm5nlLmRBLlOXsRgiyGDaf6XRjZdsG7ssE33IXegDoizthgd2
         x5/ST87IX5wLrS70Ql0P6Z1W9DZHbLKRHZxPbZBxBsaUEi3nXFx0t0dR/u5BYk8myC
         vhZzDyoRCAdlqFPbwDzT8BE5zAiDj7xYKmwDaYtDaC7G+t0VX+OYA3qpvlS6MToGAy
         JeZlpsLMvAXkA==
Date:   Thu, 9 Sep 2021 00:24:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v4] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Message-ID: <YTmqoDtXXFbwHM/4@sol.localdomain>
References: <20210909005734.154434-1-olo@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909005734.154434-1-olo@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 08, 2021 at 05:57:34PM -0700, Aleksander Adamowski wrote:
> @@ -86,12 +94,26 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
>  	if (argc != 2)
>  		goto out_usage;
>  
> -	if (sig_params.keyfile == NULL) {
> -		error_msg("Missing --key argument");
> +	if (sig_params.keyfile == NULL && sig_params.pkcs11_engine == NULL &&
> +	    sig_params.pkcs11_module == NULL) {
> +		error_msg("Missing --key argument or a pair of --pkcs11-engine "
> +			  "and --pkcs11-module");
>  		goto out_usage;
>  	}
> -	if (sig_params.certfile == NULL)
> +	if (sig_params.certfile == NULL) {
> +		if (sig_params.keyfile == NULL) {
> +			error_msg(
> +			    "--cert must be specified when PKCS#11 is used");
> +			goto out_usage;
> +		}
>  		sig_params.certfile = sig_params.keyfile;
> +	}
> +	if ((sig_params.pkcs11_engine == NULL) !=
> +	    (sig_params.pkcs11_module == NULL)) {
> +		error_msg("Both --pkcs11-engine and --pkcs11-module must be "
> +			  "specified when used");
> +		goto out_usage;
> +	}

Taking a closer look at this patch, I don't think we should be overloading the
'--key' option and 'keyfile' field like this, as it's confusing.  It's also not
really necessary for 'fsverity sign' to do all this option validation itself; I
think we should keep it simple and just rely on libfsverity.

Also, I think this feature could use clearer documentation that clearly explains
that there are now two ways to specify a private key.

I ended up making the above changes and cleaning up a bunch of other things; can
you consider the following patch instead?  Thanks!

--- 8< ---

From 4500850f62f457b4dbc434bde716ee6dd3d95320 Mon Sep 17 00:00:00 2001
From: Aleksander Adamowski <olo@fb.com>
Date: Wed, 8 Sep 2021 17:57:34 -0700
Subject: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL pkcs11
 engine

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
    --pkcs11-engine=/usr/lib64/engines-1.1/libpkcs11.so \
    --pkcs11-module=/usr/local/lib64/pkcs11_module.so \
    --cert=test-pkcs11-cert.pem && echo OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
  OK

Test evidence for regression check (checking that regular file-based key
signing still works):

  $ ./fsverity sign dummy dummy.sig --key=key.pem --cert=cert.pem && \
    echo  OK;
  Signed file 'dummy'
  (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
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
 
+/**
+ * struct libfsverity_signature_params - certificate and private key information
+ *
+ * Zero this, then set @certfile.  Then, to specify the private key by key file,
+ * set @keyfile.  Alternatively, to specify the private key by PKCS#11 token,
+ * set @pkcs11_engine, @pkcs11_module, and optionally @pkcs11_keyid.
+ *
+ * Support for PKCS#11 tokens is unavailable when libfsverity was linked to
+ * BoringSSL rather than OpenSSL.
+ */
 struct libfsverity_signature_params {
-	const char *keyfile;		/* path to key file (PEM format) */
-	const char *certfile;		/* path to certificate (PEM format) */
-	uint64_t reserved1[8];		/* must be 0 */
-	uintptr_t reserved2[8];		/* must be 0 */
+
+	/** @keyfile: the path to the key file in PEM format, when applicable */
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
 
 struct libfsverity_metadata_callbacks {
@@ -161,8 +194,7 @@ libfsverity_compute_digest(void *fd, libfsverity_read_fn_t read_fn,
  *          Documentation/filesystems/fsverity.rst in the kernel source tree for
  *          further details.
  * @digest: pointer to previously computed digest
- * @sig_params: struct libfsverity_signature_params providing filenames of
- *          the keyfile and certificate file. Reserved fields must be zero.
+ * @sig_params: pointer to the certificate and private key information
  * @sig_ret: Pointer to pointer for signed digest
  * @sig_size_ret: Pointer to size of signed return digest
  *
diff --git a/lib/sign_digest.c b/lib/sign_digest.c
index 9a35256..da23d04 100644
--- a/lib/sign_digest.c
+++ b/lib/sign_digest.c
@@ -81,6 +81,11 @@ static int read_certificate(const char *certfile, X509 **cert_ret)
 	X509 *cert;
 	int err;
 
+	if (!certfile) {
+		libfsverity_error_msg("no certificate specified");
+		return -EINVAL;
+	}
+
 	errno = 0;
 	bio = BIO_new_file(certfile, "r");
 	if (!bio) {
@@ -212,8 +217,62 @@ out:
 	return err;
 }
 
+static int
+load_pkcs11_private_key(const struct libfsverity_signature_params *sig_params
+			__attribute__((unused)),
+			EVP_PKEY **pkey_ret __attribute__((unused)))
+{
+	libfsverity_error_msg("BoringSSL doesn't support PKCS#11 tokens");
+	return -EINVAL;
+}
+
 #else /* OPENSSL_IS_BORINGSSL */
 
+#include <openssl/engine.h>
+
+static int
+load_pkcs11_private_key(const struct libfsverity_signature_params *sig_params,
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
+	engine = ENGINE_by_id("dynamic");
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
+	*pkey_ret = ENGINE_load_private_key(engine, sig_params->pkcs11_keyid,
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
 
 #endif /* !OPENSSL_IS_BORINGSSL */
 
+/* Get a private key, either from disk or from a PKCS#11 token. */
+static int
+get_private_key(const struct libfsverity_signature_params *sig_params,
+		EVP_PKEY **pkey_ret)
+{
+	if (sig_params->pkcs11_engine || sig_params->pkcs11_module ||
+	    sig_params->pkcs11_keyid) {
+		if (sig_params->keyfile) {
+			libfsverity_error_msg("private key must be specified either by file or by PKCS#11 token, not both");
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
-	EVP_PKEY *pkey = NULL;
 	X509 *cert = NULL;
+	EVP_PKEY *pkey = NULL;
 	const EVP_MD *md;
 	struct fsverity_formatted_digest *d = NULL;
 	int err;
@@ -334,11 +413,6 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 		return -EINVAL;
 	}
 
-	if (!sig_params->keyfile || !sig_params->certfile) {
-		libfsverity_error_msg("keyfile and certfile must be specified");
-		return -EINVAL;
-	}
-
 	if (!libfsverity_mem_is_zeroed(sig_params->reserved1,
 				       sizeof(sig_params->reserved1)) ||
 	    !libfsverity_mem_is_zeroed(sig_params->reserved2,
@@ -353,11 +427,11 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 		return -EINVAL;
 	}
 
-	err = read_private_key(sig_params->keyfile, &pkey);
+	err = read_certificate(sig_params->certfile, &cert);
 	if (err)
 		goto out;
 
-	err = read_certificate(sig_params->certfile, &cert);
+	err = get_private_key(sig_params, &pkey);
 	if (err)
 		goto out;
 
@@ -383,8 +457,8 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
 	err = sign_pkcs7(d, sizeof(*d) + digest->digest_size,
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
-**fsverity sign \-\-key**=*KEYFILE* [*OPTION*...] *FILE* *OUT_SIGFILE*
+**fsverity sign** [*OPTION*...] *FILE* *OUT_SIGFILE*
 
 # DESCRIPTION
 
@@ -149,12 +149,18 @@ for each file regardless of the size of the file.
 
 **fsverity measure** does not accept any options.
 
-## **fsverity sign** **\-\-key**=*KEYFILE* [*OPTION*...] *FILE* *OUT_SIGFILE*
+## **fsverity sign** [*OPTION*...] *FILE* *OUT_SIGFILE*
 
 Sign the given file for fs-verity, in a way that is compatible with the Linux
 kernel's fs-verity built-in signature verification support.  The signature will
 be written to *OUT_SIGFILE* in PKCS#7 DER format.
 
+The private key can be specified either by key file or by PKCS#11 token.  To use
+a key file, provide **\-\-key** and optionally **\-\-cert**.  To use a PKCS#11
+token, provide **\-\-pkcs11-engine**, **\-\-pkcs11-module**, **\-\-cert**, and
+optionally **\-\-pkcs11-keyid**.  PKCS#11 token support is unavailable when
+fsverity-utils was built with BoringSSL rather than OpenSSL.
+
 Options accepted by **fsverity sign**:
 
 **\-\-block-size**=*BLOCK_SIZE*
@@ -163,14 +169,14 @@ Options accepted by **fsverity sign**:
 **\-\-cert**=*CERTFILE*
 :   Specifies the file that contains the certificate, in PEM format.  This
     option is required if *KEYFILE* contains only the private key and not also
-    the certificate.
+    the certificate, or if a PKCS#11 token is used.
 
 **\-\-hash-alg**=*HASH_ALG*
 :   Same as for **fsverity digest**.
 
 **\-\-key**=*KEYFILE*
 :   Specifies the file that contains the private key, in PEM format.  This
-    option is required.
+    option is required when not using a PKCS#11 token.
 
 **\-\-out-descriptor**=*FILE*
 :   Same as for **fsverity digest**.
@@ -178,6 +184,20 @@ Options accepted by **fsverity sign**:
 **\-\-out-merkle-tree**=*FILE*
 :   Same as for **fsverity digest**.
 
+**\-\-pkcs11-engine**=*SOFILE*
+:   Specifies the path to the OpenSSL PKCS#11 engine file.  This typically will
+    be a path to the libp11 .so file.  This option is required when using a
+    PKCS#11 token.
+
+**\-\-pkcs11-keyid**=*KEYID*
+:   Specifies the key identifier in the form of a PKCS#11 URI.  If not provided,
+    the default key associated with the token is used.  This option is only
+    applicable when using a PKCS#11 token.
+
+**\-\-pkcs11-module**=*SOFILE*
+:   Specifies the path to the PKCS#11 token-specific module library.  This
+    option is required when using a PKCS#11 token.
+
 **\-\-salt**=*SALT*
 :   Same as for **fsverity digest**.
 
diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
index 81a4ddc..aab8f00 100644
--- a/programs/cmd_sign.c
+++ b/programs/cmd_sign.c
@@ -27,13 +27,16 @@ static bool write_signature(const char *filename, const u8 *sig, u32 sig_size)
 }
 
 static const struct option longopts[] = {
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
 
@@ -53,14 +56,6 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 
 	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
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
 			if (sig_params.keyfile != NULL) {
 				error_msg("--key can only be specified once");
@@ -75,6 +70,35 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 			}
 			sig_params.certfile = optarg;
 			break;
+		case OPT_PKCS11_ENGINE:
+			if (sig_params.pkcs11_engine != NULL) {
+				error_msg("--pkcs11-engine can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_engine = optarg;
+			break;
+		case OPT_PKCS11_MODULE:
+			if (sig_params.pkcs11_module != NULL) {
+				error_msg("--pkcs11-module can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_module = optarg;
+			break;
+		case OPT_PKCS11_KEYID:
+			if (sig_params.pkcs11_keyid != NULL) {
+				error_msg("--pkcs11-keyid can only be specified once");
+				goto out_usage;
+			}
+			sig_params.pkcs11_keyid = optarg;
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
@@ -86,10 +110,6 @@ int fsverity_cmd_sign(const struct fsverity_command *cmd,
 	if (argc != 2)
 		goto out_usage;
 
-	if (sig_params.keyfile == NULL) {
-		error_msg("Missing --key argument");
-		goto out_usage;
-	}
 	if (sig_params.certfile == NULL)
 		sig_params.certfile = sig_params.keyfile;
 
diff --git a/programs/fsverity.c b/programs/fsverity.c
index f6aff3a..813ea2a 100644
--- a/programs/fsverity.c
+++ b/programs/fsverity.c
@@ -58,10 +58,11 @@ static const struct fsverity_command {
 		.func = fsverity_cmd_sign,
 		.short_desc = "Sign a file for fs-verity",
 		.usage_str =
-"    fsverity sign FILE OUT_SIGFILE --key=KEYFILE\n"
+"    fsverity sign FILE OUT_SIGFILE\n"
+"               [--key=KEYFILE] [--cert=CERTFILE] [--pkcs11-engine=SOFILE]\n"
+"               [--pkcs11-module=SOFILE] [--pkcs11-keyid=KEYID]\n"
 "               [--hash-alg=HASH_ALG] [--block-size=BLOCK_SIZE] [--salt=SALT]\n"
 "               [--out-merkle-tree=FILE] [--out-descriptor=FILE]\n"
-"               [--cert=CERTFILE]\n"
 	}
 };
 
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
-- 
2.33.0

