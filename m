Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9C48985C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 13:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245300AbiAJMO4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jan 2022 07:14:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245359AbiAJMNv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jan 2022 07:13:51 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ABdvvX015905;
        Mon, 10 Jan 2022 12:13:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=CJFb9049BXUSLaIwYxKBhZm6hp6+gwR4iG7lEuM+Z2g=;
 b=giwyXwBXuxIiJi2qUPBJloN2gR1s6fjhyMxge+4fVBBwQmTqXfCq3+BS36gwb/16oHIF
 fzRVUNXJP3u1RnkaiVcYt3ODRyWcEZTEnitbPJTIuhAnugLHVbsG6Wn5UVVk/s7TgVPu
 lPTL3AHIKNwjNfU9bps9+yBAhLbBCmN3CdTcTC04/VAmgGyvQErVjA7HKEcS4uaTXiez
 FDckWhLpRM6UFO4kkgnixxxFX3YnsLuUhkxWvgAdNOiGtnK6s6JGZP0SmEfajDx/1WkB
 szUpE1tuYs0/i/iNVYxYxnL0RiJURh1hqzPN8cmb/LfJpO//eMukfXwmq8Gmw4nfzs4h sQ== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dfm3vhdff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:13:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ACDR7q032182;
        Mon, 10 Jan 2022 12:13:41 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3df288uk65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:13:41 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ACCiqM37355800
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 12:12:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E12FAE051;
        Mon, 10 Jan 2022 12:12:44 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68B2FAE04D;
        Mon, 10 Jan 2022 12:12:43 +0000 (GMT)
Received: from sig-9-65-93-173.ibm.com (unknown [9.65.93.173])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 12:12:43 +0000 (GMT)
Message-ID: <5be6aefd02e2a28a32ae8396ade61f35533a67b0.camel@linux.ibm.com>
Subject: Re: [PATCH v2 5/6] ima: support fs-verity file digest based
 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-integrity@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 10 Jan 2022 07:12:42 -0500
In-Reply-To: <20220110012403.naqx7el2t5i72xm2@altlinux.org>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
         <20220109185517.312280-6-zohar@linux.ibm.com>
         <20220110012403.naqx7el2t5i72xm2@altlinux.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7EjeHB3tpzLwQ2VThqYUjtb-Bgvv44Sa
X-Proofpoint-GUID: 7EjeHB3tpzLwQ2VThqYUjtb-Bgvv44Sa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_05,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201100085
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-01-10 at 04:24 +0300, Vitaly Chikunov wrote:
> Mimi,
> 
> On Sun, Jan 09, 2022 at 01:55:16PM -0500, Mimi Zohar wrote:
> > Instead of calculating a file hash and verifying the signature stored
> > in the security.ima xattr against the calculated file hash, verify the
> > signature based on a hash of fs-verity's file digest and the digest's
> > metadata.
> > 
> > To differentiate between a regular file hash and an fs-verity file digest
> > based signature stored as security.ima xattr, define a new signature type
> > named IMA_VERITY_DIGSIG.
> > 
> > The hash format of fs-verity's file digest and the digest's metadata to
> > be signed is defined as a structure named "ima_tbs_hash".
> > 
> > Update the 'ima-sig' template field to display the new fs-verity signature
> > type as well.
> > 
> > For example:
> >   appraise func=BPRM_CHECK digest_type=hash|verity
> > 
> > Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> > ---
> >  Documentation/ABI/testing/ima_policy      | 10 +++
> >  Documentation/security/IMA-templates.rst  |  4 +-
> >  include/uapi/linux/ima.h                  | 26 ++++++++
> >  security/integrity/ima/ima_appraise.c     | 81 +++++++++++++++++++++++
> >  security/integrity/ima/ima_template_lib.c |  3 +-
> >  security/integrity/integrity.h            |  1 +
> >  6 files changed, 122 insertions(+), 3 deletions(-)
> >  create mode 100644 include/uapi/linux/ima.h
> > 
> > diff --git a/include/uapi/linux/ima.h b/include/uapi/linux/ima.h
> > new file mode 100644
> > index 000000000000..6a2a68fc0fad
> > --- /dev/null
> > +++ b/include/uapi/linux/ima.h
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
> > +/*
> > + * IMA user API
> > + *
> > + */
> > +#ifndef _UAPI_LINUX_IMA_H
> > +#define _UAPI_LINUX_IMA_H
> > +
> > +#include <linux/types.h>
> > +
> > +/*
> > + * The hash format of fs-verity's file digest and other file metadata
> > + * to be signed.  The resulting signature is stored as a security.ima
> > + * xattr.
> > + *
> > + * "type" is defined as IMA_VERITY_DIGSIG
> > + * "algo" is the hash_algo enum of fs-verity's file digest
> > + * (e.g. HASH_ALGO_SHA256, HASH_ALGO_SHA512).
> > + */
> > +struct ima_tbs_hash {
> > +	__u8 type;        /* xattr type [enum evm_ima_xattr_type] */
> > +	__u8 algo;        /* Digest algorithm [enum hash_algo] */
> > +	__u8 digest[];    /* fs-verity digest */
> 
> Maximum digest size is known to be FS_VERITY_MAX_DIGEST_SIZE. If it's
> allocated here then ima_tbs_hash could be allocated temporarily on stack
> instead of kalloc.

The buffer size to be hashed is currently straight forward
"sizeof(*tbs_h) + hash_digest_size[algo]".   With this change, we would
need to calculate the unused part of FS_VERITY_MAX_DIGEST_SIZE and
subtract it from the struct size.  Perhaps something like:
    "sizeof(*tbs_h) - (FS_VERITY_MAX_DIGEST_SIZE -
hash_digest_size[algo])"

thanks,

Mimi

> 
> > +};
> > +
> > +#endif /* _UAPI_LINUX_IMA_H */
> > diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> > index dbba51583e7c..4e092c189ed0 100644
> > --- a/security/integrity/ima/ima_appraise.c
> > +++ b/security/integrity/ima/ima_appraise.c
> > @@ -13,7 +13,10 @@
> >  #include <linux/magic.h>
> >  #include <linux/ima.h>
> >  #include <linux/evm.h>
> > +#include <linux/fsverity.h>
> >  #include <keys/system_keyring.h>
> > +#include <uapi/linux/fsverity.h>
> > +#include <uapi/linux/ima.h>
> >  
> >  #include "ima.h"
> >  
> > @@ -183,6 +186,8 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
> >  		return ima_hash_algo;
> >  
> >  	switch (xattr_value->type) {
> > +	case IMA_VERITY_DIGSIG:
> > +		fallthrough;
> 
> I think fallthrough is not needed there, since it's just multiple case's
> and no code.

Thanks.

> 
> >  	case EVM_IMA_XATTR_DIGSIG:
> >  		sig = (typeof(sig))xattr_value;
> >  		if (sig->version != 2 || xattr_len <= sizeof(*sig)
> > @@ -225,6 +230,47 @@ int ima_read_xattr(struct dentry *dentry,
> >  	return ret;
> >  }
> >  
> > +/*
> > + * calc_tbs_hash - calculate hash of a digest and digest metadata
> > + * @type: signature type [IMA_VERITY_DIGSIG]
> 
> Parameter seems renamed, but why it's ever need if it's called once and
> ever with IMA_VERITY_DIGSIG? If it's deleted then its value no need to be
> checked below.

Thanks for catching the comment and function parameter mismatch.   At
the moment calc_tbs_hash() is limited to fs-verity.  True the parameter
isn't needed now, but at some point we probably should add similar
support for regular file hashes.   That will require incrementing the
signature version number for backwards compatability.

> 
> > + * @algo: hash algorithm [enum hash_algo]
> > + * @digest: pointer to the digest to be hashed
> > + * @hash: (out) pointer to the hash
> > + *
> > + * The IMA signature is a signature over the hash of fs-verity's file digest
> > + * with other digest metadata, not just fs-verity's file digest. Calculate
> > + * the to be signed hash.
> > + *
> > + * Return 0 on success, error code otherwise.
> > + */
> > +static int calc_tbs_hash(enum evm_ima_xattr_type xattr_type,
> > +			 enum hash_algo algo, const u8 *digest,
> > +			 struct ima_digest_data *hash)
> > +{
> > +	struct ima_tbs_hash *tbs_h;
> > +	int rc = 0;
> > +
> > +	if (xattr_type != IMA_VERITY_DIGSIG)
> > +		return -EINVAL;
> > +
> > +	tbs_h = kzalloc(sizeof(*tbs_h) + hash_digest_size[algo], GFP_KERNEL);
> > +	if (!tbs_h)
> > +		return -ENOMEM;
> > +
> > +	tbs_h->type = xattr_type;
> > +	tbs_h->algo = algo;
> > +	memcpy(tbs_h->digest, digest, hash_digest_size[algo]);
> > +
> > +	hash->algo = algo;
> 
> As I understood all of this - hash algo used in fs-verity and algo used
> to hash it here are the same. Ultimate source of which is algo id from
> xattr - if fs-verity digest algo differs from xattr's then fs-verity
> digest is ignored.

Right, the assumption is that the fs-verity digest, the tbs hash, and
signature all use the same hash algorithm.

> 
> > +	hash->length = hash_digest_size[algo];
> > +
> > +	rc = ima_calc_buffer_hash(tbs_h,
> > +				  sizeof(*tbs_h) + hash_digest_size[algo],
> > +				  hash);
> > +	kfree(tbs_h);
> > +	return rc;
> > +}
> > +
> >  /*
> >   * xattr_verify - verify xattr digest or signature
> >   *
> > @@ -236,7 +282,9 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> >  			struct evm_ima_xattr_data *xattr_value, int xattr_len,
> >  			enum integrity_status *status, const char **cause)
> >  {
> > +	struct ima_digest_data *hash = NULL;
> >  	int rc = -EINVAL, hash_start = 0;
> > +	u8 algo;  /* Digest algorithm [enum hash_algo] */
> >  
> >  	switch (xattr_value->type) {
> >  	case IMA_XATTR_DIGEST_NG:
> > @@ -271,6 +319,38 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> >  			break;
> >  		}
> >  		*status = INTEGRITY_PASS;
> > +		break;
> > +	case IMA_VERITY_DIGSIG:
> > +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > +
> > +		algo = iint->ima_hash->algo;
> > +		hash = kzalloc(sizeof(*hash) + hash_digest_size[algo],
> > +			       GFP_KERNEL);
> > +		if (!hash) {
> > +			*cause = "verity-hashing-error";
> > +			*status = INTEGRITY_FAIL;
> > +			break;
> > +		}
> > +
> > +		rc = calc_tbs_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
> > +				   iint->ima_hash->digest, hash);
> > +		if (rc) {
> > +			*cause = "verity-hashing-error";
> > +			*status = INTEGRITY_FAIL;
> > +			break;
> > +		}
> > +
> > +		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> > +					     (const char *)xattr_value,
> > +					     xattr_len, hash->digest,
> > +					     hash->length);
> > +		if (rc) {
> > +			*cause = "invalid-verity-signature";
> > +			*status = INTEGRITY_FAIL;
> > +		} else {
> > +			*status = INTEGRITY_PASS;
> > +		}
> > +
> >  		break;
> >  	case EVM_IMA_XATTR_DIGSIG:
> >  		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> > @@ -303,6 +383,7 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
> >  		break;
> >  	}
> >  
> > +	kfree(hash);
> >  	return rc;
> >  }
> >  
> > diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> > index 1c0cea2b805f..31a14943e459 100644
> > --- a/security/integrity/ima/ima_template_lib.c
> > +++ b/security/integrity/ima/ima_template_lib.c
> > @@ -498,7 +498,8 @@ int ima_eventsig_init(struct ima_event_data *event_data,
> >  {
> >  	struct evm_ima_xattr_data *xattr_value = event_data->xattr_value;
> >  
> > -	if ((!xattr_value) || (xattr_value->type != EVM_IMA_XATTR_DIGSIG))
> > +	if ((!xattr_value) ||
> > +	     !(xattr_value->type & (EVM_IMA_XATTR_DIGSIG | IMA_VERITY_DIGSIG)))
> >  		return ima_eventevmsig_init(event_data, field_data);
> >  
> >  	return ima_write_template_field_data(xattr_value, event_data->xattr_len,
> > diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> > index e7ac1086d1d9..51124708c072 100644
> > --- a/security/integrity/integrity.h
> > +++ b/security/integrity/integrity.h
> > @@ -79,6 +79,7 @@ enum evm_ima_xattr_type {
> >  	EVM_IMA_XATTR_DIGSIG,
> >  	IMA_XATTR_DIGEST_NG,
> >  	EVM_XATTR_PORTABLE_DIGSIG,
> > +	IMA_VERITY_DIGSIG,
> >  	IMA_XATTR_LAST
> >  };
> >  
> > -- 
> > 2.27.0


