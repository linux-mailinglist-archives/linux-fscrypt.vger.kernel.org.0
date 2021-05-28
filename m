Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F85C3945DB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 May 2021 18:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhE1Q2m (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 May 2021 12:28:42 -0400
Received: from mx0b-00148503.pphosted.com ([148.163.159.21]:54774 "EHLO
        mx0a-00148503.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235676AbhE1Q2l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 May 2021 12:28:41 -0400
Received: from pps.filterd (m0086146.ppops.net [127.0.0.1])
        by mx0b-00148503.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 14SFuvT9028044;
        Fri, 28 May 2021 09:27:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proofpoint.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2019-08-07;
 bh=sxBoOdzW3zY83qaAo9/BassuOiWLxnCInHzBHRmANBA=;
 b=wrD8604nu6r7ZasG9Sk8V8PZQpvew1MHI8K6nQb1WkCJQgETIlJLn1qS8mELxpbrwudR
 JbG9mtmINlj8THIpVFz2J1Tj04ouM6W4n9EHwbZrPAb+DDkXO5d9U8w07xThpOEQNAp3
 F0atRDwgxTkx6HNuPfs3gTvK3ezIJgdUKEG/RaMGXTY8kHyqpu888DfRLeNgja4ZYzXw
 EUQvQ7Abis6pf+fs1uuRw0sK0L0VfhccQ6ccV46D5pRq9kdA/9um7hv8M19z7i9XT4rL
 fCwNalmlElXHF3o+KLMb/XaiqXaCHyoK61V8Kfs4vT+/BaDrcGxdJ9nh9VEctHnjYs9k TA== 
Received: from lv-exch02.corp.proofpoint.com (spf-mailers.proofpoint.com [136.179.16.100])
        by mx0b-00148503.pphosted.com with ESMTP id 38th8mrc9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 09:27:04 -0700
Received: from lv-exch06.corp.proofpoint.com (10.19.10.26) by
 lv-exch02.corp.proofpoint.com (10.94.30.38) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Fri, 28 May 2021 09:26:58 -0700
Received: from lv-exch04.corp.proofpoint.com (10.19.10.24) by
 lv-exch06.corp.proofpoint.com (10.19.10.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Fri, 28 May 2021 09:26:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.19.16.20) by
 lv-exch04.corp.proofpoint.com (10.19.10.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 09:26:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbwNVRr9dnTrsb6/mPvQ+6SkYD1H/fvDXKU8THDhs3ER99FrYgBMvE95ykvZqDfteyzOV0xsFA+X2VNZqnEiiJUMNIlF3EDPSvW4WckRHmBEDZNoHqLQ+sDmmURXNRz9JX7UHn8Xg9mQpAl7Yr9tKjZrI96YF2G0vOVoH+8sdCVwJb2wDI9OOmtNqbIcUvj+ibYoWIsRj01PsBEi4muO8DtUld/+IsZ2JTj0JfUqc0w09X/ZpqVmTtzGudRGrfFf9TLsRffrnTTD/1qJutfxMjDWpAT0CH2j5hemUmc25kuqpykJFGkiMD4kf/2zXM2PcCf/LBJ1cLkZlIyu0aIfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxBoOdzW3zY83qaAo9/BassuOiWLxnCInHzBHRmANBA=;
 b=BFGeox06Pdb3/gX9ttxs2f4ZIJK8vD9Zc5UY2bG3OOK7MP7QVzCZbO3XumrSLQDn+xcjduviBOrf+yL7i9sqnl9kpFXqnWiosejjJF+CP3yRyo4ljeWC6TJI7S3UVOG+l85Pu6GJbNDXon3SSvp7ZLCg5MNEWINLDqCa9iOkQp8uDaT9l+SlJvOpcfEvL7K1+y6aVoHXHpJyJkaTT8Facl9Mf1OL+yWIQd1pQTtP4P4jaCS0WIMjq5heje9DjiPqXuY/agIFzufcLm0hcogLcemB5++ucsyU7QhBrgULh2sLfCS/Devf0S6PQfSsuYEhvh75LmhDXKlr5/LYC4ck3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=proofpoint.com; dmarc=pass action=none
 header.from=proofpoint.com; dkim=pass header.d=proofpoint.com; arc=none
Received: from BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17)
 by BL1PR12MB5352.namprd12.prod.outlook.com (2603:10b6:208:314::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 16:26:56 +0000
Received: from BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6]) by BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6%6]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 16:26:56 +0000
From:   Jerry Chung <jchung@proofpoint.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: RE: Is fscrypt encryption FIPS compliant?
Thread-Topic: Is fscrypt encryption FIPS compliant?
Thread-Index: AddTM+XKfcaaSuVkSxWD1s/3Vj6PAwAIkYgAAByTTTAABVSusA==
Date:   Fri, 28 May 2021 16:26:56 +0000
Message-ID: <BL1PR12MB5334640D3CB4D8124DD95594A0229@BL1PR12MB5334.namprd12.prod.outlook.com>
References: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
 <YLA1eIEOi3yHWk4X@gmail.com>
 <BL1PR12MB53345FE179D9FA84F0231F3AA0229@BL1PR12MB5334.namprd12.prod.outlook.com>
In-Reply-To: <BL1PR12MB53345FE179D9FA84F0231F3AA0229@BL1PR12MB5334.namprd12.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=proofpoint.com;
x-originating-ip: [208.84.67.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e2c2303-f00c-475f-aba3-08d921f56906
x-ms-traffictypediagnostic: BL1PR12MB5352:
x-microsoft-antispam-prvs: <BL1PR12MB535281B53C3B419687B2E4E4A0229@BL1PR12MB5352.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1seZaWjU1yIpeoSYoBEJV4K3dIFgYisggHt5SG4eU37W9x7GNbhKZkrKEHxknRkH62rAcnIqzdHGbjdRXA6Jt4TwI5hO4Tm6DZM5fsdrBKrrCMvsW5VCP/yoy6Gidx6XwrgNCf9gWvlRA/tYkd1mAKj60ZXLsMK3a/R7vv7s1ZrBMU4sgJakCI3vmM6M3cWm+QtOxHnZQyvRduSxVu5lKxDgkRTxiCsObztnHbCbVBu98EHClBgzAnlSTueCTtZFKsipafcwn5//AdCW9ikpEHGf/1Ncpnn+bLxlWmYdww3/MLgTiy3ypsmzbNc3mJ9iH3jWgWItGJK8g3e/EdH4hDlIxALYIX16gbG2fYUW8m67usgmTf2jq8oDnc9lSdPo7Wm8qeBoAoCYBLBRnc5/x3qIfmjUlZGi6a4/WauvY5BcEhlSetGhMUuQcIqzZ8F9x/cSLvrxkesW7gsQoS5gviBF+mRZmLIGZXOAMsPEMYv08zN97Pm4n5OEnA8TpeC90tn5ZifviKBqr+Ctp5SwBlIG7pgNI3LBqmtBbccSDhEyT9n+kOIyRrBI4Ucpv2Yh4Nz+81TYSBYd6rTRVLIlAriwmqZKbD3tACYzOcjOJnQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5334.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39860400002)(4744005)(83380400001)(2940100002)(478600001)(38100700002)(55016002)(8936002)(8676002)(5660300002)(33656002)(9686003)(7696005)(71200400001)(52536014)(86362001)(122000001)(6506007)(6916009)(53546011)(66446008)(76116006)(66556008)(26005)(66476007)(64756008)(2906002)(316002)(186003)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JxGiaFKWW8vt93oC9V8sWjb90lqvRBC5ZcSmdE7Y9KefdzG14rqVdP88eaKp?=
 =?us-ascii?Q?ijcc/lh6wSF7xC8lNlatRResZX5mKfCjGPwnVCnPHTc7/auQJApKcnCS8ZqX?=
 =?us-ascii?Q?OWj8ioEoUQlxvhGL2MnCH/A0Cuq1Q0IFMVrEw9vvND5PL9XKFht54ReAF0SN?=
 =?us-ascii?Q?qepbhjSNRHXveCZpiENvcH2KB2FYZEtkcMNzBB8wPY4fJgpgHWwusvap98Dw?=
 =?us-ascii?Q?YF9E7Ee1y7HGiRTu3wI2sAGRCgyCvTwlM4kylJpn0f1pNKdUTHkYndmqOt8t?=
 =?us-ascii?Q?evb4OjgqMgiQVTsB2165g886a1qNZ+VIDRVtRlOG4N9V1bmtda9Ohb6S4Wdp?=
 =?us-ascii?Q?cEdntADSOJbzGHgMMfYoTPhvRSs+Ogkh2k5YZxi359n82pfyurnguY2SK+HY?=
 =?us-ascii?Q?FsctQUomTGgoT3YWEFbjH7/iW+lnZvuAubrvzqKyv3u6hW1MspJthu87L3ZY?=
 =?us-ascii?Q?jWOWWqSpZe1rUX0s/lBn7wlVE8m48he+OULGQ8mYNskGnBYxFl1ESQROeopC?=
 =?us-ascii?Q?iZGDC7vs6/suB539RudsnyR4Vyq1mFEXkhFsJY/pF8VI03KzC02utPclWNdN?=
 =?us-ascii?Q?RDIvsah0SVOGS6m10tq4NasKDNZQTaTtrxr5Gn0oDCGlVza44xXYacMK6rdx?=
 =?us-ascii?Q?Ov+Vt02FNANfu49NndOyrTy2xPfjpmreKkaA8z/pjcX55NIoi0C6BChweTN7?=
 =?us-ascii?Q?zGu7l1rsQjICFA/CplzFbS1wNZSPwIDJGJa4JfKSUPdl5ko/fFpqO1m9K0aq?=
 =?us-ascii?Q?h0DabDDrDLgNX0hIXj1z5sst0rIbqJaivUhh4jpKDtIxKlgJgXA+qsiDSTya?=
 =?us-ascii?Q?tOVxLBRblmvxZdrrwFxZ+4DS1utHkxPQoqurNIcdjHkAv9VKiM9TmSh90EOp?=
 =?us-ascii?Q?E9U+VI+El/kJrnRuyB9OJL7AJlzxp6Q9IeQEBdnlEV7soZT5KVcom1UHLH06?=
 =?us-ascii?Q?ByXzHkyV2F6WsCDqhtrnnYmly0uE+epKhFK35NSxrexXBE3roSalg9b0CLxU?=
 =?us-ascii?Q?a5NwNamX8ulTRYPdSD3b/TLNl9F5CScI8NZr0zf7ziCP523H5I1IOUg7bq6v?=
 =?us-ascii?Q?+FPUaTDGq4oyJbX7ixJXhXQrGpOtItF9srf54DpLucuhJK+DcQNhCY/fs39L?=
 =?us-ascii?Q?avqYiuRCWNyL/e2jvG+3oAdqksVtp/7kfcF0qg/hAdHMhNfqDXYhn7DId8FU?=
 =?us-ascii?Q?FuWy9VPOZphlOKzQaf6yAz7Kuypxfvi3LDyYP40Asgfiv5lVDiUSTY+A9553?=
 =?us-ascii?Q?HhCtk8eK+hf0OGplqOuonKemjV7ZRRNfmZhoBvUcRWhPMH2QQqtMK8pSM10+?=
 =?us-ascii?Q?aso=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5334.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2c2303-f00c-475f-aba3-08d921f56906
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 16:26:56.1090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46785c73-1c32-414b-86bc-fae0377cab01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kByOGGG7wCv1/yaoXichqMOBWHDpe8V2MEBXwm1qsYp5OMTF6Fw5yTap6wZ1bL3RGfNypAWgXj3Z5QhsHSHwKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5352
X-PassedThroughOnPremises: Yes
X-OriginatorOrg: proofpoint.com
X-Proofpoint-GUID: XwSFCuAmZPAtlnlpGzRmPFlN1fEshGur
X-Proofpoint-ORIG-GUID: XwSFCuAmZPAtlnlpGzRmPFlN1fEshGur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.136,Aquarius:18.0.761,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-05-28_05,2021-05-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 mlxlogscore=906 impostorscore=0 phishscore=0 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280110
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

Does fscrypt (kernel part and userspace part) implement any encryptions by =
itself? Or is it relying on the kernel crypto API?

Thanks,
jerry
-----Original Message-----
From: Jerry Chung=20
Sent: Friday, May 28, 2021 9:55 AM
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Subject: RE: Is fscrypt encryption FIPS compliant?

Thanks for the information.

jerry
-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Thursday, May 27, 2021 8:13 PM
To: Jerry Chung <jchung@proofpoint.com>
Cc: linux-fscrypt@vger.kernel.org
Subject: Re: Is fscrypt encryption FIPS compliant?

On Thu, May 27, 2021 at 08:08:20PM +0000, Jerry Chung wrote:
> Hi Team,
>=20
> I am considering to use `fscrypt` to encrypt directory files and just won=
dered if fscrypt encryption is complaint with FIPS. If so, would it be poss=
ible to get the CMVP number for that? If not, is there any plan to get the =
certification?
>=20
> Thanks,
> Jerry Chung

No, there is no plan to certify fscrypt (kernel part or userspace part) as =
a FIPS cryptographic module.

- Eric
