Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196F62B5C84
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 11:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgKQKCj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 05:02:39 -0500
Received: from mail-eopbgr10112.outbound.protection.outlook.com ([40.107.1.112]:45246
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726925AbgKQKCj (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 05:02:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y0yebZRNUZz273L4UP+LMNvxoC/N3WzHzouG4YgEu0wPAJwCYV0ItGmp+NL9utflrjDfJH5i5ACnQlyqPHBs8nuYlsV5UABBlz8gzzAv8k5pmEp4GGWhIt67Z+/2L9ce5TbDathIVv5FNakiCCiqNPwFgRS5qMyG3Hqyk8Ee0PQDYCbUYW1w3X4JgbgDdoN6n3brLhSDtc0QcudIM0kbV+39zmpyOuI+DcN9XNBtYWf+UEvHj7jYlcdII26mXoTSYSIpxm6U61LbMpLMDbr5D+t2M2MPXynwdvLW7etBV3hRHyZ8FPjqpCk+PxS02nHL/9jYi3TbyZ3edf91q8t5CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaDYMPGx9Uh/X96tBoHHjo1jHXWj1J54SFrercfrhQU=;
 b=RAllxDx0tvNQdbUsYOw1CV+LnW9NEQ3l9LwmbgP/bsBe41bELm7Oa+DqAqrOUYvyYhFEMJcHWYqGYmUJMLWUK+zGqGOLxdj5cCkn6iwAs2UKIzfNDBB1QNh2d7ZBcM7KH2dTpPi81NWWP0YMeA96iQUYTQ9i4tyHkyWa5bEzVwo4SYsEVZNUUnOoaozUQtd0gsrBxxbYjos1c03LD+OD195IJaBcf7+1lGgq1mgoh3TZ/yO34WC/7LAt91Y03YEsKvNNC7Sd7BxAAgt/dpN/OeYS9oXV1o8JAhSLRobRI0SfKg+MV69s8830BBAI8MTWHpaNkOgDu2aiuPNN5sTxyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaDYMPGx9Uh/X96tBoHHjo1jHXWj1J54SFrercfrhQU=;
 b=eh9wtMJKA/qnQgwhMuCvML9kc91AsbkyO+3H7IKagHNXoMUhmcROPRKrQh8rFJQ6mIRpaiJAmyz44zpxy9NNLnrDNFClDujiQw/mQVEz4eu+VbWrQ7iuLS5OYv6ft8fvCBKzN6gTPZJ9kcT6+2b9mZwMS9VJwLl/7zXLEPEYKys=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM7PR83MB0436.EURPRD83.prod.outlook.com (2603:10a6:20b:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.3; Tue, 17 Nov
 2020 10:02:30 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Tue, 17 Nov 2020
 10:02:30 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 3/4] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Topic: [fsverity-utils PATCH v2 3/4] lib: add libfsverity_enable() and
 libfsverity_enable_with_sig()
Thread-Index: AQHWvMjCS105VzYeFkOrJ1jqw/OtHw==
Date:   Tue, 17 Nov 2020 10:02:30 +0000
Message-ID: <cbb9676d2dd21b2946564510d8ce0dd731037b32.camel@microsoft.com>
References: <20201116205628.262173-1-ebiggers@kernel.org>
         <20201116205628.262173-4-ebiggers@kernel.org>
In-Reply-To: <20201116205628.262173-4-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: c30c2fde-d279-48c3-fd1a-08d88adfe58e
x-ms-traffictypediagnostic: AM7PR83MB0436:
x-microsoft-antispam-prvs: <AM7PR83MB04363D5F2DE3A3893907C6FFF1E20@AM7PR83MB0436.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3epc+3ifjSC+0VLI/kjrCMw9qrrYcNTtb2o7lHi2eQkHkyZFR6LrKBZxXD1T09fDuaC8FgJTeslG8vvyVdHHizDw4gxQwMY/16YwFp32s6Zpb3rlU8Pua64eNap44E8DW2z/HCcziCR6KHj5mHosLZWwrQv8Hm3DSWqzODX3nIIubSowmWW0LaDqSin+YFxas/H5bNl0v1zbLJNZwOPIkUbVksJkmkOeNIEraKZDk3aOk/Vq8IgljKxBGNB94pUE81rC9qX6cM+nBoOn7qghE+FSZ50RbtCTOdixue0mH+00ixnQknCkUUbzAODpkGPVzSwpfpb4cqpOuivF1Kc2jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(6512007)(26005)(4001150100001)(83380400001)(2616005)(4744005)(4326008)(8936002)(110136005)(6486002)(5660300002)(86362001)(2906002)(82950400001)(8676002)(478600001)(316002)(36756003)(99936003)(186003)(66556008)(71200400001)(66616009)(82960400001)(10290500003)(66476007)(66446008)(64756008)(6506007)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: P5n3SHNsbC17dNvlF0l4NBqLnNMMZyB+VhOZGeXT7Qr6jGY0I5FsAkF3AFAgkx9CTtgdgHo+lwDaI9DZPdh4cvPydiLZw0XfgxukF47Q5IK51BHLcZGpkSg7CzJBWWl/KLhU793oqOjeq4/KOug+YUI5CyDrtDZkMLDWnv0pVvYaEV4D8Pp1iSRuJ1VLkEzcbEi3dRqnjfM2Lrl3LFdg5J8oxMcLiZ32p/8ZOkrzVmU/oEY2pdtAPJ6wuRSUfoAjFt+UlRaOtfCoDQo6ZsH2UvIVCWi2ShRGl0L82W15Rw7dHw8ad/KTUx0TTWyEZzWtXMrVib+s+nT7ha566jUdivAPnYqleI/4VJjdoR4m1AaP2SzhsyXKtjFdf9K99qcP3EczC7g1xnPxzHN63CTqa1R5Ehq881/NIywECvThoPkf3YRSw5pNdBl5ILq/FD4ehlKqgQvy2pvmh/YTPZPVkdc0g+2jLCr8XXI8ovPHmwnnCdNJR0fT+ETtXzvLssxHRfucDCBSoEdQt/zbbG8/UoKMb7BaEiBPZf14lgDKdOgp7SDXTw8l09vN45acKuq3haXRnlEH41mBxX73IYzP5nWWUxgH2up8O8OC5fijpB56seYJEUELR07GOUfEec61LsayQ0voXfwL9oriPjz4t7LqJV5zvt1yN6y2F5yo+Izy8xb0yEzymJPZ1dk+7p70zxiV0WIDudPEWMFadcJySjuwXidEg9svdAsS+FZGuAAgm+VctQxt7tKx7KlDoPtee4wBtk1ZY/VZyq7nAkXClTEuD5FMFCnc5am5P0hv86R5oDSXqo7CEe9yyQcjSqNpDkIGlXGUx47TFN83wJbKpnUCAHRIMKeDeS2lmRM7WVA8Ahw/QTtj6fNWEDk4XCs/QAhgdCozXcaZe9fRQ9wYIw==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-30mXvDHAtEW75zgNoSHJ"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c30c2fde-d279-48c3-fd1a-08d88adfe58e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 10:02:30.4599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a/M5MpxuJQchQ4f0SzGGyffZrveOehZ3OUVDxlJcnhn9qX5SIhhagH4CAa5hVGqZf87N66vz/b9TmYvS/8jsig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR83MB0436
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-30mXvDHAtEW75zgNoSHJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 12:56 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Add convenience functions that wrap FS_IOC_ENABLE_VERITY but take a
> 'struct libfsverity_merkle_tree_params' instead of
> 'struct fsverity_enable_arg'.  This is useful because it allows
> libfsverity users to deal with one common struct, and also get the
> default parameter handling that libfsverity_compute_digest() does.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/libfsverity.h | 36 +++++++++++++++++++++++++++++++++
>  lib/enable.c          | 47 +++++++++++++++++++++++++++++++++++++++++++
>  programs/cmd_enable.c | 26 +++++++++++-------------
>  programs/fsverity.h   |  3 ---
>  4 files changed, 95 insertions(+), 17 deletions(-)
>  create mode 100644 lib/enable.c

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-30mXvDHAtEW75zgNoSHJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+zn7UACgkQSylmgFB4
UWIamAf+LVa/kRkYPo/Uy7OKkF/SstQRS2Oj+55jsTdImj/ZwM7R9NfghVVF2e6N
VEdKlPA/IME8OghvJ8HBuHHYVNItuDlDazjG6WlevPQnsNi4w+BMfP+jp8CHpsY2
OV27sHsiSzqQ3xazYqS6SeVJP0CSGGBrC3N4l4sEtJTSw9f/D2nFD4CqT86b0/td
fm7oj/1L2Ly1ZpC8TfMcw5T6upaOwmj3ogC3LEO0HsNxMcTs5mQ2D32iusILx/nE
J/OAh1h52n2xfveRCR2XIhH26pZPeHKt0E20ZjEUHGdweYKOyxHBxRiAXuYw/cHv
9Vf+hpuMNbETdkERAPtSXhghDfsJFQ==
=Zb1j
-----END PGP SIGNATURE-----

--=-30mXvDHAtEW75zgNoSHJ--
