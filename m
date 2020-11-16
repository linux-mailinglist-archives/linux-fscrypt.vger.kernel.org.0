Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4DD82B5120
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 20:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727460AbgKPT2H (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 14:28:07 -0500
Received: from mail-vi1eur05on2117.outbound.protection.outlook.com ([40.107.21.117]:51200
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727801AbgKPT2H (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 14:28:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glqVpeXLRB4Ln8sXSCU5FVlluJwaVezHzqRHzDQ3dBGKLobwLnSDr5q0ye/z001PzKfv+EyMZw+AMZiI0WBdqOTUsSybSuUz/ClMK6OzKl0J338ISkKQ3FgKwq/LJgZ9hQ3lFEli0DprZPr4HsXEumyxoWXcChdCb8W+2En9vt710hw4EN/CSthvH6ljFCOj7pABV/HPtgh4T8Tub4yeS9ORjeARDmy0p1AbXuGAX5sPg1MPSHrbkdaJvW5KGD80X9UL0QiipVC8hrb7Wv7ICtLeS7ehmCz9MCzeLFdR/cBPqTvGcX18JQRW3Aggd/9n3igODdLCmCEyDoDkl/T9bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwmjrja0+Vp/UKg4t3HAJ9kyJLkWBhN/VPOCbt4VGks=;
 b=ZIstRzKEeASh5Vqb+NHQLq8e1DminmMpoGyN+T3Eu80/CvgzLBjSqb9VxS4fYZ6632/YR5y18eO3M0aLJt08PnQ0M0lU3Bz/YSNhTUoZ7SNuGUt7i8F1TB3nWJWlhFMj7ZXfB+CumgTsKhriphHQrSMDYqKdRsgvQDYFK76I7OIB32mQjlA0L8EICvctcPEBaSD7tCBA7RhRi20l2wBZb6VBcwLTmUgVwQsIcEmN983F8/ZitxBL9dplAoDLovgxSi+gPPNoM0XHX00AxQtQ/FCCgG1kwsBgiVJcz8EBYoC35eBj9Tg5pmosc4UVZaOxx8lBmKtCglIWa9l9gmFDKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwmjrja0+Vp/UKg4t3HAJ9kyJLkWBhN/VPOCbt4VGks=;
 b=RFLsnOJGcKxMQxpLkZbE553vEysCS6LvyW0TQz9ryyGJOXETG2PMqVy0LVYAj7a8Vdjmn3z9T5RmZcBimRMHJNu63ackGtq30dKxrnJgg9Hfl9j1lXCcwPjYl49tU2+zQhQp5p9LeOTl8VVLhjSiJ88Zyotffk++D+aijxj/sQk=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR83MB0321.EURPRD83.prod.outlook.com (2603:10a6:206:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 19:28:03 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 19:28:03 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Topic: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Index: AQHWvA8GJSqA4Xjtc0Gcvs1B/qNjb6nLB1UAgAACjoCAAA5dgIAADNOA
Date:   Mon, 16 Nov 2020 19:28:03 +0000
Message-ID: <8f78926bb24a7b987cc586973592a2c49dccf645.camel@microsoft.com>
References: <20201114001529.185751-1-ebiggers@kernel.org>
         <20201114001529.185751-2-ebiggers@kernel.org>
         <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
         <X7K5zkDbDRobY6ux@sol.localdomain>
         <58b4959a8e836a6a3127ac48370ee8bd15f137c8.camel@microsoft.com>
         <20201116184207.GA1750990@gmail.com>
In-Reply-To: <20201116184207.GA1750990@gmail.com>
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
x-ms-office365-filtering-correlation-id: dc891dfa-ff37-4921-2b6b-08d88a65bc87
x-ms-traffictypediagnostic: AM5PR83MB0321:
x-microsoft-antispam-prvs: <AM5PR83MB03212BB55D01CFB0D6317885F1E30@AM5PR83MB0321.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7o8oG/W9uN8UABNP/iKd1B/wnCG92z5XYnZW0DarNR173BeqAYZqVNXfKepk8DcL4VORjfKKcQ5DhV+c44hJaMtNlFTfb2FgAR5JZjVyktqP+TD+iN1pztQJJZvxRWqZC/7be4lrCg75iksetw8h1npzJTe3lNcn+ZTwDFpMNV2vIjEj/Mv2+BQ9zOFySTBXfBOl20hzLK7fNVnmgw4NwqFqwFVjP+oIQV+zXnnfUJiScU7Lhrix6zqtb4mKm4ymhuNbzi+8DLBMMj17TwtnHPQK2OioErjpKh1/jP2IQWf9EihaowZd58Gwy1h4lpvEy2I0SMNfiDF0Wa0qgHPhEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(26005)(4326008)(6506007)(82950400001)(186003)(36756003)(76116006)(6512007)(316002)(99936003)(82960400001)(6486002)(64756008)(66556008)(66616009)(66446008)(66476007)(66946007)(54906003)(71200400001)(6916009)(10290500003)(86362001)(2616005)(83380400001)(8936002)(8676002)(2906002)(478600001)(4001150100001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iOQUosHGFK/ud4DSVDMtyuO+V+4hwbJf6qbGaftkBvZVRMs/yPTor6xjpRoyAKtXxY3B3g6wUlSOWPUoDsp4Ik/nRC9kbeVoGPg2UDGRuvXHLGXTSD52lChJ10Lxw6ggY52nJXakkKFaAQDOLnx4Qaxc2mIYxOn8jJOr+QgtPCDMozEVY4Id7W6MNw1B6NT29iqXZxRv3DmAg/8QtFzRB1Dqh+5eRmyPB1AtnxtBg72vT9CpcQfe1y7IvpruOW9BaXdEV5M1RMUCpuB4Bjd8X1NnGPAZf0mogvPJqvCenmV7Q793cGqsnwiOeFRPO44WrEeqLcs0MQNW61L7GdxC118TXdASuY8+LsHqiivHgyw9eDax/ByPQI2ye3Yn3hTQtpcOBmjECejQKuSu7TqIHgetWA/XDLmN4KUEjmai8216maG0gDpa39uQWGZ8uwHlVG15Lv7q7nRS4WE0WkADZhWGFOIJTodGjaoSym60JyRMjuCIdJIApRLK1o6Bzwuor8qTj5l9X0uRpCLzKmlFHLIS4iNnQvt/fIUpYW0hQTMkTNcIqQbBqi7YZ+P1iRW5YCcDETZKPq6r1sgn0089EHh3QpZrK5JhI+pg7rN0r6dlxvndWXxRH5ufH/bWKU+unRJANit1o0R048iFWzJSjcKzYChz+W+7/CQsZTFtPcX5il9Lue7TR2j/ZY7OOQsz+KQIrO6FR5EfhtdzShDGz+1+WA14W3pu2iBajDPb+CbpsnaK2ToQ27vLyAxkQga1NbWTluh7oPa9T9cU9WqRQk80VreQVhuFPLSvLm+ierguZpnkn+PC0iF6HpenYB2c1ecSDECoNeFZunb20J3qvo2co5gV7Q2VrFeX68cK2rXUWI9C5AbzOpfE2CmRsMNbE041OlESIR9w9S5M2o7dxA==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ai/M7yEKC+jOPsQ/hjHb"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc891dfa-ff37-4921-2b6b-08d88a65bc87
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 19:28:03.0661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gy7GA/xgDwtJgd/hdX8LDRe2SxVOIPJrX+rGRkHyPB7GQe7a3mSckkIdOP3PcLV3D8+voA55v2E4Hk9+Z8kR3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR83MB0321
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-ai/M7yEKC+jOPsQ/hjHb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 10:42 -0800, Eric Biggers wrote:
> On Mon, Nov 16, 2020 at 05:50:45PM +0000, Luca Boccassi wrote:
> > On Mon, 2020-11-16 at 09:41 -0800, Eric Biggers wrote:
> > > On Mon, Nov 16, 2020 at 11:52:57AM +0000, Luca Boccassi wrote:
> > > > On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > >=20
> > > > > Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take=
 a
> > > > > 'struct libfsverity_merkle_tree_params' instead of
> > > > > 'struct fsverity_enable_arg'.  This is useful because it allows
> > > > > libfsverity users to deal with one common struct.
> > > > >=20
> > > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > > ---
> > > > >  include/libfsverity.h | 36 ++++++++++++++++++++++++++++++++++
> > > > >  lib/enable.c          | 45 +++++++++++++++++++++++++++++++++++++=
++++++
> > > > >  programs/cmd_enable.c | 28 +++++++++++++++------------
> > > > >  3 files changed, 97 insertions(+), 12 deletions(-)
> > > > >  create mode 100644 lib/enable.c
> > > > >=20
> > > > > diff --git a/include/libfsverity.h b/include/libfsverity.h
> > > > > index 8f78a13..a8aecaf 100644
> > > > > --- a/include/libfsverity.h
> > > > > +++ b/include/libfsverity.h
> > > > > @@ -112,6 +112,42 @@ libfsverity_sign_digest(const struct libfsve=
rity_digest *digest,
> > > > >  			const struct libfsverity_signature_params *sig_params,
> > > > >  			uint8_t **sig_ret, size_t *sig_size_ret);
> > > > > =20
> > > > > +/**
> > > > > + * libfsverity_enable() - Enable fs-verity on a file
> > > > > + * @fd: read-only file descriptor to the file
> > > > > + * @params: pointer to the Merkle tree parameters
> > > > > + *
> > > > > + * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioct=
l.
> > > > > + *
> > > > > + * Return: 0 on success, -EINVAL for invalid arguments, or a neg=
ative errno
> > > > > + *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
> > > > > + *	   Documentation/filesystems/fsverity.rst in the kernel sourc=
e tree for
> > > > > + *	   the possible error codes from FS_IOC_ENABLE_VERITY.
> > > > > + */
> > > > > +int
> > > > > +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_=
params *params);
> > > > > +
> > > > > +/**
> > > > > + * libfsverity_enable_with_sig() - Enable fs-verity on a file, w=
ith a signature
> > > > > + * @fd: read-only file descriptor to the file
> > > > > + * @params: pointer to the Merkle tree parameters
> > > > > + * @sig: pointer to the file's signature
> > > > > + * @sig_size: size of the file's signature in bytes
> > > > > + *
> > > > > + * Like libfsverity_enable(), but allows specifying a built-in s=
ignature (i.e. a
> > > > > + * singature created with libfsverity_sign_digest()) to associat=
e with the file.
> > > > > + * This is only needed if the in-kernel signature verification s=
upport is being
> > > > > + * used; it is not needed if signatures are being verified in us=
erspace.
> > > > > + *
> > > > > + * If @sig is NULL and @sig_size is 0, this is the same as libfs=
verity_enable().
> > > > > + *
> > > > > + * Return: See libfsverity_enable().
> > > > > + */
> > > > > +int
> > > > > +libfsverity_enable_with_sig(int fd,
> > > > > +			    const struct libfsverity_merkle_tree_params *params,
> > > > > +			    const uint8_t *sig, size_t sig_size);
> > > > > +
> > > >=20
> > > > I don't have a strong preference either way, but any specific reaso=
n
> > > > for a separate function rather than treating sig =3D=3D NULL and si=
g_size
> > > > =3D=3D 0 as a signature-less enable? For clients deploying files, i=
t would
> > > > appear easier to me to just use empty parameters to choose between
> > > > signed/not signed, without having to also change which API to call.=
 But
> > > > maybe there's some use case I'm missing where it's better to be
> > > > explicit.
> > >=20
> > > libfsverity_enable_with_sig() works since that; it allows sig =3D=3D =
NULL and
> > > sig_size =3D=3D 0.
> > >=20
> > > The reason I don't want the regular libfsverity_enable() to take the =
signature
> > > parameters is that I'd like to encourage people to do userspace signa=
ture
> > > verification instead.  I want to avoid implying that the in-kernel si=
gnature
> > > verification is something that everyone should use.  Same reason I di=
dn't want
> > > 'fsverity digest' to output fsverity_formatted_digest by default.
> >=20
> > Ok, I understand - makes sense to me, thanks.
> >=20
> > Maybe it's worth documenting in the the header description of the API
> > that empty/null values are accepted and will result in enabling without
> > signature check?
> >=20
>=20
> It's already there:
>=20
>  * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_en=
able().

Ah of course, sorry, right under my nose and still missed it :-)

--=20
Kind regards,
Luca Boccassi

--=-ai/M7yEKC+jOPsQ/hjHb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+y0sEACgkQSylmgFB4
UWJRXwgAtI+FXO/qY3bbdYsE9Ns3YM75SndNj7r1nwH1Q0e9QS18vWo1Xc3sIHms
PTVMT3SADCcvpv8I3zjg/kEc3MflZuVtuaiggn/+enzbpcppc/CAjMH3TWvjSthQ
pH7u+aF6GJvTphGuQYFalphA9tsXRN5jTBN+/6LRwyTqvlw+fE8mjO0SeRdR7/zP
/W3+b9EDc8nMMqOKA76dUSGSwoySuAtXnCejLPHKA6kmzGT57w8S9yxJH8Ab8Pq3
64GjC6383yc5/JjrLM23c7XC13EcXEjcij22d19i372mjpCEN7okcH1jSVqcKrcV
MzGfBTO+BpbgGlOkjr2DRWpahdf2lQ==
=WCfE
-----END PGP SIGNATURE-----

--=-ai/M7yEKC+jOPsQ/hjHb--
