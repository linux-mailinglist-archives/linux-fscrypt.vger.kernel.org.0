Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F92488E00
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 02:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiAJBYG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jan 2022 20:24:06 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:44700 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiAJBYF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jan 2022 20:24:05 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 09C3A72C905;
        Mon, 10 Jan 2022 04:24:04 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 4E15B4A46EA;
        Mon, 10 Jan 2022 04:24:03 +0300 (MSK)
Date:   Mon, 10 Jan 2022 04:24:03 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] ima: support fs-verity file digest based
 signatures
Message-ID: <20220110012403.naqx7el2t5i72xm2@altlinux.org>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
 <20220109185517.312280-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20220109185517.312280-6-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Mimi,

On Sun, Jan 09, 2022 at 01:55:16PM -0500, Mimi Zohar wrote:
> Instead of calculating a file hash and verifying the signature stored
> in the security.ima xattr against the calculated file hash, verify the
> signature based on a hash of fs-verity's file digest and the digest's
> metadata.
> 
> To differentiate between a regular file hash and an fs-verity file digest
> based signature stored as security.ima xattr, define a new signature type
> named IMA_VERITY_DIGSIG.
> 
> The hash format of fs-verity's file digest and the digest's metadata to
> be signed is defined as a structure named "ima_tbs_hash".
> 
> Update the 'ima-sig' template field to display the new fs-verity signature
> type as well.
> 
> For example:
>   appraise func=BPRM_CHECK digest_type=hash|verity
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/ABI/testing/ima_policy      | 10 +++
>  Documentation/security/IMA-templates.rst  |  4 +-
>  include/uapi/linux/ima.h                  | 26 ++++++++
>  security/integrity/ima/ima_appraise.c     | 81 +++++++++++++++++++++++
>  security/integrity/ima/ima_template_lib.c |  3 +-
>  security/integrity/integrity.h            |  1 +
>  6 files changed, 122 insertions(+), 3 deletions(-)
>  create mode 100644 include/uapi/linux/ima.h
> 
> diff --git a/include/uapi/linux/ima.h b/include/uapi/linux/ima.h
> new file mode 100644
> index 000000000000..6a2a68fc0fad
> --- /dev/null
> +++ b/include/uapi/linux/ima.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
> +/*
> + * IMA user API
> + *
> + */
> +#ifndef _UAPI_LINUX_IMA_H
> +#define _UAPI_LINUX_IMA_H
> +
> +#include <linux/types.h>
> +
> +/*
> + * The hash format of fs-verity's file digest and other file metadata
> + * to be signed.  The resulting signature is stored as a security.ima
> + * xattr.
> + *
> + * "type" is defined as IMA_VERITY_DIGSIG
> + * "algo" is the hash_algo enum of fs-verity's file digest
> + * (e.g. HASH_ALGO_SHA256, HASH_ALGO_SHA512).
> + */
> +struct ima_tbs_hash {
> +	__u8 type;        /* xattr type [enum evm_ima_xattr_type] */
> +	__u8 algo;        /* Digest algorithm [enum hash_algo] */
> +	__u8 digest[];    /* fs-verity digest */

Maximum digest size is known to be FS_VERITY_MAX_DIGEST_SIZE. If it's
allocated here then ima_tbs_hash could be allocated temporarily on stack
instead of kalloc.

> +};
> +
> +#endif /* _UAPI_LINUX_IMA_H */
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index dbba51583e7c..4e092c189ed0 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -13,7 +13,10 @@
>  #include <linux/magic.h>
>  #include <linux/ima.h>
>  #include <linux/evm.h>
> +#include <linux/fsverity.h>
>  #include <keys/system_keyring.h>
> +#include <uapi/linux/fsverity.h>
> +#include <uapi/linux/ima.h>
>  
>  #include "ima.h"
>  
> @@ -183,6 +186,8 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
>  		return ima_hash_algo;
>  
>  	switch (xattr_value->type) {
> +	case IMA_VERITY_DIGSIG:
> +		fallthrough;

I think fallthrough is not needed there, since it's just multiple case's
and no code.

>  	case EVM_IMA_XATTR_DIGSIG:
>  		sig = (typeof(sig))xattr_value;
>  		if (sig->version != 2 || xattr_len <= sizeof(*sig)
> @@ -225,6 +230,47 @@ int ima_read_xattr(struct dentry *dentry,
>  	return ret;
>  }
>  
> +/*
> + * calc_tbs_hash - calculate hash of a digest and digest metadata
> + * @type: signature type [IMA_VERITY_DIGSIG]

Parameter seems renamed, but why it's ever need if it's called once and
ever with IMA_VERITY_DIGSIG? If it's deleted then its value no need to be
checked below.

> + * @algo: hash algorithm [enum hash_algo]
> + * @digest: pointer to the digest to be hashed
> + * @hash: (out) pointer to the hash
> + *
> + * The IMA signature is a signature over the hash of fs-verity's file digest
> + * with other digest metadata, not just fs-verity's file digest. Calculate
> + * the to be signed hash.
> + *
> + * Return 0 on success, error code otherwise.
> + */
> +static int calc_tbs_hash(enum evm_ima_xattr_type xattr_type,
> +			 enum hash_algo algo, const u8 *digest,
> +			 struct ima_digest_data *hash)
> +{
> +	struct ima_tbs_hash *tbs_h;
> +	int rc = 0;
> +
> +	if (xattr_type != IMA_VERITY_DIGSIG)
> +		return -EINVAL;
> +
> +	tbs_h = kzalloc(sizeof(*tbs_h) + hash_digest_size[algo], GFP_KERNEL);
> +	if (!tbs_h)
> +		return -ENOMEM;
> +
> +	tbs_h->type = xattr_type;
> +	tbs_h->algo = algo;
> +	memcpy(tbs_h->digest, digest, hash_digest_size[algo]);
> +
> +	hash->algo = algo;

As I understood all of this - hash algo used in fs-verity and algo used
to hash it here are the same. Ultimate source of which is algo id from
xattr - if fs-verity digest algo differs from xattr's then fs-verity
digest is ignored.

Thanks,

> +	hash->length = hash_digest_size[algo];
> +
> +	rc = ima_calc_buffer_hash(tbs_h,
> +				  sizeof(*tbs_h) + hash_digest_size[algo],
> +				  hash);
> +	kfree(tbs_h);
> +	return rc;
> +}
> +
>  /*
>   * xattr_verify - verify xattr digest or signature
>   *
> @@ -236,7 +282,9 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>  			struct evm_ima_xattr_data *xattr_value, int xattr_len,
>  			enum integrity_status *status, const char **cause)
>  {
> +	struct ima_digest_data *hash = NULL;
>  	int rc = -EINVAL, hash_start = 0;
> +	u8 algo;  /* Digest algorithm [enum hash_algo] */
>  
>  	switch (xattr_value->type) {
>  	case IMA_XATTR_DIGEST_NG:
> @@ -271,6 +319,38 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>  			break;
>  		}
>  		*status = INTEGRITY_PASS;
> +		break;
> +	case IMA_VERITY_DIGSIG:
> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> +
> +		algo = iint->ima_hash->algo;
> +		hash = kzalloc(sizeof(*hash) + hash_digest_size[algo],
> +			       GFP_KERNEL);
> +		if (!hash) {
> +			*cause = "verity-hashing-error";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = calc_tbs_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
> +				   iint->ima_hash->digest, hash);
> +		if (rc) {
> +			*cause = "verity-hashing-error";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> +					     (const char *)xattr_value,
> +					     xattr_len, hash->digest,
> +					     hash->length);
> +		if (rc) {
> +			*cause = "invalid-verity-signature";
> +			*status = INTEGRITY_FAIL;
> +		} else {
> +			*status = INTEGRITY_PASS;
> +		}
> +
>  		break;
>  	case EVM_IMA_XATTR_DIGSIG:
>  		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> @@ -303,6 +383,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>  		break;
>  	}
>  
> +	kfree(hash);
>  	return rc;
>  }
>  
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 1c0cea2b805f..31a14943e459 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -498,7 +498,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
>  {
>  	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
>  
> -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> +	if ((!xattr_value) ||
> +	     !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
>  		return ima_eventevmsig_init(event_data, field_data);
>  
>  	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index e7ac1086d1d9..51124708c072 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -79,6 +79,7 @@ enum evm_ima_xattr_type {
>  	EVM_IMA_XATTR_DIGSIG,
>  	IMA_XATTR_DIGEST_NG,
>  	EVM_XATTR_PORTABLE_DIGSIG,
> +	IMA_VERITY_DIGSIG,
>  	IMA_XATTR_LAST
>  };
>  
> -- 
> 2.27.0
