Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68A4514EBA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 17:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377638AbiD2PMa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 11:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377609AbiD2PMa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 11:12:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B22AD4450;
        Fri, 29 Apr 2022 08:09:10 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TF209x006498;
        Fri, 29 Apr 2022 15:09:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nXnPsHhXpKm8qqmbPkjZpTlHaRtF0ZtvBMSv/HUfRUE=;
 b=JzGpUN9kgvgcH0i6sLyuyr0T9yfY3/eI+navoKzI/B26xcjiyxvkkDheQwgVMliuZ/GT
 3DWFuUqhXTWAthL34N0oy3FFkiDXW80AcS+8rYNmcSHbdEX1iaKxghkeGaY+a8ng6r42
 bcyXvTHfPrCjY8HwEev9MZnO3Qo0TogYp2ywAv4SfolMsPyN+a60/cnbgIIefgZ9iVdF
 szxLSsi0zyAbwHMUxdB+wnU+nka+NV2TcOn3h52o5/3EQMUThRstJMu0NQu4K4eORQi8
 9NN89omHmn9+Qd4GDe0M2Ra6PN+fsJZCQQmRl7yxTaDCyE9Cj/XsdLP4md1jzOAVK0qb ag== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqt9ed9gg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 15:09:08 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TEqiHO015190;
        Fri, 29 Apr 2022 15:09:07 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93bd292-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 15:09:07 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TF96AN10223944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 15:09:06 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5149AAC066;
        Fri, 29 Apr 2022 15:09:06 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17E97AC06C;
        Fri, 29 Apr 2022 15:09:06 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 15:09:06 +0000 (GMT)
Message-ID: <026c9596-9ebe-d148-fc5f-442a7e16f48b@linux.ibm.com>
Date:   Fri, 29 Apr 2022 11:09:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 4/7] ima: define a new template field named 'd-ngv2'
 and templates
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-5-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-5-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 7hi85gtDLXvoLMDbGKY3cdtE_k2Naw2W
X-Proofpoint-ORIG-GUID: 7hi85gtDLXvoLMDbGKY3cdtE_k2Naw2W
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290082
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:25, Mimi Zohar wrote:
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
>   Documentation/security/IMA-templates.rst      |  4 +
>   security/integrity/ima/ima_template.c         |  4 +
>   security/integrity/ima/ima_template_lib.c     | 79 ++++++++++++++++---
>   security/integrity/ima/ima_template_lib.h     |  4 +
>   5 files changed, 82 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 3f1cc5e317ed..5e866be89f5d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1903,7 +1903,8 @@
>   
>   	ima_template=	[IMA]
>   			Select one of defined IMA measurements template formats.
> -			Formats: { "ima" | "ima-ng" | "ima-sig" }
> +			Formats: { "ima" | "ima-ng" | "ima-ngv2" | "ima-sig" |
> +				   "ima-sigv2" }
>   			Default: "ima-ng"
>   
>   	ima_template_fmt=
> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index cab97f49971d..eafc4e34f890 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -67,6 +67,8 @@ descriptors by adding their identifier to the format string
>    - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
>    - 'd-ng': the digest of the event, calculated with an arbitrary hash
>      algorithm (field format: <hash algo>:digest);
> + - 'd-ngv2': same as d-ng, but prefixed with the "ima" digest type
> +   (field format: <digest type>:<hash algo>:digest);
>    - 'd-modsig': the digest of the event without the appended modsig;
>    - 'n-ng': the name of the event, without size limitations;
>    - 'sig': the file signature, or the EVM portable signature if the file
> @@ -87,7 +89,9 @@ Below, there is the list of defined template descriptors:
>   
>    - "ima": its format is ``d|n``;
>    - "ima-ng" (default): its format is ``d-ng|n-ng``;
> + - "ima-ngv2": its format is ``d-ngv2|n-ng``;
>    - "ima-sig": its format is ``d-ng|n-ng|sig``;
> + - "ima-sigv2": its format is ``d-ngv2|n-ng|sig``;
>    - "ima-buf": its format is ``d-ng|n-ng|buf``;
>    - "ima-modsig": its format is ``d-ng|n-ng|sig|d-modsig|modsig``;
>    - "evm-sig": its format is ``d-ng|n-ng|evmsig|xattrnames|xattrlengths|xattrvalues|iuid|igid|imode``;
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
> index 4b6706f864d4..ff82e699149c 100644
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

You probably mean 'NUL' ('\0') here: 
https://man7.org/linux/man-pages/man7/ascii.7.html

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
> @@ -265,28 +285,38 @@ int ima_parse_buf(void *bufstartp, void *bufendp, void **bufcurp,
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
>   	 *  - DATA_FMT_DIGEST_WITH_ALGO: <hash algo> + ':' + '\0' + digest,
> +	 *  - DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO:
> +	 *	<digest type> + ':' + <hash algo> + ':' + '\0' + digest,
>   	 *
>   	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
>   	 *      with a hash size limitation of 20 bytes,
> +	 *    where <digest type> is "ima",
>   	 *    where <hash algo> is the hash_algo_name[] string.
>   	 */
> -	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
> +	u8 buffer[DIGEST_TYPE_NAME_LEN_MAX + CRYPTO_MAX_ALG_NAME + 2 +
> +		IMA_MAX_DIGEST_SIZE] = { 0 };
>   	enum data_formats fmt = DATA_FMT_DIGEST;
>   	u32 offset = 0;
>   
> -	if (hash_algo < HASH_ALGO__LAST) {
> +	if (digest_type < DIGEST_TYPE__LAST && hash_algo < HASH_ALGO__LAST) {
> +		fmt = DATA_FMT_DIGEST_WITH_TYPE_AND_ALGO;
> +		offset += 1 + sprintf(buffer, "%*s:%*s:",
> +				      (int)strlen(digest_type_name[digest_type]),
> +				      digest_type_name[digest_type],
> +				      (int)strlen(hash_algo_name[hash_algo]),
> +				      hash_algo_name[hash_algo]);

'%*s' seems to be for right-alignment but only makes sense if the length 
indicator is different than then following string. sprintf(buffer, 
"|%*s|",5,"test") prints | test|. Otherwise it seems to behave like 
plain '%s' in this case... ?
