Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 604F44B5B74
	for <lists+linux-fscrypt@lfdr.de>; Mon, 14 Feb 2022 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiBNUs5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 15:48:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiBNUsw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 15:48:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBCA15FC87;
        Mon, 14 Feb 2022 12:48:27 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EI7w7w001562;
        Mon, 14 Feb 2022 20:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1pJI+ix99l7/rXF96NBURmzsCZLTmUmqrMwjJzasCG0=;
 b=C1bDcPyd47Ps/ucOG0vzZZpw5wLQNfRu9sAxsPUbwxdePlL5ZkHNCxdbhF+EIrTTAyQJ
 yvjHEpil9pDYbMXNK0cZRzdetM4rd0d0WqTJYQZYgYfGUgWIUNn4DitSdmVC5jcPuCt3
 OxXom30rXLMQmCjz0njRmfHtQejZNzpgdq1VR0l5vI34uMtRlAq4oNu5M4qlOW1p6GUP
 KFiAkN6grVpTsMIV9keh1B4OkGZhMe2HhuL3LncHVR1L5GjOTjUWJmCdYov0msVCFYvM
 nekfS6NIvX964JtQaR/gbFr3xVhNZwPAJ2YfudrIkq2ydrO6LxSX9kOwJbVZwmGxiYKr dw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e7cje8nr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:03:39 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21EK1rxK027551;
        Mon, 14 Feb 2022 20:03:38 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3e64hahga8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Feb 2022 20:03:38 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21EK3bML28377520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:03:37 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1738528058;
        Mon, 14 Feb 2022 20:03:37 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E579E28060;
        Mon, 14 Feb 2022 20:03:36 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Feb 2022 20:03:36 +0000 (GMT)
Message-ID: <ea619561-fe29-6864-0a07-a49dee8549ab@linux.ibm.com>
Date:   Mon, 14 Feb 2022 15:03:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 1/8] ima: rename IMA_ACTION_FLAGS to
 IMA_NONACTION_FLAGS
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220211214310.119257-1-zohar@linux.ibm.com>
 <20220211214310.119257-2-zohar@linux.ibm.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
In-Reply-To: <20220211214310.119257-2-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T4YCMHvcv5xJtau2XmjWltnHNOqfi_Jo
X-Proofpoint-ORIG-GUID: T4YCMHvcv5xJtau2XmjWltnHNOqfi_Jo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-14_07,2022-02-14_03,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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
> Simple policy rule options, such as fowner, uid, or euid, can be checked
> immediately, while other policy rule options, such as requiring a file
> signature, need to be deferred.
>
> The 'flags' field in the integrity_iint_cache struct contains the policy
> action', 'subaction', and non action/subaction.
>
> action: measure/measured, appraise/appraised, (collect)/collected,
>          audit/audited
> subaction: appraise status for each hook (e.g. file, mmap, bprm, read,
>          creds)
> non action/subaction: deferred policy rule options and state
>
> Rename the IMA_ACTION_FLAGS to IMA_NONACTION_FLAGS.
>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>


