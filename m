Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3122B5C7E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 11:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727764AbgKQKBL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 05:01:11 -0500
Received: from mail-eopbgr140121.outbound.protection.outlook.com ([40.107.14.121]:8999
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727710AbgKQKBK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 05:01:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViPHj9wvCqivBB9kOUnkz5kEkL1B1mKvamJnvq77qzw25Sx5gkVBkWA1d+ag2xHwiFP1bC/uqIsFYPPaamXeKyP55ATdz+DLJENALTgTJCNfsn5oNpxhM8kxivPyPTW8gYZcdVwIxCThWigcTWNqTr2HG5qHhxi16Y3G10ZMjIM+pTmmusAj+wXJRIIptQwbQtKoYRFVjiMCB+fviSKIB9p/kp0kl4M5xs/TGNltlhvFTq5ImdhXoHQy6IBeEfPITsd/mOlNMmXQQ3j0zNcQ9dmm53mRq/rCgKLacm7SuIJhb/53XPrSEEvlFBeuUt9I7jhsUGVG2qPD5V6IKRqpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9oDUP8Mz3q5e1qlw9u7krmyC8P6H0rJkGaRG7aBNGE=;
 b=ZzkDYOu/FJLawyd+I0KShVTgmkqti+F84XOFne+XNLXINrY8fJpaWKD3NVpvn3A19rh4zEQNlr4T7NifRn70ufZnMaJ9xvCkD3vnGzqZbeHlF3qdGQ5pPVJDKhv8HgpSv+EIp+9ZPu+KT6Ph0GbKrRkeWYwVW7/HJHDgxkJ8FJNXooqO29br951oD1UrFtGv55EW8Sxdl/gRvSx/eU9lIf54Q4GrOrz4ehhruWy9PaBuzdZ0vq03Z+mmotTz9Ce2r1pcofaSE6xPMlKBGwttHX/LfVPLxOHoM/hU7GYcN33ss2PwP4TGTHjy7cSq5FFGwUGufQ+rVBgzTYIk4cIX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9oDUP8Mz3q5e1qlw9u7krmyC8P6H0rJkGaRG7aBNGE=;
 b=R4mja6hi2LluoWCoZREx9RzTNkdbCxbRk697LNJrcoU5rmAwd4Lzo7fxga9JKZAAPvculACO3tg6Gmu78NfKFXnIxi4+sl6fpY/cGEUElT9QMwwWNfuWt5PcQMCqptf4U5ZwLXpppTzIcv8h9dFBII0I9n0TWf/+3qq4rq2Sg6Q=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM7PR83MB0417.EURPRD83.prod.outlook.com (2603:10a6:20b:1b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Tue, 17 Nov
 2020 10:01:05 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Tue, 17 Nov 2020
 10:01:05 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH v2 2/4] lib/compute_digest: add default
 hash_algorithm and block_size
Thread-Topic: [fsverity-utils PATCH v2 2/4] lib/compute_digest: add default
 hash_algorithm and block_size
Thread-Index: AQHWvMiQYImZUwaXPUOLAp5jJroRgg==
Date:   Tue, 17 Nov 2020 10:01:05 +0000
Message-ID: <bfcda9021e62d690f9ef43d6ad7d56af1bd05467.camel@microsoft.com>
References: <20201116205628.262173-1-ebiggers@kernel.org>
         <20201116205628.262173-3-ebiggers@kernel.org>
In-Reply-To: <20201116205628.262173-3-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: db7a5289-8905-4abb-b8a1-08d88adfb2d7
x-ms-traffictypediagnostic: AM7PR83MB0417:
x-microsoft-antispam-prvs: <AM7PR83MB04176D00AA2EE1AF435779E5F1E20@AM7PR83MB0417.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tr1ZpJxaEM15I1evaRMLnYl2mOZalhkYFYAa+iwpsrk0hpF0+Hicwr+rZzkDwJc4Dtz//qOMbLvCVwCP3EZeQOfXyQVvZK7u9tDkvocd1p3Qw40IptjD9wHfEFeJuWNvN1T2RAVyC3mjTC9Cs/mHvZ8MY4WW7CPU3VOILuPQmoILwM6aAeaZg9WJLhP8P5cVT0a62EJ568LKOk8cWsGc3Xp3dmvtRhx4yE5c6AHOKgBmrJYDUbfZUKQd6aJ83jeqxsB9E9+4J8D16d4qmJIbzuaQ8hnbHbne/dEH2g+yJnVfRaxgojiSS+nb+3NYGNZUFHu71oENLnE9fb6vqXSc9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(2906002)(82950400001)(26005)(6506007)(4001150100001)(4744005)(478600001)(186003)(2616005)(86362001)(110136005)(10290500003)(5660300002)(64756008)(66556008)(66446008)(36756003)(66476007)(99936003)(66616009)(6512007)(83380400001)(82960400001)(71200400001)(6486002)(8936002)(76116006)(8676002)(4326008)(316002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cKL3s6iO7oSbjVmLL4u2n72pJybwQqmOksu/tXLEe+veidP4sK3sMKcMLSxkYhIr1GlAa0vLDCz8RieTjINaxWi2vunM2Pa50E60gvr5MDv2JqcXNabVue6AN2HgpA+s3/etqdTCOF7EUALSOMK/oES+izlWKzA6LxN4EtNB/EkSGkIzRwUDBtGAWAkvV5gaMsI8nzI1Gw9Wh54i5m/WXRWEFOng/fm369FMrprsHaYBxkmJge5KuqLuxSjEzSaZj4f0aaQn/YDuECN139XZHkOeazD3APF2YuVs46CXgYuBPLSCU1XGiG3VE34zc7oEsCG2+Ruuj91GwF/hCVqq2MSiAijS9fE4921y+4+wHnedvMibNo+nY93EkkfEogBo3zcYTj3rrUXzgMckOdkzz1jeD9Wjt8eE+i+kiPV/2gZuTqG478cmVDif4X5XIDO+41p+6svjBoQP3MKwt/POI+4PnE7vbNr+e+J+3iGv65T4xO0AZkJ1posW17CG26a2akmxGEK9Jiqcoklbl8oVsUUGGHBHP8CJG46mtuUJeOoZ3/dGpaIlwO4/nuzZfr6dQahXelZTgNyfEYzWvhTt24+fC8WX1v1neN8k/0hR1dh6tOX8PEWkoeIHHiHEQW+vVztZtkx5GtCbVQHuHmy08VnKR8QEqz5IxLzLxut0FygSJdipLgZHGy3zD/o/iTF54jyA874BTbgosWR58ZWLc/ZL+wncdT80Zm1U5diCiZn4UR7DQ97NsMFCZMqe0xmJeIFFHjahhUR8t33bbgB+sss2/HxWKhqvyxhC/e2HGRNK94EZD0DoBOyUyVBJlOelzb9tgFAs+cU8QYcRo9fol5IIOfQBEXwanuHA36l6h911xxh0l1uY2X7TqyhRFkaLOMDxR6nvz1I6dyZ2hcaydg==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-PGVTQna36h2Z1NWiQRzx"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db7a5289-8905-4abb-b8a1-08d88adfb2d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 10:01:05.4577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /HA4CzoGByGPrVm+yDlCq92a1SyHQ54HNIpU2aD4HX/fMcjTGwbVZ6fJlblFOjUxOVxjj71xbmryprk2QrYWWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR83MB0417
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-PGVTQna36h2Z1NWiQRzx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-11-16 at 12:56 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> If hash_algorithm is left 0, default it to FS_VERITY_HASH_ALG_SHA256;
> and if block_size is left 0, default it to 4096 bytes.
>=20
> While it's nice to be explicit, having defaults makes things easier for
> library users.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/libfsverity.h          | 47 ++++++++++++++++++++++++++--------
>  lib/compute_digest.c           | 27 +++++++++++--------
>  lib/lib_private.h              |  6 +++++
>  programs/cmd_digest.c          |  8 +-----
>  programs/cmd_sign.c            |  9 +------
>  programs/test_compute_digest.c | 18 ++++++++-----
>  6 files changed, 71 insertions(+), 44 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-PGVTQna36h2Z1NWiQRzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+zn2AACgkQSylmgFB4
UWLUfQf/WF282jjGwue6IDlntbR0N18iVVhZ9iNyxBSYmaX7dTD7cEDOb7vKFQYN
xho6AwLlCg/CdAnP1ScuJpE97TdLUpkaaSyPB7Mm5IhJiqW4iC84NVt8+OKk4VTK
RC1sv+ioFXZrXgd0L5FQF6eRIeuGyiABTnY7StN1FbvFLycZ637BobwHWtt+5+8k
PmtqwnJAtke285oA71aAm7QyQJO27qkjs4Wq5p+6lNYpWNrGlE6D8PXNjSuxH0fi
TFQhvWcKpRhJMBysRJKzHMAuiIAiJoAzUC0N4ayZ09Oq5oj300SnRtc+ZVQqvFd0
db1j1Kl5pn7MTCcVOoySHHSoHRzZQQ==
=tkYN
-----END PGP SIGNATURE-----

--=-PGVTQna36h2Z1NWiQRzx--
