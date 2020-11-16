Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C582B42CF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgKPL14 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:27:56 -0500
Received: from mail-vi1eur05on2130.outbound.protection.outlook.com ([40.107.21.130]:48705
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729297AbgKPL14 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:27:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSuT7zDweTd2pZIzwyCqpvQ3gnd/J27gcpPjX3hy6CisWnNV+aVKLVL2CaUkFUek4f/WOfMnJtIeK2c1hVGJ09YjE4Z8jjUulRFVGy1ZbJWvhInD57SEwEaccOkbn7KjBqob1T870ElZCFohHpWCu4bd5IDEssptbQgpTYJHr+AId5FmQxt1THC/a21fVIcGUO2jZ0VMCfcoahcMfJ3Zb9M3gkv8sKVg+4yL/jl/TEGZiMaHv7bS7EP+ezkIfqH64DWZ1vVfhIT13zfO8a1qvSntQQUcuXvyP8fvLDC7WVltriajkpfeZInkqJlOc0pxBMG8BPZgKAbcy1UE+f/CmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUuavEy7nWi/qQdCjm97AHupKDYTAnR05c1PmijhHLI=;
 b=itmLrJ3YGf95ltRJdJRlESTnxzfQuUHgqVVm4JBu0mUc9WRMBzuekp7gBg4Q4ot9cP1mVwgzhBdCvIErkP/XAGNgVHkk+wlnlw4MUJAZHbOTjP+N6jV+vkRinqMj9jmnHaCA30c5i5eloA5xPM7BHtqgYFbXIZu4q0Wr00i1STTFPw4MuE0Sx4BgQpsbSTJUDDPvBT5wcUzf9fqNpwv1dRpWyt6+xDHvnEmuq876YcAMV03MXQVndT2YhhMuJR6JX5eQ7/qgCi9Sp55JnQ1fI0bztTS9+jXG8Baq3yclrhw16UjjNwmjiPRjv/R3zwj2poTyFxM4dBjY8Tgia6BKvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUuavEy7nWi/qQdCjm97AHupKDYTAnR05c1PmijhHLI=;
 b=LXYJMnq2ZAQDcvHiN+ansm9caOpn++Yl9pGiXZMtzUYtwj5a07i7ObtsfLo/nI7EmnStdguUro9mmPNhkvCgmHhYyFqfb2N8JBxD+tya9PhF0uGVE3ktma0+B539MfLvqCJUv5mPDdI2GcIZV5bwzPSIK6SuPSJppq6cP3l/Xu8=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR8303MB0084.EURPRD83.prod.outlook.com (2603:10a6:224:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:27:52 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:27:52 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "victorhsieh@google.com" <victorhsieh@google.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "maco@android.com" <maco@android.com>,
        "paullawrence@google.com" <paullawrence@google.com>
Subject: Re: [fsverity-utils PATCH 2/2] Rename "file measurement" to "file
 digest"
Thread-Topic: [fsverity-utils PATCH 2/2] Rename "file measurement" to "file
 digest"
Thread-Index: AQHWvAuFI7MVzm45qUqy1RPDAWLNMg==
Date:   Mon, 16 Nov 2020 11:27:52 +0000
Message-ID: <89d2fb66e12663f685286f7db58cf1c3e41134ff.camel@microsoft.com>
References: <20201113213314.73616-1-ebiggers@kernel.org>
         <20201113213314.73616-3-ebiggers@kernel.org>
In-Reply-To: <20201113213314.73616-3-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: 1e4f5a10-335f-466d-73db-08d88a22a7c7
x-ms-traffictypediagnostic: AM5PR8303MB0084:
x-microsoft-antispam-prvs: <AM5PR8303MB0084B6D5D93DB53BB5304D62F1E30@AM5PR8303MB0084.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CvYJ+iZzZAGWQGAM7yWaiMyKIO5ouL0R22TB4MBwVZBFsiqJrtDXnDhggZVroQUXHJNAmiaAFVqCI0eQq9Fky1u7D0+7DO5f+CX6H7tlcHd07/ROKTIKbQyn2n9shTYXEzR3k9A5X+8jSg4fYQ/JpZNi7hAj5AfrFNs74xx9fAH3HJ8fx4EXghpJtmrv6Pw6Gi8MRX4likmGqwYXjTOFlDZIchXJ2vSXx1WgTFVU9BL5mDfwGjdlsIbBsTUEcDvi5zt4zISxsRZiKDs8NZch8zjinAyaAoFvegUUu99i55zPhIiCeOcZPXlUMKjdU5plpD1CwHaO5eoUwSYLUk126Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(83380400001)(6512007)(64756008)(66476007)(4326008)(36756003)(316002)(76116006)(66946007)(71200400001)(66556008)(66616009)(66446008)(6486002)(8676002)(8936002)(186003)(4744005)(4001150100001)(26005)(82960400001)(99936003)(2906002)(82950400001)(6506007)(110136005)(54906003)(5660300002)(10290500003)(478600001)(86362001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: axzOvRb/IbeR3dZ2bYmGd6aQunL5CshItxoIZm3Ez3rNOLaI0eZMc8UbONAKWBPHLsF9iwDLKZByp8SHIdVQJGkbWmy8mwEdTYrkvODcEc0kWEMeoVNLLBrEY+3QWQM+6ue8CQJZO8znsVF02e/AcySuVe0ogzsK5kWxCJwd8SV3FsMlJXj9Wv3HFFoEVlHv64otGWmZ8fda9bmdGgF//chZkzFA34evin5Sga1pjAcZq/WgXoxcmk78bauKyoLqh8zuomxTVfT4Gf3SDUEwZ/vU0aUywiGgcdVY06nsinYmd45+Rl2hDITl8CM42ql5fm+UPACtJnhYMpyqBUaWCQBAjtBPFUP+iyJwPYKKB3XI4EbtGiybXKqKBDVdyy8jhy+Pug6EttYygxqASg2xDVtoDfhmdKh8RNN3yEF+XU+Oy7mHn3IRdVyrLCNaD/4wAqkmyYPWy4H9UUPE3TY9j4IEl4N7djvUDDS3vMqC8GDDe8dRQ1+fJF489iehfFOCKwCk703ccv8/Y55CPBHfKmA0F0vm64TWHnfXoDgMApK358H0sFmoVQnvBpEBV27uBDj4raP9bFLBknGdccM0iTz7o+taPz7UnRaeocw/1NSwgZu89BgzWGVuGHErSRYFd/1WJZtkYvnwcgMTMR1bG8VeQmqBL4x0e170mCOpbnmUv1OK2tNlWptV9jjkfLwQ+170Tt9MvcIXZth9F1k4jojvJS4VAcOecGG4PcDkg5RW4hr/PvavhfOonq/EgP0qRUlDvObNwugSfdGYoJp5BNmiBPQJEZZ/Y7p8nSwcZBhdicbnSf9xVJaanXllCh8eADJNNbE2zYrFgTHIlCTcxxomfQD/rYv6FLMfV1pk2JoXuR1WfkAygIvScUk8xhj6W1ClxI8u6XSBvpXhnBpPHg==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yBgTPZFi0NdNXNuN3W2+"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4f5a10-335f-466d-73db-08d88a22a7c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:27:52.0213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DcQnqgN6XVxa59eKXhAyl1lYVB7ZVROp577BVRt3f48B2GBiBRbLUaFO0Emn2I8HKmxhsjr9E026Nf8aM8tyVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR8303MB0084
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-yBgTPZFi0NdNXNuN3W2+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 13:33 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> As was done in the kernel, rename "file measurement" to "file digest".
> "File digest" has ended up being the more intuitive name, and it avoids
> using multiple names for the same thing.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  NEWS.md                |  6 +++---
>  README.md              | 20 ++++++++++----------
>  include/libfsverity.h  | 18 +++++++++---------
>  programs/cmd_digest.c  |  2 +-
>  programs/cmd_measure.c |  2 +-
>  programs/cmd_sign.c    |  2 +-
>  programs/fsverity.c    |  4 ++--
>  7 files changed, 27 insertions(+), 27 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-yBgTPZFi0NdNXNuN3W2+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yYjYACgkQSylmgFB4
UWKOigf+I6STVJ1GVnaxtAGzgXuOfNbZdNJgInvJvEd/Ojs7dG2mwdI/nt7CNn6l
ozd2KbCUscUWbcS4dNO26k7YofPK9L5/M4orBdywnInsJAb5FrkjEMzfAU2Ys6v1
i5a3WaRxOO9ujci7wMwN+f0uSkM3vraGbKlMwNNlUIhEjDwgo9bTpNtDgM+Qdevi
VeQTiP18OKxrE2eUSk9vA5InhE1bPu3B3g6kWaHih60oY455wv1B46vzpJ8bVYny
yu79msw1FC1U6DDh7bqVllqD8+HhYbMNdIAZX5r65/GgKJzAsNXgICYUhl7/2YxL
u4l4jsegySRcFJEx4i9OFn+fk9tdyA==
=VUWL
-----END PGP SIGNATURE-----

--=-yBgTPZFi0NdNXNuN3W2+--
