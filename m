Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A85BC515768
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 23:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbiD2VzM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 17:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239101AbiD2VzL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 17:55:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81274140D4;
        Fri, 29 Apr 2022 14:51:51 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TL0TbL018234;
        Fri, 29 Apr 2022 21:51:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=JbH+EfCmJGIsUSA3ahL4gd3zveVzJdcZTPDmaNBEqUI=;
 b=mx19pxHJW0EUhE7o1pA5S6CpWoiA5uo8mH+beKqQuk+QVE9yq2aSrsjHwZ28874NGttt
 gvDsHoE56NG+4eOgji8RNfTcYABPdgwA8w8CpSdmilW/+CuX5P+kyEb+5olbbSFatTVf
 skjVwNKleWYAgDPXg5wHKUrcb/3KiuBmMps5Qjz5DNeQpF5Wdihwpr6LYRYMfi8C7pr+
 lBTee/xksf26clr6DfF2XBblIXivI1ZZ1pk/eqeO1dwdpfCn5+22wVZ/YkL75g096rDp
 QwmFUs9CdJhes81RBMD4Gh9GDJQtQJ00+1vvMQkRd0SJsZxWRN5c4wkpQwyCc3lqMXi4 2Q== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3frma4mye3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 21:51:49 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TLlmQQ012069;
        Fri, 29 Apr 2022 21:51:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3fm93aqbp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 21:51:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TLplNM28377542
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 21:51:47 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B82C3124054;
        Fri, 29 Apr 2022 21:51:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81385124052;
        Fri, 29 Apr 2022 21:51:47 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 21:51:47 +0000 (GMT)
Message-ID: <8a18eb04-4d07-7bad-e6f9-0015788e6a11@linux.ibm.com>
Date:   Fri, 29 Apr 2022 17:51:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 6/7] ima: support fs-verity file digest based version 3
 signatures
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-7-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-7-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w6WYkOvB2QTl30jagM3OBTJQtYQD6zKC
X-Proofpoint-GUID: w6WYkOvB2QTl30jagM3OBTJQtYQD6zKC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_09,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290115
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:26, Mimi Zohar wrote:
> IMA may verify a file's integrity against a "good" value stored in the
> 'security.ima' xattr or as an appended signature, based on policy.  When
> the "good value" is stored in the xattr, the xattr may contain a file
> hash or signature.  In either case, the "good" value is preceded by a
> header.  The first byte of the xattr header indicates the type of data
> - hash, signature - stored in the xattr.  To support storing fs-verity
> signatures in the 'security.ima' xattr requires further differentiating
> the fs-verity signature from the existing IMA signature.
> 
> In addition the signatures stored in 'security.ima' xattr, need to be
> disambiguated.  Instead of directly signing the fs-verity digest, a new
> signature format version 3 is defined as the hash of the ima_file_id
> structure, which identifies the type of signature and the digest.
> 
> The IMA policy defines "which" files are to be measured, verified, and/or
> audited.  For those files being verified, the policy rules indicate "how"
> the file should be verified.  For example to require a file be signed,
> the appraise policy rule must include the 'appraise_type' option.
> 
> 	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
>             where 'imasig' is the original or signature format v2 (default),
>             where 'modsig' is an appended signature,
>             where 'sigv3' is the signature format v3.
> 
> The policy rule must also indicate the type of digest, if not the IMA
> default, by first specifying the digest type:
> 
> 	digest_type:= [verity]
> 
> The following policy rule requires fsverity signatures.  The rule may be
> constrained, for example based on a fsuuid or LSM label.
> 
>        appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   Documentation/ABI/testing/ima_policy      |  31 +++++-
>   Documentation/security/IMA-templates.rst  |   4 +-
>   security/integrity/digsig.c               |   3 +-
>   security/integrity/ima/ima_appraise.c     | 114 +++++++++++++++++++++-
>   security/integrity/ima/ima_policy.c       |  43 ++++++--
>   security/integrity/ima/ima_template_lib.c |   4 +-
>   security/integrity/integrity.h            |  26 ++++-
>   7 files changed, 206 insertions(+), 19 deletions(-)
> 

> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 09b5fac38195..15b4add314fc 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -71,8 +71,8 @@ descriptors by adding their identifier to the format string
>      (field format: <digest type>:<hash algo>:digest);
>    - 'd-modsig': the digest of the event without the appended modsig;
>    - 'n-ng': the name of the event, without size limitations;
> - - 'sig': the file signature, or the EVM portable signature if the file
> -   signature is not found;
> + - 'sig': the file signature, based on either the file's/fsverity's digest[1],
> +   or the EVM portable signature, if 'security.ima' contains a file hash.
>    - 'modsig' the appended file signature;
>    - 'buf': the buffer data that was used to generate the hash without size limitations;
>    - 'evmsig': the EVM portable signature;
> diff --git a/security/integrity/digsig.c b/security/integrity/digsig.c
> index c8c8a4a4e7a0..5f5639971b04 100644
> --- a/security/integrity/digsig.c
> +++ b/security/integrity/digsig.c
> @@ -75,7 +75,8 @@ int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
>   		/* v1 API expect signature without xattr type */
>   		return digsig_verify(keyring, sig + 1, siglen - 1, digest,
>   				     digestlen);
> -	case 2:
> +	case 2: /* regular file data hash based signature */
> +	case 3: /* struct ima_file_id data base signature */

nit: base -> based

>   		return asymmetric_verify(keyring, sig, siglen, digest,
>   					 digestlen);
>   	}
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 17232bbfb9f9..37ff20fc7294 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -13,7 +13,9 @@
>   #include <linux/magic.h>
>   #include <linux/ima.h>
>   #include <linux/evm.h>
> +#include <linux/fsverity.h>
>   #include <keys/system_keyring.h>
> +#include <uapi/linux/fsverity.h>
>   
>   #include "ima.h"
>   
> @@ -183,13 +185,18 @@ enum hash_algo ima_get_hash_algo(const struct evm_ima_xattr_data *xattr_value,
>   		return ima_hash_algo;
>   
>   	switch (xattr_value->type) {
> +	case IMA_VERITY_DIGSIG:
> +		sig = (typeof(sig))xattr_value;
> +		if (sig->version != 3 || xattr_len <= sizeof(*sig) ||
> +		    sig->hash_algo >= HASH_ALGO__LAST)
> +			return ima_hash_algo;
> +		return sig->hash_algo;
>   	case EVM_IMA_XATTR_DIGSIG:
>   		sig = (typeof(sig))xattr_value;
>   		if (sig->version != 2 || xattr_len <= sizeof(*sig)
>   		    || sig->hash_algo >= HASH_ALGO__LAST)
>   			return ima_hash_algo;
>   		return sig->hash_algo;
> -		break;
>   	case IMA_XATTR_DIGEST_NG:
>   		/* first byte contains algorithm id */
>   		ret = xattr_value->data[0];
> @@ -225,6 +232,40 @@ int ima_read_xattr(struct dentry *dentry,
>   	return ret;
>   }
>   
> +/*
> + * calc_file_id_hash - calculate the hash of the ima_file_id struct data
> + * @type: xattr type [enum evm_ima_xattr_type]
> + * @algo: hash algorithm [enum hash_algo]
> + * @digest: pointer to the digest to be hashed
> + * @hash: (out) pointer to the hash
> + *
> + * IMA signature version 3 disambiguates the data that is signed by
> + * indirectly signing the hash of the ima_file_id structure data.
> + *
> + * Signing the ima_file_id struct is currently only supported for
> + * IMA_VERITY_DIGSIG type xattrs.
> + *
> + * Return 0 on success, error code otherwise.
> + */
> +static int calc_file_id_hash(enum evm_ima_xattr_type type,
> +			     enum hash_algo algo, const u8 *digest,
> +			     struct ima_digest_data *hash)
> +{
> +	struct ima_file_id file_id = {
> +		.hash_type = IMA_VERITY_DIGSIG, .hash_algorithm = algo};
> +	unsigned int unused = HASH_MAX_DIGESTSIZE - hash_digest_size[algo];
> +
> +	if (type != IMA_VERITY_DIGSIG)
> +		return -EINVAL;
> +
> +	memcpy(file_id.hash, digest, hash_digest_size[algo]);
> +
> +	hash->algo = algo;
> +	hash->length = hash_digest_size[algo];
> +
> +	return ima_calc_buffer_hash(&file_id, sizeof(file_id) - unused, hash);

+struct ima_file_id {
+	__u8 hash_type;		/* xattr type [enum evm_ima_xattr_type] */
+	__u8 hash_algorithm;	/* Digest algorithm [enum hash_algo] */
+	__u8 hash[HASH_MAX_DIGESTSIZE];
+} __packed;

did you maybe mean 'sizeof(file_id.hash) - unused' ?


> +}
> +
>   /*
>    * xattr_verify - verify xattr digest or signature
>    *
> @@ -236,7 +277,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>   			struct evm_ima_xattr_data *xattr_value, int xattr_len,
>   			enum integrity_status *status, const char **cause)
>   {
> +	struct ima_max_digest_data hash;
> +	struct signature_v2_hdr *sig;
>   	int rc = -EINVAL, hash_start = 0;
> +	int mask;
>   
>   	switch (xattr_value->type) {
>   	case IMA_XATTR_DIGEST_NG:
> @@ -246,7 +290,10 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>   	case IMA_XATTR_DIGEST:
>   		if (*status != INTEGRITY_PASS_IMMUTABLE) {
>   			if (iint->flags & IMA_DIGSIG_REQUIRED) {
> -				*cause = "IMA-signature-required";
> +				if (iint->flags & IMA_VERITY_REQUIRED)
> +					*cause = "verity-signature-required";
> +				else
> +					*cause = "IMA-signature-required";
>   				*status = INTEGRITY_FAIL;
>   				break;
>   			}
> @@ -274,6 +321,20 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>   		break;
>   	case EVM_IMA_XATTR_DIGSIG:
>   		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> +
> +		mask = IMA_DIGSIG_REQUIRED | IMA_VERITY_REQUIRED;
> +		if ((iint->flags & mask) == mask) {
> +			*cause = "verity-signature-required";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		sig = (typeof(sig))xattr_value;
> +		if (sig->version == 3) {

nit for the future(?): sig->version >= 3

> +			*cause = "invalid-signature-version";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
>   		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>   					     (const char *)xattr_value,
>   					     xattr_len,
> @@ -296,6 +357,44 @@ static int xattr_verify(enum ima_hooks func, struct integrity_iint_cache *iint,
>   		} else {
>   			*status = INTEGRITY_PASS;
>   		}
> +		break;
> +	case IMA_VERITY_DIGSIG:
> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> +
> +		if (iint->flags & IMA_DIGSIG_REQUIRED) {
> +			if (!(iint->flags & IMA_VERITY_REQUIRED)) {
> +				*cause = "IMA-signature-required";
> +				*status = INTEGRITY_FAIL;
> +				break;
> +			}
> +		}
> +
> +		sig = (typeof(sig))xattr_value;
> +		if (sig->version != 3) {
> +			*cause = "invalid-signature-version";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = calc_file_id_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
> +				       iint->ima_hash->digest, &hash.hdr);
> +		if (rc) {
> +			*cause = "sigv3-hashing-error";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> +					     (const char *)xattr_value,
> +					     xattr_len, hash.digest,
> +					     hash.hdr.length);
> +		if (rc) {
> +			*cause = "invalid-verity-signature";
> +			*status = INTEGRITY_FAIL;
> +		} else {
> +			*status = INTEGRITY_PASS;
> +		}
> +
>   		break;
>   	default:
>   		*status = INTEGRITY_UNKNOWN;
> @@ -396,8 +495,15 @@ int ima_appraise_measurement(enum ima_hooks func,
>   		if (rc && rc != -ENODATA)
>   			goto out;
>   
> -		cause = iint->flags & IMA_DIGSIG_REQUIRED ?
> -				"IMA-signature-required" : "missing-hash";
> +		if (iint->flags & IMA_DIGSIG_REQUIRED) {
> +			if (iint->flags & IMA_VERITY_REQUIRED)
> +				cause = "verity-signature-required";
> +			else
> +				cause = "IMA-signature-required";
> +		} else {
> +			cause = "missing-hash";
> +		}
> +
>   		status = INTEGRITY_NOLABEL;
>   		if (file->f_mode & FMODE_CREATED)
>   			iint->flags |= IMA_NEW_FILE;
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 390a8faa77f9..e24531db95cd 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -1310,6 +1310,15 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>   	    !(entry->flags & IMA_MODSIG_ALLOWED))
>   		return false;
>   
> +	/*
> +	 * Ensure verity appraise rules require signature format v3 signatures
> +	 * ('appraise_type=sigv3').

This comment doesn't seem to reflect what is actually checked below ... 
at least for me it's difficult to see that.

It's more like 'ensure that appraise rules for verity signature type 
also have the IMA_DIGSIG_REQUIRED flag set.'

> +	 */
> +	if (entry->action == APPRAISE &&
> +	    (entry->flags & IMA_VERITY_REQUIRED) &&
> +	    !(entry->flags & IMA_DIGSIG_REQUIRED))
> +		return false;
> +
>   	return true;
>   }
>   
