Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8C2B42CE
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgKPL1g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:27:36 -0500
Received: from mail-vi1eur05on2109.outbound.protection.outlook.com ([40.107.21.109]:3914
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729794AbgKPL1g (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:27:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsG5ymM++xsk9CKeQf+Kf7U0uuOqUCr87cOp6uTI2eiKLNH5DFAbnbYAYqAmAveZeqR+djUBuUqQUwl/WHWRnmKVSjDDm/TV7RBl85Sya3mo/6dcnAPVS1zmEmeR8nSNlfc/zM1VBRdXJDxVN8kLYQtlZ3g3IDizPaEr7CBy+taChBMk0joSKsec5kKxpkNbDQ7KtTK3NzGQVrPuM20EzG7bzPabIXZD9F1BjW7tIWEggXw0ixgmWwdi9EO/ZEtN+9QBlLiBIW5VImexMV9mnvx+DnnomRx1vwck50TOxfIVvNFcQUB9UD6kNnkwTXzhhr2j12/HwBsFyoEz1dYzQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NX10H6M44+kycPmS5JUSaf6DlJxbqLZ9OIqQZAeY8iI=;
 b=NB83GCD+CSOkrgVRIVrOmppO5IZcXykoDb7uEY16hx5+eMuvn9J34zxnKGtW4/eC+STdQ01xpnbqQKHfpefQ+XasB/jmIN1laS4w1lilkOoCmSscO3O4uqg7KzhyGp35kZKNEXwVVgM+/7mNGM+72vj3cjE9ae7aoAPaDEP0fPonYGZIP8TSbJxjIJXQJwvwQCZUUiEAeQTlECt5DUcvElLaU5p/k5ScqNQVrdm1fPSNdNhjGfD/OAOXCmXUkk5tHr/dxy8/N9fqTqViRCTG1etYTwX2oqQb3v+ni6aaKSnB3Z5mWhpu31QgCcMOwAE/qltnZVmVdINvWzA8iJxARg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NX10H6M44+kycPmS5JUSaf6DlJxbqLZ9OIqQZAeY8iI=;
 b=Nc3AqXyW5rLOici/1dag5vjE3yKyeAouSrMJ3FxUg3s5zWAYHdQA7qGA38f+eivSZOyqiwEc7Hs8vt4LUmMwjUSfyXhEp9gCGtExSdPiVO2g/RZJsKmKSF6KGdRaQN6OJwwE5v7W5tu/t2OZ8ONN8Hiq8IDzulGfnyfNazCC1XQ=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR8303MB0084.EURPRD83.prod.outlook.com (2603:10a6:224:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:27:32 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:27:32 +0000
From:   Luca Boccassi <Luca.Boccassi@microsoft.com>
To:     "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
CC:     "victorhsieh@google.com" <victorhsieh@google.com>,
        "Jes.Sorensen@gmail.com" <Jes.Sorensen@gmail.com>,
        "maco@android.com" <maco@android.com>,
        "paullawrence@google.com" <paullawrence@google.com>
Subject: Re: [fsverity-utils PATCH 1/2] Upgrade to latest fsverity_uapi.h
Thread-Topic: [fsverity-utils PATCH 1/2] Upgrade to latest fsverity_uapi.h
Thread-Index: AQHWvAt5+QxKV0u2YUewgLMkIcDIZg==
Date:   Mon, 16 Nov 2020 11:27:32 +0000
Message-ID: <0838e12100e6c4e42c6b8ad39abf4c7bb6fef83b.camel@microsoft.com>
References: <20201113213314.73616-1-ebiggers@kernel.org>
         <20201113213314.73616-2-ebiggers@kernel.org>
In-Reply-To: <20201113213314.73616-2-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: 79af6983-4516-44f6-5bb6-08d88a229c28
x-ms-traffictypediagnostic: AM5PR8303MB0084:
x-microsoft-antispam-prvs: <AM5PR8303MB0084C24B1ABEFBF17ACA816DF1E30@AM5PR8303MB0084.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sf60XMGas69Q7meTDuWxlG2bZMecCXfoc5rTLPDNnULUyk2kLo8ZYHYNKcvQl9eks98XZ2Fp+i18M3l2Xo2KcGmef8hrmVPnRdzsY5HBEn6R+92WczaZGdgQSXkfWq66UqMpUGmWdDT2c9F0iY7cGslWaychET9kE7s1tLz/hZr+y8EOZgPN0eyVsCqHZlDAlpPTO5A5asIcxtsZ/UDaJ6xqa+Y0VXFyPFhvm3QP7wBkQqafs6QLESZdWCFlt+dhNsXLCizIK3gKrOtH9x1nMhnRg3QUNOuCTBIHiwLX4eOCQOKjRTtJzyvvO7RlkpTGy2ggw5c016PhvrvRcuZ2eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(376002)(136003)(346002)(396003)(83380400001)(6512007)(64756008)(66476007)(4326008)(36756003)(316002)(76116006)(66946007)(71200400001)(66556008)(66616009)(66446008)(6486002)(8676002)(8936002)(186003)(4744005)(4001150100001)(26005)(82960400001)(99936003)(2906002)(82950400001)(6506007)(110136005)(54906003)(5660300002)(10290500003)(478600001)(86362001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +jyREs59/neOywT+uCnwFNEr4v2wZb54AbHRDXf1jqOBNRYDY0XGznR7DIM4fC77JndhHwgiZpoPxwAO/No8zf40cayWGiRGjd81tMvaHPBXyqnMsLYvBcbKV8vapRI1yv+1gaE220sG421XdX5z+pHpqyCgPtvmVdK7DSNPvoJTgAwcDljDD1sDcm7P6ZSEFH4LpduFvePaTNZo3DBkgIWIrCUiX49uJRsOSWQ+kgjilj2taintAtFgih++i0GgtsdbQ/IAv+qSrRW7ShC8BC853SUugyjoMwr3JGxuk0BUkQwQ5C2YFujJvjqfjm/yq3GWDalFCCZrJct2FCMa0+DoMP59yvdk1tD9QswvmXPeXXwSopD1MzPLiZU8CZkBgdteBMMmrYraWs7x2pnW9GyO34Li616unYfl+mzdZi9fBynmMKHhc934SWHAIK0PaBcr1Sb0IVy/sjKLsZ/rKagJCGaoMF+gqSzcSsuMW9Z6w+sufJQ3MFJNqSzDogEMWyy/ezenD7tlu+hATOEsP3OQQ37ogN5PGx5qLlGfvqkkkMUBAI0I8z9hYvBKFebLlp/dtbEqks34Tu1tiNyVIfIwWfYV87CWU/q30WKkt9Fk5kNbAwfwWyz76kF+QSpzoh4TR6MFy7yqcr+rUDLYszT5UcmFip7QNgdLH3BVh1/Zsvk2QiZV9Tl59L+sdzClIshXcgL21dixDJTXHz7CtsIFeGpcbpH1rtwNFR1nlWw+8EpBhUUwnTXEkECFIeEREUSVwwsUG94P36+9K6tpexWD8agwCjgajzQRfugbxJyDzmBSdVsXkvcfYGaPTk8Q0+IHGcGaBNDSJphOZBrLZqrYRPzsC88oqs5ctb59SLmCdIiqbl8llEvDGQRNeAC0cAn6a1seAYXwDy699q3P2g==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-xKwlgM2jmL4WxpUWxuEw"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79af6983-4516-44f6-5bb6-08d88a229c28
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:27:32.4857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r+UCLW9d553Vc7EwpsMu1uirDWCByBSZFs8zb024CjknUqS9m7oWOdpW3t9FzHNjXxCGi+NoVi3ci3ui/5uVTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR8303MB0084
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-xKwlgM2jmL4WxpUWxuEw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 13:33 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> The latest UAPI header includes the declarations of fsverity_descriptor
> and fsverity_formatted_digest (previously fsverity_signed_digest).
> Therefore they no longer need to be declared in other files.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  common/fsverity_uapi.h | 49 ++++++++++++++++++++++++++++++++++++++++++
>  lib/compute_digest.c   | 17 ---------------
>  lib/sign_digest.c      | 15 +------------
>  programs/cmd_digest.c  | 11 ++--------
>  4 files changed, 52 insertions(+), 40 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-xKwlgM2jmL4WxpUWxuEw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yYiMACgkQSylmgFB4
UWJalQf9F8kgsvtTmQvn7HPkR+mnpX+ffxUF5+tEOB3O0EG09kM2IcmAyF+wuaWS
1JjfSuMVFbg9/LcFSzxUvOwytOjFZ4Jvsku1V1LQZpTyYdefmoo2DFiGCV1tw4qb
Yv/YL8YhrRGNCRM0LxEkk3P1gVU6kGLra+AUD8S1ZksBHhx7EHjVixH/UhfUXjSJ
gFJDyLUqCDmxZoBp+/uQFD5JEVwvQSgGw2S1gDOCLWNBLSZRdfZtayhS5cnjSnnm
1OijscSDCq/GFuW0TTEDa/pwWFFGRL7QzTuWtNRn0endqxIxWeEtse6y14BPlYji
86FHZqlq9IKs/XHSafeC7SQHG1kw1A==
=tEHu
-----END PGP SIGNATURE-----

--=-xKwlgM2jmL4WxpUWxuEw--
