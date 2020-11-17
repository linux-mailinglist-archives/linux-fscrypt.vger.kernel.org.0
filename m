Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E4F2B5C8B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgKQKDR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 05:03:17 -0500
Received: from mail-eopbgr10133.outbound.protection.outlook.com ([40.107.1.133]:17517
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727426AbgKQKDR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 05:03:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avoHKc8qx4u+WMd7KS6mpbA93AFHHRMoJNqjwM76A3I0NmqU/oSKZ/C4c2wcUYZh6Pz4NUT1zYtwqDx+DM5p2WHGC0dp3UiM/5fsMjMOwZAajz34dUzkZg0IoT/BHI9vzJeKypGH3ueqtUpikAtwG2q3XFhkRHzrsQYKvX1ZVjkI5wyyfyseLcZEaLSgmBnFPnSJzyIcU0AyLW0jQUHM+ShnsrfIu1QOCXj+cwfB8+p0OVMDxM4k07O8UHfpKD7IHXo6M5F//sAY8UWikvzH7jInH7UHMx0QM6tJ++aMRfRnz1DW0JDmn6t16KBiAhLj8UIVX2IvIzm+4wGtzejh4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldW4H5b7sRMPtFiKAU5jSygdEeMe1DN6lE8CFdjc00g=;
 b=hfg38REEf7Zy0gMqCZZocx1RD6K3b1cunXDu7PshlufIyhXkfY/O815ywmBhd8ywrBBD7/ttH3vFdf5jt3caPk/yBI5RsSG0RFv4NBpiXypAB8bIOQ2zmkr5VauykTJdBEgmzJE4dFUepOXveTvGVBx91C/v0lqLeRNCYA9FuDJ1J7z/7pb5krXb/3+UCd8hXOSUXQOPRGgzylIRmiApD/fEN2ociZsNSfmr5f9TtIy/hlfHnW34biWELfVP1bRyS/pGGzzqnvnRVrw/QWJGnASgOwNsx5zWIOtsFqc4KS2So3EdApaM22sfxnZmyL4hLqq0/7aNlxnfImMEMpDnWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldW4H5b7sRMPtFiKAU5jSygdEeMe1DN6lE8CFdjc00g=;
 b=X+vnZarXToB0OUjA5Xw7hAB13G8GAhaweaiICqcsBZIE1+wyautIvlqjypl6n+5sxiFCl+xGO07sCAli867ro2eZ3mXElrZoRHVsqyHpHX/xbfH2TKCLfpiqQN6QsO6820ZiYtz+xb+Z3MBL2EgOzTrHqx3AjzaECg07vQX4C2Y=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM7PR83MB0436.EURPRD83.prod.outlook.com (2603:10a6:20b:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.3; Tue, 17 Nov
 2020 10:03:09 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Tue, 17 Nov 2020
 10:03:09 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 0/4] Add libfsverity_enable() and
 default params
Thread-Topic: [fsverity-utils PATCH v2 0/4] Add libfsverity_enable() and
 default params
Thread-Index: AQHWvMjaCU8VyuaXSUeSRfu2C72CJw==
Date:   Tue, 17 Nov 2020 10:03:09 +0000
Message-ID: <668cf196dabfe50e6d40636b07fe9f91fca97d30.camel@microsoft.com>
References: <20201116205628.262173-1-ebiggers@kernel.org>
In-Reply-To: <20201116205628.262173-1-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: da7095fc-fe4a-40fa-86cc-08d88adffce2
x-ms-traffictypediagnostic: AM7PR83MB0436:
x-microsoft-antispam-prvs: <AM7PR83MB04360BADAD4272F3C9ADF692F1E20@AM7PR83MB0436.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9JynpTIE2dIXMmeJBOxo1EdpF838RWH9S/tEd18B3/Tb4+EecjC4nTukBaFgOmf6i9lGS7MPG6WH4C5QSTSIaCwh7SniKyFAhXtUTCnaao/7N/X1uEGGjn+1YbRUaMWMesMf4MgQYLyzukaKZ6dabsIzlXDxhpdrQANLk5eSZkb258VvJlV+aEAJFgd7BwgF73xSMiAPmvN7GNV9xyPauMTJOc9rNQ/BuJCvH/hejBmbm+IuZmxE7XCG0pksF5hLEiekUm1/LBwzI1zcVL99qJjusolM9s8VjswV3X/x6FcJPcECHj91iz2zU8AG/u6rB7gI1GgK6PdwEwq0qhuq/2RzBECvuqktKBpv5VO6BbOn6D3/3hg9lIjr4j6WKNRiafl1felH4oIwd2CbMz1NUg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(6512007)(26005)(4001150100001)(83380400001)(2616005)(4326008)(8936002)(110136005)(6486002)(5660300002)(86362001)(2906002)(82950400001)(8676002)(478600001)(316002)(966005)(36756003)(99936003)(186003)(66556008)(71200400001)(66616009)(82960400001)(10290500003)(66476007)(66446008)(64756008)(6506007)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Nzm+IqMgPbFeePyAbPDrtTu29HbD8XXDfrJIUgbDowEzDMjxudd6blpcl60BCHlSuICqTlNvwLzI/lF1ceuKC1xCBi9CHgWcwCgzgSp+Gcnsmkv7mfjQ2A4s03qWtqLh+57cDeh9dvzUNJTUCdPpRgWmFikZXifZYWWg6gHVrwWOhuPJO0Zly7oWGBfMlqi80imrWA1l1IVeO1dCT0Z267nOQo7hkAT8F014zrmYrRiPwsWMPycV2JSM0bcQ3YwquqZ4WMPZuc93gqS5gjU6M9hfKMwqnjcu6dn7fbAavxsB7KUlmqGATETjAJ6CTVk1S2Dqgw0TZxxa7FR4hiuni2vrMJ/Rm7TLCt1u+u8oLbH3+emgmSOW773FVI0w+MzmxRYy8O+M+VNHYLGEj3jwZWmG7qdvAnqE1cZfU2DCVHhv52nqpqRhpycXvfcwkAG0oZ3q0OAv0Mu5FDv4tzC7KUdJeyVrmNPpbXZboAtV9aaVTehKrAczibxPOH1P9xh4QrIhYdgKqI5kPQqryK4Wpd7wxq+C6dyJxls/SzxhDZxjuJqeue2rkqCmGyizEL7z547s2Wr9tBudA+u+wOVGJ+Vrn3LeZJ3A7FTRFAbWmSuqZXzdn7P0dHP0tm9jz/WOQVsv22OnlW2ckdagNJO7rRrnCqOV5EFqjZ0VzGrLygBsRIyF5cvO0qYxEmsUOSgcYkSwtDAyeNejiIbvAvIJ3xxwpbdtaK1JFV3bobYi2c6jA9PXrIiFmXUEwdajjG8DPAbLPJAkiRPZhucwjNmwOn6hkw8ofoz4V5q1D5GszsVdS3V3krIuKGQlVwfUFJjIpC3ur+ntESZR+il5rHQB31pF82G1Yal3KFDnA6txw8u882EmovMyD9E7ff24dCevtmEnorwHmBxp3+xnTObt3Q==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-9ZdizsNCAGC3ISjd8e1Q"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7095fc-fe4a-40fa-86cc-08d88adffce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 10:03:09.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e/A3VgMuEYcwXcI0S//09erSyLqqvIgVKq8HTKKXDlve6E8jTPPuR0GLLxJALkJ5EcL1Tmt+HWMPqoSAyLZTtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR83MB0436
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-9ZdizsNCAGC3ISjd8e1Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 12:56 -0800, Eric Biggers wrote:
> This patchset adds wrappers around FS_IOC_ENABLE_VERITY to libfsverity,
> makes libfsverity (rather than just the fsverity program) default to
> SHA-256 and 4096-byte blocks, and makes the fsverity commands share code
> to parse the libfsverity_merkle_tree_params.
>=20
> This is my proposed alternative to Luca's patch
> https://lkml.kernel.org/linux-fscrypt/20201113143527.1097499-1-luca.bocca=
ssi@gmail.com
>=20
> Changed since v1:
>   - Moved the default hash algorithm and block size handling into
>     libfsverity.
>=20
> Eric Biggers (4):
>   programs/fsverity: change default block size from PAGE_SIZE to 4096
>   lib/compute_digest: add default hash_algorithm and block_size
>   lib: add libfsverity_enable() and libfsverity_enable_with_sig()
>   programs/fsverity: share code to parse tree parameters
>=20
>  include/libfsverity.h          | 83 +++++++++++++++++++++++++++++-----
>  lib/compute_digest.c           | 27 ++++++-----
>  lib/enable.c                   | 47 +++++++++++++++++++
>  lib/lib_private.h              |  6 +++
>  programs/cmd_digest.c          | 31 ++-----------
>  programs/cmd_enable.c          | 34 +++-----------
>  programs/cmd_sign.c            | 32 ++-----------
>  programs/fsverity.c            | 35 ++++++++------
>  programs/fsverity.h            | 21 ++++++---
>  programs/test_compute_digest.c | 18 +++++---
>  10 files changed, 201 insertions(+), 133 deletions(-)
>  create mode 100644 lib/enable.c

Tried on my machine, looks great, thank you!

--=20
Kind regards,
Luca Boccassi

--=-9ZdizsNCAGC3ISjd8e1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+zn9wACgkQSylmgFB4
UWLNQwgApkyHdvxqKAc7AGC/JTdVK/v4ETt1joYUkVf/TqVhZxDRSqg2cHcMCjDY
ExeBHvONO9GnPcK6IjBPAbASxpIGZexf24W6K5uSlQbFt7qexzGbGmHqt16fHyNE
kJo6zp+FtHy8+AlmkwU9256BRme4DbMIBGp90NJoPSpytSpGxnr8zNIxp5QkG0zd
JJJQxkVbwmTJbdbvhSk8d+hWvwa1/HJwxXwsBzDBgd9m6/B97bM2Sf1AUUdeAFny
gv3vLygXcZ7tusihKVdK46PwCFS928FaE1KhwpV5LOPlCXtH0FXKvfvZbh77aaaG
YhFEBBzFZQtILaWRLdRtHkI1XmW2Ug==
=LCCf
-----END PGP SIGNATURE-----

--=-9ZdizsNCAGC3ISjd8e1Q--
