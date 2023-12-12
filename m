Return-Path: <linux-fscrypt+bounces-79-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 205AF80E335
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 05:10:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 430181C2199C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 04:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E833C2EE;
	Tue, 12 Dec 2023 04:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gXzo4jp/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC53DA9;
	Mon, 11 Dec 2023 20:10:04 -0800 (PST)
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BBNvZ2J022866;
	Tue, 12 Dec 2023 04:10:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=oXeSyanwy4okRJ/6RRC/xMrRJVQ56JYiwFuor52DNvg=; b=gX
	zo4jp/D+ppKJqc/kRkWrmedhEOl2CPks953diIBpepuF4aw6f0CVA7MUFSc6MMo0
	HpYmnSrQ0pDPN9pOhZVRstsCj4XlWSSyehpoCSo7l99Y5DLkOdes17nCYyhtNR3Y
	EnDFGLVVx+JUFSjDWrMKIUC9ofHA3MxH5ENmYVBMVzuzl/9V01pQJ7zJf14iy0kD
	HPRvziFGfaeutnw/N6IC+1lQLnepnXAyHmRdkhZz7ObdbyEsbk7BZtKPJk1PJhUx
	oYAZuxzNPHtt92eAz6vzlzwzGvADwot3qGswVPY1ELPLeRUMmHEQbLQNs6uv27vX
	vv0GdT8a+9MAizQnc+xw==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ux1pdj1cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 04:10:02 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aAKDbxOOHdIo3+J0NQT/jIjjn+2u8jeFQmvEIumXRw19F6DgHc6kOn9kSCwqtSOVOw2ynKd0RGzqZ7kOZBSaA2istJNN1CHBM9EGBcR3SWcdM76OanxwCdwYHo+yAdI4yYRicWKz+JN3eEjiE+DDYi5rVDEs2oxG2nwgvjZiqQtVKxQkZPmj65VF7kLCRSHn8/0nJR5l9HoSrBxqbQHIsFV4dFEJYaARCJ1K9oSpIuzy8gk/iJz44j/VBUbO/qTMFN5LhEndQFCNuudZFC99Xddv6mKhQFSrcgYJqwNkoK7ADED43CvK0nKuRD4iTehjKUKOtA27guhRgsnx/Pm5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXeSyanwy4okRJ/6RRC/xMrRJVQ56JYiwFuor52DNvg=;
 b=mFcHFiv/OR6giqbbVSwV3UMWX0JKBP8DuQ+jui4XMGoLBRXpt04beHSCAbXMm8Q1TulHknKAs3GX23WkAgD5dswxcTT+jE3IWpoXZdCKQ/xsIs/1oLsZahDNkTE0rs5HAkQvkf12Z0a9lz0UCcCzUrCT8qAhCJ0YDmvlh83PdcZkeuXQHMmx3Sa7NwroXoEMtHrc5WIqg/l1nruu16FhjIf1oXjfj8+bdI4EyNJBd9Gk06geihN0UzlzQhEBRgecUkUheVAhyIb2gCkwHBrJiZkaB8q/Fc62M7FXv6LnpyVhKL9hV/x52bX91eWP/3mj8f/1Y86mm8FunFssJ4inRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by DS0PR02MB10251.namprd02.prod.outlook.com (2603:10b6:8:1b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 04:09:57 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20%4]) with mapi id 15.20.7068.031; Tue, 12 Dec 2023
 04:09:57 +0000
From: Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To: "Om Prakash Singh (QUIC)" <quic_omprsing@quicinc.com>,
        "Gaurav Kashyap
 (QUIC)" <quic_gaurkash@quicinc.com>,
        "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
        "srinivas.kandagatla@linaro.org" <srinivas.kandagatla@linaro.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Om Prakash
 Singh <omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)"
	<quic_psodagud@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>,
        kernel
	<kernel@quicinc.com>
Subject: RE: [PATCH v3 02/12] qcom_scm: scm call for deriving a software
 secret
Thread-Topic: [PATCH v3 02/12] qcom_scm: scm call for deriving a software
 secret
Thread-Index: AQHaHQZ/5prfuk/wREmqH4+1cKTclbCfCFWAgAYenNA=
Date: Tue, 12 Dec 2023 04:09:57 +0000
Message-ID: 
 <BYAPR02MB40716781FF68532F71F1E35BE28EA@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-3-quic_gaurkash@quicinc.com>
 <30a12c5e-8336-43e8-9bca-1180e046af1e@quicinc.com>
In-Reply-To: <30a12c5e-8336-43e8-9bca-1180e046af1e@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR02MB4071:EE_|DS0PR02MB10251:EE_
x-ms-office365-filtering-correlation-id: 52ad1968-63e9-4c06-6093-08dbfac833dc
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 odrI8AcomIOYvFw4KmRtqfJuDV6BxIPsFJ4nhx6ejkKIFA7EOmDaJ5awicYRV5ea/s42bi1W++I/VajUPJIhguRzn1Cw8tLoyfuPOvqwfjBbkopudVyvZkir5aZdAf1BXqFx1/H/TkCG6SB49LuiaCW68J2mXP496RLWpCwgaVTsrzG+b98aTj/VRkedEuna9qJMj1HaFH0O0LBNyRd680eZKbjYDzjVtzJKUFuCsRM8vpMYwJ8p16+bOKtqsGs1yv70JcobbJJio3aAruCI3yn6ZhLRJLhVaTBfjGom7j3/DPdo9DegA/XZDxB/TjZ5g/SykONRrVJzAqLzEPHXjlYnovayxIT8GymJ8IzP4N7FVo+yQHYYn4d5w2MeQNWFgJ9Gj/qW9wNnnNJsuTho8FW0ETQClC3wQBqPjodYCX52/pmVXMevs1TgtjuZr1YLm4bwTl8eqHX2AGgSITYxN7hebAFog58Bu0XCx8PiQ2i19X7uFQd9u8slCDGZU215OIDXYIQ4/Q2PQNBr/VvD8LWhR2rheE939INLPkZZXYdfPqrp8LYmhF9TYHtXlkuiQWQB8OfNAW0W7qB9f/gyNXS2NSdc5GlCrIZlzgjKKXfRNGONtQbiOgS5ksE7ZT1qmtLvPuRHd6qYFdMA578ZmQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(83380400001)(122000001)(38100700002)(86362001)(41300700001)(5660300002)(2906002)(8676002)(4326008)(8936002)(52536014)(54906003)(76116006)(110136005)(9686003)(64756008)(66556008)(66946007)(53546011)(6506007)(7696005)(26005)(478600001)(66446008)(107886003)(66476007)(316002)(71200400001)(38070700009)(33656002)(55016003)(219293001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?U2hQNDB6azdwWnFWRm12dy9lRFgxd08vdStueGJaL3JIMjBPNnhyelljZTVa?=
 =?utf-8?B?SE83Rk5hVzhFNVgrWjhxU0dTdUtTQ3ltS0tZZVpoa1A2WlZXdGJ5WlVqYVVz?=
 =?utf-8?B?TUtMRTZ2cDZDSVFMNVRpczF5bG5DbHM0L0tLRFN6RElGaTJxZTdrcHJuVjFO?=
 =?utf-8?B?NTA4OFNMTDhNZWU3M3dEYVlqK3lVQ3RiN2hSWEswckEwQ3FleHMrYm01N2dj?=
 =?utf-8?B?NDFSeW9zdndMUk1GVUxTdHQ0eUw3UjBzNzJyc2tHRWpqSmN0VE9wSGpBTlFa?=
 =?utf-8?B?RzBYK01ka3JTQisvVmsvWDJ6Yi9PQlVPckdtNFVTWW1BZmMwK0VWZ015WUMz?=
 =?utf-8?B?VWdRZ280Vkd0MGZEeFZPSEFPSjlRYWNoVWErV1R3K2F3dUNtckpNMzFxK2tW?=
 =?utf-8?B?TFppRUlORmVIbDg4VTFIa3QxY1NPcmNzUkwyNUF4S0U3alExYTl6NWlXQXhI?=
 =?utf-8?B?NTBIRDRLYURRQ1FhUTBDUXQwK1ZkY1UyaHBmYnZnVVJmdnNtbnNNbHZ3NWty?=
 =?utf-8?B?aTIyQ1dQTDdwTUxyQTNtQ01KbStmazRJSFBkdDh6cUZ0MnN1b3dvQ0NVMFZt?=
 =?utf-8?B?YzBUSEpIWDc2YU02Wm9VYnlmY09adWhua1M5TlV0elJEdGNDMzd4SEMzM3M5?=
 =?utf-8?B?YTFMbWdUa2c2Tm5WWnRyUjhjVXRrWkxpeEljSkljVldtUFZmOTVRQTU3d1BX?=
 =?utf-8?B?bnh6K0pBZHJnRmk4RnFoVG9WbTA3WERwbjhRNm5ZZGFBdVMxcFRTQkhiMmVi?=
 =?utf-8?B?UmlaeTFzTXVZYzBBZ2NzM1FJQ0JsL1NERW96aWpkb0Q0NVA5NnAwRHcvUkwr?=
 =?utf-8?B?NXlBN2M0M3NnRGJjSG1aS2dKQzYwd0hJS0RHMEhNSjJuT0RIaTIyRVM0WmFi?=
 =?utf-8?B?YnNjdDJnRFBCb3QyNzBjZHNUY09XeEF1NnQ3d1d1TGxIUFYxcmZOWlZ5bzR6?=
 =?utf-8?B?bVZ2eExKRVVqNVRaQUJVam5VWVgwMCthNTVWQzFqNGU5VS9jdGErQXVqc1FL?=
 =?utf-8?B?MEZRWU9kSVFEa1ZBQ0c1RUJQamxCMnhIWTUyd3NhOE5mZUIzdVg1UU16WklN?=
 =?utf-8?B?aXQzdEt0U0pGUHVMeXZzUG5JLzlZZk82WlBaNGI5dHlnMzc3b3QxWm5lK3Iv?=
 =?utf-8?B?NzRJeWZLUEZOaS9nU0hNaWFnL0Q3ZHQ2Z3A3QWNHaUtkOFVubmhtQ1FacVV6?=
 =?utf-8?B?RlBNQURsd2ozVlN5S2RuczVvSldjYTViYWx6ci9OaUJyNm53YVBibmd4S2lm?=
 =?utf-8?B?bkJCazhnWUhsak5TaFFyWTJKa0V1bEJRRi9BVlJ2c0lDYTNPYTdhNnZjM3F6?=
 =?utf-8?B?akx4eEZEVVlwbDdDTWNmaHF1M3N0b3kybkUvNUMycFpmcDNudEkxNUpkTDNs?=
 =?utf-8?B?Q05Qakc5Nks5dy82NmhmUkZpVVYrUTNyOHRUNmk3OCsvVmk1ZE93Q3M0QVdZ?=
 =?utf-8?B?N1BYZVpuU2w2bFJPbmRCbitOcDFRNkdZbENKbUJ3UWZmSEZNKzQvd2VQMHZI?=
 =?utf-8?B?QXYzajgrYnVlbXgvODFEWmJBWE0yNXhwQ0dKaU9SUTdWek4yQW9BQmQ2MzVo?=
 =?utf-8?B?REdiOEFWWG9MUmRwTXY5UG5XMEZQS0hpWkViWm1jbjBrdjh6THRJT1dtS2M0?=
 =?utf-8?B?T2F3K0twWlJpT045RTZuTmlJOHZ2RGVEaUtKbzUzTXNEMys4eEFlUXQ2cC9p?=
 =?utf-8?B?TTRmRDQyV2NqRnVrR3d0SmowRFo2TzRqZGxWQ01jZWx3cDVyM2Z0ZlovZitk?=
 =?utf-8?B?bmxYOXFUdzRTU2E2UlFtS3p2QndiMldMNmROME9vSFhraDRBWlRhTE1IdHgx?=
 =?utf-8?B?Kzg2UnllN2JnMzF4WVhhbkh6b0JxTFdjR2F3R1FHekFoL1FjYWNvc09rL211?=
 =?utf-8?B?UGU2R0l1MndQcnVTUUZ4b0FoME8xUWlRVzJtVWsxRjRQaWdMNjlRNHZzQUp0?=
 =?utf-8?B?SVJxbkdsa1hncm9CSThVZ3V1MkxVeFFMTk56ZXdSWEpZbWNCc1hsdjdFcFA1?=
 =?utf-8?B?ejc2Sy9oeUZydEg1K3pwcXRLZlVYSjBtS0J0cUlTNk1HaXhDTzlNcDlrTkVu?=
 =?utf-8?B?MEpYTC9MTk03L3FGT0o0WXJUQUFyREVuSytKNEsrbW9VZkt4UDEzSy8yYk4w?=
 =?utf-8?Q?Szrt507X3Qg4va23JR4wRmFI6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5qUOey+yQ7aUxdKTD6xv+zeSTTjCxmDQmeTGlXZ0hEXHSjeRM6ByhTR4xMyZAGSi0lkd6DV4/5T2No994ljR3JNdRoMb2cQnsPrXFl0f9vQ2Xm3AcbfegPsrvR3vRcf7iYz95Wdsqkrax8mn0H2SWKe/bDnZlWoviK/O3CiOJmLWcyfORIocD1l3W/3h50YrYT1H3qtj779zMwnZalWBZlEi+w+dgZnmBd77+qKiec3LPZhrI+8cGUKEV8Sv1eFYUExvF9M/yT6rBspaGXM6YcHlBaOJEHRuORcxbqHNRyB4gYbKpPLofoMuHlXf5RbzcLODc0RMQnvoxwKQLi9E1iD4QXmKS6Is/xxIruVme9c2G6FQH/KPIGsJgYi3VCfa95ARaGo2dXY3FVFF62NhRw/bbwEr8ZKbhlZgaNrFmPqueB8HB6EFKjwWAvtVsNHxekOttpRuKejpYTJPsOw+tQSwBtutpBTfZOSz5uCGTXh24/BT+hCynSuqu2xsAtFE+od43p3Gl1BEB96vIMuceT62oJdv4yYT+lEkps3Mvop2e/ZpXk1EgYDELnraCLWXc8fQ5/2ABKDem50xtsmdFoCHK8j8M3Vm4v7+fAKYbql7qd8GuBuVnpjZ22CnupiIrsS9AqFxWf0/fPQ5FQElUFM4FCFp7XVflfSWvU5ddSy1EGlt+k9JJVck710d6W5ov9NW09sr8ljSdD1Nqtye0nZCmHt841J6v7T4qD3gva8vTcHgvIx1SIl7+Jv0+noFHHN8DBCckqjRgN3mi2cWhjoDQIQFuLSuDtt//2rcuQ2gxu2IdS8qj8Bn9QGCRStqF9+xE3XOwa39T3mJSWnzDA==
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ad1968-63e9-4c06-6093-08dbfac833dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2023 04:09:57.2965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DKGF+SmAM7ZA+keizvpt86tLkk7Ypy21eI4scl3qkBqoSICKpz7jSIxfKzgTjHC0Gr1Dbp/QxnUe8bV6PD86vojp4paawMGF5Cn3olNVZG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10251
X-Proofpoint-GUID: 0G9Emwyg1lzvyY6ewOqDThGbbPsrHTvL
X-Proofpoint-ORIG-GUID: 0G9Emwyg1lzvyY6ewOqDThGbbPsrHTvL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312120032

SGVsbG8gT20sDQoNCk9uIDEyLzA3LzIwMjMsIE9tIFByYWthc2ggU2luZ2ggd3JvdGU6DQo+IE9u
IDExLzIyLzIwMjMgMTE6MDggQU0sIEdhdXJhdiBLYXNoeWFwIHdyb3RlOg0KPiA+IElubGluZSBz
dG9yYWdlIGVuY3J5cHRpb24gcmVxdWlyZXMgZGVyaXZpbmcgYSBzdyBzZWNyZXQgZnJvbSB0aGUN
Cj4gPiBoYXJkd2FyZSB3cmFwcGVkIGtleXMuIEZvciBub24td3JhcHBlZCBrZXlzLCB0aGlzIGNh
biBiZSBkaXJlY3RseSBkb25lDQo+ID4gYXMga2V5cyBhcmUgaW4gdGhlIGNsZWFyLg0KPiA+DQo+
ID4gSG93ZXZlciwgd2hlbiBrZXlzIGFyZSBoYXJkd2FyZSB3cmFwcGVkLCBpdCBjYW4gYmUgdW53
cmFwcGVkIGJ5DQo+IEhXS00NCj4gPiAoSGFyZHdhcmUgS2V5IE1hbmFnZXIpIHdoaWNoIGlzIGFj
Y2Vzc2libGUgb25seSBmcm9tIFF1YWxjb21tDQo+ID4gVHJ1c3R6b25lLiBIZW5jZSwgaXQgYWxz
byBtYWtlcyBzZW5zZSB0aGF0IHRoZSBzb2Z0d2FyZSBzZWNyZXQgaXMgYWxzbw0KPiA+IGRlcml2
ZWQgdGhlcmUgYW5kIHJldHVybmVkIHRvIHRoZSBsaW51eCBrZXJuZWwgLiBUaGlzIGNhbiBiZSBp
bnZva2VkDQo+ID4gYnkgdXNpbmcgdGhlIGNyeXB0byBwcm9maWxlIEFQSXMgcHJvdmlkZWQgYnkg
dGhlIGJsb2NrIGxheWVyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogR2F1cmF2IEthc2h5YXAg
PHF1aWNfZ2F1cmthc2hAcXVpY2luYy5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2Zpcm13
YXJlL3Fjb20vcWNvbV9zY20uYyAgICAgICB8IDcxDQo+ICsrKysrKysrKysrKysrKysrKysrKysr
KysrDQo+ID4gICBkcml2ZXJzL2Zpcm13YXJlL3Fjb20vcWNvbV9zY20uaCAgICAgICB8ICAxICsN
Cj4gPiAgIGluY2x1ZGUvbGludXgvZmlybXdhcmUvcWNvbS9xY29tX3NjbS5oIHwgIDIgKw0KPiA+
ICAgMyBmaWxlcyBjaGFuZ2VkLCA3NCBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9maXJtd2FyZS9xY29tL3Fjb21fc2NtLmMNCj4gPiBiL2RyaXZlcnMvZmlybXdh
cmUvcWNvbS9xY29tX3NjbS5jDQo+ID4gaW5kZXggNTIwZGU5YjU2MzNhLi42ZGZiOTEzZjNlMzMg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9maXJtd2FyZS9xY29tL3Fjb21fc2NtLmMNCj4gPiAr
KysgYi9kcml2ZXJzL2Zpcm13YXJlL3Fjb20vcWNvbV9zY20uYw0KPiA+IEBAIC0xMjE0LDYgKzEy
MTQsNzcgQEAgaW50IHFjb21fc2NtX2ljZV9zZXRfa2V5KHUzMiBpbmRleCwgY29uc3QgdTgNCj4g
KmtleSwgdTMyIGtleV9zaXplLA0KPiA+ICAgfQ0KPiA+ICAgRVhQT1JUX1NZTUJPTF9HUEwocWNv
bV9zY21faWNlX3NldF9rZXkpOw0KPiA+DQo+ID4gKy8qKg0KPiA+ICsgKiBxY29tX3NjbV9kZXJp
dmVfc3dfc2VjcmV0KCkgLSBEZXJpdmUgc29mdHdhcmUgc2VjcmV0IGZyb20gd3JhcHBlZA0KPiA+
ICtrZXkNCj4gPiArICogQHdrZXk6IHRoZSBoYXJkd2FyZSB3cmFwcGVkIGtleSBpbmFjY2Vzc2li
bGUgdG8gc29mdHdhcmUNCj4gPiArICogQHdrZXlfc2l6ZTogc2l6ZSBvZiB0aGUgd3JhcHBlZCBr
ZXkNCj4gPiArICogQHN3X3NlY3JldDogdGhlIHNlY3JldCB0byBiZSBkZXJpdmVkIHdoaWNoIGlz
IGV4YWN0bHkgdGhlIHNlY3JldA0KPiA+ICtzaXplDQo+ID4gKyAqIEBzd19zZWNyZXRfc2l6ZTog
c2l6ZSBvZiB0aGUgc3dfc2VjcmV0DQo+ID4gKyAqDQo+ID4gKyAqIERlcml2ZSBhIHNvZnR3YXJl
IHNlY3JldCBmcm9tIGEgaGFyZHdhcmUgd3JhcHBlZCBrZXkgZm9yIHNvZnR3YXJlDQo+ID4gK2Ny
eXB0bw0KPiA+ICsgKiBvcGVyYXRpb25zLg0KPiA+ICsgKiBGb3Igd3JhcHBlZCBrZXlzLCB0aGUg
a2V5IG5lZWRzIHRvIGJlIHVud3JhcHBlZCwgaW4gb3JkZXIgdG8NCj4gPiArZGVyaXZlIGENCj4g
PiArICogc29mdHdhcmUgc2VjcmV0LCB3aGljaCBjYW4gYmUgZG9uZSBpbiB0aGUgaGFyZHdhcmUg
ZnJvbSBhIHNlY3VyZQ0KPiA+ICtleGVjdXRpb24NCj4gPiArICogZW52aXJvbm1lbnQuDQo+ID4g
KyAqDQo+ID4gKyAqIEZvciBtb3JlIGluZm9ybWF0aW9uIG9uIHN3IHNlY3JldCwgcGxlYXNlIHJl
ZmVyIHRvICJIYXJkd2FyZS13cmFwcGVkDQo+IGtleXMiDQo+ID4gKyAqIHNlY3Rpb24gb2YgRG9j
dW1lbnRhdGlvbi9ibG9jay9pbmxpbmUtZW5jcnlwdGlvbi5yc3QuDQo+ID4gKyAqDQo+ID4gKyAq
IFJldHVybjogMCBvbiBzdWNjZXNzOyAtZXJybm8gb24gZmFpbHVyZS4NCj4gPiArICovDQo+ID4g
K2ludCBxY29tX3NjbV9kZXJpdmVfc3dfc2VjcmV0KGNvbnN0IHU4ICp3a2V5LCBzaXplX3Qgd2tl
eV9zaXplLA0KPiA+ICsJCQkgICAgICB1OCAqc3dfc2VjcmV0LCBzaXplX3Qgc3dfc2VjcmV0X3Np
emUpIHsNCj4gPiArCXN0cnVjdCBxY29tX3NjbV9kZXNjIGRlc2MgPSB7DQo+ID4gKwkJLnN2YyA9
IFFDT01fU0NNX1NWQ19FUywNCj4gPiArCQkuY21kID0gIFFDT01fU0NNX0VTX0RFUklWRV9TV19T
RUNSRVQsDQo+ID4gKwkJLmFyZ2luZm8gPSBRQ09NX1NDTV9BUkdTKDQsIFFDT01fU0NNX1JXLA0K
PiA+ICsJCQkJCSBRQ09NX1NDTV9WQUwsIFFDT01fU0NNX1JXLA0KPiA+ICsJCQkJCSBRQ09NX1ND
TV9WQUwpLA0KPiA+ICsJCS5hcmdzWzFdID0gd2tleV9zaXplLA0KPiA+ICsJCS5hcmdzWzNdID0g
c3dfc2VjcmV0X3NpemUsDQo+ID4gKwkJLm93bmVyID0gQVJNX1NNQ0NDX09XTkVSX1NJUCwNCj4g
PiArCX07DQo+ID4gKw0KPiA+ICsJdm9pZCAqd2tleV9idWYsICpzZWNyZXRfYnVmOw0KPiA+ICsJ
ZG1hX2FkZHJfdCB3a2V5X3BoeXMsIHNlY3JldF9waHlzOw0KPiA+ICsJaW50IHJldDsNCj4gPiAr
DQo+ID4gKwkvKg0KPiA+ICsJICogTGlrZSBxY29tX3NjbV9pY2Vfc2V0X2tleSgpLCB3ZSB1c2Ug
ZG1hX2FsbG9jX2NvaGVyZW50KCkgdG8NCj4gcHJvcGVybHkNCj4gPiArCSAqIGdldCBhIHBoeXNp
Y2FsIGFkZHJlc3MsIHdoaWxlIGd1YXJhbnRlZWluZyB0aGF0IHdlIGNhbiB6ZXJvaXplIHRoZQ0K
PiA+ICsJICoga2V5IG1hdGVyaWFsIGxhdGVyIHVzaW5nIG1lbXplcm9fZXhwbGljaXQoKS4NCj4g
PiArCSAqLw0KPiA+ICsJd2tleV9idWYgPSBkbWFfYWxsb2NfY29oZXJlbnQoX19zY20tPmRldiwg
d2tleV9zaXplLA0KPiAmd2tleV9waHlzLCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghd2tleV9i
dWYpDQo+ID4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ID4gKwlzZWNyZXRfYnVmID0gZG1hX2FsbG9j
X2NvaGVyZW50KF9fc2NtLT5kZXYsIHN3X3NlY3JldF9zaXplLA0KPiAmc2VjcmV0X3BoeXMsIEdG
UF9LRVJORUwpOw0KPiA+ICsJaWYgKCFzZWNyZXRfYnVmKSB7DQo+ID4gKwkJcmV0ID0gLUVOT01F
TTsNCj4gPiArCQlnb3RvIGVycl9mcmVlX3dyYXBwZWQ7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJ
bWVtY3B5KHdrZXlfYnVmLCB3a2V5LCB3a2V5X3NpemUpOw0KPiA+ICsJZGVzYy5hcmdzWzBdID0g
d2tleV9waHlzOw0KPiA+ICsJZGVzYy5hcmdzWzJdID0gc2VjcmV0X3BoeXM7DQo+ID4gKw0KPiA+
ICsJcmV0ID0gcWNvbV9zY21fY2FsbChfX3NjbS0+ZGV2LCAmZGVzYywgTlVMTCk7DQo+ID4gKwlp
ZiAoIXJldCkNCj4gPiArCQltZW1jcHkoc3dfc2VjcmV0LCBzZWNyZXRfYnVmLCBzd19zZWNyZXRf
c2l6ZSk7DQo+ID4gKw0KPiA+ICsJbWVtemVyb19leHBsaWNpdChzZWNyZXRfYnVmLCBzd19zZWNy
ZXRfc2l6ZSk7DQo+ID4gKw0KPiA+ICsJZG1hX2ZyZWVfY29oZXJlbnQoX19zY20tPmRldiwgc3df
c2VjcmV0X3NpemUsIHNlY3JldF9idWYsDQo+ID4gK3NlY3JldF9waHlzKTsNCj4gPiArDQo+ID4g
K2Vycl9mcmVlX3dyYXBwZWQ6DQo+ID4gKwltZW16ZXJvX2V4cGxpY2l0KHdrZXlfYnVmLCB3a2V5
X3NpemUpOw0KPiBJbiBlcnJvciBoYW5kbGluZyBjYXNlIHRoZSBvcGVyYXRpb24gaXMgYmVpbmcg
cGVyZm9ybWVkIG9uIHVuYWxsb2NhdGVkDQo+IG1lbW9yeS4NCg0KVGhlIGZsb3cgY29tZXMgaGVy
ZSBvbmx5IHdoZW4gc2VjcmV0X2J1ZiBhbGxvY2F0aW9uIGZhaWxzLg0KQW5kIGF0IHRoYXQgcG9p
bnQsIHdrZXlfYnVmIGlzIGFscmVhZHkgYWxsb2NhdGVkLg0KV2tleV9idWYgZmFpbHVyZSBlcnJv
cnMgb3V0IGRpcmVjdGx5IGFmdGVyIGFsbG9jYXRpb24gZmFpbHVyZS4NCg0KPiA+ICsNCj4gPiAr
CWRtYV9mcmVlX2NvaGVyZW50KF9fc2NtLT5kZXYsIHdrZXlfc2l6ZSwgd2tleV9idWYsDQo+IHdr
ZXlfcGh5cyk7DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHJldDsNCj4gPiArfQ0KPiA+ICtFWFBPUlRf
U1lNQk9MKHFjb21fc2NtX2Rlcml2ZV9zd19zZWNyZXQpOw0KPiA+ICsNCj4gPiAgIC8qKg0KPiA+
ICAgICogcWNvbV9zY21faGRjcF9hdmFpbGFibGUoKSAtIENoZWNrIGlmIHNlY3VyZSBlbnZpcm9u
bWVudCBzdXBwb3J0cw0KPiBIRENQLg0KPiA+ICAgICoNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9maXJtd2FyZS9xY29tL3Fjb21fc2NtLmgNCj4gPiBiL2RyaXZlcnMvZmlybXdhcmUvcWNvbS9x
Y29tX3NjbS5oDQo+ID4gaW5kZXggNDUzMjkwN2U4NDg5Li5jNzU0NTZhYTZhYzUgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9maXJtd2FyZS9xY29tL3Fjb21fc2NtLmgNCj4gPiArKysgYi9kcml2
ZXJzL2Zpcm13YXJlL3Fjb20vcWNvbV9zY20uaA0KPiA+IEBAIC0xMjEsNiArMTIxLDcgQEAgaW50
IHNjbV9sZWdhY3lfY2FsbChzdHJ1Y3QgZGV2aWNlICpkZXYsIGNvbnN0IHN0cnVjdA0KPiBxY29t
X3NjbV9kZXNjICpkZXNjLA0KPiA+ICAgI2RlZmluZSBRQ09NX1NDTV9TVkNfRVMJCQkweDEwCS8q
IEVudGVycHJpc2UNCj4gU2VjdXJpdHkgKi8NCj4gPiAgICNkZWZpbmUgUUNPTV9TQ01fRVNfSU5W
QUxJREFURV9JQ0VfS0VZCTB4MDMNCj4gPiAgICNkZWZpbmUgUUNPTV9TQ01fRVNfQ09ORklHX1NF
VF9JQ0VfS0VZCTB4MDQNCj4gPiArI2RlZmluZSBRQ09NX1NDTV9FU19ERVJJVkVfU1dfU0VDUkVU
CTB4MDcNCj4gPg0KPiA+ICAgI2RlZmluZSBRQ09NX1NDTV9TVkNfSERDUAkJMHgxMQ0KPiA+ICAg
I2RlZmluZSBRQ09NX1NDTV9IRENQX0lOVk9LRQkJMHgwMQ0KPiA+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL2xpbnV4L2Zpcm13YXJlL3Fjb20vcWNvbV9zY20uaA0KPiA+IGIvaW5jbHVkZS9saW51eC9m
aXJtd2FyZS9xY29tL3Fjb21fc2NtLmgNCj4gPiBpbmRleCBjY2FmMjg4NDYwNTQuLmM2NWYyZDYx
NDkyZCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2Zpcm13YXJlL3Fjb20vcWNvbV9z
Y20uaA0KPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvZmlybXdhcmUvcWNvbS9xY29tX3NjbS5oDQo+
ID4gQEAgLTEwMyw2ICsxMDMsOCBAQCBib29sIHFjb21fc2NtX2ljZV9hdmFpbGFibGUodm9pZCk7
DQo+ID4gICBpbnQgcWNvbV9zY21faWNlX2ludmFsaWRhdGVfa2V5KHUzMiBpbmRleCk7DQo+ID4g
ICBpbnQgcWNvbV9zY21faWNlX3NldF9rZXkodTMyIGluZGV4LCBjb25zdCB1OCAqa2V5LCB1MzIg
a2V5X3NpemUsDQo+ID4gICAJCQkgZW51bSBxY29tX3NjbV9pY2VfY2lwaGVyIGNpcGhlciwgdTMy
DQo+IGRhdGFfdW5pdF9zaXplKTsNCj4gPiAraW50IHFjb21fc2NtX2Rlcml2ZV9zd19zZWNyZXQo
Y29uc3QgdTggKndrZXksIHNpemVfdCB3a2V5X3NpemUsDQo+ID4gKwkJCSAgICAgIHU4ICpzd19z
ZWNyZXQsIHNpemVfdCBzd19zZWNyZXRfc2l6ZSk7DQo+ID4NCj4gPiAgIGJvb2wgcWNvbV9zY21f
aGRjcF9hdmFpbGFibGUodm9pZCk7DQo+ID4gICBpbnQgcWNvbV9zY21faGRjcF9yZXEoc3RydWN0
IHFjb21fc2NtX2hkY3BfcmVxICpyZXEsIHUzMiByZXFfY250LA0KPiA+IHUzMiAqcmVzcCk7DQo=

