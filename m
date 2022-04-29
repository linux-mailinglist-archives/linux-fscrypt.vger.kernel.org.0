Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD32D515070
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355204AbiD2QMn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 12:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235285AbiD2QMm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 12:12:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B5DD64D6;
        Fri, 29 Apr 2022 09:09:23 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TG1ZIc012437;
        Fri, 29 Apr 2022 16:09:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=/gKjBJm8Ng3Z02hjWqZNYdcaPfpsNP9MRodWRR1hczA=;
 b=Q+UZ/hkalq8vv58S8ODxArExXt67Lvi6li3uewqdxXvWfi1eoiBW7R9RpPekEPbiSSu+
 mGDqZXQf1jZs/rsYO0Nw5g71A/kNUTtdCVtnjs61/xmlFTY3nbJtcjUoIL+2iiyTjG5g
 6WeTcfZ5iSCnhq5xf6ijRY1qCBWYS7EJ+3E6mWUpuoIhk80/7+23GLK8tsRJYr3eoJHK
 CzrmvXZ+DNibaQZgrL7I/NtNUMEiYujkQvmpS7ONTtrhWBlQYFBrACvqVwgZNCLRwtSv
 ftqrbsPQvztFtvQ20V41/dQLEs5U3xo6eT0ysYmwvEOBn6Z54Zcap3IlFkqHYnuPGL/K Cw== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqt9ee8rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 16:09:19 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23TFwmkM006777;
        Fri, 29 Apr 2022 16:09:17 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01dal.us.ibm.com with ESMTP id 3fm93bdetw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 16:09:17 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23TG9GDd36897136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 16:09:16 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83FE16A04F;
        Fri, 29 Apr 2022 16:09:16 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28E526A047;
        Fri, 29 Apr 2022 16:09:16 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 16:09:16 +0000 (GMT)
Message-ID: <20697475-1b31-4db7-d1e7-afe2d50e2bca@linux.ibm.com>
Date:   Fri, 29 Apr 2022 12:09:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 2/7] ima: use IMA default hash algorithm for integrity
 violations
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-3-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-3-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Hx2U6jPwJesozZKWDNHUMPP0zmbRsYgK
X-Proofpoint-ORIG-GUID: Hx2U6jPwJesozZKWDNHUMPP0zmbRsYgK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_07,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290085
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:25, Mimi Zohar wrote:
> Integrity file violations - ToM/ToU, open writers - are recorded in the IMA
> measurement list, containing 0x00's in both the template data and file data
> hash fields, but 0xFF's are actually extended into TPM PCRs.  Although the
> original 'ima' template data field ('d') is limited to 20 bytes, the 'd-ng'
> template digest field is not.
> 
> The violation file data hash template field ('d-ng') is unnecessarily hard
> coded to SHA1.  Instead of simply replacing the hard coded SHA1 hash
> algorithm with a larger hash algorithm, use the hash algorithm as defined
> in "ima_hash_algo".  ima_hash_algo is set to either the Kconfig IMA default
> hash algorithm or as defined on the boot command line (ima_hash=).
> 
> Including a non-SHA1 file data hash algorithm in the 'd-ng' field of
> violations is a cosmetic change.  The template data hash field, which is
> extended into the TPM PCRs, is not affected by this change and should not
> affect attestation of the IMA measurement list.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

The effect seems to be that violations that have previously looked like 
this

10 0000000000000000000000000000000000000000 ima-ng 
sha1:0000000000000000000000000000000000000000 /var/log/audit/audit.log

now look like this:

10 0000000000000000000000000000000000000000 ima-ng 
sha256:0000000000000000000000000000000000000000 /var/log/audit/audit.log

evmctl [1.3.2] still works fine:

# evmctl ima_measurement --ignore-violations 
/sys/kernel/security/ima/binary_runtime_measurements
Matched per TPM bank calculated digest(s).


Tested-by: Stefan Berger <stefanb@linux.ibm.com>


> ---
>   security/integrity/ima/ima_template_lib.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_template_lib.c b/security/integrity/ima/ima_template_lib.c
> index e9d65f6fe2ae..4b6706f864d4 100644
> --- a/security/integrity/ima/ima_template_lib.c
> +++ b/security/integrity/ima/ima_template_lib.c
> @@ -370,7 +370,7 @@ int ima_eventdigest_init(struct ima_event_data *event_data,
>   int ima_eventdigest_ng_init(struct ima_event_data *event_data,
>   			    struct ima_field_data *field_data)
>   {
> -	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
> +	u8 *cur_digest = NULL, hash_algo = ima_hash_algo;
>   	u32 cur_digestsize = 0;
>   
>   	if (event_data->violation)	/* recording a violation. */
