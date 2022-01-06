Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3364486BB7
	for <lists+linux-fscrypt@lfdr.de>; Thu,  6 Jan 2022 22:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244139AbiAFVOj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 6 Jan 2022 16:14:39 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:30863 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244206AbiAFVOi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 6 Jan 2022 16:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qccesdkim1; t=1641503677; x=1642108477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WG/q1tXPyLgpggfkRoXnzAjgXwP616TvYs/OIllVgGk=;
  b=qD1oOWgAV6DTBEnaiDLciLPOZNOFRnLKGptezTitQ+N1k5sXAZl0U3ng
   nMWG+3LnysfvwC0zLm2eEJSY7VUKomeQQMUXJmXOGAS3CwjM7zF/C0FP2
   ShC0mATedy+sWO9qbhqASxfEE7bQC+5iuJxpfjPtPQnHh2QYAOTHXNL7b
   A=;
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 21:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLFM5vJz/7I5yH+qXAfwpsTKKyPszT1KYjaUaPls6MXiMr6jH+lPULgfNzjwZ3wCaSkm13+FTWX445OnFbu5TQ897pfxUXfA5/fLPxNAQ81xqwlmiaCYq6tu1PwyLzm04OiovDamGz8RhMlwmB6qU4AoXMWQU1aPM7vX2NhIH3jFODKMxY5k03PtGueVyJ9JD3eeKnvP0pmrtfQhfmBSkD5Mfpup/Y2ejisuL+RoW+EsbrWNgMt72mRcHmWQwD9sG3m5WroLICNGwoLJnIADD8TB2K9ymO6v3QXYELlnRionP1Kb+zrxiD+55OmxVPiAjNehU5J3ouojMQ2AsFaLLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WG/q1tXPyLgpggfkRoXnzAjgXwP616TvYs/OIllVgGk=;
 b=Mu/citFn1LibkoydaejVRVnOWnELJ7sKY6/2S+dHHLYqY/islMPl333S3KaDoJWVZvU3fe7gzp3eTcN6hOPLyuMFxzw5QC0JmPA6u+Ps1lJdEQI4ePLe7g9FEXXmtn/A0H5R6/9IPQpIuxZbFuv43b0fi+owem6PdpxUh79Do5pGND+a+76e2p/rE5igS83d+beqkB1DVyypYpL+V0dqNMhftS886a4/WJ6Q9msiaoMWU6pe1D8soyVhh1pXlmzOJ0X8UzZ9SruBY+RmuP5WlY5iYrw2f8nBC5ocg5WVXf2Fce/7oU+QDPRTaSOHMV5eWqTUPKYLGl/dcbimG2faIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by BYAPR02MB5720.namprd02.prod.outlook.com (2603:10b6:a03:118::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Thu, 6 Jan
 2022 21:14:22 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::890e:17ec:b473:b381]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::890e:17ec:b473:b381%7]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 21:14:22 +0000
From:   Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "thara.gopinath@linaro.org" <thara.gopinath@linaro.org>,
        "Neeraj Soni (QUIC)" <quic_neersoni@quicinc.com>,
        Dinesh Garg <dineshg@quicinc.com>
Subject: RE: [PATCH 00/10] Add wrapped key support for Qualcomm ICE
Thread-Topic: [PATCH 00/10] Add wrapped key support for Qualcomm ICE
Thread-Index: AQHX6vTNJgaGQVw0vkWvN4ZRGoC2raxWlrGAgAAWnPA=
Date:   Thu, 6 Jan 2022 21:14:22 +0000
Message-ID: <BYAPR02MB4071D51F6DFB371E46E424ACE24C9@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <YddHbRx2UGeAOhji@sol.localdomain>
In-Reply-To: <YddHbRx2UGeAOhji@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qti.qualcomm.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65ac1e1f-50db-472a-81bd-08d9d15982db
x-ms-traffictypediagnostic: BYAPR02MB5720:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB5720D0352EDC28FF3EDE3B2EE24C9@BYAPR02MB5720.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MWxl1TAuFEleWpvidqH6tXzKokMkSsEJPdUt16qXMuodifjv/SomvUX6/KbaQp6QBE7hW5kFIv6boBRjo968Bb5IKGZ1fXYFNo0GAior8ckMH4CxOYqiTZdAOpQ8vwhhp0utOmL1SP2xR2xCaOS/fTbKw3uEX88UTRaV/vVS/3dQyIR0Z5pvwaZ1au4wALLLPh7MXmObjrZjxnym5VQ5JhjfmdkXeLQvzzYdCogNAEAxe8c2qD6tY8Hw++A25DFDEmXmQY9Tno++jwCrQBGWMyhbKQQ1U1UqBQMR0mWb7afgQuyBsm2GUA4rxpVrZiTaYEOM9csS4jWT6dORlKIeTJ4QTRrv83bHm8MZFgwhnQMSk2yMCQa22a8b4bKPVCso43APfDwHTpEPzanqpdrw+JYdgaUkF+IVv7dZEB4AUGlZ1ogeoj8PfbebUf1V/geNJUPR5Zaofd8YMrS8yp1qRkLdpQdUymRmKtfa68ga5SLP4PRMfZNk4FizZ/i0qDjCjmnzBHSxEQWE4VaWumJ20+XlqIMeV0jDutKmIjoEhB7pd9CI6hPquBu45/ixVJuPF5nI553P3nBQFXLGKCyAd1eQsBM3JsZq+QYhI6K7DjX2bXq9tANjVDJkfxLmfnwG7AVdwnzi/DUv5lzwrmZbSRmnHYShwUrTMrVMBDnoiX844iUqVSARUnCHt8Hput6jBekjSZL5SIeTyJhjZ4YI5uhUxUV6RectFhSyN/B8GTdyRalfmkDVeF3dkVZmvnJ7WazKqJ8aGs53gDMKAwJish4w6pwbMogMP2SHkX9kD1uUrvx2QDXtaUo+FhEnXMcJRpPynWfeHUvcOTbCWzSUPg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(38070700005)(66446008)(66946007)(7696005)(966005)(64756008)(508600001)(110136005)(5660300002)(2906002)(9686003)(71200400001)(76116006)(54906003)(33656002)(66556008)(186003)(8936002)(53546011)(107886003)(55016003)(83380400001)(6506007)(66476007)(4326008)(316002)(38100700002)(86362001)(122000001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bLK0hGErgjhnYvGsQVXhxLAh1D2LKERtsQKMIWB/KouvKHDn+yAiaLUjC4qI?=
 =?us-ascii?Q?uOnfN9XAzLLUzsGT0z2Q9LLhFgApyZA9kQwjwHb+yUVwt3/isOoVKpNGwKvE?=
 =?us-ascii?Q?QKuyV0FC2CbhGKxhpevDY8QCP3eUQZslF3WQxB01SX0e1+BPLz5yjb9TmtRU?=
 =?us-ascii?Q?Fpcm8nLc/A7y1JwwgDWSFcMKMc6rt98wRa0PxBWOwjyCjBO7QPSjM7/RtvQp?=
 =?us-ascii?Q?Shqa8hlyZ2DDGF+1Em9fFux+y1+CACcCFUp7jIrwpVtz7IyVcweCZqaGsJa8?=
 =?us-ascii?Q?ASmbZyDr22jkIBhT5wgxnpH3w7OGGjXO+UtTKzrIzT6addWNfew4YOIoQuzM?=
 =?us-ascii?Q?ZHeaEEsmWD8sxgMZZ62XbbhTqu3aX0fC45mSoOTROBu8aSKekZeCihQGAlAB?=
 =?us-ascii?Q?B1A0y4uU59wF8sOnRKE6xLMxCgZutHWZKCa8NomOdp3ao7ItGRwshiEik0mZ?=
 =?us-ascii?Q?4arzdrweZNH2HCqIOuVmoe8zlKJxwavmzTA1VrZmrC+DQFXZf3lCyCrfWbkh?=
 =?us-ascii?Q?EKaOrRHCAqHM+77pSQE9vXa5iV1bIMQfbjLBlpYeJb6ONQ2mXUhJr8cx+YdZ?=
 =?us-ascii?Q?06ETT1TwK4iIVH69UySQ/fJJOXgdkMQYKWxh6/JrwjCv1LuaGiHVH07A6zOG?=
 =?us-ascii?Q?TV3mnfWOkS23uI56MovTYkwJiKQtZiF+hyRIZp69WrSoxU9QxtKDxTXY9sGz?=
 =?us-ascii?Q?pWij+qZY5GUxZyIxfTNtpS47OHyvizLiGtyd7F29YwssZ9s34Ro/44CfL1AA?=
 =?us-ascii?Q?6yoFxe8YAi9C5hmSrVxEOPWERf/g7e2fEpqRuB70qYxO9AWiAQYdpb+GN5D/?=
 =?us-ascii?Q?V27m6QA3PSCMdNclzB/zhldchwvLgHrP2Bk2BqcwyfFmIPTY4OwBa/QmcCTc?=
 =?us-ascii?Q?8Bb9DN0jXqAsGOOSERT5GnbkrIEttq/OTTlHW59uEeylAleg4Xun76upnT2s?=
 =?us-ascii?Q?sTnRTSG+Ejy4tZBwv0TOJiXxLV2Otiiw9L1LVPfBnsoK9BSakAGzHAuOuG06?=
 =?us-ascii?Q?E6fE65i7cT2v6Q7FGJ9qQwmGl5yiEK6ATb/3A/F/VJvBRZHzlxXswCBfnHno?=
 =?us-ascii?Q?GFfJh6RzPb35HeR0wr0uYIDVfpqH1+dH5SkS9jeyslPfOth1MFyTf8bg/3Oe?=
 =?us-ascii?Q?2F9t9C3rTFMemI9gyQYbrMk/gmpQx8l8+PR0zu1T64x2ydLDFWTx7iRqzFDx?=
 =?us-ascii?Q?tEo4WrWBJLmSeB6OxsGGn3qqVWM+bsfo5pXPIP0HxxHqnySv1QGlnHz4LvLh?=
 =?us-ascii?Q?rbaY7yZH1Jqn6knqQOl/JokCFAAFwTWVggTBhNSjtk+yDCUZ4yocBQu8Agoj?=
 =?us-ascii?Q?6b48krlnbhbl7kYwlqHjXoXABjiZKwhdDRQqH4skuLtYmzB80CGiaw+crHKW?=
 =?us-ascii?Q?X6vhNGC3wwEGR1kG2ZrsAwo/W+G4lK10b1i5ENPi7rbNxT0jBj/HDmorHFcF?=
 =?us-ascii?Q?RuroEOg9MXEy1lNDXw5ENm/aN/bozeQhXn9m+p5crsU1rR7AbCda0C5tCyl9?=
 =?us-ascii?Q?aZwWgizJHNIXJdMcGdoSsKqjp94uc2A4LnKyVCPdaPi4MKBsHd3ov1QlpqfM?=
 =?us-ascii?Q?d7Cq+NJ0TDsIjIeeuA5RribKf33GSqdf1O5GjxYPSUKPQoj5V3YwiD9sOzX6?=
 =?us-ascii?Q?kTE1FvwevU8LHbuCoQ7yenI4eoUUfklV2xKT5XYSEBO8V1odKflSTzNQolNi?=
 =?us-ascii?Q?pixE3k4BFNpx0VRSuL7BVtnPw3em4uQ12aggE5/pATOaRSN0eweCkKr7AGlV?=
 =?us-ascii?Q?8DclKjJSzw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65ac1e1f-50db-472a-81bd-08d9d15982db
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 21:14:22.6104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cvi5iS7SfB73YKPxzmu996N1JxJefybEs64cOJMzLcu7GPxePcuHl6QDdXrdMxsc3+vqXkFav9/mbkv38jRel0x2Tl5dVsE/t2u8bRywH8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5720
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hey Eric

Have you tested that QCOM_SCM_ES_DERIVE_SW_SECRET is working properly?

- You will need updated trustzone build for that (as I was missing a minor =
detail in the original one pertaining to SW secret) , please request again =
on the same ticket for the updated build.
- I have reminded the people in Qualcomm too to provide you the build.
- Note that with the new build you should be using the correct directions, =
i.e QCOM_SCM_RO where intended

Warm Regards
Gaurav Kashyap

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Thursday, January 6, 2022 11:48 AM
To: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-mmc@vg=
er.kernel.org; linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; =
thara.gopinath@linaro.org; Neeraj Soni (QUIC) <quic_neersoni@quicinc.com>; =
Dinesh Garg <dineshg@quicinc.com>
Subject: Re: [PATCH 00/10] Add wrapped key support for Qualcomm ICE

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

Hi Gaurav,

On Mon, Dec 06, 2021 at 02:57:15PM -0800, Gaurav Kashyap wrote:
> Testing:
> Test platform: SM8350 HDK/MTP
> Engineering trustzone image (based on sm8350) is required to test this=20
> feature. This is because of version changes of HWKM.
> HWKM version 2 and moving forward has a lot of restrictions on the key=20
> management due to which the launched SM8350 solution (based on v1)=20
> cannot be used and some modifications are required in trustzone.

I've been trying to test this patchset on a SM8350 HDK using the TrustZone =
image you provided, but it's not completely working yet.

This is the kernel branch I'm using:
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=3Dwip-wrapped-=
keys.
It has my v4 patchset with your patchset rebased on top of it, some qcom_sc=
m.c fixes I had to make (see below), and some extra logging messages.

This is how I'm building and booting a kernel on the board:
https://github.com/ebiggers/fscryptctl/blob/wip-wrapped-keys/scripts/sm8350=
-buildkernel.sh

And this is the test script I'm running:
https://github.com/ebiggers/fscryptctl/blob/wip-wrapped-keys/scripts/wrappe=
dkey-test.sh.
It imports or generates a hardware-wrapped key, then tries to set up a dire=
ctory
on an ext4 filesystem that is encrypted with that key.   This uses new
'fscryptctl' commands to access the new blk-crypto ioctls; the version of '=
fscryptctl' on the branch the scripts are on has all the needed changes.

QCOM_SCM_ES_IMPORT_ICE_KEY, QCOM_SCM_ES_GENERATE_ICE_KEY, QCOM_SCM_ES_PREPA=
RE_ICE_KEY, all seem to work.  However, QCOM_SCM_ES_DERIVE_SW_SECRET doesn'=
t work; it always returns -EINVAL.

For example:

Importing hardware-wrapped key
[  187.606109] blk-crypto: entering BLKCRYPTOCREATEKEY [  187.611648] calli=
ng QCOM_SCM_ES_IMPORT_ICE_KEY; raw_key=3D5858585858585858585858585858585858=
585858585858585858585858585858
[  187.628180] QCOM_SCM_ES_IMPORT_ICE_KEY succeeded; longterm_wrapped_key=
=3Dfab51aa07fb6c2bf2fea60a8120e8d35a9e53865b594e0fb6279e7951a34864591f1c1c4=
e26f9421039377c1ac311ff9241a0152030000000000000000000000
[  187.646433] blk-crypto: exiting BLKCRYPTOCREATEKEY; ret=3D0 Preparing ha=
rdware-wrapped key [  187.653129] blk-crypto: entering BLKCRYPTOPREPAREKEY =
[  187.660356] calling QCOM_SCM_ES_PREPARE_ICE_KEY; longterm_wrapped_key=3D=
fab51aa07fb6c2bf2fea60a8120e8d35a9e53865b594e0fb6279e7951a34864591f1c1c4e26=
f9421039377c1ac311ff9241a0152030000000000000000000000
[  187.680420] QCOM_SCM_ES_PREPARE_ICE_KEY succeeded; ephemeral_wrapped_key=
=3D1fbf5d501854858d6faaf52c9d22bebc576012e40485ba75e7d19e88f74b3400eb1a8836=
e28232939e990df6007659b1241a0152030000000000000000000000
[  187.698791] blk-crypto: exiting BLKCRYPTOPREPAREKEY; ret=3D0 Adding hard=
ware-wrapped key [  187.705515] calling blk_crypto_derive_sw_secret(); wrap=
ped_key_size=3D68 [  187.714075] in qti_ice_derive_sw_secret() [  187.71821=
2] calling qti_ice_hwkm_init() [  187.722157] calling qti_ice_hwkm_init_seq=
uence(version=3D1)
[  187.727715] setting standard mode
[  187.731134] checking BIST status
[  187.734464] configuring ICE registers [  187.738230] disabling CRC check=
 [  187.741479] setting RSP_FIFO_FULL bit [  187.745247] calling qcom_scm_d=
erive_sw_secret() [  187.749920] calling QCOM_SCM_ES_DERIVE_SW_SECRET; wrap=
ped_key=3D1fbf5d501854858d6faaf52c9d22bebc576012e40485ba75e7d19e88f74b3400e=
b1a8836e28232939e990df6007659b1241a0152030000000000000000000000, secret_siz=
e=3D32 [  187.768834] QCOM_SCM_ES_DERIVE_SW_SECRET failed with error -22 [ =
 187.774838] blk_crypto_derive_sw_secret() returned -22
error: adding key to /mnt: Invalid argument


You can see that the wrapped_key being passed to QCOM_SCM_ES_DERIVE_SW_SECR=
ET matches the ephemeral_wrapped_key that was returned earlier by QCOM_SCM_=
ES_PREPARE_ICE_KEY, and that secret_size is 32.  So the arguments are as ex=
pected.  However, QCOM_SCM_ES_DERIVE_SW_SECRET still fails.

This still occurs if QCOM_SCM_ES_GENERATE_ICE_KEY is used instead of QCOM_S=
CM_ES_IMPORT_ICE_KEY.

Have you tested that QCOM_SCM_ES_DERIVE_SW_SECRET is working properly?

For reference, these are the fixes I had to apply to qcom_scm.c to get thin=
gs working until that point.  This included fixing the direction of the fir=
st arguments to the SCM calls, and fixing the return values.  Note, I also =
tested leaving QCOM_SCM_ES_DERIVE_SW_SECRET using QCOM_SCM_RO instead of QC=
OM_SCM_RW, but the result was still the same --- it still returned -EINVAL.

diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c inde=
x d57f52015640..002b57a1473d 100644
--- a/drivers/firmware/qcom_scm.c
+++ b/drivers/firmware/qcom_scm.c
@@ -1087,7 +1087,7 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, =
u32 wrapped_key_size,
        struct qcom_scm_desc desc =3D {
                .svc =3D QCOM_SCM_SVC_ES,
                .cmd =3D  QCOM_SCM_ES_DERIVE_SW_SECRET,
-               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RW,
                                         QCOM_SCM_VAL, QCOM_SCM_RW,
                                         QCOM_SCM_VAL),
                .args[1] =3D wrapped_key_size, @@ -1148,7 +1148,7 @@ EXPORT=
_SYMBOL(qcom_scm_derive_sw_secret);
  * This SCM calls adds support for the generate key IOCTL to interface
  * with the secure environment to generate and return a wrapped key..
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
                            u32 longterm_wrapped_key_size) @@ -1188,7 +1188=
,7 @@ int qcom_scm_generate_ice_key(u8 *longterm_wrapped_key,
        dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
                          longterm_wrapped_keybuf, longterm_wrapped_key_phy=
s);

-       return ret;
+       return ret ?: longterm_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_generate_ice_key);

@@ -1209,7 +1209,7 @@ EXPORT_SYMBOL(qcom_scm_generate_ice_key);
  * with the secure environment to rewrap the wrapped key with an
  * ephemeral wrapping key.
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
                             u32 longterm_wrapped_key_size, @@ -1219,7 +121=
9,7 @@ int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
        struct qcom_scm_desc desc =3D {
                .svc =3D QCOM_SCM_SVC_ES,
                .cmd =3D  QCOM_SCM_ES_PREPARE_ICE_KEY,
-               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RW,
                                         QCOM_SCM_VAL, QCOM_SCM_RW,
                                         QCOM_SCM_VAL),
                .args[1] =3D longterm_wrapped_key_size, @@ -1270,7 +1270,7 =
@@ int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
        dma_free_coherent(__scm->dev, longterm_wrapped_key_size,
                          longterm_wrapped_keybuf, longterm_wrapped_key_phy=
s);

-       return ret;
+       return ret ?: ephemeral_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_prepare_ice_key);

@@ -1289,7 +1289,7 @@ EXPORT_SYMBOL(qcom_scm_prepare_ice_key);
  * the secure environment to import a raw key and generate a longterm
  * wrapped key.
  *
- * Return: 0 on success; -errno on failure.
+ * Return: size of the resulting key on success; -errno on failure.
  */
 int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
                            u8 *longterm_wrapped_key, @@ -1298,7 +1298,7 @@=
 int qcom_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
        struct qcom_scm_desc desc =3D {
                .svc =3D QCOM_SCM_SVC_ES,
                .cmd =3D  QCOM_SCM_ES_IMPORT_ICE_KEY,
-               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RO,
+               .arginfo =3D QCOM_SCM_ARGS(4, QCOM_SCM_RW,
                                         QCOM_SCM_VAL, QCOM_SCM_RW,
                                         QCOM_SCM_VAL),
                .args[1] =3D imported_key_size, @@ -1344,7 +1344,7 @@ int q=
com_scm_import_ice_key(const u8 *imported_key, u32 imported_key_size,
        dma_free_coherent(__scm->dev, imported_key_size, imported_keybuf,
                          imported_key_phys);

-       return ret;
+       return ret ?: longterm_wrapped_key_size;
 }
 EXPORT_SYMBOL(qcom_scm_import_ice_key);
