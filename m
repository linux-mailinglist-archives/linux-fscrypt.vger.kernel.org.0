Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A26515117
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 18:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378816AbiD2QsQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 12:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354902AbiD2QsQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 12:48:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FDAD5566;
        Fri, 29 Apr 2022 09:44:57 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TESPen012627;
        Fri, 29 Apr 2022 16:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QwF7BRLgXcAp6rxGlvF1Bt9zQfFMAH6yUW5UlZkEXe8=;
 b=a655I37ABdW5yJKoqotzKLKsGhwTXUgkb6LYZcwqFGJ1730sA02QdcnO+Ny34Skpik+T
 d175B721R1xEN+LEctibvlGq6Rxa5ulig7oQxBRNGZf4GDALZRqP/nua5ukRVOdOrODe
 pVXl0o4bh6NJv2kBFBRsAnN6oBU0/ujZkK2RAr4v8/rXdxdijjMov15zq2mNIjpKfzwA
 skRXJzaDLzQWvYTDv8sIF3bNkYi8LnSbiTpin0pQuDbYX/awIJoVuluJf7NmL4fOvhE2
 iqH34ZnCcZPLwtfcSDBKGO35Hgg+9s6nNV3vY/JCYcBolBz+0UlRcJviTG2xZUYMmd/D XA== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fr27h501d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 16:44:52 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TGYeNC030942;
        Fri, 29 Apr 2022 16:44:42 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3fm93awkdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 16:44:42 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TGigsD34144694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 16:44:42 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CE092805C;
        Fri, 29 Apr 2022 16:44:42 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC8EE2805A;
        Fri, 29 Apr 2022 16:44:41 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 16:44:41 +0000 (GMT)
Message-ID: <ebe1f760-7831-e627-299a-c6a22f4bc5fb@linux.ibm.com>
Date:   Fri, 29 Apr 2022 12:44:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 1/7] ima: fix 'd-ng' comments and documentation
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-2-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-2-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4dSa4AnNfA8xTzjFu8rIkue2jPV7Gv0r
X-Proofpoint-GUID: 4dSa4AnNfA8xTzjFu8rIkue2jPV7Gv0r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_08,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290086
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:25, Mimi Zohar wrote:
> Initially the 'd-ng' template field did not prefix the digest with either
> "md5" or "sha1" hash algorithms.  Prior to being upstreamed this changed,
> but the comments and documentation were not updated.  Fix the comments
> and documentation.
> 
> Fixes: 4d7aeee73f53 ("ima: define new template ima-ng and template fields d-ng and n-ng")
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   Documentation/security/IMA-templates.rst  | 3 +--
>   security/integrity/ima/ima_template_lib.c | 8 +++++---
>   2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> index 1a91d92950a7..cab97f49971d 100644
> --- a/Documentation/security/IMA-templates.rst
> +++ b/Documentation/security/IMA-templates.rst
> @@ -66,8 +66,7 @@ descriptors by adding their identifier to the format string
>      calculated with the SHA1 or MD5 hash algorithm;
>    - 'n': the name of the event (i.e. the file name), with size up to 255 bytes;
>    - 'd-ng': the digest of the event, calculated with an arbitrary hash
> -   algorithm (field format: [<hash algo>:]digest, where the digest
> -   prefix is shown only if the hash algorithm is not SHA1 or MD5);

That seemed to be true for 'd'

> +   algorithm (field format: <hash algo>:digest);
>    - 'd-modsig': the digest of the event without the appended modsig;
>    - 'n-ng': the name of the event, without size limitations;
>    - 'sig': the file signature, or the EVM portable signature if the file
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index 7155d17a3b75..e9d65f6fe2ae 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -271,9 +271,11 @@ static int ima_eventdigest_init_common(const u8 *digest, u32 digestsize,
>   	/*
>   	 * digest formats:
>   	 *  - DATA_FMT_DIGEST: digest
> -	 *  - DATA_FMT_DIGEST_WITH_ALGO: [<hash algo>] + ':' + '\0' + digest,
> -	 *    where <hash algo> is provided if the hash algorithm is not
> -	 *    SHA1 or MD5
> +	 *  - DATA_FMT_DIGEST_WITH_ALGO: <hash algo> + ':' + '\0' + digest, > +	 *
> +	 *    where 'DATA_FMT_DIGEST' is the original digest format ('d')
> +	 *      with a hash size limitation of 20 bytes,
> +	 *    where <hash algo> is the hash_algo_name[] string.
>   	 */
>   	u8 buffer[CRYPTO_MAX_ALG_NAME + 2 + IMA_MAX_DIGEST_SIZE] = { 0 };
>   	enum data_formats fmt = DATA_FMT_DIGEST;

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
