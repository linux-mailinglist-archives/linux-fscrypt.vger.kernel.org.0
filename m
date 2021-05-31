Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705F4396103
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 May 2021 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhEaOes (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 May 2021 10:34:48 -0400
Received: from mx0a-00148503.pphosted.com ([148.163.157.21]:32352 "EHLO
        mx0a-00148503.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231889AbhEaOb7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 May 2021 10:31:59 -0400
Received: from pps.filterd (m0086145.ppops.net [127.0.0.1])
        by mx0a-00148503.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 14VERTdq021701;
        Mon, 31 May 2021 07:30:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proofpoint.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2019-08-07;
 bh=uYIj54yAVlrZHPtqihoRi0zu/fCoGswddf3XHRnYv0U=;
 b=ogdLLHuzZ8uf9nbPUx8ML2jIh0TI4mWlC2min3W+muB3UM9R7m6eDmizsQmh5jkBgDG8
 dT5SjyFtvhkk21o5/VHzT6tNvDB/xRtN4qUN4b44PW6dtGK+u68JpzGoKMLxakqy2doQ
 KAL4JYApl1/0nRIERLus1Hqc3W8fZwwX5P8VY9hVMW3IyOMrBYKtZEqWM2OPs28EUbnd
 X0yjp7jaEnpqwOn/V0h/GQ8Kc8dWFJiuZRqFIiZI1XjsDI34RIMdnyA7FxM77LwKeq51
 nWqtj4czQtcJ54GlHT+OopABKhya9hv8vvtva5dL5rW/IGKCUPEqUbQzk20a1mVb8dPM 4g== 
Received: from lv-exch01.corp.proofpoint.com (spf-mailers.proofpoint.com [136.179.16.100])
        by mx0a-00148503.pphosted.com with ESMTP id 38umkq0p8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 07:30:16 -0700
Received: from lv-exch06.corp.proofpoint.com (10.19.10.26) by
 lv-exch01.corp.proofpoint.com (10.94.30.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Mon, 31 May 2021 07:30:16 -0700
Received: from lv-exch04.corp.proofpoint.com (10.19.10.24) by
 lv-exch06.corp.proofpoint.com (10.19.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Mon, 31 May 2021 07:30:15 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.19.16.20) by
 lv-exch04.corp.proofpoint.com (10.19.10.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2 via Frontend Transport; Mon, 31 May 2021 07:30:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFJHe8W2CvS2tK1yTkFm75wCZZQAXExVcjc6x3kgD0edz5rsB1yHj/L3gr7pZ5jKndSfaKTnODQaYWkwMmGOKcaYDPLQxpHL0a/ScJTjT8JJCVGA8Zq0iXLD9nJBzucTupeV1DhSmFlBqh3m/IoVFdfUKN3AVp0827Fk7ZGYwMK6kh+xyeQiVT91WCUgHhlgXnYzP3tNzWBsmyMuDF0/oAforq6TMCG2OS3171s4lRKfsgM/7DEm+pmIkegWsOjBjd6IgUQudQhM6DgvJ6IQ7Nwz/Q+4Nt/wq7k5/rTvrebtUkTBZtJ+sKUkKL/faxImakQoodqnqmUFJeOtVHgJPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYIj54yAVlrZHPtqihoRi0zu/fCoGswddf3XHRnYv0U=;
 b=f5msEk8C2/W8zWuQ9Xx+znAmm+J87YBKDvVbpzC7NdDHTHHwdPbxtt6BJCW6rk1/D1t1HG8OZ+9xmxbEcQwLRQbAGrLINlfjxjHq2XxqXnEw3BOnJiri2Se9L+9KOJ5+ss86m3umheN4oKByq6ckYz08Q58/Z8ujCUvVfdYkOCa3Fo/mhbK06JqfeyDYR6O/IhPx2K9PC0tb8QVSPgEaBike7D3Fc/Uz2+LAK5BhusxDlTBPOvl+KXvNOFVytrk2O/f8f1Z+XiP/98O2UIGFBQtRJKTawh/wyEp6M94wNYXIRyOsEDr/Gidfeyx/M27Fdy80xR9PstUHpE4CEF8cww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=proofpoint.com; dmarc=pass action=none
 header.from=proofpoint.com; dkim=pass header.d=proofpoint.com; arc=none
Received: from BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17)
 by BL1PR12MB5159.namprd12.prod.outlook.com (2603:10b6:208:318::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Mon, 31 May
 2021 14:30:13 +0000
Received: from BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6]) by BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6%6]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:30:12 +0000
From:   Jerry Chung <jchung@proofpoint.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: RE: Is fscrypt encryption FIPS compliant?
Thread-Topic: Is fscrypt encryption FIPS compliant?
Thread-Index: AddTM+XKfcaaSuVkSxWD1s/3Vj6PAwAIkYgAAByTTTAABVSusAAS8MkAAH/0QpA=
Date:   Mon, 31 May 2021 14:30:12 +0000
Message-ID: <BL1PR12MB53348E43EE0F1003C5B0A5FFA03F9@BL1PR12MB5334.namprd12.prod.outlook.com>
References: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
 <YLA1eIEOi3yHWk4X@gmail.com>
 <BL1PR12MB53345FE179D9FA84F0231F3AA0229@BL1PR12MB5334.namprd12.prod.outlook.com>
 <BL1PR12MB5334640D3CB4D8124DD95594A0229@BL1PR12MB5334.namprd12.prod.outlook.com>
 <YLGYHtNESzN5F1hM@sol.localdomain>
In-Reply-To: <YLGYHtNESzN5F1hM@sol.localdomain>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=proofpoint.com;
x-originating-ip: [2607:fea8:5761:7100:f8e1:7832:2243:6548]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7807d6ae-276f-4d98-bf05-08d9244099df
x-ms-traffictypediagnostic: BL1PR12MB5159:
x-microsoft-antispam-prvs: <BL1PR12MB51596C592DF79BFDFC861E56A03F9@BL1PR12MB5159.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CYZOJkD+nd0TF9hLxUhHmlVbd4dTljGJHYxgWxYFZmr+R4xX0ZKRfEwY06zj8KsOYFY7aJ09NBVexxCeiVd+F7j40F+vbz2Wyg99HsHBAgQhvsranDOOGBU74zgliKd2NCvB2A3GAksnCoSYD9A8R4wLTbHmTD77VLse/AoKBfusedjN7yVFKsTmPUojj4yblSrYu81Vw1QN1ri+wgpljJ7AQfKG+Lafv4if+XXaFapRnzpuB7P2uSpx5TEHbLucq2xbwPvIZlXfXArjhzcNu6EPQX+P8T2qadatpkaga4Pm1P7QNtRozfANxSbZTonYe3ry3S0AzbNNseIJ/WFTQY0h/uVyCw6pqedgZBhzeyAh1D+u5I3D9l+9kzllDQCzMpGFJZ6FBlPMbtnbLO4OP6QPSMhQIPKbkbQCW35FcVPFUUw3ZFr0lsx0tLsgUwLLnwpBzDipKq0vPONpZWLb3mZWAdTsZQQFTQwcFNsh7WvAI422y+HYY/DSFn4HEBJi8nUgGi3PLrcIHNa0HkwVlz4pf4yrhtN+leQyfkGd2kUNtVxuXpY9a8Pwf76B9oQy2c8Lk18Y0dEUeBzNuy8QMXnQ4UFLeHqsnhkrh2Sr7SWhzepXob0hHKV0swnvpKRn5BFJqvluDnfLK+OygJ+fmxaazyjH4hsiFRuuAxo81Wtspne6Sdbx/lWBxYE2KZk+TstRFJKyDv2ScNLA6+6wYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5334.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(346002)(39850400004)(122000001)(55016002)(71200400001)(186003)(33656002)(66446008)(64756008)(966005)(52536014)(316002)(53546011)(478600001)(4326008)(5660300002)(66556008)(76116006)(66476007)(66946007)(8936002)(86362001)(9686003)(38100700002)(6916009)(7696005)(8676002)(83380400001)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YIrfYrmEs/3UVv/kbKwEn7JG6CdyZXFKK1aT/OX2zUg0ic1SKieElvv8AK8E?=
 =?us-ascii?Q?8CHbcTfi4+VW6jRNU73g0SdgW77GGy0b8I/kB+J0u5QJ2AZcedLFrK7w+aa1?=
 =?us-ascii?Q?jEyjp0bpPanqtfH1H6FpUnluFD4QF9BugnA5VivLp1DphgaV+qiwDUyFFht8?=
 =?us-ascii?Q?MWLRi0gqFQRBw/eRd4LtpYQ5FUXc42vZzvwejRMj5V6KJ6SH1GRhQHKTCnGs?=
 =?us-ascii?Q?Ibo/qGkbhtdAAJS/7yrXc6615xhZD6WvZOwLQ8o0oS8vabiwRBcRiattH4gg?=
 =?us-ascii?Q?c0t6PPUCs6h/EK4kfqTG8aoQ+u+r+6mFltsVQC7FdPAMF7ypJ9xEfLqwjPbf?=
 =?us-ascii?Q?GipzBWogvBGrEerIT6xxnNc9iHceJUopG49JeT8FIrQ1k7SrLs4LeOd/0Mmd?=
 =?us-ascii?Q?HzAJjkjF47eyxwiEw8xFTivlC63AOXJC6N84hMzKr+qjJxXHPPradp2hJ+rQ?=
 =?us-ascii?Q?w0rswm5Seqmslyc3karsw13zHt/f7/rzb4ZQgHATuoIFcIrX7Rb7NNvxLRgn?=
 =?us-ascii?Q?xGhaxladV+0pk4AQaAN+Y6iQK+EBI03MIxH2XRaXSPo5WQ3Y7NWauV9dONkb?=
 =?us-ascii?Q?SJAb3F75/WWk2Wk9Xjj01HUkbqZ1VQQd8tLuP93+Kcl/FQxder5Q8+Q0rmRs?=
 =?us-ascii?Q?yp9qXPsBBErx+3EejfXcGqFFcgOkUX2toEUZoxhfwKcoHFj2ylnu8T8nPqCP?=
 =?us-ascii?Q?Otgc9K826Q4iiRmcUKv+AU5ONWEsXylebo59jJRAX7mfDt83w9xVAiAVb2Cg?=
 =?us-ascii?Q?6+o2MIJp2MNiWf69NNLWHKWeOHbZoBUhheH8P6rW3tZLNqNEddLQ8h49YTgx?=
 =?us-ascii?Q?2u6uAdYeSI3ZqGR0+WZCZUE7HMPBEk6WqJtev4TN8+6TPF6nKwbjWfbPzSwX?=
 =?us-ascii?Q?0YYrfk/h+RkFAdhxP93NYCVSQryEcG09Oa9cUoJF1wjAPfdqbvg+5dvMoClL?=
 =?us-ascii?Q?XZzPXMsaoJKw5NLxhNyPtBUBcN3v/rjCP5EcyeJD+UYiLyoXxb8oe20dMz3f?=
 =?us-ascii?Q?wst3jqOgKK/+42oSoaei4XA5RQgJjUzSm44erE2TF+Kff+YWDKcRC9YvPb7N?=
 =?us-ascii?Q?YUWi5MqLMglNjegrxlHARo23KPueZq8h9/96TSjB094IPqBG/4z5qR4E78eY?=
 =?us-ascii?Q?EoMatVvda8PJnlNemJ8+zWTw0GQ/QlD3XcX+QaFrgny6mj1tL2SIWu6HJ6EO?=
 =?us-ascii?Q?aVav/IjY46bveW7u+VY+1AH5kquRgA2InGEOE3uVgDDMUl06srE3wDQVwm5l?=
 =?us-ascii?Q?nN1coOnnbIj8uVOvTTXcIyuXAuZSTYEEyrmj5E1h+cm/uxpLX3jv3BlHPVHd?=
 =?us-ascii?Q?ILT1rs2bV6Nbte8s438IdmhYlZiWlx123ew1FPTRk08q+06KxCeLequxZ+6y?=
 =?us-ascii?Q?xAmhCOTqf9hno4cJJvEbzWJWsFza?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5334.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7807d6ae-276f-4d98-bf05-08d9244099df
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 14:30:12.4374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46785c73-1c32-414b-86bc-fae0377cab01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dBzATAKb+m6DcHSk963130U4d09E+KWS3NF60A67mKdyg879KSe5MUc9/gVwZgs+tSLb0Cy69LHk9yWmHg+ekA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5159
X-PassedThroughOnPremises: Yes
X-OriginatorOrg: proofpoint.com
X-Proofpoint-GUID: O_UELVkAvC2VjSv99S-VNd_1dDQa898c
X-Proofpoint-ORIG-GUID: O_UELVkAvC2VjSv99S-VNd_1dDQa898c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.136,Aquarius:18.0.761,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-05-31_08,2021-05-31_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=846
 clxscore=1015 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105310105
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Thanks a lot for the detail explanation, Eric.

jerry
-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Friday, May 28, 2021 9:26 PM
To: Jerry Chung <jchung@proofpoint.com>
Cc: linux-fscrypt@vger.kernel.org
Subject: Re: Is fscrypt encryption FIPS compliant?

On Fri, May 28, 2021 at 04:26:56PM +0000, Jerry Chung wrote:
> Hi Eric,
>=20
> Does fscrypt (kernel part and userspace part) implement any=20
> encryptions by itself? Or is it relying on the kernel crypto API?
>=20
> Thanks,
> jerry

In the kernel part, currently the encryption algorithms are accessed throug=
h the kernel crypto API and/or through blk-crypto (the kernel's interface t=
o inline encryption hardware).  The hash algorithms SHA-256 and SipHash are=
 accessed through their library interface.  The key derivation algorithm HK=
DF is implemented in fs/crypto/ on top of HMAC-SHA512 from the kernel crypt=
o API.

The userspace tool https://urldefense.com/v3/__https://github.com/google/fs=
crypt__;!!ORgEfCBsr282Fw!57nse74kKZWgPBVTybhzV_-lLBRUeyq3AyR5Ixx2_qIuPXL2aW=
TxpZBkKmj0Ze2kIQ$  (note, this isn't the only userspace tool that can use t=
he kernel part) uses cryptographic algorithms from third-party Go packages,=
 which get built into the resulting binary.  See the source code for detail=
s.

Note that these are all implementation details, which may differ in past an=
d future versions of the software, both kernel and userspace.

- Eric
