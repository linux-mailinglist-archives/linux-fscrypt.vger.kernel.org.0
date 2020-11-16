Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0332B42DA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgKPLcw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:32:52 -0500
Received: from mail-eopbgr30109.outbound.protection.outlook.com ([40.107.3.109]:25860
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726281AbgKPLcw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:32:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WObIuFqEAiOGhN7BUwAnW2wPCpYIsaDdv7N5VyewtpIUUWJmxkkBwmM2DLLKeA0Y3V6PvNOPsyatCBIaR4wChmAG5McuOf/jub+DH01JDl4mFQEP3cZVdo8GlRieyWnBmP5EKd5goTxJOzBzCild/ZXHKWvZzVKHE2u8w/8d60CHErHZy6ZDCAQ+oViJXvHRY8TBmVAZ3k4LOs0lpKY2r7bH8dL7LshOUuluh2KAl50vuu0PA2kBMNFcwKaOUe2Xxnr+fnPlIdlNtNrphHXK68rs6BmY4NSIda6i6Teh2D5MrBhPyN7e6AbXRRM43oZMkf57x00TBDm2JPPzRiXI+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jncVmxivlI3vb9db2CZEM5pvNdgtFFmpZ2sYMbKkBD8=;
 b=it1nl8d0J8wUBsPJE64Cn1OcUy+cXKgRy5edb3D+sRkXCAgRYvKNcVFowyXQ2k7XN8l8l77aMZWHbI66WSghgb3CUTAUscEK4aBFGC1lCkaxI85Gj46HLQn7R6N9kXNd7/Uc1+grlM44Zvt97aUpljg5DgmFRth3a1e9W/mF3KpbMlFfKrpJW2wC0EMtQ5ewaSwQC3d2lEDTRMN/TrqAVvq7iAfZ68iGfd/cnxefupMUl2FuFx6v4OUt/aw02astWPZRvWDGiCI1i2fyDmRuQm2auN7UW8yRqNYzMjVPtV45sW1mpZbuZj+d9980x2kzKXMWFWPc20mOFCpHhyRXMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jncVmxivlI3vb9db2CZEM5pvNdgtFFmpZ2sYMbKkBD8=;
 b=jqf2uIZfO8FDXUfAz3nD8ONubonKF25EA4dp5IrVxWa8hFC+VOygLU81OTTRIdyhlNbn797eLVqLskGofup4uwuHWbk1MeDNnBXsyKge6JjM58sJgRoMXd3tjhuIQrnikyDu6LJVFoDmKXymk9T5zMp0eLXVB41u8BRIlJg02F8=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM6PR83MB0247.EURPRD83.prod.outlook.com (2603:10a6:209:69::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.3; Mon, 16 Nov
 2020 11:32:47 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:32:47 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>
Subject: Re: [fsverity-utils PATCH 2/2] programs/fsverity: share code to parse
 tree parameters
Thread-Topic: [fsverity-utils PATCH 2/2] programs/fsverity: share code to
 parse tree parameters
Thread-Index: AQHWvAw1usJGFVv1w0u5URdJSGn9ag==
Date:   Mon, 16 Nov 2020 11:32:47 +0000
Message-ID: <7dfd108175a3d0a2403366e272da221c549f1a96.camel@microsoft.com>
References: <20201114001529.185751-1-ebiggers@kernel.org>
         <20201114001529.185751-3-ebiggers@kernel.org>
In-Reply-To: <20201114001529.185751-3-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: 3474f0a8-2c0d-440e-b60c-08d88a2357b6
x-ms-traffictypediagnostic: AM6PR83MB0247:
x-microsoft-antispam-prvs: <AM6PR83MB024735C49250DFD3941BB35AF1E30@AM6PR83MB0247.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z8rCP3i/Q5FG+QcNgNQLbWFurn0AngWoG/EtIx+th/2MEy5KvyYLhC6g7F6AbmsoNEPS5QOoejn+hf4z4roHS7WZcLE96svA04nYdiX1aXfwU7la8QPvCskxJO6w3WFDpkQ3ExhPArNSX6pvYekJaQAt2F0SsI0Iv5ivmBAhrkSfHWyOgeij+desfbNyMksyAW3muUpwcj8hLUggVWyT2rWxQ8gJXyJYehJeAwwnzdLpstQAoZoFS3F49p6WyMHeKjsom0W9nq5S8Ewk984IwY18rRyybs9wy5sWhSszuCusV+9Zd3s/KYdwL8rSzypvB08jI3z1WffG2Ttwze2+fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(136003)(376002)(396003)(5660300002)(316002)(71200400001)(186003)(83380400001)(6512007)(8936002)(110136005)(478600001)(86362001)(6486002)(4001150100001)(36756003)(2616005)(66946007)(6506007)(76116006)(66616009)(64756008)(66446008)(66476007)(66556008)(4744005)(26005)(8676002)(99936003)(4326008)(82950400001)(82960400001)(10290500003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HvpbPXn7PgoWfKd0HkEbL7ZEWBL7gABduoR/GbMjdIMuoxg3zntqL7KOWtI9p/0np2O1dUESr1XuCh3XZqq+8XmwRIa1mH5xmXHNXuzKJ8pF4IrJlvpkr7EfsquQQ3yGOAIBv88ZpXdnf1zMycLWsG52mejH2Y+SpoHMB37dBGLBo1NE2n7CmEaOOAUV3ueWbyCgcfOV/TFAwetBohK5R8FM+uS+KBf+M7SW5JyUoQpMsdmFfvgQmsNxZ7KjDztCMFbTG6Wvhbalkfcj8Y/9Ci2+SAB6lalTQGEHM0xHPNR804z3mmOs3W6wPpPJyEH8nioGC3sVcuBkubNEp2JNRYUUA5s5GkxaOIPpGlLJqvmFLCKjW2wzT0byhtvFkxIu520z1lSxGiLFH915FXgcmfHLxIq/ZGcTEDIu1F9Acpd3jOOhiYETb2bi3YgL3S1y3WxM1Gt8mAFjmgi2l3Baoj+TjB0qaEFdMT3sFugl+S1DGWLj6ohH93Bt3DPKfubzNB9jbk5WwlEnLeCHXsMRbImnb4mnIqZYnc5NNeTso7ELSPaKFfw/HBOcmiOj6oltTs3BbZMlpPZzb46zXTmYDynTRSxRvfq3gdeAJxQWQTMENhjiJc35cJMzHZbG58ad9gwmlTCPEMtGOamOI0eOBrJvpJiWV7k6T60RIgXdjxpVQmU4a+yhJvyx2r5uKhmQLTBhlI2FSLkonlxJfiW+GbZtDZZY79Nko/JsMxg2lDrg3uzvkOIWOWFdVwLsppwAHQqjA87FwuVlm/BGY+sUu1Hhi4hsRxZ9B3fFtnxdO9GrEE6aY4Uklai6ShtWzUP5HPB+UE55+yxuuksMxplk3MtLvF/zvlAjSiF/8ns0SeKWpqnJU3GFe5rfeJBq6WfN7Qk5WjRt7Z2Xtr/p0xcj7g==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-+4goCzlaPM7KBSPd1bln"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3474f0a8-2c0d-440e-b60c-08d88a2357b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:32:47.1036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLVhwgmukLmlAWNdg/dgh43qnaeVhAGh9+bQmrl2NRPz2YelqT7WJNFjFq1bEwD/517O2qhdLz6klGok965vXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR83MB0247
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-+4goCzlaPM7KBSPd1bln
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 16:15 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> The "digest", "enable", and "sign" commands all parse the --hash-alg,
> --block-size, and --salt options and initialize a struct
> libfsverity_merkle_tree_params, so share the code that does this.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  programs/cmd_digest.c | 31 ++++---------------------------
>  programs/cmd_enable.c | 30 ++++--------------------------
>  programs/cmd_sign.c   | 31 ++++---------------------------
>  programs/fsverity.c   | 42 ++++++++++++++++++++++++++++++++++++++----
>  programs/fsverity.h   | 19 +++++++++++++++----
>  5 files changed, 65 insertions(+), 88 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-+4goCzlaPM7KBSPd1bln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yY10ACgkQSylmgFB4
UWI78wf/b9cG6Uht/waSgqu4K9y57rb6dO+Pt8MRrieeN18ocyqQ8lEa5cmg3NeY
0MWwPYFAng2rDvrs07Q7oZsejs8Md9r41L+3ylDc/HKNEwv4J2FoNxo4ZjcmRZTh
EblvSzh5f5o2X2j6/D7RwTHpES8g8bZvM1sZT3SAH+WOATWZ/McT9ZLmFs5C7rZd
eIAkn2QwL9NoUjoCUlVOQ7zT5SFmdFDDT8Hjq5G95T8mnpBSjBmU7lADf3DmgGwy
vseVSXw8q3Kf0ktLp+9aMd5k9e99SeRcm7Y2bYaLHm/z0DOSGMJ/D9Wq+9jr51K1
NNJ12wys3YyHlNZxfAjYTmvjybqv4Q==
=jCOi
-----END PGP SIGNATURE-----

--=-+4goCzlaPM7KBSPd1bln--
