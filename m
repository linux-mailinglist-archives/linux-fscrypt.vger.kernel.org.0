Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD367A6F55
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Sep 2023 01:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjISXTK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Sep 2023 19:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjISXTJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Sep 2023 19:19:09 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D23DC4;
        Tue, 19 Sep 2023 16:19:02 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38JMuBOS021475;
        Tue, 19 Sep 2023 23:18:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=/RO0z7r2CknR+ow/9IxlksjGka5smxlnKF3LU+kDdFw=;
 b=X1jE9dFdMQsTc7GBH8u6NeDYFtbuEs+YWpkZigkOJyuGsZpfqxNoxRXIYnk3DG1z3RfA
 7XyusekgwewB5LZXIEVfrqzoETb7yeUnK3juZCzo1ba45ddvUDXbCOIvkq/GSyI12spu
 VG2EhQ02B1ZzyxK6dLvuQlkGEg4PtuXlT80ihu0IfFHygF7TORCVrN5e4/+lXAjxASLO
 /w2bMc3OvGnuNA5LufuubKvjjIY0xRC77f99etT3NGXLCbQETicGfk++GQZK/lZ/T5AI
 kLhKxB1KGapvpCTm078OFprJXZpw9QB2jEqGnBRa1HUEPJyFgnFSpa1b0K20MDuZ3F/7 bQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3t78uphqc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Sep 2023 23:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5F9P2PJeUN5OcGuHltrx/xpXE98WpG4gumf5sQD1QfLGNvDQ7P1RNDZqiT3yuzwpbCMG9RTNRhFKXalm51s7uWAGWFyOkjwLy3BlPA6V0stNeKixWJE/6MCUrc8Tg7kAG8/8ALHyDvWhn+nZjaib6D6aJAOscvOWIiveTAIRdyq56/phBLSF8gAJdmah24THgRg2rSDpE7ynSEZpKjKXEyONoYwnc6bpNQWNoutRjoVW8Ds+uN5BrMFlHEv6Cq7CHfxgtU/o0Ga9fdWpWDPau/PKpqKlFNgtMp4IGpFWpmLqD9JxHGoLf9l9MiGxCCEFe/Km0famt/nUIphv0HXVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RO0z7r2CknR+ow/9IxlksjGka5smxlnKF3LU+kDdFw=;
 b=XcLuVeVX6fF0Q1cm2yo0kGlnsD/Yl+XvDqn3Au6VpKx84O1moGgsh4lMWVjmhZ1ykXeZ+93WnNF4ng/6pQDW+MUdjqQX2XTmdxnIB32USQqWnyqrS5YIQVflkF4QDjT3RAqwyekchwU4j0uDvK5850cgD95+yQPfwnsebvhZ5oMPQdSVVJUrgZ4gJ8EkhYmLmTfTph0V9Ot4Zg4w3StZzJKrxDh7VrFF1G/T0kIMMIZuiNqeeS30E7i9gV36ZBuTjERtxgglSYS6Cvu/Td4dDGPIjI04YsVHlCyEJT9PQmorcE8MX1QZU7vOvvb9EvLjqK6E5U5vSk4GQtJ2BmQBbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by PH7PR02MB8905.namprd02.prod.outlook.com (2603:10b6:510:1ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Tue, 19 Sep
 2023 23:18:49 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::cb85:9b35:eb6b:8c53]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::cb85:9b35:eb6b:8c53%7]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 23:18:49 +0000
From:   Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>
CC:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Om Prakash Singh <omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)" <quic_psodagud@quicinc.com>,
        "Arun Menon (SSG)" <avmenon@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>
Subject: RE: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Thread-Topic: [PATCH v2 00/10] Hardware wrapped key support for qcom ice and
 ufs
Thread-Index: AQHZumOGCcBpt3+7c0iBGcomJKyUhq/7BoqAgAC0/ICAG5FaAIAL2QbQ
Date:   Tue, 19 Sep 2023 23:18:48 +0000
Message-ID: <BYAPR02MB40710E9FFF687A29005A7F53E2FAA@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <f4b5512b-9922-1511-fc22-f14d25e2426a@linaro.org>
 <20230825210727.GA1366@sol.localdomain>
 <cf3816b0-7718-278c-aac2-bdd2dd85ac87@linaro.org>
In-Reply-To: <cf3816b0-7718-278c-aac2-bdd2dd85ac87@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR02MB4071:EE_|PH7PR02MB8905:EE_
x-ms-office365-filtering-correlation-id: 65231d46-de2e-404c-3979-08dbb966c77d
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Uy22vziSGaYgYRpktt6l88QckfTRMkOLprE5oE3Xn+5YT1K9XpQGyH2Y+7lDOVgivCFBXbW/xAkSjpdgZpNwWUitLqAcjy6bryDTCKLOD16PVD7Cgqdh6ABD4BGc5GlFwoPpYxx/l0KaRjif0UGFhN3OVfJ8g14oQnKNL/8O+pGJ8XV5GQi1lAaugDfcB6X3Cei8PGz0xfxKBB5EdmZYdGMV+/vfA+687ANZNsB5HXAXkyevU+yTkQOsMqvaYp/jxKTua84Y9NHO7cLI3xXJs4ln0wuGPRbT8bDmtvIM1lRQ/YTfNVDisRThNKUfKIllKJ/zI3vSQLXhaJN8yS/tHOSuhirGkrevSoX2dShr+IiFVz+OH5yhERsgZy5PLSUMqOov1W7xim2uFTIEsjprv3IEU5cn//SLzDJ5A3aku1R/bZnuqL4BVVBsZybThmWF9uT3hOqlrPw/5Z27soTgeE2YYXrPn855H1w0uU4BqiKDKI6vYRHw1h9hG/ZLhBd46V9holkj5i7zPcCoQ36mJssko6OGwKm1fWbDaRJ9q6KD1KjS7m0/aZdvr24F/c6oqx1bD/9vWx9IIf8ISLpbUAXxQMUqd5De9si9vKJFy4g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199024)(186009)(1800799009)(966005)(55016003)(5660300002)(6506007)(7696005)(53546011)(86362001)(9686003)(54906003)(316002)(64756008)(66946007)(66446008)(38100700002)(41300700001)(66556008)(66476007)(38070700005)(76116006)(110136005)(478600001)(71200400001)(8936002)(8676002)(52536014)(26005)(2906002)(33656002)(66899024)(107886003)(4326008)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0xEYzU2ZURqRzNBMDhUQWRHdWNQYlhVR0R4aCs3ZjZhUlNqTUhNWlhnUEpY?=
 =?utf-8?B?U1hEcHJhWklhM3hxVHZUVEJTU1IrYW1iWHQ4S3Z5dlVSTjRlekdhdTVTdFAr?=
 =?utf-8?B?NkFzQmZ5SVVVbFh5R1UxbTRnZitza0NZTm1TY2JiVGNGSEtlTDRnSkdSNUdR?=
 =?utf-8?B?NktsYWtiUlNQRWo2cjdGOFdkRTV6K0RHZ1dNK2JDdUoyNDcrNldFMitKcVRt?=
 =?utf-8?B?OW45T1VFVGN1SXhoNXRzSGg0dDdlaThWdmxPVHJZNHR5NTRqTWVrZENVVGdD?=
 =?utf-8?B?SVZlK0tJVVFmbUkydS9jeUhpUWV1SUdnUXo4STljbG9FT0dmOHB3WnhLbUN4?=
 =?utf-8?B?NnZJSG9QTHNML3c5d0ZQTGp3eXZtdS96YklybGZTRnBCbFlBUWlIK2xCRVB1?=
 =?utf-8?B?Zlc3NTVxUmxhaXZoUk9uOXhqMGd6cXdZekVyTUJqR1lwWmJMZTlIL3djSlZ6?=
 =?utf-8?B?NTRCQmFKb1BRTVpLYU11SUpldDcyQm5vRUVYaEtKMmR1MTJJODFicXBINDhW?=
 =?utf-8?B?amFWQll3d1F5dUhCSTZNUTk5dWF2QVJ1akxNY1NKNnA5ZldFY3VNZGQ5S0Zw?=
 =?utf-8?B?VHZaUUxTNktQRXRhK0VRdy81T1E2cFd2VnRTc3hSN3VSZGh3MU9ORnJHRU1C?=
 =?utf-8?B?ZWVWdjNLL05vWWhUZmQ0T25PRmN5OTVFeHRRL1UvdmlzSGwzbzBxYlNwWXpv?=
 =?utf-8?B?Lzd3S08xUk5ZL0hXY085R3dHeSt2dFZlY016ZWtOcFlnQmp2dHF5eUFiN28x?=
 =?utf-8?B?OWVkTGdOWjBnbWt1QVlqTzUxQUU1TUdQKzlXaGdiRXZWVzF4SS9rczM2Vm05?=
 =?utf-8?B?SmVkOGRKM1pzTW1ERmVsdzRSek01ZStzcC9iZXJtNXpQTlVZZW03eFFGTmps?=
 =?utf-8?B?TmRYMFpuVEdCM0JkZmFzRFhKM1Nta0VnaWlRSFM4UHpvWnFLelZCUWhzQTFk?=
 =?utf-8?B?M0lJS2Mrb0xIQ1dDa3FDQnVQWWlEZVMwVW5raTFQd05WYXNPdkRuTHVCWDhW?=
 =?utf-8?B?VWlqZm4yWlFPaWNsOUZUeW9JYm12WTJZejRMZ2t6bUhLbGMxbUlNajVxQnNn?=
 =?utf-8?B?T0g5MWVFMGpuQzd2RVh4cUw0UVBXWGlzcnNoUng4bndRTndKakJUSHJsM0lZ?=
 =?utf-8?B?TFV6aTA2MnJiTUVxa2c5djdwQmY3RDdVMFRRWXM5bXZpMCs3RSszNk5Tc0Jp?=
 =?utf-8?B?QmtSVjFmdGg5aGpoc0VBcFdJclF0STZidjFRSTQ4WEJoUU5NaHl1SmJieHhw?=
 =?utf-8?B?d3FZRjlVc040NDZpSDB0RkthdnVjeW8xV1BEeExRTFE0SjYzRm43VTJsdlVC?=
 =?utf-8?B?Wm1TdEZEN0I5OTRsUVVVc2FIeFk4MWt3VlU1dW9ROE9ISzVJd1JISVYvNWZ0?=
 =?utf-8?B?WW1VWk4wYUpaaHhrUHhrRCtpNTJzN1Q1ZFZwZG96cW10QnlGYVdCWU5pYzd5?=
 =?utf-8?B?b1UrRlg5VkdkK3Y5QUV1VEp4eWI5QzhDTGhDUFNESkZCWm1lRXFlc2dtWE9a?=
 =?utf-8?B?NUlxYVQ0czB2ZVprOFB2eU9aNmdHT2hSMThVV3V3b0pCb29pdnE3VzZtWUxD?=
 =?utf-8?B?UjFrck8rTEVYU3BmYkUySS96VEJNK0k5UW5wa05HWERVblhHTkVGbmsvaS9Y?=
 =?utf-8?B?UVJ1SFpmTnh1eVovREhEMmdUNkx0WTNiNHl2RG1hTUlueDhUbld6eW0rTzd3?=
 =?utf-8?B?dVZKNTVrR3NsckhGejJmQUhDOUFMMzB6TERxTi9MYTJ6NllWZlBNa01vTldO?=
 =?utf-8?B?TTJLRmhibENpeGdJSjZJc0FXNHUyTnB2SHRNRTFJYW9FU1c4MnJ3WmpwK2dl?=
 =?utf-8?B?aW1JZnU5VzlmblFyYUlXVFFBWTlhWDVsdS9QdXJSS0RoaWd5L0lJSmp4VGNO?=
 =?utf-8?B?SFh5aHlSWncwc3VHa3A0aXVoWStBbHBBQWY2eENXRnM1RmpldFZaSmVCak02?=
 =?utf-8?B?THBxUlBVdGZNK1hTc0VZWUQzTXdxZW5kNThqOHBUTUZlQ3FCd2NBekkwSTZP?=
 =?utf-8?B?WXFxYkNiKzBFL1d1a0ZETG9IRDV0eXRHV2lOTWNMUGhPa0UzRHpndmwzU3Ix?=
 =?utf-8?B?c0g4U0o3bWhqN2NCU1hPenRiQ21rb3RSQ0JkMnVwUlF3WkVnbGhrY2tsTzN1?=
 =?utf-8?Q?QKjPQ+KoStxU1/pWwcVb+c8zU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: u5bvKLXvTSzug5cRB4/0+TkKoOhZNbExjno102rB72uu92mkEk9W3QVRyyyoIo7tPlXl5jD6rqoVs4meCqQdFB5lM/OkcyDTV/q+i8SOxQufM9nFNWy3YxST69SZDLR84yhrYJzB7kapLY9+Gkx9gOCAnoMVFfv69/l6fx0yxF8VwhV4Fv8fnPsljk636IWt2xJm5VPPXzQCIC341XUM34fg+TCdDyjkyJE3iOXDxNX8xIqRGfkRJAWo4X4ao1+7wgimF2kILm19l39mJNa2yk/hypvvxFn94Pf5JjJAJJuwPBehSFLjv/D4gPNPQe7qjTemwa/TIhT8d9PqwexhR3REEPOXDUXqG7riGSIeut5ht8mockptUxpQnWUrP3XYa76lZpkMkVY03Ekjbwy+gbZH16/njCaXhBD1aIOWoPOsFroQSqz7jhNNVPPKQ5m1Kh5qI3I0PnGkQJm3KSGuHXQPm63YfK+QQXOBOINfyRzozvh0LUZyxkdw4RPWyu51i6QUaBnEroaA0C7qAkGBCRM66LHwZ2xUsUOpDQ0oAVtoYJGiZtgvMo5khGMDMSVFTPI+GsmwvE7tSErDMNkDLijruDNZSer6C1zTsP7oR5isSbUhQs8aMYj0jFrRXetsA9FoIRfpZ4dRRx9GdD0WcUR654tz9xPGH2BXoVbei7LO3c23XTFCsSSdtW7xjAH/cKtnQ3VXpzzQiRgjYsxoS4BNZyqMAI6MAMMDOSgEyyiWc3l475HT2L7qHK98MyM8kY4e72HpuxgByivorhsZz0aC0Xpc2MRushg6sMij8QLhEseYIYi5IRgCQzAmk4Wqg2ch+XhNhQsqqBQv1CwhQQ==
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65231d46-de2e-404c-3979-08dbb966c77d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2023 23:18:48.7150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yz4B4hkf/S70HhnIxQphfeQmyGHFeppVLoBPNZAD5zGsZ0lbgJYxNeVNcIf8rYpqid0pop0x2rEK8zJYMdZ3PMqpPq9cUrSumM8iaWk9s9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB8905
X-Proofpoint-GUID: 90XenHgHeiZlaPVtE41EG3CYyR0TVQ3W
X-Proofpoint-ORIG-GUID: 90XenHgHeiZlaPVtE41EG3CYyR0TVQ3W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-19_12,2023-09-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309190197
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SGVsbG8gU3Jpbml2YXMsDQoNCk9uIFR1ZSwgU2VwIDEyLCAyMDIzIGF0IDM6MDcgQU0sIFNyaW5p
dmFzIEthbmRhZ2F0bGEgd3JvdGU6DQo+IEhpIEVyaWMvR2F1cmF2LA0KPiANCj4gQWRkaW5nIG1v
cmUgaW5mb3JtYXRpb24gYW5kIHNvbWUgcXVlc3Rpb25zIHRvIHRoaXMgZGlzY3Vzc2lvbiwNCj4g
DQo+IE9uIDI1LzA4LzIwMjMgMTQ6MDcsIEVyaWMgQmlnZ2VycyB3cm90ZToNCj4gPiBIaSBTcmlu
aXZhcywNCj4gPg0KPiA+IE9uIEZyaSwgQXVnIDI1LCAyMDIzIGF0IDExOjE5OjQxQU0gKzAxMDAs
IFNyaW5pdmFzIEthbmRhZ2F0bGEgd3JvdGU6DQo+ID4+DQo+ID4+IE9uIDE5LzA3LzIwMjMgMTg6
MDQsIEdhdXJhdiBLYXNoeWFwIHdyb3RlOg0KPiA+Pj4gVGhlc2UgcGF0Y2hlcyBhZGQgc3VwcG9y
dCB0byBRdWFsY29tbSBJQ0UgKElubGluZSBDcnlwdG8gRW5naW5yKSBmb3INCj4gPj4+IGhhcmR3
YXJlIHdyYXBwZWQga2V5cyB1c2luZyBRdWFsY29tbSBIYXJkd2FyZSBLZXkgTWFuYWdlcg0KPiAo
SFdLTSkgYW5kDQo+ID4+PiBhcmUgbWFkZSBvbiB0b3Agb2YgYSByZWJhc2VkIHZlcnNpb24gIEVy
aWMgQmlnZ2VyJ3Mgc2V0IG9mIGNoYW5nZXMNCj4gPj4+IHRvIHN1cHBvcnQgd3JhcHBlZCBrZXlz
IGluIGZzY3J5cHQgYW5kIGJsb2NrIGJlbG93Og0KPiA+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2ZzL2ZzY3J5cHQvbGludXguZ2l0L2xvZy8/aD13cmFwcGVkLWsNCj4gPj4+IGV5
cy12NyAoVGhlIHJlYmFzZWQgcGF0Y2hlcyBhcmUgbm90IHVwbG9hZGVkIGhlcmUpDQo+ID4+Pg0K
PiA+Pj4gUmVmIHYxIGhlcmU6DQo+ID4+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1z
Y3NpLzIwMjExMjA2MjI1NzI1Ljc3NTEyLTEtcXVpY19nYXVyaw0KPiA+Pj4gYXNoQHF1aWNpbmMu
Y29tLw0KPiA+Pj4NCj4gPj4+IEV4cGxhbmF0aW9uIGFuZCB1c2Ugb2YgaGFyZHdhcmUtd3JhcHBl
ZC1rZXlzIGNhbiBiZSBmb3VuZCBoZXJlOg0KPiA+Pj4gRG9jdW1lbnRhdGlvbi9ibG9jay9pbmxp
bmUtZW5jcnlwdGlvbi5yc3QNCj4gPj4+DQo+ID4+PiBUaGlzIHBhdGNoIGlzIG9yZ2FuaXplZCBh
cyBmb2xsb3dzOg0KPiA+Pj4NCj4gPj4+IFBhdGNoIDEgLSBQcmVwYXJlcyBJQ0UgYW5kIHN0b3Jh
Z2UgbGF5ZXJzIChVRlMgYW5kIEVNTUMpIHRvIHBhc3MgYXJvdW5kDQo+IHdyYXBwZWQga2V5cy4N
Cj4gPj4+IFBhdGNoIDIgLSBBZGRzIGEgbmV3IFNDTSBhcGkgdG8gc3VwcG9ydCBkZXJpdmluZyBz
b2Z0d2FyZSBzZWNyZXQNCj4gPj4+IHdoZW4gd3JhcHBlZCBrZXlzIGFyZSB1c2VkIFBhdGNoIDMt
NCAtIEFkZHMgc3VwcG9ydCBmb3Igd3JhcHBlZCBrZXlzDQo+ID4+PiBpbiB0aGUgSUNFIGRyaXZl
ci4gVGhpcyBpbmNsdWRlcyBhZGRpbmcgSFdLTSBzdXBwb3J0IFBhdGNoIDUtNiAtDQo+ID4+PiBB
ZGRzIHN1cHBvcnQgZm9yIHdyYXBwZWQga2V5cyBpbiBVRlMgUGF0Y2ggNy0xMCAtIFN1cHBvcnRz
IGdlbmVyYXRlLA0KPiA+Pj4gcHJlcGFyZSBhbmQgaW1wb3J0IGZ1bmN0aW9uYWxpdHkgaW4gSUNF
IGFuZCBVRlMNCj4gPj4+DQo+ID4+PiBOT1RFOiBNTUMgd2lsbCBoYXZlIHNpbWlsYXIgY2hhbmdl
cyB0byBVRlMgYW5kIHdpbGwgYmUgdXBsb2FkZWQgaW4gYQ0KPiBkaWZmZXJlbnQgcGF0Y2hzZXQN
Cj4gPj4+ICAgICAgICAgUGF0Y2ggMywgNCwgOCwgMTAgd2lsbCBoYXZlIE1NQyBlcXVpdmFsZW50
cy4NCj4gPj4+DQo+ID4+PiBUZXN0aW5nOg0KPiA+Pj4gVGVzdCBwbGF0Zm9ybTogU004NTUwIE1U
UA0KPiA+Pj4gRW5naW5lZXJpbmcgdHJ1c3R6b25lIGltYWdlIGlzIHJlcXVpcmVkIHRvIHRlc3Qg
dGhpcyBmZWF0dXJlIG9ubHkNCj4gPj4+IGZvciBTTTg1NTAuIEZvciBTTTg2NTAgb253YXJkcywg
YWxsIHRydXN0em9uZSBjaGFuZ2VzIHRvIHN1cHBvcnQNCj4gPj4+IHRoaXMgd2lsbCBiZSBwYXJ0
IG9mIHRoZSByZWxlYXNlZCBpbWFnZXMuDQo+ID4+DQo+ID4+IEFGQUlVLCBQcmlvciB0byB0aGVz
ZSBwcm9wb3NlZCBjaGFuZ2VzIGluIHNjbSwgSFdLTSB3YXMgZG9uZSB3aXRoDQo+ID4+IGhlbHAg
b2YgVEEoVHJ1c3RlZCBBcHBsaWNhdGlvbikgZm9yIGdlbmVyYXRlLCBpbXBvcnQsIHVud3JhcCAu
Li4NCj4gZnVuY3Rpb25hbGl0eS4NCj4gPj4NCj4gPj4gMS4gV2hhdCBpcyB0aGUgcmVhc29uIGZv
ciBtb3ZpbmcgdGhpcyBmcm9tIFRBIHRvIG5ldyBzbWMgY2FsbHM/DQo+ID4+DQo+ID4+IElzIHRo
aXMgYmVjYXVzZSBvZiBtaXNzaW5nIHNtY2tpbnZva2Ugc3VwcG9ydCBpbiB1cHN0cmVhbT8NCj4g
Pj4NCj4gPj4gSG93IHNjYWxhYmxlIGlzIHRoaXMgYXBwcm9hY2g/IEFyZSB3ZSBnb2luZyB0byBh
ZGQgbmV3IHNlYyBzeXMgY2FsbHMNCj4gPj4gdG8gZXZlcnkgaW50ZXJmYWNlIHRvIFRBPw0KPiA+
Pg0KPiA+PiAyLiBIb3cgYXJlIHRoZSBvbGRlciBTb0NzIGdvaW5nIHRvIGRlYWwgd2l0aCB0aGlz
LCBnaXZlbiB0aGF0IHlvdSBhcmUNCj4gPj4gY2hhbmdpbmcgZHJpdmVycyB0aGF0IGFyZSBjb21t
b24gYWNyb3NzIHRoZXNlPw0KPiA+Pg0KPiA+PiBIYXZlIHlvdSB0ZXN0ZWQgdGhlc2UgcGF0Y2hl
cyBvbiBhbnkgb2xkZXIgcGxhdGZvcm1zPw0KPiA+Pg0KPiA+PiBXaGF0IGhhcHBlbnMgaWYgc29t
ZW9uZSB3YW50IHRvIGFkZCBzdXBwb3J0IHRvIHdyYXBwZWQga2V5cyB0byB0aGlzDQo+ID4+IHBs
YXRmb3JtcyBpbiB1cHN0cmVhbSwgSG93IGlzIHRoYXQgZ29pbmcgdG8gYmUgaGFuZGxlZD8NCj4g
Pj4NCj4gPj4gQXMgSSB1bmRlcnN0YW5kIHdpdGggdGhpcywgd2Ugd2lsbCBlbmR1cCB3aXRoIHR3
byBwb3NzaWJsZSBzb2x1dGlvbnMNCj4gPj4gb3ZlciB0aW1lIGluIHVwc3RyZWFtLg0KPiA+DQo+
ID4gSXQncyB0cnVlIHRoYXQgUXVhbGNvbW0gYmFzZWQgQW5kcm9pZCBkZXZpY2VzIGFscmVhZHkg
dXNlIEhXLXdyYXBwZWQNCj4gPiBrZXlzIG9uIFNvQ3MgZWFybGllciB0aGFuIFNNODY1MC4gIFRo
ZSBwcm9ibGVtIGlzIHRoYXQgdGhlIGtleQ0KPiA+IGdlbmVyYXRpb24sIGltcG9ydCwgYW5kIGNv
bnZlcnNpb24gd2VyZSBhZGRlZCB0byBBbmRyb2lkJ3MgS2V5TWludA0KPiA+IEhBTCwgYXMgYSBx
dWljayB3YXkgdG8gZ2V0IHRoZSBmZWF0dXJlIG91dCB0aGUgZG9vciB3aGVuIGl0IHdhcyBuZWVk
ZWQNCj4gPiAoc28gdG8gc3BlYWspLiAgVW5mb3J0dW5hdGVseSB0aGlzIGNvdXBsZWQgdGhpcyBm
ZWF0dXJlIHVubmVjZXNzYXJpbHkNCj4gPiB0byB0aGUgQW5kcm9pZCBLZXlNaW50IGFuZCB0aGUg
Y29ycmVzcG9uZGluZyAoY2xvc2VkIHNvdXJjZSkgdXNlcnNwYWNlDQo+ID4gSEFMIHByb3ZpZGVk
IGJ5IFF1YWxjb21tLCB3aGljaCBpdCdzIG5vdCBhY3R1YWxseSByZWxhdGVkIHRvLiAgSSdkDQo+
ID4gZ3Vlc3MgdGhhdCBRdWFsY29tbSdzIGNsb3NlZCBzb3VyY2UgdXNlcnNwYWNlIEhBTCBtYWtl
cyBTTUMgY2FsbHMgaW50bw0KPiBRdWFsY29tbSdzIEtleU1pbnQgVEEsIGJ1dCBJIGhhdmUgbm8g
aW5zaWdodCBpbnRvIHRob3NlIGRldGFpbHMuDQo+ID4NCj4gPiBUaGUgbmV3IFNNQyBjYWxscyBl
bGltaW5hdGUgdGhlIGRlcGVuZGVuY3kgb24gdGhlIEFuZHJvaWQtc3BlY2lmaWMNCj4gS2V5TWlu
dC4NCj4gPiBUaGV5J3JlIGFsc28gYmVpbmcgZG9jdW1lbnRlZCBieSBRdWFsY29tbS4gIFNvLCBh
cyB0aGlzIHBhdGNoc2V0IGRvZXMsDQo+ID4gdGhleSBjYW4gYmUgdXNlZCBieSBMaW51eCBpbiB0
aGUgaW1wbGVtZW50YXRpb24gb2YgbmV3IGlvY3RscyB3aGljaA0KPiA+IHByb3ZpZGUgYSB2ZW5k
b3IgaW5kZXBlbmRlbnQgaW50ZXJmYWNlIHRvIEhXLXdyYXBwZWQga2V5IGdlbmVyYXRpb24sDQo+
IGltcG9ydCwgYW5kIGNvbnZlcnNpb24uDQo+ID4NCj4gPiBJIHRoaW5rIHRoZSBuZXcgYXBwcm9h
Y2ggaXMgdGhlIG9ubHkgb25lIHRoYXQgaXMgdmlhYmxlIG91dHNpZGUgdGhlDQo+ID4gQW5kcm9p
ZCBjb250ZXh0LiAgQXMgc3VjaCwgSSBkb24ndCB0aGluayBhbnlvbmUgaGFzIGFueSBwbGFuIHRv
DQo+ID4gdXBzdHJlYW0gc3VwcG9ydCBmb3INCj4gDQo+IEp1c3QgYml0IG9mIGhpc3RvcnkgYWZh
aXUuDQo+IA0KPiBvbiBRY29tIFNvQ3MgdGhlcmUgYXJlIDMgd2F5cyB0byB0YWxrIHRvIFRydXN0
ZWQgc2VydmljZS9UcnVzdGVkIGFwcGxpY2F0aW9uLg0KPiANCj4gMT4gQWRkaW5nIFNDTSBjYWxs
cy4gVGhpcyBpcyBub3Qgc2NhbGFibGUgc29sdXRpb24sIGltYWdpbmUgd2Uga2VlcA0KPiBhZGRp
bmcgbmV3IHNjbSBjYWxscyBhbmQgc3RhdGljIHNlcnZpY2VzIHRvIHRoZSBUWiBhcyByZXF1aXJl
ZCBhbmQgdGhpcyBpcyBnb2luZw0KPiB0byBibG9hdCB1cCB0aGUgdHogaW1hZ2Ugc2l6ZS4gTm90
IG9ubHkgdGhhdCwgbmV3IFNvQ3Mgd291bGQgbmVlZCB0byBtYWludGFpbg0KPiBiYWNrd2FyZCBj
b21wYXRpYmlsaXR5LCB3aGljaCBpcyBub3QgZ29pbmcgdG8gaGFwcGVuLg0KPiBBRkFJVSB0aGlz
IGlzIGRpc2NvdXJhZ2VkIGluIGdlbmVyYWwgYW5kIFFjb20gYXQgc29tZSBwb2ludCBpbiB0aW1l
IHdpbGwgbW92ZQ0KPiBhd2F5IGZyb20gdGhpcy4uDQo+IA0KPiAyPiB1c2luZyBRU0VFQ09NOiBU
aGlzIGhhcyBzb21lIHNjYWxhYmxlIGlzc3Vlcywgd2hpY2ggaXMgbm93IHJlcGxhY2VkDQo+IHdp
dGggc21jaW52b2tlLg0KPiANCj4gMz4gc21jaW52b2tlOiBUaGlzIGlzIHByZWZlcnJlZCB3YXkg
dG8gdGFsayB0byBhbnkgUVRFRSBzZXJ2aWNlIG9yDQo+IGFwcGxpY2F0aW9uLiBUaGUgaXNzdWUg
aXMgdGhhdCB0aGlzIGlzIGJhc2VkIG9uIHNvbWUgZG93bnN0cmVhbSBVQVBJIHdoaWNoIGlzDQo+
IG5vdCB1cHN0cmVhbSByZWFkeSB5ZXQuDQo+IA0KPiBJTU8sIGFkZGluZyBhIHNvbHV0aW9uIHRo
YXQgaXMganVzdCBnb2luZyB0byBsaXZlIGZvciBmZXcgeWVhcnMgaXMgcXVlc3Rpb25hYmxlDQo+
IGZvciB1cHN0cmVhbS4NCj4gDQo+IEZpeGluZyBbM10gc2VlbXMgdG8gYmUgbXVjaCBzY2FsYWJs
ZSBzb2x1dGlvbiBhbG9uZyB3aXRoIGl0IHdlIHdpbGwgYWxzbyBnZXQNCj4gc3VwcG9ydCBmb3Ig
dGhpcyBmZWF0dXJlIGluIGFsbCB0aGUgUXVhbGNvbW0gcGxhdGZvcm1zLg0KPiANCj4gQW0gaW50
ZXJlc3RlZCB0byBoZWFyIHdoYXQgR2F1cmF2IGhhcyB0byBzYXkgb24gdGhpcy4NCj4gDQo+IA0K
PiAtLXNyaW5pDQo+IA0KPiANCg0KV2hhdCB5b3UgYXJlIHJlZmVycmluZyB0byBpcyB3cmFwcGVk
IGtleXMgYmVpbmcgZ2VuZXJhdGVkIGluIGEgVHJ1c3RlZCBBcHBsaWNhdGlvbiAoaW4gY2FzZSBv
ZiBhbmRyb2lkIGFuZCBzb21lIG90aGVyIHNvbHV0aW9ucywga2V5bWFzdGVyKSwgYW5kIGV2ZW50
dWFsbHkgYmVpbmcgcHJvZ3JhbW1lZCB2aWEgU0NNIGNhbGxzIGluIFRaLg0KQW5kLCB5b3UgYXJl
IHN1Z2dlc3RpbmcgaW5zdGVhZCBvZiBpb2N0bC0+c2NtIGNhbGwsIHdlIHNob3VsZCBiZSBkb2lu
ZyBpb2N0bC0+c21jaW52b2tlLT5UQQ0KDQpXaGF0IEVyaWMgYW5kIEkgYXJlIGFkZGluZyBoZXJl
IHNob3VsZCBub3QgYmUganVzdCBjb25zaWRlcmVkIGEgc3RvcGdhcCwgYnV0IGEgcGF0aCBmb3Ig
cG90ZW50aWFsIGNsaWVudHMgdG8gZ2VuZXJhdGUgYW5kIG1hbmFnZSB3cmFwcGVkIGtleXMgd2l0
aG91dCByZXF1aXJpbmcgYW55IFRBLg0KVGhlIFRBIHdheSB3aWxsIGNvbnRpbnVlIHRvIHdvcmss
IGFuZCB0aG9zZSB3cmFwcGVkIGtleXMgY2FuIGJlIHByb2dyYW1tZWQgdG8gSUNFIHVzaW5nIGZz
Y3J5cHQuDQoNClVubGVzcywgaXMgdGhlIHN1Z2dlc3Rpb24gdGhhdCB3cmFwcGVkIGtleXMgc2hv
dWxkIGFsd2F5cyBiZSBnZW5lcmF0ZWQgYW5kIG1hbmFnZWQgaW4gYSB0cnVzdGVkIGFwcGxpY2F0
aW9uPw0KQW5kIHRoZW4gcHJvZ3JhbW1lZCB0aG91Z2gga2VybmVsLT5TQ00gY2FsbCBpbnRlcmZh
Y2U/DQoNCj4gPiBIVy13cmFwcGVkIGtleXMgZm9yIG9sZGVyIFF1YWxjb21tIFNvQ3MgdGhhdCBs
YWNrIHRoZSBuZXcgaW50ZXJmYWNlLg0KPiA+DQo+ID4gLSBFcmljDQo=
