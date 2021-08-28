Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7893FA2AE
	for <lists+linux-fscrypt@lfdr.de>; Sat, 28 Aug 2021 03:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhH1BED (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 27 Aug 2021 21:04:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44242 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232939AbhH1BED (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 27 Aug 2021 21:04:03 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17S0vfxG002319
        for <linux-fscrypt@vger.kernel.org>; Fri, 27 Aug 2021 18:03:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VFum/QYBrSMgTQtuTby0PkkZm2xlIVFgKkKAS0s0quQ=;
 b=EA3zWKBKAdmUTv3cAvRhOTxYit2GZUgCRNU/5hUfu/U1fwAOn3ipqpivCKHE4O7de4nT
 iWMtWl90HgCKr1XukObknCOstqmkNxLlpzVN/Q44swU8trNEY9tqDR9Z3LvxXo9tlIQ/
 OL09tuDGH/Jdfo9CkEvW8K8+yQ2e5cGNZl8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3aq70jsa1b-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Fri, 27 Aug 2021 18:03:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 27 Aug 2021 18:03:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gnc9HaHMUgpluTjc09OcvnYIukJHnl5DGGxPkgKMjElBjq0vadSAbi3VWydujoDQD8RQHUxcMbDmVBFsLjy/+Mr5iOOrb+/0MY3Il267pnDSEcI8VL9lIbNgbb2iuNCq+tX8neVnn3LsnLYWrMrhSGzpdTdicUhqGTpNzDZACBtktrvoU17+Y9ZWtzLWaRoZqUq2JnLVsGq/dlKFRGMx8GMAXuB8h0nwTITNqmcJiqNkVK4hiT5A+qp85KdoIl43NHhO6+PMb49YgFACh3Ohj5uUQMORYcRdzyhQ4f5mWgKMhwebLzQiQAe5zwUhIPfrKPzB0qkzjHPIMBie2wiejg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFum/QYBrSMgTQtuTby0PkkZm2xlIVFgKkKAS0s0quQ=;
 b=J9lKVf1eU8LLvrNFJvXSyj/m52HKBMqvgB34bfLPrhJLWMWBTjEzQ1J9rzQgjWX+CkvkeA7VlqKl7A2MoXc+w4RQNZ6nx8hubfFyhdpkPQ/8NcJ/sHtcUBhGN4MARoDVmyeILS27ziLntfSQQa9rWWEiFgRpOpab3TgVhNu0hvv21JehDeF7Uyu/a68O6LYJt/FUdHJn0FwjVI0QlCVj1kXp92SGKRd/tLjVmTLixBAdrbNs2s9GRjowE7vbg5XPvxGxTni+tYuE1TKs4zXpWCOJoMKLplTxBZzJxXBU9+IZSgixP6hbeTpDManV5XhiVNw2G+3cO2ye8lYc8b6BdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4827.namprd15.prod.outlook.com (2603:10b6:303:fe::9)
 by MW3PR15MB3866.namprd15.prod.outlook.com (2603:10b6:303:50::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Sat, 28 Aug
 2021 01:03:10 +0000
Received: from CO1PR15MB4827.namprd15.prod.outlook.com
 ([fe80::6cd3:5ded:cabc:967d]) by CO1PR15MB4827.namprd15.prod.outlook.com
 ([fe80::6cd3:5ded:cabc:967d%6]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 01:03:10 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL
 pkcs11 engine
Thread-Topic: [PATCH] Implement PKCS#11 opaque keys support through OpenSSL
 pkcs11 engine
Thread-Index: AQHXmg9RCc3Wy2YqPEOZ7nx5L3z4BquGKE4AgAHx9po=
Date:   Sat, 28 Aug 2021 01:03:10 +0000
Message-ID: <CO1PR15MB48272C3F89D0B6789DC82AC9DDC99@CO1PR15MB4827.namprd15.prod.outlook.com>
References: <20210826001346.1899149-1-olo@fb.com>
 <YSfncv8Agfam4P2m@sol.localdomain>
In-Reply-To: <YSfncv8Agfam4P2m@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc79673b-e0f6-400c-4035-08d969bf9ad7
x-ms-traffictypediagnostic: MW3PR15MB3866:
x-microsoft-antispam-prvs: <MW3PR15MB38661F2804A671B4407A59CCDDC99@MW3PR15MB3866.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HZfwNUBOancW+bj+v8XyJGKc0NSmy1CD/SxFmjD3uU/WuR3G8eXdIAv+8HJ6y6mp1ZEHkKZclDkElhsi47N155tu5ESKnsnoIsTsivPAqiWj67GO20etjpN++EYKtLUJWVpgKMnbUaprbjvNxejCF4/RjQD72QrEt4mhGgQwa2LEMyMt6e3c22sqHbvOhOdSsIccMQjorLcvKOtaQ9kiWiypgxlWX4rAangjkFJIbFQVZdJ2rLgyanrjRHq4K9IoAFT2fd/lnG62MvwcrXUYZm1ETY9HNIc1jKazReNC+dfEnf24xHhI867YPQqWlUu9bQRezWfg31xvSBWgsLJgumyArhQYwpd0FRe4gEKwzEA7irGMv5B/QLq34Z2C13DJzGOyMrk9bTdT287Y1kxz3YrRSKy6RvgSvUgqI7TpA38pTtxJP0GZhxr+eR0H6SAV62lUqV8KqFBsG5PEdDMbBQvI61JJL5D3TEBq8f5gtFokdRPdA1lxiLsvsWCk/mqq8CDqclTqZr6IHMm6OEHcckF/4FD0rTYd1fC6WMYAdQWY+hFmaFrD9qu6RCx65YKU8etX4Bt9/2t+On5jPZmgY3s/Z4FXw0jnXQaBB0oTc6/h96u1NAnTB79v/krDKtT4fKNjIs7bCLAPS4IKE6nsgKb2TSYpT9sTcTyobv4tpA3lQLQpRSRMzkVXHvi8EoC1d14ZQ6cmRQDmUv4G2/gfeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4827.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(186003)(33656002)(83380400001)(478600001)(86362001)(52536014)(38070700005)(5660300002)(4326008)(66446008)(316002)(122000001)(2906002)(7696005)(8676002)(76116006)(71200400001)(9686003)(8936002)(6916009)(6506007)(64756008)(66556008)(66476007)(66946007)(91956017)(53546011)(55016002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hfqON32t6eUwVl/BjpdeRHcXUyhSQtGG7O80wCmDJoGT6Q9nbR50gQeTHa?=
 =?iso-8859-1?Q?H7w7MLMRSb8uMcXzMK19AORhFeBRpbNc7JTKuDxLrX5m1UrSOjCtox7aRw?=
 =?iso-8859-1?Q?Ic2e5Wr49S6MYGJuCa/3CT/4CTUZ1y0n33EFwZXTzpyyZUocEyLSpIp+oy?=
 =?iso-8859-1?Q?GCjXOj7pwZToRwTEiDfXuxJDMItr0bEoKD0uMJMl2wux+Bz9A3BQsfxt9H?=
 =?iso-8859-1?Q?yKiR5fO2BUgV/zk2PdKWjn5CU+mo8zgxk27RhelAxVk+21jVluIbuPaovO?=
 =?iso-8859-1?Q?rN4O0+VumTl+ND2Voz89kB+bxixgeLw1lcZsWniHKyELFrOqnMS6Uk4y0M?=
 =?iso-8859-1?Q?KJCYQapwjM/ryrx/ONnCEP5wPc5ovwGB/I3Blpnj+mPhOBMmr9P2jCiCt3?=
 =?iso-8859-1?Q?LDuw85aQqDjonJSoSztA6M6Z44vvSe8IKcDx24FLAGGEERZPU7lJGESKkf?=
 =?iso-8859-1?Q?JL9Ho3PmKn/cb2Cp/RuBkfVmIHekka5Aalw7OSCyjCcImq3OOwrKu+NN9y?=
 =?iso-8859-1?Q?idi0sCuk20lLyol7Pu/hXUKGrQpTLIBZ26o4bZmxBPR7drmE+hVQHb8cuG?=
 =?iso-8859-1?Q?GxAdTmUrPSLXGB9pYZW559cR72QSejQdZ1kVhdD1vxoqK7zvxpfnKAsFI5?=
 =?iso-8859-1?Q?LjXBOXwpWphx6e8imLeucKpawM0VquEYK6UIXX5LKcvFVmmibjyUz/phTO?=
 =?iso-8859-1?Q?9fUMs4IyPWtX/yU2VpbLCFY/Qxyi2oyU53sa83/ifZDPvfEN7N3F7bOzDh?=
 =?iso-8859-1?Q?7v45v+7tCRN+WB3gxecO6uh0gmvSia0lNQDhNFnh72hpzCrv6QCsPdIlOt?=
 =?iso-8859-1?Q?UNDvuEI8IyJaN4KyUuCOIPOsmSMhUnen4FLKlrOmgZEtxdGnVl5Rrr2riT?=
 =?iso-8859-1?Q?4+XNukELIEC9xxSzAUHQTLGJdTgtdiNabk8j6s1NJNrLyAdEzo3iqHBGkg?=
 =?iso-8859-1?Q?4//fhafGmQ49CUd1qMyh5fQenUyoJE5ebqevIzzNEN5KBx+8ZCOJ1+E7zc?=
 =?iso-8859-1?Q?bf2N3aRGsgxavVHmRFAbUO+/oEiIi/xMHJ/8lKAjLiBNU2xIstED4E22jG?=
 =?iso-8859-1?Q?8XM7rInFbtSHfPZQ3tzeiDwzXioxObidOghaePSSShoZixfylbg7ybEnse?=
 =?iso-8859-1?Q?yPkACIhJpA0Ki+JEJyNYCUvuGXXH8wbqMmBUn4+VbHn+tfPjtVRwHBLi9i?=
 =?iso-8859-1?Q?RURi3blN03nZPEani6Sag+4N4IShNy7KRXnk5Vc74LfRYYTmSW023qPzEI?=
 =?iso-8859-1?Q?bErjVy/w/+YJmUJdMv1CdW/LJDB7MR/iLoLnYCUYnOFn/vpVfKDcZkyH7l?=
 =?iso-8859-1?Q?3Ew/HG+7W6pa6vdgQzSL2f7M6L2N+9L1/Z7zyYt1yxx5hfjElqc77ERd5d?=
 =?iso-8859-1?Q?jZrloAy0iOFv6hhpPoy54jKUmAuZ2NGw=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4827.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc79673b-e0f6-400c-4035-08d969bf9ad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2021 01:03:10.4774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vo3FkIKFjHGHVQI6ySe5gixDk5mIlMusj8ldFYErw9ckiEddkjTo5kNu9ZyamHny
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3866
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: em33V2kepf6AQSs1G68ZVeLVqZ64niPM
X-Proofpoint-GUID: em33V2kepf6AQSs1G68ZVeLVqZ64niPM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-27_07:2021-08-27,2021-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=994 suspectscore=0 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric!=0A=
=0A=
Thanks for the quick response to the patch!=0A=
=0A=
My replies inline below:=0A=
=0A=
On Thursday, August 26, 2021 12:11 PM, Eric Biggers wrote:=0A=
=0A=
> First, can you make sure to include "[fsverity-utils PATCH]" in the subje=
ct like=0A=
> the fsverity-utils README file suggests?  I almost missed this patch as i=
t=0A=
> initially didn't look relevant to me.=0A=
=0A=
Sure! Apologies for missing that part. The V2 of the patch will be appropri=
ately tagged.=0A=
 =0A=
> I'm not particularly familiar with the OpenSSL PKCS#11 engine, but this p=
atch=0A=
> looks reasonable at a high level (assuming that you really want to use th=
e=0A=
> kernel's built-in fs-verity signature verification support -- I've been t=
rying=0A=
> to encourage people to do userspace signature verification instead).=0A=
=0A=
We are currently going forward with in-kernel sig verification (and btrfs),=
 but=0A=
I'd love to hear more about the userspace support you mention.=0A=
=0A=
> Some=0A=
> comments on the implementation below.=0A=
> =0A=
=0A=
> This comment is incorrect, as your code uses keyfile even in the pkcs11 c=
ase.=0A=
> =0A=
> Also, keyfile is only optional in the pkcs11 case.  Please write a commen=
t that=0A=
> clearly explains which parameters must be specified and when.=0A=
=0A=
Yes, you are entirely right about this. The decision to use the --key argum=
ent=0A=
as an optional PKCS#11 key identified was a later afterthought and I forgot=
=0A=
to update some related pieces of code.=0A=
=0A=
Will fix in the next patch, as well as address your other comments.=0A=
