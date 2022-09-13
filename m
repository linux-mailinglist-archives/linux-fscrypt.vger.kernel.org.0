Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBE685B6B67
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Sep 2022 12:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiIMKH5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Sep 2022 06:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbiIMKH4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Sep 2022 06:07:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2050520BD;
        Tue, 13 Sep 2022 03:07:50 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28D9DbZg023764;
        Tue, 13 Sep 2022 10:07:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6e/PXZ/3U5aGWXxhvqdm/q3Fkl2eH2VKVOUm0iKWJCw=;
 b=LX4MJ6vKdmqV0Zw2QhfQIbKoMqtdjr3Q0phs+UdReY5GSpkYHmhlVJ+PdWO8LT/EMANv
 EjQ0w+6Sa89roV+U1r0QYiGDOhAvQcSO3rIFomzyBlgK12DTG8J/TzN9trCxt1HHYagS
 ULPfQpKJ95L0lzft3FfdeSNKXMFpJkdW3Sim8eqmPo1j4vdbAUuMlTDnuxr6NCrmBVWf
 bzxOYBg4Es4GDDb5WwClxue6A3TwUHU+nR214+f9jZLvI+aue0pNbbrFvYu21WBMl81U
 Yy8KqqtC+ll08V6BWNRa8pS/XMUhxdG4e1DWQs9UKJhUmhBD7tNwb1Z/ojANe4gIy2k7 IQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jj5w2amek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 10:07:37 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28D8UC3p011269;
        Tue, 13 Sep 2022 10:07:37 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh19tnh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 10:07:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EO/66cEzV91G57cocPrwJNBg8NKNsZ3ZNjPMpJ3sAlXagI+RPBGMDnlhNSqaeL06EpOmwooUmtxB8vJpTHbgPZcLLQUTFkbADSb+bBDhJv9Su+ILvtiUyiHN+63qu84oeJmGacaekZ2kBzGBtDB6NItRZaPIMuUE9HnH004ABDs1fJjlT9OXgN71AqMoZvpMXPYDu/p+t/kR7qppsW40JRHVNUdQGYQ6JYNR5tvb3A/gpihyZX8pXpT4vWbqm1FAr7LOu4XkSE81nU0JnLpGlOoLDwcngidnuF+io8YCLPfsFOIz5TK1bYrBU4s8hAvBboBqwCPjk5dzMsuBZ/HSmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e/PXZ/3U5aGWXxhvqdm/q3Fkl2eH2VKVOUm0iKWJCw=;
 b=Vz7m4YLIONDRgc17SYqgg2ao3WVzk/2cwQwNcxYcvr26qI7AeIzEOu2sFlq7EOHNgpQK3nYrwFvA8068KiZEQlCdBHrv4heXeu7SP2c4tGV8GmxjUhX70UXbSsENUux/tr59WzMrnOxtOuhnV9btXlIFrKskoEaeKbgLOWZq9c+wLtY1jzFjYOF/3GUqvpH6sOS559kL33l7pVwYCN+U8QcKHTXKpamT88aPuWqdvApj/7AUzFkX4Au2RUOVMphjNcUCmGUDmjpdRsNaDaJJn5IbrB0PFxKJaQAjWxSxr7a9mXk/CptD40wF+tQ/4VabZTlcxJcl+2oXj4GssNPEqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6e/PXZ/3U5aGWXxhvqdm/q3Fkl2eH2VKVOUm0iKWJCw=;
 b=l5qft2uuHEF3uRxp5Am8IhfljYyC0kKBgAmTjWbfIFOz1zC4FMEKgotKlq/EgcCZGzGJJtSMX63MwMQ4jai+9pZitV6dZTUYIHGqpqrWvBjTIDakVRlYoAt6KbbUAGAyshBtoq4nIs5BhIboHvuXiXKnh17kxXiLC5oBAYV6WsE=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN2PR10MB4382.namprd10.prod.outlook.com (2603:10b6:208:1d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Tue, 13 Sep
 2022 10:07:34 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::74b2:acd4:6739:716f]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::74b2:acd4:6739:716f%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 10:07:34 +0000
Message-ID: <dbb3a5ea-65d9-12bd-bde3-e16ab2f44adc@oracle.com>
Date:   Tue, 13 Sep 2022 18:07:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted
 directories
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|MN2PR10MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: caff0738-8104-46ce-9a1c-08da956fc719
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zKcVKsvBC5fSRPeMcDKG8VqpO8oAiqIWFPc79kP+9R1fzUcgwdMtEf6UDQRDeniiNcumhi17KPFDH7yauzLqe+8yEBltUabTVyNLPqF+oFZ5WJGYn3Bbq0I4mzMauqhKhQL6OcDKG8V01bI0M/q4x8QP0CumzUGbPOeOhKjGA94gqOCW8uSAQ1UNlKUwD4Hk37e8xccrpmX7PEkocc1S1dUNnWYq7YanZ83BcbdAPqlkHXznz2sxQXgjYjV3D4hWzsmjDuuZn7PWj5C1TBkPlEHqcC/8H3kLjvWeDYYgw0cxWWVLfRvCVHKii7UWyM7SZdMFedpLEOLRVpAwTMG1P4qVrynzFPcmsmc10wf082xEzi8WUUJqK25OjZ9dfcLpy/wxZoFWLF3T2AWf1uhtGUuSIj0M3H/zh+uawjvFeKwpm8UONz9SOj/zRnEnSYfClPUE4cbsUbsk5zypD09mj24BCYf84MAOEhLpJ929oF0ya02yyn6tyRRQfCjxERmPakaLxadd3oPYANIArfxA3gAXxIawZIwfkEeXveKceT/7SRKd79a+PBEjmGPSRDbEOAN1KSK+/0WjvCz8gpxcYfjWXw7lGoWdzkocraULLZEWInkUEqLj4ec/DTmn2vOyaZUV/JDhL7XZUsP9muszb69cc/qSYzkS1SvrmhQfqiDD2VjzJi9Ye3D+uH+ib9NUKl7LRtc84Ui73haVGFaAcK4J5gDsYJST95x2Va2qNM/ZataMee8vlNfopCBu5W0CdazTLeIJcUmSCFi5w5SiAWX4/BxkNPYVKCuyqWlMlr1CXVHGbjcuJVKNm7ug7TGd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(6506007)(316002)(41300700001)(66476007)(53546011)(2616005)(6512007)(36756003)(44832011)(4326008)(66556008)(6486002)(478600001)(186003)(6666004)(7416002)(66946007)(8936002)(110136005)(2906002)(5660300002)(86362001)(31696002)(8676002)(38100700002)(26005)(921005)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlI2VEtlSWVGcFRpTGUxN3owOFJxbk4wd1BJYS9MMUxQUERIcGxZNmJwN3li?=
 =?utf-8?B?cHlBaVF6RzdrZGUvYit3U2hoTGVEcXFuYng5enJZdDQ5SldacFdxWVF6ckpG?=
 =?utf-8?B?OTdBWW9WZGlRK3N3bEpCSHBrWUpsRXo1VUkrbW9ac1M0S0ZxZzJPY2lFdDQz?=
 =?utf-8?B?aWo3QlFRa2VYNnE5VUNlQlc2K2xydG1adnhiRllscld4bkIzUS9SQjQwSndS?=
 =?utf-8?B?TXFXd1I0VjJjQzlPN1NNTEhJOTkrVWF5Z3VXR1FwL1Z4d0ZFcjBrREw5M0J0?=
 =?utf-8?B?SWpnS1locm4yQW9CODJBSFFUSEMvRnZYL3pSaUNRbWRBajdPSU9CUjY2bjFv?=
 =?utf-8?B?NGpUWS9rdUc0ZUxaWGNyMDM1V3AwNDk0blArWWRmbnorK1ZWU0FRUnFLUmxu?=
 =?utf-8?B?d3ZWOUN1a1l2bTl3SmNjTlNzcURZVjJZMy9JTmhuZjlVNWdLVE1HbDJIbG1U?=
 =?utf-8?B?cTBIL1Z4QjRUaGV2ZGNyNk9Ed3pjZ1dOSlptVVJROCtnYWpVN2xHMHdyWGpi?=
 =?utf-8?B?djdRbkVVQXpFWG5MRml6eHlNUGxBRTU3cUZ3WHFiak9yWFRJb2JDdHNPNk9S?=
 =?utf-8?B?RStOemZtZU9VOUFDbjdmZFBFSUJwVHRjamsxd0p4c3U2VEVyN0NRRGpxa3VH?=
 =?utf-8?B?eEdZRmxUYUNoNGJmbUFKWkJLaG9WZmIwNS84c2hVaGRSZGZMMFFhUTJZcndy?=
 =?utf-8?B?TmR1UW1YcGF5eXVrTmlKZG1yY2hwZDBWVERpbEd2WDhOR0M4ZEEvaXRLekRS?=
 =?utf-8?B?cHZXcDFNSlhTdXZZei9PR1FEeG14N3ZUUE5Oa0dhdzloZG5WT2lEQnpudFJB?=
 =?utf-8?B?Y25ZdkxDUkNXRHc4aU1FVXRmcVE1djJiOGFOYmVJU0QzMjIrcTl4RVY1WlFx?=
 =?utf-8?B?aVRQOC9rQVVxZlliZXljVmdTUEg3N1N6Qy9kS3hGQXB2UG9RK3ZwM0xlbms1?=
 =?utf-8?B?Mnh2aTIrRWVRWnJRTm5FTW05aUhDN2pTWld4dDlXVmpLaUExeW1nVXZQZjZm?=
 =?utf-8?B?czVPK3RiSHN1RjMzOGZxT3QyVHBwbWkyS05ESGNIT1BrUzdIZXIwV3hXclk1?=
 =?utf-8?B?aGYxMHU4bjdjdzRLS1diZDJoWWdZUDNDYWdGbnJqMkVjTEowbDNwb1VhTGZZ?=
 =?utf-8?B?ZGJQYVFhVm9EVVc4R25BQlVMMHBDdmladlFURmpEaGEzZ2srYTQweDE5UnI3?=
 =?utf-8?B?L2w4dU1EOU1kcGVuY0xwS1gyekVZZXNKM3JxU1ZhdUEyK1d0MlpORExPY0ho?=
 =?utf-8?B?NkJCbjJTY3dOdzhJUWhvMGVTOW1NMjNhTks0QWdEcVM0TnRRdzFQNHlqRnVl?=
 =?utf-8?B?RzRFNEg3UjV3eHA0UWtmMi9QV0I1VnVBenZQeDl3RGpjcE5sNVEvbzlEL2sv?=
 =?utf-8?B?RStYdHQrSU9xeGJjQWw3ZGhXWVIvNC9CdFVTdWMwbDA2M0dnSlRLSDI2Y0N6?=
 =?utf-8?B?NFpRdEdGMDYzZ3ZsL2orSW5ldHhqRWVGVmMyY3RUS3liWS9Ca2NObnBSTnlB?=
 =?utf-8?B?Y1lEVG11V2FUaDNDZ3A5cjYxNHhEeGRzalAzdzlZQ25GNXRXa0VKbDBrUHQ0?=
 =?utf-8?B?L3VuRGlLZExDMTJuZHFnR09wWHRScDJzRW94eERnVjZGRGJBNzBpNDNKd1dp?=
 =?utf-8?B?dEJTbFBYREt1dENHQVRtSlE4eWNlWXM1RjZYNTFnemZjTUpHN1YrMzU2VnVO?=
 =?utf-8?B?bDNUazg5dFBHazRvUGRTRnBna2pOSnVNSmZuNU9tM1FWNXB5b1FkUGdsdzI3?=
 =?utf-8?B?TGRRSEtTTjg0NnhSdTdvTWJLeno2NXA4RXZyb1pPSXVBSUpETktCVTdZOFV0?=
 =?utf-8?B?bVdOUzlHNkJDRGZSTExKQXJQRGw5QlNUb1gvdGpGa3ZGOHRjV2pYelZQc3J4?=
 =?utf-8?B?dDFFOW1XSVhtQ0RWZmdhQTl0S2h3d3FaVnc5S01FUkxBTjlOM3oxTzI5NjBw?=
 =?utf-8?B?TForVUw4RXpiQ1JZbVcxaE5xa2VhR0NpZFhYZ3VCZE1zOXB4WHBUL29rZmY1?=
 =?utf-8?B?Y3g2SVJ2dzF3cm5NOEdyWVdzMDR6VEJyUyszUklrMEZVVlNPTGgxdnlPZkVD?=
 =?utf-8?B?cnN2bGFyelM1MHdTTlg4TW1xSWRyV0F5dG1sK0RsR0JTMFBQN0xWQytHM25j?=
 =?utf-8?Q?fnUbPu7yjl2TG2qvUQKbVI+ir?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: caff0738-8104-46ce-9a1c-08da956fc719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 10:07:34.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QzXHJmvoy9l1lHQy50dafKP6oIUcCz3de1RaPf4zHCJoGf9E79u/lVzHmvQlyGGCI3Id5KEAwPTxmCwzEbqxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-13_03,2022-09-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130045
X-Proofpoint-GUID: 08SvT9UFOonPu1_4fqFlRwvvfvnm-piI
X-Proofpoint-ORIG-GUID: 08SvT9UFOonPu1_4fqFlRwvvfvnm-piI
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 06/09/2022 08:35, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Creating several new subvolumes out of snapshots of another subvolume,
> each for a different VM's storage, is a important usecase for btrfs.

> We
> would like to give each VM a unique encryption key to use for new writes
> to its subvolume, so that secure deletion of the VM's data is as simple
> as securely deleting the key; to avoid needing multiple keys in each VM,
> we envision the initial subvolume being unencrypted.

In this usecase, you didn't mention if the original subvolume is
encrypted, assuming it is not, so this usecase is the same as mentioned
in the design document. Now, in this usecase, what happens if the
original subvolume is encrypted? Can we still avoid the multiple keys?
How is that going to work? Or we don't yet support subvolumes out of
snapshots of another encrypted subvolume?

Thanks,
-Anand

> However, this means
> that the snapshot's directories would have a mix of encrypted and
> unencrypted files. During lookup with a key, both unencrypted and
> encrypted forms of the desired name must be queried.
> 
> To allow this, add another FS_CFLG to allow filesystems to opt into
> partially encrypted directories.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>   fs/crypto/fname.c       | 17 ++++++++++++++++-
>   include/linux/fscrypt.h |  2 ++
>   2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index 6c092a1533f7..3bdece33e14d 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -414,6 +414,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>   	fname->usr_fname = iname;
>   
>   	if (!IS_ENCRYPTED(dir) || fscrypt_is_dot_dotdot(iname)) {
> +unencrypted:
>   		fname->disk_name.name = (unsigned char *)iname->name;
>   		fname->disk_name.len = iname->len;
>   		return 0;
> @@ -448,8 +449,16 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>   	 * user-supplied name
>   	 */
>   
> -	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED)
> +	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED) {
> +		/*
> +		 * This isn't a valid nokey name, but it could be an unencrypted
> +		 * name if the filesystem allows partially encrypted
> +		 * directories.
> +		 */
> +		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL)
> +			goto unencrypted;
>   		return -ENOENT;
> +	}
>   
>   	fname->crypto_buf.name = kmalloc(FSCRYPT_NOKEY_NAME_MAX, GFP_KERNEL);
>   	if (fname->crypto_buf.name == NULL)
> @@ -460,6 +469,12 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
>   	if (ret < (int)offsetof(struct fscrypt_nokey_name, bytes[1]) ||
>   	    (ret > offsetof(struct fscrypt_nokey_name, sha256) &&
>   	     ret != FSCRYPT_NOKEY_NAME_MAX)) {
> +		/* Again, this could be an unencrypted name. */
> +		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL) {
> +			kfree(fname->crypto_buf.name);
> +			fname->crypto_buf.name = NULL;
> +			goto unencrypted;
> +		}
>   		ret = -ENOENT;
>   		goto errout;
>   	}
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index a236d8c6d0da..a4e00314c91b 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -102,6 +102,8 @@ struct fscrypt_nokey_name {
>    * pages for writes and therefore won't need the fscrypt bounce page pool.
>    */
>   #define FS_CFLG_OWN_PAGES (1U << 1)
> +/* The filesystem allows partially encrypted directories/files. */
> +#define FS_CFLG_ALLOW_PARTIAL (1U << 2)
>   
>   /* Crypto operations for filesystems */
>   struct fscrypt_operations {

