Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5093B1B2BE9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2020 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDUQHQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 21 Apr 2020 12:07:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727911AbgDUQHP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 21 Apr 2020 12:07:15 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03LG6BOi006394;
        Tue, 21 Apr 2020 09:07:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4lciBkwE7k852SoR9uH1Dyofnp5TgDdS0zgGj7mJ56Q=;
 b=ZrD+KEcBIuMFHvfrOh4y/i72TsOtyt2LMFI6oO+3xxdfsomf1Kc5msY7XNsBMzeX4E7c
 ZrAzlj4pKHpflpLoFN+rJqnvT9P/0Q3Xn4/k1BUbYFskGDUjEnr+tT5tJBIj2TCLWaHs
 LFD0T4SumNUUiz4HntP5Wv0cyFWwny1GXck= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ghc6bt2y-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 21 Apr 2020 09:07:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 21 Apr 2020 09:07:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TjZy5YIAdb0ebgBBM0lWlRQQYM3jzBlM6vGfJ/LUazaT/+oJIdcsHJBbbvRuPjvw5I2EsXiURgjHxqPOt9ha4pDqGYIFxW/xRQvlPht7hZSOC3C8Zk7vCj7pWEy7sKjitPpDTlVec4bXM0O4rt5OnblWjsDCy7886E5ZbF3GeGwEXH7IYfAluHI+miNC6OaBl7zuCJQtlB6AxVYBAEFKpOjg3OfL3h8hw8bFnmlO46PiwFcTWUNgUq21TnQHLTb3TYORfe3jtAI8AMAQGpwdflmRpKY2aq+z0WhGhIXmJs8ldkQ0Gd8iSDKJprFcc3AAAtCsAbJWVLLcxI2yQxPPZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lciBkwE7k852SoR9uH1Dyofnp5TgDdS0zgGj7mJ56Q=;
 b=JMAXdDcmJ4xa8M/jjWXr+sAHi0u1broyU44CgHa81tc1N0SpdAdaWKer2UqZ6kMZ2VgYbmX/zLAMFCP5gX9OE7Q8aSknzjddGYXOnB5E2rLBPVMn69Kh66jpKeRoLb96bU+KDi0J5rOdwVFfAhoLjReGVqMxbwL/OALqJZgrPd5hHCmOUuznN0UcYABn8yZjsEWAR5JoSUBrGH32efLczdStIn+LoGgdL7ttI+FD7t20n6H6Wr+A0flmpbD7m6wK1PP90gjW3dy3ZHnPN/YkDGlcqSOSLRVN0elgElsbwjP3z6DH1NJ2OURSTaJhZNBxaehGovtOgkuP2CrNJU4rQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lciBkwE7k852SoR9uH1Dyofnp5TgDdS0zgGj7mJ56Q=;
 b=koERENQd7vt136r9AbDsl9csLxDhR3cTJvPloIJxA2QObKfwk7SOg9yX+5PEl1znAnBQRyShbi08w0V8MUkB2mGcX+vdU9zhtHAF2HkhOrJgIx7Odj2YlyFLu7y6PhbzSKkzu1YDcRWfjQGMVINnGt+VWb77OjgXmIbol+4noOc=
Received: from BN8PR15MB3265.namprd15.prod.outlook.com (2603:10b6:408:72::25)
 by BN8PR15MB2948.namprd15.prod.outlook.com (2603:10b6:408:84::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Tue, 21 Apr
 2020 16:07:08 +0000
Received: from BN8PR15MB3265.namprd15.prod.outlook.com
 ([fe80::39b7:dd88:64b:a3db]) by BN8PR15MB3265.namprd15.prod.outlook.com
 ([fe80::39b7:dd88:64b:a3db%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 16:07:08 +0000
Subject: Re: [PATCH 3/9] Move fsverity_descriptor definition to libfsverity.h
To:     Eric Biggers <ebiggers@kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
CC:     <linux-fscrypt@vger.kernel.org>, <kernel-team@fb.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-4-Jes.Sorensen@gmail.com>
 <20200322045722.GC111151@sol.localdomain>
From:   Jes Sorensen <jsorensen@fb.com>
Message-ID: <ebca4865-60e7-c61e-b335-c2962482643b@fb.com>
Date:   Tue, 21 Apr 2020 12:07:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <20200322045722.GC111151@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0025.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::35) To BN8PR15MB3265.namprd15.prod.outlook.com
 (2603:10b6:408:72::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11d1::10c4] (2620:10d:c091:480::1:bf76) by MN2PR07CA0025.namprd07.prod.outlook.com (2603:10b6:208:1a0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Tue, 21 Apr 2020 16:07:08 +0000
X-Originating-IP: [2620:10d:c091:480::1:bf76]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f60d0fe2-aacd-4bc7-b01f-08d7e60e0b00
X-MS-TrafficTypeDiagnostic: BN8PR15MB2948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR15MB294891DAA7EF6E5CC348EC48C6D50@BN8PR15MB2948.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 038002787A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3265.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(39860400002)(366004)(396003)(136003)(346002)(316002)(66946007)(478600001)(186003)(4326008)(110136005)(31696002)(8676002)(36756003)(5660300002)(6486002)(31686004)(2616005)(86362001)(52116002)(16526019)(53546011)(8936002)(2906002)(66556008)(66476007)(81156014);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2dSDOHeGSjuYMr970ih2jm8gBjpZahpHiML4BChnwOKJz8U01fIRWl9Il4RlNPMA834/sGIX9caSNjSnh/NNF1YTKUjLxxwAx95+SoohT+pYATNPdsITJ4lEh0aDcV2A9TCfvfIxPxcaTwC4HF2UWPnR5JnulccJyCkbxXuTWzg0gYU++IRsZz9URg2MPaqe9YDj3O0+awhGTZnQJV5AhFWvpc1rhahxf0B1Ug0mL7BHN+hicGMxGZJBSv0/Jx906/I7ZHGOeVH+xmaRCUJquwOkKa+9RGDS0xiVZN5MWF5hU+Q4uhnyUcwSDoQUoDHr3IgFVABUKjANMiHgEwHzQFPVTbM9f41A6nir1UNM8usfmxCW4YnReiqJiNNugjna3vg+W8TKBaYjP+ul6LVnU7tIvsZVjeteX0/pXBFrqYvhFIKkFjTzRGok+wwWPtVF
X-MS-Exchange-AntiSpam-MessageData: 3DZGAUxu4vEif0YioLjyEhaAHT9boIGs/kH0cVchYU0rcLjFEKUIyMNy5pSit51T53jiSf3lVz+8eRMhiqga07F6NPpRVSd6rrf7bRtbwZF2e2NAEi5wdePO9jcctE/czUtvkXNSmFbxNyw305ban1qZodob9E1aY7/laZZN15P0pc2pGDJUMCNS27rN54T8
X-MS-Exchange-CrossTenant-Network-Message-Id: f60d0fe2-aacd-4bc7-b01f-08d7e60e0b00
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2020 16:07:08.6378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9EL1+jVp6+XA0PZbVDdEEGvOWP3cqnBTPUdWrhTeTZx8egW8RLTlPxiElBtMI74tZLRo/kNZHUN+G5QGrXrfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2948
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_06:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210124
X-FB-Internal: deliver
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/22/20 12:57 AM, Eric Biggers wrote:
> On Thu, Mar 12, 2020 at 05:47:52PM -0400, Jes Sorensen wrote:
>> From: Jes Sorensen <jsorensen@fb.com>
>>
>> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
>> ---
>>  cmd_sign.c    | 19 +------------------
>>  libfsverity.h | 26 +++++++++++++++++++++++++-
>>  2 files changed, 26 insertions(+), 19 deletions(-)
>>
>> diff --git a/cmd_sign.c b/cmd_sign.c
>> index dcc44f8..1792084 100644
>> --- a/cmd_sign.c
>> +++ b/cmd_sign.c
>> @@ -20,26 +20,9 @@
>>  #include <unistd.h>
>>  
>>  #include "commands.h"
>> -#include "fsverity_uapi.h"
>> +#include "libfsverity.h"
>>  #include "hash_algs.h"
>>  
>> -/*
>> - * Merkle tree properties.  The file measurement is the hash of this structure
>> - * excluding the signature and with the sig_size field set to 0.
>> - */
>> -struct fsverity_descriptor {
>> -	__u8 version;		/* must be 1 */
>> -	__u8 hash_algorithm;	/* Merkle tree hash algorithm */
>> -	__u8 log_blocksize;	/* log2 of size of data and tree blocks */
>> -	__u8 salt_size;		/* size of salt in bytes; 0 if none */
>> -	__le32 sig_size;	/* size of signature in bytes; 0 if none */
>> -	__le64 data_size;	/* size of file the Merkle tree is built over */
>> -	__u8 root_hash[64];	/* Merkle tree root hash */
>> -	__u8 salt[32];		/* salt prepended to each hashed block */
>> -	__u8 __reserved[144];	/* must be 0's */
>> -	__u8 signature[];	/* optional PKCS#7 signature */
>> -};
>> -
>>  /*
>>   * Format in which verity file measurements are signed.  This is the same as
>>   * 'struct fsverity_digest', except here some magic bytes are prepended to
>> diff --git a/libfsverity.h b/libfsverity.h
>> index ceebae1..396a6ee 100644
>> --- a/libfsverity.h
>> +++ b/libfsverity.h
>> @@ -13,13 +13,14 @@
>>  
>>  #include <stddef.h>
>>  #include <stdint.h>
>> +#include <linux/types.h>
>>  
>>  #define FS_VERITY_HASH_ALG_SHA256       1
>>  #define FS_VERITY_HASH_ALG_SHA512       2
>>  
>>  struct libfsverity_merkle_tree_params {
>>  	uint16_t version;
>> -	uint16_t hash_algorithm;
>> +	uint16_t hash_algorithm;	/* Matches the digest_algorithm type */
>>  	uint32_t block_size;
>>  	uint32_t salt_size;
>>  	const uint8_t *salt;
>> @@ -27,6 +28,7 @@ struct libfsverity_merkle_tree_params {
>>  };
>>  
>>  struct libfsverity_digest {
>> +	char magic[8];			/* must be "FSVerity" */
>>  	uint16_t digest_algorithm;
>>  	uint16_t digest_size;
>>  	uint8_t digest[];
>> @@ -38,4 +40,26 @@ struct libfsverity_signature_params {
>>  	uint64_t reserved[11];
>>  };
>>  
>> +/*
>> + * Merkle tree properties.  The file measurement is the hash of this structure
>> + * excluding the signature and with the sig_size field set to 0.
>> + */
>> +struct fsverity_descriptor {
>> +	uint8_t version;	/* must be 1 */
>> +	uint8_t hash_algorithm;	/* Merkle tree hash algorithm */
>> +	uint8_t log_blocksize;	/* log2 of size of data and tree blocks */
>> +	uint8_t salt_size;	/* size of salt in bytes; 0 if none */
>> +	__le32 sig_size;	/* size of signature in bytes; 0 if none */
>> +	__le64 data_size;	/* size of file the Merkle tree is built over */
>> +	uint8_t root_hash[64];	/* Merkle tree root hash */
>> +	uint8_t salt[32];	/* salt prepended to each hashed block */
>> +	uint8_t __reserved[144];/* must be 0's */
>> +	uint8_t signature[];	/* optional PKCS#7 signature */
>> +};
>> +
> 
> I thought there was no need for this to be part of the library API?

Hi Eric,

Been busy working on RPM support, but looking at this again now. Given
that the fsverity signature is a hash of the descriptor, I don't see how
we can avoid this?

Cheers,
Jes



