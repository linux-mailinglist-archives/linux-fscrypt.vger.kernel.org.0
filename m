Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD6A51C5DC
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 May 2022 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382530AbiEERQe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 May 2022 13:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382531AbiEERQb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 May 2022 13:16:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890585C877;
        Thu,  5 May 2022 10:12:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245GVK9C030921;
        Thu, 5 May 2022 17:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Oy7utAOsTBky6zMG1vAj2bVPZkz4VO9zEgBvUU2VdDQ=;
 b=lAy9ZJqOldS9XMxA/dIyKG0AyKKhtj5XKYe0LxkMUbKH5MMEJwUFijo8mSfAQNXlfMYN
 TCXwkpgffEN6GWEQB8+eFcOvE68cdhTwE69cR6JPqNCgQUMV5Cmxd2/3HbJ0XbfotXWg
 X/xnh5QpQxA47lZpqcGhHXgNGUZQUFCcA/iD0F4RQR6NkBg9vnhxBaJz/vc58dh3Mh4Y
 Uin1Q68W4IglqcoGI5Z8d2itlKv8BYHf63IVYph5VpzOBcLYevWjI8sYtD3AHO4Cdcqi
 3q6TtXksGqTh4NL0TobxcH37Rn80PYHgJtaeih4sz2TQikdi393FBnDeplku/4TjHtJL 1w== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvj630u09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 17:12:43 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245H2Pb6017022;
        Thu, 5 May 2022 17:12:42 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01wdc.us.ibm.com with ESMTP id 3frvr9u0as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 17:12:41 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245HCfOp29163976
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 17:12:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2574EBE058;
        Thu,  5 May 2022 17:12:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5010BE051;
        Thu,  5 May 2022 17:12:40 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 17:12:40 +0000 (GMT)
Message-ID: <ae5889bc-f5aa-6d0a-fdce-81819a15d22c@linux.ibm.com>
Date:   Thu, 5 May 2022 13:12:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v9 6/7] ima: support fs-verity file digest based version 3
 signatures
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220505123141.1599622-1-zohar@linux.ibm.com>
 <20220505123141.1599622-7-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220505123141.1599622-7-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: coOlU9zrGOKZpJOhXPb5K8YTp8hsJ5pa
X-Proofpoint-GUID: coOlU9zrGOKZpJOhXPb5K8YTp8hsJ5pa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=905 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050118
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 5/5/22 08:31, Mimi Zohar wrote:
> IMA may verify a file's integrity against a "good" value stored in the
> 'security.ima' xattr or as an appended signature, based on policy.  When
> the "good value" is stored in the xattr, the xattr may contain a file
> hash or signature.  In either case, the "good" value is preceded by a
> header.  The first byte of the xattr header indicates the type of data
> - hash, signature - stored in the xattr.  To support storing fs-verity
> signatures in the 'security.ima' xattr requires further differentiating
> the fs-verity signature from the existing IMA signature.
> 
> In addition the signatures stored in 'security.ima' xattr, need to be
> disambiguated.  Instead of directly signing the fs-verity digest, a new
> signature format version 3 is defined as the hash of the ima_file_id
> structure, which identifies the type of signature and the digest.
> 
> The IMA policy defines "which" files are to be measured, verified, and/or
> audited.  For those files being verified, the policy rules indicate "how"
> the file should be verified.  For example to require a file be signed,
> the appraise policy rule must include the 'appraise_type' option.
> 
> 	appraise_type:= [imasig] | [imasig|modsig] | [sigv3]
>             where 'imasig' is the original or signature format v2 (default),
>             where 'modsig' is an appended signature,
>             where 'sigv3' is the signature format v3.
> 
> The policy rule must also indicate the type of digest, if not the IMA
> default, by first specifying the digest type:
> 
> 	digest_type:= [verity]
> 
> The following policy rule requires fsverity signatures.  The rule may be
> constrained, for example based on a fsuuid or LSM label.
> 
>        appraise func=BPRM_CHECK digest_type=verity appraise_type=sigv3
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

Acked-by: Stefan Berger <stefanb@linux.ibm.com>
