Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FED2B42C1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 12:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgKPLZQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 06:25:16 -0500
Received: from mail-vi1eur05on2107.outbound.protection.outlook.com ([40.107.21.107]:1792
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729749AbgKPLZQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 06:25:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQe91nRBowbTeVY1hVpvpFEPoUVY4V8i5TdnKC3/nVYEX0XIIczYCkRIye3zO8ceJ/AcICetyFCwXJN8YNPJ1pwBMM9nC4T27YEYmDoBJ4tN5O5/23MVGxmn+v3AOTDOOhNISL6jnbZtP7b8e0r00fOiDlU/hKLjkD+s55e2XfgOqp0JXYt8u3xp0QUk1Yl3rrlKJRajYu1IGmwVjYBPVkJwc1dlstfg+fbTuIX/iEOhSWroKS+tqBjHsc6BufUbXLp1VldU7c4X21LP7YjfVq1PCsiJgCNF3nSk7dbJKjaCecgKaEGhFx9FNK+jW2c68ZfslA1Cz+BG3lDqkcZyWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8d4VnW51cIPKLKm7exRdu/fQrKv8kBY3WQpCIm/FOA=;
 b=c6Fdoq30qyYKMzobMdT0jYP7K6wTr+mNkYMW6C87qJaGikmzS5fjFBcy/uWvc0vsdotbg0jc0nrZ3P3yZcF1ZgYUwH8hi85nyxfwjejJBS8EZvtaal6aST+Msa/gkg34HNcZloMz6gVepfSEpD6SPwcITb+RV5+hiziDHIKkVOQ1rbKMQuf0g0nAB04SN6bYbGqIo4G1t4g2sj4ocxX4StRJjT00kmoCh429WNfVPrqi5HAwhFzlZd0dUn2msSHF4Hxr4HaO2TVheGx5Xjr3ZAG2Wn+MPNup4f01cu8kwloomRQOkebTjHpLE1SVgIWHVPO+hvvwvklMNSvWp2k+CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8d4VnW51cIPKLKm7exRdu/fQrKv8kBY3WQpCIm/FOA=;
 b=hzVf8r69oKDwCV5RNpx3SgZhD7UuBRoFIC8r2aotJ+Ss4Mua+kEM0IMdtgSVAKADBzRCibeZzxqRIMuZOEGxo9CLTkcTfk1+0TjLl8ti1QjW5xdsglbHKWFA6+/4ar+QnqWeFjf6LLXz1qtiXcIZ+j3vyM4/TrHYWX69bfyays4=
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com (2603:10a6:206:25::31)
 by AM5PR8303MB0084.EURPRD83.prod.outlook.com (2603:10a6:224:6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.4; Mon, 16 Nov
 2020 11:25:12 +0000
Received: from AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d]) by AM5PR83MB0178.EURPRD83.prod.outlook.com
 ([fe80::3983:12a4:4f34:39d%5]) with mapi id 15.20.3611.004; Mon, 16 Nov 2020
 11:25:12 +0000
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
Subject: Re: [PATCH 4/4] fs-verity: move structs needed for file signing to
 UAPI header
Thread-Topic: [PATCH 4/4] fs-verity: move structs needed for file signing to
 UAPI header
Thread-Index: AQHWvAslCGiSvIVss0aTWS660pPV+w==
Date:   Mon, 16 Nov 2020 11:25:11 +0000
Message-ID: <1110494125be52ff267e3fb50d96756c04ac5ca5.camel@microsoft.com>
References: <20201113211918.71883-1-ebiggers@kernel.org>
         <20201113211918.71883-5-ebiggers@kernel.org>
In-Reply-To: <20201113211918.71883-5-ebiggers@kernel.org>
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
x-ms-office365-filtering-correlation-id: 8b0df3f0-05a1-4f0a-1d78-08d88a224858
x-ms-traffictypediagnostic: AM5PR8303MB0084:
x-microsoft-antispam-prvs: <AM5PR8303MB00847D3DB70FE5E5F4B4EC0EF1E30@AM5PR8303MB0084.EURPRD83.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IEjHgphXC+/LhsFbKwcF9ZZTs58r1nOmEogxXk5p1a6uoOCKc4/PJjRzKWENMeM0mLcHmSfhFBShB2fg0/NWR0JyQKkuza0zXdTNn/uzy2nz0g0DHu9mxgajTNc0hlw8zWxxo5CH3CNskf7y8vDjN7OBlH9OE98L28Ge4WtU/X3B7kwI4tfaia57JJ7l7FMhTXe8UNdI/r9KJf9YoijqzoF41K7XKQewDMT0Ytow2+Gh0pxdh89EF8VKxmUfslW3lQDamHXvHpL97GNkZpV+T0lSgp2r+S6y1SOUxNLZUWX27iQlqTeH2iAO+YoW9epggi4ryjVXrZChUA36iGiaJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR83MB0178.EURPRD83.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(376002)(366004)(39860400002)(82950400001)(82960400001)(99936003)(2906002)(6506007)(186003)(26005)(4001150100001)(478600001)(86362001)(2616005)(10290500003)(5660300002)(110136005)(54906003)(4326008)(66476007)(64756008)(36756003)(6512007)(83380400001)(6486002)(8676002)(8936002)(71200400001)(316002)(76116006)(66946007)(66556008)(66616009)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /djZSal3woMUZzEMZEA1Xsf6HL9axamHY+6x2tLOmGl/y5zCxieJESdk6s2njSrIZXgxl3JIKDfusKBWmo725zLKHwcDNASWVRLGPBlIXooOekP0AgfbuoJjzawThBvv/2Hylc2leUZe9hVdkwLUayICCs9aCCFV8vTs7MN5bSnPkkTgo/6+LKz3pd1v2jBf1WNPog33BLPKQXiToe2+qxaULQo61SeV8SoiegZFIlhvJ5a23VeyNs/wzXSdOVdHidOMsAp9bRAqkA3V2K0Osc3XHcVX7Ak63wregRiBSi4k8bEig0M2ksaOPGiUuJ4VG/gHxtvQeHX3ML+xf9xzDSgFiwQtl+iUKfm6CEpf0uLz6eGapOVcd2anCTvTYuNAaA535rTvxDLV1rs+RjvBEyPblax+GYGjQEt61+qbsVBVkbLWZ3KqFt4UC4uNL3c9sy3TAinagqwaIGp1hCHiiPkgFUtivERN91D9cMrXMTSHJdvMJULhl8S85T5Tn9pD969IQCEoJFsxYhEB+1pInMftFIiz/Alt0OlVuPdWkONMPeQwHtw64H7S/z9gRmAgvYGEl2xQmJDuqtHbZghUe5qN7CKMwsDRfqnDfQvpG2Wxy+oqcIProvrwl86qKPckDBvc0O6ITKqt2a9FzmqtPJbfvbbEQQD/dUXtVZu9uQoVCQreR9df8g+OsgPOKwYweZQLdJCnHrJFYHTygJRIJp8hzxgOSEqsdmqgaozDmTJXALJDOufqDFcl2V6r2xXIbgdt5FjcD2V4gGqn6ALjGN4hGMtx8PvIxg31aHI7jKlbU5cBRwkgXj9k06iniHNLQvODZozx+Itx+GJe75lLxIlnB9ERd8uNe3a+glMQDiZtTslAtMVtVSNc9VfrqFxidiL9K5exCx9hRca50e9MFw==
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-KYUhJpYVntrgAZst+MAw"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM5PR83MB0178.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0df3f0-05a1-4f0a-1d78-08d88a224858
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 11:25:11.8201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zmP6PJkhSGYj4eNAFTtVH8FiVds3W/ni/lQ1nuDLWUGAWBTcDS9M7Q+nLLMBFHHngu/XGFDbeK1Pj/VS9GBhwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR8303MB0084
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

--=-KYUhJpYVntrgAZst+MAw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-11-13 at 13:19 -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> Although it isn't used directly by the ioctls,
> "struct fsverity_descriptor" is required by userspace programs that need
> to compute fs-verity file digests in a standalone way.  Therefore
> it's also needed to sign files in a standalone way.
>=20
> Similarly, "struct fsverity_formatted_digest" (previously called
> "struct fsverity_signed_digest" which was misleading) is also needed to
> sign files if the built-in signature verification is being used.
>=20
> Therefore, move these structs to the UAPI header.
>=20
> While doing this, try to make it clear that the signature-related fields
> in fsverity_descriptor aren't used in the file digest computation.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fsverity.rst |  6 +---
>  fs/verity/fsverity_private.h           | 37 -------------------
>  include/uapi/linux/fsverity.h          | 49 ++++++++++++++++++++++++++
>  3 files changed, 50 insertions(+), 42 deletions(-)

Acked-by: Luca Boccassi <luca.boccassi@microsoft.com>

--=20
Kind regards,
Luca Boccassi

--=-KYUhJpYVntrgAZst+MAw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEyBAABCgAdFiEE6g0RLAGYhL9yp9G8SylmgFB4UWIFAl+yYZYACgkQSylmgFB4
UWI0cwf48uHoU+4rqlW//d3WHEb/08fFIfY9zzqURvG6K/oUJBJfRSWXFm/4UyWE
Wy98qwiEYSXVpdm0CtS5xcqo0zyG0rO+vK08ItLNZ7Zd/aEa5QY0quQnezcPHRZf
oW8rZNbQZ9ttd27MuhZO5WFEziSybUNXkPwt6XQRcNXN/q+DU54MoAqI5p7JdQNm
Oy4fGDeD/5FyQJArk/MCJOpGCTPfXFXriCiGsXcQYo+E9SdoM1KcqnhdSUjEUYwD
kEBS+QDtL04dLVu6pKMcnYsh0eGb18eGmY78AZJXioIIAZLlPBzxz/8EanMyNYm2
6K6oLcJyNzdUeelIHGp9HltJq5jf
=yiLw
-----END PGP SIGNATURE-----

--=-KYUhJpYVntrgAZst+MAw--
