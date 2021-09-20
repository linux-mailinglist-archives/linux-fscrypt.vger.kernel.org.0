Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0646412887
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Sep 2021 23:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhITV4Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 17:56:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44014 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232018AbhITVyY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 17:54:24 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KHwLGP022867
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Sep 2021 14:52:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LOCeLMrrorgVoEw32PA05Le+fT1pZUdbjixOhXO3IWw=;
 b=liqmI4o/Zg1w0sKdby23+bEktK0LGuA1XM29bP9sQ18S3mJPLFNIn/uylZ//g33TnPXa
 FJq9+SPoJ/Vgfdi9Zf+qnE4exTUisvSenRnnxtTZvK6ZPSJ2HKRsCoDaTwIfsfjRCIXB
 34PlTNDU3KaXP4qP+9xKkeoHSkveXL74otQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b6mkmw4du-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Sep 2021 14:52:57 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 20 Sep 2021 14:52:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ng+yl6QpQYPP8Ad+jZVIMKP42eb362zuSicI/YYe33yC+6VPHgWrmmhbb1piEoeqTOS2p7WHW4Wdaskgc9K7C5WLxe0DNlu7Vsn6ApMgPQYoZpa/Pni0i0GYPpDBbag93/4Sw4LKZ/1VtKEI2LUxTTnpq/RCdXrmlDcHZ//+2JClzTvNtN00oVn8CbzObJoR19/ft33nt+Z+M4uDzEqobsVCYqb1gTTF5A0tIXQ5zf55yYXQ2qL6cR5qdIaw4iN9Z7+IxKXn1nOKTGa80r/U73ILgLfTIaNCmvRKyFYDP9sk6p2MkRdwqQci05hcpQ1LRMQEaglM7qo2piVGEY2gYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iqRivM1h2ffiC4yYVjTbCvg+E5fFyEyeIGKAiQf9IGU=;
 b=Z8iKz1o1s8LuFxzk2yLoE94e3GIghC1PwYk94lTuoFzQcrA5IepeHHznzSUTITL/XJPgwxJgsH3VzwnQGTr9dcLnckb+yAhfuBvPI0C5YsNi/XAqCV+pe++kAthSHJyr2JH0fmJQucJGANGFS1GqEh7zFaUEOpdQX2BoBAbU/sEMdDi+cys+5Tch+hSN5oe72p99Yyh7S3QxTFqDi6LcIE+MqqY56d39MdXcCoXPhheVsW5R7ygoJ7KU0jbAT+P6U9QBIR7YiJTV2XH8v0qZNW9kYdSGfXkPHNSflbEjRfkeOin24i0sy9AkI384LQEk3x0GzIsEoMIQ36Tz0ANMbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SA1PR15MB4569.namprd15.prod.outlook.com (2603:10b6:806:198::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Mon, 20 Sep
 2021 21:52:55 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 21:52:55 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     =?iso-8859-2?Q?Tomasz_K=B3oczko?= <kloczko.tomasz@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils] 1.4: test suite does not build
Thread-Topic: [fsverity-utils] 1.4: test suite does not build
Thread-Index: AQHXrMhpYFP1rvDuXU2NGtGOs7tdL6utWMLngAAYHYCAAAaO+g==
Date:   Mon, 20 Sep 2021 21:52:55 +0000
Message-ID: <SA1PR15MB4824F4BC9969A55AFD556182DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
 <YUZGUIRpVjNpupSi@sol.localdomain>
 <SA1PR15MB48247A9238700C0A1B12CCB6DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YUj667bPkKxM4L+z@gmail.com>
In-Reply-To: <YUj667bPkKxM4L+z@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 72d90ca0-6a18-d4a4-743a-88b20c9f870e
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 514c9329-d909-46b0-9515-08d97c81009c
x-ms-traffictypediagnostic: SA1PR15MB4569:
x-microsoft-antispam-prvs: <SA1PR15MB456944058BC0301A856696CBDDA09@SA1PR15MB4569.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8b3qoB4TUlUOsfJQhQtaFNthMDxr+v9qf0s8Ukj+Z3Y3ZdTpbD1BfZhwICLAy57MIoxnOpUZwgl7AsIZfirXBzaUGXcOXkU45qzhC64ZKsFfNAJfP8IJooAmpB1x0uDyMJCLNt8/Xhsva6ObazrSHUast1KREH6ueEQhrjwWHCYjr+4rBYwj5+HnuDiRoi8JAxGLo1kdQCrrCZ21c/SfVkfY30BIXZR+Ts3lYmP06q5Auwxt7Z2UHKMkPAwbCO+Dfo6RDmxQPL8rvvhj3C2qJkVzMME5HBVJXTHSk0nbCPPZ2a4HyWoZvIsO4JtYRjrvq2weKcFTkC4o3pbSFlopGx7wySBB3hpnmfzCYNDMmDu6MLECO3hDcYrG6Obba4x2LB1yZZPU5+saEEOG+F2gPzrrx0KdrPmSIHXkuInVZbo8VBuHOxIccYniy9yH2+wRYSkGWscHpJO4ScQuJJqV3qyOaID+WKU8asqtUg9xmaGMaagToh2sDyr+4CM9W9Ffowt4zQHxdXcsp2P5pxJS2qIxq7Cu0wk0379+BLPOZhJcwHtwaMfJh2Dm78NUiJWi6UjM+CfYtRyqpIaG3erpnxQY8hlC3mlzDGwP5ck/EpE5U19fuVWfvv7SMn5Nx0902qppKF2ASeKfMj08q6EsDSutF0AbkzL7dBmEalXqcKsQ0JumDvZ7eiOipNslZgw1h09KoPM6fMEtx9Cy6wY/YbsD1lFnDaZ9oZzvEaMzJG+Vb3r+QZoB46cTNjLxcNGcAkJ9Ze9mQMBBVuqViMJdWlw5WXAjbG3ExTafPDNvSg/AtiAuH8uGu/GiK9XFAVIb+fGhIXnp/4arvtbWbxlKcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(86362001)(66946007)(83380400001)(71200400001)(38100700002)(52536014)(122000001)(91956017)(508600001)(4326008)(6506007)(66476007)(64756008)(53546011)(66446008)(76116006)(2906002)(186003)(9686003)(55016002)(7696005)(33656002)(316002)(54906003)(5660300002)(38070700005)(8936002)(8676002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?4p2YWYOsWJk3hwk9s1ciShwsULjT3N4VSd5xfZd2BHG8og7aquxctPtK7v?=
 =?iso-8859-2?Q?j47mjxsRyuqOGHG+vpv3qh5yeA457Vcf3g0RdSHShbnc/WSwI5yIAsko3U?=
 =?iso-8859-2?Q?WJSOfbpvtz5ef30WElZhLj/bbwlb5WVtJZfU20ItH5taaT5AXKgnxEbFzr?=
 =?iso-8859-2?Q?Y3suvcvVKTBdIP053d/ZsGnHknkq+lmvYXenarTaH1MjrdUvE2PWUntUFV?=
 =?iso-8859-2?Q?vm1oN6E6sV+uwMSUllJp/+vbbWySK7UvHeAaIYMFSOPysZ8F+VCd4DeXzk?=
 =?iso-8859-2?Q?wsXhrhhOK7ERNoXD6W91WjUl81iKRqgnSLUve1OK9s6zJZZH0+1QKe1E/C?=
 =?iso-8859-2?Q?bGVSF1c2OhPD0b1HURZOhbvCphyaf7NHVgcf0jL2iAWp2NnhRbYeA8Pbo8?=
 =?iso-8859-2?Q?PiJScXnB4izKS3zt8YqfaMUez6wlOwLKzZiwvz3AgaE4TlHXIgqPeg/zJL?=
 =?iso-8859-2?Q?j24EAY1BcmSPPTyvXw45OPksOmWtzZXW8Qk8AiwIMSjHsMo2mZMJWY0Jyf?=
 =?iso-8859-2?Q?ioo/6fvk9nSJFnk/h8B0DQQvzriPiKWsPuvaFWOBpPw4XJ9720rWUVhNSQ?=
 =?iso-8859-2?Q?jN3p/AFWm68YjJi3zOXNvXY9C0X7yrFOu/80ETz3CEgAuiBBXniMxLpZwR?=
 =?iso-8859-2?Q?1cfyvEgIX3MYeb3xOVg71wdcrMHu79qQ9+ev6SaQG4cHh0C6KKAwVyuljN?=
 =?iso-8859-2?Q?CzuKtS9GkIEXZqhmds4fMy9AT5Us6GLqMm9IKOsHwMmBqvlMDnEqiN+y2n?=
 =?iso-8859-2?Q?q5Cf+d0hVCnAFRmMY0tdjMJHVwClqdEp2uWdVdhqRWV+4Qsobb8bOthgVM?=
 =?iso-8859-2?Q?7TAchoYm/SRK9qt3MPSLIfHeVJlaks22cyYBgP8gxJngPW0astARu7UAZR?=
 =?iso-8859-2?Q?Tu/YE303a4Fzz4FnX9QM0dAKLJlqbG2u5fJIWAomIcBe7PQaZ90Rr4aE3w?=
 =?iso-8859-2?Q?VX7rLB9zcb6X0Gu7V0UhYfHtoUQb0ny/jTD3YFszO9HkKGAHE15DEwld9l?=
 =?iso-8859-2?Q?PlgdVtjjiO45UayHxxieX4fFkvcD84k8R/r3W1kvSIbIlk1PSA4R1WZ/xk?=
 =?iso-8859-2?Q?NMbjVWydlwigkY4mCZkPSrNywHwD382PXVwEwfzIuImhYWmw1QPc6oxw3k?=
 =?iso-8859-2?Q?MLEy4c4/yR4KHw2fNhkQHStKym6kK9nMp0oYtix1pza7G9USXOgVo0ZjZO?=
 =?iso-8859-2?Q?ggs0dF6sf1OMDkscPgcXDg7TGRORyRBmJiNeEKOM3wpiotPORAFGtZLre3?=
 =?iso-8859-2?Q?mYDZXnguj77ovOvIcxOWU/cdSxO3LDOChrLfQ/nIiPapDmSvWj9eibZTpm?=
 =?iso-8859-2?Q?KebU5TGaf1Q+LmmmZ9/0JBNW2JIujricpn0haO4ovlLH44iEWCWFUR2Gzr?=
 =?iso-8859-2?Q?iLyVhP7+U9O1ONbxWy14Ue5VK5fPzMqw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 514c9329-d909-46b0-9515-08d97c81009c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 21:52:55.2005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O/UelQQx2DgYQFDKNFdXB9X7MoSxwZUjloOxamLRe1qZRcLACBvQN3/45PFl6Eb5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4569
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: tlbvOVQ-hFAkysROm_PicmY0vsED7s0Q
X-Proofpoint-ORIG-GUID: tlbvOVQ-hFAkysROm_PicmY0vsED7s0Q
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=372 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 20, 2021 at 2:19 PM, Eric Biggers wrote:

> Aleksander: there still shouldn't be any compiler warnings.  In my test s=
cript
> (scripts/run-tests.sh) I actually use -Werror.  If there isn't a good way=
 to
> avoid these deprecation warnings (and I'd prefer not to have code that's
> conditional on different OpenSSL versions), we can just add
> -Wno-deprecated-declarations to the Makefile for now.

I think -Wno-deprecated-declarations is the best option for now.

I took a few looks around and the community isn't ready for OpenSSL 3.0 just
yet with PKCS#11 support.

The release happened just 2 weeks ago.

Projects like libp11 (https://github.com/OpenSC/libp11), the PKCS#11 engine
implementation for OpenSSL, haven't yet caught up to that fact - there's no
trace of discussion about migrating to the Providers API anywhere on their
mailing lists or issue tracker.

The official OpenSSL release does not come with a PKCS#11 provider, and it =
only
acknowledges a potential future existence of such in a single sentence in t=
heir
design doc (https://www.openssl.org/docs/OpenSSL300Design.html):

"For example a PKCS#11 provider may opt out of caching because its algorith=
ms
may become available and unavailable over time."

Since this is a completely new, redesigned API, I expect it to take some ti=
me
before alternatives to existing Engine-based implementations arise.=
