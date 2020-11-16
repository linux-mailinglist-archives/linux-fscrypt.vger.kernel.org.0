Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4562B4E82
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 18:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730751AbgKPRuu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 12:50:50 -0500
Received: from mail-db8eur05on2112.outbound.protection.outlook.com ([40.107.20.112]:60513
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730167AbgKPRuu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 12:50:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzGCz7ZjB3ur/GAtMEwoj0ai8uK/arEb7mnF63yjbt8HKFGsugj/AZN7VrjZugjb0yxXz5rAgDLSTFs5gSxv0twxVPY6SdTdVi29669sY9SSSJ7zHmQw0kP1or0x67LwydQejftyYbSquno1pqnOZgUEHUEO63q6xVove9xAYEz922LZ1Lxj2vdmbgZSK9J4ep/6ZlzoFbS7AZzr2cV0D5gH8nl3E3ol5xAkvB7CUlIfvypJvKE/DTCOC9GtR1mD36ikPSsd+Ip0ZgPEnJHqhTGgOKil9vVKsdNqp7p102Qh3zW74ohpTc+lQot0phla73hbV8fuQcuXaRbzx6QdqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnBRcbFSgKRnezhfa8PCvg2sP9ffbP4/ZyNMobk+PV8=;
 b=LB+7MnlzbjUQhdg4xfetIuMi4CctsGW1o5gLVbA6wgXkaAtzULD5Rgf8OnnK9kXDDTq9XY3FDbBQIQaRNajbt/zyytX8RilPLj+MQTLcVUBxWccGylhYNf0Sh87A259H/jxkip2awY5SsgSI88Bs3EAoebtAWSXLbuA2sllTf+jm0+qFQwnhC5Lq5RMYhSqo9tRzfd+cxMZd/znhqaZGTXnMtREYd65r1cQ4gIbqeJtbHUvx2tl47Mk0hXCqj3NWBtGm3ETA/bjH3Ci7EQ+FQvfAnnQv4ThnYOzMW0sdlj/TjFJ6phFDqNEg12evjrB6Tble7wceek/n9VX/uVYdeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EnBRcbFSgKRnezhfa8PCvg2sP9ffbP4/ZyNMobk+PV8=;
 b=C8BOMozOR5sga4rPor8loWNNATqDResBi1VSxwukNiE/+NNanx+YoAAlH412qlwclfVFk4HUd0zpbwV5hSExjwyb4oPDf63fksd3a113ZkMCoJRAZDJdCsArtPpWP6ChkduUzv6BbD1LVFMAHpSedSrzVBukfEcYodbwzNl1CuU=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR83MB0337.EURPRD83.prod.outlook.com (2603:10a6:206:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 17:50:45 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 17:50:45 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Topic: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Index: AQHWvA8GJSqA4Xjtc0Gcvs1B/qNjb6nLB1UAgAACjoA=
Date:   Mon, 16 Nov 2020 17:50:45 +0000
Message-ID: <58b4959a8e836a6a3127ac48370ee8bd15f137c8.camel@microsoft.com>
References: <20201114001529.185751-1-ebiggers@kernel.org>
         <20201114001529.185751-2-ebiggers@kernel.org>
         <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
         <X7K5zkDbDRobY6ux@sol.localdomain>
In-Reply-To: <X7K5zkDbDRobY6ux@sol.localdomain>
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
x-ms-office365-filtering-correlation-id: 57b66993-c21b-42bc-dd90-08d88a5824f9
x-ms-traffictypediagnostic: AM5PR83MB0337:
x-microsoft-antispam-prvs: <AM5PR83MB03377D0D4F2E72987B102161F1E30@AM5PR83MB0337.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jLxorzslg5kJHVraBaPuo0oz1qd82NFzt04jbK751KCdRk0n/RWlC1uuPbHnRJk1jAXp9cCcq/UzszcG57aGPuImuJtbdUeSajzWjlsLIiw3lGaty8JqDse/OCh/pTiJfuKqoyk/+va4u80InWvhTkJkH20sr3YMPAW7Gew3hMNnHsgCBeO4qrmDyi1ASWq7X+v/nSTOnkL0DNN2WX6aChb+E+BAh64jPElyuyC7LQj9Q2lsODDrC+i8tFCB4OamlM7+ov/qrWALnCu/3Q+jAefw9pC6n5VHztMJMdEkYkgtdgFFZ8yq1odRWVeVDnw2LiDGxcSLlP2+PMQi9rvQrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39850400004)(366004)(376002)(346002)(86362001)(82960400001)(82950400001)(36756003)(99936003)(2616005)(5660300002)(6486002)(6506007)(6512007)(54906003)(2906002)(83380400001)(4001150100001)(10290500003)(71200400001)(316002)(66476007)(66556008)(66446008)(66946007)(64756008)(478600001)(66616009)(76116006)(6916009)(186003)(26005)(8936002)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rFTzC2tVsFEYkt/u/cKZCMJCiiSR+96cUit2EH0bpazZ1G1eP9+LR8X2Bg1HSXdV6Cqdi9EVrMMSi5+QIVAaiXzm1Ro2ZA87gXx8HyThTZTt0qpTfVN5pgYLt9LumvR40ItGkJvROg7Qvb6UWrcKV5D5SUBjs/Aq2d+WE8viwCSzUgzbgMjjtCs1lKfTrUkgyA2KgPR9JGFP3PWeEval3C2+JqVsLPr1TywSZ7PARkMMtg0Ere+kpZ1UTxN8z+MuZHP7byvxorQibQhgkX+kZv+4qnfn3w6Re7yW5zWTKLZYy2MQwQAZK9KIawSmXaiq7JL2Hn66ltzP1IXoM9VGqZZJ8aP2BjtH93aBQapqNbScDEa9VV3dMDw0EDNBhcJsgkfmBHoWv5Ppo6Ms4zig8yEJyuUCDNh0KFsoFjO6Kxtz9NaiEub1tsyJPeRRP/exSF1MMI7Qo6osLkAhScyUr7BaRrBXUJcaQvObdpjDG/vLKIDxeRc5/xe5HPRlBvKEp505KHaiwQeuJAEJekZbq7f3Hrubf8jjsru/WV+xPP09JGRugLEs3d2RnzVDn8WvDq1JuFsQRF0bLRkyfxWDCTTcaFB+ZKwvMuE/AOMres8NgtZlOQtk805xCWgcMN/S5f9qHKUfqgpIBhZivLV/bwrc15PH5p2VmxGYFcOY5A2tLSSzGXYxKFTlEQ02dBGvDb6QFpAe+Y2PpgotiYIwbp69KxqGUY2fps6W0Nenyod6mwc7c7jYhDOHgOp3sF9C5odF495u6Yi3tKsyly1CsRYOkpBrFtTsj3cQiF2vWyMoJzF4uNnjEgkLv3Pygvhb/AV4+YrEEZ2fa7iAtNdLDzJN0sSfvTW3EZuUAJW6fNu7YAVJtFVG1xMWmrXOr8yL+MO581CvJm0Tgw0N43QMbA==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-W0roLYps4EF5IojpmLxw"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b66993-c21b-42bc-dd90-08d88a5824f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 17:50:45.3126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xGqNSz4YR1TO7op47bEZlA7hidhClLr2UaTixYoAWqJmUUCTKvAWAX/fNVW4Uyjoc51MihSFe4kEK1JVYystyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR83MB0337
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-W0roLYps4EF5IojpmLxw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 09:41 -0800, Eric Biggers wrote:
> On Mon, Nov 16, 2020 at 11:52:57AM +0000, Luca Boccassi wrote:
> > On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >=20
> > > Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
> > > 'struct libfsverity_merkle_tree_params' instead of
> > > 'struct fsverity_enable_arg'.  This is useful because it allows
> > > libfsverity users to deal with one common struct.
> > >=20
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  include/libfsverity.h | 36 ++++++++++++++++++++++++++++++++++
> > >  lib/enable.c          | 45 +++++++++++++++++++++++++++++++++++++++++=
++
> > >  programs/cmd_enable.c | 28 +++++++++++++++------------
> > >  3 files changed, 97 insertions(+), 12 deletions(-)
> > >  create mode 100644 lib/enable.c
> > >=20
> > > diff --git a/include/libfsverity.h b/include/libfsverity.h
> > > index 8f78a13..a8aecaf 100644
> > > --- a/include/libfsverity.h
> > > +++ b/include/libfsverity.h
> > > @@ -112,6 +112,42 @@ libfsverity_sign_digest(const struct libfsverity=
_digest *digest,
> > >  			const struct libfsverity_signature_params *sig_params,
> > >  			uint8_t **sig_ret, size_t *sig_size_ret);
> > > =20
> > > +/**
> > > + * libfsverity_enable() - Enable fs-verity on a file
> > > + * @fd: read-only file descriptor to the file
> > > + * @params: pointer to the Merkle tree parameters
> > > + *
> > > + * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioctl.
> > > + *
> > > + * Return: 0 on success, -EINVAL for invalid arguments, or a negativ=
e errno
> > > + *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
> > > + *	   Documentation/filesystems/fsverity.rst in the kernel source tr=
ee for
> > > + *	   the possible error codes from FS_IOC_ENABLE_VERITY.
> > > + */
> > > +int
> > > +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_para=
ms *params);
> > > +
> > > +/**
> > > + * libfsverity_enable_with_sig() - Enable fs-verity on a file, with =
a signature
> > > + * @fd: read-only file descriptor to the file
> > > + * @params: pointer to the Merkle tree parameters
> > > + * @sig: pointer to the file's signature
> > > + * @sig_size: size of the file's signature in bytes
> > > + *
> > > + * Like libfsverity_enable(), but allows specifying a built-in signa=
ture (i.e. a
> > > + * singature created with libfsverity_sign_digest()) to associate wi=
th the file.
> > > + * This is only needed if the in-kernel signature verification suppo=
rt is being
> > > + * used; it is not needed if signatures are being verified in usersp=
ace.
> > > + *
> > > + * If @sig is NULL and @sig_size is 0, this is the same as libfsveri=
ty_enable().
> > > + *
> > > + * Return: See libfsverity_enable().
> > > + */
> > > +int
> > > +libfsverity_enable_with_sig(int fd,
> > > +			    const struct libfsverity_merkle_tree_params *params,
> > > +			    const uint8_t *sig, size_t sig_size);
> > > +
> >=20
> > I don't have a strong preference either way, but any specific reason
> > for a separate function rather than treating sig =3D=3D NULL and sig_si=
ze
> > =3D=3D 0 as a signature-less enable? For clients deploying files, it wo=
uld
> > appear easier to me to just use empty parameters to choose between
> > signed/not signed, without having to also change which API to call. But
> > maybe there's some use case I'm missing where it's better to be
> > explicit.
>=20
> libfsverity_enable_with_sig() works since that; it allows sig =3D=3D NULL=
 and
> sig_size =3D=3D 0.
>=20
> The reason I don't want the regular libfsverity_enable() to take the sign=
ature
> parameters is that I'd like to encourage people to do userspace signature
> verification instead.  I want to avoid implying that the in-kernel signat=
ure
> verification is something that everyone should use.  Same reason I didn't=
 want
> 'fsverity digest' to output fsverity_formatted_digest by default.

Ok, I understand - makes sense to me, thanks.

Maybe it's worth documenting in the the header description of the API
that empty/null values are accepted and will result in enabling without
signature check?

> > > +LIBEXPORT int
> > > +libfsverity_enable_with_sig(int fd,
> > > +			    const struct libfsverity_merkle_tree_params *params,
> > > +			    const uint8_t *sig, size_t sig_size)
> > > +{
> > > +	struct fsverity_enable_arg arg =3D {};
> > > +
> > > +	if (!params) {
> > > +		libfsverity_error_msg("missing required parameters for enable");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	arg.version =3D 1;
> > > +	arg.hash_algorithm =3D params->hash_algorithm;
> > > +	arg.block_size =3D params->block_size;
> > > +	arg.salt_size =3D params->salt_size;
> > > +	arg.salt_ptr =3D (uintptr_t)params->salt;
> > > +	arg.sig_size =3D sig_size;
> > > +	arg.sig_ptr =3D (uintptr_t)sig;
> > > +
> > > +	if (ioctl(fd, FS_IOC_ENABLE_VERITY, &arg) !=3D 0)
> > > +		return -errno;
> > > +	return 0;
> > > +}
> >=20
> > I'm ok with leaving file handling to clients - after all, depending on
> > infrastructure/bindings/helper libs/whatnot, file handling might vary
> > wildly.
> >=20
> > But could we at least provide a default for block size and hash algo,
> > if none are specified?
> >=20
> > While file handling is a generic concept and expected to be a solved
> > problem for most programs, figuring out what the default block size
> > should be or what hash algorithm to use is, are fs-verity specific
> > concepts that most clients (at least those that I deal with) wouldn't
> > care about in any way outside of this use, and would want it to "just
> > work".
> >=20
> > Apart from these 2 comments, I ran a quick test of the 2 new series,
> > and everything works as expected. Thanks!
>=20
> First, providing defaults in libfsverity_enable() doesn't make sense unle=
ss the
> same defaults are provided in libfsverity_compute_digest() too.
>=20
> Second, PAGE_SIZE is a bad default block size.  It really should be a fix=
ed
> value, like 4096, so that e.g. if you sign files on both x86 and PowerPC,=
 or
> sign on x86 and enable on PowerPC, you get the same results.
>=20
> So at least we shouldn't provide defaults unless it's done right.
>=20
> I suppose it's probably not too late to change the default for the fsveri=
ty
> program, though.  I doubt anyone is using it with a non-4K PAGE_SIZE yet.
>=20
> Would it work for you if both libfsverity_compute_digest() and
> libfsverity_enable() defaulted to SHA-256 and 4096?
>=20
> - Eric

Yes, using those defaults in the functions would work perfectly fine
for me, thank you!

--=20
Kind regards,
Luca Boccassi

--=-W0roLYps4EF5IojpmLxw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yu/MACgkQSylmgFB4
UWKqwgf9Gx40T04Q0mYAD5smI0N2g2kIDBMTXEDbRfiwgNUTxyad7Lvdj3q2JSAI
fdM2Q+1SAGqQOLoL27CzxK6M9E3whViaRDP773tGtU6PX+TIY8HdjzRV5OMpX64o
QDUiHay9+ZUifH+VMc/oV6NN/mADL/ERfiHTGqMkFkaqgOHGOYhsZ7eW3dudmN0Q
hOAV5otY5nnyshl1xM0/mQCw1w6SmLHxfMVT79K0i9KbEyfxk591fPOf0HYQlky0
Sk22DH/bQpB0q0VxPGMtVGY+21WN8ip/uJ3MogsDevEF25iKq9r2rSkzYWOwDY/Y
LGQau9gzVJCA9dguHXE5AHgoUzcQEQ==
=I3xy
-----END PGP SIGNATURE-----

--=-W0roLYps4EF5IojpmLxw--
