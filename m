Return-Path: <linux-fscrypt+bounces-78-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58BDC80E32B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 05:05:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B74D1C21965
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 04:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 192A2C2E3;
	Tue, 12 Dec 2023 04:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="AUvOgmek"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BC4E8;
	Mon, 11 Dec 2023 20:05:07 -0800 (PST)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BC3bx4v022274;
	Tue, 12 Dec 2023 04:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=BEEo6NWm3qKoyI1tGcMnlQw1MM3eRUCzxxWDdPLdS7o=; b=AU
	vOgmekgLpBrSx9Q5PTIPJXeWiRUu9VFhB23dAFPsIKcWq1ZH5dWxQZJOgwgYP2sI
	MQjNm3b8yzc+j6oIvqP0H88nHwqkJHftuO36YxbNU9P1TKCFLSr1aKR2KuVLjUND
	+q3d0yaP84lbDw5XEPVjDeWk0IFaWS586LzfY2AnDoxgo60gQlj1Jqt3Onues9Qd
	pGkJf9gcY5FvccHMjw4Kcq1pX3VgWRlWCSHpCmGMZYygfUXkJ1gkxbI2lpMCUJkI
	g5Bre5RFlzmhzeCdmYguW6gIzQtGs4+5c0un4n6A/rOZqd0VmIcPDYXw1/lA/xzW
	Vmb4vTRT/7rvya2cqFRw==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3uxa8jgnfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 04:05:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTDjiZ/PBIuhZ39zB3dZZXGOA+RccuOwHQ2HWqXGW3639RKz8mCVjceb2rQiZwA8nTo98KJrQ4cLxWzwv6/DmGPQ1SDGTONIK1lFJrUOQkWP+4O1AmuQ0YXSBW3t1BsMDE2QAfjVXJDg83ixzAocEsLrIcgndvM+csmD3Xj9HKDNLVbjF5ziBWTuuP0CJ0UTW5U7bL7sPdC+iD+bvq56IFPTyiUbIjRjQmVOnmmVTikzLoaCJitGZ2UtRha0jJ4NCdgj0ngAJzoYwl3KaB6KFsJgnA4+4kneeXJghcQxyNh8bH517dmkUAqRolFz7nCMLLmr47X9e/LePwzUD041HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEEo6NWm3qKoyI1tGcMnlQw1MM3eRUCzxxWDdPLdS7o=;
 b=ExwbwA2ZRJRPfw8006LeW6DJrosusyxij4sU/58ZmxIepLLTFxMi6AeKLWcGKer5ElJ4W5CVCEuo1jy1R+64hS83isD8Rxr/nBohk7rrxcfraxoyVXZIgZxX6E1srqEkt3kX7nKafpr1B6I7eS3BPfOtRoNdAiebmDHElh4HBzJnJkJcuGWHPltQAN1Px0Yz9DQ7R2XV1hSVCgjwt9lobJRP+CyTYWyLxskR0A+w2F0l0EuVpR/O657zjoIxWq/olwOqdfH+J7l5Npik8UsoCjOXZFqhIHZmWA3Wo/KD1hTeFIGId+aKHQcSxdu+20GTb84dEtQkiwS9UZoblD9+7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by DS0PR02MB10251.namprd02.prod.outlook.com (2603:10b6:8:1b4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.32; Tue, 12 Dec
 2023 04:04:57 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20%4]) with mapi id 15.20.7068.031; Tue, 12 Dec 2023
 04:04:55 +0000
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
Subject: RE: [PATCH v3 04/12] soc: qcom: ice: support for hardware wrapped
 keys
Thread-Topic: [PATCH v3 04/12] soc: qcom: ice: support for hardware wrapped
 keys
Thread-Index: AQHaHQaN90T44D/eK028XtLtx1lddrCfGxUAgAYKUDA=
Date: Tue, 12 Dec 2023 04:04:55 +0000
Message-ID: 
 <BYAPR02MB407152355C3B841CC14C2A75E28EA@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-5-quic_gaurkash@quicinc.com>
 <0de13ec3-2b74-46bb-a32a-9066e637d5b1@quicinc.com>
In-Reply-To: <0de13ec3-2b74-46bb-a32a-9066e637d5b1@quicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR02MB4071:EE_|DS0PR02MB10251:EE_
x-ms-office365-filtering-correlation-id: 72a231e8-77ee-4ea8-9c64-08dbfac78028
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 yjVdmedwA0c8X4oh1Mw7aMBRjNJ5jEMdLNEGmwTyOYFlJNJCGaIk6aor4EZcBT4GJO04ubX3i+bFR0LbzDnxh+z+kKJr/qzlHKkaYxxbD3wFyUZUaRZY8r+8CtHXBCRSK0IHUN3DrcNTTmR3KSFXznbPaS5EoYfsUdDyk3RaUAjTywxNowuwEDwNpsW8++wre//AoswRc4MrVxDGIa0DoITIHsfvO3jCLpZIPazKH9KrHbiiWD9n/q/ZEHUXLHGUtf6rzP0Ujcydmtcov+E/agn6dzs73bNcqR8Tlg3auWO8Y6DOIe+hVmxhCk+0fG1H2pdz29ON99aZzIUoPzoYf2NzzysE6AqLvYduKFp/a6htLqIElgPaTMFLKH9MAVpUvlOOLEPJ4why3UfaF1ysP8Tg5AYsmJp++uYziwTJwy+LBKrAKQ/UlQx1paURQBIoNSO9q68hg/TunKCgIkqKWA/MumqHDvwkEWWwwsyQ0FKZgxUjVzOlmkSbMdqWcUtJuRkWJkWgWOf7qWfP4X3S9SpK2RtR00VQFB7E7Av4sFOxtjeUtay8rWuChGQm86BxLp0GEJ7xhgNUvX7ca7cQlxiINAsD4THPbiapn+Vv9SI=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(39860400002)(396003)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(83380400001)(122000001)(38100700002)(86362001)(41300700001)(5660300002)(2906002)(8676002)(4326008)(8936002)(52536014)(54906003)(76116006)(110136005)(9686003)(64756008)(66556008)(66946007)(53546011)(6506007)(7696005)(26005)(478600001)(966005)(66446008)(107886003)(66476007)(316002)(71200400001)(38070700009)(33656002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UWYrc3Npa2JkbWdqWnNBZ1RYSzVYT1Q1ZHFpRWxFY3g0RTBKQmNkQk5QV0xX?=
 =?utf-8?B?TVg2SnhvS25mQ0x1U1U0czVhUWVxZkNrSXRmNzg4ZDI0ZUtOVXNOeWlXZVUx?=
 =?utf-8?B?UzR0N1V5dmJaU093NzRUczFZQndOZHpOYm9BK1ZGMnlIY0ZmamI1NExsV0xk?=
 =?utf-8?B?WVRIK0JVRmVHYXhqL3BIZlJMRTVMZDMxNTBucjJQTXh6TUVHSU1mR2NvM0tz?=
 =?utf-8?B?ZXVWZUtHY1dIZlIydFRicVVvcmg0VzNIb1U5am0wUjlra0hsVGEva3VIVnU0?=
 =?utf-8?B?U29NM0NWYkVFRXlleTNNbkJDSXNCanNUNkhGWjFNYjNvV255MHp4eUtyTkU5?=
 =?utf-8?B?UUJxWnNrbkhGYTFoRDg5b1dpd1RIcUJleW9CWEs3eTlORGRWRzUvUFpYUTY3?=
 =?utf-8?B?V1lXY3RrcG9ONER1bEM5K1JLWDNFeURsN1dMNkZyeEhSbXBxeXg0UWdLRDNX?=
 =?utf-8?B?bTkyN1Z1T084TGxVQUhwSmVaOWVCbTUrQnRWamlDVDl4VmZHUklTMTJ3QXNJ?=
 =?utf-8?B?VGM0LzdEU0phUzhySjF0QWJTREFUMXJhclVuQkF5dnZweVI3VW1ERk1MbzRH?=
 =?utf-8?B?NkFuNFcwbkdNRndERnNFU1poMWRTRUh1ZnlRbHRaRXJyMzdBdlN1QVl5NDNx?=
 =?utf-8?B?RS9EVUpsRXAzYjM3NnJ3V2V4ZytZTDdZZUgzVXc1QitqUUhMNkNkT0t1bjJx?=
 =?utf-8?B?TnpucVpMNVN3YktZWlJ4NWVGTUs0ay9DUi9uUWpCUXo0UjhhSzQ5cE4rVTNt?=
 =?utf-8?B?RjkxdGtjZ2xaRlY4M2RmdmlwU0ZHRWl0QkZwMFlpWUJaQjFpMGhnbzVFWERG?=
 =?utf-8?B?UHRHVHBWMytUVnp0MXlXSDIxbTloN21OcUVqZ2dHdGQvb2Nqa25sWmxyeklo?=
 =?utf-8?B?RXhlbjNlL1FvOTBVRFpUT3B0bmxhU3dnSzloOGZjVGdOYnBmN0tDVEtpZnN5?=
 =?utf-8?B?M3VqSUdyT0hBUlQxemFzOWRET2JFSVJJMXdMUkxXTFFxVkhiK0tWdzRHeFJj?=
 =?utf-8?B?aVlGZVphdGV2SXJ6czd4TU5pZzdsSHB3TGlyYnZzbDhDM3ZZRGtlN3hoK3Iv?=
 =?utf-8?B?Z3N4T1RQVXBTclkrTjNpRDlpdmZtNVl0cktGQjZ5emxHWDhkOXRsMjg4MHVm?=
 =?utf-8?B?QXRQYkQ0YTFiMERRV2NRUXNHRWlGOXRaZG1ydGovbWlxcGtBcVAra2pEaERL?=
 =?utf-8?B?bkV5Z2grbCs1TFZ3TGlCangzMWlacXRISFV2KzRpcHJBcXJZMzZlTmJ3Q3pH?=
 =?utf-8?B?Q3hzMG9xbG5zWkQ1UFJSUEsxTjZ0b29pOEFCK0FCTldOQzZiSk5BZG5tUkQ3?=
 =?utf-8?B?Tldza1R2Z2FHajVtbHphMHlicm91aFIwQjdVb1ZCWFNZdTlGVzcwT1BmRVpS?=
 =?utf-8?B?TFAzeTdmYWs2bFdYYnZSNEY1QVJ5YXJpWlA1U1hKaU5jZ0s0c3BEQS9rM05R?=
 =?utf-8?B?c1Z6c2NnTW4xYUs4dUsrcVRmdy95eSsvVW1Ia0pHRkgxUWZiN2oyeVJsSWJk?=
 =?utf-8?B?SFlOK283YkQyS2lmZE1NYi9yaGpmbEF3YzZmdis0Q01yd0NwaXZwRzFKQTl3?=
 =?utf-8?B?MFZycWtwUFRjblp6TkdReU9HcE52Rms4bkZUcW1PL1FBUEx5eWtYalVGT2kr?=
 =?utf-8?B?Z2RIcXhzT3EzemFTZ2EyMzVlL3VZcXVkekttbXJta2hFVjFqc0ltdXBCb0xk?=
 =?utf-8?B?TnZRK1ZEbFl6OUVkZE4xcDZsK3YzMlRSeE5sQW9kNE0vd05YWXhQV0RhMUVT?=
 =?utf-8?B?cEplUnY2Zjk2bE5qMllscWoxZFdzaThIYkErb0FzUkllMlora2t2RFpwbVRz?=
 =?utf-8?B?d0EzK1RkODFGeDE2cEFHaWZSUWNNOVlCY1BTb1FnVmYwTEk4REZ5VTFyTVJB?=
 =?utf-8?B?TlNUV1BLU3NEWnVBeXlscVIrWnIvYjFnZmEyUFhMSk0wckVPaUJBSVNUVldI?=
 =?utf-8?B?SFBqNTlJOVphZ2NSMkJ0MWcycVZuL0RvSlhaVmM3RmlQK3BVYlBIeVN5Z1Rk?=
 =?utf-8?B?YW5mMHRmb0EreElLYmlyNGl0bGdrR2NhZnM3enhvZUZOZ0h4NkFmZk1IU05r?=
 =?utf-8?B?WDBHdlY0NjhtUXArOEt0MVRkOVh3NVltWkdmdDVSUHVoOEYxVkYxU3ppaXl5?=
 =?utf-8?Q?AMjOeWvBQQTevQKgZZJ6dH4Hm?=
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
	8S4dw22dmuS6xwmq4RoTzBH60t7A8Sw/PXT5lb6deo5vX/5jX0NzIypeWWJFcvyXSyZtutMlkmJtyhYjsOn6OwSls1kbQk6aTxQSjA72DtgLJZyg1C9rJlAoHAthrrRbVquezWeyrnIG5gRS1TMlSe5jGire72hgFsfzK0OxPSFjRnP6oS69m2xggtXRwhb9X28qH6odeZnA56wYFWNJame0Un/w9ifgurV8CE16WUp8KuSGuhRmUHOCyjVZAi9OdAors9etM3cnLYlTT1latXpBqM9B6ddNLvY8B2FI66Dx2tN6jsfK/rGSI+GsBgYILGFddioAjAfqUen8D7HOjlf3vRPwdRHFL7Aqst/0t1AtOEo969Kf1zvPcOgIRCld+fUGtK5oz0JO7HUV4GhlyrhP1GfM9PNxCcMAqUVZs2Zs5bdHstlnfwBJyCZXi/1n/69lIcAO87pLkuvKHtDF1ZS0p9MlQ3HAIQ4VPGdprM40TR1SQDnzmgtST9xkP3QliNStaEjw8ptC26YBTar9b4JiCTVRqzMhpZIEr1A63/5Pv+gM3Acd2gm7Kndng85Q6pJBFH4gCgKS4mRkmoui4Z7xWEDfsa74AwG1u8xT4FENInhO4AFjnSrADcEWLv8+kw34AuETGU0gAQpvjwyzMPtflxpGQhwN1jdNFLejBThBR4RUmZeuZWqIq7EV6BDZj0K80tldYOfe8FP7FRNkbtRjnRWyXE48CTxuf+zEZa9RemiBDHaRQdQ6HIau04M65r4DRLbuzHPUD2DhjcCXEndT5PeO3zWjh5sXvZ0hBm+p+l0mBO774WEYwB+dhl8MMkB5Vb4V2cRlXs59pJy1tQ==
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a231e8-77ee-4ea8-9c64-08dbfac78028
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2023 04:04:55.8186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 90bYHIWNpqW13a3wHnApeZt3G4pzYTbP9tx+WouoLYLvTXdru0vEGijjnFIs27y1HukKpXlCfg8AftyBU8Bkom+fgMKpXQHvnNbPCbHiWA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10251
X-Proofpoint-GUID: -ZR152e6DeOFX1EhCn8zJMySbKMoJbf8
X-Proofpoint-ORIG-GUID: -ZR152e6DeOFX1EhCn8zJMySbKMoJbf8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312120031

SGVsbG8gT20NCg0KT24gMTIvMDcvMjAyMywgT20gUHJha2FzaCBTaW5naCB3cm90ZToNCj4gT24g
MTEvMjIvMjAyMyAxMTowOCBBTSwgR2F1cmF2IEthc2h5YXAgd3JvdGU6DQo+ID4gTm93IHRoYXQg
SFdLTSBzdXBwb3J0IGlzIGFkZGVkIHRvIElDRSwgZXh0ZW5kIHRoZSBJQ0UgZHJpdmVyIHRvDQo+
ID4gc3VwcG9ydCBoYXJkd2FyZSB3cmFwcGVkIGtleXMgcHJvZ3JhbW1pbmcgY29taW5nIGluIGZy
b20gdGhlIHN0b3JhZ2UNCj4gPiBjb250cm9sbGVycyAodWZzIGFuZCBlbW1jKS4gVGhlIHBhdGNo
ZXMgdGhhdCBmb2xsb3cgd2lsbCBhZGQgdWZzIGFuZA0KPiA+IGVtbWMgc3VwcG9ydC4NCj4gPg0K
PiA+IERlcml2ZSBzb2Z0d2FyZSBzZWNyZXQgc3VwcG9ydCBpcyBhbHNvIGFkZGVkIGJ5IGZvcndh
cmRpbmcgdGhlIGNhbGwNCj4gPiB0aGUgY29ycmVzcG9uZGluZyBzY20gYXBpLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogR2F1cmF2IEthc2h5YXAgPHF1aWNfZ2F1cmthc2hAcXVpY2luYy5jb20+
DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL3NvYy9xY29tL2ljZS5jIHwgMTE0DQo+ICsrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+ID4gICBpbmNsdWRlL3NvYy9xY29t
L2ljZS5oIHwgICA0ICsrDQo+ID4gICAyIGZpbGVzIGNoYW5nZWQsIDEwNyBpbnNlcnRpb25zKCsp
LCAxMSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3NvYy9xY29t
L2ljZS5jIGIvZHJpdmVycy9zb2MvcWNvbS9pY2UuYyBpbmRleA0KPiA+IGFkZjljYWI4NDhmYS4u
ZWU3YzBiZWVmM2QyIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvc29jL3Fjb20vaWNlLmMNCj4g
PiArKysgYi9kcml2ZXJzL3NvYy9xY29tL2ljZS5jDQo+ID4gQEAgLTI3LDYgKzI3LDggQEANCj4g
PiAgICNkZWZpbmUgUUNPTV9JQ0VfUkVHX0JJU1RfU1RBVFVTCQkweDAwNzANCj4gPiAgICNkZWZp
bmUgUUNPTV9JQ0VfUkVHX0FEVkFOQ0VEX0NPTlRST0wJCTB4MTAwMA0KPiA+ICAgI2RlZmluZSBR
Q09NX0lDRV9SRUdfQ09OVFJPTAkJCTB4MA0KPiA+ICsjZGVmaW5lIFFDT01fSUNFX0xVVF9LRVlT
X0NSWVBUT0NGR19SMTYJCTB4NDA0MA0KPiA+ICsNCj4gPiAgIC8qIFFDT00gSUNFIEhXS00gcmVn
aXN0ZXJzICovDQo+ID4gICAjZGVmaW5lIFFDT01fSUNFX1JFR19IV0tNX1RaX0tNX0NUTA0KPiAJ
MHgxMDAwDQo+ID4gICAjZGVmaW5lIFFDT01fSUNFX1JFR19IV0tNX1RaX0tNX1NUQVRVUw0KPiAJ
MHgxMDA0DQo+ID4gQEAgLTM3LDYgKzM5LDcgQEANCj4gPiAgICNkZWZpbmUgUUNPTV9JQ0VfUkVH
X0hXS01fQkFOSzBfQkJBQ18zDQo+IAkweDUwMEMNCj4gPiAgICNkZWZpbmUgUUNPTV9JQ0VfUkVH
X0hXS01fQkFOSzBfQkJBQ180DQo+IAkweDUwMTANCj4gPg0KPiA+ICsvKiBRQ09NIElDRSBIV0tN
IEJJU1QgdmFscyAqLw0KPiA+ICAgI2RlZmluZSBRQ09NX0lDRV9IV0tNX0JJU1RfRE9ORV9WMV9W
QUwJCTB4MTENCj4gPiAgICNkZWZpbmUgUUNPTV9JQ0VfSFdLTV9CSVNUX0RPTkVfVjJfVkFMCQkw
eDI4Nw0KPiA+DQo+ID4gQEAgLTQ3LDYgKzUwLDggQEANCj4gPiAgICNkZWZpbmUgUUNPTV9JQ0Vf
Rk9SQ0VfSFdfS0VZMF9TRVRUSU5HX01BU0sJMHgyDQo+ID4gICAjZGVmaW5lIFFDT01fSUNFX0ZP
UkNFX0hXX0tFWTFfU0VUVElOR19NQVNLCTB4NA0KPiA+DQo+ID4gKyNkZWZpbmUgUUNPTV9JQ0Vf
TFVUX0tFWVNfQ1JZUFRPQ0ZHX09GRlNFVAkweDgwDQo+ID4gKw0KPiA+ICAgI2RlZmluZSBRQ09N
X0lDRV9IV0tNX1JFR19PRkZTRVQJMHg4MDAwDQo+ID4gICAjZGVmaW5lIEhXS01fT0ZGU0VUKHJl
ZykJCSgocmVnKSArDQo+IFFDT01fSUNFX0hXS01fUkVHX09GRlNFVCkNCj4gPg0KPiA+IEBAIC02
Nyw2ICs3MiwxNiBAQCBzdHJ1Y3QgcWNvbV9pY2Ugew0KPiA+ICAgCWJvb2wgaHdrbV9pbml0X2Nv
bXBsZXRlOw0KPiA+ICAgfTsNCj4gPg0KPiA+ICt1bmlvbiBjcnlwdG9fY2ZnIHsNCj4gPiArCV9f
bGUzMiByZWd2YWw7DQo+ID4gKwlzdHJ1Y3Qgew0KPiA+ICsJCXU4IGR1c2l6ZTsNCj4gPiArCQl1
OCBjYXBpZHg7DQo+ID4gKwkJdTggcmVzZXJ2ZWQ7DQo+ID4gKwkJdTggY2ZnZTsNCj4gPiArCX07
DQo+ID4gK307DQo+ID4gKw0KPiA+ICAgc3RhdGljIGJvb2wgcWNvbV9pY2VfY2hlY2tfc3VwcG9y
dGVkKHN0cnVjdCBxY29tX2ljZSAqaWNlKQ0KPiA+ICAgew0KPiA+ICAgCXUzMiByZWd2YWwgPSBx
Y29tX2ljZV9yZWFkbChpY2UsIFFDT01fSUNFX1JFR19WRVJTSU9OKTsgQEAgLQ0KPiAyMzcsNg0K
PiA+ICsyNTIsOCBAQCBzdGF0aWMgdm9pZCBxY29tX2ljZV9od2ttX2luaXQoc3RydWN0IHFjb21f
aWNlICppY2UpDQo+ID4gICAJLyogQ2xlYXIgSFdLTSByZXNwb25zZSBGSUZPIGJlZm9yZSBkb2lu
ZyBhbnl0aGluZyAqLw0KPiA+ICAgCXFjb21faWNlX3dyaXRlbChpY2UsIDB4OCwNCj4gPg0KPiAJ
SFdLTV9PRkZTRVQoUUNPTV9JQ0VfUkVHX0hXS01fQkFOSzBfQkFOS05fSVJRX1NUQQ0KPiBUVVMp
KTsNCj4gPiArDQo+ID4gKwlpY2UtPmh3a21faW5pdF9jb21wbGV0ZSA9IHRydWU7DQo+IFRoaXMg
dGhpcyBjaGFuZ2Ugc2hvdWxkIGdvIHdpdGggcHJldmlvdXMgcGF0Y2ggMy8xMi4NCg0KT2theSwg
bWFrZXMgc2Vuc2UuDQoNCj4gPiAgIH0NCj4gPg0KPiA+ICAgaW50IHFjb21faWNlX2VuYWJsZShz
dHJ1Y3QgcWNvbV9pY2UgKmljZSkgQEAgLTI4NCw2ICszMDEsNTEgQEAgaW50DQo+ID4gcWNvbV9p
Y2Vfc3VzcGVuZChzdHJ1Y3QgcWNvbV9pY2UgKmljZSkNCj4gPiAgIH0NCj4gPiAgIEVYUE9SVF9T
WU1CT0xfR1BMKHFjb21faWNlX3N1c3BlbmQpOw0KPiA+DQo+ID4gKy8qDQo+ID4gKyAqIEhXIGRp
Y3RhdGVzIHRoZSBpbnRlcm5hbCBtYXBwaW5nIGJldHdlZW4gdGhlIElDRSBhbmQgSFdLTSBzbG90
cywNCj4gPiArICogd2hpY2ggYXJlIGRpZmZlcmVudCBmb3IgZGlmZmVyZW50IHZlcnNpb25zLCBt
YWtlIHRoZSB0cmFuc2xhdGlvbg0KPiA+ICsgKiBoZXJlLiBGb3IgdjEgaG93ZXZlciwgdGhlIHRy
YW5zbGF0aW9uIGlzIGRvbmUgaW4gdHJ1c3R6b25lLg0KPiA+ICsgKi8NCj4gPiArc3RhdGljIGlu
dCB0cmFuc2xhdGVfaHdrbV9zbG90KHN0cnVjdCBxY29tX2ljZSAqaWNlLCBpbnQgc2xvdCkgew0K
PiA+ICsJcmV0dXJuIChpY2UtPmh3a21fdmVyc2lvbiA9PSAxKSA/IHNsb3QgOiAoc2xvdCAqIDIp
OyB9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHFjb21faWNlX3Byb2dyYW1fd3JhcHBlZF9rZXko
c3RydWN0IHFjb21faWNlICppY2UsDQo+ID4gKwkJCQkJY29uc3Qgc3RydWN0IGJsa19jcnlwdG9f
a2V5ICprZXksDQo+ID4gKwkJCQkJdTggZGF0YV91bml0X3NpemUsIGludCBzbG90KQ0KPiA+ICt7
DQo+ID4gKwlpbnQgaHdrbV9zbG90Ow0KPiA+ICsJaW50IGVycjsNCj4gPiArCXVuaW9uIGNyeXB0
b19jZmcgY2ZnOw0KPiA+ICsNCj4gPiArCWh3a21fc2xvdCA9IHRyYW5zbGF0ZV9od2ttX3Nsb3Qo
aWNlLCBzbG90KTsNCj4gPiArDQo+ID4gKwltZW1zZXQoJmNmZywgMCwgc2l6ZW9mKGNmZykpOw0K
PiA+ICsJY2ZnLmR1c2l6ZSA9IGRhdGFfdW5pdF9zaXplOw0KPiA+ICsJY2ZnLmNhcGlkeCA9IFFD
T01fU0NNX0lDRV9DSVBIRVJfQUVTXzI1Nl9YVFM7DQo+ID4gKwljZmcuY2ZnZSA9IDB4ODA7DQo+
IHVzZSBtYWNybyBmb3IgY29uc3RhbnQgdmFsdWUgIjB4ODAiDQo+ID4gKw0KPiA+ICsJLyogQ2xl
YXIgQ0ZHRSAqLw0KPiA+ICsJcWNvbV9pY2Vfd3JpdGVsKGljZSwgMHgwLCBRQ09NX0lDRV9MVVRf
S0VZU19DUllQVE9DRkdfUjE2ICsNCj4gPiArCQkJCSAgUUNPTV9JQ0VfTFVUX0tFWVNfQ1JZUFRP
Q0ZHX09GRlNFVA0KPiAqIHNsb3QpOw0KPiA+ICsNCj4gPiArCS8qIENhbGwgdHJ1c3R6b25lIHRv
IHByb2dyYW0gdGhlIHdyYXBwZWQga2V5IHVzaW5nIGh3a20gKi8NCj4gPiArCWVyciA9IHFjb21f
c2NtX2ljZV9zZXRfa2V5KGh3a21fc2xvdCwga2V5LT5yYXcsIGtleS0+c2l6ZSwNCj4gPiArCQkJ
CSAgIFFDT01fU0NNX0lDRV9DSVBIRVJfQUVTXzI1Nl9YVFMsDQo+IGRhdGFfdW5pdF9zaXplKTsN
Cj4gPiArCWlmIChlcnIpIHsNCj4gPiArCQlwcl9lcnIoIiVzOlNDTSBjYWxsIEVycm9yOiAweCV4
IHNsb3QgJWRcbiIsIF9fZnVuY19fLCBlcnIsDQo+ID4gKwkJICAgICAgIHNsb3QpOw0KPiA+ICsJ
CXJldHVybiBlcnI7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJLyogRW5hYmxlIENGR0UgYWZ0ZXIg
cHJvZ3JhbW1pbmcga2V5ICovDQo+ID4gKwlxY29tX2ljZV93cml0ZWwoaWNlLCBjZmcucmVndmFs
LA0KPiBRQ09NX0lDRV9MVVRfS0VZU19DUllQVE9DRkdfUjE2ICsNCj4gPiArDQo+IFFDT01fSUNF
X0xVVF9LRVlTX0NSWVBUT0NGR19PRkZTRVQgKiBzbG90KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4g
ZXJyOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICAgaW50IHFjb21faWNlX3Byb2dyYW1fa2V5KHN0cnVj
dCBxY29tX2ljZSAqaWNlLA0KPiA+ICAgCQkJIHU4IGFsZ29yaXRobV9pZCwgdTgga2V5X3NpemUs
DQo+ID4gICAJCQkgY29uc3Qgc3RydWN0IGJsa19jcnlwdG9fa2V5ICpia2V5LCBAQCAtMjk5LDI0
DQo+ICszNjEsMzEgQEAgaW50DQo+ID4gcWNvbV9pY2VfcHJvZ3JhbV9rZXkoc3RydWN0IHFjb21f
aWNlICppY2UsDQo+ID4NCj4gPiAgIAkvKiBPbmx5IEFFUy0yNTYtWFRTIGhhcyBiZWVuIHRlc3Rl
ZCBzbyBmYXIuICovDQo+ID4gICAJaWYgKGFsZ29yaXRobV9pZCAhPSBRQ09NX0lDRV9DUllQVE9f
QUxHX0FFU19YVFMgfHwNCj4gPiAtCSAgICBrZXlfc2l6ZSAhPSBRQ09NX0lDRV9DUllQVE9fS0VZ
X1NJWkVfMjU2KSB7DQo+ID4gKwkgICAgKGtleV9zaXplICE9IFFDT01fSUNFX0NSWVBUT19LRVlf
U0laRV8yNTYgJiYNCj4gPiArCSAgICBrZXlfc2l6ZSAhPSBRQ09NX0lDRV9DUllQVE9fS0VZX1NJ
WkVfV1JBUFBFRCkpIHsNCj4gQ2FuIHlvdSBwbGVhc2UgY2hlY2sgdGhlIGxvZ2ljIHdpdGggJiYg
b3BlcmF0aW9uLiB0aGUgY29uZGl0aW9uIHdpbGwgYWx3YXlzDQo+IGJlIGZhbHNlLg0KDQpObywg
dGhlIGNvbmRpdGlvbiB3b24ndCBhbHdheXMgYmUgZmFsc2UsIG15IHYyIHBhdGNoZXMgd2VyZSB3
cm9uZyB3aGljaCB3YXMgcG9pbnRlZCBvdXQgYnkgTmVpbA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvYWxsL2ZjYmY2ZGVlLWFhNmEtNGFmOC05ZmYxLTQ5NWFkYmNiNWE1N0BsaW5hcm8ub3JnLw0K
DQpUaGUgY29uZGl0aW9uIHdvdWxkIGNoZWNrIGlmIHRoZSBzaXplIHBhc3NlZCBpcyBlaXRoZXIg
MjU2IG9yIHdyYXBwZWQuDQoNCj4gPiAgIAkJZGV2X2Vycl9yYXRlbGltaXRlZChkZXYsDQo+ID4g
ICAJCQkJICAgICJVbmhhbmRsZWQgY3J5cHRvIGNhcGFiaWxpdHk7DQo+IGFsZ29yaXRobV9pZD0l
ZCwga2V5X3NpemU9JWRcbiIsDQo+ID4gICAJCQkJICAgIGFsZ29yaXRobV9pZCwga2V5X3NpemUp
Ow0KPiA+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAgIAl9DQo+ID4NCj4gPiAtCW1lbWNweShr
ZXkuYnl0ZXMsIGJrZXktPnJhdywgQUVTXzI1Nl9YVFNfS0VZX1NJWkUpOw0KPiA+IC0NCj4gPiAt
CS8qIFRoZSBTQ00gY2FsbCByZXF1aXJlcyB0aGF0IHRoZSBrZXkgd29yZHMgYXJlIGVuY29kZWQg
aW4gYmlnDQo+IGVuZGlhbiAqLw0KPiA+IC0JZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoa2V5
LndvcmRzKTsgaSsrKQ0KPiA+IC0JCV9fY3B1X3RvX2JlMzJzKCZrZXkud29yZHNbaV0pOw0KPiA+
ICsJaWYgKGJrZXktPmNyeXB0b19jZmcua2V5X3R5cGUgPT0NCj4gQkxLX0NSWVBUT19LRVlfVFlQ
RV9IV19XUkFQUEVEKSB7DQo+ID4gKwkJaWYgKCFpY2UtPnVzZV9od2ttKQ0KPiA+ICsJCQlyZXR1
cm4gLUVJTlZBTDsNCj4gaGF2aW5nIGVycm9yIGxvZyBpbiBmYWlsdXJlIGNhc2Ugd291bGQgaGVs
cCBpbiBkZWJ1Z2dpbmcuDQo+ID4gKwkJZXJyID0gcWNvbV9pY2VfcHJvZ3JhbV93cmFwcGVkX2tl
eShpY2UsIGJrZXksDQo+IGRhdGFfdW5pdF9zaXplLA0KPiA+ICsJCQkJCQkgICBzbG90KTsNCj4g
PiArCX0gZWxzZSB7DQo+ID4gKwkJbWVtY3B5KGtleS5ieXRlcywgYmtleS0+cmF3LCBBRVNfMjU2
X1hUU19LRVlfU0laRSk7DQo+ID4NCj4gPiAtCWVyciA9IHFjb21fc2NtX2ljZV9zZXRfa2V5KHNs
b3QsIGtleS5ieXRlcywNCj4gQUVTXzI1Nl9YVFNfS0VZX1NJWkUsDQo+ID4gLQkJCQkgICBRQ09N
X1NDTV9JQ0VfQ0lQSEVSX0FFU18yNTZfWFRTLA0KPiA+IC0JCQkJICAgZGF0YV91bml0X3NpemUp
Ow0KPiA+ICsJCS8qIFRoZSBTQ00gY2FsbCByZXF1aXJlcyB0aGF0IHRoZSBrZXkgd29yZHMgYXJl
IGVuY29kZWQgaW4NCj4gYmlnIGVuZGlhbiAqLw0KPiA+ICsJCWZvciAoaSA9IDA7IGkgPCBBUlJB
WV9TSVpFKGtleS53b3Jkcyk7IGkrKykNCj4gPiArCQkJX19jcHVfdG9fYmUzMnMoJmtleS53b3Jk
c1tpXSk7DQo+ID4NCj4gPiAtCW1lbXplcm9fZXhwbGljaXQoJmtleSwgc2l6ZW9mKGtleSkpOw0K
PiA+ICsJCWVyciA9IHFjb21fc2NtX2ljZV9zZXRfa2V5KHNsb3QsIGtleS5ieXRlcywNCj4gQUVT
XzI1Nl9YVFNfS0VZX1NJWkUsDQo+ID4gKw0KPiBRQ09NX1NDTV9JQ0VfQ0lQSEVSX0FFU18yNTZf
WFRTLA0KPiA+ICsJCQkJCSAgIGRhdGFfdW5pdF9zaXplKTsNCj4gPiArCQltZW16ZXJvX2V4cGxp
Y2l0KCZrZXksIHNpemVvZihrZXkpKTsNCj4gPiArCX0NCj4gPg0KPiA+ICAgCXJldHVybiBlcnI7
DQo+ID4gICB9DQo+ID4gQEAgLTMyNCw3ICszOTMsMjEgQEAgRVhQT1JUX1NZTUJPTF9HUEwocWNv
bV9pY2VfcHJvZ3JhbV9rZXkpOw0KPiA+DQo+ID4gICBpbnQgcWNvbV9pY2VfZXZpY3Rfa2V5KHN0
cnVjdCBxY29tX2ljZSAqaWNlLCBpbnQgc2xvdCkNCj4gPiAgIHsNCj4gPiAtCXJldHVybiBxY29t
X3NjbV9pY2VfaW52YWxpZGF0ZV9rZXkoc2xvdCk7DQo+ID4gKwlpbnQgaHdrbV9zbG90ID0gc2xv
dDsNCj4gPiArDQo+ID4gKwlpZiAoaWNlLT51c2VfaHdrbSkgew0KPiA+ICsJCWh3a21fc2xvdCA9
IHRyYW5zbGF0ZV9od2ttX3Nsb3QoaWNlLCBzbG90KTsNCj4gPiArCS8qDQo+ID4gKwkgKiBJZ25v
cmUgY2FsbHMgdG8gZXZpY3Qga2V5IHdoZW4gSFdLTSBpcyBzdXBwb3J0ZWQgYW5kIGh3a20gaW5p
dA0KPiA+ICsJICogaXMgbm90IHlldCBkb25lLiBUaGlzIGlzIHRvIGF2b2lkIHRoZSBjbGVhcmlu
ZyBhbGwgc2xvdHMgY2FsbA0KPiA+ICsJICogZHVyaW5nIGEgc3RvcmFnZSByZXNldCB3aGVuIElD
RSBpcyBzdGlsbCBpbiBsZWdhY3kgbW9kZS4gSFdLTSBzbGF2ZQ0KPiA+ICsJICogaW4gSUNFIHRh
a2VzIGNhcmUgb2YgemVyb2luZyBvdXQgdGhlIGtleXRhYmxlIG9uIHJlc2V0Lg0KPiA+ICsJICov
DQo+ID4gKwkJaWYgKCFpY2UtPmh3a21faW5pdF9jb21wbGV0ZSkNCj4gPiArCQkJcmV0dXJuIDA7
DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICsJcmV0dXJuIHFjb21fc2NtX2ljZV9pbnZhbGlkYXRlX2tl
eShod2ttX3Nsb3QpOw0KPiA+ICAgfQ0KPiA+ICAgRVhQT1JUX1NZTUJPTF9HUEwocWNvbV9pY2Vf
ZXZpY3Rfa2V5KTsNCj4gPg0KPiA+IEBAIC0zMzQsNiArNDE3LDE1IEBAIGJvb2wgcWNvbV9pY2Vf
aHdrbV9zdXBwb3J0ZWQoc3RydWN0IHFjb21faWNlDQo+ICppY2UpDQo+ID4gICB9DQo+ID4gICBF
WFBPUlRfU1lNQk9MX0dQTChxY29tX2ljZV9od2ttX3N1cHBvcnRlZCk7DQo+ID4NCj4gPiAraW50
IHFjb21faWNlX2Rlcml2ZV9zd19zZWNyZXQoc3RydWN0IHFjb21faWNlICppY2UsIGNvbnN0IHU4
IHdrZXlbXSwNCj4gPiArCQkJICAgICAgdW5zaWduZWQgaW50IHdrZXlfc2l6ZSwNCj4gPiArCQkJ
ICAgICAgdTggc3dfc2VjcmV0W0JMS19DUllQVE9fU1dfU0VDUkVUX1NJWkVdKQ0KPiA+ICt7DQo+
ID4gKwlyZXR1cm4gcWNvbV9zY21fZGVyaXZlX3N3X3NlY3JldCh3a2V5LCB3a2V5X3NpemUsDQo+
ID4gKwkJCQkJIHN3X3NlY3JldCwNCj4gQkxLX0NSWVBUT19TV19TRUNSRVRfU0laRSk7IH0NCj4g
PiArRVhQT1JUX1NZTUJPTF9HUEwocWNvbV9pY2VfZGVyaXZlX3N3X3NlY3JldCk7DQo+ID4gKw0K
PiA+ICAgc3RhdGljIHN0cnVjdCBxY29tX2ljZSAqcWNvbV9pY2VfY3JlYXRlKHN0cnVjdCBkZXZp
Y2UgKmRldiwNCj4gPiAgIAkJCQkJdm9pZCBfX2lvbWVtICpiYXNlKQ0KPiA+ICAgew0KPiA+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL3NvYy9xY29tL2ljZS5oIGIvaW5jbHVkZS9zb2MvcWNvbS9pY2Uu
aCBpbmRleA0KPiA+IDFmNTJlODJlM2UxYy4uZGFiZTBkM2ExZmQwIDEwMDY0NA0KPiA+IC0tLSBh
L2luY2x1ZGUvc29jL3Fjb20vaWNlLmgNCj4gPiArKysgYi9pbmNsdWRlL3NvYy9xY29tL2ljZS5o
DQo+ID4gQEAgLTE3LDYgKzE3LDcgQEAgZW51bSBxY29tX2ljZV9jcnlwdG9fa2V5X3NpemUgew0K
PiA+ICAgCVFDT01fSUNFX0NSWVBUT19LRVlfU0laRV8xOTIJCT0gMHgyLA0KPiA+ICAgCVFDT01f
SUNFX0NSWVBUT19LRVlfU0laRV8yNTYJCT0gMHgzLA0KPiA+ICAgCVFDT01fSUNFX0NSWVBUT19L
RVlfU0laRV81MTIJCT0gMHg0LA0KPiA+ICsJUUNPTV9JQ0VfQ1JZUFRPX0tFWV9TSVpFX1dSQVBQ
RUQJPSAweDUsDQo+ID4gICB9Ow0KPiA+DQo+ID4gICBlbnVtIHFjb21faWNlX2NyeXB0b19hbGcg
ew0KPiA+IEBAIC0zNSw1ICszNiw4IEBAIGludCBxY29tX2ljZV9wcm9ncmFtX2tleShzdHJ1Y3Qg
cWNvbV9pY2UgKmljZSwNCj4gPiAgIAkJCSB1OCBkYXRhX3VuaXRfc2l6ZSwgaW50IHNsb3QpOw0K
PiA+ICAgaW50IHFjb21faWNlX2V2aWN0X2tleShzdHJ1Y3QgcWNvbV9pY2UgKmljZSwgaW50IHNs
b3QpOw0KPiA+ICAgYm9vbCBxY29tX2ljZV9od2ttX3N1cHBvcnRlZChzdHJ1Y3QgcWNvbV9pY2Ug
KmljZSk7DQo+ID4gK2ludCBxY29tX2ljZV9kZXJpdmVfc3dfc2VjcmV0KHN0cnVjdCBxY29tX2lj
ZSAqaWNlLCBjb25zdCB1OCB3a2V5W10sDQo+ID4gKwkJCSAgICAgIHVuc2lnbmVkIGludCB3a2V5
X3NpemUsDQo+ID4gKwkJCSAgICAgIHU4IHN3X3NlY3JldFtCTEtfQ1JZUFRPX1NXX1NFQ1JFVF9T
SVpFXSk7DQo+ID4gICBzdHJ1Y3QgcWNvbV9pY2UgKm9mX3Fjb21faWNlX2dldChzdHJ1Y3QgZGV2
aWNlICpkZXYpOw0KPiA+ICAgI2VuZGlmIC8qIF9fUUNPTV9JQ0VfSF9fICovDQo=

