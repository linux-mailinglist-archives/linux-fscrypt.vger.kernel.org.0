Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248F13943A0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 28 May 2021 15:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235543AbhE1N4T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 May 2021 09:56:19 -0400
Received: from mx0a-00148503.pphosted.com ([148.163.157.21]:49426 "EHLO
        mx0a-00148503.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235379AbhE1N4T (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 May 2021 09:56:19 -0400
Received: from pps.filterd (m0086145.ppops.net [127.0.0.1])
        by mx0a-00148503.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 14SDnhwS007751;
        Fri, 28 May 2021 06:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proofpoint.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2019-08-07;
 bh=rChi0sPZ4XVjK0AkjFkEx5zT8GqHvzTPpb+q4gvCnAY=;
 b=tCzhcrCDuKat9/Qs+2N/fIh2GtE6LwGrxX5nxGzzHYPmuh+aY1L3jw4rPv7TEZiHpVXD
 BdaVtmeY71HHRDCPICGdj9Jut3lMdLXvBn8no8NSDsuMDvSx5T0PdaQRrCBJ90k0FvM8
 cgBEASjVAQrurKwWKQU/hRYMF6O1iW3bnZn2uYgu1M7TCL3XR4lJMGEP9yzeoxXmHHnL
 53/Urxpeec+Tur8fIVq53C5w67E/v6hMbfdeAOqvXFNJByu8juS9ZkF2Dd+KZtWgDRWy
 YYdG5Kil4FJqKSo4IWtWD7IjykyJ50B9mAA+kWfqVCwrbCUWOux5tB9f6U9YAc6ASbqU yQ== 
Received: from lv-exch04.corp.proofpoint.com (spf-mailers.proofpoint.com [136.179.16.100])
        by mx0a-00148503.pphosted.com with ESMTP id 38t2a7gn1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 28 May 2021 06:54:43 -0700
Received: from lv-exch03.corp.proofpoint.com (10.19.10.23) by
 lv-exch04.corp.proofpoint.com (10.19.10.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2; Fri, 28 May 2021 06:54:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.19.16.20) by
 lv-exch03.corp.proofpoint.com (10.19.10.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2176.2 via Frontend Transport; Fri, 28 May 2021 06:54:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FybWZDkgGcYpYAwPtobcz4a8ElvfNbIQT0DYlmnRFzLgJYVzgR1DIfjFItXw+rtb7TZ+oySnr9CRNCAxsxBucm9+VG6Dt1usaSb4XjsFwsyllC+LqAlT71x5lh0qS/V+AzTnb9BwIqTKsiDFmtIOgvV/pg4DuZBTBywONEtyncxbCZRhJx47hokRPpeYtpttSQCLNOLlEbwaSshP0iQt1a3RIENVq+Phq6paEkm360BomjdKmz9AStC1Ij8qEu17iih/z+sOiyMt9niQOhtzT4Bv36O1rjkrHV2x8kGyhyzZQ9PW4XOkxgQbyIO6h4ywam4jGr8vG7dg7j85WCq7kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rChi0sPZ4XVjK0AkjFkEx5zT8GqHvzTPpb+q4gvCnAY=;
 b=gXhQJKtoHzhsaZ7IbeBVio5EHRAWDsH9Gf5Eu1byc7dy2rcFRKyH5sAajp2jclnGLoZxlg4+jhxeqkIxpyNNvbFoowd5QM8mU3LHK+ueKHt7Mj+Zkc4oVTHTV1RPM/A36SyXMR8K+g0dh7ZLVK3Lq7Y2vmKFWMVTCc/ENFApHV+v86RFADiGUwzJe9yWCY+0k+1oAkXCCgs0G1DZ34m+s3m94ZswIFAIKdESfJJoovV98lhT5rrbIm5vkPRPnm6HlNV5DyCwcx1HQUVfQYCnWU5od3dd703X2gvAA7yQC0Ks4fHZGLA2yfLVWPC1sLc8MZO/NVpyBcRWDKIrJtXEJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=proofpoint.com; dmarc=pass action=none
 header.from=proofpoint.com; dkim=pass header.d=proofpoint.com; arc=none
Received: from BL1PR12MB5334.namprd12.prod.outlook.com (2603:10b6:208:31d::17)
 by BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 13:54:40 +0000
Received: from BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6]) by BL1PR12MB5334.namprd12.prod.outlook.com
 ([fe80::d47:bc49:42ca:11a6%6]) with mapi id 15.20.4173.022; Fri, 28 May 2021
 13:54:40 +0000
From:   Jerry Chung <jchung@proofpoint.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: RE: Is fscrypt encryption FIPS compliant?
Thread-Topic: Is fscrypt encryption FIPS compliant?
Thread-Index: AddTM+XKfcaaSuVkSxWD1s/3Vj6PAwAIkYgAAByTTTA=
Date:   Fri, 28 May 2021 13:54:40 +0000
Message-ID: <BL1PR12MB53345FE179D9FA84F0231F3AA0229@BL1PR12MB5334.namprd12.prod.outlook.com>
References: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
 <YLA1eIEOi3yHWk4X@gmail.com>
In-Reply-To: <YLA1eIEOi3yHWk4X@gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=proofpoint.com;
x-originating-ip: [208.84.67.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a425e1b8-698f-409a-e593-08d921e02391
x-ms-traffictypediagnostic: BL1PR12MB5144:
x-microsoft-antispam-prvs: <BL1PR12MB51447C86116378FBC476C086A0229@BL1PR12MB5144.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XgYzu6/HXdWA37aAFVtF1Wa9cYXpBhKfi4du8NObKCYboo3DWcqBU1fTQ7Tz5lH37piJw5d04Gj4KCvvk7/79Q5qGKzPRIXQ9VHJre7+g0k8Vd1QziGqrLdf8nBByx9azPphCxxnNmiwEJlsGqQWu5krWy9bbz9MomSFIjcbbwCd+9owJ0Dj9P8Lies1OivSWJDvatvnZUs5aJ3LxorGbNfb8S2UyxYAicvatgcDvx0LabdgigKezpalSTmIYSC9od1yfV7dJqFqy8usjUhebnEM9ZcRzNIhh9fpkPWSekdcUzgGRVUbHZXk3ri7c/uOH0yGdHaCY7glEXHYrtjgTuqgBN9FFMcylmWBTAvUMa95o8LpqMLeX+YR4DQCTezybHX7lT1m9dqrL7pBxOaM7h2TWkPxyBi+iEZq2/yvtwBsJ47b2Z+U0KDApVWWV0+KCFk95rU6Uy2vXIE+ttwzJZWEZlcbucYmIZmlgKGs1Q144CRzhZl1255+BNis/JfaXEGWOYNGJZUQ5MVaJqR/luEQdK+0nbztBZMpeMtVIRu304jBQ2Bh9MvO7cvsWWYeneUAarqNVJ9YpbXB9BSJj4yqKi+JWCyk1r2CyDfVAjg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5334.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(64756008)(66446008)(76116006)(66946007)(66556008)(26005)(2906002)(186003)(4326008)(55016002)(38100700002)(8936002)(4744005)(498600001)(8676002)(83380400001)(6506007)(52536014)(122000001)(86362001)(9686003)(6916009)(33656002)(5660300002)(53546011)(7696005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cAeXrL0ySIqT/yboMOvfGvHkK6avKmuest0LPaNLWQ2kkSknb7f1uCJZ6Jax?=
 =?us-ascii?Q?XqbbQpp9TkQP+qcqk9D3A1+52yM/v1a1m+OMTw5lVz60IJAB4hqXOxE/Ge+u?=
 =?us-ascii?Q?Q5CZFJZjVWZaLC8GKKElv/CPIHjmxCElbdqvXzjkF7L7sCQrugVgW+bZ8uye?=
 =?us-ascii?Q?XYFh70AG0+shY58yiU0pz3AArRyNHY/T738FpcUQBEvmrM99dcuoeH1KYzaX?=
 =?us-ascii?Q?AK9S094JXEsFL4EU/RjQ7nGTdITcgWwD5eMva67JsUi9f/NzBbC2b6lr7rTK?=
 =?us-ascii?Q?1dc+he/Gz7rhaQpEA5ZxgarFWQXHDna09Dddpt3kKSNIkdP4KGjNvlD9z1Qe?=
 =?us-ascii?Q?Mi7UDvg14pnsuNdeOHeeH6ngXib847TfLEMyH4R5xXW4h8UQIJncVEOZEF4n?=
 =?us-ascii?Q?VpAO9UfzrEIEJlIjy7N6Ytg4lQ+IhPJ7rDmWdhg5qd7yhYZBg3dX0LG2NiAx?=
 =?us-ascii?Q?xpB+soGpmuSGDDji2hDPEYDTTOtlJJxLFaYsjlcIfIY4kIvdmVgyLoYxfK0E?=
 =?us-ascii?Q?b3WgMq/LCpcaa+AGo0t/x64IcOsCPv9aXfkujV8KxTqWTgHpHrUySIyIMoXW?=
 =?us-ascii?Q?P0UthJsHfrkm8NznhrQA8XTepN1L+3pZAQgTBKEVmUPFACBqP95RTzgYxc8K?=
 =?us-ascii?Q?oNvR8PYdXndAlfAguUXMRVr5gIrrYTg6YY0izM42aVqVxTVwhRC2TkSA5j85?=
 =?us-ascii?Q?oEMJXtg1GtGpPld+8voT9Ag6Ux3PFu+UIXZxzd0wcdsba0jCz/HtEem8CEI1?=
 =?us-ascii?Q?JPZoT4Ssz89vOMXxNF3l6FL2yOL1R+tjDrL5t15YgKMsNt6n0rxLTEWuDZMa?=
 =?us-ascii?Q?6QA3ldY1MUgmIlhRGfPDOhtDAmQ3V5GNGtCAzOA+Fxhq9s2wHIOjw94BqRWS?=
 =?us-ascii?Q?I5EB33RrfL/R0aI1GQxv+ZOcsf0/TcJu9IE690Ibj2H8emyCh6jB/BX9r4Sa?=
 =?us-ascii?Q?12Tqu7PIPrcjxQ0XVNhEGKoNiaesmj9Govs0pvc9BpxqId928hUHcsf7jSqh?=
 =?us-ascii?Q?lanCkyC0LC845VNWGdWIw/4FAY/o2c4GawkU3Ar32p/mD8/HDelrd3N4Hn5l?=
 =?us-ascii?Q?4n9btQOw0R6WMoFGqlNYHsKrAv/Z0kxXDLdSWE5PJdxQh3XU69HzaMu05ctK?=
 =?us-ascii?Q?EWJkg5MnR0G0ylMGE/ADuFmJTliXWLwJ1NG3ugwYezoS+o9C4uJOn9zKs9Y+?=
 =?us-ascii?Q?mjznT92qJvf6Zn45Yo++3MCHQ4LdqwJD0LM95NxgEa8fRB4vBpLN73jKnjCc?=
 =?us-ascii?Q?VWTPTOH98HTOsUrow6BPy4giBn7l8RPeRxC15pHcM87yCgIK29Bz7zrtJ1um?=
 =?us-ascii?Q?N9w=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5334.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a425e1b8-698f-409a-e593-08d921e02391
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 13:54:40.1655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46785c73-1c32-414b-86bc-fae0377cab01
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9yQMIHHrLYXcC2fp6hYpLjoI/FUNjI9z7fJ/onuqg3jrGFIAtAT+ZqehrSTliKrpwTvopG0RW5J88Rqhn1zqlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5144
X-OriginatorOrg: proofpoint.com
X-PassedThroughOnPremises: Yes
X-Proofpoint-GUID: CKBOpC1bz6fsBZ6EEVEQmhZoYZm1sfET
X-Proofpoint-ORIG-GUID: CKBOpC1bz6fsBZ6EEVEQmhZoYZm1sfET
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.136,Aquarius:18.0.761,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-05-28_05,2021-05-27_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 impostorscore=0
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=840
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105280093
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

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
