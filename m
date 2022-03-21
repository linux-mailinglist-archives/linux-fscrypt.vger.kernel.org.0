Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D8F4E26F1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 13:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbiCUMzM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 08:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343693AbiCUMzK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 08:55:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0197349F0E;
        Mon, 21 Mar 2022 05:53:44 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LCbtYV020632;
        Mon, 21 Mar 2022 12:53:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YdFgqeukeLoGFVaICxahPmVUOqgutiRUWpi8e1v11VA=;
 b=LTs6csA0mg+QnOkRHqyrw/vozmfj5WnQb3Ume2Jamh/9C0SaGVX8XyGmG6aarrzkPEiD
 ck1QO05SdpuCp2UPY0l0k0xrEf0CQa85HDT16HBaz7QI+YQ4UoPVNlGYgAro5nE4JrsI
 aXvQd8hSUqf4eFLbCpGynLE4BDEGdNQ5u6Xveiku+YtAkyLH1lJTldPiduG/CsFqWguJ
 e9Ma9Nieh8q7MQc4hI/jN7gPE8heAWCm0PQKCRe35BtCpLLH9VAe73VbgPtcjgjtfZWS
 TdlG1p/nepN9J12N5GEiDAeHC9oDXjAFOU7PP/rj4yNh2WT7tIJrJ3M4dHHibD6Lyho+ ZA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3exf1uuspn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 12:53:39 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LCr7p9005803;
        Mon, 21 Mar 2022 12:53:38 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3ew6t9gm9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 12:53:38 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LCrbTd32637328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 12:53:37 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 323DD7805F;
        Mon, 21 Mar 2022 12:53:37 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F301B78060;
        Mon, 21 Mar 2022 12:53:35 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 12:53:35 +0000 (GMT)
Message-ID: <b19eca12-3ae1-a8a5-fcfd-a22b5ee9319c@linux.ibm.com>
Date:   Mon, 21 Mar 2022 08:53:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v6 2/5] ima: define a new template field named 'd-ngv2'
 and templates
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318182151.100847-1-zohar@linux.ibm.com>
 <20220318182151.100847-3-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220318182151.100847-3-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kTZHQ2FTVcLb4JqdPtlerAA2SRFtCU89
X-Proofpoint-GUID: kTZHQ2FTVcLb4JqdPtlerAA2SRFtCU89
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_05,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 3/18/22 14:21, Mimi Zohar wrote:
> In preparation to differentiate between unsigned regular IMA file
> hashes and fs-verity's file digests in the IMA measurement list,
> define a new template field named 'd-ngv2'.
> 
> Also define two new templates named 'ima-ngv2' and 'ima-sigv2', which
> include the new 'd-ngv2' field.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   .../admin-guide/kernel-parameters.txt         |  3 +-
>   security/integrity/ima/ima_template.c         |  4 ++
>   security/integrity/ima/ima_template_lib.c     | 71 ++++++++++++++++---
>   security/integrity/ima/ima_template_lib.h     |  4 ++
>   4 files changed, 72 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index f5a27f067db9..47386ac10471 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1876,7 +1876,8 @@
>   
>   	ima_template=	[IMA]
>   			Select one of defined IMA measurements template formats.
> -			Formats: { "ima" | "ima-ng" | "ima-sig" }
> +			Formats: { "ima" | "ima-ng" | "ima-ngv2" | "ima-sig" |
> +				   "ima-sigv2" }
>   			Default: "ima-ng"
>   
>   	ima_template_fmt=
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index db1ad6d7a57f..c25079faa208 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -20,6 +20,8 @@ static struct ima_template_desc builtin_templates[] = {
>   	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
>   	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
>   	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
> +	{.name = "ima-ngv2", .fmt = "d-ngv2|n-ng"},
> +	{.name = "ima-sigv2", .fmt = "d-ngv2|n-ng|sig"},
>   	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
>   	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
>   	{.name = "evm-sig",
> @@ -38,6 +40,8 @@ static const struct ima_template_field supported_fields[] = {
>   	 .field_show = ima_show_template_string},
>   	{.field_id = "d-ng", .field_init = ima_eventdigest_ng_init,
>   	 .field_show = ima_show_template_digest_ng},
> +	{.field_id = "d-ngv2", .field_init = ima_eventdigest_ngv2_init,
> +	 .field_show = ima_show_template_digest_ngv2},
>   	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
>   	 .field_show = ima_show_template_string},
>   	{.field_id = "sig", .field_init = ima_eventsig_init,
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 7155d17a3b75..bd95864a5f6f 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -24,11 +24,16 @@ static bool ima_template_hash_algo_allowed(u8 algo)
>   enum data_formats {
>   	DATA_FMT_DIGEST = 0,
>   	DATA_FMT_DIGEST_WITH_ALGO,
> +	DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
>   	DATA_FMT_STRING,
>   	DATA_FMT_HEX,
>   	DATA_FMT_UINT
>   };
>   
> +#define DIGEST_TYPE_MAXLEN 16	/* including NULL */
> +static const char * const digest_type_name[] = {"ima"};
> +static int digest_type_size = ARRAY_SIZE(digest_type_name);
> +
>   static int ima_write_template_field_data(const void *data, const u32 datalen,
>   					 enum data_formats datafmt,
>   					 struct ima_field_data *field_data)
> @@ -72,8 +77,9 @@ static void ima_show_template_data_ascii(struct seq_file *m,
>   	u32 buflen = field_data->len;
>   
>   	switch (datafmt) {
> +	case DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
>   	case DATA_FMT_DIGEST_WITH_ALGO:
> -		buf_ptr = strnchr(field_data->data, buflen, ':');
> +		buf_ptr = strrchr(field_data->data, ':');
>   		if (buf_ptr != field_data->data)
>   			seq_printf(m, "%s", field_data->data);
>   
> @@ -178,6 +184,14 @@ void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
>   				     field_data);
>   }
>   
> +void ima_show_template_digest_ngv2(struct seq_file *m, enum ima_show_type show,
> +				   struct ima_field_data *field_data)
> +{
> +	ima_show_template_field_data(m, show,
> +				     DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
> +				     field_data);
> +}
> +
>   void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
>   			      struct ima_field_data *field_data)
>   {
> @@ -265,26 +279,39 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
>   }
>   
>   static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
> -				       u8 hash_algo,
> +				       u8 digest_type, u8 hash_algo,
>   				       struct ima_field_data *field_data)
>   {
>   	/*
>   	 * digest formats:
>   	 *  - DATA_FMT_DIGEST: digest
>   	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> +	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> +	 *	[<digest type> + ':' + <hash algo>] + ':' + '\0' + digest,
> +	 *    where <hash type> is either "ima" or "verity",
>   	 *    where <hash algo> is provided if the hash algorithm is not
>   	 *    SHA1 or MD5
>   	 */
> -	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
> +	u8 buffer[DIGEST_TYPE_MAXLEN + CRYPTO_MAX_ALG_NAME + 2 +
> +		IMA_MAX_DIGEST_SIZE] = { 0 };

Should it not be DIGEST_TYPE_MAXLEN + 1 /* for ':' */ + 
CRYPTO_MAX_ALG_NAME + ....

>   	enum data_formats fmt = DATA_FMT_DIGEST;
>   	u32 offset = 0;
>   
> -	if (hash_algo < HASH_ALGO__LAST) {
> -		fmt = DATA_FMT_DIGEST_WITH_ALGO;
> -		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
> +	if (digest_type < digest_type_size && hash_algo < HASH_ALGO__LAST) {

It's a bit difficult to see what the digest_type has to do with size...
Maybe digest_type should be a enum and the comparison here should be 
digest_type != DIGEST_TYPE_NONE or something like it..


> +		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> +		offset += snprintf(buffer, DIGEST_TYPE_MAXLEN +
> +				   CRYPTO_MAX_ALG_NAME + 1, "%*s:%s",
> +				   (int)strlen(digest_type_name[digest_type]),
> +				   digest_type_name[digest_type],
>   				   hash_algo_name[hash_algo]);
>   		buffer[offset] = ':';
>   		offset += 2;
> +	} else if (hash_algo < HASH_ALGO__LAST) {
> +		fmt = DATA_FMT_DIGEST_WITH_ALGO;
> +		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1,
> +				   "%s", hash_algo_name[hash_algo]);
> +		buffer[offset] = ':';
> +		offset += 2;
>   	}
>   
>   	if (digest)
> @@ -359,7 +386,8 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
>   	cur_digestsize = hash.hdr.length;
>   out:
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   HASH_ALGO__LAST, field_data);
> +					   digest_type_size, HASH_ALGO__LAST,
> +					   field_data);
>   }
>   
>   /*
> @@ -380,7 +408,31 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   	hash_algo = event_data->iint->ima_hash->algo;
>   out:
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   hash_algo, field_data);
> +					   digest_type_size, hash_algo,
> +					   field_data);
> +}
> +
> +/*
> + * This function writes the digest of an event (without size limit),
> + * prefixed with both the hash type and algorithm.
> + */
> +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
> +			      struct ima_field_data *field_data)
> +{
> +	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
> +	u32 cur_digestsize = 0;
> +	u8 digest_type = 0;

What does '0' mean? I think this should definitely be an enum or at 
least #define.

> +
> +	if (event_data->violation)	/* recording a violation. */
> +		goto out;
> +
> +	cur_digest = event_data->iint->ima_hash->digest;
> +	cur_digestsize = event_data->iint->ima_hash->length;
> +
> +	hash_algo = event_data->iint->ima_hash->algo;
> +out:
> +	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> +					   digest_type, hash_algo, field_data);
>   }
>   
>   /*
> @@ -415,7 +467,8 @@ int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
>   	}
>   
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   hash_algo, field_data);
> +					   digest_type_size, hash_algo,
> +					   field_data);
>   }
>   
>   static int ima_eventname_init_common(struct ima_event_data *event_data,
> diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
> index c71f1de95753..9f7c335f304f 100644
> --- a/security/integrity/ima/ima_template_lib.h
> +++ b/security/integrity/ima/ima_template_lib.h
> @@ -21,6 +21,8 @@ void ima_show_template_digest(struct seq_file *m, enum ima_show_type show,
>   			      struct ima_field_data *field_data);
>   void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
>   				 struct ima_field_data *field_data);
> +void ima_show_template_digest_ngv2(struct seq_file *m, enum ima_show_type show,
> +				   struct ima_field_data *field_data);
>   void ima_show_template_string(struct seq_file *m, enum ima_show_type show,
>   			      struct ima_field_data *field_data);
>   void ima_show_template_sig(struct seq_file *m, enum ima_show_type show,
> @@ -38,6 +40,8 @@ int ima_eventname_init(struct ima_event_data *event_data,
>   		       struct ima_field_data *field_data);
>   int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   			    struct ima_field_data *field_data);
> +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
> +			      struct ima_field_data *field_data);
>   int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
>   				struct ima_field_data *field_data);
>   int ima_eventname_ng_init(struct ima_event_data *event_data,
