Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C51234C59
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 22:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgGaUho (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 16:37:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13890 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726915AbgGaUhn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 16:37:43 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VKYx2j003772;
        Fri, 31 Jul 2020 13:37:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=MNHrNHWzW0ONqnLuth8qU78rUUoTztVczFcUa5LpLrs=;
 b=TElTQdBg/XzPuogc+lHEKlbEgajUCubAsB7fNEnU4Y2t1Pecku5jiGO9Sxr0/BM38jen
 ZqOU6QkB0z5VoRGdo5xrsxavUZRMaitUGnUoQkEqInjxPwk4eGGn/qi8bL7x0rTLeHz1
 lO7d+wOAAC5W7onI1f8COwKOtt/auUZM+/o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32m01cqfad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 31 Jul 2020 13:37:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 13:37:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvLzJ1hAEXIoO3gxkp8hrNS4LtnIfIpZ3h1/1AMr7zjc9Fwnook6b6M8BBSRyAbr5vmLkk4/WlLqYyNxJuboLa7DNPn2zM2WMQ/PQnLJb1lqCk1gKH2pVnPrT333VGenL73UMz7eEzev+ediLBeVymCFCiiY2ByPxlUHbE1aTBO6aBQYienCQLfvbNfpYmvFhkqa/Ta0hOHgWcUOzGq6lzsFK2gWbrxkgFzU9Mzmv9Zwc9ZGPvpFMX8+miv5vts9q3yRHUcFfFMpt/JOIECZRkR4Q84Xwu/EhCgsZQPA0jwCQ0mZpnque08NU5cjSnCJHkyTKQZnOu3iFbrB4knZow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNHrNHWzW0ONqnLuth8qU78rUUoTztVczFcUa5LpLrs=;
 b=Ecaq0KQsCB9lQ2Z0cclAiaSlrEPVoQw8rua+ooF8p77GsmZQYrdwusOBfLHttAc1yy5LKMmrqFhXzx1qIyxAPg+8mMSEhBdT5yB9LEbp05VMxIJlmjw4Jaz8bnkC+sAFZXaKhMtspFRQ/mhWdZzBg6BeyhhI3Kk9hl+MHCxNcbwPzCh9jfBnSjm2oYRbSX/Tcx4m4i/e9DBynyIL35GTI0y5lVaTTipq/BXixd+3ttIEUznoJJKRPTFS1Xb5ns5lroeRKHLLOwsF6WlQlzxZvYL3YIG1pOx4KH3m0PCkQQDBbuzt3ZxeDIV2CQIBIjTQ6QwlYqdWZG2zj0LBnsewag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNHrNHWzW0ONqnLuth8qU78rUUoTztVczFcUa5LpLrs=;
 b=jTjbAjXi5JDJsKbpnKbkETwg32+yFe3MIysU4nz59B3ICAOxfqfKAfneePcuKOZDkBJDcbAxPA1qr+vYl6ipFROxfxo6XdAzdcQL4KkjmRG6UUvdlprZLEp9XavxSMjKZkqd9RZf1HJE8Prl6vwGsBusijEXhiDqiu9cHLfWFR8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3276.namprd15.prod.outlook.com (2603:10b6:5:169::30)
 by DM6PR15MB3162.namprd15.prod.outlook.com (2603:10b6:5:163::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Fri, 31 Jul
 2020 20:37:35 +0000
Received: from DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::d12f:743:361e:744c]) by DM6PR15MB3276.namprd15.prod.outlook.com
 ([fe80::d12f:743:361e:744c%5]) with mapi id 15.20.3216.033; Fri, 31 Jul 2020
 20:37:35 +0000
Subject: Re: [fsverity-utils PATCH] Switch to MIT license
To:     Eric Biggers <ebiggers@kernel.org>, <linux-fscrypt@vger.kernel.org>
CC:     Jes Sorensen <jes.sorensen@gmail.com>, Chris Mason <clm@fb.com>,
        <kernel-team@fb.com>, Victor Hsieh <victorhsieh@google.com>
References: <20200731191156.22602-1-ebiggers@kernel.org>
From:   Jes Sorensen <jsorensen@fb.com>
Message-ID: <b55d6efd-0f2c-e63b-1074-e7ffedd56964@fb.com>
Date:   Fri, 31 Jul 2020 16:37:33 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <20200731191156.22602-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:208:23b::8) To DM6PR15MB3276.namprd15.prod.outlook.com
 (2603:10b6:5:169::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e1::10da] (2620:10d:c091:480::1:4a2) by MN2PR11CA0003.namprd11.prod.outlook.com (2603:10b6:208:23b::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 20:37:34 +0000
X-Originating-IP: [2620:10d:c091:480::1:4a2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fda674e5-0448-4567-7e85-08d835918e8f
X-MS-TrafficTypeDiagnostic: DM6PR15MB3162:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3162B45F873B7B59F0C616E7C64E0@DM6PR15MB3162.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NSZpmwommRRvNIHKmZhkhZVpHl3QMJ9WdKXQsnf47I767AHHZhfQZnAcYrQwCR95vktt4nEzYUX7ts/9MmIjkchuxZNZSwxXGWnFuq3DCl28Yr7PF71ZuJr1NmYVqDqPxQhqCgQpwkawaDQGDmnnTUyCVanfCzfRsNPxTib1dzFqqWT9/phoYbUU2pc40km2Q/ZjmKBzR/UwXeirqYpDSRwmd8W05vLec4SqXgfC2S6goNjcrGggRZG7ob8gWqZ329lGGRYAB5t/TkicmiMj4/hIcYFvsPmSzEeRJWgO2GCP4jSu2y75AVH1zizKPewc9ald67dUFusEmmQG88WEVsC25qpGc258fC9fUZ4Tj3XvjuBchUJfMLs9aXf8MeDAva+QdLkyUjeajcKPOeMRrMhyrw1wrwqn8O2P1ZLfvnz9AjCg7YYl0tBLcbecVjpqX90js70CwgabJ3KJAhLGDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3276.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(366004)(346002)(396003)(39860400002)(376002)(8676002)(966005)(54906003)(316002)(4326008)(478600001)(8936002)(52116002)(66946007)(53546011)(66476007)(2906002)(66556008)(36756003)(31686004)(6486002)(5660300002)(86362001)(2616005)(31696002)(186003)(4744005)(16526019)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eYxAsi6Mnid039apf74aRYTTaTQdCKZ0geHuGQLSYc1cZdGZjAAFNzJwkOzp3DvuD8RWkYo2XQJm+0KDmSjte5ZSZyu1e/RQwGRwGAs7vr4nYXfkyaFw/xbxMra1/FJlkxJLnIbxfQ+Ngb1qg/svg0QDCIdmKXXbVGzgp1YqjsMH9YodtEMZDrnzlTkWVQ1uf85p3eu8ShRu3hdjU0OSrxmSQI5YIjKjtNfbOEj0BGoz/ksxAoaNvrNp+6QhAz9jweyYmIyyY0l9nfIeoy3BGly4ZTMZzZVANQUVlfWmnDl6DHVGvF7fY56yn649Rz+R+pBSnG2IJOVuuWXOY6ljh5tEnBCVHPeXD1F8fuzajvuvqT4UbOFNYE5mSooyZHMGXYpnjCmBqpmAEDZCd3I55lCMNYVOi6Nx+JlFTb4MLJyb/BXbDge37EpS8RkXgvfQjS7Jr5WecB6qhf/hOFl/umd/xZAao4zihzAIrTYhpuAmOX44wRBIMG8nEFJ80tdNOwiH1GxyEmBWqRPWasCfdQIeHXuE2vF2lzoRsbiUX46HS3ITFZKXt9nQxYBh31ogEgfgCr4j5OrmVZP4hVFouwUR7txRTlU0Ch4WnSg/VLCuD/FgO4WZF1SmgF1+XZLz2GKW0Vq0L5WLL2oezXm4cGAf1naJPA9BK1SXM6bGvZk=
X-MS-Exchange-CrossTenant-Network-Message-Id: fda674e5-0448-4567-7e85-08d835918e8f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3276.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 20:37:35.3322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LTbzQSkED+Bq+gfnonH3DB+sBT8/gXUizYXX+Xynzr8Q/Kb2Vycjf9Kd59T05U3dBDifxS5ZFS3APSJ2H7Vzow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3162
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_08:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=971
 phishscore=0 clxscore=1011 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007310147
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 7/31/20 3:11 PM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This allows libfsverity to be used by software with other common
> licenses, e.g. LGPL, MIT, BSD, and Apache 2.0.  It also avoids the
> incompatibility that some people perceive between OpenSSL and the GPL.
> 
> See discussion at
> https://lkml.kernel.org/linux-fscrypt/20200211000037.189180-1-Jes.Sorensen@gmail.com/T/#u
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Acked-by: Jes Sorensen <jsorensen@fb.com>


