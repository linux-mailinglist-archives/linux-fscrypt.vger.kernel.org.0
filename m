Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DE93F8E7D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Aug 2021 21:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhHZTMg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 26 Aug 2021 15:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhHZTMf (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 26 Aug 2021 15:12:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21D9C6103E;
        Thu, 26 Aug 2021 19:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630005108;
        bh=Ss+ujEeyMmCHyfz1t1eXqT4HvGms8VAWxlZ9bmASsuk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VvS6xVJ56R3GkqbwBDY85r9X4OOxsJf9P/CgQ7BLvPDeKIMuoclcsh/g132qk/ZWz
         mRSMxaEn0LJ3g2/M6OAVEiNZRv9TfLRXTsMPpnXZ2RzZq+g0/OMdmUQaERAVNAdExw
         lM3DHKuWOC9lCNUER4dwSKkeAnczrdrex2CXBUpSZPShKDUVLICdz3gSKkt0ib5bvx
         wscGEJYXUf0RsuOY9nd/bbm8VJ/YUifFox7mTW1ymnxopcoI2MT24YHk7XC1o4hlcE
         QCJ4agwHA19ayMysuKeQG9/eVds7kJZugDBwoHqNJ0pP8Cuy0SSDzW7L2Yg2mBOqP7
         4wxDmgGaXtRvA==
Date:   Thu, 26 Aug 2021 12:11:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL
 pkcs11 engine
Message-ID: <YSfncv8Agfam4P2m@sol.localdomain>
References: <20210826001346.1899149-1-olo@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826001346.1899149-1-olo@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Aleksander,

First, can you make sure to include "[fsverity-utils PATCH]" in the subject like
the fsverity-utils README file suggests?  I almost missed this patch as it
initially didn't look relevant to me.

I'm not particularly familiar with the OpenSSL PKCS#11 engine, but this patch
looks reasonable at a high level (assuming that you really want to use the
kernel's built-in fs-verity signature verification support -- I've been trying
to encourage people to do userspace signature verification instead).  Some
comments on the implementation below.

On Wed, Aug 25, 2021 at 05:13:46PM -0700, Aleksander Adamowski wrote:
> PKCS#11 API allows us to use opaque keys confined in hardware security
> modules (HSMs) and similar hardware tokens without direct access to the
> key material, providing logical separation of the keys from the
> cryptographic operations performed using them.
> 
> This commit allows using the popular libp11 pkcs11 module for the
> OpenSSL library with `fsverity` so that direct access to a private key
> file isn't necessary to sign files.
> 
> The user needs to supply the path to the engine shared library
> (typically libp11 shared object file) and the PKCS#11 module library (a
> shared object file specific to the given hardware token).
> 
> Additionally, the existing `key` argument can be used to pass an
> optional token-specific key identifier (instead of a private key file
> name) for tokens that can contain multiple keys.
> 
> Test evidence with a hardware PKCS#11 token:
> 
>   $ echo test > dummy
>   $ ./fsverity sign dummy dummy.sig \
>     --pkcs11-engine=/usr/lib64/engines-1.1/libpkcs11.so \
>     --pkcs11-module=/usr/local/lib64/pkcs11_module.so \
>     --cert=test-pkcs11-cert.pem && echo OK;
>   Signed file 'dummy'
>   (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
>   OK

Please update the man page (man/fsverity.1.md) to document these new options.

> 
> Test evidence for regression check (checking that regular file-based key
> signing still works):
> 
>   $ ./fsverity sign dummy dummy.sig --key=key.pem --cert=cert.pem && \
>     echo  OK;
>   Signed file 'dummy'
>   (sha256:c497326752e21b3992b57f7eff159102d474a97d972dc2c2d99d23e0f5fbdb65)
>   OK
> 
> Signed-off-by: Aleksander Adamowski <olo@fb.com>
> ---
>  include/libfsverity.h |  9 ++++-
>  lib/sign_digest.c     | 94 +++++++++++++++++++++++++++++++++++++++++++
>  programs/cmd_sign.c   | 57 ++++++++++++++++++++++++++
>  programs/fsverity.c   |  6 ++-
>  programs/fsverity.h   |  2 +
>  5 files changed, 166 insertions(+), 2 deletions(-)
> 
> diff --git a/include/libfsverity.h b/include/libfsverity.h
> index 6cefa2b..4b27b3a 100644
> --- a/include/libfsverity.h
> +++ b/include/libfsverity.h
> @@ -82,8 +82,15 @@ struct libfsverity_digest {
>  };
>  
>  struct libfsverity_signature_params {
> -	const char *keyfile;		/* path to key file (PEM format) */
> +	const char *keyfile; /* path to key file (PEM format), optional,
> +				conflicts with pkcs11 */

This comment is incorrect, as your code uses keyfile even in the pkcs11 case.

Also, keyfile is only optional in the pkcs11 case.  Please write a comment that
clearly explains which parameters must be specified and when.

>  	const char *certfile;		/* path to certificate (PEM format) */
> +#ifndef OPENSSL_IS_BORINGSSL
> +	const char *pkcs11_engine;	/* path to PKCS#11 engine .so, optional,
> +					   conflicts with *keyfile */
> +	const char *pkcs11_module;	/* path to PKCS#11 module .so, optional,
> +					   conflicts with *keyfile */
> +#endif
>  	uint64_t reserved1[8];		/* must be 0 */
>  	uintptr_t reserved2[8];		/* must be 0 */
>  };

Inserting these new fields into the middle of the struct breaks the library ABI.
They need to be placed in reserved2 instead, and the size of reserved2 needs to
be decreased accordingly.

> +static ENGINE *get_engine(const char *pkcs11_engine, const char *pkcs11_module)
> +{

Calling this get_pkcs11_engine() would be clearer.

> +static int read_pkcs11_token(ENGINE *engine, const char *key_id,
> +			     EVP_PKEY **pkey_ret)
> +{
> +	EVP_PKEY *pkey;
> +	int err;
> +
> +	pkey = ENGINE_load_private_key(engine, key_id, NULL, NULL);
> +	if (!pkey) {
> +		error_msg_openssl(
> +		    "failed to load private key from PKCS#11 token");
> +		err = -EINVAL;
> +		goto out;
> +	} else {
> +		*pkey_ret = pkey;
> +		err = 0;
> +	}
> +out:
> +	// Free the functional reference obtained from ENGINE_init()
> +	ENGINE_finish(engine);
> +	return err;
> +}
> +
>  static BIO *new_mem_buf(const void *buf, size_t size)
>  {
>  	BIO *bio;
> @@ -334,10 +389,20 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
>  		return -EINVAL;
>  	}
>  
> +#ifdef OPENSSL_IS_BORINGSSL
>  	if (!sig_params->keyfile || !sig_params->certfile) {
>  		libfsverity_error_msg("keyfile and certfile must be specified");
> +	}
> +#else
> +	if ((!sig_params->keyfile &&
> +	     (!sig_params->pkcs11_engine || !sig_params->pkcs11_module)) ||
> +	    !sig_params->certfile) {
> +		libfsverity_error_msg(
> +		    "(keyfile or pkcs11_engine and pkcs11_module) and certfile "
> +		    "must be specified");
>  		return -EINVAL;
>  	}
> +#endif
>  
>  	if (!libfsverity_mem_is_zeroed(sig_params->reserved1,
>  				       sizeof(sig_params->reserved1)) ||
> @@ -353,9 +418,38 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
>  		return -EINVAL;
>  	}
>  
> +#ifdef OPENSSL_IS_BORINGSSL
>  	err = read_private_key(sig_params->keyfile, &pkey);
>  	if (err)
>  		goto out;
> +#else
> +	if (sig_params->pkcs11_engine && sig_params->pkcs11_module) {
> +		ENGINE *engine;
> +		engine = get_engine(sig_params->pkcs11_engine,
> +				    sig_params->pkcs11_module);
> +		if (!engine) {
> +			err = -EINVAL;
> +			goto out;
> +		}
> +		/*
> +		 * We overload the keyfile arg as an optional PKCS#11 key
> +		 * identifier (NULL will cause engine to use the default key
> +		 * from the token)
> +		 */
> +		err = read_pkcs11_token(engine, sig_params->keyfile, &pkey);
> +		if (err)
> +			goto out;
> +	} else if (sig_params->keyfile) {
> +		err = read_private_key(sig_params->keyfile, &pkey);
> +		if (err)
> +			goto out;
> +
> +	} else {
> +		libfsverity_error_msg("Either private key or both pkcs11 "
> +				      "params need to be provided");
> +		return -EINVAL;
> +	}
> +#endif

There are several bugs here.  The !OPENSSL_IS_BORINGSSL case no longer returns
an error if sig_params->keyfile or sig_params->certfile is unset, and it doesn't
return an error if the pkcs11 parameters are set.  Also, either case fails to
return an error if pkcs11_engine is set but not pkcs11_module, or vice versa.

I think it would be best to create a new function get_private_key() that just
handles getting the private key correctly.  Something like the following:

static int
get_private_key(const struct libfsverity_signature_params *sig_params,
		EVP_PKEY **pkey_ret)
{
	if (sig_params->pkcs11_engine || sig_params->pkcs11_module) {
#ifdef OPENSSL_IS_BORINGSSL
		libfsverity_error_msg("BoringSSL doesn't support PKCS#11 feature");
		return -EINVAL;
#else
		ENGINE *engine;

		if (!sig_params->pkcs11_engine) {
			libfsverity_error_msg("missing PKCS#11 engine parameter");
			return -EINVAL;
		}
		if (!sig_params->pkcs11_module) {
			libfsverity_error_msg("missing PKCS#11 module parameter");
			return -EINVAL;
		}
		engine = get_pkcs11_engine(sig_params->pkcs11_engine,
					   sig_params->pkcs11_module);
		if (!engine)
			return -EINVAL;
		/*
		 * We overload the keyfile parameter as an optional PKCS#11 key
		 * identifier.  NULL will cause the engine to use the default
		 * key from the token.
		 */
		*pkey_ret = ENGINE_load_private_key(engine, sig_params->keyfile,
						    NULL, NULL);
		ENGINE_finish(engine);
		if (!*pkey_ret) {
			error_msg_openssl("failed to load private key from PKCS#11 token");
			return -EINVAL;
		}
		return 0;
#endif
	}
	if (!sig_params->keyfile) {
		error_msg_openssl("missing keyfile parameter (or PKCS11 parameters)");
		return -EINVAL;
	}
	return read_private_key(sig_params->keyfile, pkey_ret);
}


The NULL check of certfile can be moved into read_certificate().

Then libfsverity_sign_digest() itself would be pretty simple:

	err = read_certificate(sig_params->certfile, &cert);
	if (err)
		goto out;

	err = get_private_key(sig_params, &pkey);
	if (err)
		goto out;

> diff --git a/programs/cmd_sign.c b/programs/cmd_sign.c
> index 81a4ddc..81de18c 100644
> --- a/programs/cmd_sign.c
> +++ b/programs/cmd_sign.c
> @@ -32,8 +32,16 @@ static const struct option longopts[] = {
>  	{"salt",	    required_argument, NULL, OPT_SALT},
>  	{"out-merkle-tree", required_argument, NULL, OPT_OUT_MERKLE_TREE},
>  	{"out-descriptor",  required_argument, NULL, OPT_OUT_DESCRIPTOR},
> +#ifdef OPENSSL_IS_BORINGSSL
>  	{"key",		    required_argument, NULL, OPT_KEY},
> +#else
> +	{"key",		    optional_argument, NULL, OPT_KEY},
> +#endif

The --key option still requires an argument in both cases, so it should still be
"required_argument".  I think what you're trying to say is that the --key option
is not required in the !OPENSSL_IS_BORINGSSL case.  That's something different;
it's handled in the code that processes the options.

Another thing to keep in mind is that the 'fsverity' binary might not know
whether 'libfsverity' is linked to BoringSSL or OpenSSL.  So any use of
OPENSSL_IS_BORINGSSL should be avoided in the programs/ directory.

>  	{"cert",	    required_argument, NULL, OPT_CERT},
> +#ifndef OPENSSL_IS_BORINGSSL
> +	{"pkcs11-engine",	    optional_argument, NULL, OPT_PKCS11_ENGINE},
> +	{"pkcs11-module",	    optional_argument, NULL, OPT_PKCS11_MODULE},
> +#endif
>  	{NULL, 0, NULL, 0}
>  };

Likewise, using OPENSSL_IS_BORINGSSL isn't valid here.

> +#ifndef OPENSSL_IS_BORINGSSL
> +		case OPT_PKCS11_ENGINE:
> +			if (sig_params.keyfile != NULL) {
> +				error_msg("--pkcs11-engine cannot be specified "
> +					  "when on-disk --key is in use");
> +				goto out_usage;
> +			}
> +			sig_params.pkcs11_engine = optarg;
> +			break;
> +		case OPT_PKCS11_MODULE:
> +			if (sig_params.keyfile != NULL) {
> +				error_msg("--pkcs11-module cannot be specified "
> +					  "when on-disk --key is in use");
> +				goto out_usage;
> +			}
> +			sig_params.pkcs11_module = optarg;
> +			break;
> +#endif

This seems to contradict elsewhere in the patch where keyfile is used even in
the PKCS#11 case.

Also as mentioned above, it isn't really valid to use OPENSSL_IS_BORINGSSL here.

- Eric
