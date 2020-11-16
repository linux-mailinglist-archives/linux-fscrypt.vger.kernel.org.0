Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838482B42B2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgKPLV3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:21:29 -0500
Received: from mail-vi1eur05on2103.outbound.protection.outlook.com ([40.107.21.103]:4874
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728882AbgKPLV3 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:21:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oL3UbP9NVfsW0tWtxG1roP+b7+8ZGwl6CF68c424RiA48isOl2THzvvJ9gXbKo9FbMCJi+nyMJD3sgARODkBry07uKA/u6lUexC1/eiJJ2iXGWkaduiNBAGiEUcvQC5xeL3jlCsFkKRDvfck+9F5/x+OPf8orxvYtIsCqGJNNW7yZbCq5frh5ctge4WcafzyeXkztNyN8u8BiBL4hFlvHh6MDbk92Q1GD2WvwX3UkgTJ+fPrI82k9Aih2pNVSJPhLaZIRQq3D1WL/XWQXkdWKHAamnFl3bIKD17PiBwHhzzGVUm9Jx3PFBSqB3t5kdWciCuQf9cvCh7srN9E4F+95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTlsA0XZhijZ1IsaHuQV5M/lcYV4IkO57KkKRo1hvuQ=;
 b=aUgE4ddpPSp9ktn4CrtrERF3ojfd3BVrSn+2l9jHTfzbykMN8sm/KuyKf254/uoO6pWYvj5sS+o5m9zqjVJdzSk90SxeSrurm5z8SNTS2AGJfGcegUlUzfK4B2FBPoIJDLNhw9Af1YF9VbY0aPO82aL1ozkq59Ehj8JW1wTxICNSpRss8/aQ6BX1t1OpGP1U/sgIYZOxdb1xbCCSqdqPZB8LNd4QB5SdOG4CcG5N14StgnWSlSyyOVHL58RErJHGMUvrmOWSy/eiR55iT331CkxyfQJX96AjsjQ9hULUWKPLlXuumCmI1J6YC05+51YncS7y3MQ20Z+HnwCfUWRQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTlsA0XZhijZ1IsaHuQV5M/lcYV4IkO57KkKRo1hvuQ=;
 b=YLzCUNbrg7iF8FpKNtl+S0MlE+WINhMCJc6wT2g3WPN2TUSNov/Sca1MvFuo770pMJPezqUaTRz9oCQrl/sO1D87R3rPKJck8vtfHW4J8iwbz022D+MBwe4o5jKDRDizAieCtf2blhBY2b6hLTOn8vytf2sGwKVrpWwmyze5gVY=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR8303MB0084.EURPRD83.prod.outlook.com (2603:10a6:224:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:21:25 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:21:25 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "victorhsieh@google.com" <victorhsieh@google.com>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "maco@android.com" <maco@android.com>,
        "paullawrence@google.com" <paullawrence@google.com>
Subject: Re: [PATCH 1/4] fs-verity: remove filenames from file comments
Thread-Topic: [PATCH 1/4] fs-verity: remove filenames from file comments
Thread-Index: AQHWvAqeDGJxGb3sgEW/5Ji+Dr3Tpw==
Date:   Mon, 16 Nov 2020 11:21:25 +0000
Message-ID: <b305fda4e0fc0ec57b318629d2f5c9760e5aa259.camel@microsoft.com>
References: <20201113211918.71883-1-ebiggers@kernel.org>
         <20201113211918.71883-2-ebiggers@kernel.org>
In-Reply-To: <20201113211918.71883-2-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: ace5e832-0c08-409c-5614-08d88a21c140
x-ms-traffictypediagnostic: AM5PR8303MB0084:
x-microsoft-antispam-prvs: <AM5PR8303MB008442DA88260406EE6E8477F1E30@AM5PR8303MB0084.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uSpHuHUUPh37AKm/9a7nQKnf8b2HLHHJ1n56EE+3P827xiIJ3urLFPAR5g1iJiR2/e5mOi+QZbEnElSVZTNhTBbvtBN4qT2oka9wWkgGNOiHatbstb9xkYaVAJvXqbpNzETYLY4KB8etl02W79SsXSraIqqi667otxOCGEK5lzinPir/qKSJ6oWqo2lvAOMqNd3Ux7u0y4nN6r7cmNFoHCbDaMc4TCMfV/Bh32PntT+Tw9M68RV20ujjOaPErodRPnA8Mh41fDabEl7YHf9mOiGD1rlVfcUo8y2+lQqZyhwB+pcpkStpquCUeLWAFAOx+ReYpiUbs6yFY1FPRMK+xQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(82950400001)(82960400001)(99936003)(2906002)(6506007)(186003)(26005)(4001150100001)(4744005)(478600001)(86362001)(2616005)(10290500003)(5660300002)(110136005)(54906003)(4326008)(66476007)(64756008)(36756003)(6512007)(83380400001)(6486002)(8676002)(8936002)(71200400001)(316002)(76116006)(66946007)(66556008)(66616009)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: GIO2uNeyun/jpsGUnsMZ6mlTwCu1gM8URFlCTnlebY9PCnXiL/vdljoHRIb1+EZFIcpGI/iq1nvSSWhaj/0OqNt1aYFHQ/gmPEBvgm57MnQOa5EtJ+tJFRzhcQUrY5j2EMamcPGfDVpXubTlJmqPN25RiiMhUTlCNAIiB+DRhD965vy0un+VqU7jlWaJ09ovBNJ5dRK+erJQ+/sF22ksWvWlb9pOoETLJOGL0hkNwuwBati4tx5P2cSl7p8I4y3tYdGLgR9u0BJ6RoVZX5MTGZZ3JdH4rcFq/WXqboiEy9U9RLk/5ounL5YWh7LmGaKrOroB7wXUH4DEwyZ08vK/jMVH4HMBpFNhXE/rvR7BZvdsM8anrf36PM6DZ3nMJmicu23so2Ew4sxC2X1UFrVQ0+dU2tmyjl/X1UAe1rSPS8YFXIJebjR4HGclmLmueCg4BQ6MLi02Dg7630iZ4KeTCsQMSTk7l5o08GPHprMimS5fn25CQvSL5NvFijLeoVJbjREdjBGcQj9i1+xH9wDtsV7ELxYy8DzzSB57hvMpSUs/JymnnmMOKlUK8/GjucObZrpc0UmM79XzZbKY2ODdwoloNAblCiKeI3gXs9kLtBzp7C36ZWDglrqtP3AmJqEk1qw+6BSEEVkkKk5aoEtdYbYq2UWnS3Kc3hTAeB2QruaiOgUngfx0B6uUH5nWjhH8kMhc5Sucxc4DA6OS6tnTEuEZAmkxZD5qtiz0errKCrWa0x9mx4+azbnAbFKYcK9BwvfcZjKvAn3PeA/qxqdQmdgQdyTHbXPC6ILPfb+igkgurki3+W2dyoUqnJgRCBFdGNXF2RNCILEbg936Dy58P+NBbMB7xHEdYaWYIpEDaphmfEYdq88XIaLB+dLaBgzP+5iHW1pXaPafMapgS0v4Pg==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-eRPqKMtNggsve0NYEOpv"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace5e832-0c08-409c-5614-08d88a21c140
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:21:25.2208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rBO7ZRVazYbmFsKkKa/wU+6WRpyd6EzU/lt8L5kbHKvjUvMc+7HSKreuLHdrEsF955sfITR2Q8Ar/Y6NCsiYYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR8303MB0084
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-eRPqKMtNggsve0NYEOpv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 13:19 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Embedding the file path inside kernel source code files isn't
> particularly useful as often files are moved around and the paths become
> incorrect.  checkpatch.pl warns about this since v5.10-rc1.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/enable.c    | 2 +-
>  fs/verity/hash_algs.c | 2 +-
>  fs/verity/init.c      | 2 +-
>  fs/verity/measure.c   | 2 +-
>  fs/verity/open.c      | 2 +-
>  fs/verity/signature.c | 2 +-
>  fs/verity/verify.c    | 2 +-
>  7 files changed, 7 insertions(+), 7 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-eRPqKMtNggsve0NYEOpv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yYLAACgkQSylmgFB4
UWKnKwgAsNYE6IDqTrzIjSNFZsbRfzEKud3ncB6s3hQoeexMP1tYz9+jEgAA1h4w
ADe1KjUPh7rR3u9OblwkWMccAstTdi8oRCbzK1b41jP1f8CkSO8CxZKMP6nja8Cd
59du5CBXraLlFQtJTGMnRfItgK8xV/d51cOMuTAzLWpePWQcUSpx/E/0GIIv7rRc
9CvSPpuacfv2xSDM8YfX+X3T6hLENhpdK581RQihg1y9DM1iyfBpV2PGf2PzJF2g
EuPp4RKAiAeRKpQ8cvHVwraZGGj0NcsJ4QmC3fkWZ5eNdkV4ZLFNwKmgCdVSdizb
b1KBc0t93H3F4lgRpELJR5aEXJ/8ww==
=JiJo
-----END PGP SIGNATURE-----

--=-eRPqKMtNggsve0NYEOpv--
