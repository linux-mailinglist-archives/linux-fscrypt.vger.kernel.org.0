Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB394E8DE2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Mar 2022 08:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiC1GQw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Mar 2022 02:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiC1GQu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Mar 2022 02:16:50 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0190205FE;
        Sun, 27 Mar 2022 23:15:07 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KRj6Y6XqpzCrP7;
        Mon, 28 Mar 2022 14:12:53 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Mar 2022 14:15:05 +0800
Message-ID: <889cca45-4697-6edb-41f5-83cf6340bf32@huawei.com>
Date:   Mon, 28 Mar 2022 14:14:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 2/5] ima: define a new template field named 'd-ngv2'
 and templates
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, <linux-integrity@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-3-zohar@linux.ibm.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <20220325223824.310119-3-zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2022/3/26 6:38, Mimi Zohar wrote:
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
>   security/integrity/ima/ima_template.c         |  4 +
>   security/integrity/ima/ima_template_lib.c     | 78 ++++++++++++++++---
>   security/integrity/ima/ima_template_lib.h     |  4 +
>   4 files changed, 79 insertions(+), 10 deletions(-)
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
> index 7155d17a3b75..af269b94b369 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -24,11 +24,22 @@ static bool ima_template_hash_algo_allowed(u8 algo)
>   enum data_formats {
>   	DATA_FMT_DIGEST = 0,
>   	DATA_FMT_DIGEST_WITH_ALGO,
> +	DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO,
>   	DATA_FMT_STRING,
>   	DATA_FMT_HEX,
>   	DATA_FMT_UINT
>   };
>   
> +enum digest_type {
> +	DIGEST_TYPE_IMA,
> +	DIGEST_TYPE__LAST
> +};
> +
> +#define DIGEST_TYPE_NAME_LEN_MAX 4	/* including NULL */
> +static const char * const digest_type_name[DIGEST_TYPE__LAST] = {
> +	[DIGEST_TYPE_IMA] = "ima"
> +};
> +
>   static int ima_write_template_field_data(const void *data, const u32 datalen,
>   					 enum data_formats datafmt,
>   					 struct ima_field_data *field_data)
> @@ -72,8 +83,9 @@ static void ima_show_template_data_ascii(struct seq_file *m,
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
> @@ -178,6 +190,14 @@ void ima_show_template_digest_ng(struct seq_file *m, enum ima_show_type show,
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
> @@ -265,26 +285,39 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
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
> +	u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
> +		IMA_MAX_DIGEST_SIZE] = { 0 };

Hi Mimi,

Shouldn't this contains an additional ":", Thus should +1 again?

>   	enum data_formats fmt = DATA_FMT_DIGEST;
>   	u32 offset = 0;
>   
> -	if (hash_algo < HASH_ALGO__LAST) {
> -		fmt = DATA_FMT_DIGEST_WITH_ALGO;
> -		offset += snprintf(buffer, CRYPTO_MAX_ALG_NAME + 1, "%s",
> +	if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
> +		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> +		offset += snprintf(buffer, DIGEST_TYPE_NAME_LEN_MAX +
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
> @@ -359,7 +392,8 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
>   	cur_digestsize = hash.hdr.length;
>   out:
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   HASH_ALGO__LAST, field_data);
> +					   DIGEST_TYPE__LAST, HASH_ALGO__LAST,
> +					   field_data);
>   }
>   
>   /*
> @@ -380,7 +414,32 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   	hash_algo = event_data->iint->ima_hash->algo;
>   out:
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   hash_algo, field_data);
> +					   DIGEST_TYPE__LAST, hash_algo,
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
> +	u8 digest_type = DIGEST_TYPE_IMA;
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
> +					   digest_type, hash_algo,
> +					   field_data);
>   }
>   
>   /*
> @@ -415,7 +474,8 @@ int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
>   	}
>   
>   	return ima_eventdigest_init_common(cur_digest, cur_digestsize,
> -					   hash_algo, field_data);
> +					   DIGEST_TYPE__LAST, hash_algo,
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


-- 
Best
GUO Zihua
