Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E786F4B5C49
	for <lists+linux-fscrypt@lfdr.de>; Mon, 14 Feb 2022 22:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbiBNVKR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 16:10:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiBNVKO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 16:10:14 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D40C2492;
        Mon, 14 Feb 2022 13:10:05 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EI9WKD008775;
        Mon, 14 Feb 2022 20:13:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N0QNkjW3qGQaVeorojZWrqSjCFf0AtLA6NMcO9ypCik=;
 b=QtPNgtDvx2E/gY526BJifF3ty15H/Yo2Sl/iOcAuiyVpbf4hQrbed9/jIVlYdAHganmZ
 Cq4kJScL7N4y8YSN9loMUD2Ah+UQOTFTAFqy4bQmURty3/SWtiSzsdNQsp/1jb7zwS8Y
 Pwx8iQIRemIiPmraJ5lh0SHrvPqlviAPIlzJXgWJcEkIUWxaGBpX2dDgZRs76kIXEDPe
 QIxAVCEi0pu07MHHIe2GWZPJzlqEbTqsrL+eTMVcYP7yB3FHrsN15gKVE2WQx8ZkBRA1
 WTZFwn98qMvOjw4x/Hu7u0f/oDBg+yFj/EHW3aQEr+PabmftEHE9SvS/YgmdPQV920jy mQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e6ycr3fef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:13:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EK1xcr005846;
        Mon, 14 Feb 2022 20:13:33 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3e64ha7x5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:13:33 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EKDWHp33423846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:13:32 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF291AC065;
        Mon, 14 Feb 2022 20:13:32 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8156EAC059;
        Mon, 14 Feb 2022 20:13:32 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 20:13:32 +0000 (GMT)
Message-ID: <b0ba8db6-cf85-0ee3-af19-c8b1251d5b63@linux.ibm.com>
Date:   Mon, 14 Feb 2022 15:13:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 2/8] ima: define ima_max_digest_data struct without a
 flexible array variable
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-3-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220211214310.119257-3-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DUZyhJckYq_l8o03iQFE7ETTRaar7VtR
X-Proofpoint-GUID: DUZyhJckYq_l8o03iQFE7ETTRaar7VtR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 2/11/22 16:43, Mimi Zohar wrote:
> To support larger hash digests in the 'iint' cache, instead of defining
> the 'digest' field as the maximum digest size, the 'digest' field was
> defined as a flexible array variable.  The "ima_digest_data" struct was
> wrapped inside a local structure with the maximum digest size.  But
> before adding the record to the iint cache, memory for the exact digest
> size was dynamically allocated.
>
> The original reason for defining the 'digest' field as a flexible array
> variable is still valid for the 'iint' cache use case.  Instead of
> wrapping the 'ima_digest_data' struct in a local structure define
> 'ima_max_digest_data' struct.
>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   security/integrity/ima/ima_api.c          | 10 ++++------
>   security/integrity/ima/ima_init.c         |  5 +----
>   security/integrity/ima/ima_main.c         |  5 +----
>   security/integrity/ima/ima_template_lib.c |  5 +----
>   security/integrity/integrity.h            | 10 ++++++++++
>   5 files changed, 17 insertions(+), 18 deletions(-)
>
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 5b220a2fe573..c6805af46211 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -217,14 +217,11 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>   	const char *audit_cause = "failed";
>   	struct inode *inode = file_inode(file);
>   	const char *filename = file->f_path.dentry->d_name.name;
> +	struct ima_max_digest_data hash;
>   	int result = 0;
>   	int length;
>   	void *tmpbuf;
>   	u64 i_version;
> -	struct {
> -		struct ima_digest_data hdr;
> -		char digest[IMA_MAX_DIGEST_SIZE];
> -	} hash;
>   
>   	/*
>   	 * Always collect the modsig, because IMA might have already collected
> @@ -239,8 +236,9 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>   
>   	/*
>   	 * Detecting file change is based on i_version. On filesystems
> -	 * which do not support i_version, support is limited to an initial
> -	 * measurement/appraisal/audit.
> +	 * which do not support i_version, support was originally limited
> +	 * to an initial measurement/appraisal/audit, but was modified to
> +	 * assume the file changed.
>   	 */
>   	i_version = inode_query_iversion(inode);
>   	hash.hdr.algo = algo;
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index b26fa67476b4..63979aefc95f 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -47,12 +47,9 @@ static int __init ima_add_boot_aggregate(void)
>   	struct integrity_iint_cache tmp_iint, *iint = &tmp_iint;
>   	struct ima_event_data event_data = { .iint = iint,
>   					     .filename = boot_aggregate_name };
> +	struct ima_max_digest_data hash;
>   	int result = -ENOMEM;
>   	int violation = 0;
> -	struct {
> -		struct ima_digest_data hdr;
> -		char digest[TPM_MAX_DIGEST_SIZE];
> -	} hash;
>   
>   	memset(iint, 0, sizeof(*iint));
>   	memset(&hash, 0, sizeof(hash));
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 7c80dfe2c7a5..c6412dec3810 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -874,10 +874,7 @@ int process_buffer_measurement(struct user_namespace *mnt_userns,
>   					    .buf = buf,
>   					    .buf_len = size};
>   	struct ima_template_desc *template;
> -	struct {
> -		struct ima_digest_data hdr;
> -		char digest[IMA_MAX_DIGEST_SIZE];
> -	} hash = {};
> +	struct ima_max_digest_data hash;


It looks like the initialization wasn't necessary.

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>


>   	char digest_hash[IMA_MAX_DIGEST_SIZE];
>   	int digest_hash_len = hash_digest_size[ima_hash_algo];
>   	int violation = 0;
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 5a5d462ab36d..7155d17a3b75 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -307,10 +307,7 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
>   int ima_eventdigest_init(struct ima_event_data *event_data,
>   			 struct ima_field_data *field_data)
>   {
> -	struct {
> -		struct ima_digest_data hdr;
> -		char digest[IMA_MAX_DIGEST_SIZE];
> -	} hash;
> +	struct ima_max_digest_data hash;
>   	u8 *cur_digest = NULL;
>   	u32 cur_digestsize = 0;
>   	struct inode *inode;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index d045dccd415a..daf49894fd7d 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -15,6 +15,7 @@
>   #include <linux/types.h>
>   #include <linux/integrity.h>
>   #include <crypto/sha1.h>
> +#include <crypto/hash.h>
>   #include <linux/key.h>
>   #include <linux/audit.h>
>   
> @@ -110,6 +111,15 @@ struct ima_digest_data {
>   	u8 digest[];
>   } __packed;
>   
> +/*
> + * Instead of wrapping the ima_digest_data struct inside a local structure
> + * with the maximum hash size, define ima_max_digest_data struct.
> + */
> +struct ima_max_digest_data {
> +	struct ima_digest_data hdr;
> +	u8 digest[HASH_MAX_DIGESTSIZE];
> +} __packed;
> +
>   /*
>    * signature format v2 - for using with asymmetric keys
>    */
