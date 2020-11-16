Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902252B432C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgKPLxE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:53:04 -0500
Received: from mail-eopbgr30096.outbound.protection.outlook.com ([40.107.3.96]:63905
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726487AbgKPLxD (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:53:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdkUiadaDWm4Ibyxe5trvVCfKdJMLnZ15lJ4oSYcPdeoMGmmVBXyrfz73JukMH/Y4DFfbNrJ9gbolzQL57OG80PNDllVn6ThEnxLP/zf2FkHxu9jhr+cx9O+rY87Y8raLpYFl+0T5lK4rlQpSMe5VWy0mA/R/l/Y/yJUHIbXW7jo5oWBNHFxSQiSK0sOG8nsNVajA8w8j9qVqRznSCatBpYNtpvcwQI2/3dmtmyNrtWMOXaLmvxnL7UGO28Z4+xJdhw4qJ/KcPYVfPJVVN34dZCZcXuehZpGJn/XYr+Raz1kb/30eKanWb6twZ9YilvvR+E9jVWzuSIcOL3Kfdzr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6Kls1m/zs6DQSd/UCFqoow8c7lkxOESYeDGgFQquxY=;
 b=NEadpP9clx3olScHngAhre1CzkH1SbCgPPeh7Fdc2+PJ8FoJOtikbenpyDxphAHRQU8IefRKNOwf889LMe0ceWQ7ue+jk9+TOfHC7TturZlgvEIlrfyp4fK62rCoiXWVULNxyNOS4g2c5IQdLy85gzxrLm9knj5BMHxmpBkLC4TEHJGj1fDxKkF6c4S6FBOpKOl5zyNM9+pf/5fsriKioxv/90h8mBcT5i6Eli5wV39hIZCGoPRycVe+QhPraA507/LxEKgZPhaeHHhrX6glkrUi6CecSuf8wfr7wTD/XX29P9huh8yQjFTEIeJ9c+TaIQSQOHN4iGvM83iaVDT0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6Kls1m/zs6DQSd/UCFqoow8c7lkxOESYeDGgFQquxY=;
 b=ZTsxS4jdODD6Zhr+Mv1Bm7sYvcYbRYke1r6mZENCnAa8KlI9CVsKaBdzyg1QDgzdO43gUXXndA0NCbCyba5pFEhw/jE0pU/l1F0A0UvUjz7p6iEBsSHWACbsp9sHdQh3aeN2D14kkkyrFqLsaDzIzNnb6vO5OzVzj1uCAx5T3r4=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM6PR83MB0278.EURPRD83.prod.outlook.com (2603:10a6:209:6a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:52:57 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:52:57 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Topic: [fsverity-utils PATCH 1/2] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Index: AQHWvA8GJSqA4Xjtc0Gcvs1B/qNjbw==
Date:   Mon, 16 Nov 2020 11:52:57 +0000
Message-ID: <cf3b4508c2fa79381b3c0f7fb6406b55f1f50e33.camel@microsoft.com>
References: <20201114001529.185751-1-ebiggers@kernel.org>
         <20201114001529.185751-2-ebiggers@kernel.org>
In-Reply-To: <20201114001529.185751-2-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: 7a92d864-bc19-4df1-9048-08d88a2628f6
x-ms-traffictypediagnostic: AM6PR83MB0278:
x-microsoft-antispam-prvs: <AM6PR83MB0278F83C07BE72D127CC5D47F1E30@AM6PR83MB0278.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vyW892KNjVgImZ+/3Sp6j4SWb9xjtcmFy2ijctwf6XtVGSrpKT2Yj3xE9PK5p1YyOPd+BFRIo7frB3ZQ7WkRkk0DlSJ3T1yB6cBen/d0ttHduj5B0s/pUFXIxo2pemhPC6rQk+lR9B8p8/k5yHS6iZawjApPRUYnJKAAHUdNc0plhYdHJeGE03f1pbWWFaIeXUCN/sIlGkiN29ye+oTB6RremF9okZotsKG67sAS05tAE3lrvJ9HHdWSThJwQ0YcHHjdmp12/PaLN9OTEuSoBkbUHMIThJiexHsk4dqEvQZyqZyM0o8iScmfQn0Pidha1uOGCJ6cSYo6OSo3iVcIlvPTZH5V0Cn95TvpimtSs2i79kNS6DNDvMvbhWggcdtbhNRAkode2p32nf9pxJI/uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(4326008)(71200400001)(66556008)(5660300002)(4001150100001)(66476007)(66446008)(83380400001)(66946007)(66616009)(478600001)(64756008)(6486002)(10290500003)(8676002)(76116006)(2616005)(966005)(186003)(86362001)(110136005)(36756003)(316002)(8936002)(6506007)(82960400001)(99936003)(82950400001)(6512007)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /Yio4fwc6perAJ/hNZjWRsep/ySKbPnHEJSxHMcdSnKxUh0HTGr50kJa5l+8h/+fxZnNhzey88d8pmrgemohw87G2PpPW+/JYLS4rsfWtVscn818NmrXYTBIUfy+13fh3feFK5Y48r6z8+Bp3VHXusVg6Zg/+vXom92KpnOlZkSOYOyyKvh3HB12PtrHl6+v54mER6Ms9rHDMqS/iY0hx+WH/sdAPmkLA1m3xYV+ipZsS21FItFC0v92Xdg56JHP/IZFRAnQgvOcfqzqIJHvk1XnpREBqO1IbkqmTAj4ytFyFDT3ts757tmpt5SvWIWsvspVCeUkfvZLAwOzQ6G4R1rTdJ+jcU/0EpkIMXrvN/1NCxnCFy+/IGrjFKHxGbUP22xUGKpugDIqsxGCBlY4djArq4NCZNXEE8fQ93yqsMGP4sQQhiGdkAww8mn97c7RKIlqJG5pEdGneYjEyAAlZdEuYR4AKm2CztBsVb5HI7XPip92J5ajJIeg8+1NNaOob0WjufRG37dRgsKydretO8Pm1m67mJS7/j+0TTwgxbOOqnBpBe3u9WSzFxiDJWIuf0kVonigmC62/s+Yzkd5t65WhhL5XOAZqtUcdiD/CUspPmwI8yKX0b2RWSYqZAzKKAM2JzZKGlk5ulXwoyAx7VFiDXbsEntHCWmLLUY3Jac9UHTOMbwj2ruRWiHvyjWDSkqlmS0dA2k9EkO1U8B549Ojp03qpvfRyXw7aNPU/gsCQEMjJMkP398xIlx/0TdFdEf3fROsrgMje2CJrQVHCYBmYgvom1/0ZIHeyizIH488s03/NwYhXCQX+lw8tP+mp5MRsrlJroXpIXhS0XXyBqxjpehcJne8Mrhrky2Pw6cXU5ca8JY++DewOoEIB1mHz7DSA2gqM5NqCIZisMj6PA==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-ES5TjrvhCNt4pn//MUDS"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a92d864-bc19-4df1-9048-08d88a2628f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:52:57.1584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZSjj3E7z0IltnaUNff3mW5I/YTa4+TiSMALmkve//Kyl3iQ5A/NYuGN5Abv/7AUPSHDIXAEKMbWD0oaJOB9oHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR83MB0278
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-ES5TjrvhCNt4pn//MUDS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
> 'struct libfsverity_merkle_tree_params' instead of
> 'struct fsverity_enable_arg'.  This is useful because it allows
> libfsverity users to deal with one common struct.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/libfsverity.h | 36 ++++++++++++++++++++++++++++++++++
>  lib/enable.c          | 45 +++++++++++++++++++++++++++++++++++++++++++
>  programs/cmd_enable.c | 28 +++++++++++++++------------
>  3 files changed, 97 insertions(+), 12 deletions(-)
>  create mode 100644 lib/enable.c
>=20
> diff --git a/include/libfsverity.h b/include/libfsverity.h
> index 8f78a13..a8aecaf 100644
> --- a/include/libfsverity.h
> +++ b/include/libfsverity.h
> @@ -112,6 +112,42 @@ libfsverity_sign_digest(const struct libfsverity_dig=
est *digest,
>  			const struct libfsverity_signature_params *sig_params,
>  			uint8_t **sig_ret, size_t *sig_size_ret);
> =20
> +/**
> + * libfsverity_enable() - Enable fs-verity on a file
> + * @fd: read-only file descriptor to the file
> + * @params: pointer to the Merkle tree parameters
> + *
> + * This is a simple wrapper around the FS_IOC_ENABLE_VERITY ioctl.
> + *
> + * Return: 0 on success, -EINVAL for invalid arguments, or a negative er=
rno
> + *	   value from the FS_IOC_ENABLE_VERITY ioctl.  See
> + *	   Documentation/filesystems/fsverity.rst in the kernel source tree f=
or
> + *	   the possible error codes from FS_IOC_ENABLE_VERITY.
> + */
> +int
> +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *=
params);
> +
> +/**
> + * libfsverity_enable_with_sig() - Enable fs-verity on a file, with a si=
gnature
> + * @fd: read-only file descriptor to the file
> + * @params: pointer to the Merkle tree parameters
> + * @sig: pointer to the file's signature
> + * @sig_size: size of the file's signature in bytes
> + *
> + * Like libfsverity_enable(), but allows specifying a built-in signature=
 (i.e. a
> + * singature created with libfsverity_sign_digest()) to associate with t=
he file.
> + * This is only needed if the in-kernel signature verification support i=
s being
> + * used; it is not needed if signatures are being verified in userspace.
> + *
> + * If @sig is NULL and @sig_size is 0, this is the same as libfsverity_e=
nable().
> + *
> + * Return: See libfsverity_enable().
> + */
> +int
> +libfsverity_enable_with_sig(int fd,
> +			    const struct libfsverity_merkle_tree_params *params,
> +			    const uint8_t *sig, size_t sig_size);
> +

I don't have a strong preference either way, but any specific reason
for a separate function rather than treating sig =3D=3D NULL and sig_size
=3D=3D 0 as a signature-less enable? For clients deploying files, it would
appear easier to me to just use empty parameters to choose between
signed/not signed, without having to also change which API to call. But
maybe there's some use case I'm missing where it's better to be
explicit.

>  /**
>   * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
>   * @name: Pointer to name of hash algorithm
> diff --git a/lib/enable.c b/lib/enable.c
> new file mode 100644
> index 0000000..dd77292
> --- /dev/null
> +++ b/lib/enable.c
> @@ -0,0 +1,45 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Implementation of libfsverity_enable() and libfsverity_enable_with_si=
g().
> + *
> + * Copyright 2020 Google LLC
> + *
> + * Use of this source code is governed by an MIT-style
> + * license that can be found in the LICENSE file or at
> + * https://opensource.org/licenses/MIT.
> + */
> +
> +#include "lib_private.h"
> +
> +#include <sys/ioctl.h>
> +
> +LIBEXPORT int
> +libfsverity_enable(int fd, const struct libfsverity_merkle_tree_params *=
params)
> +{
> +	return libfsverity_enable_with_sig(fd, params, NULL, 0);
> +}
> +
> +LIBEXPORT int
> +libfsverity_enable_with_sig(int fd,
> +			    const struct libfsverity_merkle_tree_params *params,
> +			    const uint8_t *sig, size_t sig_size)
> +{
> +	struct fsverity_enable_arg arg =3D {};
> +
> +	if (!params) {
> +		libfsverity_error_msg("missing required parameters for enable");
> +		return -EINVAL;
> +	}
> +
> +	arg.version =3D 1;
> +	arg.hash_algorithm =3D params->hash_algorithm;
> +	arg.block_size =3D params->block_size;
> +	arg.salt_size =3D params->salt_size;
> +	arg.salt_ptr =3D (uintptr_t)params->salt;
> +	arg.sig_size =3D sig_size;
> +	arg.sig_ptr =3D (uintptr_t)sig;
> +
> +	if (ioctl(fd, FS_IOC_ENABLE_VERITY, &arg) !=3D 0)
> +		return -errno;
> +	return 0;
> +}

I'm ok with leaving file handling to clients - after all, depending on
infrastructure/bindings/helper libs/whatnot, file handling might vary
wildly.

But could we at least provide a default for block size and hash algo,
if none are specified?

While file handling is a generic concept and expected to be a solved
problem for most programs, figuring out what the default block size
should be or what hash algorithm to use is, are fs-verity specific
concepts that most clients (at least those that I deal with) wouldn't
care about in any way outside of this use, and would want it to "just
work".

Apart from these 2 comments, I ran a quick test of the 2 new series,
and everything works as expected. Thanks!

--=20
Kind regards,
Luca Boccassi

--=-ES5TjrvhCNt4pn//MUDS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yaBcACgkQSylmgFB4
UWLoNQf+LmdeJS19j1mYZqWVe4uSTsAnYwxtI3B3ooZ7Jf8+Qe4eVKmXIH1fmaki
2YmbHDkvtYiN0/ynaXnQvHNqBUAzhaeapRWPOkFeftIMGsFsgFTaS0Pwllcfcyz8
uU/P1lIZ5S4q1ug+mxJQyhWwYS3OVZMnQdEbdGw3zylXz04TAYx8s+/rA4nSpChu
PeCLM2UqslHsUCLmFzOdL9VAQAJfWyO0aao/9UAwhK/78834EG+EGgQz/hFoA0Zg
KSdkmBIv0FyoVr5MN0FQcWHkuG4RB2RtTKxSI52Jri8VCo4VB6OUYWtq/u1BGxP7
hTPOxwFpt6MeAtDGH/zlz0OiKf2miQ==
=zRdj
-----END PGP SIGNATURE-----

--=-ES5TjrvhCNt4pn//MUDS--
