Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCC92B4330
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgKPLxx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:53:53 -0500
Received: from mail-eopbgr30124.outbound.protection.outlook.com ([40.107.3.124]:4416
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgKPLxw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:53:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpnXaacFkCMKPK+aTFc+HPzce9MmmRb01ADDm6yMN5BJfPl7Vft7yyPfiJE+GzSwpjVjrana3++8p9bBLMWRn6boJ8sFadJ8l2rVHEkC+wBhZ7QODp9sFZsh+HFVpHfwuazmVL1Fbu94YfzFxvYONnSPXWAA4EuGs4lx+dqU6DzHHBB7GNjTAUlXX84garIWwJEUYu+dlPYWPDLk5kqgQekFk7RUKgrMZdbpqrPnUauevzGHeQrEG83dNHSzG9tipLS/7mDz8NN38M7Bntz9yPznBOG9cZfd5LzETEeaq/uHtu/hiq1JLuk3K7jPpYbErnzmONLGFKP9No2ra/OGEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mueEyib8jnBC5joZhL3UQApIbaPobpfGby3haJDTg4o=;
 b=W4Zys5owrWNx4Thv08Bnko7bYCMwcyk/iX6VXzrnQByTMIUEnJENYkvO9PoITuCQp6n/ymOpZWBFKmobL8MngygN5Vm6IoGdcr+qnBae/UFyH9ZvvPbrWqnXsWEvyVtLA/b8epMzbgY4YUV8Oz8Na9CjTGPOC6Fw1kI0x72qOyWGA5uhDjZzuctQ1Ly4WcvJfu/DVY1Ns9zt+LL1ok2669i9v2iqhYBTN4zW0XyO3z+N9AVxBnMNNXhBZGHr2iPDfZ+iyewwbfZFuEczcIHslcIrMmZOPaXJ38Rp2PZ7Y853o/Ah16uLclZHkbtRKdgylRLCXK3dxwyDQX05/yC79Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mueEyib8jnBC5joZhL3UQApIbaPobpfGby3haJDTg4o=;
 b=K1YBuyEDx9aPM6FAOId68dNQBFZBBy3DT/9ODp7xNXi6YCj5b6pN4Df7KONovyW1mJJU10Zxjemo/F/tweQjC1+3D+5kctvYmZ4N9JX0ROwX7uvfnka0xeJu7MpQZpMJjYYYjb/Z6Z43QRXf39tdUYzYAFWfppRl0UFTY/qXj8I=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM6PR83MB0278.EURPRD83.prod.outlook.com (2603:10a6:209:6a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:53:47 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:53:47 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils RFC PATCH] Add libfsverity_enable() API
Thread-Topic: [fsverity-utils RFC PATCH] Add libfsverity_enable() API
Thread-Index: AQHWvA8kU+L/GDYvPEi6K2yARA2GDg==
Date:   Mon, 16 Nov 2020 11:53:47 +0000
Message-ID: <6c8adbaada81eede82a73e56439d54b62f13bb80.camel@microsoft.com>
References: <20201113143527.1097499-1-luca.boccassi@gmail.com>
         <X68jCECcvkXs5VWf@sol.localdomain>
In-Reply-To: <X68jCECcvkXs5VWf@sol.localdomain>
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
x-ms-office365-filtering-correlation-id: 438d0caa-25a3-4df3-b95c-08d88a2646d9
x-ms-traffictypediagnostic: AM6PR83MB0278:
x-microsoft-antispam-prvs: <AM6PR83MB0278144E7BE3EA6F51D19447F1E30@AM6PR83MB0278.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YKqlr6d3VMjgu3ZiQ4Vt1ikXK/rCZgU+cH2BxpqpWbmPQvv8XGB0nZm4Uo9TV1lg9NaU/pRvcIaKygva7FKN1Vwe3B3hKhTb413HtQEZ2ftxOd9yczCGhir4+x/Q6B/Fk3mzmUcwy9n0RYuCp+NZqtOdLvqVvJwoSaOe54YV7/P4uio6/yshHEUdzBIli3QoRjl7Keu5RdSHMfk3Q6h0xPQMuN0My/29/7Mz++PHihf6w7/yumZTacM6PjlF9ZYPiToyRsfKinueMOazS1I7gCJiShLwo5JKrZgVQc+6xUBzP3d38hdUycqUEXACuiFrKEp/ZwB+V8s9uS0fUFYmFHqQC2vMS1ag+gR87aZnWz7I53VxYwEqQJDTcGjwT64AzX7dX2U2N9nXOexEhBBTiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(366004)(4326008)(71200400001)(66556008)(5660300002)(4001150100001)(66476007)(66446008)(83380400001)(66946007)(66616009)(478600001)(64756008)(6486002)(10290500003)(8676002)(76116006)(2616005)(966005)(186003)(86362001)(6916009)(36756003)(54906003)(316002)(8936002)(6506007)(82960400001)(99936003)(82950400001)(6512007)(26005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rz6sEM6Sju3tZ5geSYdekTM9UF4gXsN5eauUmFlUPq9KYvaDlJYA1bA10Btxgi26wGcyYOBs6N+QSh6Xfls/AN1bUYBk9QhiK2RAtSOrsA9dz4I3RK7/ohcdTw0Pd3iIVOZk4DxBzgF2G6r6DrxemlRq2uV1wdPCrUNsuLAWawjvtywszpxMEML6+xI8PPhST8/8FdYXLc8sLqaRExeEMaEbknH35A7T4Y5ANC+87gs60xt/KRDDoB6u6pbpUhj0v/CsYJbLpfRYo/t4SWNYM9/WwssZYC+Y5z90ZxbqKNs8mcwfevD0vkTmmgT0bxqvOB0s3Sw5vjHc0lhgep7sjTH5TPVjlpDKsgbsNn1Lpw9TTb8Sm+3W6Jn6mMdL80/R8Hgv+9kn7XXP33SBJ1KdxBt2C40mwQoddxfR/AHrqlFQRZCi7rg5ujLvOne7y+6W7l0/dKUYECTpRZemSyxrEeK7+yyqeJpoulNcZ57vDDDDGZfZyddqzPdoEPuh8sU5fkLjODW8WN6Rs1pPwL+l67r03iYUv9PDeSsQYUaXMpxOFOAonrwx8PtXRY5J9hc33PRHPB5Id4lj7WntqsLxwBhsdIlgfkRo2IP366rjgY/RT3gH3nXmFd7sSa31N13imCzAeV4g4A3c0996Ow7lcp3UMf3IGAsmH3BIIi2axNu4yNJN/f7abe1hllxDROXIY+JlcqwtrmMwkVUiKHq8Hq7qHIIhVuCPG1udsCrmZhry2ijZH29bWRGa1aBTVshPQJeIgZiaOn1dvqit/xzvzRtMBmfYUtCbTmTEU+bLIDRaINqCNpml4PVT0nc/7/Fnt4nORdA+aYm3ZrJaY0lBL3okNlRJqZ8yzWEAyPlklO2h5DvML3I3CbRL1IlKAugs/huFKzJtUU8kLlGTU4/NiA==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-G4AikyLsdmLSTzbu4jWZ"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 438d0caa-25a3-4df3-b95c-08d88a2646d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:53:47.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bo/gUQuzda2e6iWQ7iMfLI7BbhyG0/U06zTElXRpw1GCiT4ypz/SUA9pu+XkoOltL8kJ2uXSjdsNgh4qRoY9qQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR83MB0278
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-G4AikyLsdmLSTzbu4jWZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 16:21 -0800, Eric Biggers wrote:
> On Fri, Nov 13, 2020 at 02:35:27PM +0000, luca.boccassi@gmail.com wrote:
> > From: Luca Boccassi <luca.boccassi@microsoft.com>
> >=20
> > Factor out the 'fsverity enable' implementation in the library, to
> > give users a shortcut for reading signatures and enabling a file
> > with the default parameters.
> >=20
> > Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>
> > ---
> > Marked as RFC to get guidance on how to deal with helper functions
> > duplication, that right now are part of the "programs" utility objects
> > and not usable from the "library" objects.
> > There's dozens of different ways to handle this, all equally valid, so
> > it's down to the preference of the maintainer (eg: new common helpers,
> > include helpers at build time, further splits of sources, etc).
> > Please provide a preference and I'll follow up.
> >=20
> >  common/common_defs.h  |   9 ++
> >  include/libfsverity.h |  21 +++++
> >  lib/enable.c          | 191 ++++++++++++++++++++++++++++++++++++++++++
> >  programs/cmd_enable.c |  66 ++-------------
> >  programs/fsverity.h   |   9 --
> >  5 files changed, 227 insertions(+), 69 deletions(-)
> >  create mode 100644 lib/enable.c
> >=20
> > diff --git a/common/common_defs.h b/common/common_defs.h
> > index 279385a..871db2c 100644
> > --- a/common/common_defs.h
> > +++ b/common/common_defs.h
> > @@ -90,4 +90,13 @@ static inline int ilog2(unsigned long n)
> >  #  define le64_to_cpu(v)	(__builtin_bswap64((__force u64)(v)))
> >  #endif
> > =20
> > +/* The hash algorithm that 'fsverity' assumes when none is specified *=
/
> > +#define FS_VERITY_HASH_ALG_DEFAULT	FS_VERITY_HASH_ALG_SHA256
> > +
> > +/*
> > + * Largest digest size among all hash algorithms supported by fs-verit=
y.
> > + * This can be increased if needed.
> > + */
> > +#define FS_VERITY_MAX_DIGEST_SIZE	64
> > +
> >  #endif /* COMMON_COMMON_DEFS_H */
> > diff --git a/include/libfsverity.h b/include/libfsverity.h
> > index 8f78a13..8d1f93b 100644
> > --- a/include/libfsverity.h
> > +++ b/include/libfsverity.h
> > @@ -112,6 +112,27 @@ libfsverity_sign_digest(const struct libfsverity_d=
igest *digest,
> >  			const struct libfsverity_signature_params *sig_params,
> >  			uint8_t **sig_ret, size_t *sig_size_ret);
> > =20
> > +/**
> > + * libfsverity_enable() - Enable fs-verity on a file
> > + *          An fsverity_digest (also called a "file measurement") is t=
he root of
> > + *          a file's Merkle tree.  Not to be confused with a tradition=
al file
> > + *          digest computed over the entire file.
> > + * @file: path to the file to enable
> > + * @signature: (optional) path to signature for @file
> > + * @params: struct libfsverity_merkle_tree_params specifying the fs-ve=
rity
> > + *	    version, the hash algorithm, the block size, and
> > + *	    optionally a salt.  Reserved fields must be zero.
> > + *      All fields bar the version are optional, and defaults will be =
used
> > + *      if set to zero.
> > + *
> > + * Returns:
> > + * * 0 for success, -EINVAL for invalid input arguments, or a generic =
error
> > + *   if the FS_IOC_ENABLE_VERITY ioctl fails.
> > + */
> > +int
> > +libfsverity_enable(const char *file, const char *signature,
> > +			struct libfsverity_merkle_tree_params *params);
> > +
> >  /**
> >   * libfsverity_find_hash_alg_by_name() - Find hash algorithm by name
> >   * @name: Pointer to name of hash algorithm
>=20
> Hi Luca, can you consider
> https://lkml.kernel.org/linux-fscrypt/20201114001529.185751-1-ebiggers@ke=
rnel.org/T/#u
> instead?
>=20
> It's somewhat useful to have a wrapper around FS_IOC_ENABLE_VERITY that t=
akes
> 'struct libfsverity_merkle_tree_params', so that library users can deal w=
ith one
> common struct.  (And I took advantage of that to simplify the code that p=
arses
> the parameters.)
>=20
> But I think we should keep it as a thin wrapper, and not have file path
> parameters or set defaults in the libfsverity_merkle_tree_params.  The li=
brary
> user is better suited to deal with those, like they already do for
> libfsverity_compute_digest().
>=20
> - Eric

Hi,

Sure, no problem, we can drop this, thanks for sending those series.
Left a comment in the other thread.

--=20
Kind regards,
Luca Boccassi

--=-G4AikyLsdmLSTzbu4jWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yaEoACgkQSylmgFB4
UWKLiwf+Lf9Pn83N85xmR4FVESFrcbVtdf4CLvRfWYvq9pqzMFLTaUWchQwT7jq7
UFhFOmXhGwViRKPWGIzyC5voZC8Zy2aLRuYFCYdSJcpE21MsNJYMNOHXxe+cAcpl
Gq1UuFJEOad1yaaeEuKS1nC2KrUkTM8o27qq11Zhpegu73yRiskXr2yHLjx97azE
PxuEojV+/1PAds5ZpjpfUZ/OFglFHQ21Z4U1tA+9T+HWqIpdwXAjoaRSjlEseyak
TwMq3lLlUFU1fqS4bsclsYwQ6xeyljKvvOoXHaHh9rCSjn8fHJ/r26VoiqNq3hSv
VckJvHndWxi6QzznxU4dPcTksR3lPQ==
=7+C/
-----END PGP SIGNATURE-----

--=-G4AikyLsdmLSTzbu4jWZ--
