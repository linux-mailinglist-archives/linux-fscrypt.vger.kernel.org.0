Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8744B5BBC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 14 Feb 2022 22:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiBNUz0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 15:55:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiBNUz0 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 15:55:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEE0FA200;
        Mon, 14 Feb 2022 12:55:05 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EI4XRX026782;
        Mon, 14 Feb 2022 20:38:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=RFRim46dVEX/HWt+vVkSniQsaEJBboiclm7GP8zWmHw=;
 b=VZ0CpleugKrWQbvdpuPtrFjiSelxRc9LWlG0K17Gw4KEeu2Hzt+vL8Ofl0AvqPLPT5y+
 +UV2ueeh1oUrN6uwOUSi2STFbjtq8AgVXVf48A9p9KKqZs9LLTeXL0yZAtFQPX1l3fXb
 bBYhQjzIJPLAMi3fbXj3Pi3LUTOiDfey02p1JJhR6I9Ow1zl4KIhDUPrY1LALmagT2C5
 IwpRABylm6vK4/nXffLId8lV2vyD9sV/bDXm/BEHy+QWnCaBVUBmwkzm+z0TarPrFhSD
 1tyKezr/fgzq8s4yxF2jZn4xK1ka4vxY+Pwba0l3lbGdv33zS+mJ0jlrGhPBFd/9oToM Og== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e79213xs7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:38:31 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EKH5i1005260;
        Mon, 14 Feb 2022 20:38:30 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01wdc.us.ibm.com with ESMTP id 3e64ha8c37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:38:30 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EKcTmI32178632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:38:29 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18B49C6061;
        Mon, 14 Feb 2022 20:38:29 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4107C6057;
        Mon, 14 Feb 2022 20:38:28 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 20:38:28 +0000 (GMT)
Message-ID: <3133af38-4d68-1f69-3610-f87fca640354@linux.ibm.com>
Date:   Mon, 14 Feb 2022 15:38:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 4/8] ima: define a new template field 'd-type' and a
 new template 'ima-ngv2'
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-5-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220211214310.119257-5-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: idWyenUAAO3QKt3lr44-h8I8jxofxECX
X-Proofpoint-ORIG-GUID: idWyenUAAO3QKt3lr44-h8I8jxofxECX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140118
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
> In preparation to differentiate between regular IMA file hashes and
> fs-verity's file digests, define a new template field named 'd-type'.
> Define a new template named 'ima-ngv2', which includes the new 'd-type'
> field.
>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   security/integrity/ima/ima_template.c     |  3 +++
>   security/integrity/ima/ima_template_lib.c | 13 +++++++++++++
>   security/integrity/ima/ima_template_lib.h |  2 ++
>   3 files changed, 18 insertions(+)
>
> diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
> index db1ad6d7a57f..b321342e5bee 100644
> --- a/security/integrity/ima/ima_template.c
> +++ b/security/integrity/ima/ima_template.c
> @@ -19,6 +19,7 @@ enum header_fields { HDR_PCR, HDR_DIGEST, HDR_TEMPLATE_NAME,
>   static struct ima_template_desc builtin_templates[] = {
>   	{.name = IMA_TEMPLATE_IMA_NAME, .fmt = IMA_TEMPLATE_IMA_FMT},
>   	{.name = "ima-ng", .fmt = "d-ng|n-ng"},
> +	{.name = "ima-ngv2", .fmt = "d-ng|n-ng|d-type"},
>   	{.name = "ima-sig", .fmt = "d-ng|n-ng|sig"},
>   	{.name = "ima-buf", .fmt = "d-ng|n-ng|buf"},
>   	{.name = "ima-modsig", .fmt = "d-ng|n-ng|sig|d-modsig|modsig"},
> @@ -40,6 +41,8 @@ static const struct ima_template_field supported_fields[] = {
>   	 .field_show = ima_show_template_digest_ng},
>   	{.field_id = "n-ng", .field_init = ima_eventname_ng_init,
>   	 .field_show = ima_show_template_string},
> +	{.field_id = "d-type", .field_init = ima_eventdigest_type_init,
> +	 .field_show = ima_show_template_string},
>   	{.field_id = "sig", .field_init = ima_eventsig_init,
>   	 .field_show = ima_show_template_sig},
>   	{.field_id = "buf", .field_init = ima_eventbuf_init,
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 7155d17a3b75..a213579e825e 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -383,6 +383,19 @@ int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   					   hash_algo, field_data);
>   }
>   
> +/*
> + * This function writes the digest type of an event.
> + */
> +int ima_eventdigest_type_init(struct ima_event_data *event_data,
> +			      struct ima_field_data *field_data)
> +{
> +	static const char * const digest_type[] = {"ima"};

This array makes sense with 6/8.

Acked-by: Stefan Berger <stefanb@linux.ibm.com>


> +
> +	return ima_write_template_field_data(digest_type[0],
> +					     strlen(digest_type[0]),
> +					     DATA_FMT_STRING, field_data);
> +}
> +
>   /*
>    * This function writes the digest of the file which is expected to match the
>    * digest contained in the file's appended signature.
> diff --git a/security/integrity/ima/ima_template_lib.h b/security/integrity/ima/ima_template_lib.h
> index c71f1de95753..539a5e354925 100644
> --- a/security/integrity/ima/ima_template_lib.h
> +++ b/security/integrity/ima/ima_template_lib.h
> @@ -38,6 +38,8 @@ int ima_eventname_init(struct ima_event_data *event_data,
>   		       struct ima_field_data *field_data);
>   int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   			    struct ima_field_data *field_data);
> +int ima_eventdigest_type_init(struct ima_event_data *event_data,
> +			      struct ima_field_data *field_data);
>   int ima_eventdigest_modsig_init(struct ima_event_data *event_data,
>   				struct ima_field_data *field_data);
>   int ima_eventname_ng_init(struct ima_event_data *event_data,
