Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74B8404239
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 02:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348391AbhIIAVr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 20:21:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61808 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241998AbhIIAVr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 20:21:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1890Ej1a009959
        for <linux-fscrypt@vger.kernel.org>; Wed, 8 Sep 2021 17:20:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SRvta3R45P+s9S6yUp1VurC7F5HRd6lwSICkd2Nn8iw=;
 b=LHXDChlzjImhPU073iR6/q1GgNgonnTg54OB8zOfJgsqnaCYZDSCFB99I4Wv0M5qbVhj
 8MqkskUm9f7dgj9DctdZ4PC0b5/S5KDYDvfsdcisLqo+IrPajfQJVig49YjWMDE97QN3
 134fhRoorCTFT4vP5TUdk+/5j9BCMum6Oeg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcq53sxp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Sep 2021 17:20:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 8 Sep 2021 17:20:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9t9lfj/lbd2YAgnl4KCRKtayv7B81VWp8zffbmZUFfNVWDS1+3WTvBnaUcW7sUEs7pQHa1k048RFJ3UURjPbgEsJtQvI1uYAt2QKYRilPLpPtJfzD8XHYNsuNkqNqdhLqewrzCCX3qlH7KgFaWV7yObxXJxmP6PLhJC0/GB8OOHrDBP71/tJ53mfkRlGvDqCD8BHUJkY5qIOBHGNcERxc4ttpdiwFZzQjwC0H4s8k4IvKei8SlFL5ZGTCBcBE/bEkboioFIMkmkTrcEyEsOmUK6Lc/0STYBGxyafxkmZqLzAQNaIuBNrSdUrJjSANHQtgwSgUiEiq9P5RRLx243tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SRvta3R45P+s9S6yUp1VurC7F5HRd6lwSICkd2Nn8iw=;
 b=oJBNj7ZxHfCQx9cXr36u53bAzyC5PEJyH6balG7+9M09ncZMKw5sJzT0HBj+mTMIlrazeel4Xz3ASlA4PZxfBDkfsJcXoEECZZTrZsQB5itYhzWp1nTy+4UUII321Jievz1yp6HTkQRv65ILGkTnhwiulXbhVW2PqqC8uOxU5SY5qLbRRvAgj0TxbJyTwK5xCmgqgI/EGUuAGg1dJ1j+/KMthVEXzNWyOb/xBWHUpdshbhsIU3hQJfL2GhkaR1bAKKqG+S8hOXPXlxRp1+w7YwNTgAZi2rErc/eGGrgfLOGHHkvtJPDLROoo1AkjnQcNDJvBR6l1d04aRNUEzVbo0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SN6PR1501MB2110.namprd15.prod.outlook.com (2603:10b6:805:a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Thu, 9 Sep
 2021 00:20:35 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 00:20:35 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Topic: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Index: AQHXm6xcGarxStMvPUS3MVkBynObEauaztiAgAAMJniAAAXVAIAABG9L
Date:   Thu, 9 Sep 2021 00:20:35 +0000
Message-ID: <SA1PR15MB48244271F45CF01744C5074EDDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <20210828013037.2250639-1-olo@fb.com> <YTk806ahPPcuz9gl@gmail.com>
 <SA1PR15MB48240CCB6C38535A022ACADBDDD49@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YTlL6Josq+79r/ia@gmail.com>
In-Reply-To: <YTlL6Josq+79r/ia@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: e8237c32-e52a-3030-17a6-a1d59a31648a
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5de19263-dec3-4b8e-534f-08d97327a503
x-ms-traffictypediagnostic: SN6PR1501MB2110:
x-microsoft-antispam-prvs: <SN6PR1501MB2110F558927134F60572DC6EDDD59@SN6PR1501MB2110.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3k5s+J0eobJz0Ezed4h+XNqVPJWibKYn4RFV0nAZFw5gmqXdHY0Jj52W4DECqoxtNB5RixACNMRCl07gsCPaAy4TQV4PM5VRPn3v9mPHxlGfXlnJeKC3pwvzQTawpqklrn2RO1C2fu/xNjzPx+GdEtbVdj2wZt5AFHmjMy+O1Mr/XgKHxtPndPE6yldChdZwea5KDRSAFf0gy+lN+0JSPkTH4ANFyui4rRx8lt3cnDR/ti8HXA4LnBXluIhWeAr1c65xzxGOBoGz67pdluUMVvOvNeIT/V6PueQuwld3gHWclvNPGTnW2tiEN5L3qWfLIirYbZg47vDHvX0WjaKm+lI+Ot4U9O+LbIIB0en8Q0IaYy1UGy4LsMHft4DNvYAdeXdLBiQCnakLVS0uH4ptdsOjA/XGhoGprAHbZwCrLFXjYayJOlIpAmrJIXPjJmSkMdrhgOyr9K3L4G6H+kyBv2VswSwQlneJeNSS4UbqEq7DuHLcmRoWYTrRW0DjNiASBU1e30xp+Ypd1gIbpiE+hX7C+GB9I9UqOJHo46KQFY1ttNJslefrVc4ccRgD1uXKR/9+U9hqYiJI/OaNMmp7b7V3scPYwVIamjg+3/HzX5r1nKZmib6uhNqonK9ExHLDAT94qlaOMh4WSxSJmUjm01iuBDwDmR2+k0nYelJkt0UJjNNJN61D0JKiCgZYQHMifOJFGBlJkGve018n7x5Mkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(4326008)(38070700005)(6916009)(6506007)(5660300002)(8936002)(122000001)(33656002)(38100700002)(55016002)(478600001)(316002)(9686003)(186003)(2906002)(7696005)(71200400001)(64756008)(66446008)(66556008)(66476007)(52536014)(53546011)(91956017)(86362001)(8676002)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?VrUd8aDtSJ1i8dU517wNDe9rEEq2TlLkyZ/v3+CpP5CLVoXB5rZazF2wR8?=
 =?iso-8859-1?Q?4on8KEK4RYclh3omW5K1urPovKT46a9qCrZ7G8TNjQqYrKb2hF2Al6jfGw?=
 =?iso-8859-1?Q?8OblCvO0JHm0+hMJax+d6ScoB+Sa3edThcvcFS3TX7GvQxIxXzctVKbVWy?=
 =?iso-8859-1?Q?URvS5e6mM+xDRU72F8pTgmaxuFrgh0obco4rvG9Cd+TDtzJUEyguirqHCX?=
 =?iso-8859-1?Q?J/QAEi5bKG8qfz6f+mh0BQSPpyEf96fG6RpM5s9REjFZVmoVCPA9UOaM59?=
 =?iso-8859-1?Q?OgL/llYCbiFD24OzjscAuxorNzEWCYSAhwVBWsGbnyJg1RSS2+p7yhkO0C?=
 =?iso-8859-1?Q?JjmKzqGR5OkDPK2fi4eBTyehoo1F0Cc6zSIwCRCUzZrprl29G3mTzfFor0?=
 =?iso-8859-1?Q?t3Jy0WFGAy+Cvdzy54zeP6iFEhv4HmM1cUQjzspWDJzndEbTluFuiMmpGB?=
 =?iso-8859-1?Q?L3ktPOaoQGrUysghoc1bttG8sSe0PBOr6PulFVu3sVL8KU89i28dt/MZJK?=
 =?iso-8859-1?Q?U29/qXLRZT1WxkZZw9F7thvi6MZX3C1TjftAwWZyixXw/OpShzvgzklhdd?=
 =?iso-8859-1?Q?fiEuXCjUnY842K+B2qfQJOLwZaWnLuianHyndL61w+3d749mNx3425YARE?=
 =?iso-8859-1?Q?9T9tpK4MKQfA83AI8lWuYlRsMMc5WyqZtzmqJeRD7J8H3V+1gM5ivrvawd?=
 =?iso-8859-1?Q?gps1tlkSFjKKDSwnp5nkU7DrfLclRYXlUyIpzRLGDpKQ+RmyMXfvduFe9a?=
 =?iso-8859-1?Q?DuyRRlvD1g5O5Dq4NMnHFYjqyB0GNZIB4fn6tdUOq3mlRIkDJiIMDoULXb?=
 =?iso-8859-1?Q?QOzjMiEDokcr42k38J7bPy4PXqVuOFpsHTeNo8NyfZHI29YaYatRFA7+K0?=
 =?iso-8859-1?Q?6l5sOevAcNIi9bTipmNxS81RTrhH8O5xWLjBuYmbPAcBk0VeTmKgsutaeK?=
 =?iso-8859-1?Q?2lac2Q4e1H7C1NtuyhkAhv2OajZqKUddG/wAMu6qnt20YO7ODKOljWlElf?=
 =?iso-8859-1?Q?CxyE5ye3D8SOrihwQImb+Ui48Jh07OqdMWIM2z9xHIuzXrAFAyjzzQ0WPu?=
 =?iso-8859-1?Q?tKCM6fHt2Wq7JzdmIM6nyNaHFKqNJQlZ6lYYNmzZIwjBc5Vt7lMz2oX0Dx?=
 =?iso-8859-1?Q?u0+KSr+vC+Zmrrv+lvNgWEkFJnjSUydurFGTaa1vUOc3uV4YshBExC0bjW?=
 =?iso-8859-1?Q?WgiM43MKVX3hHSKtB/EjCm1fa7jSa8BTpepKXDOnRIuUAAwr1MWaAbmWOC?=
 =?iso-8859-1?Q?CHr1qDteXy5Ex+0KdyPMJVnwfCgx3J+P+GQyHJ+fRdizvV+NxBvL0VvPfJ?=
 =?iso-8859-1?Q?7XFG+2RJY2WMT3L/Cz1rovoCCe+EdjRpM26kB3EDsfcyjIlCklYcEmHUpn?=
 =?iso-8859-1?Q?SzWRAFgkk248anZmhBS/az+pX28GZLtA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de19263-dec3-4b8e-534f-08d97327a503
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 00:20:35.7460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPZVnv++CtpuqiVlP5hF4MWhvCACFlHowjI1Jkv26KLRX7oyvK2VKpSzhpXj7EoL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2110
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 7Twc7ke6jrVWqVe1fLqJsrMCHE7kUh0O
X-Proofpoint-ORIG-GUID: 7Twc7ke6jrVWqVe1fLqJsrMCHE7kUh0O
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_10:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=846 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wednesday, September 8, 2021 4:48 PM, Eric Biggers wrote:=0A=
> Regarding struct libfsverity_signature_params, I wrote "Please write a co=
mment=0A=
> that clearly explains which parameters must be specified and when.".=0A=
=0A=
Got it. I assumed that the detailed explanation in the manpage covering the=
=0A=
same parameters would be sufficient, as repeating it in struct comments wou=
ld=0A=
make the information redundant and require reformatting that part to multi-=
line=0A=
comments.=0A=
=0A=
I can add it to the struct comments, but this will mean I'll need to change=
=0A=
them to multi-line comments (above each struct member) and add empty lines=
=0A=
between members (following the same commenting style as in struct=0A=
libfsverity_merkle_tree_params). Are you okay with that change?=0A=
=0A=
> Also I mentioned "The !OPENSSL_IS_BORINGSSL case no longer returns an err=
or if=0A=
> sig_params->keyfile or sig_params->certfile is unset".  That wasn't addre=
ssed=0A=
> for sig_params->certfile.=0A=
=0A=
Ah, I see. In my patch V2, after your suggestion, there's a new NULL check =
for=0A=
certfile in lib/sign_digest.c:87 that I intended as a replacement for the=
=0A=
previous check in lib/sign_digest.c:337. I think it's a better place for th=
at=0A=
check, as it's in the place of actual use.=0A=
=0A=
Do you want me to place that check back in the pre-check logic in=0A=
libfsverity_sign_digest()?=
