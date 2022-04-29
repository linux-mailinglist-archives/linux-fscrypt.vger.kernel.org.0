Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529D2515284
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Apr 2022 19:43:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379559AbiD2Rqg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Apr 2022 13:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355320AbiD2Rqf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Apr 2022 13:46:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4955939A3;
        Fri, 29 Apr 2022 10:43:16 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23TGGkF3005014;
        Fri, 29 Apr 2022 17:43:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1AZ+KFh/rzC4r2O+HkoiofULh4tefGIG3w3U8CMIGDY=;
 b=RlJATUCivjsHEH2igqJjQ2/vXzL84l6GzfT/UqqXUKsGmL8JZMnk9KIinHfOIeP75Pd5
 yb8Oovgqocptg9viiFLwWT/v0xgofzfU2s/OxA7sqKunk3+AQfhMf62QSLOD3m7kQDf/
 Z7Ox17Hw1xpAmJI3NnxMenPisv8mp55WPzCjZsJjZZetEuQRi/Y+SesIurwoOIiYJoOP
 LNRnSvFe3hRGyuTysgHlQzGYT94ClPeTHpDQRdpLONX3JUN6O18uiNypZFLNDIEQ6cnh
 An0+jBOUCKP6yeiuHm2Fnwkv5MncbpTv/SAc1DenbAu6l+d9cunxZt/dfYBnYVy8CQ1o mA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqu6p9x11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 17:43:13 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23THbmKr006745;
        Fri, 29 Apr 2022 17:43:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3fm93anx4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 17:43:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23THhBAl14418310
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Apr 2022 17:43:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93465BE059;
        Fri, 29 Apr 2022 17:43:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34295BE05D;
        Fri, 29 Apr 2022 17:43:11 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 29 Apr 2022 17:43:11 +0000 (GMT)
Message-ID: <d3f6dad3-3f0a-481d-3067-36c0a4ea279f@linux.ibm.com>
Date:   Fri, 29 Apr 2022 13:42:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v8 7/7] fsverity: update the documentation
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220429112601.1421947-1-zohar@linux.ibm.com>
 <20220429112601.1421947-8-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220429112601.1421947-8-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3IlPq9HPSo5ooC5ZOneflsv1WG9s3ASS
X-Proofpoint-ORIG-GUID: 3IlPq9HPSo5ooC5ZOneflsv1WG9s3ASS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_08,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 mlxlogscore=947 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204290088
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/29/22 07:26, Mimi Zohar wrote:
> Update the fsverity documentation related to IMA signature support.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   Documentation/filesystems/fsverity.rst | 35 +++++++++++++++++---------
>   1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 8cc536d08f51..b7d42fd65e9d 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -70,12 +70,23 @@ must live on a read-write filesystem because they are independently
>   updated and potentially user-installed, so dm-verity cannot be used.
>   
>   The base fs-verity feature is a hashing mechanism only; actually
> -authenticating the files is up to userspace.  However, to meet some
> -users' needs, fs-verity optionally supports a simple signature
> -verification mechanism where users can configure the kernel to require
> -that all fs-verity files be signed by a key loaded into a keyring; see
> -`Built-in signature verification`_.  Support for fs-verity file hashes
> -in IMA (Integrity Measurement Architecture) policies is also planned.
> +authenticating the files may be done by:
> +
> +* Userspace-only
> +
> +* Builtin signature verification + userspace policy
> +
> +  fs-verity optionally supports a simple signature verification
> +  mechanism where users can configure the kernel to require that
> +  all fs-verity files be signed by a key loaded into a keyring;
> +  see `Built-in signature verification`_.
> +
> +* Integrity Measurement Architecture (IMA)
> +
> +  IMA supports including fs-verity file digests and signatures in the
> +  IMA measurement list and verifying fs-verity based file signatures
> +  stored as security.ima xattrs, based on policy.
> +
>   
>   User API
>   ========
> @@ -653,12 +664,12 @@ weren't already directly answered in other parts of this document.
>       hashed and what to do with those hashes, such as log them,
>       authenticate them, or add them to a measurement list.
>   
> -    IMA is planned to support the fs-verity hashing mechanism as an
> -    alternative to doing full file hashes, for people who want the
> -    performance and security benefits of the Merkle tree based hash.
> -    But it doesn't make sense to force all uses of fs-verity to be
> -    through IMA.  As a standalone filesystem feature, fs-verity
> -    already meets many users' needs, and it's testable like other
> +    IMA supports the fs-verity hashing mechanism as an alternative
> +    to full file hashes, for those who want the performance and
> +    security benefits of the Merkle tree based hash.  However, it
> +    doesn't make sense to force all uses of fs-verity to be through
> +    IMA.  fs-verity already meets many users' needs even as a
> +    standalone filesystem feature, and it's testable like other
>       filesystem features e.g. with xfstests.
>   
>   :Q: Isn't fs-verity useless because the attacker can just modify the

Acked-by: Stefan Berger <stefanb@linux.ibm.com>
