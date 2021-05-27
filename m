Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82A3937C1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 May 2021 23:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhE0VJW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 May 2021 17:09:22 -0400
Received: from mx0a-00148503.pphosted.com ([148.163.157.21]:2700 "EHLO
        mx0a-00148503.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233387AbhE0VJV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 May 2021 17:09:21 -0400
X-Greylist: delayed 3564 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2021 17:09:21 EDT
Received: from pps.filterd (m0086145.ppops.net [127.0.0.1])
        by mx0a-00148503.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 14RJH1h6021825
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 May 2021 13:08:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proofpoint.com; h=from : to :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2019-08-07;
 bh=9ML7T3RsCfVdhkzWRxvSlFLnpSUyMsUKDzEjzVxU2Ao=;
 b=G3MZN1rLuuINbdeaUapUjnulkjEBrNTyqv+akAfufXE39HaW9tVeHYHqGtD0eTbErYX9
 A3R7AZkma/EWJ+FoP2sFSOQiZfD+l/Url+gPOry3sTgiuzu0BXj5oJp5dwlUnPeeGvfb
 l8GV81Oj9WCBZCoBASjcWyXaCCnCGzX/Ik8/H80PEMXlFqZjc6bIl0h5gt4F14ESSU36
 Lq3VVwRnxuD+Cb+eq/RuxxM6O++UP8XaRpQX0m8AGkxWyicbRFMA3s84yfiCWQAbGaf7
 fkuaT1dtYPMjBkYmvy2oVOXmqnhSaJuH3LuAtUALlmy9dnJxi67O7dxQM3gAMsUpSRww pA== 
Received: from lv-exch01.corp.proofpoint.com (spf-mailers.proofpoint.com [136.179.16.100])
        by mx0a-00148503.pphosted.com with ESMTP id 38t2a7gbc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 May 2021 13:08:23 -0700
Received: from lv-exch04.corp.proofpoint.com (10.19.10.24) by
 lv-exch01.corp.proofpoint.com (10.94.30.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Thu, 27 May 2021 13:08:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.19.16.20) by
 lv-exch04.corp.proofpoint.com (10.19.10.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2 via Frontend Transport; Thu, 27 May 2021 13:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zspo71+DuGm/w8dTLt6jWaQvTSM7mNsXvRA1gxHHAq/xPppCcdxAbREq1nL3cmObrsEn1Oe0p/ZhFe0dzZSmexi9vx0/KwaUWWUQ+sKDqDW47jI4OtWwvd3W/inIFnNOH+rLzpEdDuBZngFkIdAZOmi1sZLtYgQBGlIYtjtJmAo2bfB1e+B/NNWpjaTd8CsjhvcnaGIj6wZoDuA/xL5BMS14MNgVOltJrk33bvpa80vV2lyRKuBpA+IlMeQJZyD8Q4E5/bHUELxXb+GOYFmwU/cLXLb2nP6yf09CeMZAD1jo7cKgoeHeGHRwhb19dddXShDik7bHL4Qb2D3PSsCEUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ML7T3RsCfVdhkzWRxvSlFLnpSUyMsUKDzEjzVxU2Ao=;
 b=TZ0JHCkfQ1aOssEhaPgwDVloor+40sC81+mickxl37Ns/Kmldqu6wonkZYRHuW9qS8uyS3goRVTftdxnZ07QoJ7l2FBAV+ht85Gyj7IdqbompTG/bhgnhTa6yR/a5BV0939O3eIpIkMwtyzHPENus9GByIhJJLywGJfSkZil3PYjqCPmmxpPtVOXGWfokEefR17TqqFWUI3zMuTxAii3zgmL7rij2cdNoWGm/ojOxtGIBJL9HR5acOe8FBz+y+GhBq1VoLqfIVn3o/a+cwIZS96VRvNO7wtOdqYLw/Tqz/Dk7LtbfqxpEuXbeB93MECyiSRiJYuqQnKTTTE3LEGMWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=proofpoint.com; dmarc=pass action=none
 header.from=proofpoint.com; dkim=pass header.d=proofpoint.com; arc=none
Received: from BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 27 May
 2021 20:08:20 +0000
Received: from BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6]) by BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6%6]) with mapi id 15.20.4173.022; Thu, 27 May 2021
 20:08:20 +0000
From:   Jerry Chung <jchung@proofpoint.com>
To:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Is fscrypt encryption FIPS compliant?
Thread-Topic: Is fscrypt encryption FIPS compliant?
Thread-Index: AddTM+XKfcaaSuVkSxWD1s/3Vj6PAw==
Date:   Thu, 27 May 2021 20:08:20 +0000
Message-ID: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=proofpoint.com;
x-originating-ip: [208.84.67.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c22bed64-6aff-4d67-71ce-08d9214b2c78
x-ms-traffictypediagnostic: BL1PR12MB5175:
x-microsoft-antispam-prvs: <BL1PR12MB51757749EDE201FF1F4367AAA0239@BL1PR12MB5175.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: InWW5HSbDLQ0rb24nIm78cBNb9I6m2VTnM5PXLfsHTxGrxeSWTqcsxVSlZRIDpz3hFLSygs2okPvga1veVuEIR0k1w2AiOQ0/89CrC9lQ0RVAzDpdTEWEvAtgri1M8u0VZd3rfJYB60VFqsEqhGRlHlVSpkvV6IaG4fCkeU9bM0ZU72DvpAHXMrwL3r9faYwj2ELuqCW0wGl/jsXn+mfSQZVruw9bFGh9Fp1Uds1IQYLPYiDO1m5uA6rzOCC4a4P7NjiPU/i8Zuchi27PUqvNVWMZmobGoaR4kOBz3bihFQZr2xOQfdd1bqju0pHLsXOmIRjXbJZGg9K7LoIYIXmGXMv4Jn+Qg4xYA3Qa8AJgCPgMNP4un5wzyXgv/Dfd74cLZROCgSi8987jrV+UIX101Iz/99S+4CLTT8iItW/eHvYg1DBRFPuPp0dfJMP8N+vU3i28jj2F36lLqVtFBVjxhsAUCyO9ajgzlXvZkpKbClOsd4v1ZTKVJdvVfvCqYTV6hzSDTgr4DVohPb3OR3gEtAY/yf3N7UU8HnhHKMYLbjtfLaOD4F+VFuIihvMSc0unsB1xGNkeZw920cvsSGV7HHo9Rja5I4zVvimRmranyk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5334.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(376002)(346002)(136003)(478600001)(52536014)(7696005)(38100700002)(8936002)(316002)(9686003)(5660300002)(186003)(122000001)(66946007)(86362001)(55016002)(64756008)(66446008)(2906002)(8676002)(66476007)(66556008)(6916009)(558084003)(71200400001)(76116006)(33656002)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/ewNbC6Q0jdRWVKCsZcammdjccXb8cpHlSGw7rIOiWZ3HSwpxQLlTcBUWWzq?=
 =?us-ascii?Q?OhSEBNtDmAnlgDGRjQDKIHTJyLT7QobwBlL5nfQoYWhzXyTeFfEDPJ0RLjqS?=
 =?us-ascii?Q?+hGJ4ULOzikYFM2XmLwSFPZY4F+3qmrFAdIzRiRq5EEZ8h845T7WYlhSLSxY?=
 =?us-ascii?Q?UsYWQ8JB8ppT1UXs5YU8uD9Lb6EfUpoOTbohIqYyfeuu1hEV2NKsn66u/+IY?=
 =?us-ascii?Q?dvzZnF6my+xXWJasoYBjPrRh0+AI+NjtJ2cHbwnpdvMBf8b8JeXXatJhCebn?=
 =?us-ascii?Q?cmhQfFIyr38EVYvFuAcw46RELwKxwoFJ3zfPeSraqamxKnX+4wB9HJcW+Fcg?=
 =?us-ascii?Q?spNlkyaO7iVfZV1qThoWG90idpeSjM+x3equgVdqWHvAFGeoyoGBh++wXU9J?=
 =?us-ascii?Q?cpQ+hTHXSymyGatrFaQ2YHPiA/bdjY01cYFontqKaGpOvvllSw0FSVCp7o6j?=
 =?us-ascii?Q?Gr6ldmO8iNzozw5YY0ylySmB+rzjGxQ8zIhXW4Ur6pHz0mb1PawT70fTQq+R?=
 =?us-ascii?Q?VbXvFXqyR2e54kX3hmno3NZjhoI3fu7k+Os8HwYYUJIWmNeerz4RLC3eh2nL?=
 =?us-ascii?Q?nAJ4L+j4AnwdzRKTqUT64s9nLxNTp2WlMXJQ74rC1JoFpXA7Op1a2EIDcv8M?=
 =?us-ascii?Q?XdSzDBELEChNlbgSIlP0oWhV7zbXzVPZNA80usuJroOh8zP1tRVDCHfYnRaf?=
 =?us-ascii?Q?FlehcQidOg2I1Fi//PwR3LVKIN72XqV+oXlK3j0ljfYmUxYs/Ryzrv1Itzxd?=
 =?us-ascii?Q?DM+UHy32u+hwMip3LFc6BpORPcHae9pDn+I6Jo+hwc5LZ5NN5J1Azj2yLucT?=
 =?us-ascii?Q?H56e07x9iJatusGlcrvnnEtpESwahREWIeo78ayh1R6p5VwomvdwUfgfEV0e?=
 =?us-ascii?Q?US+s0zaSK7dmcsaFHjoagmM3EpAXbUaWYCpOE3QLrL3JfX3K2DVw/TAwvB3l?=
 =?us-ascii?Q?5UZDXNnXGmwKJ+UpWJLMQbiI0Oueg7q1ufvszqYMApE5RJ19KP8eXXXCJtm5?=
 =?us-ascii?Q?KjipJvRnOlSoaInW1YLhkjxE8+ZL33pI+G2C7OSp+ERuAMuSSUkKd/vH8/A5?=
 =?us-ascii?Q?dnEkn56ghtbcdD7pW66mfspg3NfMvdyxd7+CxJTxpMXw0OYC1hAx8ope+o+G?=
 =?us-ascii?Q?aU6QXI2m1bVJqRsEx+WNQRMX34oIhnkHIEojjYQe7GPD5HI11kWbrWwN9HoH?=
 =?us-ascii?Q?5LA1ETy6VgDekZcqGbEcH4HUjpPblz7tXSL2NIakTrC1eV2LAZtYaKzOuud5?=
 =?us-ascii?Q?+NtCCyb+RKcIkZmQrOQ1i5lz89OUWPT4wTVu/4lEXl64YgkJKLr3bvwRzWNX?=
 =?us-ascii?Q?WS8=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5334.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22bed64-6aff-4d67-71ce-08d9214b2c78
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2021 20:08:20.0427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46785c73-1c32-414b-86bc-fae0377cab01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zNTTvw6Vvt1mza1Wo69cvtYCX9YRx6LaPFoANtMUCoWjhmsvZySaHy7TwEQoN5wQFsrdSq8393VEmGGSc3pWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
X-OriginatorOrg: proofpoint.com
X-PassedThroughOnPremises: Yes
X-Proofpoint-GUID: F_oZtB5H2XCVSBdxFvjBEI0h9ThFOtTP
X-Proofpoint-ORIG-GUID: F_oZtB5H2XCVSBdxFvjBEI0h9ThFOtTP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.136,Aquarius:18.0.761,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-05-27_12,2021-05-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=650
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105270129
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Team,

I am considering to use `fscrypt` to encrypt directory files and just wonde=
red if fscrypt encryption is complaint with FIPS. If so, would it be possib=
le to get the CMVP number for that? If not, is there any plan to get the ce=
rtification?

Thanks,
Jerry Chung
