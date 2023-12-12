Return-Path: <linux-fscrypt+bounces-76-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC70580E308
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 04:53:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C472B219B8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Dec 2023 03:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50593BE60;
	Tue, 12 Dec 2023 03:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="THMSaCZ/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBD08E;
	Mon, 11 Dec 2023 19:53:38 -0800 (PST)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BC2w9TG000755;
	Tue, 12 Dec 2023 03:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	qcppdkim1; bh=TcOKV1nKrWe7dTHgOTkOP0ky8SCIHbUtqbkpiwBVNec=; b=TH
	MSaCZ/IC9Xh697DnsbQvXvmRPRqcvwEA2+03evzCJeLu0B97KRuIGlNx1LddUxNU
	j9p6Tyt3FvxALkeHGFeJTLs9/ZOQy5u7Qfq8NG1Lb0UuEyanXkXbs8FXWDd03+p8
	+bc55zePvQTdtXF9+E2BQAmcni+n8zlxmSMpb/n/f+6QTAezZ0dedHqQzUhpbHtD
	EXLPF0te3pzrhoJih3dtDOkJbynZ/BiM76fzlu1aQxupAfGctmtCcAi5aElabyyu
	E3slAj5F23BjHc2OqLIQbt0Xg4jZbtrzQBU+7lWNDChHvstidpyZMFYUGIET3ce7
	ofZJzIdEsVlnLRxS+JHQ==
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ux20esxcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 03:53:33 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hb/ieZ5dOSLTGeY2Q372KoRuJuNo9mF2ZHAbT2IbutgyAQKpa/77jrUtmSSCWIWEins9ql8Ev+0Y8e2O8fJb8aBtb8GXVfF9mQmA0fm+QuDbK/gopJctjQrsOus34wmWly8/076nvd04by/Hi6atfFxGp/rJglKY5tt+9+lZMbAnj3TBRZNsHBbuxTsbhlvtebx3pWGIJPA4mxY/uuJ9pijptGZDy0ZBZDGcr+pmon044fG/KQPut6acTrGenAyeAFXJsa/uZeEbXjyRSZ+HO2Y1GiP2qqYnMZ4aC8dgA1SepcFPwLCOVIlE98rFGuaWfcdEFGitu2zFUdr2G/hPIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TcOKV1nKrWe7dTHgOTkOP0ky8SCIHbUtqbkpiwBVNec=;
 b=EHXYzSmyp6No0gc1uS2BQ3TFr/0X15v24hGpZW4p+V9JwEu2QZu7Oke+t0w52Zf0kzxiD7Wy3iSyo3fm9QCo8kp0nRDvHU4uTyYNzXYsoledXLNUlvYqiV0LTvCbZIdidiBK7S7nag6/XicUW1g4UPK2EMSk92SPFe1AIi/sZI0qwRIFZHDnoVS4K1Aeozau48Gx6Bck3PA+/ryi+quLE092Q2ML965m5bfbqxh3xYdaYDkCHFsGboPtC926FgYUGL5UIkAWhWD7flAIaXeut0/BYriTPv675jHMRnocu3IkGxgCoa4gVBUkAzUXW8hqlszl3/s7paFk8D4IdrFWgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by SN7PR02MB9404.namprd02.prod.outlook.com (2603:10b6:806:329::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.28; Tue, 12 Dec
 2023 03:53:29 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::f807:ae10:1c6e:bb20%4]) with mapi id 15.20.7068.031; Tue, 12 Dec 2023
 03:53:28 +0000
From: Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        "Gaurav Kashyap (QUIC)"
	<quic_gaurkash@quicinc.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "ebiggers@google.com" <ebiggers@google.com>,
        "neil.armstrong@linaro.org"
	<neil.armstrong@linaro.org>,
        "srinivas.kandagatla@linaro.org"
	<srinivas.kandagatla@linaro.org>,
        "linux-mmc@vger.kernel.org"
	<linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org"
	<linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org"
	<linux-fscrypt@vger.kernel.org>,
        Om Prakash Singh
	<omprsing@qti.qualcomm.com>,
        "Prasad Sodagudi (QUIC)"
	<quic_psodagud@quicinc.com>,
        "abel.vesa@linaro.org" <abel.vesa@linaro.org>,
        "Seshu Madhavi Puppala (QUIC)" <quic_spuppala@quicinc.com>,
        kernel
	<kernel@quicinc.com>
Subject: RE: [PATCH v3 03/12] soc: qcom: ice: add hwkm support in ice
Thread-Topic: [PATCH v3 03/12] soc: qcom: ice: add hwkm support in ice
Thread-Index: AQHaHQaGEg6dgOyltkmox7SDIUO7TbCe3ykAgAZAmOA=
Date: Tue, 12 Dec 2023 03:53:28 +0000
Message-ID: 
 <BYAPR02MB4071DEB386C1C28B09B8278EE28EA@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-4-quic_gaurkash@quicinc.com>
 <up5gjtun7a2hfwvz47422xjxwt2mhxtn6m4yal5jxa4aneqn3m@7msl7k23hjhb>
In-Reply-To: <up5gjtun7a2hfwvz47422xjxwt2mhxtn6m4yal5jxa4aneqn3m@7msl7k23hjhb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR02MB4071:EE_|SN7PR02MB9404:EE_
x-ms-office365-filtering-correlation-id: 836fcd64-e7e2-48cc-7516-08dbfac5e663
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 qpLLCNvKdek4f77fLTHAoepotP0B1nbYAbEA4CPvYfp4jNPe/2ic+GpmGUyokidqUZ+vpDRskQl6dQ2jKtdnzAD+gw66XGRN4zTYjafGfo8HDV346Cq4umtm1v8PG6/R3O0jE+mUgfVZGVcIRWxsVUML6/i/lktQLZq7y39tfpMMcPYe5yAhlqRhjexiwMEaT2tf5ZUvtWd8Xn6iKtb9fESvdSWZmPQSViZpN2d1dhC2UCy3rK1+zN2MKGekuYgziflgVQIHb6oEc6arrlTZahjvm/ABIqjm481HgOkEn/K7xF8EQ6N+wNdtlrR+Q/XsyA37wtuREzS174osC4aXWWysO6/G3AiOLwkzIMADGvIheXpfEtLwVSiuo0BnXXFcqESYRTvLQFewXd3vPWzAQlfJKF7+ojOuM41HmZH/QMKKhi968uu67/oatq5PQ0RX8Tr5GMaajkvusVmaV8wuBR8t/iOI7zjrlCOVoj4Jb7qsgtVOgQMIk67vjeA8aEmN+28k4t0Pa4AibUvyW9vBppsm1QLv+DMGGQ17FjpQUBW6VEcApYFGWkk4dYtFIRPwZjDG0FHk/crQTfA2qGw4gTs77Gi4Sv1G93iitEqTtUROeK143TQ8BSX0IsurdsVk
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(396003)(136003)(376002)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(30864003)(7416002)(5660300002)(66899024)(83380400001)(41300700001)(122000001)(38100700002)(2906002)(66476007)(38070700009)(478600001)(316002)(54906003)(64756008)(9686003)(66556008)(66446008)(66946007)(110136005)(76116006)(33656002)(7696005)(55016003)(71200400001)(6506007)(52536014)(4326008)(26005)(86362001)(8676002)(8936002)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?NUNS1d6RN/TstDgO8dXo5TxezvgjXZuSEGU3sHoSwAIpZKQUE8max1r1y2AG?=
 =?us-ascii?Q?vbfLF9ZT5QbiOhM8P3JIsJdgOIbh+X+cTTPPKswHMCYTHDLpZ2BBx/+F14Jn?=
 =?us-ascii?Q?hnjS3QUoBoHXZVLAVWh5bQPTWW0wx9DggBzAJj+aA/eRl+BFR2h8bVYzIr9v?=
 =?us-ascii?Q?jLp/93JHsob2wa1mYukXbg+EKs4aJnGb8iylVfycEeIkXsnE77hTvsjaogi2?=
 =?us-ascii?Q?gWVZNFgafcdHEbbKTMNJAex+MqVXIarnzXSIXPodj9N8djjMJyDOjE8qHnkG?=
 =?us-ascii?Q?0HRbwm4TZkxFt21qnu2V/vQ5CczSJptvqeJB1LMIBkwEOnCff4xb0QqzU8jK?=
 =?us-ascii?Q?0dWvkLwicq6NO5JG1oFUQCL0NY8odU9NOrJyc2ZiN77WSNRobwjAvzsXDytv?=
 =?us-ascii?Q?jNAJ98SnMj1XqbGvtEczQaTuslmKUpfeeFzApFfRjcfIHfXtfH/eXv8Mhrzu?=
 =?us-ascii?Q?dLI03eeiGiVosuBP/1u9NN5TMOxlQ4H45KcUVZam35pQfPQcbB4m9hLFTU2X?=
 =?us-ascii?Q?6sXgTtlu6vt419lX8GWZxjTslERZQVnuRivOVCGsXStQkp9gizULHTbLdbaN?=
 =?us-ascii?Q?12E6EpkX1W7croqIYQGRkBXAcIGyo8joipZrF8yhHT+gJY+OuwSl/dLRFWtd?=
 =?us-ascii?Q?krehlic/qJipRra28TjQlLG7E6epoOuND+Kei7JKUaXEUyEd5J2sxSJ0hM35?=
 =?us-ascii?Q?VURgq1Jjy1vsW+U1ffxD7ERfKoE4ba+wGCAwMj1qKZDWSD7PyuZaRTVlBVvu?=
 =?us-ascii?Q?uvhPaHE+ov6lywQkmT77YvTIzfXnBvwE4RS7Jxdvqk5UFVFyNG8dZC4S4VZu?=
 =?us-ascii?Q?ioVvZOr0kZztjIyLBVTrMg/6nWzJURGDPoCGiTraM+5MDSVphdCoYQFleMQT?=
 =?us-ascii?Q?CvD4JBeKdlbil5ZPCp/S3kPIm2QoY8qDouQoNAi+Dq+iFsRBMsp/a+o/3531?=
 =?us-ascii?Q?mwZc62zHg41CkudaggXY0Wc331G/8JT7mYKroloVnX0i3j9ZgXJ0G+cZWZPs?=
 =?us-ascii?Q?hA2e1MRvf2+6cEODtg/72OtdugHCq1Ku0zG8RTN6T07mBTDHg7iCaaRvBSyS?=
 =?us-ascii?Q?f/9Qov7L+ZhRZ9tstsDHCyAGJvMla2aljZnLUkPQ7tF0DYRevaoZD+TKk57q?=
 =?us-ascii?Q?3dtkuy3RGyWc3JWRJvxZCPC3we7sSEKSgJ1GKAP2C7NgpqHi9i6Z9ncZCeaE?=
 =?us-ascii?Q?ZqU165x76IfTv5g1zJ+y/1Pc046V2INYHSaDHBcW/D1a+7PAUulBXEZoLAF4?=
 =?us-ascii?Q?eGXM9CqwSkWxIvKCMO2d0/OLhfm6bqRHze9jX32kyJRGQsr12m+kSq6ecUgL?=
 =?us-ascii?Q?LULJI9QG/OZTrd2oNreie49UU7XCp2Z6fhHkzJfxFWkWJau2u4zdgwIWN+1a?=
 =?us-ascii?Q?duaKvFHVBaTvro+DxiWSVwrs0jTpYgvgorNX/LVJNaA84dkgwjgJEpqndWg4?=
 =?us-ascii?Q?kkdn1tTIPscAHd/I5mdxKSLxy9IRwH3256FY8iQwO8nD4L8Igrl2aVWT+UCH?=
 =?us-ascii?Q?8GicmfWYqk/blocLDdHJy1ZMgl9/crtzUCFS8WkCzQrHYyqPCNVh+D/ev18w?=
 =?us-ascii?Q?pnG63TSLp4tF6qt/oBAyAkQnb4Zo1UlV9yMtPvCz?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	w7kz/UZrBb5daP9As6DdjCO7YrQ55gKNJpebRqpH+aDDM9qqlu32e6MU7DNni4eTOTsTfH21AYuINCn1Zs6xU+MKHDxefNuSFv580rVB+MtVy3rzsh8/uHaWaFkPMxjNPDWLc/qexcZ3PBAcAKmSUQx4LeS0uOepMvMFEXJz774AxH5tpRQftGfhptwO2mJheie8YvLyaRvJ4dAY5GB4QCujPqhM5ObpZTAHYnL6lN0xn+IlmPiCD+gvtLhWbbzb/oz0Mygda7hnkZ9dCLXCr4vqvwlzFiHoc4KX/7DYHeHcTTD1SfgXWybjTjMy7NpxXuhuAMSlvELmWp49oBCiNYCo8xX9df3Ej+JGE2hb//V5EuUupyP16Gvx7jLoxwxZzsF6Q8/8QmJyEfk2x43z6Ip1ar/iMGEoy6QyJMG+SPvg1KjkcijSrqQYdDSKIQN9sagsOBUggqlH7vHkmmJkDnVeKL0hgQMXehezF7V8roC+dKR1OfZcXSkK8hIz5fQeiwuKghFjdTreA8T0D6d+IMHc/Q+Fc84/IPboed9C1x8AA9VnQoWgZgG9FdA/G37IZUvIh/d45BemOxNINiGb75dMGqQpwA47HSc6FwFq79rRPvGKXpYHwcNBfZKr1jph2doTLXSamYiAkyC3zhu50hgQIXTB6gdBg8ySeDUU2XYUHsaU5XHIIsXy+FMfl1SZbEdqFyJH+yiq+un4HYlxOftamYmE2Jnahlp8H9asnH9fovI7bU8W0H+SUnIHXjNoUnrSAtKn+vMD4PYfj6zU4QqWDOfJfyotM8xOr4qmYHvfwcljq6VYtt4gofbbvm95totKXD3gpTg0HYJhBaq2oTOaKrLuttKGv+9vnvJwqcbYirA4U37veIX9F1ykoLB+
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 836fcd64-e7e2-48cc-7516-08dbfac5e663
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2023 03:53:28.3768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zgevk4D1R4LlTlS2njE1xg/WkD7EOs3euk2Dv1w7rlRiskm7cNlw4Amq5t/Lop3nwOYBxaCr66jiSh0LkPG9XiU7BGxZkWBGng+Gb7ygHRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR02MB9404
X-Proofpoint-GUID: 9mYc_px6nxA_o7s_DXk7puwVolAiQuAp
X-Proofpoint-ORIG-GUID: 9mYc_px6nxA_o7s_DXk7puwVolAiQuAp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_01,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0 bulkscore=0
 clxscore=1011 suspectscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2311290000 definitions=main-2312120029

Hello Bjorn,

On 12/07/2023, Bjorn Andersson wrote:
> On Tue, Nov 21, 2023 at 09:38:08PM -0800, Gaurav Kashyap wrote:
> > Qualcomm's ICE (Inline Crypto Engine) contains a proprietary key
> > management hardware called Hardware Key Manager (HWKM).
> > This patch integrates HWKM support in ICE when it is available. HWKM
> > primarily provides hardware wrapped key support where the ICE
> > (storage) keys are not available in software and protected in
> > hardware.
> >
> > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > ---
> >  drivers/soc/qcom/ice.c | 133
> ++++++++++++++++++++++++++++++++++++++++-
> >  include/soc/qcom/ice.h |   1 +
> >  2 files changed, 133 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c index
> > 6f941d32fffb..adf9cab848fa 100644
> > --- a/drivers/soc/qcom/ice.c
> > +++ b/drivers/soc/qcom/ice.c
> > @@ -26,6 +26,19 @@
> >  #define QCOM_ICE_REG_FUSE_SETTING            0x0010
> >  #define QCOM_ICE_REG_BIST_STATUS             0x0070
> >  #define QCOM_ICE_REG_ADVANCED_CONTROL                0x1000
> > +#define QCOM_ICE_REG_CONTROL                 0x0
> > +/* QCOM ICE HWKM registers */
> > +#define QCOM_ICE_REG_HWKM_TZ_KM_CTL                  0x1000
> > +#define QCOM_ICE_REG_HWKM_TZ_KM_STATUS                       0x1004
> > +#define QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS     0x2008
> > +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_0                       0x5000
> > +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_1                       0x5004
> > +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_2                       0x5008
> > +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_3                       0x500C
> > +#define QCOM_ICE_REG_HWKM_BANK0_BBAC_4                       0x5010
> > +
> > +#define QCOM_ICE_HWKM_BIST_DONE_V1_VAL               0x11
> > +#define QCOM_ICE_HWKM_BIST_DONE_V2_VAL               0x287
> >
> >  /* BIST ("built-in self-test") status flags */
> >  #define QCOM_ICE_BIST_STATUS_MASK            GENMASK(31, 28)
> > @@ -34,6 +47,9 @@
> >  #define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK  0x2  #define
> > QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK  0x4
> >
> > +#define QCOM_ICE_HWKM_REG_OFFSET     0x8000
> > +#define HWKM_OFFSET(reg)             ((reg) +
> QCOM_ICE_HWKM_REG_OFFSET)
> > +
> >  #define qcom_ice_writel(engine, val, reg)    \
> >       writel((val), (engine)->base + (reg))
> >
> > @@ -46,6 +62,9 @@ struct qcom_ice {
> >       struct device_link *link;
> >
> >       struct clk *core_clk;
> > +     u8 hwkm_version;
> > +     bool use_hwkm;
> > +     bool hwkm_init_complete;
> >  };
> >
> >  static bool qcom_ice_check_supported(struct qcom_ice *ice) @@ -63,8
> > +82,26 @@ static bool qcom_ice_check_supported(struct qcom_ice *ice)
> >               return false;
> >       }
> >
> > +     if (major >=3D 4 || (major =3D=3D 3 && minor =3D=3D 2 && step >=
=3D 1))
> > +             ice->hwkm_version =3D 2;
> > +     else if (major =3D=3D 3 && minor =3D=3D 2)
> > +             ice->hwkm_version =3D 1;
> > +     else
> > +             ice->hwkm_version =3D 0;
> > +
> > +     if (ice->hwkm_version =3D=3D 0)
> > +             ice->use_hwkm =3D false;
> > +
> >       dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
> >                major, minor, step);
> > +     if (!ice->hwkm_version)
> > +             dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not
> > + supported");
>=20
> So for a version < 3.2.0, we will dev_info() three times, one stating the
> version found, one stating that HWKM is not supported, and then below one
> saying that HWKM is not used.
>=20
> > +     else
> > +             dev_info(dev, "QC ICE HWKM (Hardware Key Manager) version=
 =3D
> %d",
> > +                      ice->hwkm_version);
>=20
> And for version >=3D 3.2.0 we will dev_info() two times.
>=20
>=20
> To the vast majority of readers of the kernel log none of these info-prin=
ts are
> useful - it's just spam.
>=20
> I'd prefer that it was turned into dev_dbg(), which those who want to kno=
w
> (e.g. during bringup) can enable. But that's a separate change, please st=
art by
> consolidating your information into a single line printed in the log.

Noted for next patch.

>=20
> > +
> > +     if (!ice->use_hwkm)
> > +             dev_info(dev, "QC ICE HWKM (Hardware Key Manager) not
> > + used");
> >
> >       /* If fuses are blown, ICE might not work in the standard way. */
> >       regval =3D qcom_ice_readl(ice, QCOM_ICE_REG_FUSE_SETTING); @@
> > -113,10 +150,14 @@ static void qcom_ice_optimization_enable(struct
> qcom_ice *ice)
> >   * fails, so we needn't do it in software too, and (c) properly testin=
g
> >   * storage encryption requires testing the full storage stack anyway,
> >   * and not relying on hardware-level self-tests.
> > + *
> > + * However, we still care about if HWKM BIST failed (when supported)
> > + as
> > + * important functionality would fail later, so disable hwkm on failur=
e.
> >   */
> >  static int qcom_ice_wait_bist_status(struct qcom_ice *ice)  {
> >       u32 regval;
> > +     u32 bist_done_val;
>=20
> The "val" suffix indicates that this would be a "value", but it's actuall=
y a
> register offset. "bist_done_reg" would be better.
>=20

Noted for next patch.

> >       int err;
> >
> >       err =3D readl_poll_timeout(ice->base + QCOM_ICE_REG_BIST_STATUS,
> > @@ -125,15 +166,95 @@ static int qcom_ice_wait_bist_status(struct
> qcom_ice *ice)
> >       if (err)
> >               dev_err(ice->dev, "Timed out waiting for ICE self-test
> > to complete\n");
> >
> > +     if (ice->use_hwkm) {
> > +             bist_done_val =3D (ice->hwkm_version =3D=3D 1) ?
> > +                              QCOM_ICE_HWKM_BIST_DONE_V1_VAL :
> > +                              QCOM_ICE_HWKM_BIST_DONE_V2_VAL;
> > +             if (qcom_ice_readl(ice,
> > +
> HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_STATUS)) !=3D
> > +                                bist_done_val) {
> > +                     dev_warn(ice->dev, "HWKM BIST error\n");
>=20
> Sounds like a error to me, wouldn't dev_err() be suitable?
>=20

Yes, noted for next patch.

> > +                     ice->use_hwkm =3D false;
> > +             }
> > +     }
> >       return err;
> >  }
> >
> > +static void qcom_ice_enable_standard_mode(struct qcom_ice *ice) {
> > +     u32 val =3D 0;
> > +
> > +     if (!ice->use_hwkm)
> > +             return;
> > +
> > +     /*
> > +      * When ICE is in standard (hwkm) mode, it supports HW wrapped
> > +      * keys, and when it is in legacy mode, it only supports standard
> > +      * (non HW wrapped) keys.
> > +      *
> > +      * Put ICE in standard mode, ICE defaults to legacy mode.
> > +      * Legacy mode - ICE HWKM slave not supported.
> > +      * Standard mode - ICE HWKM slave supported.
> > +      *
> > +      * Depending on the version of HWKM, it is controlled by differen=
t
> > +      * registers in ICE.
> > +      */
> > +     if (ice->hwkm_version >=3D 2) {
> > +             val =3D qcom_ice_readl(ice, QCOM_ICE_REG_CONTROL);
> > +             val =3D val & 0xFFFFFFFE;
> > +             qcom_ice_writel(ice, val, QCOM_ICE_REG_CONTROL);
> > +     } else {
> > +             qcom_ice_writel(ice, 0x7,
> > +                             HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL))=
;
> > +     }
> > +}
> > +
> > +static void qcom_ice_hwkm_init(struct qcom_ice *ice) {
> > +     if (!ice->use_hwkm)
> > +             return;
> > +
> > +     /* Disable CRC checks. This HWKM feature is not used. */
> > +     qcom_ice_writel(ice, 0x6,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_TZ_KM_CTL));
> > +
> > +     /*
> > +      * Give register bank of the HWKM slave access to read and modify
> > +      * the keyslots in ICE HWKM slave. Without this, trustzone will n=
ot
> > +      * be able to program keys into ICE.
> > +      */
> > +     qcom_ice_writel(ice, 0xFFFFFFFF,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_0));
>=20
> This line is 86 characters long if left unwrapped. You're allowed to go o=
ver 80
> characters if it makes the code more readable, so please do so for these =
and
> below.
>=20

Noted for next patch.

> > +     qcom_ice_writel(ice, 0xFFFFFFFF,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_1));
> > +     qcom_ice_writel(ice, 0xFFFFFFFF,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_2));
> > +     qcom_ice_writel(ice, 0xFFFFFFFF,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_3));
> > +     qcom_ice_writel(ice, 0xFFFFFFFF,
> > +                     HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BBAC_4));
> > +
> > +     /* Clear HWKM response FIFO before doing anything */
> > +     qcom_ice_writel(ice, 0x8,
> > +
> >
> +HWKM_OFFSET(QCOM_ICE_REG_HWKM_BANK0_BANKN_IRQ_STATUS));
> > +}
> > +
> >  int qcom_ice_enable(struct qcom_ice *ice)  {
> > +     int err;
> > +
> >       qcom_ice_low_power_mode_enable(ice);
> >       qcom_ice_optimization_enable(ice);
> >
> > -     return qcom_ice_wait_bist_status(ice);
> > +     qcom_ice_enable_standard_mode(ice);
> > +
> > +     err =3D qcom_ice_wait_bist_status(ice);
> > +     if (err)
> > +             return err;
> > +
> > +     qcom_ice_hwkm_init(ice);
> > +
> > +     return err;
> >  }
> >  EXPORT_SYMBOL_GPL(qcom_ice_enable);
> >
> > @@ -149,6 +270,8 @@ int qcom_ice_resume(struct qcom_ice *ice)
> >               return err;
> >       }
> >
> > +     qcom_ice_enable_standard_mode(ice);
> > +     qcom_ice_hwkm_init(ice);
> >       return qcom_ice_wait_bist_status(ice);  }
> > EXPORT_SYMBOL_GPL(qcom_ice_resume);
> > @@ -205,6 +328,12 @@ int qcom_ice_evict_key(struct qcom_ice *ice, int
> > slot)  }  EXPORT_SYMBOL_GPL(qcom_ice_evict_key);
> >
> > +bool qcom_ice_hwkm_supported(struct qcom_ice *ice) {
> > +     return ice->use_hwkm;
> > +}
> > +EXPORT_SYMBOL_GPL(qcom_ice_hwkm_supported);
> > +
> >  static struct qcom_ice *qcom_ice_create(struct device *dev,
> >                                       void __iomem *base)  { @@ -239,6
> > +368,8 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
> >               engine->core_clk =3D devm_clk_get_enabled(dev, NULL);
> >       if (IS_ERR(engine->core_clk))
> >               return ERR_CAST(engine->core_clk);
> > +     engine->use_hwkm =3D of_property_read_bool(dev->of_node,
> > +                                              "qcom,ice-use-hwkm");
>=20
> Under what circumstances would we, with version >=3D 3.2, not specify thi=
s
> flag?
>=20
> Thanks,
> Bjorn
>=20

For 3.2.0 versions and above where all the Trustzone support is not present=
 for wrapped keys,=20
using Qualcomm ICE means using standard (non-wrapped) keys. This cannot wor=
k in conjunction
with "HWKM mode" being enabled, and ICE needs to be in "Legacy Mode".  HWKM=
 mode is
basically a bunch of register initializations.

Ideally, there should not be any SoC supporting HWKM which does not have al=
l the support, with
a pure hardware version based decision. But unfortunately, we need an expli=
cit switch to=20
support the above scenario.

> >
> >       if (!qcom_ice_check_supported(engine))
> >               return ERR_PTR(-EOPNOTSUPP); diff --git
> > a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h index
> > 9dd835dba2a7..1f52e82e3e1c 100644
> > --- a/include/soc/qcom/ice.h
> > +++ b/include/soc/qcom/ice.h
> > @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
> >                        const struct blk_crypto_key *bkey,
> >                        u8 data_unit_size, int slot);  int
> > qcom_ice_evict_key(struct qcom_ice *ice, int slot);
> > +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
> >  struct qcom_ice *of_qcom_ice_get(struct device *dev);  #endif /*
> > __QCOM_ICE_H__ */
> > --
> > 2.25.1
> >
> >

