Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEBD4B1A55
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Feb 2022 01:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiBKAUt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Feb 2022 19:20:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240966AbiBKAUs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Feb 2022 19:20:48 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6962C7;
        Thu, 10 Feb 2022 16:20:48 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21ALpFdd021812;
        Fri, 11 Feb 2022 00:20:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=EBGSsOWS/PPAqu6i6+6YCHl6NifmZUaWgBhLauUDJzQ=;
 b=URgRZOKIFcLRQ+oc//YKMpeWhHDcGUDXFubsZiF1dNaoA4nwPpVn6mPEC8Wg/lrRh1G5
 NZGkEbrIR7a1S/veWIzqukctRnwLod2Py44S1/0C/REVmqevqsCjYgFQurDzujtEdOeq
 9yYKeypEsPahE4ZHAgwQVYw7yHI8XzF5M+D74kimK5hdw+xcxoaHT0Hng4FVFKZy1WzU
 5kC11a45TvJeqoqn0xXenszx+nBS9pM2FjC+Lg1wZeeAML+AsII/GuJcJMjd0qJ9Yj6q
 /PViGTEwcxIwBneBLQO1mhH8j+icUa/TZQG5ECmyoeJg/njAS2Yk2cNkuNjT+ItQycUy Kg== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e50hj26vd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 00:20:45 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21B0DTu7008631;
        Fri, 11 Feb 2022 00:20:44 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gva32rc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 00:20:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21B0Kf6K29295052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 00:20:41 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 313DC52051;
        Fri, 11 Feb 2022 00:20:41 +0000 (GMT)
Received: from sig-9-65-92-50.ibm.com (unknown [9.65.92.50])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 239C752050;
        Fri, 11 Feb 2022 00:20:40 +0000 (GMT)
Message-ID: <ea2a11b0b55ee34c7edc16f32928a81f21be461f.camel@linux.ibm.com>
Subject: Re: [PATCH v4 7/8] ima: support fs-verity file digest based version
 3 signatures
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 10 Feb 2022 19:20:37 -0500
In-Reply-To: <20220208014140.483447-8-zohar@linux.ibm.com>
References: <20220208014140.483447-1-zohar@linux.ibm.com>
         <20220208014140.483447-8-zohar@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9n7eW2Sk8_o682RKH0HAk_FiOKGmzI0T
X-Proofpoint-ORIG-GUID: 9n7eW2Sk8_o682RKH0HAk_FiOKGmzI0T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_11,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-02-07 at 20:41 -0500, Mimi Zohar wrote:
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 28aca1f9633b..576cbe790e27 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -1728,10 +1728,13 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>                         break;
>                 case Opt_digest_type:
>                         ima_log_string(ab, "digest_type", args[0].from);
> -                       if ((strcmp(args[0].from, "verity")) == 0)
> +                       if ((strcmp(args[0].from, "verity")) == 0) {
>                                 entry->flags |= IMA_VERITY_REQUIRED;
> -                       else
> +                               if (entry->action == APPRAISE)
> +                                       entry->flags |= IMA_DIGSIG_REQUIRED;

Instead of overloading the "digest_type=verity" to require a signature,
extend the existing "appraise_type" to support signature v3 (e.g.
appraise_type=sigv3).  This will simplify IMA signature v3 support in
the future.

> +                       } else {
>                                 result = -EINVAL;
> +                       }
>                         break;
>                 case Opt_appraise_type:
>                         ima_log_string(ab, "appraise_type", args[0].from);
> 

-- 
thanks,

Mimi

