Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D60E412730
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Sep 2021 22:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhITUI4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 16:08:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237712AbhITUGz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 16:06:55 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KHwEQD014054
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Sep 2021 13:05:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=LACZMrt2bWvdGBEGMd8P80T0l9SqONJux4MY8WZBqVE=;
 b=Boq4dzMiUyzQFpfWtGGgKi/Lbc+Vld9NRVkD/A9vEbo+R+hTo60hCPmAalDZ0nUVWtN3
 iEJU6eOkD+4ZWofjqal+unf6UqaJSVJno+6okrvK/OxzBY0LdXlcb1Q0FD2ohjzLZOPc
 qR3LV423PK2K743FNTSyv3MGQdNuDPVn2Ng= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b6f2rdrsp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Sep 2021 13:05:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 20 Sep 2021 13:05:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T990/fdnPpHki3rXvjcIQED8OTJpPqvzqfW4hZE01fG9yUqDPSHFaxM+Wuo+V0Zbe0htnfRYfMdlJ53gphq110pUrIVILOCAss7TuMKr2rBWvsCXntLe57tXyjarhsQ0KINm1C+xtQEElYVOury4giz6IM2CH9cTXDaOhVY00/Cu/KJQsgjpp8Qq12DUtgvKI8WFbStTFLyUIqR7t6XXb21i7n0a3ErbUPZUlE4C9BHnhrw2TDd+PEnlWej6+/OYk6i4XgbDiQnM9KkXyfbX/5b8kPorY2kpC9XaNRYV7JDV9oaqKbA5H3G12A9RXA4vM58YYu3aUakSgNKYoxSibg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xT+s9R12XP9AXtH12n/r3I/1uDV+VCbnxSOoyKVFVwM=;
 b=FJyrMa4LOYtjq/HyGTsEUsBNDX5T4ok5+K9pp1H2Axy8pA3BBipkA9cq1Ces17umq7QMNsWToNtmVeXB9cmE5Adj9DlacjpZLZz9iVl6GXte4O83HqUJXB2wOxXNT4S/t+Rpcx/VtTN3+7dbuG5c9upi8Gdk2kVa7qQhca57+uz6YxJwxkS/4p0PzYPiTkFHT76yEWxC2CtwkDQCrlyEuuVVvjPUdFCEOKTxEu2KftFOFoFv5FX0JBz5LOgnMuGa41lUKYMmevwbENlksfATsYWNQJMQYTYIZY0RW0CWbso3qo/Wetm09d5ZTcF38z8y954NhGer8uOFeZczsX7Rwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SN6PR15MB2237.namprd15.prod.outlook.com (2603:10b6:805:24::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Mon, 20 Sep
 2021 20:05:25 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 20:05:25 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        =?iso-8859-2?Q?Tomasz_K=B3oczko?= <kloczko.tomasz@gmail.com>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils] 1.4: test suite does not build
Thread-Topic: [fsverity-utils] 1.4: test suite does not build
Thread-Index: AQHXrMhpYFP1rvDuXU2NGtGOs7tdL6utWMLn
Date:   Mon, 20 Sep 2021 20:05:25 +0000
Message-ID: <SA1PR15MB48247A9238700C0A1B12CCB6DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
 <YUZGUIRpVjNpupSi@sol.localdomain>
In-Reply-To: <YUZGUIRpVjNpupSi@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: af6331f5-1c8a-4cd2-7c19-0d56a0c50ccb
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a82b3e9f-c170-40e2-fc62-08d97c71fc46
x-ms-traffictypediagnostic: SN6PR15MB2237:
x-microsoft-antispam-prvs: <SN6PR15MB2237AF552692FF60BD8C9F58DDA09@SN6PR15MB2237.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lcKqiWlXxH5TLBJHZ7EnGJwLBic2W6HycJo/q6nNMNtObyMojXgO/7P38WKK5F1JhCKAecQb6etRFDYlG60DOnyR16D3wNP41aaD+ojPjz56/DUIhX820j60vzATBw6vHchUp60Kxq4VfJ15bYLL3wb87axdf50m2jP4evT7PykY0etfURdy+ruHeR6dADKwnarLUHDrsRuyhCsEkk3XkuPE3kqc1riqiJyFUhEcqOi1kXjsyEpUC9yK6KxMWAbBx1dbRbNDBOdvkQ+jwr8SSicAuOsSCyxqSGfkr1roVey2hAVWpgsY1OmzVjY4P74/jtLTRBH4VTzK8piG/b6gHDY9NlavKFxdF84h+X/gqyMd+UkpoWdIpLarQCg+gOnJO5gZuVIBQvzvN6Ab+u9XvGqJLYS4HstnS/wpO54hf0hgXzfWaFpIK70bx3C7ZVyHbXNYIoQpl64Ya1bpRyYIrjMCOUOTse6PPKJiCC85Xj1WXkZ+ZEFhMRXR/xGCfJMGoQTtKd5zZAQ+zOgADKBgcxn7+uJRirwx8M/KINChxy+0SGHcVVA4r2HfNGn4dSwhRlFC/f0274dz0SN2fGL6DW80Tb9bIQ4TqC8c3rhxqIcWC8oYjvnz+XC4JcJihzQU6W/uhZlGDuwrrsr9X+quWZMeJasKtUZ3qKaq2HNq/7m+Se7GYx2h6m88jaEhuybIA9T4Hjw/8JquZPZM7gP9fvdRhG1fCJSS966eIe/DMJnEMG7Bu4NmRURR+63Awh2SJNiSszw/++PnjmWT+jSU9SB5K7H2unwqyRSvBBdzsHyvUrn3tXfOTCuZJliEjtvU8grn8qP0eZ4Rtu7rcX5MjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(5660300002)(33656002)(52536014)(9686003)(76116006)(86362001)(966005)(38070700005)(66476007)(38100700002)(4326008)(66446008)(110136005)(316002)(122000001)(71200400001)(91956017)(7696005)(66946007)(8676002)(53546011)(83380400001)(508600001)(55016002)(6506007)(8936002)(64756008)(66556008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?TTCkWo4iezxSTcuns47xX7aQMnF0hpon4LaoVL2TqfcYuogNCP9q7k/zhg?=
 =?iso-8859-2?Q?8P1XRXE6Mb5aaRFfeSfTE24x24Nj8NuULLspGWXBSdtYQ/Bj2AQ9KjCLfo?=
 =?iso-8859-2?Q?tHtDNqwitDisyn3QneJJvgev8wYAh0tcsgYCAdQEVUY9r/mZFo2Mx6CC9A?=
 =?iso-8859-2?Q?lzW7OAHv7n1nDdfjmSZM3aJZsAyMhxebhQMk/37Wx8cmxZiAeIyaH0Eyio?=
 =?iso-8859-2?Q?uOuEukrimg49REZqqOZsYwHag8kwlzvw4y631gU5FaGiUcEMQS41vY0CWt?=
 =?iso-8859-2?Q?MfuLv68NRAtE9V23QqF4FaX9E/l7DmJ4z7MQofbx89o+6Qstu2b519JCLN?=
 =?iso-8859-2?Q?kBWbl1xGXZHBnWbUVDR+mqXP/Vft852fD037YaT1ss21sEciS5a8TkCSIt?=
 =?iso-8859-2?Q?j5a4xwMcVvyZvm2u7cJR55PnbZ7uu9NisPuPJqzuH+Sx+2lEpM2PgKzAJ2?=
 =?iso-8859-2?Q?5VE7RqO6I+xCd4mRrO3LvPQofG+bs4wskUzOyxncaxBgU/st9VJRyqM0el?=
 =?iso-8859-2?Q?sJToxubE3vNK+EGsgEoTkq93GRAvgUzdrwteUcnznyu2DlqQxGEKGZsvro?=
 =?iso-8859-2?Q?2/7N93K8GFeluC1u8EF8KGrfbahSfx6y4/WYs0n08TInl0peADZHixns3Z?=
 =?iso-8859-2?Q?jdldzeUHc7ZnXZuLbneMYNOA4SLlra8W58XgYNcp0T6ltkkR/BViddr31a?=
 =?iso-8859-2?Q?rhzUJ3hhYuXtBcRJnhQOreXJiSUAeVwGlCuBPXbltBHWYpzj9f71VCL5SZ?=
 =?iso-8859-2?Q?kKfCiW0dP2N+rHQWy6G/En82ocAwQlg+iQCrOA3K6VdFMxvKaKo7qZfuZ5?=
 =?iso-8859-2?Q?0Hg4BoRqV3E/g8AROey5h5ikMRsGushCqjDLn9f59OJSFnm3rUjpWabaCG?=
 =?iso-8859-2?Q?e//rIRM73L2AC6erw7T0XOxpJC6SEk6k3wU5sN1D/6ef90PV+UV63zVup1?=
 =?iso-8859-2?Q?ssjeJdBG6DgmuIXaHnQkj3u+Glci1DT6pkOwVmez6Lrks2Q6n514AS34iB?=
 =?iso-8859-2?Q?6kUO2SwCUX/RMUcSmTFra5bKGOk8sbPbZJrWpn6BMNCUBukeCXUDvTtYQv?=
 =?iso-8859-2?Q?r7Rq2Pk72AG+pkauw9LiOKu5uVxBuN+xOAgOHMFb4+x/sO1ER94RuvTAit?=
 =?iso-8859-2?Q?4XBFH/70NfDMVYs2hyXzafVradsY6sW04JuKYHZDWfw+tZuHPwLAZiVNQR?=
 =?iso-8859-2?Q?6qN0vLxvBfoNAr+DIRTegejAgu3Isfe9HA2dAXvvVofhQ83+7BXyP0uJYM?=
 =?iso-8859-2?Q?ONBZT0HV8ztqH6Rz9MF5zD/5vaewAuZh4tfNq1anZQGoe8uwWZTN/OzeJf?=
 =?iso-8859-2?Q?Cy+NXSr/zshjBZ6qmBBn50GsgF3B3iXAdoHvvgoYdMf6v5vwqfED964a8/?=
 =?iso-8859-2?Q?y7nVihaiSjTtckvj8K7nEumQioVFTcUg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a82b3e9f-c170-40e2-fc62-08d97c71fc46
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 20:05:25.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vxxOYhG43Iosaepe5Aw9J+ACZG9cJMK06wo28glDjQJyE3vjW/CWX8v68uxNYCSc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2237
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KmR301hvNoxtPQvF6spNCK7EeMhAKk0P
X-Proofpoint-GUID: KmR301hvNoxtPQvF6spNCK7EeMhAKk0P
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Saturday, September 18, 2021 1:04 PM, Eric Biggers wrote:
> Aleksander, can you look into these?

These look like compiler warnings, why did they break the build?

The reason for the warnings is that the Engines API that we use with OpenSS=
L <=3D
1.1 has started to be deprecated with OpenSSL release 3.0.

The replacement that OpenSSL offers is called "Providers":
https://www.openssl.org/docs/man3.0/man7/migration_guide.html#Engines-and-M=
ETHOD-APIs

Unfortunately, the Providers API is only available starting with version 3.=
0,
the same version that deprecates Engines:

https://www.openssl.org/docs/manmaster/man3/OSSL_PROVIDER_load.html

So, our options here are:

1. Tolerate deprecation warnings from the compiler until the OpenSSL version
that provides the new replacement API is widespread enough to stop supporti=
ng
OpenSSL versions <=3D 1.1 (I think this is the most reasonable approach, af=
ter
all that's how deprecation mechanisms are meant to be used).

2. Use a bunch of preprocessor conditional #ifdefs to support both OpenSSL
pre-3.0 with Engines and post-3.0 with Providers. This would make code pret=
ty
messy IMHO, but should be doable. I can start working on a patch if we get
consensus; however, my opinion is that we should withhold from that until
OpenSSL 3 is the standard release on mainstream distros.

