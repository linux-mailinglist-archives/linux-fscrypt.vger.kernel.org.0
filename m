Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1F40426F
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 02:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348778AbhIIA4Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 20:56:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38664 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245152AbhIIA4Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 20:56:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1890oDLp000340
        for <linux-fscrypt@vger.kernel.org>; Wed, 8 Sep 2021 17:55:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=roqpEOVUIlHY1Srp027GUcuz49Kz6nBTxrBZP7SHwMs=;
 b=i7yXUuAUnE/wOtvg/hMwPiRcGbDkI+iscMGfe1H/Jc3wAolKnifOAXDHoJHBU3it6Pqi
 bIeGzovS9kzh/TFKyZoekTFf8JE1tljymhWR2IRjn6jVjIvCxGpZHMfauxVTMvldSBv0
 pUzjV0P3f34nz2HJCL3Js7G0k8QRNLzcjQg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcmw9qyf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Sep 2021 17:55:16 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 8 Sep 2021 17:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuwI1qV2fh4tYgvtNs4tHx5gd80T1yJGfOHSegIfkdfXGjpKFbWmBhIQltbNvY1lFS2Pa6vqgYd3dAWpQLw1NHZB9MWFDU3vOBqm0D/+/LIkL5F5uCvkTS4agCNU1yMTP0pbkKtTu2sBRq2aXYuHK5Ee5uI03N+X83kzH7uA93WLsndPcvi/OVEBEHKx9B7Ac6N7RW1eOzq5gz8QeKa2qds1MWEAQfTmjhyJBDYuTGGI+NnQ6glXTmThr2XsVB69c2QRlsc9Pg0cxheEIVtH6M4tGhPapsZpe38bEL+QChfdREBNSOp9IZL6yDf9wmfO/aRMOoGL9f7ofHFVMmSHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=roqpEOVUIlHY1Srp027GUcuz49Kz6nBTxrBZP7SHwMs=;
 b=ThhVyCZZi8D5acULRsIO25tDdFGDki9ZhBWAr2FXz5YzTjiBfKjlH7p1vJUThUIwgn020HWBkxzX0inducX+9aKtSeSF5wEqAj6l9LDTYcuqLVlbxS1CeuZeO3gxUsnQOE3OgkWfx3jUNu8n2Lj8KQxOXpJr05CpSokQGQqT5W+pPn0ASrKsITi8aDYraX/6fsTy5Y5EB/jcMqFcFcpB+bbmhnRpYnHGDZ6QdfPeaFz32edGv4SBbTAIBu0SyHyNx/EpHe/yawS2M3H7/ROE6WcTGMnqM+NuTmQq0/TPq4Ciyf6KegTWO8MaN5MYXe75VgqrVomDp/d51jmZZpoPng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SA1PR15MB4594.namprd15.prod.outlook.com (2603:10b6:806:19d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:55:07 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 00:55:07 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Topic: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Index: AQHXm6xcGarxStMvPUS3MVkBynObEauaztiAgAAMJniAAAXVAIAABG9LgAAGjACAAAahJQ==
Date:   Thu, 9 Sep 2021 00:55:07 +0000
Message-ID: <SA1PR15MB4824F66E4E8B50D110886832DDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <20210828013037.2250639-1-olo@fb.com> <YTk806ahPPcuz9gl@gmail.com>
 <SA1PR15MB48240CCB6C38535A022ACADBDDD49@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YTlL6Josq+79r/ia@gmail.com>
 <SA1PR15MB48244271F45CF01744C5074EDDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YTlVHtvjuCxsI0DS@gmail.com>
In-Reply-To: <YTlVHtvjuCxsI0DS@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 0dfcd4ca-11df-3e5a-8396-e22457b6c811
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16661ecc-c3f9-4bde-6d54-08d9732c77ae
x-ms-traffictypediagnostic: SA1PR15MB4594:
x-microsoft-antispam-prvs: <SA1PR15MB45943AC240817E3261785EE8DDD59@SA1PR15MB4594.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V8eYiNmUGqzHIrB0Q5sZh2UcF954IkGkM6mOXsfkk0UPQ08drOd2u0BH5wcifF7zlXKcRu1xfLLTR1kDBNePeRetL2RtZp9uoxJyrtAgvbClQOYgP5t8rUFsgtxWVofpt+ZSrfUfmscZxPfypYz4SUa9iMqC9LqwGaOl0aem5cYfSyHAYUKwrtZGgAcfXuW92wNXLFQztuYEjvUhzjS+Vmpwme+jQZ29XsC196HC5L25PkbkgTtCrUugLIrsuDfPEpZCWDWDBa995FwGs47WoxNso2C/NdBgULLo6PH3o2GhIxdw5dfMhL6MpTXEDOFEb1dvkfU2ZXkz36qi8QKoZrW0UZ4rHEcWvBZhtBHib1OGBX9p3gYYHKmCKUFojJsb7WBKpoNceyOYFpNVVnNiEJtoFUfQIzxpNXGXxIlpOw7fnraS42oKECzmF2ZvhkGMtpQNNA7NIDxO/F/e0EWamZUni0cz3lqaK4otLQ9a7H1DKXsbuwpAj5/T9Es1piSXKfyVsBpEuVyPMzzuTKlELfmKt8JVY7GzJ4Q8rKQD+IIuttooCf9jJSCOOyfczLKrUicZs9yIvD2t4JNZp9yl+ID8RaqbPUmH7D2fIqnBOALMpAOh1UjifHMzBKb3aavVf1S0P0cJqMB0DyZBS9dqoQuVgrsJ7w9vJHntL+buNxp1CQe8ngLh9d0UtN4f5ZK05uUfxQ6El7Stqgu/Fjpr0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(2906002)(86362001)(7696005)(6916009)(316002)(76116006)(91956017)(71200400001)(52536014)(38070700005)(4326008)(53546011)(122000001)(38100700002)(4744005)(5660300002)(64756008)(6506007)(66476007)(66946007)(55016002)(66446008)(478600001)(8676002)(66556008)(186003)(33656002)(8936002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UJwKj9+yC0gfsj/NxUM3P4WzqLBYmSUuiv3ezAO03ssDyQUdjCemqYDN3M?=
 =?iso-8859-1?Q?+fKmAgC1jPUrbRkd+7/AF3sRLJzz8lLLFcbPMICZ0WP5uvr1vLnwxGJg4O?=
 =?iso-8859-1?Q?Lkvy29IZl7CY4u1vH6JSs6EmzJD7SX2C7iWNiW/C5obaRmmV+KU8o8u3ku?=
 =?iso-8859-1?Q?ZfQp8qkhJf17Oa2wi735BZjQ6Q5gkAF8QvMjgC39lNqCLMHgogpxhxDhX8?=
 =?iso-8859-1?Q?RHwyYSU4wDhSIxg6rjo3fq3ZEMr+V8e/ppbAS61Y4uMvh8bdNwUIiWlpGT?=
 =?iso-8859-1?Q?3/ljrfHy3zUuICQMPgZS2W8wuN4oOHn/3WXPafUmU1+Ne19CdhPjvjBySi?=
 =?iso-8859-1?Q?Xzv8PSNkzwg6pivnCUWQElMhTiBiGgQk6op7OdHSLi8Z6rdQGdlxOnv2Pn?=
 =?iso-8859-1?Q?DHQWCPSIs1PV52ul2jnAjsGT+mdpA5PE9crzol5UvxFHRm6NSLyjXjzwUV?=
 =?iso-8859-1?Q?rwBYWaE1Xn/Y3zcyVJUKIz2mwHvWF4pGwIxPZCKLcv5FI6EBSpK3Aqv8Yw?=
 =?iso-8859-1?Q?lyFbbmyzjPqU6wGWi4JW05yQe0oDytiWE+3UkO0fiKQOE2YAGXXsfil//W?=
 =?iso-8859-1?Q?qi71IYLSxn6+MPrDOel7vPRMc+/9EOmE8+ZdHjM+oDQaL0pTEA1h9xzssI?=
 =?iso-8859-1?Q?8YETwutmUKKmfTCrUyaVikJkgMCRwaE4h2Dh0QRU8ib+FW8yVuLwhV+Z5C?=
 =?iso-8859-1?Q?n2CXOhTB7HNOq1DLkykKa3+tmyMMcD68JeNLEjO8LsQQOVPz6NvupFK7z/?=
 =?iso-8859-1?Q?WZ1LP8uUcOxUfoR8Fh3eQj7XPK53T6rfOASN5/hGHBsl6ZoTXnGBTcvIfm?=
 =?iso-8859-1?Q?VWpx2Es8TjCZNouphe7bxODyQM976b/GjrtkLnFBLNylKEDtbwPhQJMUUB?=
 =?iso-8859-1?Q?sGwwsntmL8P0jvTrk1qRDaoE38zjM8YZeaRwJE5iy8SP5N4xwql5gUFitY?=
 =?iso-8859-1?Q?rocOiTa6t8l+PYLOhnqpiaghrGLYo/DJ4J4DY4o0t2mf5p3pun+MXZp5sc?=
 =?iso-8859-1?Q?9hEoDqFfOpzSwY0DaF62QT9b5q5WyQVJyBar3xwPqrbF/2tqjSuLrAg1zN?=
 =?iso-8859-1?Q?ER8DII7KsNQH+ACA2Qq6y7L1YH1lY7IQiB0/ayf+eG/LolnH5PhDwS1n2h?=
 =?iso-8859-1?Q?paf9xe/HWyGu58DQ7JQ6UnidwYJO4hl6MnT/tM7Kz5kNZtQgJYRpmV83P0?=
 =?iso-8859-1?Q?VKXCJISuoeyDo6F/aPkvx5t2OFY35wNCIqAwJZL/MFvFqxiSflKoZtgEdN?=
 =?iso-8859-1?Q?VdzXrx/ab2QaLRt18ZbhumH0T2Hf2/HHb3XJfmDcmdi9qjIRQQIfLLgGqv?=
 =?iso-8859-1?Q?XbfjVVavdf63TN1wYmBdfMcZgzpozcrwq+CrF0Jht8Ctz9+LrO7IZU370Y?=
 =?iso-8859-1?Q?J7I1LC9nnYr+TBOKXJUVvUB/Lfv6Rgpw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16661ecc-c3f9-4bde-6d54-08d9732c77ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 00:55:07.2534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cq+y5vl69lF27zG9cfys/qVJRAfZOUNTyKpvTwSLJHYHutVwRm845HqHNHUP4ZnC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4594
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: bsRTUj5tThUc5YtcwLqw-8I295iip2gc
X-Proofpoint-GUID: bsRTUj5tThUc5YtcwLqw-8I295iip2gc
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_10:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=894 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 clxscore=1015 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wednesday, September 8, 2021 5:28 PM, Eric Biggers wrote:=0A=
>It's fine to reformat the comments and code if necessary.=0A=
=0A=
Will do.=0A=
=0A=
> It needs to be:=0A=
> =0A=
>         if (!certfile) {=0A=
>                 libfsverity_error_msg("certfile must be specified");=0A=
>                 return -EINVAL;=0A=
>         }=0A=
=0A=
{facepalm}=0A=
=0A=
Argh, will fix that in V4 !=0A=
How did I miss that. Thanks for catching it!=
