Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A943F2B5C27
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 10:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKQJrm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 04:47:42 -0500
Received: from mail-eopbgr70135.outbound.protection.outlook.com ([40.107.7.135]:12407
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727729AbgKQJrm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 04:47:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNuhpTOkw3C5tX/ljSNzfUZoQJdLBo74uZtpiMT1FQWpnvTj6I2mAfAwYykxkvF1Uy+iDwSnlPvgmS7tP3z5+hfhQYe5/TbxdXhNQeOfDvfYv6JQ4tV6Lj81R7QLLi01wh1tXQ3bAryMt2JO4HYWenVp/Uh3v2a1cSaLwCXsDlNqEmTIB/AcU28Iiyg7q8YlK3SDIQUIzor++ohr/kOJ9atoXYWRsoyfYuKoC7cP/T0YIqiNCG5oOPRXGRigoRGkxS/GOWJICEyUKV5ZazJrbvkydvZmIe+14OI4yoprm+uh/ZQtX5xcTJTO3D49vZ83JDgYb2ERKOawy3u2dyef0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqk18xA8IzLz2VixrPlkkLs81Bi/6VSdU0TNVeQVPSo=;
 b=UCS7Pw/dbB16dhBmdkUmEPXQi4Fvd2xq88p1q7OwDLsdM4CCfJu9LCJyL5fQAhpOcaxoHknWprZFiyxFjvWv7eOqzImgHfTwb5RZodZH8ObTkkpNaGbuv7R9gYS4/HLwlweCD1IlVXOMK977eqFoPdiClKY38SntvULu4PZPzZff5x00tZJCA5v6jf9R2uU0GpdGrOWa+rVhDQD43m+A4yZoTG3kGu0+H1nANkjE7fRI/fROpHf5VtJTQeaaS154ONSvZmCt/XIR+QBYssEy9AOizoVLFuZw2DCpfNFdDKxz1gaR4eHlJgEktxdLCTb3LPGZVUwPIS1pjDBsLi+Fuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fqk18xA8IzLz2VixrPlkkLs81Bi/6VSdU0TNVeQVPSo=;
 b=FRdjlVpt6R5xxlmWPY/Vfsk50vYuQnTa/u1F6KgJJM7PMBWLcmIFMJhax5vrr9xsqX7mFuFGhNG5EYl/7buJJtnMvXMvM3kYk/6XSrUWHpgrok13gg9PNQa4mB1uN1TBkLhFsu5K6P0cUsGzrh1wwZKasP3b0icfs5C8UviXU0s=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR83MB0162.EURPRD83.prod.outlook.com (2603:10a6:206:25::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.6; Tue, 17 Nov
 2020 09:47:38 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Tue, 17 Nov 2020
 09:47:38 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 1/4] programs/fsverity: change default
 block size from PAGE_SIZE to 4096
Thread-Topic: [fsverity-utils PATCH v2 1/4] programs/fsverity: change default
 block size from PAGE_SIZE to 4096
Thread-Index: AQHWvMavoQpfXIolWkOxRt3TPmrfmA==
Date:   Tue, 17 Nov 2020 09:47:38 +0000
Message-ID: <f1b4d97dbcac6358b33a554be327aba6038567f1.camel@microsoft.com>
References: <20201116205628.262173-1-ebiggers@kernel.org>
         <20201116205628.262173-2-ebiggers@kernel.org>
In-Reply-To: <20201116205628.262173-2-ebiggers@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [88.98.246.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a9b3249-78cb-4591-6a76-08d88addd1c5
x-ms-traffictypediagnostic: AM5PR83MB0162:
x-microsoft-antispam-prvs: <AM5PR83MB016283231DB8DCD976543261F1E20@AM5PR83MB0162.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oii6tH9o7hXMLeIvbBpoUNFyFw6y8YpZlXB42FkowrPu8Hk7aqqOuG+J/4ymqgutTghQuPB+tmwHREufTTEepkMETOcRiFEUO3dESef4hXMBmh2+I8XmH9NRpqO9yRxqBIDcCt7L/QohVTXL+j1Tnj0FhgXrJuV8vW2ttbI2CzypD2MwFzb1h2iO75aSiCXdmo1E0qKzxmVBO9HxQdrnI1/YreXQbuWk/SFUHMoV3RVZkkQKMZcoFkZagm7dQkCytCJzzyGF18PDWCAn4CdR3p3WIrrQOQSLRwjz/Anfy1amiu0IOQukd1RyZvqklt7d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(66556008)(66616009)(66476007)(478600001)(66446008)(64756008)(10290500003)(76116006)(66946007)(99936003)(36756003)(82960400001)(82950400001)(83380400001)(4001150100001)(6486002)(6506007)(110136005)(8936002)(8676002)(2906002)(316002)(86362001)(2616005)(4326008)(5660300002)(186003)(71200400001)(26005)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rSZ7h7++yJ4nOiHUwekmj7SXkaOPN/ug980N3OZ9a/G/e1+0R+HkPxowOxjvyuCb5qpS9psiUq3JVJdXLqe1s1vCv7XJ0XMDRgpu6khUs6oJismYm/fNQSLdFPoUHXMClxLSeC/+wfa8Ea1oAQebyqdEUzM5WH50gN0bvMFx8S8b8jlHgLW3Cz6O0YUYYNtXI8BiBfPOYznFdS9PVsdqtww41dWtVwFT7+Yh9QYSB+bVlV8M8TZUSWlcyCbwzuBAOeQ+ORynC+vO50/dpWRvg5QR+jO1SoSHu0Pvfi9fEN6d+ADNeaT/lallTBLp3y15twCRmWgh6MZJJFYgM4+aS3ncChHTeKt2tvX9JHjUaJa4qizkWIGbeXWFJjWRCSJb2e8/bz1wAS3yDJiJ6Mjvn/XYHL1I/vWewAceE0zyU3/R3byw3urc++YXnIOnqWfkh+sGTMh0K5u0Ao2rPxoh5GOQJrnW6Ey113YoYrnKX5Sxq6lOl9uN5P4Qoc4+/xjP/5autbpGapp03XMLZ8hG13vCzrteEN94yxEE4Pcn4776eHuvoUkyrKgtAz1YxZF4BmvuzlNEVHjSsCrLgUei3nc40+0lFN5sM0NWvUv1ebeAaGTsiVSKnWrM/Z/kprfunYy/HayCX5wNuBhz59IXhpT/9bgjk8+c32bQ3pX0GnkplnpJDBKEpyXx2Onms5o7yrPPV15jjliF3FAVGjK6YUYqGKYouHOB8mE5a4/UX1pz5np0ZlPRj7swweUTFLvfoO5zQLYqyeYeD6yxjhJnokzItUAJKYib6iN46C01fwHgw61ctTa5KcKZMIAUKqdLSOeQLtfbC1XxrWEddmHuBax4Xm+lOh84jIQrtk87Qaj2jIeCwnlMv7LdzAhrvTN1r4D1197NwDoXbL3qGsvX5Q==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-tRYPzABxf52xm4QiHqNp"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9b3249-78cb-4591-6a76-08d88addd1c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 09:47:38.3187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VgtL3YEBx+FVqs/6ZDpDPT8UfSr91I0b67VRYKoxIVHAvEuGzA0AwrPXol7fAom5JUBUibRv5T5+hUcgxG95EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR83MB0162
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-tRYPzABxf52xm4QiHqNp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 12:56 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Even though the kernel currently only supports PAGE_SIZE =3D=3D Merkle tr=
ee
> block size, PAGE_SIZE isn't a good default Merkle tree block size for
> fsverity-utils, since it means that if someone doesn't explicitly
> specify the block size, then the results of 'fsverity sign' and
> 'fsverity enable' will differ between different architectures.
>=20
> So change the default Merkle tree block size to 4096, which is the most
> common PAGE_SIZE.  This will break anyone using the fsverity program
> without the --block-size option on an architecture with a non-4K page
> size.  But I don't think anyone is actually doing that yet anyway.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  programs/cmd_digest.c |  2 +-
>  programs/cmd_enable.c |  2 +-
>  programs/cmd_sign.c   |  2 +-
>  programs/fsverity.c   | 14 --------------
>  programs/fsverity.h   |  1 -
>  5 files changed, 3 insertions(+), 18 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-tRYPzABxf52xm4QiHqNp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+znDgACgkQSylmgFB4
UWIf1Qf9GDfsgxMb8DbIHecyqTC3aLUDBeiUu2KeeUYO048Vlmfr1Bq+4Spzdqqt
onmIEHJNRYS9lFxMjIHajPm1ZK5japt+n2R8R6zcjMOHdzCBHcEtBNi4wPzQPZZ9
AdfFkcZXCvK4WZh8sBhVPhlD3vYfc8lndhGP6ZGffwk+nRpEDXEdASDcag/2PLDR
b8ovd03BGhlok+7FfW0z1uQQzF+Tz38ZVqSqB+WmO+W0YZc4V9Ev475DsJeEmfOu
L/yw3hYbbQNDZDZoXtlGrZ0In4QF9wtJ/kvSt/RWpkGwmeHLTAcWPY/qX3R1lz+G
+g+0BVQMOiPXj78PDJ2gldpu79bvpA==
=LwtD
-----END PGP SIGNATURE-----

--=-tRYPzABxf52xm4QiHqNp--
