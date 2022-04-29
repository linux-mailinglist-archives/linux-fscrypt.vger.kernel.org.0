Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C660651522A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 19:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbiD2Ref (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 13:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379737AbiD2ReM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 13:34:12 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFAB6694B0;
        Fri, 29 Apr 2022 10:30:52 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TGCY9d005165;
        Fri, 29 Apr 2022 17:30:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WFL/U33Ha8OXulEYobBN/mDs+rMVvy1Wgxjn9y4J1d4=;
 b=k2+gSa8m6B+vMvUazgUqIqnA8A3b09A1rp6ow8CusaNh08LE5PTG1V2g14TxLT7Xuob4
 qkxVgs8yY+phop0fmT5J7U5VdulSSseeuK41xGAJDzXjoivkcn5HlxZmHOS3TDKgvMpV
 bNe629RBAtO0bYkp19VBsm/gsqkcxj6CUc0cQj2lv0kAPFhUVArLrnIa2aJZykB/9DTl
 qOZd2kdXVhQ/7pN41Um61R+Occ0Eh/8hA9N+w9lLXdDUXFZaJ0YM0FtOFP9Y2++6Dtt8
 NehqVwRM7zvHCuZVOXi77xJuCACdvr//TXd2pgdup9ku3eyHYx6pHNhIBJh00ciQ5Wji RA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqu6p9phg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 17:30:48 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23THFpLk021538;
        Fri, 29 Apr 2022 17:30:47 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 3fm93ab5wu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 17:30:47 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23THUlBj19792250
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 17:30:47 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 337F7AC05B;
        Fri, 29 Apr 2022 17:30:47 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBE94AC064;
        Fri, 29 Apr 2022 17:30:46 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 17:30:46 +0000 (GMT)
Message-ID: <40351a94-c46c-772a-6dff-3e4dd921b68d@linux.ibm.com>
Date:   Fri, 29 Apr 2022 13:30:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 5/7] ima: permit fsverity's file digests in the IMA
 measurement list
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-6-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-6-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wyYCuORhybz-IYuML_vqMTWUyJ0A6YDr
X-Proofpoint-ORIG-GUID: wyYCuORhybz-IYuML_vqMTWUyJ0A6YDr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_08,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290086
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:25, Mimi Zohar wrote:
> Permit fsverity's file digest (a hash of struct fsverity_descriptor) to
> be included in the IMA measurement list, based on the new measurement
> policy rule 'digest_type=verity' option.
> 
> To differentiate between a regular IMA file hash from an fsverity's
> file digest, use the new d-ngv2 format field included in the ima-ngv2
> template.
> 
> The following policy rule requires fsverity file digests and specifies
> the new 'ima-ngv2' template, which contains the new 'd-ngv2' field.  The
> policy rule may be constrained, for example based on a fsuuid or LSM
> label.
> 
> measure func=FILE_CHECK digest_type=verity template=ima-ngv2
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   Documentation/ABI/testing/ima_policy      | 14 ++++++-
>   Documentation/security/IMA-templates.rst  |  2 +-
>   security/integrity/ima/ima_api.c          | 49 +++++++++++++++++++++--
>   security/integrity/ima/ima_main.c         |  2 +-
>   security/integrity/ima/ima_policy.c       | 38 +++++++++++++++++-
>   security/integrity/ima/ima_template_lib.c | 10 +++--
>   security/integrity/integrity.h            |  1 +
>   7 files changed, 105 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index 839fab811b18..0a8caed393e3 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -27,8 +27,9 @@ Description:
>   				[fowner=] [fgroup=]]
>   			lsm:	[[subj_user=] [subj_role=] [subj_type=]
>   				 [obj_user=] [obj_role=] [obj_type=]]
> -			option:	[[appraise_type=]] [template=] [permit_directio]
> -				[appraise_flag=] [appraise_algos=] [keyrings=]
> +			option:	[digest_type=] [template=] [permit_directio]
> +				[appraise_type=] [appraise_flag=]
> +				[appraise_algos=] [keyrings=]
>   		  base:
>   			func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
>   				[FIRMWARE_CHECK]
> @@ -51,6 +52,9 @@ Description:
>   			appraise_flag:= [check_blacklist]
>   			Currently, blacklist check is only for files signed with appended
>   			signature.
> +			digest_type:= verity
> +			    Require fs-verity's file digest instead of the
> +			    regular IMA file hash.
>   			keyrings:= list of keyrings
>   			(eg, .builtin_trusted_keys|.ima). Only valid
>   			when action is "measure" and func is KEY_CHECK.
> @@ -149,3 +153,9 @@ Description:
>   		security.ima xattr of a file:
>   
>   			appraise func=SETXATTR_CHECK appraise_algos=sha256,sha384,sha512
> +
> +		Example of a 'measure' rule requiring fs-verity's digests
> +		with indication of type of digest in the measurement list.
> +
> +			measure func=FILE_CHECK digest_type=verity \
> +				template=ima-ngv2
> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index eafc4e34f890..09b5fac38195 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -67,7 +67,7 @@ descriptors by adding their identifier to the format string
>    - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
>    - 'd-ng': the digest of the event, calculated with an arbitrary hash
>      algorithm (field format: <hash algo>:digest);
> - - 'd-ngv2': same as d-ng, but prefixed with the "ima" digest type
> + - 'd-ngv2': same as d-ng, but prefixed with the "ima" or "verity" digest type
>      (field format: <digest type>:<hash algo>:digest);
>    - 'd-modsig': the digest of the event without the appended modsig;
>    - 'n-ng': the name of the event, without size limitations;
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index c6805af46211..d64ec031b1b4 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -14,6 +14,7 @@
>   #include <linux/xattr.h>
>   #include <linux/evm.h>
>   #include <linux/iversion.h>
> +#include <linux/fsverity.h>
>   
>   #include "ima.h"
>   
> @@ -200,6 +201,34 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>   				allowed_algos);
>   }
>   
> +static int ima_get_verity_digest(struct integrity_iint_cache *iint,
> +				 struct ima_max_digest_data *hash)
> +{
> +	enum hash_algo verity_alg;
> +	int ret;
> +
> +	/*
> +	 * On failure, 'measure' policy rules will result in a file data
> +	 * hash containing 0's.
> +	 */
> +	ret = fsverity_get_digest(iint->inode, hash->digest, &verity_alg);
> +	if (ret) {
> +		memset(hash->digest, 0, sizeof(hash->digest));
> +		return ret;
> +	}
> +
> +	/*
> +	 * Unlike in the case of actually calculating the file hash, in
> +	 * the fsverity case regardless of the hash algorithm, return
> +	 * the verity digest to be included in the measurement list. A
> +	 * mismatch between the verity algorithm and the xattr signature
> +	 * algorithm, if one exists, will be detected later.
> +	 */
> +	hash->hdr.algo = verity_alg;
> +	hash->hdr.length = hash_digest_size[verity_alg];
> +	return 0;
> +}
> +
>   /*
>    * ima_collect_measurement - collect file measurement
>    *
> @@ -242,16 +271,30 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>   	 */
>   	i_version = inode_query_iversion(inode);
>   	hash.hdr.algo = algo;
> +	hash.hdr.length = hash_digest_size[algo];
>   
>   	/* Initialize hash digest to 0's in case of failure */
>   	memset(&hash.digest, 0, sizeof(hash.digest));

You seem to be doing this above as well in ima_get_verity_digest(). I 
guess the above one could go.

>   
> -	if (buf)
> +	if (iint->flags & IMA_VERITY_REQUIRED) {
> +		result = ima_get_verity_digest(iint, &hash);
> +		switch (result) {
> +		case 0:
> +			break;
> +		case -ENODATA:
> +			audit_cause = "no-verity-digest";
> +			break;
> +		default:
> +			audit_cause = "invalid-verity-digest";
> +			break;
> +		}
> +	} else if (buf) {
>   		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
> -	else
> +	} else {
>   		result = ima_calc_file_hash(file, &hash.hdr);
> +	}
>   
> -	if (result && result != -EBADF && result != -EINVAL)
> +	if (result == -ENOMEM)
>   		goto out;
>   
>   	length = sizeof(hash.hdr) + hash.hdr.length;
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 1aebf63ad7a6..040b03ddc1c7 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -335,7 +335,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
>   	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
>   
>   	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
> -	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
> +	if (rc == -ENOMEM)
>   		goto out_locked;
>   
>   	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index eea6e92500b8..390a8faa77f9 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -1023,6 +1023,7 @@ enum policy_opt {
>   	Opt_fowner_gt, Opt_fgroup_gt,
>   	Opt_uid_lt, Opt_euid_lt, Opt_gid_lt, Opt_egid_lt,
>   	Opt_fowner_lt, Opt_fgroup_lt,
> +	Opt_digest_type,
>   	Opt_appraise_type, Opt_appraise_flag, Opt_appraise_algos,
>   	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
>   	Opt_label, Opt_err
> @@ -1065,6 +1066,7 @@ static const match_table_t policy_tokens = {
>   	{Opt_egid_lt, "egid<%s"},
>   	{Opt_fowner_lt, "fowner<%s"},
>   	{Opt_fgroup_lt, "fgroup<%s"},
> +	{Opt_digest_type, "digest_type=%s"},
>   	{Opt_appraise_type, "appraise_type=%s"},
>   	{Opt_appraise_flag, "appraise_flag=%s"},
>   	{Opt_appraise_algos, "appraise_algos=%s"},
> @@ -1172,6 +1174,21 @@ static void check_template_modsig(const struct ima_template_desc *template)
>   #undef MSG
>   }
>   
> +/*
> + * Warn if the template does not contain the given field.
> + */
> +static void check_template_field(const struct ima_template_desc *template,
> +				 const char *field, const char *msg)
> +{
> +	int i;
> +
> +	for (i = 0; i < template->num_fields; i++)
> +		if (!strcmp(template->fields[i]->field_id, field))
> +			return;
> +
> +	pr_notice_once("%s", msg);
> +}
> +
>   static bool ima_validate_rule(struct ima_rule_entry *entry)
>   {
>   	/* Ensure that the action is set and is compatible with the flags */
> @@ -1214,7 +1231,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
>   				     IMA_INMASK | IMA_EUID | IMA_PCR |
>   				     IMA_FSNAME | IMA_GID | IMA_EGID |
>   				     IMA_FGROUP | IMA_DIGSIG_REQUIRED |
> -				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS))
> +				     IMA_PERMIT_DIRECTIO | IMA_VALIDATE_ALGOS |
> +				     IMA_VERITY_REQUIRED))
>   			return false;
>   
>   		break;
> @@ -1707,6 +1725,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>   						   LSM_SUBJ_TYPE,
>   						   AUDIT_SUBJ_TYPE);
>   			break;
> +		case Opt_digest_type:
> +			ima_log_string(ab, "digest_type", args[0].from);
> +			if ((strcmp(args[0].from, "verity")) == 0)
> +				entry->flags |= IMA_VERITY_REQUIRED;
> +			else
> +				result = -EINVAL;
> +			break;
>   		case Opt_appraise_type:
>   			ima_log_string(ab, "appraise_type", args[0].from);
>   			if ((strcmp(args[0].from, "imasig")) == 0)
> @@ -1797,6 +1822,15 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>   		check_template_modsig(template_desc);
>   	}
>   
> +	/* d-ngv2 template field recommended for unsigned fs-verity digests */
> +	if (!result && entry->action == MEASURE &&
> +	    entry->flags & IMA_VERITY_REQUIRED) {
> +		template_desc = entry->template ? entry->template :
> +						  ima_template_desc_current();
> +		check_template_field(template_desc, "d-ngv2",
> +				     "verity rules should include d-ngv2");
> +	}
> +
>   	audit_log_format(ab, "res=%d", !result);
>   	audit_log_end(ab);
>   	return result;
> @@ -2154,6 +2188,8 @@ int ima_policy_show(struct seq_file *m, void *v)
>   		else
>   			seq_puts(m, "appraise_type=imasig ");
>   	}
> +	if (entry->flags & IMA_VERITY_REQUIRED)
> +		seq_puts(m, "digest_type=verity ");
>   	if (entry->flags & IMA_CHECK_BLACKLIST)
>   		seq_puts(m, "appraise_flag=check_blacklist ");
>   	if (entry->flags & IMA_PERMIT_DIRECTIO)
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index ff82e699149c..2ebcf6cd92b8 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -32,12 +32,14 @@ enum data_formats {
>   
>   enum digest_type {
>   	DIGEST_TYPE_IMA,
> +	DIGEST_TYPE_VERITY,
>   	DIGEST_TYPE__LAST
>   };
>   
> -#define DIGEST_TYPE_NAME_LEN_MAX 4	/* including NULL */
> +#define DIGEST_TYPE_NAME_LEN_MAX 7	/* including NULL */
>   static const char * const digest_type_name[DIGEST_TYPE__LAST] = {
> -	[DIGEST_TYPE_IMA] = "ima"
> +	[DIGEST_TYPE_IMA] = "ima",
> +	[DIGEST_TYPE_VERITY] = "verity"
>   };
>   
>   static int ima_write_template_field_data(const void *data, const u32 datalen,
> @@ -297,7 +299,7 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
>   	 *
>   	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
>   	 *      with a hash size limitation of 20 bytes,
> -	 *    where <digest type> is "ima",
> +	 *    where <digest type> is either "ima" or "verity",
>   	 *    where <hash algo> is the hash_algo_name[] string.
>   	 */
>   	u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
> @@ -435,6 +437,8 @@ int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
>   	cur_digestsize = event_data->iint->ima_hash->length;
>   
>   	hash_algo = event_data->iint->ima_hash->algo;
> +	if (event_data->iint->flags & IMA_VERITY_REQUIRED)
> +		digest_type = DIGEST_TYPE_VERITY;
>   out:
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
>   					   digest_type, hash_algo,
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 3510e413ea17..04e2b99cd912 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -40,6 +40,7 @@
>   #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
>   #define IMA_MODSIG_ALLOWED	0x20000000
>   #define IMA_CHECK_BLACKLIST	0x40000000
> +#define IMA_VERITY_REQUIRED	0x80000000
>   
>   #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>   				 IMA_HASH | IMA_APPRAISE_SUBMASK)

Acked-by: Stefan Berger <stefanb@linux.ibm.com>
