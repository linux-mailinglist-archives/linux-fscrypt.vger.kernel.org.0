Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCA4E3201
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Mar 2022 21:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbiCUUsb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Mar 2022 16:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiCUUsa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Mar 2022 16:48:30 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D381FA62;
        Mon, 21 Mar 2022 13:47:03 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LKEF26021728;
        Mon, 21 Mar 2022 20:47:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=bznLJJ5ayLawwKnAkuI141uK+6PE06H2Vvww5acbFf4=;
 b=sRArNvkvwHtXMG3RTPAjXpL/iNqmAMYaOGdF+FS0z4bMdvmzo/JkudWtdKRb10zQcdcx
 +M+bn7+wALuXS3kh2Caxkz8ZFSjBcwiPWFtDB2ksvEADy7uaw//vBaRXdr1uYAOjOoGH
 cRwbRCljyhPwX1lJRvCNkuOJ8sITACTzejH+x8RtDyFwEyfw5Oa381Gz0GmdCi20IBNH
 //85eOQCDnyhZaw3cezLc8FB1eoa90C7tBQK5V9Q0+XuQty0sIpEIgzo3O1o1w14pWCr
 WGbryzJmz032OdapEgm+MpPjjI2B4oLF2tn+1PszI5CW81kYHAMUYHYf6hnijgqUZUCT Rw== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exreruk3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 20:47:00 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LKfEbe014430;
        Mon, 21 Mar 2022 20:47:00 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 3ew6t9un1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 20:47:00 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LKkw0V24772972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 20:46:58 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA637B2070;
        Mon, 21 Mar 2022 20:46:57 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B31AFB2067;
        Mon, 21 Mar 2022 20:46:57 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 20:46:57 +0000 (GMT)
Message-ID: <ed3ea52c-a59f-358c-4753-125225bc39f2@linux.ibm.com>
Date:   Mon, 21 Mar 2022 16:46:57 -0400
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
 <b19eca12-3ae1-a8a5-fcfd-a22b5ee9319c@linux.ibm.com>
 <31254e743b73a43f6f27679678318d0d8744a355.camel@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <31254e743b73a43f6f27679678318d0d8744a355.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XxZN493bfNzK4rMSDrtCexZHrsHNxzyb
X-Proofpoint-GUID: XxZN493bfNzK4rMSDrtCexZHrsHNxzyb
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_08,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=892
 malwarescore=0 impostorscore=0 suspectscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210130
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 3/21/22 15:48, Mimi Zohar wrote:
> On Mon, 2022-03-21 at 08:53 -0400, Stefan Berger wrote:

>>> +
>>> +/*
>>> + * This function writes the digest of an event (without size limit),
>>> + * prefixed with both the hash type and algorithm.
>>> + */
>>> +int ima_eventdigest_ngv2_init(struct ima_event_data *event_data,
>>> +			      struct ima_field_data *field_data)
>>> +{
>>> +	u8 *cur_digest = NULL, hash_algo = HASH_ALGO_SHA1;
>>> +	u32 cur_digestsize = 0;
>>> +	u8 digest_type = 0;
>>
>> What does '0' mean? I think this should definitely be an enum or at
>> least #define.
> 
> The first element of the array is "ima".  Should I define two macros
> similar to kernel_read_file_id and kernel_read_file_str for just two
> strings?

I would introduce an enum like enum hash_algo: 
https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/hash_info.h#L38

And an array like hash_algo_name: 
https://elixir.bootlin.com/linux/latest/source/crypto/hash_info.c#L12


> 
> thanks,
> 
> Mimi
> 
